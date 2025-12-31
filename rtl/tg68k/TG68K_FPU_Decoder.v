module TG68K_FPU_Decoder
  (input  clk,
   input  nReset,
   input  [15:0] opcode,
   input  [15:0] extension_word,
   input  decode_enable,
   output [3:0] instruction_type,
   output [6:0] operation_code,
   output [2:0] source_format,
   output [2:0] dest_format,
   output [2:0] source_reg,
   output [2:0] dest_reg,
   output [2:0] ea_mode,
   output [2:0] ea_register,
   output needs_extension_word,
   output valid_instruction,
   output privileged_instruction,
   output illegal_instruction,
   output unsupported_instruction);
  wire [2:0] coprocessor_id;
  wire [2:0] inst_type_bits;
  wire [2:0] format_field;
  wire [6:0] opmode_field;
  wire [2:0] rm_field;
  wire [2:0] rn_field;
  wire [3:0] instruction_type_int;
  wire valid_f_line;
  wire valid_coprocessor_id;
  wire valid_format;
  wire valid_opmode;
  wire [2:0] n14;
  wire [2:0] n15;
  wire [2:0] n16;
  wire [2:0] n17;
  wire n19;
  wire [2:0] n20;
  wire [6:0] n21;
  wire [2:0] n22;
  wire [2:0] n23;
  wire [2:0] n25;
  wire [6:0] n27;
  wire [2:0] n29;
  wire [2:0] n31;
  wire [3:0] n34;
  wire n36;
  wire n38;
  wire n39;
  wire [2:0] n40;
  wire n42;
  wire [2:0] n43;
  wire n45;
  wire n46;
  wire [2:0] n47;
  wire n49;
  wire [2:0] n50;
  wire n52;
  wire n53;
  wire n54;
  wire [3:0] n57;
  wire n59;
  wire [2:0] n60;
  wire n62;
  wire [2:0] n63;
  wire n65;
  wire [2:0] n66;
  wire n68;
  wire [2:0] n69;
  wire n71;
  wire n72;
  wire [3:0] n75;
  wire [3:0] n77;
  wire [3:0] n79;
  wire n81;
  wire n83;
  wire n85;
  wire n87;
  wire n89;
  wire n90;
  wire n91;
  wire [7:0] n92;
  wire n94;
  wire n95;
  wire n96;
  wire n97;
  wire n98;
  wire [2:0] n99;
  wire n101;
  wire [7:0] n102;
  wire n104;
  wire n105;
  wire [4:0] n106;
  wire n108;
  wire [3:0] n111;
  wire n114;
  wire [3:0] n116;
  wire n118;
  wire [3:0] n120;
  wire n122;
  wire [3:0] n124;
  wire n126;
  wire [2:0] n127;
  wire n129;
  wire n132;
  wire [3:0] n135;
  wire n137;
  wire [7:0] n138;
  reg n148;
  reg n152;
  reg [3:0] n158;
  wire n160;
  wire n163;
  wire [3:0] n166;
  wire [3:0] n170;
  wire n172;
  wire n175;
  wire n177;
  wire n180;
  wire n182;
  wire n184;
  wire n185;
  wire n187;
  wire n188;
  wire n190;
  wire n191;
  wire n193;
  wire n194;
  wire n196;
  wire n197;
  wire n199;
  wire n200;
  reg n203;
  wire n205;
  wire n207;
  wire n208;
  wire n210;
  wire n212;
  wire n213;
  wire n214;
  wire n216;
  wire n218;
  wire n219;
  wire n220;
  wire n223;
  wire n224;
  wire n225;
  wire n226;
  wire n227;
  wire n228;
  wire n229;
  wire n230;
  wire n231;
  wire n232;
  localparam n234 = 1'b0;
  wire n236;
  wire [2:0] n237;
  localparam [2:0] n239 = 3'b010;
  assign instruction_type = instruction_type_int; //(module output)
  assign operation_code = opmode_field; //(module output)
  assign source_format = n237; //(module output)
  assign dest_format = n239; //(module output)
  assign source_reg = rm_field; //(module output)
  assign dest_reg = rn_field; //(module output)
  assign ea_mode = n16; //(module output)
  assign ea_register = n17; //(module output)
  assign needs_extension_word = n160; //(module output)
  assign valid_instruction = n227; //(module output)
  assign privileged_instruction = n163; //(module output)
  assign illegal_instruction = n232; //(module output)
  assign unsupported_instruction = n234; //(module output)
  /* TG68K_FPU_Decoder.vhd:85:16  */
  assign coprocessor_id = n14; // (signal)
  /* TG68K_FPU_Decoder.vhd:86:16  */
  assign inst_type_bits = n15; // (signal)
  /* TG68K_FPU_Decoder.vhd:87:16  */
  assign format_field = n25; // (signal)
  /* TG68K_FPU_Decoder.vhd:88:16  */
  assign opmode_field = n27; // (signal)
  /* TG68K_FPU_Decoder.vhd:89:16  */
  assign rm_field = n29; // (signal)
  /* TG68K_FPU_Decoder.vhd:90:16  */
  assign rn_field = n31; // (signal)
  /* TG68K_FPU_Decoder.vhd:91:16  */
  assign instruction_type_int = n166; // (signal)
  /* TG68K_FPU_Decoder.vhd:94:16  */
  assign valid_f_line = n175; // (signal)
  /* TG68K_FPU_Decoder.vhd:95:16  */
  assign valid_coprocessor_id = n180; // (signal)
  /* TG68K_FPU_Decoder.vhd:96:16  */
  assign valid_format = n203; // (signal)
  /* TG68K_FPU_Decoder.vhd:97:16  */
  assign valid_opmode = n223; // (signal)
  /* TG68K_FPU_Decoder.vhd:110:41  */
  assign n14 = opcode[11:9]; // extract
  /* TG68K_FPU_Decoder.vhd:111:41  */
  assign n15 = opcode[8:6]; // extract
  /* TG68K_FPU_Decoder.vhd:112:34  */
  assign n16 = opcode[5:3]; // extract
  /* TG68K_FPU_Decoder.vhd:113:38  */
  assign n17 = opcode[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:124:35  */
  assign n19 = inst_type_bits == 3'b000;
  /* TG68K_FPU_Decoder.vhd:127:55  */
  assign n20 = extension_word[12:10]; // extract
  /* TG68K_FPU_Decoder.vhd:128:55  */
  assign n21 = extension_word[6:0]; // extract
  /* TG68K_FPU_Decoder.vhd:129:51  */
  assign n22 = extension_word[15:13]; // extract
  /* TG68K_FPU_Decoder.vhd:130:51  */
  assign n23 = extension_word[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:124:17  */
  assign n25 = n19 ? n20 : 3'b000;
  /* TG68K_FPU_Decoder.vhd:124:17  */
  assign n27 = n19 ? n21 : 7'b0000000;
  /* TG68K_FPU_Decoder.vhd:124:17  */
  assign n29 = n19 ? n22 : 3'b000;
  /* TG68K_FPU_Decoder.vhd:124:17  */
  assign n31 = n19 ? n23 : 3'b000;
  /* TG68K_FPU_Decoder.vhd:147:26  */
  assign n34 = opcode[15:12]; // extract
  /* TG68K_FPU_Decoder.vhd:147:41  */
  assign n36 = n34 == 4'b1111;
  /* TG68K_FPU_Decoder.vhd:147:69  */
  assign n38 = coprocessor_id == 3'b001;
  /* TG68K_FPU_Decoder.vhd:147:50  */
  assign n39 = n38 & n36;
  /* TG68K_FPU_Decoder.vhd:153:51  */
  assign n40 = opcode[5:3]; // extract
  /* TG68K_FPU_Decoder.vhd:153:64  */
  assign n42 = n40 == 3'b010;
  /* TG68K_FPU_Decoder.vhd:153:82  */
  assign n43 = opcode[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:153:95  */
  assign n45 = n43 == 3'b101;
  /* TG68K_FPU_Decoder.vhd:153:72  */
  assign n46 = n45 & n42;
  /* TG68K_FPU_Decoder.vhd:154:51  */
  assign n47 = opcode[5:3]; // extract
  /* TG68K_FPU_Decoder.vhd:154:64  */
  assign n49 = n47 == 3'b001;
  /* TG68K_FPU_Decoder.vhd:154:82  */
  assign n50 = opcode[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:154:95  */
  assign n52 = n50 == 3'b101;
  /* TG68K_FPU_Decoder.vhd:154:72  */
  assign n53 = n52 & n49;
  /* TG68K_FPU_Decoder.vhd:153:104  */
  assign n54 = n46 | n53;
  /* TG68K_FPU_Decoder.vhd:153:41  */
  assign n57 = n54 ? 4'b0011 : 4'b0000;
  /* TG68K_FPU_Decoder.vhd:149:33  */
  assign n59 = inst_type_bits == 3'b000;
  /* TG68K_FPU_Decoder.vhd:167:50  */
  assign n60 = opcode[5:3]; // extract
  /* TG68K_FPU_Decoder.vhd:167:63  */
  assign n62 = n60 == 3'b001;
  /* TG68K_FPU_Decoder.vhd:169:53  */
  assign n63 = opcode[5:3]; // extract
  /* TG68K_FPU_Decoder.vhd:169:66  */
  assign n65 = n63 == 3'b111;
  /* TG68K_FPU_Decoder.vhd:170:58  */
  assign n66 = opcode[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:170:71  */
  assign n68 = n66 == 3'b010;
  /* TG68K_FPU_Decoder.vhd:170:88  */
  assign n69 = opcode[2:0]; // extract
  /* TG68K_FPU_Decoder.vhd:170:101  */
  assign n71 = n69 == 3'b011;
  /* TG68K_FPU_Decoder.vhd:170:79  */
  assign n72 = n68 | n71;
  /* TG68K_FPU_Decoder.vhd:170:49  */
  assign n75 = n72 ? 4'b1000 : 4'b0101;
  /* TG68K_FPU_Decoder.vhd:169:41  */
  assign n77 = n65 ? n75 : 4'b0101;
  /* TG68K_FPU_Decoder.vhd:167:41  */
  assign n79 = n62 ? 4'b0101 : n77;
  /* TG68K_FPU_Decoder.vhd:166:33  */
  assign n81 = inst_type_bits == 3'b001;
  /* TG68K_FPU_Decoder.vhd:180:33  */
  assign n83 = inst_type_bits == 3'b010;
  /* TG68K_FPU_Decoder.vhd:184:33  */
  assign n85 = inst_type_bits == 3'b011;
  /* TG68K_FPU_Decoder.vhd:188:33  */
  assign n87 = inst_type_bits == 3'b100;
  /* TG68K_FPU_Decoder.vhd:193:33  */
  assign n89 = inst_type_bits == 3'b101;
  /* TG68K_FPU_Decoder.vhd:199:58  */
  assign n90 = extension_word[15]; // extract
  /* TG68K_FPU_Decoder.vhd:199:63  */
  assign n91 = ~n90;
  /* TG68K_FPU_Decoder.vhd:203:59  */
  assign n92 = opcode[15:8]; // extract
  /* TG68K_FPU_Decoder.vhd:203:73  */
  assign n94 = n92 == 8'b11110010;
  /* TG68K_FPU_Decoder.vhd:204:67  */
  assign n95 = extension_word[15]; // extract
  /* TG68K_FPU_Decoder.vhd:203:82  */
  assign n96 = n95 & n94;
  /* TG68K_FPU_Decoder.vhd:205:67  */
  assign n97 = extension_word[14]; // extract
  /* TG68K_FPU_Decoder.vhd:204:79  */
  assign n98 = n97 & n96;
  /* TG68K_FPU_Decoder.vhd:207:74  */
  assign n99 = extension_word[12:10]; // extract
  /* TG68K_FPU_Decoder.vhd:207:89  */
  assign n101 = n99 != 3'b000;
  /* TG68K_FPU_Decoder.vhd:207:116  */
  assign n102 = extension_word[7:0]; // extract
  /* TG68K_FPU_Decoder.vhd:207:129  */
  assign n104 = n102 == 8'b00000000;
  /* TG68K_FPU_Decoder.vhd:207:98  */
  assign n105 = n104 & n101;
  /* TG68K_FPU_Decoder.vhd:210:77  */
  assign n106 = extension_word[12:8]; // extract
  /* TG68K_FPU_Decoder.vhd:210:91  */
  assign n108 = n106 == 5'b00000;
  /* TG68K_FPU_Decoder.vhd:210:57  */
  assign n111 = n108 ? 4'b0011 : 4'b0000;
  /* TG68K_FPU_Decoder.vhd:207:57  */
  assign n114 = n105 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:207:57  */
  assign n116 = n105 ? 4'b1001 : n111;
  /* TG68K_FPU_Decoder.vhd:203:49  */
  assign n118 = n98 ? n114 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:203:49  */
  assign n120 = n98 ? n116 : 4'b0000;
  /* TG68K_FPU_Decoder.vhd:199:41  */
  assign n122 = n91 ? 1'b0 : n118;
  /* TG68K_FPU_Decoder.vhd:199:41  */
  assign n124 = n91 ? 4'b0001 : n120;
  /* TG68K_FPU_Decoder.vhd:198:33  */
  assign n126 = inst_type_bits == 3'b110;
  /* TG68K_FPU_Decoder.vhd:224:58  */
  assign n127 = extension_word[15:13]; // extract
  /* TG68K_FPU_Decoder.vhd:224:73  */
  assign n129 = n127 == 3'b100;
  /* TG68K_FPU_Decoder.vhd:224:41  */
  assign n132 = n129 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:224:41  */
  assign n135 = n129 ? 4'b0100 : 4'b0010;
  /* TG68K_FPU_Decoder.vhd:223:33  */
  assign n137 = inst_type_bits == 3'b111;
  assign n138 = {n137, n126, n89, n87, n85, n83, n81, n59};
  /* TG68K_FPU_Decoder.vhd:148:25  */
  always @*
    case (n138)
      8'b10000000: n148 = 1'b1;
      8'b01000000: n148 = 1'b1;
      8'b00100000: n148 = 1'b0;
      8'b00010000: n148 = 1'b0;
      8'b00001000: n148 = 1'b1;
      8'b00000100: n148 = 1'b1;
      8'b00000010: n148 = 1'b1;
      8'b00000001: n148 = 1'b1;
      default: n148 = 1'b1;
    endcase
  /* TG68K_FPU_Decoder.vhd:148:25  */
  always @*
    case (n138)
      8'b10000000: n152 = n132;
      8'b01000000: n152 = n122;
      8'b00100000: n152 = 1'b1;
      8'b00010000: n152 = 1'b1;
      8'b00001000: n152 = 1'b0;
      8'b00000100: n152 = 1'b0;
      8'b00000010: n152 = 1'b0;
      8'b00000001: n152 = 1'b0;
      default: n152 = 1'b0;
    endcase
  /* TG68K_FPU_Decoder.vhd:148:25  */
  always @*
    case (n138)
      8'b10000000: n158 = n135;
      8'b01000000: n158 = n124;
      8'b00100000: n158 = 4'b0111;
      8'b00010000: n158 = 4'b0110;
      8'b00001000: n158 = 4'b0101;
      8'b00000100: n158 = 4'b0101;
      8'b00000010: n158 = n79;
      8'b00000001: n158 = n57;
      default: n158 = 4'b0000;
    endcase
  /* TG68K_FPU_Decoder.vhd:147:17  */
  assign n160 = n39 ? n148 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:147:17  */
  assign n163 = n39 ? n152 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:147:17  */
  assign n166 = n39 ? n158 : 4'b0000;
  /* TG68K_FPU_Decoder.vhd:246:26  */
  assign n170 = opcode[15:12]; // extract
  /* TG68K_FPU_Decoder.vhd:246:41  */
  assign n172 = n170 == 4'b1111;
  /* TG68K_FPU_Decoder.vhd:246:17  */
  assign n175 = n172 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:253:35  */
  assign n177 = coprocessor_id == 3'b001;
  /* TG68K_FPU_Decoder.vhd:253:17  */
  assign n180 = n177 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:261:25  */
  assign n182 = format_field == 3'b000;
  /* TG68K_FPU_Decoder.vhd:261:42  */
  assign n184 = format_field == 3'b001;
  /* TG68K_FPU_Decoder.vhd:261:42  */
  assign n185 = n182 | n184;
  /* TG68K_FPU_Decoder.vhd:261:58  */
  assign n187 = format_field == 3'b010;
  /* TG68K_FPU_Decoder.vhd:261:58  */
  assign n188 = n185 | n187;
  /* TG68K_FPU_Decoder.vhd:261:76  */
  assign n190 = format_field == 3'b011;
  /* TG68K_FPU_Decoder.vhd:261:76  */
  assign n191 = n188 | n190;
  /* TG68K_FPU_Decoder.vhd:262:48  */
  assign n193 = format_field == 3'b100;
  /* TG68K_FPU_Decoder.vhd:262:48  */
  assign n194 = n191 | n193;
  /* TG68K_FPU_Decoder.vhd:262:62  */
  assign n196 = format_field == 3'b101;
  /* TG68K_FPU_Decoder.vhd:262:62  */
  assign n197 = n194 | n196;
  /* TG68K_FPU_Decoder.vhd:262:78  */
  assign n199 = format_field == 3'b110;
  /* TG68K_FPU_Decoder.vhd:262:78  */
  assign n200 = n197 | n199;
  /* TG68K_FPU_Decoder.vhd:260:17  */
  always @*
    case (n200)
      1'b1: n203 = 1'b1;
      default: n203 = 1'b0;
    endcase
  /* TG68K_FPU_Decoder.vhd:271:34  */
  assign n205 = $unsigned(opmode_field) >= $unsigned(7'b0000000);
  /* TG68K_FPU_Decoder.vhd:271:64  */
  assign n207 = $unsigned(opmode_field) <= $unsigned(7'b0001111);
  /* TG68K_FPU_Decoder.vhd:271:47  */
  assign n208 = n207 & n205;
  /* TG68K_FPU_Decoder.vhd:272:34  */
  assign n210 = $unsigned(opmode_field) >= $unsigned(7'b0100000);
  /* TG68K_FPU_Decoder.vhd:272:64  */
  assign n212 = $unsigned(opmode_field) <= $unsigned(7'b0101111);
  /* TG68K_FPU_Decoder.vhd:272:47  */
  assign n213 = n212 & n210;
  /* TG68K_FPU_Decoder.vhd:271:78  */
  assign n214 = n208 | n213;
  /* TG68K_FPU_Decoder.vhd:273:34  */
  assign n216 = $unsigned(opmode_field) >= $unsigned(7'b0001100);
  /* TG68K_FPU_Decoder.vhd:273:64  */
  assign n218 = $unsigned(opmode_field) <= $unsigned(7'b0011111);
  /* TG68K_FPU_Decoder.vhd:273:47  */
  assign n219 = n218 & n216;
  /* TG68K_FPU_Decoder.vhd:272:78  */
  assign n220 = n214 | n219;
  /* TG68K_FPU_Decoder.vhd:271:17  */
  assign n223 = n220 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Decoder.vhd:280:52  */
  assign n224 = decode_enable & valid_f_line;
  /* TG68K_FPU_Decoder.vhd:280:69  */
  assign n225 = n224 & valid_coprocessor_id;
  /* TG68K_FPU_Decoder.vhd:280:94  */
  assign n226 = n225 & valid_format;
  /* TG68K_FPU_Decoder.vhd:280:111  */
  assign n227 = n226 & valid_opmode;
  /* TG68K_FPU_Decoder.vhd:281:76  */
  assign n228 = valid_f_line & valid_coprocessor_id;
  /* TG68K_FPU_Decoder.vhd:281:101  */
  assign n229 = n228 & valid_format;
  /* TG68K_FPU_Decoder.vhd:281:118  */
  assign n230 = n229 & valid_opmode;
  /* TG68K_FPU_Decoder.vhd:281:58  */
  assign n231 = ~n230;
  /* TG68K_FPU_Decoder.vhd:281:54  */
  assign n232 = decode_enable & n231;
  /* TG68K_FPU_Decoder.vhd:294:65  */
  assign n236 = instruction_type_int == 4'b0000;
  /* TG68K_FPU_Decoder.vhd:294:39  */
  assign n237 = n236 ? format_field : 3'b010;
endmodule

