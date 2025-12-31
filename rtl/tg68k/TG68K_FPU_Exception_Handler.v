module TG68K_FPU_Exception_Handler
  (input  clk,
   input  reset,
   input  [79:0] operation_result,
   input  operation_valid,
   input  [7:0] operation_type,
   input  [79:0] operand_a,
   input  [79:0] operand_b,
   input  overflow_flag,
   input  underflow_flag,
   input  inexact_flag,
   input  invalid_flag,
   input  divide_by_zero_flag,
   input  [31:0] fpcr,
   input  [31:0] fpsr_in,
   output [31:0] fpsr_out,
   output exception_pending,
   output [7:0] exception_vector,
   output [79:0] corrected_result);
  wire [31:0] fpsr_work;
  wire exception_detected;
  wire exception_enabled;
  wire [1:0] rounding_mode;
  wire is_nan_result;
  wire is_inf_result;
  wire is_zero_result;
  wire result_sign;
  wire [1:0] n4;
  wire n7;
  wire [14:0] n8;
  wire n10;
  wire n11;
  wire n12;
  wire [62:0] n13;
  wire n15;
  wire n16;
  wire n17;
  wire n20;
  wire [14:0] n21;
  wire n23;
  wire n24;
  wire n25;
  wire [62:0] n26;
  wire n28;
  wire n29;
  wire n32;
  wire [78:0] n33;
  wire n35;
  wire n38;
  wire n75;
  wire [14:0] n76;
  wire [30:0] n77;
  wire [31:0] n78;
  wire n80;
  wire [14:0] n81;
  wire [30:0] n82;
  wire [31:0] n83;
  wire n128;
  wire n129;
  wire n130;
  wire [62:0] n131;
  wire n133;
  wire n134;
  wire n135;
  wire n136;
  wire n137;
  wire n140;
  wire n146;
  wire n149;
  wire n150;
  wire n151;
  wire [62:0] n152;
  wire n154;
  wire n155;
  wire n156;
  wire n157;
  wire n158;
  wire n161;
  wire n167;
  wire [79:0] n193;
  wire n195;
  wire n197;
  wire n200;
  wire [15:0] n202;
  wire [16:0] n204;
  wire [79:0] n206;
  wire [79:0] n207;
  wire n209;
  wire n211;
  wire [15:0] n215;
  wire [16:0] n217;
  wire [79:0] n219;
  wire n221;
  wire n223;
  wire n224;
  wire [79:0] n227;
  wire n229;
  wire n230;
  wire [79:0] n233;
  wire n235;
  wire [15:0] n237;
  wire [16:0] n239;
  wire [79:0] n241;
  wire [2:0] n242;
  reg [79:0] n243;
  wire [79:0] n244;
  wire n246;
  wire n248;
  wire n251;
  wire n252;
  wire [79:0] n254;
  wire [79:0] n255;
  wire n256;
  wire n258;
  wire n260;
  wire n264;
  wire n266;
  wire n267;
  wire n270;
  wire [15:0] n271;
  wire [16:0] n272;
  wire [17:0] n274;
  wire [61:0] n275;
  wire [79:0] n276;
  wire n277;
  wire [15:0] n278;
  wire [16:0] n279;
  wire [17:0] n281;
  wire [61:0] n282;
  wire [79:0] n283;
  wire [79:0] n284;
  wire [79:0] n285;
  wire n287;
  wire n288;
  wire n293;
  wire n295;
  wire n297;
  wire n299;
  wire [2:0] n300;
  wire n302;
  wire [2:0] n304;
  localparam [7:0] n305 = 8'b00000000;
  wire [3:0] n307;
  wire [7:0] n311;
  wire n312;
  wire n313;
  wire [7:0] n315;
  wire n318;
  wire n327;
  wire n328;
  wire n330;
  wire n339;
  wire [7:0] n343;
  wire n344;
  wire n347;
  wire n351;
  wire [7:0] n353;
  wire n354;
  wire n358;
  wire n359;
  wire n360;
  wire n363;
  wire n364;
  wire n365;
  wire n368;
  wire n369;
  wire n370;
  wire n374;
  wire n375;
  wire n376;
  wire n380;
  wire [7:0] n383;
  wire n384;
  wire n387;
  wire n391;
  wire [7:0] n393;
  wire n394;
  wire n398;
  wire n399;
  wire n400;
  wire n403;
  wire n404;
  wire n405;
  wire n408;
  wire n409;
  wire n410;
  wire n414;
  wire n415;
  wire n416;
  wire n420;
  wire [7:0] n423;
  wire n424;
  wire n427;
  wire n431;
  wire [7:0] n433;
  wire n434;
  wire n438;
  wire n439;
  wire n440;
  wire n443;
  wire n444;
  wire n445;
  wire n448;
  wire n449;
  wire n450;
  wire n454;
  wire n455;
  wire n456;
  wire n460;
  wire [7:0] n463;
  wire n464;
  wire n467;
  wire n471;
  wire [7:0] n473;
  wire n474;
  wire n478;
  wire n479;
  wire n480;
  wire n483;
  wire n484;
  wire n485;
  wire n488;
  wire n489;
  wire n490;
  wire n494;
  wire n495;
  wire n496;
  wire n500;
  wire [7:0] n503;
  wire n504;
  wire n507;
  wire n511;
  wire [7:0] n513;
  wire n514;
  wire n518;
  wire n519;
  wire n520;
  wire n523;
  wire n524;
  wire n525;
  wire n528;
  wire n529;
  wire n530;
  wire n534;
  wire n535;
  wire n536;
  wire n540;
  wire [7:0] n543;
  wire n544;
  wire n547;
  wire n551;
  wire [7:0] n553;
  wire n554;
  wire n558;
  wire n559;
  wire n560;
  wire n563;
  wire n564;
  wire n565;
  wire n568;
  wire n569;
  wire n570;
  wire n574;
  wire n575;
  wire n576;
  wire n580;
  wire [7:0] n583;
  wire n584;
  wire n587;
  wire n591;
  wire [7:0] n593;
  wire n594;
  wire n599;
  wire n600;
  wire n604;
  wire n605;
  wire n609;
  wire n610;
  wire n615;
  wire n616;
  wire [7:0] n621;
  wire [7:0] n622;
  wire [7:0] n623;
  wire [7:0] n626;
  wire [7:0] n627;
  wire [7:0] n628;
  wire [7:0] n630;
  wire [7:0] n631;
  wire [7:0] n634;
  wire n635;
  wire [7:0] n638;
  wire n639;
  wire n640;
  wire [7:0] n643;
  wire n644;
  wire n645;
  wire [7:0] n648;
  wire n649;
  wire n650;
  wire [7:0] n653;
  wire n654;
  wire n655;
  wire [7:0] n658;
  wire n659;
  wire n660;
  wire [7:0] n663;
  wire n664;
  wire n665;
  wire [7:0] n668;
  wire n669;
  wire n670;
  wire [79:0] n672;
  wire [31:0] n673;
  wire [31:0] n674;
  wire n676;
  wire n679;
  wire n719;
  wire n877;
  wire [31:0] n878;
  reg [31:0] n879;
  wire n883;
  wire n884;
  reg n885;
  wire n886;
  wire n887;
  reg n888;
  reg [31:0] n889;
  reg n890;
  wire [7:0] n891;
  reg [7:0] n892;
  reg [79:0] n893;
  assign fpsr_out = n889; //(module output)
  assign exception_pending = n890; //(module output)
  assign exception_vector = n892; //(module output)
  assign corrected_result = n893; //(module output)
  /* TG68K_FPU_Exception_Handler.vhd:112:12  */
  assign fpsr_work = n879; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:116:12  */
  assign exception_detected = n885; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:117:12  */
  assign exception_enabled = n888; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:118:12  */
  assign rounding_mode = n4; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:122:12  */
  assign is_nan_result = n20; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:123:12  */
  assign is_inf_result = n32; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:124:12  */
  assign is_zero_result = n38; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:348:17  */
  assign result_sign = n7; // (signal)
  /* TG68K_FPU_Exception_Handler.vhd:131:26  */
  assign n4 = fpcr[5:4]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:137:40  */
  assign n7 = operation_result[79]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:140:28  */
  assign n8 = operation_result[78:64]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:140:43  */
  assign n10 = n8 == 15'b111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:141:29  */
  assign n11 = operation_result[63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:141:34  */
  assign n12 = ~n11;
  /* TG68K_FPU_Exception_Handler.vhd:141:59  */
  assign n13 = operation_result[62:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:141:73  */
  assign n15 = n13 != 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Exception_Handler.vhd:141:40  */
  assign n16 = n12 | n15;
  /* TG68K_FPU_Exception_Handler.vhd:140:63  */
  assign n17 = n16 & n10;
  /* TG68K_FPU_Exception_Handler.vhd:140:9  */
  assign n20 = n17 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:148:28  */
  assign n21 = operation_result[78:64]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:148:43  */
  assign n23 = n21 == 15'b111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:149:28  */
  assign n24 = operation_result[63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:148:63  */
  assign n25 = n24 & n23;
  /* TG68K_FPU_Exception_Handler.vhd:149:59  */
  assign n26 = operation_result[62:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:149:73  */
  assign n28 = n26 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Exception_Handler.vhd:149:39  */
  assign n29 = n28 & n25;
  /* TG68K_FPU_Exception_Handler.vhd:148:9  */
  assign n32 = n29 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:156:28  */
  assign n33 = operation_result[78:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:156:42  */
  assign n35 = n33 == 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Exception_Handler.vhd:156:9  */
  assign n38 = n35 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:210:36  */
  assign n75 = operand_a[79]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:211:55  */
  assign n76 = operand_a[78:64]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:211:26  */
  assign n77 = {16'b0, n76};  //  uext
  /* TG68K_FPU_Exception_Handler.vhd:211:17  */
  assign n78 = {1'b0, n77};  //  uext
  /* TG68K_FPU_Exception_Handler.vhd:214:36  */
  assign n80 = operand_b[79]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:215:55  */
  assign n81 = operand_b[78:64]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:215:26  */
  assign n82 = {16'b0, n81};  //  uext
  /* TG68K_FPU_Exception_Handler.vhd:215:17  */
  assign n83 = {1'b0, n82};  //  uext
  /* TG68K_FPU_Exception_Handler.vhd:244:26  */
  assign n128 = n78 == 32'b00000000000000000111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:244:51  */
  assign n129 = operand_a[63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:244:56  */
  assign n130 = ~n129;
  /* TG68K_FPU_Exception_Handler.vhd:244:75  */
  assign n131 = operand_a[62:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:244:89  */
  assign n133 = n131 != 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Exception_Handler.vhd:244:62  */
  assign n134 = n130 | n133;
  /* TG68K_FPU_Exception_Handler.vhd:244:36  */
  assign n135 = n134 & n128;
  /* TG68K_FPU_Exception_Handler.vhd:246:34  */
  assign n136 = operand_a[62]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:246:39  */
  assign n137 = ~n136;
  /* TG68K_FPU_Exception_Handler.vhd:246:21  */
  assign n140 = n137 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:244:17  */
  assign n146 = n135 ? n140 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:250:26  */
  assign n149 = n83 == 32'b00000000000000000111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:250:51  */
  assign n150 = operand_b[63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:250:56  */
  assign n151 = ~n150;
  /* TG68K_FPU_Exception_Handler.vhd:250:75  */
  assign n152 = operand_b[62:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:250:89  */
  assign n154 = n152 != 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Exception_Handler.vhd:250:62  */
  assign n155 = n151 | n154;
  /* TG68K_FPU_Exception_Handler.vhd:250:36  */
  assign n156 = n155 & n149;
  /* TG68K_FPU_Exception_Handler.vhd:252:34  */
  assign n157 = operand_b[62]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:252:39  */
  assign n158 = ~n157;
  /* TG68K_FPU_Exception_Handler.vhd:252:21  */
  assign n161 = n158 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:250:17  */
  assign n167 = n156 ? n161 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:271:17  */
  assign n193 = invalid_flag ? 80'b01111111111111111100000000000000000000000000000000000000000000000000000000000000 : operation_result;
  /* TG68K_FPU_Exception_Handler.vhd:271:17  */
  assign n195 = invalid_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:271:17  */
  assign n197 = invalid_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:282:49  */
  assign n200 = n75 ^ n80;
  /* TG68K_FPU_Exception_Handler.vhd:282:61  */
  assign n202 = {n200, 15'b111111111111111};
  /* TG68K_FPU_Exception_Handler.vhd:282:81  */
  assign n204 = {n202, 1'b1};
  /* TG68K_FPU_Exception_Handler.vhd:282:87  */
  assign n206 = {n204, 63'b000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_Exception_Handler.vhd:278:17  */
  assign n207 = divide_by_zero_flag ? n206 : n193;
  /* TG68K_FPU_Exception_Handler.vhd:278:17  */
  assign n209 = divide_by_zero_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:278:17  */
  assign n211 = divide_by_zero_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:292:61  */
  assign n215 = {result_sign, 15'b111111111111111};
  /* TG68K_FPU_Exception_Handler.vhd:292:81  */
  assign n217 = {n215, 1'b1};
  /* TG68K_FPU_Exception_Handler.vhd:292:87  */
  assign n219 = {n217, 63'b000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_Exception_Handler.vhd:290:25  */
  assign n221 = rounding_mode == 2'b00;
  /* TG68K_FPU_Exception_Handler.vhd:290:42  */
  assign n223 = rounding_mode == 2'b01;
  /* TG68K_FPU_Exception_Handler.vhd:290:42  */
  assign n224 = n221 | n223;
  /* TG68K_FPU_Exception_Handler.vhd:294:29  */
  assign n227 = result_sign ? 80'b11111111111111111000000000000000000000000000000000000000000000000000000000000000 : 80'b01111111111111101111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:293:25  */
  assign n229 = rounding_mode == 2'b10;
  /* TG68K_FPU_Exception_Handler.vhd:302:44  */
  assign n230 = ~result_sign;
  /* TG68K_FPU_Exception_Handler.vhd:302:29  */
  assign n233 = n230 ? 80'b01111111111111111000000000000000000000000000000000000000000000000000000000000000 : 80'b11111111111111101111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_Exception_Handler.vhd:301:25  */
  assign n235 = rounding_mode == 2'b11;
  /* TG68K_FPU_Exception_Handler.vhd:310:61  */
  assign n237 = {result_sign, 15'b111111111111111};
  /* TG68K_FPU_Exception_Handler.vhd:310:81  */
  assign n239 = {n237, 1'b1};
  /* TG68K_FPU_Exception_Handler.vhd:310:87  */
  assign n241 = {n239, 63'b000000000000000000000000000000000000000000000000000000000000000};
  assign n242 = {n235, n229, n224};
  /* TG68K_FPU_Exception_Handler.vhd:289:21  */
  always @*
    case (n242)
      3'b100: n243 = n233;
      3'b010: n243 = n227;
      3'b001: n243 = n219;
      default: n243 = n241;
    endcase
  /* TG68K_FPU_Exception_Handler.vhd:285:17  */
  assign n244 = overflow_flag ? n243 : n207;
  /* TG68K_FPU_Exception_Handler.vhd:285:17  */
  assign n246 = overflow_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:285:17  */
  assign n248 = overflow_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:318:28  */
  assign n251 = fpcr[11]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:318:33  */
  assign n252 = ~n251;
  /* TG68K_FPU_Exception_Handler.vhd:319:57  */
  assign n254 = {result_sign, 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_Exception_Handler.vhd:314:17  */
  assign n255 = n256 ? n254 : n244;
  /* TG68K_FPU_Exception_Handler.vhd:314:17  */
  assign n256 = n252 & underflow_flag;
  /* TG68K_FPU_Exception_Handler.vhd:314:17  */
  assign n258 = underflow_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:314:17  */
  assign n260 = underflow_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:324:17  */
  assign n264 = inexact_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:324:17  */
  assign n266 = inexact_flag ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:331:36  */
  assign n267 = n146 | n167;
  /* TG68K_FPU_Exception_Handler.vhd:336:54  */
  assign n270 = operand_a[79]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:336:70  */
  assign n271 = operand_a[78:63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:336:59  */
  assign n272 = {n270, n271};
  /* TG68K_FPU_Exception_Handler.vhd:336:85  */
  assign n274 = {n272, 1'b1};
  /* TG68K_FPU_Exception_Handler.vhd:336:102  */
  assign n275 = operand_a[61:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:336:91  */
  assign n276 = {n274, n275};
  /* TG68K_FPU_Exception_Handler.vhd:338:54  */
  assign n277 = operand_b[79]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:338:70  */
  assign n278 = operand_b[78:63]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:338:59  */
  assign n279 = {n277, n278};
  /* TG68K_FPU_Exception_Handler.vhd:338:85  */
  assign n281 = {n279, 1'b1};
  /* TG68K_FPU_Exception_Handler.vhd:338:102  */
  assign n282 = operand_b[61:0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:338:91  */
  assign n283 = {n281, n282};
  /* TG68K_FPU_Exception_Handler.vhd:335:21  */
  assign n284 = n146 ? n276 : n283;
  /* TG68K_FPU_Exception_Handler.vhd:331:17  */
  assign n285 = n267 ? n284 : n255;
  /* TG68K_FPU_Exception_Handler.vhd:331:17  */
  assign n287 = n267 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:331:17  */
  assign n288 = n267 ? 1'b1 : n197;
  /* TG68K_FPU_Exception_Handler.vhd:348:17  */
  assign n293 = is_inf_result ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:346:17  */
  assign n295 = is_zero_result ? 1'b0 : n293;
  /* TG68K_FPU_Exception_Handler.vhd:346:17  */
  assign n297 = is_zero_result ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:346:17  */
  assign n299 = is_zero_result ? 1'b0 : result_sign;
  assign n300 = {n299, n297, n295};
  /* TG68K_FPU_Exception_Handler.vhd:344:17  */
  assign n302 = is_nan_result ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:344:17  */
  assign n304 = is_nan_result ? 3'b000 : n300;
  assign n307 = n305[3:0]; // extract
  assign n311 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n312 = n311[7]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n313 = fpcr[15]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n315 = n328 ? 8'b00110111 : n892;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n318 = n313 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n327 = n313 ? 1'b0 : 1'b1;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n328 = n313 & n312;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n330 = n312 ? n318 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n339 = n312 ? n327 : 1'b1;
  assign n343 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n344 = n343[6]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n347 = fpcr[14]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n351 = n376 ? 1'b1 : n330;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n353 = n375 ? 8'b00110110 : n315;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n354 = n339 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n358 = n380 ? 1'b0 : n339;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n359 = n354 & n347;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n360 = n339 & n347;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n363 = n339 & n347;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n364 = n359 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n365 = n360 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n368 = n363 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n369 = n364 & n344;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n370 = n365 & n344;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n374 = n368 & n344;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n375 = n369 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n376 = n370 & n339;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n380 = n374 & n339;
  assign n383 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n384 = n383[5]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n387 = fpcr[13]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n391 = n416 ? 1'b1 : n351;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n393 = n415 ? 8'b00110101 : n353;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n394 = n358 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n398 = n420 ? 1'b0 : n358;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n399 = n394 & n387;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n400 = n358 & n387;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n403 = n358 & n387;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n404 = n399 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n405 = n400 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n408 = n403 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n409 = n404 & n384;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n410 = n405 & n384;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n414 = n408 & n384;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n415 = n409 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n416 = n410 & n358;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n420 = n414 & n358;
  assign n423 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n424 = n423[4]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n427 = fpcr[12]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n431 = n456 ? 1'b1 : n391;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n433 = n455 ? 8'b00110100 : n393;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n434 = n398 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n438 = n460 ? 1'b0 : n398;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n439 = n434 & n427;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n440 = n398 & n427;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n443 = n398 & n427;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n444 = n439 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n445 = n440 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n448 = n443 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n449 = n444 & n424;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n450 = n445 & n424;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n454 = n448 & n424;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n455 = n449 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n456 = n450 & n398;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n460 = n454 & n398;
  assign n463 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n464 = n463[3]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n467 = fpcr[11]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n471 = n496 ? 1'b1 : n431;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n473 = n495 ? 8'b00110011 : n433;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n474 = n438 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n478 = n500 ? 1'b0 : n438;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n479 = n474 & n467;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n480 = n438 & n467;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n483 = n438 & n467;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n484 = n479 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n485 = n480 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n488 = n483 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n489 = n484 & n464;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n490 = n485 & n464;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n494 = n488 & n464;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n495 = n489 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n496 = n490 & n438;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n500 = n494 & n438;
  assign n503 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n504 = n503[2]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n507 = fpcr[10]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n511 = n536 ? 1'b1 : n471;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n513 = n535 ? 8'b00110010 : n473;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n514 = n478 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n518 = n540 ? 1'b0 : n478;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n519 = n514 & n507;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n520 = n478 & n507;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n523 = n478 & n507;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n524 = n519 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n525 = n520 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n528 = n523 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n529 = n524 & n504;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n530 = n525 & n504;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n534 = n528 & n504;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n535 = n529 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n536 = n530 & n478;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n540 = n534 & n478;
  assign n543 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n544 = n543[1]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n547 = fpcr[9]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n551 = n576 ? 1'b1 : n511;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n553 = n575 ? 8'b00110001 : n513;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n554 = n518 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n558 = n580 ? 1'b0 : n518;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n559 = n554 & n547;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n560 = n518 & n547;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n563 = n518 & n547;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n564 = n559 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n565 = n560 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n568 = n563 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n569 = n564 & n544;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n570 = n565 & n544;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n574 = n568 & n544;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n575 = n569 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n576 = n570 & n518;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n580 = n574 & n518;
  assign n583 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:358:47  */
  assign n584 = n583[0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:360:32  */
  assign n587 = fpcr[8]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n591 = n616 ? 1'b1 : n551;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n593 = n615 ? 8'b00110000 : n553;
  /* TG68K_FPU_Exception_Handler.vhd:365:29  */
  assign n594 = n558 & n558;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n599 = n594 & n587;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n600 = n558 & n587;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n604 = n599 & n558;
  /* TG68K_FPU_Exception_Handler.vhd:360:25  */
  assign n605 = n600 & n558;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n609 = n604 & n584;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n610 = n605 & n584;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n615 = n609 & n558;
  /* TG68K_FPU_Exception_Handler.vhd:358:21  */
  assign n616 = n610 & n558;
  assign n621 = {n304, n302, n307};
  /* TG68K_FPU_Exception_Handler.vhd:386:51  */
  assign n622 = fpsr_in[23:16]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:387:50  */
  assign n623 = fpsr_in[15:8]; // extract
  assign n626 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:387:64  */
  assign n627 = n623 | n626;
  /* TG68K_FPU_Exception_Handler.vhd:388:49  */
  assign n628 = fpsr_in[7:0]; // extract
  assign n630 = {n288, n248, n260, n211, n266, 3'b000};
  /* TG68K_FPU_Exception_Handler.vhd:388:62  */
  assign n631 = n628 | n630;
  assign n634 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:390:62  */
  assign n635 = n634[7]; // extract
  assign n638 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:390:92  */
  assign n639 = n638[6]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:390:66  */
  assign n640 = n635 | n639;
  assign n643 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:391:60  */
  assign n644 = n643[5]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:390:96  */
  assign n645 = n640 | n644;
  assign n648 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:391:90  */
  assign n649 = n648[4]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:391:64  */
  assign n650 = n645 | n649;
  assign n653 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:392:60  */
  assign n654 = n653[3]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:391:94  */
  assign n655 = n650 | n654;
  assign n658 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:392:90  */
  assign n659 = n658[2]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:392:64  */
  assign n660 = n655 | n659;
  assign n663 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:393:60  */
  assign n664 = n663[1]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:392:94  */
  assign n665 = n660 | n664;
  assign n668 = {1'b0, n287, n195, n246, n258, n209, n264, 1'b0};
  /* TG68K_FPU_Exception_Handler.vhd:393:90  */
  assign n669 = n668[0]; // extract
  /* TG68K_FPU_Exception_Handler.vhd:393:64  */
  assign n670 = n665 | n669;
  /* TG68K_FPU_Exception_Handler.vhd:208:13  */
  assign n672 = operation_valid ? n285 : operation_result;
  assign n673 = {n621, n622, n627, n631};
  /* TG68K_FPU_Exception_Handler.vhd:208:13  */
  assign n674 = operation_valid ? n673 : fpsr_in;
  /* TG68K_FPU_Exception_Handler.vhd:208:13  */
  assign n676 = operation_valid ? n670 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:208:13  */
  assign n679 = operation_valid ? n591 : 1'b0;
  /* TG68K_FPU_Exception_Handler.vhd:402:53  */
  assign n719 = exception_detected & exception_enabled;
  /* TG68K_FPU_Exception_Handler.vhd:172:5  */
  assign n877 = ~reset;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  assign n878 = n877 ? n674 : fpsr_work;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk)
    n879 <= n878;
  /* TG68K_FPU_Exception_Handler.vhd:172:5  */
  assign n883 = ~reset;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  assign n884 = n883 ? n676 : exception_detected;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk)
    n885 <= n884;
  /* TG68K_FPU_Exception_Handler.vhd:172:5  */
  assign n886 = ~reset;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  assign n887 = n886 ? n679 : exception_enabled;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk)
    n888 <= n887;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n889 <= 32'b00000000000000000000000000000000;
    else
      n889 <= fpsr_work;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n890 <= 1'b0;
    else
      n890 <= n719;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  assign n891 = operation_valid ? n593 : n892;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n892 <= 8'b00000000;
    else
      n892 <= n891;
  /* TG68K_FPU_Exception_Handler.vhd:196:9  */
  always @(posedge clk or posedge reset)
    if (reset)
      n893 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n893 <= n672;
endmodule

