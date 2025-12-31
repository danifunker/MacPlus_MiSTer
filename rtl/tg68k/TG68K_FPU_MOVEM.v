module TG68K_FPU_MOVEM
  (input  clk,
   input  nReset,
   input  clkena,
   input  start_movem,
   input  direction,
   input  [7:0] register_mask,
   input  predecrement,
   input  postincrement,
   input  fmovem_data_request,
   input  [2:0] fmovem_reg_index,
   input  fmovem_data_write,
   input  [79:0] fmovem_data_in,
   input  [79:0] reg_data_in,
   output movem_done,
   output movem_busy,
   output [79:0] fmovem_data_out,
   output [2:0] reg_address,
   output [79:0] reg_data_out,
   output reg_write_enable,
   output address_error);
  reg movem_state;
  wire n10;
  wire n14;
  wire n17;
  wire n23;
  wire [79:0] n25;
  wire [2:0] n26;
  wire [2:0] n28;
  wire [79:0] n29;
  wire n32;
  wire n33;
  wire n35;
  wire n37;
  wire n39;
  wire n43;
  wire [1:0] n44;
  reg n47;
  reg n49;
  reg [79:0] n51;
  reg [2:0] n53;
  reg [79:0] n55;
  reg n58;
  reg n61;
  reg n63;
  wire n100;
  reg n101;
  wire n104;
  reg n105;
  wire n106;
  reg n107;
  wire n108;
  wire n109;
  wire [79:0] n110;
  reg [79:0] n111;
  wire n112;
  wire n113;
  wire [2:0] n114;
  reg [2:0] n115;
  wire n116;
  wire n117;
  wire [79:0] n118;
  reg [79:0] n119;
  wire n120;
  reg n121;
  wire n122;
  reg n123;
  assign movem_done = n105; //(module output)
  assign movem_busy = n107; //(module output)
  assign fmovem_data_out = n111; //(module output)
  assign reg_address = n115; //(module output)
  assign reg_data_out = n119; //(module output)
  assign reg_write_enable = n121; //(module output)
  assign address_error = n123; //(module output)
  /* TG68K_FPU_MOVEM.vhd:70:16  */
  always @*
    movem_state = n101; // (isignal)
  initial
    movem_state = 1'b0;
  /* TG68K_FPU_MOVEM.vhd:80:27  */
  assign n10 = ~nReset;
  /* TG68K_FPU_MOVEM.vhd:98:49  */
  assign n14 = start_movem ? 1'b1 : 1'b0;
  /* TG68K_FPU_MOVEM.vhd:98:49  */
  assign n17 = start_movem ? 1'b1 : movem_state;
  /* TG68K_FPU_MOVEM.vhd:91:41  */
  assign n23 = movem_state == 1'b0;
  /* TG68K_FPU_MOVEM.vhd:107:49  */
  assign n25 = fmovem_data_request ? reg_data_in : n111;
  /* TG68K_FPU_MOVEM.vhd:107:49  */
  assign n26 = fmovem_data_request ? fmovem_reg_index : n115;
  /* TG68K_FPU_MOVEM.vhd:113:49  */
  assign n28 = fmovem_data_write ? fmovem_reg_index : n26;
  /* TG68K_FPU_MOVEM.vhd:113:49  */
  assign n29 = fmovem_data_write ? fmovem_data_in : n119;
  /* TG68K_FPU_MOVEM.vhd:113:49  */
  assign n32 = fmovem_data_write ? 1'b1 : 1'b0;
  /* TG68K_FPU_MOVEM.vhd:123:64  */
  assign n33 = ~start_movem;
  /* TG68K_FPU_MOVEM.vhd:123:49  */
  assign n35 = n33 ? 1'b1 : n105;
  /* TG68K_FPU_MOVEM.vhd:123:49  */
  assign n37 = n33 ? 1'b0 : n107;
  /* TG68K_FPU_MOVEM.vhd:123:49  */
  assign n39 = n33 ? 1'b0 : movem_state;
  /* TG68K_FPU_MOVEM.vhd:105:41  */
  assign n43 = movem_state == 1'b1;
  assign n44 = {n43, n23};
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n47 = n35;
      2'b01: n47 = 1'b0;
      default: n47 = 1'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n49 = n37;
      2'b01: n49 = n14;
      default: n49 = 1'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n51 = n25;
      2'b01: n51 = n111;
      default: n51 = 80'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n53 = n28;
      2'b01: n53 = n115;
      default: n53 = 3'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n55 = n29;
      2'b01: n55 = n119;
      default: n55 = 80'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n58 = n32;
      2'b01: n58 = 1'b0;
      default: n58 = 1'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n61 = n123;
      2'b01: n61 = 1'b0;
      default: n61 = 1'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:90:33  */
  always @*
    case (n44)
      2'b10: n63 = n39;
      2'b01: n63 = n17;
      default: n63 = 1'bX;
    endcase
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n100 = clkena ? n63 : movem_state;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk or posedge n10)
    if (n10)
      n101 <= 1'b0;
    else
      n101 <= n100;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n104 = clkena ? n47 : n105;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk or posedge n10)
    if (n10)
      n105 <= 1'b0;
    else
      n105 <= n104;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n106 = clkena ? n49 : n107;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk or posedge n10)
    if (n10)
      n107 <= 1'b0;
    else
      n107 <= n106;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n108 = ~n10;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n109 = clkena & n108;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n110 = n109 ? n51 : n111;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk)
    n111 <= n110;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n112 = ~n10;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n113 = clkena & n112;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n114 = n113 ? n53 : n115;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk)
    n115 <= n114;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n116 = ~n10;
  /* TG68K_FPU_MOVEM.vhd:78:9  */
  assign n117 = clkena & n116;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n118 = n117 ? n55 : n119;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk)
    n119 <= n118;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n120 = clkena ? n58 : n121;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk or posedge n10)
    if (n10)
      n121 <= 1'b0;
    else
      n121 <= n120;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  assign n122 = clkena ? n61 : n123;
  /* TG68K_FPU_MOVEM.vhd:88:17  */
  always @(posedge clk or posedge n10)
    if (n10)
      n123 <= 1'b0;
    else
      n123 <= n122;
endmodule

