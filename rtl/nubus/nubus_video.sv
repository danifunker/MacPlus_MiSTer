module nubus_video (
    input clk,
    input reset,

    // CPU Interface (NuBus Slot)
    input [31:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out,
    input [1:0] uds_lds, // {uds, lds} - 00=both, 01=lower, 10=upper
    input rw_n, // 1=read, 0=write
    input select, // Chip select
    output reg ack_n, // DTACK (Active Low)

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

    // Video Parameters
    parameter H_RES = 640;
    parameter V_RES = 480;

    // VRAM (Using BRAM)
    // 640x480 = 307200 bytes.
    // Mapped to 0x000000 in slot space.

    reg [7:0] vram [0:307199];

    // CLUT (Color Look-Up Table)
    reg [23:0] clut [0:255];

    // Registers
    reg [31:0] reg_palette_addr;
    reg [31:0] reg_palette_data_acc;
    reg [1:0]  palette_wr_cnt;

    // ROM Buffer (4KB)
    reg [7:0] rom [0:4095];

    // Fallback ROM Initialization
    initial begin
        // Initialize with 0
        integer i;
        for (i = 0; i < 4096; i = i + 1)
            rom[i] = 8'h00;

        // Minimal Declaration ROM content (Format Block and Directory)
        // Format Block at 0xFFFF (offset 4095)
        rom[4095] = 8'hE1; // ByteLanes
        rom[4094] = 8'h00; // Reserved
        rom[4093] = 8'hC7; // Test Pattern $5A932BC7 (LSB)
        rom[4092] = 8'h2B;
        rom[4091] = 8'h93;
        rom[4090] = 8'h5A; // MSB
        rom[4089] = 8'h01; // Format
        rom[4088] = 8'h01; // Revision
        rom[4087] = 8'h71; // CRC
        rom[4086] = 8'hE2;
        rom[4085] = 8'h01;
        rom[4084] = 8'h79;
        rom[4083] = 8'h00; // Length
        rom[4082] = 8'h00;
        rom[4081] = 8'h08;
        rom[4080] = 8'h24;

        // Directory Offset at 0xFFEF (offset 4079)
        // Offset = FFE0 - FFFF = -1F = FFFFFFE1 -> E1 FF FF 00 (big endian on wire?)
        // NuBus is big endian.
        // But offsets are 24-bit.
        // Stored as: Byte 0 (MSB? No, offset is signed 24-bit).
        // It's "sOffset" type.
        // Usually: [00] [Hi] [Mid] [Lo]
        rom[4079] = 8'hE1; // Lo
        rom[4078] = 8'hFF; // Mid
        rom[4077] = 8'hFF; // Hi
        rom[4076] = 8'h00; // unused/MSB of long

        // Directory at 0xFFE0 (offset 4064)
        // Entry 1: ID=1 (Board sRsrc), Offset to sRsrc list/data
        rom[4064] = 1;
        // ... incomplete minimal ROM, but safer than all zeros.
    end

    // ROM Download Logic
    // Index 4 is assigned to Toby ROM
    always @(posedge clk) begin
        if (ioctl_wr && ioctl_download && (ioctl_index == 8'd4)) begin
            // ioctl_addr is 25-bit word address if connected to dio_addr/dio_a
            // ROM is small (4KB = 2048 words).
            if (ioctl_addr < 2048) begin
                rom[{ioctl_addr[10:0], 1'b0}] <= ioctl_data[7:0];
                rom[{ioctl_addr[10:0], 1'b1}] <= ioctl_data[15:8];
            end
        end
    end

    // Video Timing Generator
    reg [10:0] h_cnt;
    reg [10:0] v_cnt;

    // Standard 640x480 @ 67Hz (Apple) Timing
    parameter H_TOTAL = 864;
    parameter H_SYNC_START = 640 + 64; // Front porch
    parameter H_SYNC_END = 640 + 64 + 64; // Sync width
    parameter V_TOTAL = 525;
    parameter V_SYNC_START = 480 + 3;
    parameter V_SYNC_END = 480 + 3 + 3;

    assign vga_hs = ~(h_cnt >= H_SYNC_START && h_cnt < H_SYNC_END);
    assign vga_vs = ~(v_cnt >= V_SYNC_START && v_cnt < V_SYNC_END);
    assign vga_blank = (h_cnt >= H_RES) || (v_cnt >= V_RES);
    assign vga_clk = clk;

    // Video Scanning
    always @(posedge clk) begin
        if (reset) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 0;
                if (v_cnt == V_TOTAL - 1) begin
                    v_cnt <= 0;
                end else begin
                    v_cnt <= v_cnt + 1;
                end
            end else begin
                h_cnt <= h_cnt + 1;
            end
        end
    end

    // Video Output
    reg [7:0] pixel_data;
    always @(posedge clk) begin
        if (!vga_blank) begin
            pixel_data <= vram[v_cnt * 640 + h_cnt];
        end else begin
            pixel_data <= 0;
        end
    end

    assign vga_r = clut[pixel_data][23:16];
    assign vga_g = clut[pixel_data][15:8];
    assign vga_b = clut[pixel_data][7:0];

    // NuBus Interface Logic
    always @(posedge clk) begin
        if (reset) begin
            ack_n <= 1;
            palette_wr_cnt <= 0;
        end else if (select) begin // Active Select
            if (ack_n) begin // First cycle of access
                ack_n <= 0; // Assert ACK

                if (!rw_n) begin // Write
                    if (addr[23:20] < 4'h2) begin // VRAM range 0x000000-0x1FFFFF
                        if (uds_lds[1] == 0) // Upper byte (even addr)
                            vram[addr[23:0] & 32'h0007_FFFF] <= data_in[15:8];
                        if (uds_lds[0] == 0) // Lower byte (odd addr)
                            vram[(addr[23:0] | 1) & 32'h0007_FFFF] <= data_in[7:0];
                    end

                    // Registers (Based on MDC12.rs)
                    else if (addr[23:16] == 8'h20) begin
                        case (addr[15:0])
                            // Palette Address
                            16'h0200: begin
                                reg_palette_addr <= {24'b0, data_in[7:0]};
                                palette_wr_cnt <= 0;
                            end

                            // Palette Data
                            16'h0207: begin // Data write (Accumulate RGB)
                                if (palette_wr_cnt == 0) begin
                                    reg_palette_data_acc[23:16] <= data_in[7:0]; // Red
                                    palette_wr_cnt <= 1;
                                end else if (palette_wr_cnt == 1) begin
                                    reg_palette_data_acc[15:8] <= data_in[7:0]; // Green
                                    palette_wr_cnt <= 2;
                                end else begin
                                    reg_palette_data_acc[7:0] <= data_in[7:0]; // Blue
                                    clut[reg_palette_addr[7:0]] <= {reg_palette_data_acc[23:8], data_in[7:0]};
                                    reg_palette_addr <= reg_palette_addr + 1;
                                    palette_wr_cnt <= 0;
                                end
                            end
                        endcase
                    end
                end else begin // Read
                    data_out <= 0;

                    if (addr[23:20] < 4'h2) begin // VRAM
                        data_out[15:8] <= vram[addr[23:0] & 32'h0007_FFFF];
                        data_out[7:0]  <= vram[(addr[23:0] | 1) & 32'h0007_FFFF];
                    end

                    // ROM (at top of slot space)
                    // FsFF FFFF
                    // 4KB ROM at 0xFFF000 - 0xFFFFFF offset
                    else if (addr[23:12] == 12'hFFF) begin
                        // Byte lane 3 (bits 7:0) for 32-bit card
                        data_out <= {8'h00, rom[addr[11:0]]};
                    end
                end
            end
            // Keep ack_n low while select is high (hold behavior)
        end else begin
            ack_n <= 1;
        end
    end

endmodule
