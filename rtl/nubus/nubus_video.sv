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
    // 16-bit width to allow Byte Enable inference
    // 307200 bytes = 153600 words
    (* ramstyle = "no_rw_check, M10K" *) reg [15:0] vram [0:153599];

    // CLUT (Color Look-Up Table) - 256 entries x 24 bits
    reg [23:0] clut [0:255];

    // ROM Buffer (32KB)
    reg [7:0] rom [0:32767];

    // Registers
    reg [7:0] reg_control;       // 0x080000
    reg [7:0] reg_pixel_mask;    // 0x080018
    reg [7:0] reg_clut_addr_wr;  // 0x080010
    reg [7:0] reg_clut_addr_rd;  // 0x08001C
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
    reg vbl_pulse;
    always @(posedge clk) begin
        if (reset) begin
            h_cnt <= 11'd0;
            v_cnt <= 11'd0;
            vbl_pulse <= 0;
        end else begin
            vbl_pulse <= 0;
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 11'd0;
                if (v_cnt == V_TOTAL - 1) begin
                    v_cnt <= 11'd0;
                end else begin
                    v_cnt <= v_cnt + 11'd1;
                    if (v_cnt == V_RES - 1) // Next is V_RES (Start of VBlank)
                        vbl_pulse <= 1;
                end
            end else begin
                h_cnt <= h_cnt + 11'd1;
            end
        end
    end

    // Interrupt Logic
    always @(posedge clk) begin
        if (reset) begin
            irq_active <= 0;
            nmrq_n <= 1;
        end else begin
            if (vbl_pulse && irq_en)
                irq_active <= 1;

            if (irq_clear)
                irq_active <= 0;

            nmrq_n <= ~irq_active;
        end
    end

    // Video Output Logic
    reg [17:0] fetch_addr;
    reg byte_sel;

    always @(*) begin
        case (mode)
            2'b00: begin // 1bpp
                // (v * 40) + (h >> 4)
                fetch_addr = (v_cnt * 40) + (h_cnt >> 4);
                byte_sel = (h_cnt[3] == 0) ? 0 : 1;
            end
            2'b01: begin // 2bpp
                // (v * 80) + (h >> 3)
                fetch_addr = (v_cnt * 80) + (h_cnt >> 3);
                byte_sel = (h_cnt[2] == 0) ? 0 : 1;
            end
            2'b10: begin // 4bpp
                // (v * 160) + (h >> 2)
                fetch_addr = (v_cnt * 160) + (h_cnt >> 2);
                byte_sel = (h_cnt[1] == 0) ? 0 : 1;
            end
            2'b11: begin // 8bpp
                // (v * 320) + (h >> 1)
                fetch_addr = (v_cnt * 320) + (h_cnt >> 1);
                byte_sel = (h_cnt[0] == 0) ? 0 : 1;
            end
        endcase
    end

    // Fetch VRAM (Word)
    reg [15:0] vram_word;
    always @(posedge clk) begin
        vram_word <= vram[fetch_addr];
    end

    // Delayed byte select
    reg byte_sel_d;
    always @(posedge clk) begin
        byte_sel_d <= byte_sel;
    end

    // Select Byte
    wire [7:0] vram_byte = (byte_sel_d == 0) ? vram_word[15:8] : vram_word[7:0];

    // Pipelined h_cnt for pixel extraction
    reg [2:0] h_cnt_d;
    always @(posedge clk) begin
        h_cnt_d <= h_cnt[2:0];
    end

    reg [7:0] pixel_idx;
    // Extract Pixel Index
    always @(*) begin
        case (mode)
            2'b00: // 1bpp
                pixel_idx = {7'b0, vram_byte[7 - h_cnt_d]};

            2'b01: // 2bpp
                case (h_cnt_d[1:0])
                    2'b00: pixel_idx = {6'b0, vram_byte[7:6]};
                    2'b01: pixel_idx = {6'b0, vram_byte[5:4]};
                    2'b10: pixel_idx = {6'b0, vram_byte[3:2]};
                    2'b11: pixel_idx = {6'b0, vram_byte[1:0]};
                endcase

            2'b10: // 4bpp
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
    wire [17:0] vram_word_addr = addr[18:1];

    always @(posedge clk) begin
        irq_clear <= 0;

        if (reset) begin
            ack_n <= 1;
            reg_control <= 0;
            reg_pixel_mask <= 8'hFF;
            reg_clut_addr_wr <= 0;
            reg_clut_addr_rd <= 0;
            clut_seq_cnt <= 0;
        end else if (select) begin
            if (ack_n) begin
                ack_n <= 0; // Assert ACK

                if (!rw_n) begin // Write
                    // VRAM
                    if (addr[23:19] == 5'b00000) begin
                        if (vram_word_addr < 153600) begin
                            if (uds_lds[1]) vram[vram_word_addr][15:8] <= data_in[15:8];
                            if (uds_lds[0]) vram[vram_word_addr][7:0]  <= data_in[7:0];
                        end
                    end
                    // Registers
                    else if (addr[23:16] == 8'h08) begin
                        case (addr[15:0])
                            16'h0000: if (uds_lds[1]) reg_control <= data_in[15:8];
                            16'h0004: if (uds_lds[1]) irq_clear <= 1;
                            16'h0010: if (uds_lds[1]) begin
                                reg_clut_addr_wr <= data_in[15:8];
                                clut_seq_cnt <= 0;
                            end
                            16'h0014: if (uds_lds[1]) begin
                                case (clut_seq_cnt)
                                    0: begin clut_temp_data[23:16] <= data_in[15:8]; clut_seq_cnt <= 1; end
                                    1: begin clut_temp_data[15:8]  <= data_in[15:8]; clut_seq_cnt <= 2; end
                                    2: begin
                                        clut[reg_clut_addr_wr] <= {clut_temp_data[23:16], clut_temp_data[15:8], data_in[15:8]};
                                        reg_clut_addr_wr <= reg_clut_addr_wr + 1;
                                        clut_seq_cnt <= 0;
                                    end
                                endcase
                            end
                            16'h0018: if (uds_lds[1]) reg_pixel_mask <= data_in[15:8];
                            16'h001C: if (uds_lds[1]) reg_clut_addr_rd <= data_in[15:8];
                        endcase
                    end
                end else begin // Read
                    data_out <= 0;

                    // VRAM
                    if (addr[23:19] == 5'b00000) begin
                         if (vram_word_addr < 153600)
                            data_out <= vram[vram_word_addr];
                    end
                    // Registers
                    else if (addr[23:16] == 8'h08) begin
                         case (addr[15:0])
                            16'h0008: data_out[15:8] <= 8'b00000011;
                            16'h0018: data_out[15:8] <= reg_pixel_mask;
                            // Readback for CLUT Read Address to suppress unused warning
                            16'h001C: data_out[15:8] <= reg_clut_addr_rd;
                         endcase
                    end
                    // ROM
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
