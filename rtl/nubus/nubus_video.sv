module nubus_video (
    input clk,
    input reset,

    // CPU Interface (NuBus Slot)
    input [31:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out,
    input [1:0] uds_lds,
    input rw_n,
    input select,
    output reg ack_n,
    output reg nmrq_n,

    // Video Output
    output [7:0] vga_r,
    output [7:0] vga_g,
    output [7:0] vga_b,
    output vga_hs,
    output vga_vs,
    output vga_blank,
    output vga_clk,

    // SDRAM Interface for VRAM
    output reg [24:0] vram_addr,
    output reg [15:0] vram_dout,
    input [15:0] vram_din,
    output reg vram_rd,
    output reg vram_wr,
    input vram_ready,

    // IOCTL Interface for ROM Download
    input        ioctl_wr,
    input [24:0] ioctl_addr,
    input [15:0] ioctl_data,
    input        ioctl_download,
    input [7:0]  ioctl_index
);

    // Video Parameters
    localparam H_RES = 640;
    localparam V_RES = 480;
    localparam H_TOTAL = 864;
    localparam H_SYNC_START = 640 + 64;
    localparam H_SYNC_END = 640 + 64 + 64;
    localparam V_TOTAL = 525;
    localparam V_SYNC_START = 480 + 3;
    localparam V_SYNC_END = 480 + 3 + 3;

    // CLUT - Keep on-chip
    reg [23:0] clut [0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            clut[i] = {i[7:0], i[7:0], i[7:0]};
        end
    end

    // ROM Buffer - Keep on-chip
    reg [7:0] rom [0:32767];

    // Registers
    reg [7:0] reg_control;
    reg [7:0] reg_pixel_mask;
    reg [7:0] reg_clut_addr_wr;
    reg [7:0] reg_clut_addr_rd;
    reg [1:0] clut_seq_cnt;
    reg [23:0] clut_temp_data;
    reg irq_active;
    reg irq_clear;

    wire [1:0] mode = reg_control[5:4];
    wire video_en = reg_control[7];
    wire irq_en = reg_control[0];

    // Video Counters
    reg [10:0] h_cnt;
    reg [10:0] v_cnt;
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

    // VBL Interrupt
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
                    if (v_cnt == V_RES - 1)
                        vbl_pulse <= 1;
                end
            end else begin
                h_cnt <= h_cnt + 11'd1;
            end
        end
    end

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

    // Video fetch address - fix width issue
    wire [15:0] v_shift5 = {v_cnt[9:0], 5'd0};
    wire [13:0] v_shift3 = {v_cnt[9:0], 3'd0};
    wire [17:0] v_times_40 = {2'd0, v_shift5} + {4'd0, v_shift3};
    
    wire [16:0] v_shift6 = {v_cnt[8:0], 6'd0};
    wire [14:0] v_shift4 = {v_cnt[8:0], 4'd0};
    wire [17:0] v_times_80 = {1'd0, v_shift6} + {3'd0, v_shift4};
    
    wire [17:0] v_times_160 = {v_cnt[7:0], 7'd0} + {2'd0, v_cnt[7:0], 5'd0};
    wire [17:0] v_times_320 = {v_cnt[6:0], 8'd0} + {1'd0, v_cnt[6:0], 6'd0};
    
    wire [17:0] fetch_addr = 
        (mode == 2'b00) ? (v_times_40 + {7'd0, h_cnt[10:4]}) :
        (mode == 2'b01) ? (v_times_80 + {8'd0, h_cnt[10:3]}) :
        (mode == 2'b10) ? (v_times_160 + {9'd0, h_cnt[10:2]}) :
                          (v_times_320 + {10'd0, h_cnt[10:1]});

    // Unified state machine
    reg [15:0] vram_cache;
    reg vram_cache_valid;
    reg [3:0] state;
    reg [17:0] last_fetch_addr;
    wire [17:0] cpu_vram_addr = addr[18:1];
    
    localparam S_IDLE = 0;
    localparam S_VIDEO_FETCH = 1;
    localparam S_VIDEO_WAIT = 2;
    localparam S_CPU_WRITE = 3;
    localparam S_CPU_WRITE_WAIT = 4;
    localparam S_CPU_READ = 5;
    localparam S_CPU_READ_WAIT = 6;
    
    // ROM Download
    always @(posedge clk) begin
        if (ioctl_wr && ioctl_download && (ioctl_index == 8'd4)) begin
            if (ioctl_addr < 16384) begin
                rom[{ioctl_addr[13:0], 1'b0}] <= ioctl_data[7:0];
                rom[{ioctl_addr[13:0], 1'b1}] <= ioctl_data[15:8];
            end
        end
    end
    
    // Main state machine - single driver for all outputs
    always @(posedge clk) begin
        irq_clear <= 0;
        
        if (reset) begin
            state <= S_IDLE;
            vram_rd <= 0;
            vram_wr <= 0;
            vram_addr <= 25'd0;
            vram_dout <= 16'd0;
            vram_cache_valid <= 0;
            last_fetch_addr <= 18'h3FFFF;
            ack_n <= 1;
            data_out <= 16'd0;
            reg_control <= 0;
            reg_pixel_mask <= 8'hFF;
            reg_clut_addr_wr <= 0;
            reg_clut_addr_rd <= 0;
            clut_seq_cnt <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    vram_rd <= 0;
                    vram_wr <= 0;
                    
                    // Priority: CPU accesses, then video fetch
                    if (select && ack_n) begin
                        if (!rw_n && addr[23:19] == 5'b00000) begin
                            // CPU VRAM write
                            if (cpu_vram_addr < 153600) begin
                                vram_addr <= {7'd0, cpu_vram_addr};
                                vram_dout <= data_in;
                                state <= S_CPU_WRITE;
                            end else begin
                                ack_n <= 0;
                            end
                        end else if (rw_n && addr[23:19] == 5'b00000) begin
                            // CPU VRAM read
                            if (cpu_vram_addr < 153600) begin
                                vram_addr <= {7'd0, cpu_vram_addr};
                                state <= S_CPU_READ;
                            end else begin
                                data_out <= 16'd0;
                                ack_n <= 0;
                            end
                        end else if (!rw_n && addr[23:16] == 8'h08) begin
                            // Register write
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
                                        1: begin clut_temp_data[15:8] <= data_in[15:8]; clut_seq_cnt <= 2; end
                                        2: begin
                                            clut[reg_clut_addr_wr] <= {clut_temp_data[23:16], clut_temp_data[15:8], data_in[15:8]};
                                            reg_clut_addr_wr <= reg_clut_addr_wr + 8'd1;
                                            clut_seq_cnt <= 0;
                                        end
                                    endcase
                                end
                                16'h0018: if (uds_lds[1]) reg_pixel_mask <= data_in[15:8];
                                16'h001C: if (uds_lds[1]) reg_clut_addr_rd <= data_in[15:8];
                            endcase
                            ack_n <= 0;
                        end else if (rw_n && addr[23:16] == 8'h08) begin
                            // Register read
                            data_out <= 16'd0;
                            case (addr[15:0])
                                16'h0008: data_out[15:8] <= 8'b00000011;
                                16'h0018: data_out[15:8] <= reg_pixel_mask;
                                16'h001C: data_out[15:8] <= reg_clut_addr_rd;
                            endcase
                            ack_n <= 0;
                        end else if (rw_n && addr[23:20] == 4'hF) begin
                            // ROM read
                            if (addr[14:0] < 15'd32768) begin
                                data_out[15:8] <= rom[{addr[14:1], 1'b0}];
                                data_out[7:0] <= rom[{addr[14:1], 1'b1}];
                            end else begin
                                data_out <= 16'd0;
                            end
                            ack_n <= 0;
                        end else begin
                            data_out <= 16'd0;
                            ack_n <= 0;
                        end
                    end else if (!select) begin
                        ack_n <= 1;
                    end else if (fetch_addr != last_fetch_addr && fetch_addr < 153600) begin
                        // Video fetch when CPU not accessing
                        vram_addr <= {7'd0, fetch_addr};
                        state <= S_VIDEO_FETCH;
                    end
                end
                
                S_VIDEO_FETCH: begin
                    vram_rd <= 1;
                    vram_cache_valid <= 0;
                    state <= S_VIDEO_WAIT;
                end
                
                S_VIDEO_WAIT: begin
                    if (vram_ready) begin
                        vram_cache <= vram_din;
                        vram_cache_valid <= 1;
                        last_fetch_addr <= fetch_addr;
                        vram_rd <= 0;
                        state <= S_IDLE;
                    end
                end
                
                S_CPU_WRITE: begin
                    vram_wr <= 1;
                    state <= S_CPU_WRITE_WAIT;
                end
                
                S_CPU_WRITE_WAIT: begin
                    if (vram_ready) begin
                        vram_wr <= 0;
                        ack_n <= 0;
                        state <= S_IDLE;
                    end
                end
                
                S_CPU_READ: begin
                    vram_rd <= 1;
                    state <= S_CPU_READ_WAIT;
                end
                
                S_CPU_READ_WAIT: begin
                    if (vram_ready) begin
                        data_out <= vram_din;
                        vram_rd <= 0;
                        ack_n <= 0;
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end

    // Pixel output
    reg [2:0] h_cnt_d;
    reg byte_sel_d;
    
    always @(posedge clk) begin
        h_cnt_d <= h_cnt[2:0];
        byte_sel_d <= (mode == 2'b00) ? h_cnt[3] : 
                      (mode == 2'b01) ? h_cnt[2] :
                      (mode == 2'b10) ? h_cnt[1] : h_cnt[0];
    end
    
    wire [7:0] vram_byte = byte_sel_d ? vram_cache[7:0] : vram_cache[15:8];
    
    reg [7:0] pixel_idx;
    always @(*) begin
        case (mode)
            2'b00: begin
                case (h_cnt_d)
                    3'd0: pixel_idx = {7'b0, vram_byte[7]};
                    3'd1: pixel_idx = {7'b0, vram_byte[6]};
                    3'd2: pixel_idx = {7'b0, vram_byte[5]};
                    3'd3: pixel_idx = {7'b0, vram_byte[4]};
                    3'd4: pixel_idx = {7'b0, vram_byte[3]};
                    3'd5: pixel_idx = {7'b0, vram_byte[2]};
                    3'd6: pixel_idx = {7'b0, vram_byte[1]};
                    3'd7: pixel_idx = {7'b0, vram_byte[0]};
                endcase
            end
            2'b01: begin
                case (h_cnt_d[1:0])
                    2'b00: pixel_idx = {6'b0, vram_byte[7:6]};
                    2'b01: pixel_idx = {6'b0, vram_byte[5:4]};
                    2'b10: pixel_idx = {6'b0, vram_byte[3:2]};
                    2'b11: pixel_idx = {6'b0, vram_byte[1:0]};
                endcase
            end
            2'b10: pixel_idx = h_cnt_d[0] ? {4'b0, vram_byte[3:0]} : {4'b0, vram_byte[7:4]};
            2'b11: pixel_idx = vram_byte;
        endcase
    end

    wire [7:0] masked_idx = pixel_idx & reg_pixel_mask;
    assign vga_r = (vga_blank || !vram_cache_valid) ? 8'h00 : clut[masked_idx][23:16];
    assign vga_g = (vga_blank || !vram_cache_valid) ? 8'h00 : clut[masked_idx][15:8];
    assign vga_b = (vga_blank || !vram_cache_valid) ? 8'h00 : clut[masked_idx][7:0];

endmodule