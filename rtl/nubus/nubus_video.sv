module nubus_video (
    input clk,
    input reset,

    // CPU Interface (NuBus Slot)
    input [31:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out,
    input [1:0] uds_lds, // {uds, lds} - 1=active
    input rw_n, // 1=read, 0=write
    input select, // Chip select
    output reg ack_n, // DTACK (Active Low)
    output reg nmrq_n, // Interrupt Request (Active Low)

    // Video Output
    output [7:0] vga_r,
    output [7:0] vga_g,
    output [7:0] vga_b,
    output vga_hs,
    output vga_vs,
    output vga_blank,
    output vga_clk,

    // IOCTL Interface for ROM Download
    input        ioctl_wr,
    input [24:0] ioctl_addr,
    input [15:0] ioctl_data, // 16-bit data from HPS
    input        ioctl_download,
    input [7:0]  ioctl_index // Expecting Index 4 for Video ROM
);

    // Video Parameters (Standard 640x480 @ 66.67Hz)
    parameter H_RES = 640;
    parameter V_RES = 480;

    parameter H_TOTAL = 864;
    parameter H_SYNC_START = 640 + 64;
    parameter H_SYNC_END = 640 + 64 + 64;
    parameter V_TOTAL = 525;
    parameter V_SYNC_START = 480 + 3;
    parameter V_SYNC_END = 480 + 3 + 3;

    // VRAM (300KB - Exact 640x480)
    // Reducing from 512KB to save resources and prevent compilation hang.
    (* ramstyle = "no_rw_check, M10K" *) reg [7:0] vram [0:307199];

    // CLUT (Color Look-Up Table) - 256 entries x 24 bits
    reg [23:0] clut [0:255];

    // ROM Buffer (32KB)
    reg [7:0] rom [0:32767];

    // Registers
    reg [7:0] reg_control;       // 0x080000
    reg [7:0] reg_pixel_mask;    // 0x080018
    reg [7:0] reg_clut_addr_wr;  // 0x080010
    (* keep *) reg [7:0] reg_clut_addr_rd;  // 0x08001C
    reg [1:0] clut_seq_cnt;      // 0=Red, 1=Green, 2=Blue
    reg [23:0] clut_temp_data;   // Temp storage for RGB

    // Interrupt State
    reg irq_active;
    reg irq_clear;

    // Bit Depth decoding from Control Register
    // Using bits 5:4 as standard Toby/RBV mode bits
    // 00=1bpp, 01=2bpp, 10=4bpp, 11=8bpp
    wire [1:0] mode = reg_control[5:4];
    wire video_en = reg_control[7];
    // wire sync_green = reg_control[6]; // Unused
    wire irq_en = reg_control[0];

    // Video Counters
    reg [10:0] h_cnt;
    reg [10:0] v_cnt;

    // Pipelined Syncs to match BRAM latency (1 cycle)
    reg vga_hs_reg, vga_vs_reg, vga_blank_reg;

    always @(posedge clk) begin
        if (reset) begin
            vga_hs_reg <= 1;
            vga_vs_reg <= 1;
            vga_blank_reg <= 1;
        end else begin
            vga_hs_reg <= ~(h_cnt >= H_SYNC_START && h_cnt < H_SYNC_END);
            vga_vs_reg <= ~(v_cnt >= V_SYNC_START && v_cnt < V_SYNC_END);
            vga_blank_reg <= (h_cnt >= H_RES) || (v_cnt >= V_RES) || !video_en;
        end
    end

    assign vga_hs = vga_hs_reg;
    assign vga_vs = vga_vs_reg;
    assign vga_blank = vga_blank_reg;
    assign vga_clk = clk;

    // Interrupt Generation (VBL)
    // Trigger on start of VBL (v_cnt == V_RES)
    reg vbl_pulse;
    always @(posedge clk) begin
        if (reset) begin
            h_cnt <= 0;
            v_cnt <= 0;
            vbl_pulse <= 0;
        end else begin
            vbl_pulse <= 0;
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 0;
                if (v_cnt == V_TOTAL - 1) begin
                    v_cnt <= 0;
                end else begin
                    v_cnt <= v_cnt + 1;
                    if (v_cnt == V_RES - 1) // Next is V_RES (Start of VBlank)
                        vbl_pulse <= 1;
                end
            end else begin
                h_cnt <= h_cnt + 1;
            end
        end
    end

    // Interrupt Logic
    always @(posedge clk) begin
        if (reset) begin
            irq_active <= 0;
            nmrq_n <= 1;
        end else begin
            // Set IRQ on VBL if enabled
            if (vbl_pulse && irq_en)
                irq_active <= 1;

            // Clear IRQ on write to 0x080004
            if (irq_clear)
                irq_active <= 0;

            nmrq_n <= ~irq_active;
        end
    end

    // Video Output Logic
    reg [7:0] vram_byte;
    reg [7:0] pixel_idx;

    // Calculate VRAM address based on x, y and mode
    reg [19:0] fetch_addr;

    always @(*) begin
        case (mode)
            2'b00: fetch_addr = (v_cnt * 80) + (h_cnt >> 3);
            2'b01: fetch_addr = (v_cnt * 160) + (h_cnt >> 2);
            2'b10: fetch_addr = (v_cnt * 320) + (h_cnt >> 1);
            2'b11: fetch_addr = (v_cnt * 640) + h_cnt;
        endcase
    end

    // Fetch VRAM
    always @(posedge clk) begin
        vram_byte <= vram[fetch_addr];
    end

    // Pipelined h_cnt for pixel extraction
    reg [2:0] h_cnt_d;
    always @(posedge clk) begin
        h_cnt_d <= h_cnt[2:0];
    end

    // Extract Pixel Index using delayed count
    always @(*) begin
        case (mode)
            2'b00: // 1bpp (8 pixels/byte) - Bit 7 is leftmost
                pixel_idx = {7'b0, vram_byte[7 - h_cnt_d]};

            2'b01: // 2bpp (4 pixels/byte) - Bits 7:6 first
                case (h_cnt_d[1:0])
                    2'b00: pixel_idx = {6'b0, vram_byte[7:6]};
                    2'b01: pixel_idx = {6'b0, vram_byte[5:4]};
                    2'b10: pixel_idx = {6'b0, vram_byte[3:2]};
                    2'b11: pixel_idx = {6'b0, vram_byte[1:0]};
                endcase

            2'b10: // 4bpp (2 pixels/byte) - Bits 7:4 first
                case (h_cnt_d[0])
                    1'b0: pixel_idx = {4'b0, vram_byte[7:4]};
                    1'b1: pixel_idx = {4'b0, vram_byte[3:0]};
                endcase

            2'b11: // 8bpp
                pixel_idx = vram_byte;
        endcase
    end

    // Apply Pixel Mask and Lookup CLUT
    wire [7:0] masked_idx = pixel_idx & reg_pixel_mask;

    // Output RGB (with blanking from pipelined signal)
    assign vga_r = vga_blank ? 8'h00 : clut[masked_idx][23:16];
    assign vga_g = vga_blank ? 8'h00 : clut[masked_idx][15:8];
    assign vga_b = vga_blank ? 8'h00 : clut[masked_idx][7:0];

    // ROM Download
    always @(posedge clk) begin
        if (ioctl_wr && ioctl_download && (ioctl_index == 8'd4)) begin
            if (ioctl_addr < 16384) begin
                rom[{ioctl_addr[13:0], 1'b0}] <= ioctl_data[7:0];
                rom[{ioctl_addr[13:0], 1'b1}] <= ioctl_data[15:8];
            end
        end
    end

    // NuBus Interface
    wire [18:0] vram_offset = addr[18:0]; // 512KB space address

    always @(posedge clk) begin
        irq_clear <= 0;

        if (reset) begin
            ack_n <= 1;
            reg_control <= 0; // Default 1bpp, Blank
            reg_pixel_mask <= 8'hFF;
            reg_clut_addr_wr <= 0;
            reg_clut_addr_rd <= 0;
            clut_seq_cnt <= 0;
        end else if (select) begin
            if (ack_n) begin
                ack_n <= 0; // Assert ACK

                // Write Access
                if (!rw_n) begin
                    // VRAM: 0x000000 - 0x07FFFF (512KB space)
                    if (addr[23:19] == 5'b00000) begin
                        // Check bounds for reduced VRAM size
                        if (uds_lds[1] && (vram_offset < 307200))
                            vram[vram_offset] <= data_in[15:8];

                        if (uds_lds[0] && ((vram_offset | 1) < 307200))
                            vram[vram_offset | 1] <= data_in[7:0];
                    end

                    // Registers: 0x08xxxx
                    else if (addr[23:16] == 8'h08) begin
                        case (addr[15:0])
                            // TFB Control: 0x080000
                            16'h0000: if (uds_lds[1]) reg_control <= data_in[15:8];

                            // IRQ Ack: 0x080004
                            16'h0004: if (uds_lds[1]) irq_clear <= 1;

                            // CLUT Write Address: 0x080010
                            16'h0010: if (uds_lds[1]) begin
                                reg_clut_addr_wr <= data_in[15:8];
                                clut_seq_cnt <= 0;
                            end

                            // CLUT Data: 0x080014
                            16'h0014: if (uds_lds[1]) begin
                                case (clut_seq_cnt)
                                    0: begin // Red
                                        clut_temp_data[23:16] <= data_in[15:8];
                                        clut_seq_cnt <= 1;
                                    end
                                    1: begin // Green
                                        clut_temp_data[15:8] <= data_in[15:8];
                                        clut_seq_cnt <= 2;
                                    end
                                    2: begin // Blue
                                        clut[reg_clut_addr_wr] <= {clut_temp_data[23:16], clut_temp_data[15:8], data_in[15:8]};
                                        reg_clut_addr_wr <= reg_clut_addr_wr + 1;
                                        clut_seq_cnt <= 0;
                                    end
                                endcase
                            end

                            // Pixel Mask: 0x080018
                            16'h0018: if (uds_lds[1]) reg_pixel_mask <= data_in[15:8];

                            // CLUT Read Address: 0x08001C
                            16'h001C: if (uds_lds[1]) begin
                                reg_clut_addr_rd <= data_in[15:8];
                            end
                        endcase
                    end
                end

                // Read Access
                else begin
                    data_out <= 0;

                    // VRAM
                    if (addr[23:19] == 5'b00000) begin
                         if (uds_lds[1] && (vram_offset < 307200))
                            data_out[15:8] <= vram[vram_offset];

                         if (uds_lds[0] && ((vram_offset | 1) < 307200))
                            data_out[7:0]  <= vram[vram_offset | 1];
                    end

                    // Registers
                    else if (addr[23:16] == 8'h08) begin
                         case (addr[15:0])
                            // Monitor Sense: 0x080008
                            16'h0008: data_out[15:8] <= 8'b00000011;

                            // Pixel Mask: 0x080018
                            16'h0018: data_out[15:8] <= reg_pixel_mask;
                         endcase
                    end

                    // ROM: 0xF00000 - 0xFFFFFF (Mapped to 32KB at top)
                    else if (addr[23:20] == 4'hF) begin
                        data_out[15:8] <= rom[addr[14:0]];
                        data_out[7:0] <= rom[addr[14:0]];
                    end
                end
            end
        end else begin
            ack_n <= 1;
        end
    end

endmodule
