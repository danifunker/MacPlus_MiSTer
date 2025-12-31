module TG68K_FPU_PackedDecimal
  (input  clk,
   input  nReset,
   input  clkena,
   input  start_conversion,
   input  packed_to_extended,
   input  [6:0] k_factor,
   input  [79:0] extended_in,
   input  [95:0] packed_in,
   output conversion_done,
   output conversion_valid,
   output [79:0] extended_out,
   output [95:0] packed_out,
   output overflow,
   output inexact,
   output invalid);
  reg [2:0] packed_state;
  wire [67:0] bcd_digits;
  wire [11:0] bcd_exponent;
  wire [63:0] binary_mantissa;
  wire [10:0] decimal_exponent;
  wire [127:0] work_mantissa;
  wire [31:0] work_exponent;
  wire result_sign;
  wire exp_sign;
  wire [5:0] cycle_count;
  reg [127:0] packed_conversion_temp_mantissa;
  wire n13;
  wire [2:0] n16;
  wire n18;
  wire n19;
  wire n20;
  wire [11:0] n21;
  wire [67:0] n22;
  wire [3:0] n23;
  wire n25;
  wire n28;
  wire [3:0] n30;
  wire n32;
  wire n34;
  wire [3:0] n35;
  wire n37;
  wire n39;
  wire [3:0] n40;
  wire n42;
  wire n44;
  wire [3:0] n45;
  wire n47;
  wire n49;
  wire [3:0] n50;
  wire n52;
  wire n54;
  wire [3:0] n55;
  wire n57;
  wire n59;
  wire [3:0] n60;
  wire n62;
  wire n64;
  wire [3:0] n65;
  wire n67;
  wire n69;
  wire [3:0] n70;
  wire n72;
  wire n74;
  wire [3:0] n75;
  wire n77;
  wire n79;
  wire [3:0] n80;
  wire n82;
  wire n84;
  wire [3:0] n85;
  wire n87;
  wire n89;
  wire [3:0] n90;
  wire n92;
  wire n94;
  wire [3:0] n95;
  wire n97;
  wire n99;
  wire [3:0] n100;
  wire n102;
  wire n104;
  wire [3:0] n105;
  wire n107;
  wire n109;
  wire [3:0] n110;
  wire n112;
  wire n114;
  wire [3:0] n115;
  wire n117;
  wire n119;
  wire [3:0] n120;
  wire n122;
  wire n124;
  wire n125;
  wire [14:0] n126;
  wire [30:0] n127;
  wire [31:0] n128;
  wire [31:0] n130;
  wire [63:0] n131;
  wire [14:0] n133;
  wire n135;
  wire n136;
  wire [62:0] n137;
  wire n139;
  wire n140;
  wire [95:0] n159;
  wire n161;
  wire n163;
  wire [2:0] n165;
  wire [67:0] n166;
  wire [67:0] n167;
  wire [11:0] n169;
  wire [78:0] n170;
  wire n172;
  wire [95:0] n174;
  wire [2:0] n177;
  wire [95:0] n178;
  wire n179;
  wire n180;
  wire [2:0] n181;
  wire n182;
  wire n183;
  wire [95:0] n184;
  wire n185;
  wire n186;
  wire [2:0] n188;
  wire [67:0] n189;
  wire [11:0] n190;
  wire [127:0] n191;
  wire [127:0] n192;
  wire [31:0] n193;
  wire n194;
  wire n195;
  wire n197;
  wire [31:0] n198;
  wire n200;
  wire [63:0] n202;
  wire [127:0] n204;
  wire [31:0] n205;
  wire n207;
  wire [3:0] n208;
  wire [30:0] n209;
  wire [31:0] n210;
  wire n212;
  wire [3:0] n213;
  wire [30:0] n214;
  wire [31:0] n215;
  wire n217;
  wire [3:0] n218;
  wire [30:0] n219;
  wire [31:0] n220;
  wire n222;
  wire [3:0] n223;
  wire [30:0] n224;
  wire [31:0] n225;
  wire n227;
  wire [3:0] n228;
  wire [30:0] n229;
  wire [31:0] n230;
  wire n232;
  wire [3:0] n233;
  wire [30:0] n234;
  wire [31:0] n235;
  wire n237;
  wire [3:0] n238;
  wire [30:0] n239;
  wire [31:0] n240;
  wire n242;
  wire [3:0] n243;
  wire [30:0] n244;
  wire [31:0] n245;
  wire n247;
  wire [3:0] n248;
  wire [30:0] n249;
  wire [31:0] n250;
  wire n252;
  wire [3:0] n253;
  wire [30:0] n254;
  wire [31:0] n255;
  wire n257;
  wire [3:0] n258;
  wire [30:0] n259;
  wire [31:0] n260;
  wire n262;
  wire [3:0] n263;
  wire [30:0] n264;
  wire [31:0] n265;
  wire n267;
  wire [3:0] n268;
  wire [30:0] n269;
  wire [31:0] n270;
  wire n272;
  wire [3:0] n273;
  wire [30:0] n274;
  wire [31:0] n275;
  wire n277;
  wire [3:0] n278;
  wire [30:0] n279;
  wire [31:0] n280;
  wire n282;
  wire [3:0] n283;
  wire [30:0] n284;
  wire [31:0] n285;
  wire n287;
  wire [3:0] n288;
  wire [30:0] n289;
  wire [31:0] n290;
  wire n292;
  wire [16:0] n293;
  reg [31:0] n295;
  wire [255:0] n296;
  wire [255:0] n298;
  wire [127:0] n299;
  wire [30:0] n300;
  wire [127:0] n301;
  wire [127:0] n302;
  wire [31:0] n303;
  wire [31:0] n305;
  wire [5:0] n306;
  wire [3:0] n315;
  wire [30:0] n316;
  wire [31:0] n317;
  wire [3:0] n319;
  wire [30:0] n320;
  wire [31:0] n321;
  wire [3:0] n323;
  wire [30:0] n324;
  wire [31:0] n325;
  wire n328;
  wire n330;
  wire n331;
  wire n333;
  wire n334;
  wire n338;
  wire [31:0] n344;
  wire [31:0] n346;
  wire [31:0] n348;
  wire [31:0] n349;
  wire [31:0] n350;
  wire [31:0] n355;
  wire [31:0] n356;
  wire [31:0] n357;
  wire [31:0] n358;
  wire [10:0] n359;
  wire [3:0] n368;
  wire [30:0] n369;
  wire [31:0] n370;
  wire [3:0] n372;
  wire [30:0] n373;
  wire [31:0] n374;
  wire [3:0] n376;
  wire [30:0] n377;
  wire [31:0] n378;
  wire n381;
  wire n383;
  wire n384;
  wire n386;
  wire n387;
  wire n391;
  wire [31:0] n397;
  wire [31:0] n399;
  wire [31:0] n401;
  wire [31:0] n402;
  wire [31:0] n403;
  wire [31:0] n408;
  wire [31:0] n409;
  wire [31:0] n410;
  wire [10:0] n411;
  wire [10:0] n412;
  wire [63:0] n413;
  wire [2:0] n415;
  wire [63:0] n416;
  wire [10:0] n417;
  wire [5:0] n419;
  wire [127:0] n420;
  wire n423;
  wire [31:0] n424;
  wire n426;
  wire n428;
  wire [31:0] n430;
  wire [31:0] n432;
  wire [10:0] n433;
  wire [31:0] n435;
  wire [31:0] n437;
  wire [31:0] n438;
  wire [10:0] n439;
  wire [10:0] n440;
  wire n443;
  wire [67:0] n445;
  wire [10:0] n446;
  wire n447;
  wire [127:0] n448;
  wire [31:0] n449;
  wire n451;
  wire [3:0] n452;
  wire [3:0] n454;
  wire n456;
  wire [3:0] n457;
  wire [3:0] n459;
  wire n461;
  wire [3:0] n462;
  wire [3:0] n464;
  wire n466;
  wire [3:0] n467;
  wire [3:0] n469;
  wire n471;
  wire [3:0] n472;
  wire [3:0] n474;
  wire n476;
  wire [3:0] n477;
  wire [3:0] n479;
  wire n481;
  wire [3:0] n482;
  wire [3:0] n484;
  wire n486;
  wire [3:0] n487;
  wire [3:0] n489;
  wire n491;
  wire [3:0] n492;
  wire [3:0] n494;
  wire n496;
  wire [3:0] n497;
  wire [3:0] n499;
  wire n501;
  wire [3:0] n502;
  wire [3:0] n504;
  wire n506;
  wire [3:0] n507;
  wire [3:0] n509;
  wire n511;
  wire [3:0] n512;
  wire [3:0] n514;
  wire n516;
  wire [3:0] n517;
  wire [3:0] n519;
  wire n521;
  wire [3:0] n522;
  wire [3:0] n524;
  wire n526;
  wire [3:0] n527;
  wire [3:0] n529;
  wire n531;
  wire [3:0] n532;
  wire [3:0] n534;
  wire n536;
  wire [16:0] n537;
  wire [3:0] n538;
  reg [3:0] n539;
  wire [3:0] n540;
  reg [3:0] n541;
  wire [3:0] n542;
  reg [3:0] n543;
  wire [3:0] n544;
  reg [3:0] n545;
  wire [3:0] n546;
  reg [3:0] n547;
  wire [3:0] n548;
  reg [3:0] n549;
  wire [3:0] n550;
  reg [3:0] n551;
  wire [3:0] n552;
  reg [3:0] n553;
  wire [3:0] n554;
  reg [3:0] n555;
  wire [3:0] n556;
  reg [3:0] n557;
  wire [3:0] n558;
  reg [3:0] n559;
  wire [3:0] n560;
  reg [3:0] n561;
  wire [3:0] n562;
  reg [3:0] n563;
  wire [3:0] n564;
  reg [3:0] n565;
  wire [3:0] n566;
  reg [3:0] n567;
  wire [3:0] n568;
  reg [3:0] n569;
  wire [3:0] n570;
  reg [3:0] n571;
  wire [31:0] n572;
  wire [31:0] n574;
  wire [5:0] n575;
  wire [31:0] n576;
  wire [31:0] n577;
  wire [31:0] n578;
  wire [10:0] n579;
  wire [31:0] n580;
  wire n582;
  wire [31:0] n584;
  wire [31:0] n585;
  wire [31:0] n592;
  wire [30:0] n593;
  wire [3:0] n594;
  wire [31:0] n598;
  wire [31:0] n600;
  wire [30:0] n601;
  wire [3:0] n602;
  wire [31:0] n605;
  wire [31:0] n607;
  wire [30:0] n608;
  wire [3:0] n609;
  wire [11:0] n610;
  wire [31:0] n612;
  wire [31:0] n619;
  wire [30:0] n620;
  wire [3:0] n621;
  wire [31:0] n625;
  wire [31:0] n627;
  wire [30:0] n628;
  wire [3:0] n629;
  wire [31:0] n632;
  wire [31:0] n634;
  wire [30:0] n635;
  wire [3:0] n636;
  wire [11:0] n637;
  wire [11:0] n638;
  wire n641;
  wire n643;
  wire [2:0] n645;
  wire [67:0] n646;
  wire [67:0] n647;
  wire [11:0] n648;
  wire [10:0] n649;
  wire n650;
  wire [5:0] n651;
  wire n653;
  wire n655;
  wire [31:0] n656;
  wire [31:0] n658;
  wire [31:0] n660;
  wire [31:0] n662;
  wire n664;
  wire [79:0] n666;
  wire n668;
  wire [15:0] n670;
  wire [16:0] n672;
  wire [79:0] n674;
  wire [30:0] n675;
  wire [14:0] n676;
  wire [15:0] n677;
  wire [79:0] n678;
  wire [79:0] n679;
  wire n681;
  wire [79:0] n682;
  wire n683;
  wire [79:0] n685;
  wire n686;
  wire n689;
  wire n691;
  wire n692;
  wire [1:0] n693;
  wire [3:0] n695;
  wire [15:0] n696;
  wire [16:0] n698;
  wire [27:0] n700;
  wire [95:0] n701;
  wire [95:0] n702;
  wire n704;
  wire [6:0] n705;
  reg n709;
  reg n713;
  reg [79:0] n715;
  reg [95:0] n717;
  reg n720;
  reg n724;
  reg n727;
  reg [2:0] n732;
  reg [67:0] n734;
  reg [11:0] n736;
  reg [63:0] n738;
  reg [10:0] n740;
  reg [127:0] n742;
  reg [31:0] n744;
  reg n746;
  reg n748;
  reg [5:0] n751;
  reg [127:0] n753;
  wire n828;
  wire n829;
  wire [127:0] n830;
  reg [127:0] n831;
  wire [2:0] n840;
  reg [2:0] n841;
  wire n842;
  wire n843;
  wire [67:0] n844;
  reg [67:0] n845;
  wire n846;
  wire n847;
  wire [11:0] n848;
  reg [11:0] n849;
  wire n850;
  wire n851;
  wire [63:0] n852;
  reg [63:0] n853;
  wire n855;
  wire n856;
  wire [10:0] n857;
  reg [10:0] n858;
  wire n859;
  wire n860;
  wire [127:0] n861;
  reg [127:0] n862;
  wire n863;
  wire n864;
  wire [31:0] n865;
  reg [31:0] n866;
  wire n867;
  wire n868;
  wire n869;
  reg n870;
  wire n871;
  wire n872;
  wire n873;
  reg n874;
  wire [5:0] n875;
  reg [5:0] n876;
  wire n877;
  reg n878;
  wire n879;
  reg n880;
  wire [79:0] n881;
  reg [79:0] n882;
  wire [95:0] n883;
  reg [95:0] n884;
  wire n885;
  reg n886;
  wire n887;
  reg n888;
  wire n889;
  reg n890;
  assign conversion_done = n878; //(module output)
  assign conversion_valid = n880; //(module output)
  assign extended_out = n882; //(module output)
  assign packed_out = n884; //(module output)
  assign overflow = n886; //(module output)
  assign inexact = n888; //(module output)
  assign invalid = n890; //(module output)
  /* TG68K_FPU_PackedDecimal.vhd:78:12  */
  always @*
    packed_state = n841; // (isignal)
  initial
    packed_state = 3'b000;
  /* TG68K_FPU_PackedDecimal.vhd:85:12  */
  assign bcd_digits = n845; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:86:12  */
  assign bcd_exponent = n849; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:87:12  */
  assign binary_mantissa = n853; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:89:12  */
  assign decimal_exponent = n858; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:92:12  */
  assign work_mantissa = n862; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:93:12  */
  assign work_exponent = n866; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:94:12  */
  assign result_sign = n870; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:95:12  */
  assign exp_sign = n874; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:123:12  */
  assign cycle_count = n876; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:128:18  */
  always @*
    packed_conversion_temp_mantissa = n831; // (isignal)
  initial
    packed_conversion_temp_mantissa = 128'bX;
  /* TG68K_FPU_PackedDecimal.vhd:133:19  */
  assign n13 = ~nReset;
  /* TG68K_FPU_PackedDecimal.vhd:155:25  */
  assign n16 = start_conversion ? 3'b001 : packed_state;
  /* TG68K_FPU_PackedDecimal.vhd:147:21  */
  assign n18 = packed_state == 3'b000;
  /* TG68K_FPU_PackedDecimal.vhd:163:53  */
  assign n19 = packed_in[95]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:164:50  */
  assign n20 = packed_in[94]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:165:54  */
  assign n21 = packed_in[91:80]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:166:52  */
  assign n22 = packed_in[67:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n23 = bcd_digits[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n25 = $unsigned(n23) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n28 = n25 ? 1'b1 : 1'b0;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n30 = bcd_digits[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n32 = $unsigned(n30) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n34 = n32 ? 1'b1 : n28;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n35 = bcd_digits[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n37 = $unsigned(n35) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n39 = n37 ? 1'b1 : n34;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n40 = bcd_digits[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n42 = $unsigned(n40) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n44 = n42 ? 1'b1 : n39;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n45 = bcd_digits[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n47 = $unsigned(n45) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n49 = n47 ? 1'b1 : n44;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n50 = bcd_digits[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n52 = $unsigned(n50) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n54 = n52 ? 1'b1 : n49;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n55 = bcd_digits[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n57 = $unsigned(n55) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n59 = n57 ? 1'b1 : n54;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n60 = bcd_digits[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n62 = $unsigned(n60) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n64 = n62 ? 1'b1 : n59;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n65 = bcd_digits[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n67 = $unsigned(n65) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n69 = n67 ? 1'b1 : n64;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n70 = bcd_digits[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n72 = $unsigned(n70) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n74 = n72 ? 1'b1 : n69;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n75 = bcd_digits[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n77 = $unsigned(n75) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n79 = n77 ? 1'b1 : n74;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n80 = bcd_digits[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n82 = $unsigned(n80) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n84 = n82 ? 1'b1 : n79;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n85 = bcd_digits[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n87 = $unsigned(n85) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n89 = n87 ? 1'b1 : n84;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n90 = bcd_digits[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n92 = $unsigned(n90) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n94 = n92 ? 1'b1 : n89;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n95 = bcd_digits[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n97 = $unsigned(n95) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n99 = n97 ? 1'b1 : n94;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n100 = bcd_digits[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n102 = $unsigned(n100) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n104 = n102 ? 1'b1 : n99;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n105 = bcd_digits[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n107 = $unsigned(n105) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n109 = n107 ? 1'b1 : n104;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n110 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n112 = $unsigned(n110) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n114 = n112 ? 1'b1 : n109;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n115 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n117 = $unsigned(n115) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n119 = n117 ? 1'b1 : n114;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n120 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n122 = $unsigned(n120) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n124 = n122 ? 1'b1 : n119;
  /* TG68K_FPU_PackedDecimal.vhd:187:55  */
  assign n125 = extended_in[79]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:188:77  */
  assign n126 = extended_in[78:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:188:46  */
  assign n127 = {16'b0, n126};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:188:94  */
  assign n128 = {1'b0, n127};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:188:94  */
  assign n130 = n128 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:189:70  */
  assign n131 = extended_in[63:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:193:43  */
  assign n133 = extended_in[78:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:193:58  */
  assign n135 = n133 == 15'b111111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:195:47  */
  assign n136 = extended_in[63]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:195:73  */
  assign n137 = extended_in[62:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:195:87  */
  assign n139 = n137 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:195:58  */
  assign n140 = n139 & n136;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n159 = n140 ? n884 : 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n161 = n179 ? 1'b1 : n886;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n163 = n140 ? n890 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n165 = n140 ? packed_state : 3'b110;
  assign n166 = {4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001};
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n167 = n182 ? n166 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n169 = n183 ? 12'b100110011001 : bcd_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:209:46  */
  assign n170 = extended_in[78:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:209:60  */
  assign n172 = n170 == 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:209:29  */
  assign n174 = n172 ? 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n884;
  /* TG68K_FPU_PackedDecimal.vhd:209:29  */
  assign n177 = n172 ? 3'b110 : 3'b011;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n178 = n135 ? n159 : n174;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n179 = n140 & n135;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n180 = n135 ? n163 : n890;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n181 = n135 ? n165 : n177;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n182 = n140 & n135;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n183 = n140 & n135;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n184 = packed_to_extended ? n884 : n178;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n185 = packed_to_extended ? n886 : n161;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n186 = packed_to_extended ? n124 : n180;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n188 = packed_to_extended ? 3'b010 : n181;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n189 = packed_to_extended ? n22 : n167;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n190 = packed_to_extended ? n21 : n169;
  assign n191 = {64'b0000000000000000000000000000000000000000000000000000000000000000, n131};
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n192 = packed_to_extended ? work_mantissa : n191;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n193 = packed_to_extended ? work_exponent : n130;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n194 = packed_to_extended ? n19 : n125;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n195 = packed_to_extended ? n20 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:159:21  */
  assign n197 = packed_state == 3'b001;
  /* TG68K_FPU_PackedDecimal.vhd:221:40  */
  assign n198 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:221:40  */
  assign n200 = n198 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:221:25  */
  assign n202 = n200 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : binary_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:221:25  */
  assign n204 = n200 ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:226:40  */
  assign n205 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:226:40  */
  assign n207 = $signed(n205) < $signed(32'b00000000000000000000000000010001);
  /* TG68K_FPU_PackedDecimal.vhd:229:89  */
  assign n208 = bcd_digits[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:229:59  */
  assign n209 = {27'b0, n208};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:229:44  */
  assign n210 = {1'b0, n209};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:229:33  */
  assign n212 = cycle_count == 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:230:89  */
  assign n213 = bcd_digits[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:230:59  */
  assign n214 = {27'b0, n213};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:230:44  */
  assign n215 = {1'b0, n214};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:230:33  */
  assign n217 = cycle_count == 6'b000001;
  /* TG68K_FPU_PackedDecimal.vhd:231:89  */
  assign n218 = bcd_digits[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:231:59  */
  assign n219 = {27'b0, n218};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:231:44  */
  assign n220 = {1'b0, n219};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:231:33  */
  assign n222 = cycle_count == 6'b000010;
  /* TG68K_FPU_PackedDecimal.vhd:232:89  */
  assign n223 = bcd_digits[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:232:59  */
  assign n224 = {27'b0, n223};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:232:44  */
  assign n225 = {1'b0, n224};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:232:33  */
  assign n227 = cycle_count == 6'b000011;
  /* TG68K_FPU_PackedDecimal.vhd:233:89  */
  assign n228 = bcd_digits[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:233:59  */
  assign n229 = {27'b0, n228};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:233:44  */
  assign n230 = {1'b0, n229};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:233:33  */
  assign n232 = cycle_count == 6'b000100;
  /* TG68K_FPU_PackedDecimal.vhd:234:89  */
  assign n233 = bcd_digits[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:234:59  */
  assign n234 = {27'b0, n233};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:234:44  */
  assign n235 = {1'b0, n234};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:234:33  */
  assign n237 = cycle_count == 6'b000101;
  /* TG68K_FPU_PackedDecimal.vhd:235:89  */
  assign n238 = bcd_digits[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:235:59  */
  assign n239 = {27'b0, n238};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:235:44  */
  assign n240 = {1'b0, n239};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:235:33  */
  assign n242 = cycle_count == 6'b000110;
  /* TG68K_FPU_PackedDecimal.vhd:236:89  */
  assign n243 = bcd_digits[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:236:59  */
  assign n244 = {27'b0, n243};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:236:44  */
  assign n245 = {1'b0, n244};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:236:33  */
  assign n247 = cycle_count == 6'b000111;
  /* TG68K_FPU_PackedDecimal.vhd:237:89  */
  assign n248 = bcd_digits[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:237:59  */
  assign n249 = {27'b0, n248};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:237:44  */
  assign n250 = {1'b0, n249};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:237:33  */
  assign n252 = cycle_count == 6'b001000;
  /* TG68K_FPU_PackedDecimal.vhd:238:89  */
  assign n253 = bcd_digits[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:238:59  */
  assign n254 = {27'b0, n253};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:238:44  */
  assign n255 = {1'b0, n254};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:238:33  */
  assign n257 = cycle_count == 6'b001001;
  /* TG68K_FPU_PackedDecimal.vhd:239:89  */
  assign n258 = bcd_digits[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:239:59  */
  assign n259 = {27'b0, n258};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:239:44  */
  assign n260 = {1'b0, n259};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:239:33  */
  assign n262 = cycle_count == 6'b001010;
  /* TG68K_FPU_PackedDecimal.vhd:240:89  */
  assign n263 = bcd_digits[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:240:59  */
  assign n264 = {27'b0, n263};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:240:44  */
  assign n265 = {1'b0, n264};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:240:33  */
  assign n267 = cycle_count == 6'b001011;
  /* TG68K_FPU_PackedDecimal.vhd:241:89  */
  assign n268 = bcd_digits[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:241:59  */
  assign n269 = {27'b0, n268};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:241:44  */
  assign n270 = {1'b0, n269};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:241:33  */
  assign n272 = cycle_count == 6'b001100;
  /* TG68K_FPU_PackedDecimal.vhd:242:89  */
  assign n273 = bcd_digits[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:242:59  */
  assign n274 = {27'b0, n273};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:242:44  */
  assign n275 = {1'b0, n274};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:242:33  */
  assign n277 = cycle_count == 6'b001101;
  /* TG68K_FPU_PackedDecimal.vhd:243:89  */
  assign n278 = bcd_digits[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:243:59  */
  assign n279 = {27'b0, n278};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:243:44  */
  assign n280 = {1'b0, n279};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:243:33  */
  assign n282 = cycle_count == 6'b001110;
  /* TG68K_FPU_PackedDecimal.vhd:244:89  */
  assign n283 = bcd_digits[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:244:59  */
  assign n284 = {27'b0, n283};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:244:44  */
  assign n285 = {1'b0, n284};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:244:33  */
  assign n287 = cycle_count == 6'b001111;
  /* TG68K_FPU_PackedDecimal.vhd:245:89  */
  assign n288 = bcd_digits[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:245:59  */
  assign n289 = {27'b0, n288};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:245:44  */
  assign n290 = {1'b0, n289};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:245:33  */
  assign n292 = cycle_count == 6'b010000;
  assign n293 = {n292, n287, n282, n277, n272, n267, n262, n257, n252, n247, n242, n237, n232, n227, n222, n217, n212};
  /* TG68K_FPU_PackedDecimal.vhd:228:29  */
  always @*
    case (n293)
      17'b10000000000000000: n295 = n290;
      17'b01000000000000000: n295 = n285;
      17'b00100000000000000: n295 = n280;
      17'b00010000000000000: n295 = n275;
      17'b00001000000000000: n295 = n270;
      17'b00000100000000000: n295 = n265;
      17'b00000010000000000: n295 = n260;
      17'b00000001000000000: n295 = n255;
      17'b00000000100000000: n295 = n250;
      17'b00000000010000000: n295 = n245;
      17'b00000000001000000: n295 = n240;
      17'b00000000000100000: n295 = n235;
      17'b00000000000010000: n295 = n230;
      17'b00000000000001000: n295 = n225;
      17'b00000000000000100: n295 = n220;
      17'b00000000000000010: n295 = n215;
      17'b00000000000000001: n295 = n210;
      default: n295 = 32'b00000000000000000000000000000000;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:249:67  */
  assign n296 = {128'b0, n204};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:249:67  */
  assign n298 = $signed(n296) * $signed(256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:249:46  */
  assign n299 = n298[127:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n300 = n295[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n301 = {97'b0, n300};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n302 = n299 + n301;
  /* TG68K_FPU_PackedDecimal.vhd:250:56  */
  assign n303 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:250:56  */
  assign n305 = n303 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_PackedDecimal.vhd:250:44  */
  assign n306 = n305[5:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:101:38  */
  assign n315 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:101:15  */
  assign n316 = {27'b0, n315};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:101:9  */
  assign n317 = {1'b0, n316};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:38  */
  assign n319 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:102:15  */
  assign n320 = {27'b0, n319};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:9  */
  assign n321 = {1'b0, n320};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:38  */
  assign n323 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:103:15  */
  assign n324 = {27'b0, n323};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:9  */
  assign n325 = {1'b0, n324};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:104:15  */
  assign n328 = $signed(n317) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:25  */
  assign n330 = $signed(n321) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:19  */
  assign n331 = n328 | n330;
  /* TG68K_FPU_PackedDecimal.vhd:104:35  */
  assign n333 = $signed(n325) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:29  */
  assign n334 = n331 | n333;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n338 = n334 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n344 = n334 ? 32'b11111111111111111111111111111111 : 32'bX;
  /* TG68K_FPU_PackedDecimal.vhd:107:19  */
  assign n346 = $signed(n325) * $signed(32'b00000000000000000000000001100100); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:30  */
  assign n348 = $signed(n321) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:25  */
  assign n349 = n346 + n348;
  /* TG68K_FPU_PackedDecimal.vhd:107:35  */
  assign n350 = n349 + n317;
  /* TG68K_FPU_PackedDecimal.vhd:107:9  */
  assign n355 = n338 ? n350 : n344;
  /* TG68K_FPU_PackedDecimal.vhd:254:53  */
  assign n356 = -n355;
  /* TG68K_FPU_PackedDecimal.vhd:254:84  */
  assign n357 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:254:82  */
  assign n358 = n356 - n357;
  /* TG68K_FPU_PackedDecimal.vhd:254:53  */
  assign n359 = n358[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:101:38  */
  assign n368 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:101:15  */
  assign n369 = {27'b0, n368};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:101:9  */
  assign n370 = {1'b0, n369};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:38  */
  assign n372 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:102:15  */
  assign n373 = {27'b0, n372};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:9  */
  assign n374 = {1'b0, n373};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:38  */
  assign n376 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:103:15  */
  assign n377 = {27'b0, n376};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:9  */
  assign n378 = {1'b0, n377};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:104:15  */
  assign n381 = $signed(n370) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:25  */
  assign n383 = $signed(n374) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:19  */
  assign n384 = n381 | n383;
  /* TG68K_FPU_PackedDecimal.vhd:104:35  */
  assign n386 = $signed(n378) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:29  */
  assign n387 = n384 | n386;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n391 = n387 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n397 = n387 ? 32'b11111111111111111111111111111111 : 32'bX;
  /* TG68K_FPU_PackedDecimal.vhd:107:19  */
  assign n399 = $signed(n378) * $signed(32'b00000000000000000000000001100100); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:30  */
  assign n401 = $signed(n374) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:25  */
  assign n402 = n399 + n401;
  /* TG68K_FPU_PackedDecimal.vhd:107:35  */
  assign n403 = n402 + n370;
  /* TG68K_FPU_PackedDecimal.vhd:107:9  */
  assign n408 = n391 ? n403 : n397;
  /* TG68K_FPU_PackedDecimal.vhd:256:83  */
  assign n409 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:256:81  */
  assign n410 = n408 - n409;
  /* TG68K_FPU_PackedDecimal.vhd:256:53  */
  assign n411 = n410[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:253:29  */
  assign n412 = exp_sign ? n359 : n411;
  /* TG68K_FPU_PackedDecimal.vhd:259:78  */
  assign n413 = n204[63:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n415 = n207 ? packed_state : 3'b100;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n416 = n207 ? n202 : n413;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n417 = n207 ? decimal_exponent : n412;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n419 = n207 ? n306 : 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n420 = n207 ? n302 : n204;
  /* TG68K_FPU_PackedDecimal.vhd:218:21  */
  assign n423 = packed_state == 3'b010;
  /* TG68K_FPU_PackedDecimal.vhd:267:40  */
  assign n424 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:267:40  */
  assign n426 = n424 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:274:46  */
  assign n428 = $signed(work_exponent) > $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:275:67  */
  assign n430 = $signed(work_exponent) * $signed(32'b00000000000000000000000000000011); // smul
  /* TG68K_FPU_PackedDecimal.vhd:275:71  */
  assign n432 = $signed(n430) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:275:53  */
  assign n433 = n432[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:278:68  */
  assign n435 = $signed(work_exponent) * $signed(32'b00000000000000000000000000000011); // smul
  /* TG68K_FPU_PackedDecimal.vhd:278:72  */
  assign n437 = $signed(n435) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:278:53  */
  assign n438 = -n437;
  /* TG68K_FPU_PackedDecimal.vhd:278:53  */
  assign n439 = n438[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:274:29  */
  assign n440 = n428 ? n433 : n439;
  /* TG68K_FPU_PackedDecimal.vhd:274:29  */
  assign n443 = n428 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n445 = n426 ? 68'b00000000000000000000000000000000000000000000000000000000000000000000 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n446 = n426 ? n440 : decimal_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n447 = n426 ? n443 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n448 = n426 ? work_mantissa : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:283:40  */
  assign n449 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:283:40  */
  assign n451 = $signed(n449) < $signed(32'b00000000000000000000000000010001);
  /* TG68K_FPU_PackedDecimal.vhd:286:102  */
  assign n452 = n448[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:286:115  */
  assign n454 = n452 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:286:33  */
  assign n456 = cycle_count == 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:287:102  */
  assign n457 = n448[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:287:115  */
  assign n459 = n457 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:287:33  */
  assign n461 = cycle_count == 6'b000001;
  /* TG68K_FPU_PackedDecimal.vhd:288:102  */
  assign n462 = n448[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:288:116  */
  assign n464 = n462 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:288:33  */
  assign n466 = cycle_count == 6'b000010;
  /* TG68K_FPU_PackedDecimal.vhd:289:102  */
  assign n467 = n448[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:289:117  */
  assign n469 = n467 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:289:33  */
  assign n471 = cycle_count == 6'b000011;
  /* TG68K_FPU_PackedDecimal.vhd:290:102  */
  assign n472 = n448[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:290:117  */
  assign n474 = n472 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:290:33  */
  assign n476 = cycle_count == 6'b000100;
  /* TG68K_FPU_PackedDecimal.vhd:291:102  */
  assign n477 = n448[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:291:117  */
  assign n479 = n477 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:291:33  */
  assign n481 = cycle_count == 6'b000101;
  /* TG68K_FPU_PackedDecimal.vhd:292:102  */
  assign n482 = n448[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:292:117  */
  assign n484 = n482 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:292:33  */
  assign n486 = cycle_count == 6'b000110;
  /* TG68K_FPU_PackedDecimal.vhd:293:102  */
  assign n487 = n448[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:293:117  */
  assign n489 = n487 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:293:33  */
  assign n491 = cycle_count == 6'b000111;
  /* TG68K_FPU_PackedDecimal.vhd:294:102  */
  assign n492 = n448[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:294:117  */
  assign n494 = n492 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:294:33  */
  assign n496 = cycle_count == 6'b001000;
  /* TG68K_FPU_PackedDecimal.vhd:295:102  */
  assign n497 = n448[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:295:117  */
  assign n499 = n497 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:295:33  */
  assign n501 = cycle_count == 6'b001001;
  /* TG68K_FPU_PackedDecimal.vhd:296:102  */
  assign n502 = n448[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:296:117  */
  assign n504 = n502 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:296:33  */
  assign n506 = cycle_count == 6'b001010;
  /* TG68K_FPU_PackedDecimal.vhd:297:102  */
  assign n507 = n448[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:297:117  */
  assign n509 = n507 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:297:33  */
  assign n511 = cycle_count == 6'b001011;
  /* TG68K_FPU_PackedDecimal.vhd:298:102  */
  assign n512 = n448[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:298:117  */
  assign n514 = n512 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:298:33  */
  assign n516 = cycle_count == 6'b001100;
  /* TG68K_FPU_PackedDecimal.vhd:299:102  */
  assign n517 = n448[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:299:117  */
  assign n519 = n517 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:299:33  */
  assign n521 = cycle_count == 6'b001101;
  /* TG68K_FPU_PackedDecimal.vhd:300:102  */
  assign n522 = n448[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:300:117  */
  assign n524 = n522 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:300:33  */
  assign n526 = cycle_count == 6'b001110;
  /* TG68K_FPU_PackedDecimal.vhd:301:102  */
  assign n527 = n448[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:301:117  */
  assign n529 = n527 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:301:33  */
  assign n531 = cycle_count == 6'b001111;
  /* TG68K_FPU_PackedDecimal.vhd:302:102  */
  assign n532 = n448[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:302:117  */
  assign n534 = n532 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:302:33  */
  assign n536 = cycle_count == 6'b010000;
  assign n537 = {n536, n531, n526, n521, n516, n511, n506, n501, n496, n491, n486, n481, n476, n471, n466, n461, n456};
  assign n538 = n445[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n539 = n538;
      17'b01000000000000000: n539 = n538;
      17'b00100000000000000: n539 = n538;
      17'b00010000000000000: n539 = n538;
      17'b00001000000000000: n539 = n538;
      17'b00000100000000000: n539 = n538;
      17'b00000010000000000: n539 = n538;
      17'b00000001000000000: n539 = n538;
      17'b00000000100000000: n539 = n538;
      17'b00000000010000000: n539 = n538;
      17'b00000000001000000: n539 = n538;
      17'b00000000000100000: n539 = n538;
      17'b00000000000010000: n539 = n538;
      17'b00000000000001000: n539 = n538;
      17'b00000000000000100: n539 = n538;
      17'b00000000000000010: n539 = n538;
      17'b00000000000000001: n539 = n454;
      default: n539 = n538;
    endcase
  assign n540 = n445[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n541 = n540;
      17'b01000000000000000: n541 = n540;
      17'b00100000000000000: n541 = n540;
      17'b00010000000000000: n541 = n540;
      17'b00001000000000000: n541 = n540;
      17'b00000100000000000: n541 = n540;
      17'b00000010000000000: n541 = n540;
      17'b00000001000000000: n541 = n540;
      17'b00000000100000000: n541 = n540;
      17'b00000000010000000: n541 = n540;
      17'b00000000001000000: n541 = n540;
      17'b00000000000100000: n541 = n540;
      17'b00000000000010000: n541 = n540;
      17'b00000000000001000: n541 = n540;
      17'b00000000000000100: n541 = n540;
      17'b00000000000000010: n541 = n459;
      17'b00000000000000001: n541 = n540;
      default: n541 = n540;
    endcase
  assign n542 = n445[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n543 = n542;
      17'b01000000000000000: n543 = n542;
      17'b00100000000000000: n543 = n542;
      17'b00010000000000000: n543 = n542;
      17'b00001000000000000: n543 = n542;
      17'b00000100000000000: n543 = n542;
      17'b00000010000000000: n543 = n542;
      17'b00000001000000000: n543 = n542;
      17'b00000000100000000: n543 = n542;
      17'b00000000010000000: n543 = n542;
      17'b00000000001000000: n543 = n542;
      17'b00000000000100000: n543 = n542;
      17'b00000000000010000: n543 = n542;
      17'b00000000000001000: n543 = n542;
      17'b00000000000000100: n543 = n464;
      17'b00000000000000010: n543 = n542;
      17'b00000000000000001: n543 = n542;
      default: n543 = n542;
    endcase
  assign n544 = n445[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n545 = n544;
      17'b01000000000000000: n545 = n544;
      17'b00100000000000000: n545 = n544;
      17'b00010000000000000: n545 = n544;
      17'b00001000000000000: n545 = n544;
      17'b00000100000000000: n545 = n544;
      17'b00000010000000000: n545 = n544;
      17'b00000001000000000: n545 = n544;
      17'b00000000100000000: n545 = n544;
      17'b00000000010000000: n545 = n544;
      17'b00000000001000000: n545 = n544;
      17'b00000000000100000: n545 = n544;
      17'b00000000000010000: n545 = n544;
      17'b00000000000001000: n545 = n469;
      17'b00000000000000100: n545 = n544;
      17'b00000000000000010: n545 = n544;
      17'b00000000000000001: n545 = n544;
      default: n545 = n544;
    endcase
  assign n546 = n445[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n547 = n546;
      17'b01000000000000000: n547 = n546;
      17'b00100000000000000: n547 = n546;
      17'b00010000000000000: n547 = n546;
      17'b00001000000000000: n547 = n546;
      17'b00000100000000000: n547 = n546;
      17'b00000010000000000: n547 = n546;
      17'b00000001000000000: n547 = n546;
      17'b00000000100000000: n547 = n546;
      17'b00000000010000000: n547 = n546;
      17'b00000000001000000: n547 = n546;
      17'b00000000000100000: n547 = n546;
      17'b00000000000010000: n547 = n474;
      17'b00000000000001000: n547 = n546;
      17'b00000000000000100: n547 = n546;
      17'b00000000000000010: n547 = n546;
      17'b00000000000000001: n547 = n546;
      default: n547 = n546;
    endcase
  assign n548 = n445[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n549 = n548;
      17'b01000000000000000: n549 = n548;
      17'b00100000000000000: n549 = n548;
      17'b00010000000000000: n549 = n548;
      17'b00001000000000000: n549 = n548;
      17'b00000100000000000: n549 = n548;
      17'b00000010000000000: n549 = n548;
      17'b00000001000000000: n549 = n548;
      17'b00000000100000000: n549 = n548;
      17'b00000000010000000: n549 = n548;
      17'b00000000001000000: n549 = n548;
      17'b00000000000100000: n549 = n479;
      17'b00000000000010000: n549 = n548;
      17'b00000000000001000: n549 = n548;
      17'b00000000000000100: n549 = n548;
      17'b00000000000000010: n549 = n548;
      17'b00000000000000001: n549 = n548;
      default: n549 = n548;
    endcase
  assign n550 = n445[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n551 = n550;
      17'b01000000000000000: n551 = n550;
      17'b00100000000000000: n551 = n550;
      17'b00010000000000000: n551 = n550;
      17'b00001000000000000: n551 = n550;
      17'b00000100000000000: n551 = n550;
      17'b00000010000000000: n551 = n550;
      17'b00000001000000000: n551 = n550;
      17'b00000000100000000: n551 = n550;
      17'b00000000010000000: n551 = n550;
      17'b00000000001000000: n551 = n484;
      17'b00000000000100000: n551 = n550;
      17'b00000000000010000: n551 = n550;
      17'b00000000000001000: n551 = n550;
      17'b00000000000000100: n551 = n550;
      17'b00000000000000010: n551 = n550;
      17'b00000000000000001: n551 = n550;
      default: n551 = n550;
    endcase
  assign n552 = n445[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n553 = n552;
      17'b01000000000000000: n553 = n552;
      17'b00100000000000000: n553 = n552;
      17'b00010000000000000: n553 = n552;
      17'b00001000000000000: n553 = n552;
      17'b00000100000000000: n553 = n552;
      17'b00000010000000000: n553 = n552;
      17'b00000001000000000: n553 = n552;
      17'b00000000100000000: n553 = n552;
      17'b00000000010000000: n553 = n489;
      17'b00000000001000000: n553 = n552;
      17'b00000000000100000: n553 = n552;
      17'b00000000000010000: n553 = n552;
      17'b00000000000001000: n553 = n552;
      17'b00000000000000100: n553 = n552;
      17'b00000000000000010: n553 = n552;
      17'b00000000000000001: n553 = n552;
      default: n553 = n552;
    endcase
  assign n554 = n445[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n555 = n554;
      17'b01000000000000000: n555 = n554;
      17'b00100000000000000: n555 = n554;
      17'b00010000000000000: n555 = n554;
      17'b00001000000000000: n555 = n554;
      17'b00000100000000000: n555 = n554;
      17'b00000010000000000: n555 = n554;
      17'b00000001000000000: n555 = n554;
      17'b00000000100000000: n555 = n494;
      17'b00000000010000000: n555 = n554;
      17'b00000000001000000: n555 = n554;
      17'b00000000000100000: n555 = n554;
      17'b00000000000010000: n555 = n554;
      17'b00000000000001000: n555 = n554;
      17'b00000000000000100: n555 = n554;
      17'b00000000000000010: n555 = n554;
      17'b00000000000000001: n555 = n554;
      default: n555 = n554;
    endcase
  assign n556 = n445[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n557 = n556;
      17'b01000000000000000: n557 = n556;
      17'b00100000000000000: n557 = n556;
      17'b00010000000000000: n557 = n556;
      17'b00001000000000000: n557 = n556;
      17'b00000100000000000: n557 = n556;
      17'b00000010000000000: n557 = n556;
      17'b00000001000000000: n557 = n499;
      17'b00000000100000000: n557 = n556;
      17'b00000000010000000: n557 = n556;
      17'b00000000001000000: n557 = n556;
      17'b00000000000100000: n557 = n556;
      17'b00000000000010000: n557 = n556;
      17'b00000000000001000: n557 = n556;
      17'b00000000000000100: n557 = n556;
      17'b00000000000000010: n557 = n556;
      17'b00000000000000001: n557 = n556;
      default: n557 = n556;
    endcase
  assign n558 = n445[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n559 = n558;
      17'b01000000000000000: n559 = n558;
      17'b00100000000000000: n559 = n558;
      17'b00010000000000000: n559 = n558;
      17'b00001000000000000: n559 = n558;
      17'b00000100000000000: n559 = n558;
      17'b00000010000000000: n559 = n504;
      17'b00000001000000000: n559 = n558;
      17'b00000000100000000: n559 = n558;
      17'b00000000010000000: n559 = n558;
      17'b00000000001000000: n559 = n558;
      17'b00000000000100000: n559 = n558;
      17'b00000000000010000: n559 = n558;
      17'b00000000000001000: n559 = n558;
      17'b00000000000000100: n559 = n558;
      17'b00000000000000010: n559 = n558;
      17'b00000000000000001: n559 = n558;
      default: n559 = n558;
    endcase
  assign n560 = n445[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n561 = n560;
      17'b01000000000000000: n561 = n560;
      17'b00100000000000000: n561 = n560;
      17'b00010000000000000: n561 = n560;
      17'b00001000000000000: n561 = n560;
      17'b00000100000000000: n561 = n509;
      17'b00000010000000000: n561 = n560;
      17'b00000001000000000: n561 = n560;
      17'b00000000100000000: n561 = n560;
      17'b00000000010000000: n561 = n560;
      17'b00000000001000000: n561 = n560;
      17'b00000000000100000: n561 = n560;
      17'b00000000000010000: n561 = n560;
      17'b00000000000001000: n561 = n560;
      17'b00000000000000100: n561 = n560;
      17'b00000000000000010: n561 = n560;
      17'b00000000000000001: n561 = n560;
      default: n561 = n560;
    endcase
  assign n562 = n445[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n563 = n562;
      17'b01000000000000000: n563 = n562;
      17'b00100000000000000: n563 = n562;
      17'b00010000000000000: n563 = n562;
      17'b00001000000000000: n563 = n514;
      17'b00000100000000000: n563 = n562;
      17'b00000010000000000: n563 = n562;
      17'b00000001000000000: n563 = n562;
      17'b00000000100000000: n563 = n562;
      17'b00000000010000000: n563 = n562;
      17'b00000000001000000: n563 = n562;
      17'b00000000000100000: n563 = n562;
      17'b00000000000010000: n563 = n562;
      17'b00000000000001000: n563 = n562;
      17'b00000000000000100: n563 = n562;
      17'b00000000000000010: n563 = n562;
      17'b00000000000000001: n563 = n562;
      default: n563 = n562;
    endcase
  assign n564 = n445[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n565 = n564;
      17'b01000000000000000: n565 = n564;
      17'b00100000000000000: n565 = n564;
      17'b00010000000000000: n565 = n519;
      17'b00001000000000000: n565 = n564;
      17'b00000100000000000: n565 = n564;
      17'b00000010000000000: n565 = n564;
      17'b00000001000000000: n565 = n564;
      17'b00000000100000000: n565 = n564;
      17'b00000000010000000: n565 = n564;
      17'b00000000001000000: n565 = n564;
      17'b00000000000100000: n565 = n564;
      17'b00000000000010000: n565 = n564;
      17'b00000000000001000: n565 = n564;
      17'b00000000000000100: n565 = n564;
      17'b00000000000000010: n565 = n564;
      17'b00000000000000001: n565 = n564;
      default: n565 = n564;
    endcase
  assign n566 = n445[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n567 = n566;
      17'b01000000000000000: n567 = n566;
      17'b00100000000000000: n567 = n524;
      17'b00010000000000000: n567 = n566;
      17'b00001000000000000: n567 = n566;
      17'b00000100000000000: n567 = n566;
      17'b00000010000000000: n567 = n566;
      17'b00000001000000000: n567 = n566;
      17'b00000000100000000: n567 = n566;
      17'b00000000010000000: n567 = n566;
      17'b00000000001000000: n567 = n566;
      17'b00000000000100000: n567 = n566;
      17'b00000000000010000: n567 = n566;
      17'b00000000000001000: n567 = n566;
      17'b00000000000000100: n567 = n566;
      17'b00000000000000010: n567 = n566;
      17'b00000000000000001: n567 = n566;
      default: n567 = n566;
    endcase
  assign n568 = n445[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n569 = n568;
      17'b01000000000000000: n569 = n529;
      17'b00100000000000000: n569 = n568;
      17'b00010000000000000: n569 = n568;
      17'b00001000000000000: n569 = n568;
      17'b00000100000000000: n569 = n568;
      17'b00000010000000000: n569 = n568;
      17'b00000001000000000: n569 = n568;
      17'b00000000100000000: n569 = n568;
      17'b00000000010000000: n569 = n568;
      17'b00000000001000000: n569 = n568;
      17'b00000000000100000: n569 = n568;
      17'b00000000000010000: n569 = n568;
      17'b00000000000001000: n569 = n568;
      17'b00000000000000100: n569 = n568;
      17'b00000000000000010: n569 = n568;
      17'b00000000000000001: n569 = n568;
      default: n569 = n568;
    endcase
  assign n570 = n445[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n537)
      17'b10000000000000000: n571 = n534;
      17'b01000000000000000: n571 = n570;
      17'b00100000000000000: n571 = n570;
      17'b00010000000000000: n571 = n570;
      17'b00001000000000000: n571 = n570;
      17'b00000100000000000: n571 = n570;
      17'b00000010000000000: n571 = n570;
      17'b00000001000000000: n571 = n570;
      17'b00000000100000000: n571 = n570;
      17'b00000000010000000: n571 = n570;
      17'b00000000001000000: n571 = n570;
      17'b00000000000100000: n571 = n570;
      17'b00000000000010000: n571 = n570;
      17'b00000000000001000: n571 = n570;
      17'b00000000000000100: n571 = n570;
      17'b00000000000000010: n571 = n570;
      17'b00000000000000001: n571 = n570;
      default: n571 = n570;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:305:56  */
  assign n572 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:305:56  */
  assign n574 = n572 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_PackedDecimal.vhd:305:44  */
  assign n575 = n574[5:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:308:66  */
  assign n576 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:308:68  */
  assign n577 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:308:66  */
  assign n578 = n576 + n577;
  /* TG68K_FPU_PackedDecimal.vhd:308:49  */
  assign n579 = n578[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:311:49  */
  assign n580 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:311:49  */
  assign n582 = $signed(n580) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:313:63  */
  assign n584 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:313:63  */
  assign n585 = -n584;
  /* TG68K_FPU_PackedDecimal.vhd:114:65  */
  assign n592 = n585 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:114:60  */
  assign n593 = n592[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:114:48  */
  assign n594 = n593[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:115:22  */
  assign n598 = $signed(n585) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:116:65  */
  assign n600 = n598 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:116:60  */
  assign n601 = n600[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:116:48  */
  assign n602 = n601[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:117:22  */
  assign n605 = $signed(n598) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:118:66  */
  assign n607 = n605 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:118:61  */
  assign n608 = n607[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:118:49  */
  assign n609 = n608[3:0];  // trunc
  assign n610 = {n609, n602, n594};
  /* TG68K_FPU_PackedDecimal.vhd:316:63  */
  assign n612 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:114:65  */
  assign n619 = n612 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:114:60  */
  assign n620 = n619[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:114:48  */
  assign n621 = n620[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:115:22  */
  assign n625 = $signed(n612) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:116:65  */
  assign n627 = n625 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:116:60  */
  assign n628 = n627[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:116:48  */
  assign n629 = n628[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:117:22  */
  assign n632 = $signed(n625) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:118:66  */
  assign n634 = n632 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:118:61  */
  assign n635 = n634[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:118:49  */
  assign n636 = n635[3:0];  // trunc
  assign n637 = {n636, n629, n621};
  /* TG68K_FPU_PackedDecimal.vhd:311:29  */
  assign n638 = n582 ? n610 : n637;
  /* TG68K_FPU_PackedDecimal.vhd:311:29  */
  assign n641 = n582 ? 1'b1 : 1'b0;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n643 = n451 ? n888 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n645 = n451 ? packed_state : 3'b110;
  assign n646 = {n571, n569, n567, n565, n563, n561, n559, n557, n555, n553, n551, n549, n547, n545, n543, n541, n539};
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n647 = n451 ? n646 : n445;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n648 = n451 ? bcd_exponent : n638;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n649 = n451 ? n446 : n579;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n650 = n451 ? n447 : n641;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n651 = n451 ? n575 : cycle_count;
  /* TG68K_FPU_PackedDecimal.vhd:264:21  */
  assign n653 = packed_state == 3'b011;
  /* TG68K_FPU_PackedDecimal.vhd:325:44  */
  assign n655 = binary_mantissa == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:331:58  */
  assign n656 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:331:58  */
  assign n658 = $signed(n656) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:331:63  */
  assign n660 = $signed(n658) / $signed(32'b00000000000000000000000000000011); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:331:67  */
  assign n662 = n660 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:333:41  */
  assign n664 = $signed(n662) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:335:61  */
  assign n666 = {result_sign, 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_PackedDecimal.vhd:336:44  */
  assign n668 = $signed(n662) > $signed(32'b00000000000000000111111111111111);
  /* TG68K_FPU_PackedDecimal.vhd:339:61  */
  assign n670 = {result_sign, 15'b111111111111111};
  /* TG68K_FPU_PackedDecimal.vhd:339:81  */
  assign n672 = {n670, 1'b1};
  /* TG68K_FPU_PackedDecimal.vhd:339:87  */
  assign n674 = {n672, 63'b000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_PackedDecimal.vhd:342:92  */
  assign n675 = n662[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:342:80  */
  assign n676 = n675[14:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:342:61  */
  assign n677 = {result_sign, n676};
  /* TG68K_FPU_PackedDecimal.vhd:342:107  */
  assign n678 = {n677, binary_mantissa};
  /* TG68K_FPU_PackedDecimal.vhd:336:29  */
  assign n679 = n668 ? n674 : n678;
  /* TG68K_FPU_PackedDecimal.vhd:336:29  */
  assign n681 = n668 ? 1'b1 : n886;
  /* TG68K_FPU_PackedDecimal.vhd:333:29  */
  assign n682 = n664 ? n666 : n679;
  /* TG68K_FPU_PackedDecimal.vhd:333:29  */
  assign n683 = n664 ? n886 : n681;
  /* TG68K_FPU_PackedDecimal.vhd:325:25  */
  assign n685 = n655 ? 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000 : n682;
  /* TG68K_FPU_PackedDecimal.vhd:325:25  */
  assign n686 = n655 ? n886 : n683;
  /* TG68K_FPU_PackedDecimal.vhd:323:21  */
  assign n689 = packed_state == 3'b100;
  /* TG68K_FPU_PackedDecimal.vhd:348:21  */
  assign n691 = packed_state == 3'b101;
  /* TG68K_FPU_PackedDecimal.vhd:354:47  */
  assign n692 = ~packed_to_extended;
  /* TG68K_FPU_PackedDecimal.vhd:356:55  */
  assign n693 = {result_sign, exp_sign};
  /* TG68K_FPU_PackedDecimal.vhd:356:66  */
  assign n695 = {n693, 2'b00};
  /* TG68K_FPU_PackedDecimal.vhd:356:73  */
  assign n696 = {n695, bcd_exponent};
  /* TG68K_FPU_PackedDecimal.vhd:356:88  */
  assign n698 = {n696, 1'b0};
  /* TG68K_FPU_PackedDecimal.vhd:356:94  */
  assign n700 = {n698, 11'b00000000000};
  /* TG68K_FPU_PackedDecimal.vhd:356:110  */
  assign n701 = {n700, bcd_digits};
  /* TG68K_FPU_PackedDecimal.vhd:354:25  */
  assign n702 = n692 ? n701 : n884;
  /* TG68K_FPU_PackedDecimal.vhd:353:21  */
  assign n704 = packed_state == 3'b110;
  assign n705 = {n704, n691, n689, n653, n423, n197, n18};
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n709 = 1'b1;
      7'b0100000: n709 = n878;
      7'b0010000: n709 = n878;
      7'b0001000: n709 = n878;
      7'b0000100: n709 = n878;
      7'b0000010: n709 = n878;
      7'b0000001: n709 = 1'b0;
      default: n709 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n713 = 1'b1;
      7'b0100000: n713 = n880;
      7'b0010000: n713 = n880;
      7'b0001000: n713 = n880;
      7'b0000100: n713 = n880;
      7'b0000010: n713 = n880;
      7'b0000001: n713 = 1'b0;
      default: n713 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n715 = n882;
      7'b0100000: n715 = n882;
      7'b0010000: n715 = n685;
      7'b0001000: n715 = n882;
      7'b0000100: n715 = n882;
      7'b0000010: n715 = n882;
      7'b0000001: n715 = n882;
      default: n715 = 80'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n717 = n702;
      7'b0100000: n717 = n884;
      7'b0010000: n717 = n884;
      7'b0001000: n717 = n884;
      7'b0000100: n717 = n884;
      7'b0000010: n717 = n184;
      7'b0000001: n717 = n884;
      default: n717 = 96'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n720 = n886;
      7'b0100000: n720 = n886;
      7'b0010000: n720 = n686;
      7'b0001000: n720 = n886;
      7'b0000100: n720 = n886;
      7'b0000010: n720 = n185;
      7'b0000001: n720 = 1'b0;
      default: n720 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n724 = n888;
      7'b0100000: n724 = n888;
      7'b0010000: n724 = 1'b1;
      7'b0001000: n724 = n643;
      7'b0000100: n724 = n888;
      7'b0000010: n724 = n888;
      7'b0000001: n724 = 1'b0;
      default: n724 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n727 = n890;
      7'b0100000: n727 = n890;
      7'b0010000: n727 = n890;
      7'b0001000: n727 = n890;
      7'b0000100: n727 = n890;
      7'b0000010: n727 = n186;
      7'b0000001: n727 = 1'b0;
      default: n727 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n732 = 3'b000;
      7'b0100000: n732 = 3'b110;
      7'b0010000: n732 = 3'b110;
      7'b0001000: n732 = n645;
      7'b0000100: n732 = n415;
      7'b0000010: n732 = n188;
      7'b0000001: n732 = n16;
      default: n732 = 3'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n734 = bcd_digits;
      7'b0100000: n734 = bcd_digits;
      7'b0010000: n734 = bcd_digits;
      7'b0001000: n734 = n647;
      7'b0000100: n734 = bcd_digits;
      7'b0000010: n734 = n189;
      7'b0000001: n734 = bcd_digits;
      default: n734 = 68'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n736 = bcd_exponent;
      7'b0100000: n736 = bcd_exponent;
      7'b0010000: n736 = bcd_exponent;
      7'b0001000: n736 = n648;
      7'b0000100: n736 = bcd_exponent;
      7'b0000010: n736 = n190;
      7'b0000001: n736 = bcd_exponent;
      default: n736 = 12'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n738 = binary_mantissa;
      7'b0100000: n738 = binary_mantissa;
      7'b0010000: n738 = binary_mantissa;
      7'b0001000: n738 = binary_mantissa;
      7'b0000100: n738 = n416;
      7'b0000010: n738 = binary_mantissa;
      7'b0000001: n738 = binary_mantissa;
      default: n738 = 64'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n740 = decimal_exponent;
      7'b0100000: n740 = decimal_exponent;
      7'b0010000: n740 = decimal_exponent;
      7'b0001000: n740 = n649;
      7'b0000100: n740 = n417;
      7'b0000010: n740 = decimal_exponent;
      7'b0000001: n740 = decimal_exponent;
      default: n740 = 11'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n742 = work_mantissa;
      7'b0100000: n742 = work_mantissa;
      7'b0010000: n742 = work_mantissa;
      7'b0001000: n742 = work_mantissa;
      7'b0000100: n742 = work_mantissa;
      7'b0000010: n742 = n192;
      7'b0000001: n742 = work_mantissa;
      default: n742 = 128'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n744 = work_exponent;
      7'b0100000: n744 = work_exponent;
      7'b0010000: n744 = work_exponent;
      7'b0001000: n744 = work_exponent;
      7'b0000100: n744 = work_exponent;
      7'b0000010: n744 = n193;
      7'b0000001: n744 = work_exponent;
      default: n744 = 32'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n746 = result_sign;
      7'b0100000: n746 = result_sign;
      7'b0010000: n746 = result_sign;
      7'b0001000: n746 = result_sign;
      7'b0000100: n746 = result_sign;
      7'b0000010: n746 = n194;
      7'b0000001: n746 = result_sign;
      default: n746 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n748 = exp_sign;
      7'b0100000: n748 = exp_sign;
      7'b0010000: n748 = exp_sign;
      7'b0001000: n748 = n650;
      7'b0000100: n748 = exp_sign;
      7'b0000010: n748 = n195;
      7'b0000001: n748 = exp_sign;
      default: n748 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n751 = cycle_count;
      7'b0100000: n751 = cycle_count;
      7'b0010000: n751 = cycle_count;
      7'b0001000: n751 = n651;
      7'b0000100: n751 = n419;
      7'b0000010: n751 = cycle_count;
      7'b0000001: n751 = 6'b000000;
      default: n751 = 6'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n705)
      7'b1000000: n753 = packed_conversion_temp_mantissa;
      7'b0100000: n753 = packed_conversion_temp_mantissa;
      7'b0010000: n753 = packed_conversion_temp_mantissa;
      7'b0001000: n753 = n448;
      7'b0000100: n753 = n420;
      7'b0000010: n753 = packed_conversion_temp_mantissa;
      7'b0000001: n753 = packed_conversion_temp_mantissa;
      default: n753 = 128'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n828 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n829 = clkena & n828;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n830 = n829 ? n753 : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n831 <= n830;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n840 = clkena ? n732 : packed_state;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n841 <= 3'b000;
    else
      n841 <= n840;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n842 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n843 = clkena & n842;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n844 = n843 ? n734 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n845 <= n844;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n846 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n847 = clkena & n846;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n848 = n847 ? n736 : bcd_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n849 <= n848;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n850 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n851 = clkena & n850;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n852 = n851 ? n738 : binary_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n853 <= n852;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n855 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n856 = clkena & n855;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n857 = n856 ? n740 : decimal_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n858 <= n857;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n859 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n860 = clkena & n859;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n861 = n860 ? n742 : work_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n862 <= n861;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n863 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n864 = clkena & n863;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n865 = n864 ? n744 : work_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n866 <= n865;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n867 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n868 = clkena & n867;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n869 = n868 ? n746 : result_sign;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n870 <= n869;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n871 = ~n13;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n872 = clkena & n871;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n873 = n872 ? n748 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n874 <= n873;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n875 = clkena ? n751 : cycle_count;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n876 <= 6'b000000;
    else
      n876 <= n875;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n877 = clkena ? n709 : n878;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n878 <= 1'b0;
    else
      n878 <= n877;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n879 = clkena ? n713 : n880;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n880 <= 1'b0;
    else
      n880 <= n879;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n881 = clkena ? n715 : n882;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n882 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n882 <= n881;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n883 = clkena ? n717 : n884;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n884 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n884 <= n883;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n885 = clkena ? n720 : n886;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n886 <= 1'b0;
    else
      n886 <= n885;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n887 = clkena ? n724 : n888;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n888 <= 1'b0;
    else
      n888 <= n887;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n889 = clkena ? n727 : n890;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n13)
    if (n13)
      n890 <= 1'b0;
    else
      n890 <= n889;
endmodule

