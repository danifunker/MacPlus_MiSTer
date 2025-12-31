module TG68K_ALU
  (input  clk,
   input  Reset,
   input  clkena_lw,
   input  [1:0] CPU,
   input  execOPC,
   input  decodeOPC,
   input  exe_condition,
   input  exec_tas,
   input  long_start,
   input  non_aligned,
   input  check_aligned,
   input  movem_presub,
   input  set_stop,
   input  Z_error,
   input  [1:0] rot_bits,
   input  [103:0] exec,
   input  [31:0] OP1out,
   input  [31:0] OP2out,
   input  [31:0] reg_QA,
   input  [31:0] reg_QB,
   input  [15:0] opcode,
   input  [15:0] exe_opcode,
   input  [1:0] exe_datatype,
   input  [15:0] sndOPC,
   input  [15:0] last_data_read,
   input  [15:0] data_read,
   input  [7:0] FlagsSR,
   input  [6:0] micro_state,
   input  [7:0] bf_ext_in,
   input  [5:0] bf_shift,
   input  [5:0] bf_width,
   input  [31:0] bf_ffo_offset,
   input  [4:0] bf_loffset,
   output [7:0] bf_ext_out,
   output set_V_Flag,
   output [7:0] Flags,
   output [2:0] c_out,
   output [31:0] addsub_q,
   output [31:0] ALUout);
  wire [31:0] op1in;
  wire [31:0] addsub_a;
  wire [31:0] addsub_b;
  wire [33:0] notaddsub_b;
  wire [33:0] add_result;
  wire [2:0] addsub_ofl;
  wire opaddsub;
  wire [3:0] c_in;
  wire [2:0] flag_z;
  wire [3:0] set_flags;
  wire [7:0] ccrin;
  wire [3:0] last_flags1;
  wire [9:0] bcd_pur;
  wire [8:0] bcd_kor;
  wire halve_carry;
  wire vflag_a;
  wire bcd_a_carry;
  wire [8:0] bcd_a;
  wire [127:0] result_mulu;
  wire [63:0] result_div;
  wire [31:0] result_div_pre;
  wire v_flag;
  wire rot_rot;
  wire rot_x;
  wire rot_c;
  wire [31:0] rot_out;
  wire asl_vflag;
  wire [4:0] bit_number;
  wire [31:0] bits_out;
  wire one_bit_in;
  wire bchg;
  wire bset;
  wire mulu_sign;
  wire muls_msb;
  wire [63:0] mulu_reg;
  wire fasign;
  wire [31:0] faktorb;
  wire [63:0] div_reg;
  wire [63:0] div_quot;
  wire div_neg;
  wire div_bit;
  wire [32:0] div_sub;
  wire [32:0] div_over;
  wire nozero;
  wire div_qsign;
  wire [63:0] dividend;
  wire divs;
  wire signedop;
  wire op1_sign;
  wire [15:0] op2outext;
  wire [31:0] datareg;
  wire [31:0] bf_datareg;
  wire [39:0] result;
  wire [39:0] result_tmp;
  wire [31:0] unshifted_bitmask;
  wire [39:0] inmux0;
  wire [39:0] inmux1;
  wire [39:0] inmux2;
  wire [31:0] inmux3;
  wire [39:0] shifted_bitmask;
  wire [37:0] bitmaskmux0;
  wire [35:0] bitmaskmux1;
  wire [31:0] bitmaskmux2;
  wire [31:0] bitmaskmux3;
  wire [31:0] bf_set2;
  wire [39:0] shift;
  wire [5:0] bf_firstbit;
  wire [3:0] mux;
  wire [4:0] bitnr;
  wire [31:0] mask;
  wire mask_not_zero;
  wire bf_bset;
  wire bf_nflag;
  wire bf_bchg;
  wire bf_ins;
  wire bf_exts;
  wire bf_fffo;
  wire bf_d32;
  wire bf_s32;
  wire [33:0] hot_msb;
  wire [32:0] vector;
  wire [65:0] result_bs;
  wire [5:0] bit_nr;
  wire [5:0] bit_msb;
  wire [5:0] bs_shift;
  wire [5:0] bs_shift_mod;
  wire [32:0] asl_over;
  wire [32:0] asl_over_xor;
  wire [32:0] asr_sign;
  wire msb;
  wire [5:0] ring;
  wire [31:0] alu;
  wire [31:0] bsout;
  wire bs_v;
  wire bs_c;
  wire bs_x;
  wire n8;
  wire n9;
  wire [23:0] n10;
  wire [6:0] n11;
  wire n12;
  wire [31:0] n13;
  wire [31:0] n14;
  wire [31:0] n15;
  wire [31:0] n16;
  wire [31:0] n17;
  wire [31:0] n18;
  wire n19;
  wire n20;
  wire n21;
  wire [7:0] n22;
  wire n23;
  wire n25;
  wire n26;
  wire [31:0] n27;
  wire [31:0] n28;
  wire [31:0] n29;
  wire n30;
  wire n32;
  wire n33;
  wire n35;
  wire [15:0] n36;
  wire [15:0] n37;
  wire [31:0] n38;
  wire n39;
  wire [31:0] n40;
  wire [31:0] n41;
  wire [31:0] n42;
  wire [31:0] n43;
  wire n44;
  wire [31:0] n45;
  wire n46;
  wire [31:0] n47;
  wire n48;
  wire [3:0] n49;
  wire [3:0] n50;
  wire [7:0] n51;
  wire n52;
  wire [31:0] n53;
  wire n54;
  wire n55;
  wire n56;
  wire n57;
  wire [15:0] n58;
  wire [15:0] n59;
  wire [31:0] n60;
  wire n61;
  wire n62;
  wire n63;
  wire n64;
  wire [7:0] n66;
  wire n67;
  wire [3:0] n68;
  wire [3:0] n69;
  wire [7:0] n70;
  wire [7:0] n71;
  wire [7:0] n72;
  wire [15:0] n73;
  wire [7:0] n74;
  wire [7:0] n75;
  wire [7:0] n76;
  wire [7:0] n77;
  wire [7:0] n78;
  wire [15:0] n79;
  wire [15:0] n80;
  wire [15:0] n81;
  wire [15:0] n82;
  wire [15:0] n83;
  wire [15:0] n84;
  wire [31:0] n85;
  wire [31:0] n86;
  wire [31:0] n87;
  wire [31:0] n88;
  wire [31:0] n89;
  wire [31:0] n90;
  wire [31:0] n91;
  wire [7:0] n92;
  wire [7:0] n93;
  wire [23:0] n94;
  wire [23:0] n95;
  wire [23:0] n96;
  wire [31:0] n97;
  wire [31:0] n98;
  wire [31:0] n99;
  wire [31:0] n100;
  wire [31:0] n101;
  wire [7:0] n102;
  wire [7:0] n103;
  wire [23:0] n104;
  wire [23:0] n105;
  wire [23:0] n106;
  wire n111;
  wire n112;
  wire n113;
  wire n114;
  wire [1:0] n115;
  wire n116;
  wire [2:0] n117;
  wire [28:0] n118;
  wire [31:0] n119;
  wire [1:0] n120;
  wire [31:0] n122;
  wire [31:0] n123;
  wire [31:0] n124;
  wire n125;
  wire n128;
  wire n130;
  wire [3:0] n131;
  wire [7:0] n133;
  wire [11:0] n135;
  wire [3:0] n136;
  wire [15:0] n137;
  wire n138;
  wire n139;
  wire n140;
  wire n141;
  wire n142;
  wire n143;
  wire n144;
  wire n145;
  wire n147;
  wire n148;
  wire n149;
  wire n150;
  wire n151;
  wire n152;
  wire n154;
  wire n155;
  wire n156;
  wire n157;
  wire n158;
  wire n159;
  wire n160;
  wire n161;
  wire n162;
  wire n163;
  wire n164;
  wire n165;
  wire n166;
  wire n167;
  wire n168;
  wire n169;
  wire n170;
  wire [31:0] n173;
  wire [31:0] n175;
  wire [31:0] n177;
  wire [31:0] n179;
  wire [31:0] n181;
  wire n182;
  wire n183;
  wire n184;
  wire n185;
  wire n186;
  wire n188;
  wire n189;
  wire [31:0] n190;
  wire n191;
  wire n192;
  wire [15:0] n193;
  wire [15:0] n194;
  wire [15:0] n195;
  wire [15:0] n196;
  wire [15:0] n197;
  wire n199;
  wire n200;
  wire n201;
  wire n202;
  wire n203;
  wire n204;
  wire n205;
  wire [31:0] n207;
  wire [31:0] n208;
  wire n209;
  wire n210;
  wire n212;
  wire [31:0] n215;
  wire [31:0] n216;
  wire [31:0] n217;
  wire [31:0] n218;
  wire [31:0] n219;
  wire [31:0] n220;
  wire n221;
  wire n222;
  wire [32:0] n224;
  wire n225;
  wire [33:0] n226;
  wire [32:0] n228;
  wire n229;
  wire [33:0] n230;
  wire [33:0] n231;
  wire [33:0] n232;
  wire [32:0] n234;
  wire n235;
  wire [33:0] n236;
  wire [33:0] n237;
  wire n238;
  wire n239;
  wire n240;
  wire n241;
  wire n242;
  wire n243;
  wire n244;
  wire n245;
  wire n246;
  wire n247;
  wire n248;
  wire [31:0] n249;
  wire n250;
  wire n251;
  wire n252;
  wire n253;
  wire n254;
  wire n255;
  wire n256;
  wire n257;
  wire n258;
  wire n259;
  wire n260;
  wire n261;
  wire n262;
  wire n263;
  wire n264;
  wire n265;
  wire n266;
  wire n267;
  wire n268;
  wire n269;
  wire n270;
  wire [2:0] n271;
  wire n275;
  wire [8:0] n276;
  wire [9:0] n277;
  wire n278;
  wire n279;
  wire n280;
  wire n281;
  wire n282;
  wire [3:0] n285;
  localparam [8:0] n286 = 9'b000000000;
  wire n288;
  wire [3:0] n290;
  wire [3:0] n291;
  wire n292;
  wire n293;
  wire n294;
  wire n295;
  wire n296;
  wire n297;
  wire [8:0] n298;
  wire [8:0] n299;
  wire n300;
  wire n301;
  wire n302;
  wire n303;
  wire n304;
  wire [3:0] n306;
  wire n307;
  wire n308;
  wire n309;
  wire n310;
  wire n311;
  wire n312;
  wire n313;
  wire n314;
  wire n315;
  wire n316;
  wire n317;
  wire n318;
  wire n319;
  wire [3:0] n321;
  wire n322;
  wire n323;
  wire n324;
  wire n325;
  wire [8:0] n326;
  wire [8:0] n327;
  wire [7:0] n328;
  wire [7:0] n329;
  wire [7:0] n330;
  wire n331;
  wire [8:0] n332;
  wire n333;
  wire n335;
  wire n336;
  wire n337;
  wire n338;
  wire [1:0] n343;
  wire n345;
  wire n347;
  wire [1:0] n348;
  reg n351;
  reg n355;
  wire n361;
  wire n362;
  wire [1:0] n363;
  wire n365;
  wire [4:0] n366;
  wire [2:0] n367;
  wire [4:0] n369;
  wire [4:0] n370;
  wire [1:0] n371;
  wire n373;
  wire [4:0] n374;
  wire [2:0] n375;
  wire [4:0] n377;
  wire [4:0] n378;
  wire [4:0] n379;
  wire n385;
  wire n386;
  wire n387;
  wire [1:0] n393;
  wire n395;
  wire n398;
  wire [2:0] n400;
  wire n402;
  wire n404;
  wire n406;
  wire n408;
  wire n410;
  wire [4:0] n411;
  reg n414;
  reg n418;
  reg n422;
  reg n426;
  reg n430;
  reg n433;
  wire [1:0] n434;
  wire n436;
  wire n439;
  wire [7:0] n441;
  wire [31:0] n458;
  wire [4:0] n459;
  wire n461;
  wire n464;
  wire n465;
  wire n468;
  localparam [31:0] n469 = 32'b00000000000000000000000000000000;
  wire [4:0] n471;
  wire n473;
  wire n476;
  wire n477;
  wire n479;
  wire n480;
  wire [4:0] n482;
  wire n484;
  wire n487;
  wire n488;
  wire n490;
  wire n491;
  wire [4:0] n493;
  wire n495;
  wire n498;
  wire n499;
  wire n501;
  wire n502;
  wire [4:0] n504;
  wire n506;
  wire n509;
  wire n510;
  wire n512;
  wire n513;
  wire [4:0] n515;
  wire n517;
  wire n520;
  wire n521;
  wire n523;
  wire n524;
  wire [4:0] n526;
  wire n528;
  wire n531;
  wire n532;
  wire n534;
  wire n535;
  wire [4:0] n537;
  wire n539;
  wire n542;
  wire n543;
  wire n545;
  wire n546;
  wire [4:0] n548;
  wire n550;
  wire n553;
  wire n554;
  wire n556;
  wire n557;
  wire [4:0] n559;
  wire n561;
  wire n564;
  wire n565;
  wire n567;
  wire n568;
  wire [4:0] n570;
  wire n572;
  wire n575;
  wire n576;
  wire n578;
  wire n579;
  wire [4:0] n581;
  wire n583;
  wire n586;
  wire n587;
  wire n589;
  wire n590;
  wire [4:0] n592;
  wire n594;
  wire n597;
  wire n598;
  wire n600;
  wire n601;
  wire [4:0] n603;
  wire n605;
  wire n608;
  wire n609;
  wire n611;
  wire n612;
  wire [4:0] n614;
  wire n616;
  wire n619;
  wire n620;
  wire n622;
  wire n623;
  wire [4:0] n625;
  wire n627;
  wire n630;
  wire n631;
  wire n633;
  wire n634;
  wire [4:0] n636;
  wire n638;
  wire n641;
  wire n642;
  wire n644;
  wire n645;
  wire [4:0] n647;
  wire n649;
  wire n652;
  wire n653;
  wire n655;
  wire n656;
  wire [4:0] n658;
  wire n660;
  wire n663;
  wire n664;
  wire n666;
  wire n667;
  wire [4:0] n669;
  wire n671;
  wire n674;
  wire n675;
  wire n677;
  wire n678;
  wire [4:0] n680;
  wire n682;
  wire n685;
  wire n686;
  wire n688;
  wire n689;
  wire [4:0] n691;
  wire n693;
  wire n696;
  wire n697;
  wire n699;
  wire n700;
  wire [4:0] n702;
  wire n704;
  wire n707;
  wire n708;
  wire n710;
  wire n711;
  wire [4:0] n713;
  wire n715;
  wire n718;
  wire n719;
  wire n721;
  wire n722;
  wire [4:0] n724;
  wire n726;
  wire n729;
  wire n730;
  wire n732;
  wire n733;
  wire [4:0] n735;
  wire n737;
  wire n740;
  wire n741;
  wire n743;
  wire n744;
  wire [4:0] n746;
  wire n748;
  wire n751;
  wire n752;
  wire n754;
  wire n755;
  wire [4:0] n757;
  wire n759;
  wire n762;
  wire n763;
  wire n765;
  wire n766;
  wire [4:0] n768;
  wire n770;
  wire n773;
  wire n774;
  wire n776;
  wire n777;
  wire [4:0] n779;
  wire n781;
  wire n784;
  wire n785;
  wire n787;
  wire n788;
  wire [4:0] n790;
  wire n792;
  wire n795;
  wire n796;
  wire n797;
  wire n798;
  wire n799;
  wire n800;
  wire [4:0] n801;
  wire n803;
  wire n806;
  wire n807;
  wire [4:0] n809;
  wire n812;
  wire [31:0] n813;
  wire [31:0] n814;
  wire n815;
  wire [15:0] n816;
  wire [15:0] n817;
  wire [31:0] n818;
  wire [31:0] n819;
  wire n820;
  wire [23:0] n821;
  wire [7:0] n822;
  wire [31:0] n823;
  wire [31:0] n824;
  wire n825;
  wire [35:0] n827;
  wire [3:0] n828;
  wire [3:0] n829;
  wire [3:0] n830;
  wire [31:0] n831;
  wire [35:0] n833;
  wire [35:0] n834;
  wire [35:0] n835;
  wire n836;
  wire [37:0] n838;
  wire [1:0] n839;
  wire [1:0] n840;
  wire [1:0] n841;
  wire [35:0] n842;
  wire [37:0] n844;
  wire [37:0] n845;
  wire [37:0] n846;
  wire n847;
  wire [38:0] n849;
  wire [39:0] n851;
  wire n852;
  wire n853;
  wire n854;
  wire [38:0] n855;
  wire [39:0] n857;
  wire [39:0] n858;
  wire [39:0] n859;
  wire [39:0] n860;
  wire [7:0] n861;
  wire [7:0] n862;
  wire [7:0] n863;
  wire [31:0] n864;
  wire n865;
  wire n866;
  wire [38:0] n867;
  wire [39:0] n868;
  wire [39:0] n869;
  wire n870;
  wire [1:0] n871;
  wire [37:0] n872;
  wire [39:0] n873;
  wire [39:0] n874;
  wire n875;
  wire [3:0] n876;
  wire [35:0] n877;
  wire [39:0] n878;
  wire [39:0] n879;
  wire n880;
  wire [7:0] n881;
  wire [23:0] n882;
  wire [31:0] n883;
  wire [31:0] n884;
  wire [31:0] n885;
  wire n886;
  wire [15:0] n887;
  wire [15:0] n888;
  wire [31:0] n889;
  wire [31:0] n890;
  wire [7:0] n891;
  wire [31:0] n892;
  wire [7:0] n893;
  wire [39:0] n894;
  wire [39:0] n896;
  wire [39:0] n897;
  wire [39:0] n898;
  wire [39:0] n900;
  wire [39:0] n901;
  wire [39:0] n902;
  wire [39:0] n903;
  wire n904;
  wire n905;
  wire n906;
  wire n907;
  wire n909;
  wire n910;
  wire n911;
  wire n912;
  wire n914;
  wire n915;
  wire n916;
  wire n917;
  wire n919;
  wire n920;
  wire n921;
  wire n922;
  wire n924;
  wire n925;
  wire n926;
  wire n927;
  wire n929;
  wire n930;
  wire n931;
  wire n932;
  wire n934;
  wire n935;
  wire n936;
  wire n937;
  wire n939;
  wire n940;
  wire n941;
  wire n942;
  wire n944;
  wire n945;
  wire n946;
  wire n947;
  wire n949;
  wire n950;
  wire n951;
  wire n952;
  wire n954;
  wire n955;
  wire n956;
  wire n957;
  wire n959;
  wire n960;
  wire n961;
  wire n962;
  wire n964;
  wire n965;
  wire n966;
  wire n967;
  wire n969;
  wire n970;
  wire n971;
  wire n972;
  wire n974;
  wire n975;
  wire n976;
  wire n977;
  wire n979;
  wire n980;
  wire n981;
  wire n982;
  wire n984;
  wire n985;
  wire n986;
  wire n987;
  wire n989;
  wire n990;
  wire n991;
  wire n992;
  wire n994;
  wire n995;
  wire n996;
  wire n997;
  wire n999;
  wire n1000;
  wire n1001;
  wire n1002;
  wire n1004;
  wire n1005;
  wire n1006;
  wire n1007;
  wire n1009;
  wire n1010;
  wire n1011;
  wire n1012;
  wire n1014;
  wire n1015;
  wire n1016;
  wire n1017;
  wire n1019;
  wire n1020;
  wire n1021;
  wire n1022;
  wire n1024;
  wire n1025;
  wire n1026;
  wire n1027;
  wire n1029;
  wire n1030;
  wire n1031;
  wire n1032;
  wire n1034;
  wire n1035;
  wire n1036;
  wire n1037;
  wire n1039;
  wire n1040;
  wire n1041;
  wire n1042;
  wire n1044;
  wire n1045;
  wire n1046;
  wire n1047;
  wire n1049;
  wire n1050;
  wire n1051;
  wire n1052;
  wire n1054;
  wire n1055;
  wire n1056;
  wire n1057;
  wire n1059;
  wire n1060;
  wire n1061;
  wire n1062;
  wire n1064;
  wire n1065;
  wire n1066;
  wire n1067;
  wire n1069;
  wire n1070;
  wire n1071;
  wire n1072;
  wire n1074;
  wire n1075;
  wire n1076;
  wire n1077;
  wire n1079;
  wire n1080;
  wire n1081;
  wire n1082;
  wire n1084;
  wire n1085;
  wire n1086;
  wire n1087;
  wire n1089;
  wire n1090;
  wire n1091;
  wire n1092;
  wire n1094;
  wire n1095;
  wire n1096;
  wire n1097;
  wire n1098;
  wire n1099;
  wire n1100;
  wire n1101;
  wire [5:0] n1103;
  wire [5:0] n1104;
  wire [5:0] n1105;
  wire [3:0] n1106;
  wire n1108;
  wire [3:0] n1109;
  wire n1111;
  wire [3:0] n1112;
  wire n1114;
  wire [3:0] n1115;
  wire n1117;
  wire [3:0] n1119;
  wire n1121;
  wire [3:0] n1122;
  wire n1124;
  wire [3:0] n1126;
  wire n1128;
  wire [3:0] n1130;
  wire [3:0] n1131;
  wire [3:0] n1132;
  wire n1134;
  wire [3:0] n1135;
  wire [3:0] n1137;
  wire [1:0] n1138;
  wire n1139;
  wire n1140;
  wire n1141;
  wire n1143;
  wire [3:0] n1144;
  wire [3:0] n1145;
  wire [1:0] n1146;
  wire [1:0] n1148;
  wire [3:0] n1149;
  wire [3:0] n1152;
  wire [1:0] n1153;
  wire [2:0] n1154;
  wire [1:0] n1155;
  wire [1:0] n1156;
  wire n1157;
  wire n1159;
  wire [3:0] n1160;
  wire [3:0] n1162;
  wire [2:0] n1163;
  wire n1164;
  wire n1166;
  wire n1167;
  wire n1168;
  wire n1169;
  wire n1171;
  wire [3:0] n1172;
  wire [3:0] n1174;
  wire [2:0] n1175;
  wire n1176;
  wire n1177;
  wire [1:0] n1178;
  wire [1:0] n1180;
  wire [3:0] n1181;
  wire [3:0] n1182;
  wire [2:0] n1183;
  wire [2:0] n1185;
  localparam [4:0] n1186 = 5'b11111;
  wire [1:0] n1188;
  wire n1190;
  wire n1192;
  wire n1193;
  wire n1195;
  wire n1196;
  wire n1199;
  wire n1200;
  wire n1201;
  wire n1203;
  wire n1204;
  wire n1205;
  wire n1207;
  wire n1208;
  wire [1:0] n1209;
  wire n1210;
  wire n1211;
  wire n1212;
  wire n1213;
  wire n1214;
  wire n1217;
  wire [1:0] n1222;
  wire n1223;
  wire n1225;
  wire n1226;
  wire n1228;
  wire n1230;
  wire n1231;
  wire n1232;
  wire n1234;
  wire [2:0] n1235;
  reg n1236;
  wire n1254;
  wire n1255;
  wire n1257;
  wire n1258;
  wire n1260;
  wire n1261;
  wire n1264;
  wire n1265;
  wire n1285;
  wire n1286;
  wire n1289;
  wire n1290;
  wire [31:0] n1291;
  wire n1296;
  wire [1:0] n1297;
  wire n1299;
  wire n1301;
  wire n1303;
  wire n1304;
  wire n1306;
  wire [2:0] n1307;
  reg [5:0] n1312;
  wire [1:0] n1313;
  wire n1315;
  wire n1317;
  wire n1319;
  wire n1320;
  wire n1322;
  wire [2:0] n1323;
  reg [5:0] n1328;
  wire [5:0] n1329;
  wire [1:0] n1331;
  wire n1333;
  wire n1334;
  wire n1335;
  wire n1336;
  wire n1337;
  wire [5:0] n1338;
  wire [2:0] n1339;
  wire [2:0] n1340;
  wire n1342;
  wire [2:0] n1345;
  wire [5:0] n1346;
  wire [5:0] n1347;
  wire [5:0] n1349;
  localparam [33:0] n1352 = 34'b0000000000000000000000000000000000;
  wire n1356;
  wire [5:0] n1357;
  wire [5:0] n1359;
  wire [30:0] n1361;
  wire [31:0] n1363;
  wire [30:0] n1364;
  wire [31:0] n1366;
  wire [31:0] n1367;
  wire [32:0] n1368;
  wire [1:0] n1369;
  wire n1372;
  wire n1375;
  wire n1377;
  wire n1378;
  wire [1:0] n1379;
  wire n1380;
  reg n1381;
  wire n1382;
  reg n1383;
  wire [7:0] n1385;
  wire [15:0] n1386;
  wire [6:0] n1387;
  wire [31:0] n1388;
  wire [32:0] n1390;
  wire [32:0] n1391;
  wire n1393;
  wire n1394;
  wire n1395;
  wire n1396;
  wire n1397;
  wire n1399;
  wire n1401;
  wire n1402;
  wire n1403;
  wire [1:0] n1404;
  wire n1405;
  wire n1407;
  wire n1408;
  wire n1410;
  wire n1412;
  wire n1413;
  wire n1414;
  wire n1416;
  wire [2:0] n1417;
  reg n1418;
  wire n1419;
  wire n1421;
  wire n1422;
  wire [1:0] n1423;
  wire [7:0] n1424;
  wire [7:0] n1425;
  wire [7:0] n1426;
  wire n1427;
  wire n1429;
  wire [15:0] n1430;
  wire [15:0] n1431;
  wire [15:0] n1432;
  wire n1433;
  wire n1435;
  wire n1437;
  wire n1438;
  wire [31:0] n1439;
  wire [31:0] n1440;
  wire [31:0] n1441;
  wire n1442;
  wire n1444;
  wire [2:0] n1445;
  wire [7:0] n1446;
  wire [7:0] n1447;
  reg [7:0] n1449;
  wire [7:0] n1450;
  wire [7:0] n1451;
  reg [7:0] n1453;
  wire [15:0] n1454;
  reg [15:0] n1456;
  reg n1457;
  wire n1458;
  wire n1459;
  wire n1460;
  wire n1462;
  wire [1:0] n1463;
  wire [7:0] n1464;
  wire [7:0] n1465;
  wire [7:0] n1466;
  wire n1467;
  wire n1468;
  wire n1469;
  wire n1471;
  wire [15:0] n1472;
  wire [15:0] n1473;
  wire [15:0] n1474;
  wire n1475;
  wire n1476;
  wire n1477;
  wire n1479;
  wire n1481;
  wire n1482;
  wire [31:0] n1483;
  wire [31:0] n1484;
  wire [31:0] n1485;
  wire n1486;
  wire n1487;
  wire n1488;
  wire n1490;
  wire [2:0] n1491;
  wire [7:0] n1492;
  wire [7:0] n1493;
  reg [7:0] n1495;
  wire [7:0] n1496;
  wire [7:0] n1497;
  reg [7:0] n1499;
  wire [15:0] n1500;
  reg [15:0] n1502;
  reg n1503;
  wire n1504;
  wire n1505;
  wire [31:0] n1506;
  wire [31:0] n1507;
  wire [31:0] n1508;
  wire [31:0] n1509;
  wire [31:0] n1510;
  wire n1511;
  wire [31:0] n1512;
  wire [31:0] n1513;
  wire n1515;
  wire n1516;
  wire n1518;
  wire n1520;
  wire n1521;
  wire n1523;
  wire n1524;
  wire n1526;
  wire n1527;
  wire n1528;
  wire n1530;
  wire n1532;
  wire [5:0] n1534;
  wire n1536;
  wire [5:0] n1538;
  wire n1540;
  wire [5:0] n1542;
  wire n1544;
  wire [5:0] n1546;
  wire n1548;
  wire [5:0] n1550;
  wire n1552;
  wire [5:0] n1554;
  wire [5:0] n1555;
  wire [5:0] n1556;
  wire [5:0] n1557;
  wire [5:0] n1558;
  wire [5:0] n1559;
  wire [5:0] n1560;
  wire [5:0] n1562;
  wire n1564;
  wire n1566;
  wire [5:0] n1568;
  wire n1570;
  wire [5:0] n1572;
  wire n1574;
  wire [5:0] n1576;
  wire [5:0] n1577;
  wire [5:0] n1578;
  wire [5:0] n1579;
  wire n1581;
  wire n1583;
  wire [5:0] n1585;
  wire [5:0] n1586;
  wire n1588;
  wire [2:0] n1589;
  wire [5:0] n1591;
  wire n1593;
  wire [3:0] n1594;
  wire [5:0] n1596;
  wire n1598;
  wire [4:0] n1599;
  wire [5:0] n1601;
  wire n1603;
  wire [5:0] n1604;
  reg [5:0] n1606;
  wire n1607;
  wire n1608;
  wire [5:0] n1609;
  wire [5:0] n1610;
  wire n1611;
  wire n1612;
  wire n1613;
  wire n1614;
  wire [5:0] n1616;
  wire [5:0] n1617;
  wire n1618;
  wire n1619;
  wire n1620;
  wire [5:0] n1622;
  wire [5:0] n1623;
  wire [5:0] n1624;
  wire n1625;
  wire n1626;
  wire n1627;
  wire [5:0] n1629;
  wire [5:0] n1631;
  wire n1633;
  wire [5:0] n1634;
  wire n1635;
  wire [5:0] n1636;
  wire n1637;
  wire [31:0] n1638;
  wire [31:0] n1639;
  wire [31:0] n1640;
  localparam [32:0] n1641 = 33'b000000000000000000000000000000000;
  wire n1642;
  wire n1644;
  wire n1645;
  wire n1646;
  wire n1647;
  wire n1648;
  wire [31:0] n1649;
  wire [31:0] n1650;
  wire n1651;
  wire n1653;
  wire [31:0] n1654;
  wire n1655;
  wire [32:0] n1657;
  wire [1:0] n1658;
  wire n1659;
  localparam [23:0] n1660 = 24'b000000000000000000000000;
  localparam [23:0] n1661 = 24'b000000000000000000000000;
  wire n1663;
  wire n1664;
  wire n1665;
  wire n1666;
  wire [22:0] n1667;
  wire n1669;
  wire n1670;
  localparam [15:0] n1671 = 16'b0000000000000000;
  wire n1674;
  wire n1675;
  wire n1676;
  wire n1677;
  wire [14:0] n1678;
  wire n1680;
  wire n1682;
  wire n1683;
  wire n1684;
  wire n1686;
  wire n1687;
  wire n1688;
  wire n1689;
  wire n1691;
  wire [2:0] n1692;
  wire n1693;
  reg n1694;
  wire [6:0] n1695;
  wire [6:0] n1696;
  reg [6:0] n1697;
  wire n1698;
  wire n1699;
  reg n1700;
  wire [14:0] n1701;
  wire [14:0] n1702;
  reg [14:0] n1703;
  wire n1704;
  reg n1705;
  wire [7:0] n1707;
  reg n1711;
  wire [7:0] n1712;
  wire [7:0] n1713;
  reg [7:0] n1714;
  wire [15:0] n1715;
  wire [15:0] n1716;
  reg [15:0] n1717;
  wire [7:0] n1719;
  wire [65:0] n1721;
  wire [30:0] n1722;
  wire [31:0] n1723;
  wire [65:0] n1724;
  wire n1728;
  wire [7:0] n1729;
  wire [7:0] n1730;
  wire n1731;
  wire [7:0] n1732;
  wire [7:0] n1733;
  wire n1734;
  wire [7:0] n1735;
  wire [7:0] n1736;
  wire [7:0] n1737;
  wire [7:0] n1738;
  wire [7:0] n1739;
  wire [7:0] n1740;
  wire n1741;
  wire n1742;
  wire n1743;
  wire n1744;
  wire [7:0] n1745;
  wire n1747;
  wire [7:0] n1749;
  wire n1751;
  wire [15:0] n1753;
  wire n1755;
  wire n1758;
  wire [1:0] n1759;
  wire [1:0] n1761;
  wire [2:0] n1762;
  wire [2:0] n1764;
  wire [2:0] n1766;
  wire n1769;
  wire n1770;
  wire n1771;
  wire [1:0] n1772;
  wire n1773;
  wire [2:0] n1774;
  wire n1775;
  wire [3:0] n1776;
  wire n1777;
  wire n1778;
  wire n1779;
  wire [1:0] n1780;
  wire [1:0] n1781;
  wire [1:0] n1782;
  wire [1:0] n1783;
  wire n1785;
  wire n1786;
  wire n1787;
  wire n1788;
  wire n1789;
  wire [1:0] n1790;
  wire n1791;
  wire [2:0] n1792;
  wire n1793;
  wire [3:0] n1794;
  wire n1795;
  wire n1796;
  wire [1:0] n1797;
  wire n1798;
  wire [2:0] n1799;
  wire n1800;
  wire [3:0] n1801;
  wire [3:0] n1802;
  wire [3:0] n1803;
  wire [3:0] n1804;
  wire n1806;
  wire n1807;
  wire [7:0] n1808;
  wire [7:0] n1809;
  wire n1810;
  wire [7:0] n1811;
  wire [7:0] n1812;
  wire n1813;
  wire n1814;
  wire n1815;
  wire n1816;
  wire n1817;
  wire n1818;
  wire n1820;
  wire n1821;
  wire n1823;
  wire n1824;
  wire n1825;
  wire n1826;
  wire n1827;
  wire [1:0] n1829;
  wire [3:0] n1831;
  wire [3:0] n1833;
  wire [3:0] n1834;
  wire [3:0] n1835;
  wire n1836;
  wire n1837;
  wire [3:0] n1838;
  wire n1839;
  wire n1840;
  wire n1841;
  wire n1843;
  wire n1844;
  wire n1845;
  wire n1846;
  wire n1847;
  wire n1848;
  wire n1849;
  wire n1850;
  wire n1851;
  wire n1852;
  wire n1853;
  wire n1854;
  wire n1855;
  wire n1856;
  wire n1858;
  wire n1860;
  wire n1862;
  wire n1863;
  wire n1864;
  wire [1:0] n1865;
  wire [3:0] n1867;
  wire n1868;
  wire n1869;
  wire [1:0] n1870;
  wire [3:0] n1872;
  wire [3:0] n1873;
  wire [3:0] n1874;
  wire n1875;
  wire n1877;
  wire n1878;
  wire n1879;
  wire n1880;
  wire n1881;
  wire n1885;
  wire n1886;
  wire n1887;
  wire n1888;
  wire n1889;
  wire n1890;
  wire n1891;
  wire n1892;
  wire n1893;
  wire n1894;
  wire n1895;
  wire n1896;
  wire n1897;
  wire n1898;
  wire n1900;
  wire n1901;
  wire n1904;
  wire n1905;
  wire n1906;
  wire n1907;
  wire n1908;
  wire [1:0] n1909;
  wire n1911;
  wire n1912;
  wire n1913;
  wire n1914;
  wire n1915;
  wire n1918;
  wire n1919;
  wire [1:0] n1920;
  wire n1921;
  wire n1922;
  wire n1923;
  wire n1924;
  wire n1925;
  wire n1926;
  wire n1927;
  wire n1928;
  wire n1929;
  wire n1930;
  wire n1931;
  wire n1932;
  wire n1933;
  wire n1934;
  wire n1935;
  wire n1936;
  wire n1937;
  wire n1938;
  wire n1939;
  wire n1940;
  wire n1941;
  wire n1942;
  wire n1944;
  wire n1945;
  wire n1946;
  wire n1947;
  wire n1948;
  wire n1949;
  wire n1951;
  wire n1952;
  wire n1953;
  wire n1954;
  wire [15:0] n1955;
  wire n1957;
  wire n1959;
  wire [15:0] n1960;
  wire n1962;
  wire n1963;
  wire n1964;
  wire n1967;
  wire [3:0] n1970;
  wire [3:0] n1971;
  wire [3:0] n1972;
  wire [3:0] n1973;
  wire [3:0] n1974;
  wire [1:0] n1975;
  wire [1:0] n1976;
  wire [1:0] n1977;
  wire n1978;
  wire n1979;
  wire n1980;
  wire n1981;
  wire n1982;
  wire [3:0] n1983;
  wire [3:0] n1984;
  wire [3:0] n1985;
  wire [3:0] n1986;
  wire [3:0] n1987;
  wire [3:0] n1988;
  wire [3:0] n1989;
  wire [3:0] n1990;
  wire [3:0] n1991;
  wire [3:0] n1992;
  wire [3:0] n1993;
  wire [4:0] n1994;
  wire [4:0] n1995;
  wire [4:0] n1996;
  wire [3:0] n1997;
  wire [3:0] n1998;
  wire [3:0] n1999;
  wire n2000;
  wire n2001;
  wire n2002;
  wire [3:0] n2003;
  wire [4:0] n2004;
  wire [4:0] n2005;
  wire [4:0] n2006;
  wire [2:0] n2007;
  wire [2:0] n2008;
  wire [2:0] n2009;
  wire [3:0] n2011;
  wire [7:0] n2012;
  wire [7:0] n2013;
  wire [3:0] n2014;
  wire n2015;
  wire [7:0] n2017;
  wire [3:0] n2018;
  wire n2019;
  wire [4:0] n2021;
  wire [7:0] n2022;
  wire n2029;
  wire n2030;
  wire n2031;
  wire n2032;
  wire n2034;
  wire n2035;
  wire n2036;
  wire n2039;
  wire [62:0] n2040;
  wire [63:0] n2041;
  wire n2042;
  wire [31:0] n2043;
  wire [32:0] n2044;
  wire [32:0] n2045;
  wire [32:0] n2046;
  wire [31:0] n2047;
  wire [32:0] n2048;
  wire [32:0] n2049;
  wire [32:0] n2050;
  wire [32:0] n2051;
  wire [32:0] n2052;
  wire [32:0] n2053;
  wire [30:0] n2054;
  wire n2055;
  wire n2057;
  wire [15:0] n2058;
  wire [31:0] n2060;
  wire [31:0] n2061;
  wire [31:0] n2084;
  wire n2092;
  wire n2093;
  wire n2094;
  wire n2095;
  wire n2096;
  wire n2097;
  wire n2098;
  wire n2099;
  wire n2101;
  wire n2102;
  wire n2103;
  wire n2104;
  wire n2105;
  wire n2106;
  wire n2107;
  wire n2108;
  wire n2109;
  wire n2110;
  wire n2111;
  wire n2112;
  wire n2113;
  wire n2114;
  wire n2115;
  wire n2116;
  wire n2117;
  wire n2118;
  wire n2119;
  wire n2120;
  wire n2121;
  wire n2122;
  wire n2123;
  wire n2124;
  wire n2125;
  wire n2126;
  wire n2127;
  wire n2128;
  wire n2129;
  wire n2130;
  wire n2131;
  wire n2132;
  wire n2133;
  wire n2134;
  wire n2135;
  wire n2136;
  wire n2137;
  wire n2138;
  wire n2139;
  wire n2140;
  wire n2141;
  wire n2142;
  wire n2143;
  wire n2144;
  wire n2145;
  wire n2146;
  wire n2147;
  wire n2148;
  wire n2149;
  wire n2150;
  wire n2151;
  wire n2152;
  wire n2153;
  wire n2154;
  wire n2155;
  wire n2156;
  wire n2157;
  wire n2158;
  wire n2159;
  wire n2160;
  wire n2161;
  wire n2162;
  wire n2163;
  wire n2164;
  wire [3:0] n2165;
  wire [3:0] n2166;
  wire [3:0] n2167;
  wire [3:0] n2168;
  wire [3:0] n2169;
  wire [3:0] n2170;
  wire [3:0] n2171;
  wire [3:0] n2172;
  wire [15:0] n2173;
  wire [15:0] n2174;
  wire [31:0] n2175;
  wire n2176;
  wire n2178;
  wire n2179;
  wire n2180;
  wire n2181;
  wire n2182;
  wire [31:0] n2183;
  wire n2184;
  wire n2185;
  wire [63:0] n2186;
  wire [15:0] n2187;
  wire [15:0] n2188;
  wire [31:0] n2189;
  wire [31:0] n2190;
  wire [15:0] n2191;
  wire [15:0] n2192;
  wire [15:0] n2193;
  wire n2195;
  wire n2196;
  wire n2197;
  wire [15:0] n2198;
  wire [15:0] n2200;
  wire n2201;
  wire n2202;
  wire [32:0] n2203;
  wire [32:0] n2205;
  wire [32:0] n2206;
  wire [32:0] n2207;
  wire [16:0] n2209;
  wire [15:0] n2210;
  wire [32:0] n2211;
  wire [32:0] n2212;
  wire [32:0] n2213;
  wire n2214;
  wire [31:0] n2215;
  wire [31:0] n2216;
  wire [31:0] n2217;
  wire [30:0] n2218;
  wire n2219;
  wire [31:0] n2220;
  wire [31:0] n2221;
  wire [31:0] n2223;
  wire [31:0] n2224;
  wire [31:0] n2225;
  wire n2226;
  wire n2227;
  wire n2228;
  wire n2229;
  wire n2230;
  wire n2231;
  wire n2232;
  wire n2233;
  wire n2234;
  wire n2235;
  wire n2236;
  wire n2237;
  wire n2239;
  wire n2242;
  wire n2248;
  wire n2251;
  wire n2252;
  wire n2253;
  wire [63:0] n2255;
  wire [63:0] n2256;
  wire n2259;
  wire n2260;
  wire n2261;
  wire [63:0] n2262;
  wire n2264;
  wire n2267;
  wire n2268;
  wire n2269;
  wire n2270;
  wire [31:0] n2271;
  wire [32:0] n2273;
  wire [16:0] n2275;
  wire [15:0] n2276;
  wire [32:0] n2277;
  wire [32:0] n2278;
  wire n2281;
  wire n2282;
  wire [31:0] n2283;
  wire [31:0] n2285;
  wire [31:0] n2286;
  wire [31:0] n2287;
  wire [63:0] n2288;
  wire n2290;
  wire n2291;
  wire n2293;
  wire n2294;
  wire n2297;
  wire [31:0] n2307;
  wire [2:0] n2308;
  wire [3:0] n2309;
  reg [3:0] n2310;
  wire [8:0] n2311;
  wire [127:0] n2313;
  wire [63:0] n2314;
  reg [63:0] n2315;
  wire n2316;
  reg n2317;
  reg n2318;
  wire n2320;
  reg n2321;
  wire n2322;
  reg n2323;
  wire [31:0] n2325;
  wire [31:0] n2326;
  reg [31:0] n2327;
  wire [63:0] n2329;
  wire [63:0] n2332;
  reg [63:0] n2333;
  wire [63:0] n2334;
  wire n2336;
  reg n2337;
  wire [32:0] n2338;
  reg [32:0] n2339;
  wire n2340;
  reg n2341;
  wire [63:0] n2342;
  wire n2343;
  reg n2344;
  wire n2345;
  reg n2346;
  wire [31:0] n2349;
  wire [39:0] n2351;
  wire [31:0] n2352;
  wire [39:0] n2354;
  wire [4:0] n2355;
  wire n2356;
  reg n2357;
  wire n2358;
  reg n2359;
  wire n2360;
  reg n2361;
  wire n2362;
  reg n2363;
  wire n2364;
  reg n2365;
  wire n2366;
  reg n2367;
  wire n2368;
  reg n2369;
  wire [32:0] n2371;
  wire [32:0] n2372;
  wire [32:0] n2373;
  wire [31:0] n2374;
  wire [7:0] n2375;
  reg [7:0] n2376;
  reg [7:0] n2377;
  wire n2378;
  wire n2379;
  wire n2380;
  wire n2381;
  wire n2382;
  wire n2383;
  wire n2384;
  wire n2385;
  wire n2386;
  wire n2387;
  wire n2388;
  wire n2389;
  wire n2390;
  wire n2391;
  wire n2392;
  wire n2393;
  wire n2394;
  wire n2395;
  wire n2396;
  wire n2397;
  wire n2398;
  wire n2399;
  wire n2400;
  wire n2401;
  wire n2402;
  wire n2403;
  wire n2404;
  wire n2405;
  wire n2406;
  wire n2407;
  wire n2408;
  wire n2409;
  wire n2410;
  wire n2411;
  wire n2412;
  wire n2413;
  wire n2414;
  wire n2415;
  wire n2416;
  wire n2417;
  wire n2418;
  wire n2419;
  wire n2420;
  wire n2421;
  wire n2422;
  wire n2423;
  wire n2424;
  wire n2425;
  wire n2426;
  wire n2427;
  wire n2428;
  wire n2429;
  wire n2430;
  wire n2431;
  wire n2432;
  wire n2433;
  wire n2434;
  wire n2435;
  wire n2436;
  wire n2437;
  wire n2438;
  wire n2439;
  wire n2440;
  wire n2441;
  wire n2442;
  wire n2443;
  wire n2444;
  wire n2445;
  wire n2446;
  wire n2447;
  wire n2448;
  wire n2449;
  wire n2450;
  wire n2451;
  wire n2452;
  wire n2453;
  wire n2454;
  wire n2455;
  wire n2456;
  wire n2457;
  wire n2458;
  wire n2459;
  wire n2460;
  wire n2461;
  wire n2462;
  wire n2463;
  wire n2464;
  wire n2465;
  wire n2466;
  wire n2467;
  wire n2468;
  wire n2469;
  wire n2470;
  wire n2471;
  wire n2472;
  wire n2473;
  wire n2474;
  wire n2475;
  wire n2476;
  wire n2477;
  wire n2478;
  wire n2479;
  wire n2480;
  wire n2481;
  wire n2482;
  wire n2483;
  wire n2484;
  wire n2485;
  wire n2486;
  wire n2487;
  wire n2488;
  wire n2489;
  wire n2490;
  wire n2491;
  wire n2492;
  wire n2493;
  wire n2494;
  wire n2495;
  wire n2496;
  wire n2497;
  wire n2498;
  wire n2499;
  wire n2500;
  wire n2501;
  wire n2502;
  wire n2503;
  wire n2504;
  wire n2505;
  wire n2506;
  wire n2507;
  wire n2508;
  wire n2509;
  wire n2510;
  wire n2511;
  wire n2512;
  wire [31:0] n2513;
  wire n2514;
  wire n2515;
  wire n2516;
  wire n2517;
  wire n2518;
  wire n2519;
  wire n2520;
  wire n2521;
  wire n2522;
  wire n2523;
  wire n2524;
  wire n2525;
  wire n2526;
  wire n2527;
  wire n2528;
  wire n2529;
  wire n2530;
  wire n2531;
  wire n2532;
  wire n2533;
  wire n2534;
  wire n2535;
  wire n2536;
  wire n2537;
  wire n2538;
  wire n2539;
  wire n2540;
  wire n2541;
  wire n2542;
  wire n2543;
  wire n2544;
  wire n2545;
  wire n2546;
  wire n2547;
  wire n2548;
  wire n2549;
  wire n2550;
  wire n2551;
  wire n2552;
  wire n2553;
  wire n2554;
  wire n2555;
  wire n2556;
  wire n2557;
  wire n2558;
  wire n2559;
  wire n2560;
  wire n2561;
  wire n2562;
  wire n2563;
  wire n2564;
  wire n2565;
  wire n2566;
  wire n2567;
  wire n2568;
  wire n2569;
  wire n2570;
  wire n2571;
  wire n2572;
  wire n2573;
  wire n2574;
  wire n2575;
  wire n2576;
  wire n2577;
  wire n2578;
  wire n2579;
  wire n2580;
  wire n2581;
  wire n2582;
  wire n2583;
  wire n2584;
  wire n2585;
  wire n2586;
  wire n2587;
  wire n2588;
  wire n2589;
  wire n2590;
  wire n2591;
  wire n2592;
  wire n2593;
  wire n2594;
  wire n2595;
  wire n2596;
  wire n2597;
  wire n2598;
  wire n2599;
  wire n2600;
  wire n2601;
  wire n2602;
  wire n2603;
  wire n2604;
  wire n2605;
  wire n2606;
  wire n2607;
  wire n2608;
  wire n2609;
  wire n2610;
  wire n2611;
  wire n2612;
  wire n2613;
  wire n2614;
  wire n2615;
  wire n2616;
  wire n2617;
  wire n2618;
  wire n2619;
  wire n2620;
  wire n2621;
  wire n2622;
  wire n2623;
  wire n2624;
  wire n2625;
  wire n2626;
  wire n2627;
  wire n2628;
  wire n2629;
  wire n2630;
  wire n2631;
  wire n2632;
  wire n2633;
  wire n2634;
  wire n2635;
  wire n2636;
  wire n2637;
  wire n2638;
  wire n2639;
  wire n2640;
  wire n2641;
  wire n2642;
  wire n2643;
  wire n2644;
  wire n2645;
  wire n2646;
  wire n2647;
  wire n2648;
  wire n2649;
  wire n2650;
  wire n2651;
  wire n2652;
  wire n2653;
  wire n2654;
  wire n2655;
  wire n2656;
  wire n2657;
  wire n2658;
  wire n2659;
  wire n2660;
  wire n2661;
  wire n2662;
  wire [33:0] n2663;
  assign bf_ext_out = n2376; //(module output)
  assign set_V_Flag = n2242; //(module output)
  assign Flags = n2377; //(module output)
  assign c_out = n271; //(module output)
  assign addsub_q = n249; //(module output)
  assign ALUout = n18; //(module output)
  /* TG68K_ALU.vhd:86:16  */
  assign op1in = n2307; // (signal)
  /* TG68K_ALU.vhd:87:16  */
  assign addsub_a = n124; // (signal)
  /* TG68K_ALU.vhd:88:16  */
  assign addsub_b = n220; // (signal)
  /* TG68K_ALU.vhd:89:16  */
  assign notaddsub_b = n232; // (signal)
  /* TG68K_ALU.vhd:90:16  */
  assign add_result = n237; // (signal)
  /* TG68K_ALU.vhd:91:16  */
  assign addsub_ofl = n2308; // (signal)
  /* TG68K_ALU.vhd:92:16  */
  assign opaddsub = n199; // (signal)
  /* TG68K_ALU.vhd:93:16  */
  assign c_in = n2309; // (signal)
  /* TG68K_ALU.vhd:94:16  */
  assign flag_z = n1766; // (signal)
  /* TG68K_ALU.vhd:95:16  */
  assign set_flags = n1804; // (signal)
  /* TG68K_ALU.vhd:96:16  */
  assign ccrin = n1740; // (signal)
  /* TG68K_ALU.vhd:97:16  */
  assign last_flags1 = n2310; // (signal)
  /* TG68K_ALU.vhd:100:16  */
  assign bcd_pur = n277; // (signal)
  /* TG68K_ALU.vhd:101:16  */
  assign bcd_kor = n2311; // (signal)
  /* TG68K_ALU.vhd:102:16  */
  assign halve_carry = n282; // (signal)
  /* TG68K_ALU.vhd:103:16  */
  assign vflag_a = n335; // (signal)
  /* TG68K_ALU.vhd:104:16  */
  assign bcd_a_carry = n338; // (signal)
  /* TG68K_ALU.vhd:105:16  */
  assign bcd_a = n332; // (signal)
  /* TG68K_ALU.vhd:106:16  */
  assign result_mulu = n2313; // (signal)
  /* TG68K_ALU.vhd:107:16  */
  assign result_div = n2315; // (signal)
  /* TG68K_ALU.vhd:108:16  */
  assign result_div_pre = n2225; // (signal)
  /* TG68K_ALU.vhd:110:16  */
  assign v_flag = n2317; // (signal)
  /* TG68K_ALU.vhd:112:16  */
  assign rot_rot = n1236; // (signal)
  /* TG68K_ALU.vhd:115:16  */
  assign rot_x = n1289; // (signal)
  /* TG68K_ALU.vhd:116:16  */
  assign rot_c = n1290; // (signal)
  /* TG68K_ALU.vhd:117:16  */
  assign rot_out = n1291; // (signal)
  /* TG68K_ALU.vhd:118:16  */
  assign asl_vflag = n2318; // (signal)
  /* TG68K_ALU.vhd:120:16  */
  assign bit_number = n379; // (signal)
  /* TG68K_ALU.vhd:121:16  */
  assign bits_out = n2513; // (signal)
  /* TG68K_ALU.vhd:122:16  */
  assign one_bit_in = n2378; // (signal)
  /* TG68K_ALU.vhd:123:16  */
  assign bchg = n2321; // (signal)
  /* TG68K_ALU.vhd:124:16  */
  assign bset = n2323; // (signal)
  /* TG68K_ALU.vhd:126:16  */
  assign mulu_sign = n2039; // (signal)
  /* TG68K_ALU.vhd:128:16  */
  assign muls_msb = n2034; // (signal)
  /* TG68K_ALU.vhd:129:16  */
  assign mulu_reg = n2329; // (signal)
  /* TG68K_ALU.vhd:130:16  */
  assign fasign = 1'bX; // (signal)
  /* TG68K_ALU.vhd:132:16  */
  assign faktorb = n2061; // (signal)
  /* TG68K_ALU.vhd:134:16  */
  assign div_reg = n2333; // (signal)
  /* TG68K_ALU.vhd:135:16  */
  assign div_quot = n2334; // (signal)
  /* TG68K_ALU.vhd:137:16  */
  assign div_neg = n2337; // (signal)
  /* TG68K_ALU.vhd:138:16  */
  assign div_bit = n2214; // (signal)
  /* TG68K_ALU.vhd:139:16  */
  assign div_sub = n2213; // (signal)
  /* TG68K_ALU.vhd:140:16  */
  assign div_over = n2339; // (signal)
  /* TG68K_ALU.vhd:141:16  */
  assign nozero = n2341; // (signal)
  /* TG68K_ALU.vhd:142:16  */
  assign div_qsign = n2185; // (signal)
  /* TG68K_ALU.vhd:143:16  */
  assign dividend = n2342; // (signal)
  /* TG68K_ALU.vhd:144:16  */
  assign divs = n2099; // (signal)
  /* TG68K_ALU.vhd:145:16  */
  assign signedop = n2344; // (signal)
  /* TG68K_ALU.vhd:146:16  */
  assign op1_sign = n2346; // (signal)
  /* TG68K_ALU.vhd:148:16  */
  assign op2outext = n2200; // (signal)
  /* TG68K_ALU.vhd:151:16  */
  assign datareg = n2349; // (signal)
  /* TG68K_ALU.vhd:153:16  */
  assign bf_datareg = n814; // (signal)
  /* TG68K_ALU.vhd:154:16  */
  assign result = n2351; // (signal)
  /* TG68K_ALU.vhd:155:16  */
  assign result_tmp = n903; // (signal)
  /* TG68K_ALU.vhd:156:16  */
  assign unshifted_bitmask = n2352; // (signal)
  /* TG68K_ALU.vhd:158:16  */
  assign inmux0 = n869; // (signal)
  /* TG68K_ALU.vhd:159:16  */
  assign inmux1 = n874; // (signal)
  /* TG68K_ALU.vhd:160:16  */
  assign inmux2 = n879; // (signal)
  /* TG68K_ALU.vhd:161:16  */
  assign inmux3 = n885; // (signal)
  /* TG68K_ALU.vhd:162:16  */
  assign shifted_bitmask = n859; // (signal)
  /* TG68K_ALU.vhd:163:16  */
  assign bitmaskmux0 = n846; // (signal)
  /* TG68K_ALU.vhd:164:16  */
  assign bitmaskmux1 = n835; // (signal)
  /* TG68K_ALU.vhd:165:16  */
  assign bitmaskmux2 = n824; // (signal)
  /* TG68K_ALU.vhd:166:16  */
  assign bitmaskmux3 = n819; // (signal)
  /* TG68K_ALU.vhd:167:16  */
  assign bf_set2 = n890; // (signal)
  /* TG68K_ALU.vhd:168:16  */
  assign shift = n2354; // (signal)
  /* TG68K_ALU.vhd:169:16  */
  assign bf_firstbit = n1105; // (signal)
  /* TG68K_ALU.vhd:170:16  */
  assign mux = n1182; // (signal)
  /* TG68K_ALU.vhd:171:16  */
  assign bitnr = n2355; // (signal)
  /* TG68K_ALU.vhd:172:16  */
  assign mask = datareg; // (signal)
  /* TG68K_ALU.vhd:173:16  */
  assign mask_not_zero = n1217; // (signal)
  /* TG68K_ALU.vhd:174:16  */
  assign bf_bset = n2357; // (signal)
  /* TG68K_ALU.vhd:175:16  */
  assign bf_nflag = n2514; // (signal)
  /* TG68K_ALU.vhd:176:16  */
  assign bf_bchg = n2359; // (signal)
  /* TG68K_ALU.vhd:177:16  */
  assign bf_ins = n2361; // (signal)
  /* TG68K_ALU.vhd:178:16  */
  assign bf_exts = n2363; // (signal)
  /* TG68K_ALU.vhd:179:16  */
  assign bf_fffo = n2365; // (signal)
  /* TG68K_ALU.vhd:180:16  */
  assign bf_d32 = n2367; // (signal)
  /* TG68K_ALU.vhd:181:16  */
  assign bf_s32 = n2369; // (signal)
  /* TG68K_ALU.vhd:187:16  */
  assign hot_msb = n2663; // (signal)
  /* TG68K_ALU.vhd:188:16  */
  assign vector = n2371; // (signal)
  /* TG68K_ALU.vhd:189:16  */
  assign result_bs = n1724; // (signal)
  /* TG68K_ALU.vhd:190:16  */
  assign bit_nr = n1636; // (signal)
  /* TG68K_ALU.vhd:191:16  */
  assign bit_msb = n1359; // (signal)
  /* TG68K_ALU.vhd:192:16  */
  assign bs_shift = n1349; // (signal)
  /* TG68K_ALU.vhd:193:16  */
  assign bs_shift_mod = n1606; // (signal)
  /* TG68K_ALU.vhd:194:16  */
  assign asl_over = n1391; // (signal)
  /* TG68K_ALU.vhd:195:16  */
  assign asl_over_xor = n2372; // (signal)
  /* TG68K_ALU.vhd:196:16  */
  assign asr_sign = n2373; // (signal)
  /* TG68K_ALU.vhd:197:16  */
  assign msb = n1711; // (signal)
  /* TG68K_ALU.vhd:198:16  */
  assign ring = n1329; // (signal)
  /* TG68K_ALU.vhd:199:16  */
  assign alu = n1513; // (signal)
  /* TG68K_ALU.vhd:200:16  */
  assign bsout = n2374; // (signal)
  /* TG68K_ALU.vhd:201:16  */
  assign bs_v = n1526; // (signal)
  /* TG68K_ALU.vhd:202:16  */
  assign bs_c = n1653; // (signal)
  /* TG68K_ALU.vhd:203:16  */
  assign bs_x = n1528; // (signal)
  /* TG68K_ALU.vhd:215:35  */
  assign n8 = op1in[7]; // extract
  /* TG68K_ALU.vhd:215:39  */
  assign n9 = n8 | exec_tas;
  assign n10 = op1in[31:8]; // extract
  assign n11 = op1in[6:0]; // extract
  /* TG68K_ALU.vhd:216:24  */
  assign n12 = exec[76]; // extract
  /* TG68K_ALU.vhd:217:41  */
  assign n13 = result[31:0]; // extract
  /* TG68K_ALU.vhd:219:57  */
  assign n14 = {26'b0, bf_firstbit};  //  uext
  /* TG68K_ALU.vhd:219:57  */
  assign n15 = bf_ffo_offset - n14;
  /* TG68K_ALU.vhd:218:25  */
  assign n16 = bf_fffo ? n15 : n13;
  assign n17 = {n10, n9, n11};
  /* TG68K_ALU.vhd:216:17  */
  assign n18 = n12 ? n16 : n17;
  /* TG68K_ALU.vhd:224:24  */
  assign n19 = exec[12]; // extract
  /* TG68K_ALU.vhd:224:45  */
  assign n20 = exec[13]; // extract
  /* TG68K_ALU.vhd:224:38  */
  assign n21 = n19 | n20;
  /* TG68K_ALU.vhd:225:51  */
  assign n22 = bcd_a[7:0]; // extract
  /* TG68K_ALU.vhd:226:27  */
  assign n23 = exec[20]; // extract
  /* TG68K_ALU.vhd:226:41  */
  assign n25 = 1'b1 & n23;
  /* TG68K_ALU.vhd:234:40  */
  assign n26 = exec[67]; // extract
  /* TG68K_ALU.vhd:235:61  */
  assign n27 = result_mulu[31:0]; // extract
  /* TG68K_ALU.vhd:238:58  */
  assign n28 = mulu_reg[31:0]; // extract
  /* TG68K_ALU.vhd:234:33  */
  assign n29 = n26 ? n27 : n28;
  /* TG68K_ALU.vhd:241:27  */
  assign n30 = exec[21]; // extract
  /* TG68K_ALU.vhd:241:41  */
  assign n32 = 1'b1 & n30;
  /* TG68K_ALU.vhd:242:38  */
  assign n33 = exe_opcode[15]; // extract
  /* TG68K_ALU.vhd:242:47  */
  assign n35 = n33 | 1'b0;
  /* TG68K_ALU.vhd:244:52  */
  assign n36 = result_div[47:32]; // extract
  /* TG68K_ALU.vhd:244:77  */
  assign n37 = result_div[15:0]; // extract
  /* TG68K_ALU.vhd:244:66  */
  assign n38 = {n36, n37};
  /* TG68K_ALU.vhd:246:40  */
  assign n39 = exec[68]; // extract
  /* TG68K_ALU.vhd:247:60  */
  assign n40 = result_div[63:32]; // extract
  /* TG68K_ALU.vhd:249:60  */
  assign n41 = result_div[31:0]; // extract
  /* TG68K_ALU.vhd:246:33  */
  assign n42 = n39 ? n40 : n41;
  /* TG68K_ALU.vhd:242:25  */
  assign n43 = n35 ? n38 : n42;
  /* TG68K_ALU.vhd:252:27  */
  assign n44 = exec[5]; // extract
  /* TG68K_ALU.vhd:253:41  */
  assign n45 = OP2out | OP1out;
  /* TG68K_ALU.vhd:254:27  */
  assign n46 = exec[6]; // extract
  /* TG68K_ALU.vhd:255:41  */
  assign n47 = OP2out & OP1out;
  /* TG68K_ALU.vhd:256:27  */
  assign n48 = exec[16]; // extract
  assign n49 = {exe_condition, exe_condition, exe_condition, exe_condition};
  assign n50 = {exe_condition, exe_condition, exe_condition, exe_condition};
  assign n51 = {n49, n50};
  /* TG68K_ALU.vhd:258:27  */
  assign n52 = exec[7]; // extract
  /* TG68K_ALU.vhd:259:41  */
  assign n53 = OP2out ^ OP1out;
  /* TG68K_ALU.vhd:261:27  */
  assign n54 = exec[85]; // extract
  /* TG68K_ALU.vhd:264:27  */
  assign n55 = exec[9]; // extract
  /* TG68K_ALU.vhd:266:27  */
  assign n56 = exec[81]; // extract
  /* TG68K_ALU.vhd:268:27  */
  assign n57 = exec[15]; // extract
  /* TG68K_ALU.vhd:269:40  */
  assign n58 = OP1out[15:0]; // extract
  /* TG68K_ALU.vhd:269:61  */
  assign n59 = OP1out[31:16]; // extract
  /* TG68K_ALU.vhd:269:53  */
  assign n60 = {n58, n59};
  /* TG68K_ALU.vhd:270:27  */
  assign n61 = exec[14]; // extract
  /* TG68K_ALU.vhd:272:27  */
  assign n62 = exec[75]; // extract
  /* TG68K_ALU.vhd:274:27  */
  assign n63 = exec[2]; // extract
  /* TG68K_ALU.vhd:276:38  */
  assign n64 = exe_opcode[9]; // extract
  /* TG68K_ALU.vhd:276:25  */
  assign n66 = n64 ? 8'b00000000 : FlagsSR;
  /* TG68K_ALU.vhd:281:27  */
  assign n67 = exec[77]; // extract
  /* TG68K_ALU.vhd:282:54  */
  assign n68 = n249[11:8]; // extract
  /* TG68K_ALU.vhd:282:78  */
  assign n69 = n249[3:0]; // extract
  /* TG68K_ALU.vhd:282:68  */
  assign n70 = {n68, n69};
  assign n71 = n249[7:0]; // extract
  /* TG68K_ALU.vhd:281:17  */
  assign n72 = n67 ? n70 : n71;
  assign n73 = {n66, n2377};
  assign n74 = n73[7:0]; // extract
  /* TG68K_ALU.vhd:274:17  */
  assign n75 = n63 ? n74 : n72;
  assign n76 = n73[15:8]; // extract
  assign n77 = n249[15:8]; // extract
  /* TG68K_ALU.vhd:274:17  */
  assign n78 = n63 ? n76 : n77;
  assign n79 = {n78, n75};
  assign n80 = bf_datareg[15:0]; // extract
  /* TG68K_ALU.vhd:272:17  */
  assign n81 = n62 ? n80 : n79;
  assign n82 = bf_datareg[31:16]; // extract
  assign n83 = n249[31:16]; // extract
  /* TG68K_ALU.vhd:272:17  */
  assign n84 = n62 ? n82 : n83;
  assign n85 = {n84, n81};
  /* TG68K_ALU.vhd:270:17  */
  assign n86 = n61 ? bits_out : n85;
  /* TG68K_ALU.vhd:268:17  */
  assign n87 = n57 ? n60 : n86;
  /* TG68K_ALU.vhd:266:17  */
  assign n88 = n56 ? bsout : n87;
  /* TG68K_ALU.vhd:264:17  */
  assign n89 = n55 ? rot_out : n88;
  /* TG68K_ALU.vhd:261:17  */
  assign n90 = n54 ? OP2out : n89;
  /* TG68K_ALU.vhd:258:17  */
  assign n91 = n52 ? n53 : n90;
  assign n92 = n91[7:0]; // extract
  /* TG68K_ALU.vhd:256:17  */
  assign n93 = n48 ? n51 : n92;
  assign n94 = n91[31:8]; // extract
  assign n95 = n249[31:8]; // extract
  /* TG68K_ALU.vhd:256:17  */
  assign n96 = n48 ? n95 : n94;
  assign n97 = {n96, n93};
  /* TG68K_ALU.vhd:254:17  */
  assign n98 = n46 ? n47 : n97;
  /* TG68K_ALU.vhd:252:17  */
  assign n99 = n44 ? n45 : n98;
  /* TG68K_ALU.vhd:241:17  */
  assign n100 = n32 ? n43 : n99;
  /* TG68K_ALU.vhd:226:17  */
  assign n101 = n25 ? n29 : n100;
  assign n102 = n101[7:0]; // extract
  /* TG68K_ALU.vhd:224:17  */
  assign n103 = n21 ? n22 : n102;
  assign n104 = n101[31:8]; // extract
  assign n105 = n249[31:8]; // extract
  /* TG68K_ALU.vhd:224:17  */
  assign n106 = n21 ? n105 : n104;
  /* TG68K_ALU.vhd:293:24  */
  assign n111 = exec[29]; // extract
  /* TG68K_ALU.vhd:294:34  */
  assign n112 = sndOPC[11]; // extract
  /* TG68K_ALU.vhd:295:51  */
  assign n113 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:295:62  */
  assign n114 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:295:55  */
  assign n115 = {n113, n114};
  /* TG68K_ALU.vhd:295:73  */
  assign n116 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:295:66  */
  assign n117 = {n115, n116};
  /* TG68K_ALU.vhd:295:84  */
  assign n118 = OP1out[31:3]; // extract
  /* TG68K_ALU.vhd:295:77  */
  assign n119 = {n117, n118};
  /* TG68K_ALU.vhd:297:84  */
  assign n120 = sndOPC[10:9]; // extract
  /* TG68K_ALU.vhd:297:77  */
  assign n122 = {30'b000000000000000000000000000000, n120};
  /* TG68K_ALU.vhd:294:25  */
  assign n123 = n112 ? n119 : n122;
  /* TG68K_ALU.vhd:293:17  */
  assign n124 = n111 ? n123 : OP1out;
  /* TG68K_ALU.vhd:301:24  */
  assign n125 = exec[48]; // extract
  /* TG68K_ALU.vhd:301:17  */
  assign n128 = n125 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:309:24  */
  assign n130 = exec[78]; // extract
  /* TG68K_ALU.vhd:310:65  */
  assign n131 = OP2out[7:4]; // extract
  /* TG68K_ALU.vhd:310:57  */
  assign n133 = {4'b0000, n131};
  /* TG68K_ALU.vhd:310:78  */
  assign n135 = {n133, 4'b0000};
  /* TG68K_ALU.vhd:310:95  */
  assign n136 = OP2out[3:0]; // extract
  /* TG68K_ALU.vhd:310:87  */
  assign n137 = {n135, n136};
  /* TG68K_ALU.vhd:311:30  */
  assign n138 = ~execOPC;
  /* TG68K_ALU.vhd:311:43  */
  assign n139 = exec[53]; // extract
  /* TG68K_ALU.vhd:311:55  */
  assign n140 = ~n139;
  /* TG68K_ALU.vhd:311:35  */
  assign n141 = n140 & n138;
  /* TG68K_ALU.vhd:311:68  */
  assign n142 = exec[29]; // extract
  /* TG68K_ALU.vhd:311:82  */
  assign n143 = ~n142;
  /* TG68K_ALU.vhd:311:60  */
  assign n144 = n143 & n141;
  /* TG68K_ALU.vhd:312:38  */
  assign n145 = ~long_start;
  /* TG68K_ALU.vhd:312:59  */
  assign n147 = exe_datatype == 2'b00;
  /* TG68K_ALU.vhd:312:43  */
  assign n148 = n147 & n145;
  /* TG68K_ALU.vhd:312:73  */
  assign n149 = exec[50]; // extract
  /* TG68K_ALU.vhd:312:81  */
  assign n150 = ~n149;
  /* TG68K_ALU.vhd:312:65  */
  assign n151 = n150 & n148;
  /* TG68K_ALU.vhd:316:49  */
  assign n152 = ~long_start;
  /* TG68K_ALU.vhd:316:70  */
  assign n154 = exe_datatype == 2'b10;
  /* TG68K_ALU.vhd:316:54  */
  assign n155 = n154 & n152;
  /* TG68K_ALU.vhd:316:85  */
  assign n156 = exec[47]; // extract
  /* TG68K_ALU.vhd:316:101  */
  assign n157 = exec[46]; // extract
  /* TG68K_ALU.vhd:316:94  */
  assign n158 = n156 | n157;
  /* TG68K_ALU.vhd:316:111  */
  assign n159 = n158 | movem_presub;
  /* TG68K_ALU.vhd:316:134  */
  assign n160 = exec[102]; // extract
  /* TG68K_ALU.vhd:316:127  */
  assign n161 = n159 | n160;
  /* TG68K_ALU.vhd:316:76  */
  assign n162 = n161 & n155;
  /* TG68K_ALU.vhd:317:48  */
  assign n163 = exec[69]; // extract
  /* TG68K_ALU.vhd:319:51  */
  assign n164 = exec[102]; // extract
  /* TG68K_ALU.vhd:321:51  */
  assign n165 = exec[103]; // extract
  /* TG68K_ALU.vhd:321:75  */
  assign n166 = exec[47]; // extract
  /* TG68K_ALU.vhd:321:91  */
  assign n167 = exec[46]; // extract
  /* TG68K_ALU.vhd:321:84  */
  assign n168 = n166 | n167;
  /* TG68K_ALU.vhd:321:101  */
  assign n169 = n168 | movem_presub;
  /* TG68K_ALU.vhd:321:66  */
  assign n170 = n169 & n165;
  /* TG68K_ALU.vhd:321:41  */
  assign n173 = n170 ? 32'b00000000000000000000000000001000 : 32'b00000000000000000000000000000100;
  /* TG68K_ALU.vhd:319:41  */
  assign n175 = n164 ? 32'b00000000000000000000000000000100 : n173;
  /* TG68K_ALU.vhd:317:41  */
  assign n177 = n163 ? 32'b00000000000000000000000000000110 : n175;
  /* TG68K_ALU.vhd:316:33  */
  assign n179 = n162 ? n177 : 32'b00000000000000000000000000000010;
  /* TG68K_ALU.vhd:312:25  */
  assign n181 = n151 ? 32'b00000000000000000000000000000001 : n179;
  /* TG68K_ALU.vhd:330:33  */
  assign n182 = exec[28]; // extract
  /* TG68K_ALU.vhd:330:59  */
  assign n183 = n2377[4]; // extract
  /* TG68K_ALU.vhd:330:50  */
  assign n184 = n183 & n182;
  /* TG68K_ALU.vhd:330:75  */
  assign n185 = exec[31]; // extract
  /* TG68K_ALU.vhd:330:68  */
  assign n186 = n184 | n185;
  /* TG68K_ALU.vhd:330:25  */
  assign n188 = n186 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:333:41  */
  assign n189 = exec[56]; // extract
  /* TG68K_ALU.vhd:311:17  */
  assign n190 = n144 ? n181 : OP2out;
  /* TG68K_ALU.vhd:311:17  */
  assign n191 = n144 ? n128 : n189;
  /* TG68K_ALU.vhd:311:17  */
  assign n192 = n144 ? 1'b0 : n188;
  assign n193 = n190[15:0]; // extract
  /* TG68K_ALU.vhd:309:17  */
  assign n194 = n130 ? n137 : n193;
  assign n195 = n190[31:16]; // extract
  assign n196 = OP2out[31:16]; // extract
  /* TG68K_ALU.vhd:309:17  */
  assign n197 = n130 ? n196 : n195;
  /* TG68K_ALU.vhd:309:17  */
  assign n199 = n130 ? n128 : n191;
  /* TG68K_ALU.vhd:309:17  */
  assign n200 = n130 ? 1'b0 : n192;
  /* TG68K_ALU.vhd:337:24  */
  assign n201 = exec[69]; // extract
  /* TG68K_ALU.vhd:337:43  */
  assign n202 = n201 | check_aligned;
  /* TG68K_ALU.vhd:338:36  */
  assign n203 = ~movem_presub;
  /* TG68K_ALU.vhd:339:64  */
  assign n204 = ~long_start;
  /* TG68K_ALU.vhd:339:48  */
  assign n205 = n204 & non_aligned;
  assign n207 = {n197, n194};
  /* TG68K_ALU.vhd:339:25  */
  assign n208 = n205 ? 32'b00000000000000000000000000000000 : n207;
  /* TG68K_ALU.vhd:343:64  */
  assign n209 = ~long_start;
  /* TG68K_ALU.vhd:343:48  */
  assign n210 = n209 & non_aligned;
  /* TG68K_ALU.vhd:344:44  */
  assign n212 = exe_datatype == 2'b10;
  /* TG68K_ALU.vhd:344:27  */
  assign n215 = n212 ? 32'b00000000000000000000000000001000 : 32'b00000000000000000000000000000100;
  assign n216 = {n197, n194};
  /* TG68K_ALU.vhd:343:25  */
  assign n217 = n210 ? n215 : n216;
  /* TG68K_ALU.vhd:338:19  */
  assign n218 = n203 ? n208 : n217;
  assign n219 = {n197, n194};
  /* TG68K_ALU.vhd:337:17  */
  assign n220 = n202 ? n218 : n219;
  /* TG68K_ALU.vhd:353:28  */
  assign n221 = ~opaddsub;
  /* TG68K_ALU.vhd:353:33  */
  assign n222 = n221 | long_start;
  /* TG68K_ALU.vhd:354:43  */
  assign n224 = {1'b0, addsub_b};
  /* TG68K_ALU.vhd:354:57  */
  assign n225 = c_in[0]; // extract
  /* TG68K_ALU.vhd:354:52  */
  assign n226 = {n224, n225};
  /* TG68K_ALU.vhd:356:48  */
  assign n228 = {1'b0, addsub_b};
  /* TG68K_ALU.vhd:356:62  */
  assign n229 = c_in[0]; // extract
  /* TG68K_ALU.vhd:356:57  */
  assign n230 = {n228, n229};
  /* TG68K_ALU.vhd:356:40  */
  assign n231 = ~n230;
  /* TG68K_ALU.vhd:353:17  */
  assign n232 = n222 ? n226 : n231;
  /* TG68K_ALU.vhd:358:36  */
  assign n234 = {1'b0, addsub_a};
  /* TG68K_ALU.vhd:358:57  */
  assign n235 = notaddsub_b[0]; // extract
  /* TG68K_ALU.vhd:358:45  */
  assign n236 = {n234, n235};
  /* TG68K_ALU.vhd:358:61  */
  assign n237 = n236 + notaddsub_b;
  /* TG68K_ALU.vhd:359:38  */
  assign n238 = add_result[9]; // extract
  /* TG68K_ALU.vhd:359:54  */
  assign n239 = addsub_a[8]; // extract
  /* TG68K_ALU.vhd:359:42  */
  assign n240 = n238 ^ n239;
  /* TG68K_ALU.vhd:359:70  */
  assign n241 = addsub_b[8]; // extract
  /* TG68K_ALU.vhd:359:58  */
  assign n242 = n240 ^ n241;
  /* TG68K_ALU.vhd:360:38  */
  assign n243 = add_result[17]; // extract
  /* TG68K_ALU.vhd:360:55  */
  assign n244 = addsub_a[16]; // extract
  /* TG68K_ALU.vhd:360:43  */
  assign n245 = n243 ^ n244;
  /* TG68K_ALU.vhd:360:72  */
  assign n246 = addsub_b[16]; // extract
  /* TG68K_ALU.vhd:360:60  */
  assign n247 = n245 ^ n246;
  /* TG68K_ALU.vhd:361:38  */
  assign n248 = add_result[33]; // extract
  /* TG68K_ALU.vhd:362:39  */
  assign n249 = add_result[32:1]; // extract
  /* TG68K_ALU.vhd:363:39  */
  assign n250 = c_in[1]; // extract
  /* TG68K_ALU.vhd:363:57  */
  assign n251 = add_result[8]; // extract
  /* TG68K_ALU.vhd:363:43  */
  assign n252 = n250 ^ n251;
  /* TG68K_ALU.vhd:363:73  */
  assign n253 = addsub_a[7]; // extract
  /* TG68K_ALU.vhd:363:61  */
  assign n254 = n252 ^ n253;
  /* TG68K_ALU.vhd:363:89  */
  assign n255 = addsub_b[7]; // extract
  /* TG68K_ALU.vhd:363:77  */
  assign n256 = n254 ^ n255;
  /* TG68K_ALU.vhd:364:39  */
  assign n257 = c_in[2]; // extract
  /* TG68K_ALU.vhd:364:57  */
  assign n258 = add_result[16]; // extract
  /* TG68K_ALU.vhd:364:43  */
  assign n259 = n257 ^ n258;
  /* TG68K_ALU.vhd:364:74  */
  assign n260 = addsub_a[15]; // extract
  /* TG68K_ALU.vhd:364:62  */
  assign n261 = n259 ^ n260;
  /* TG68K_ALU.vhd:364:91  */
  assign n262 = addsub_b[15]; // extract
  /* TG68K_ALU.vhd:364:79  */
  assign n263 = n261 ^ n262;
  /* TG68K_ALU.vhd:365:39  */
  assign n264 = c_in[3]; // extract
  /* TG68K_ALU.vhd:365:57  */
  assign n265 = add_result[32]; // extract
  /* TG68K_ALU.vhd:365:43  */
  assign n266 = n264 ^ n265;
  /* TG68K_ALU.vhd:365:74  */
  assign n267 = addsub_a[31]; // extract
  /* TG68K_ALU.vhd:365:62  */
  assign n268 = n266 ^ n267;
  /* TG68K_ALU.vhd:365:91  */
  assign n269 = addsub_b[31]; // extract
  /* TG68K_ALU.vhd:365:79  */
  assign n270 = n268 ^ n269;
  /* TG68K_ALU.vhd:366:30  */
  assign n271 = c_in[3:1]; // extract
  /* TG68K_ALU.vhd:376:32  */
  assign n275 = c_in[1]; // extract
  /* TG68K_ALU.vhd:376:46  */
  assign n276 = add_result[8:0]; // extract
  /* TG68K_ALU.vhd:376:35  */
  assign n277 = {n275, n276};
  /* TG68K_ALU.vhd:378:38  */
  assign n278 = OP1out[4]; // extract
  /* TG68K_ALU.vhd:378:52  */
  assign n279 = OP2out[4]; // extract
  /* TG68K_ALU.vhd:378:42  */
  assign n280 = n278 ^ n279;
  /* TG68K_ALU.vhd:378:67  */
  assign n281 = bcd_pur[5]; // extract
  /* TG68K_ALU.vhd:378:56  */
  assign n282 = n280 ^ n281;
  /* TG68K_ALU.vhd:379:17  */
  assign n285 = halve_carry ? 4'b0110 : 4'b0000;
  /* TG68K_ALU.vhd:382:27  */
  assign n288 = bcd_pur[9]; // extract
  assign n290 = n286[7:4]; // extract
  /* TG68K_ALU.vhd:382:17  */
  assign n291 = n288 ? 4'b0110 : n290;
  assign n292 = n286[8]; // extract
  /* TG68K_ALU.vhd:385:24  */
  assign n293 = exec[12]; // extract
  /* TG68K_ALU.vhd:386:47  */
  assign n294 = bcd_pur[8]; // extract
  /* TG68K_ALU.vhd:386:36  */
  assign n295 = ~n294;
  /* TG68K_ALU.vhd:386:60  */
  assign n296 = bcd_a[7]; // extract
  /* TG68K_ALU.vhd:386:51  */
  assign n297 = n295 & n296;
  /* TG68K_ALU.vhd:388:41  */
  assign n298 = bcd_pur[9:1]; // extract
  /* TG68K_ALU.vhd:388:54  */
  assign n299 = n298 + bcd_kor;
  /* TG68K_ALU.vhd:389:36  */
  assign n300 = bcd_pur[4]; // extract
  /* TG68K_ALU.vhd:389:52  */
  assign n301 = bcd_pur[3]; // extract
  /* TG68K_ALU.vhd:389:66  */
  assign n302 = bcd_pur[2]; // extract
  /* TG68K_ALU.vhd:389:56  */
  assign n303 = n301 | n302;
  /* TG68K_ALU.vhd:389:40  */
  assign n304 = n300 & n303;
  /* TG68K_ALU.vhd:389:25  */
  assign n306 = n304 ? 4'b0110 : n285;
  /* TG68K_ALU.vhd:392:36  */
  assign n307 = bcd_pur[8]; // extract
  /* TG68K_ALU.vhd:392:52  */
  assign n308 = bcd_pur[7]; // extract
  /* TG68K_ALU.vhd:392:66  */
  assign n309 = bcd_pur[6]; // extract
  /* TG68K_ALU.vhd:392:56  */
  assign n310 = n308 | n309;
  /* TG68K_ALU.vhd:392:81  */
  assign n311 = bcd_pur[5]; // extract
  /* TG68K_ALU.vhd:392:96  */
  assign n312 = bcd_pur[4]; // extract
  /* TG68K_ALU.vhd:392:85  */
  assign n313 = n311 & n312;
  /* TG68K_ALU.vhd:392:112  */
  assign n314 = bcd_pur[3]; // extract
  /* TG68K_ALU.vhd:392:126  */
  assign n315 = bcd_pur[2]; // extract
  /* TG68K_ALU.vhd:392:116  */
  assign n316 = n314 | n315;
  /* TG68K_ALU.vhd:392:100  */
  assign n317 = n313 & n316;
  /* TG68K_ALU.vhd:392:70  */
  assign n318 = n310 | n317;
  /* TG68K_ALU.vhd:392:40  */
  assign n319 = n307 & n318;
  /* TG68K_ALU.vhd:392:25  */
  assign n321 = n319 ? 4'b0110 : n291;
  /* TG68K_ALU.vhd:396:43  */
  assign n322 = bcd_pur[8]; // extract
  /* TG68K_ALU.vhd:396:60  */
  assign n323 = bcd_a[7]; // extract
  /* TG68K_ALU.vhd:396:51  */
  assign n324 = ~n323;
  /* TG68K_ALU.vhd:396:47  */
  assign n325 = n322 & n324;
  /* TG68K_ALU.vhd:398:41  */
  assign n326 = bcd_pur[9:1]; // extract
  /* TG68K_ALU.vhd:398:54  */
  assign n327 = n326 - bcd_kor;
  assign n328 = {n321, n306};
  assign n329 = {n291, n285};
  /* TG68K_ALU.vhd:385:17  */
  assign n330 = n293 ? n328 : n329;
  /* TG68K_ALU.vhd:385:17  */
  assign n331 = n293 ? n297 : n325;
  /* TG68K_ALU.vhd:385:17  */
  assign n332 = n293 ? n299 : n327;
  /* TG68K_ALU.vhd:400:23  */
  assign n333 = CPU[1]; // extract
  /* TG68K_ALU.vhd:400:17  */
  assign n335 = n333 ? 1'b0 : n331;
  /* TG68K_ALU.vhd:403:39  */
  assign n336 = bcd_pur[9]; // extract
  /* TG68K_ALU.vhd:403:51  */
  assign n337 = bcd_a[8]; // extract
  /* TG68K_ALU.vhd:403:43  */
  assign n338 = n336 | n337;
  /* TG68K_ALU.vhd:415:44  */
  assign n343 = opcode[7:6]; // extract
  /* TG68K_ALU.vhd:416:41  */
  assign n345 = n343 == 2'b01;
  /* TG68K_ALU.vhd:418:41  */
  assign n347 = n343 == 2'b11;
  assign n348 = {n347, n345};
  /* TG68K_ALU.vhd:415:33  */
  always @*
    case (n348)
      2'b10: n351 = 1'b0;
      2'b01: n351 = 1'b1;
      default: n351 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:415:33  */
  always @*
    case (n348)
      2'b10: n355 = 1'b1;
      2'b01: n355 = 1'b0;
      default: n355 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:425:30  */
  assign n361 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:425:33  */
  assign n362 = ~n361;
  /* TG68K_ALU.vhd:426:38  */
  assign n363 = exe_opcode[5:4]; // extract
  /* TG68K_ALU.vhd:426:50  */
  assign n365 = n363 == 2'b00;
  /* TG68K_ALU.vhd:427:53  */
  assign n366 = sndOPC[4:0]; // extract
  /* TG68K_ALU.vhd:429:58  */
  assign n367 = sndOPC[2:0]; // extract
  /* TG68K_ALU.vhd:429:51  */
  assign n369 = {2'b00, n367};
  /* TG68K_ALU.vhd:426:25  */
  assign n370 = n365 ? n366 : n369;
  /* TG68K_ALU.vhd:432:38  */
  assign n371 = exe_opcode[5:4]; // extract
  /* TG68K_ALU.vhd:432:50  */
  assign n373 = n371 == 2'b00;
  /* TG68K_ALU.vhd:433:53  */
  assign n374 = reg_QB[4:0]; // extract
  /* TG68K_ALU.vhd:435:58  */
  assign n375 = reg_QB[2:0]; // extract
  /* TG68K_ALU.vhd:435:51  */
  assign n377 = {2'b00, n375};
  /* TG68K_ALU.vhd:432:25  */
  assign n378 = n373 ? n374 : n377;
  /* TG68K_ALU.vhd:425:17  */
  assign n379 = n362 ? n370 : n378;
  /* TG68K_ALU.vhd:441:65  */
  assign n385 = ~one_bit_in;
  /* TG68K_ALU.vhd:441:61  */
  assign n386 = bchg & n385;
  /* TG68K_ALU.vhd:441:81  */
  assign n387 = n386 | bset;
  /* TG68K_ALU.vhd:462:42  */
  assign n393 = opcode[5:4]; // extract
  /* TG68K_ALU.vhd:462:55  */
  assign n395 = n393 == 2'b00;
  /* TG68K_ALU.vhd:462:33  */
  assign n398 = n395 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:465:44  */
  assign n400 = opcode[10:8]; // extract
  /* TG68K_ALU.vhd:466:41  */
  assign n402 = n400 == 3'b010;
  /* TG68K_ALU.vhd:467:41  */
  assign n404 = n400 == 3'b011;
  /* TG68K_ALU.vhd:469:41  */
  assign n406 = n400 == 3'b101;
  /* TG68K_ALU.vhd:470:41  */
  assign n408 = n400 == 3'b110;
  /* TG68K_ALU.vhd:471:41  */
  assign n410 = n400 == 3'b111;
  assign n411 = {n410, n408, n406, n404, n402};
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n414 = 1'b0;
      5'b01000: n414 = 1'b1;
      5'b00100: n414 = 1'b0;
      5'b00010: n414 = 1'b0;
      5'b00001: n414 = 1'b0;
      default: n414 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n418 = 1'b0;
      5'b01000: n418 = 1'b0;
      5'b00100: n418 = 1'b0;
      5'b00010: n418 = 1'b0;
      5'b00001: n418 = 1'b1;
      default: n418 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n422 = 1'b1;
      5'b01000: n422 = 1'b0;
      5'b00100: n422 = 1'b0;
      5'b00010: n422 = 1'b0;
      5'b00001: n422 = 1'b0;
      default: n422 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n426 = 1'b0;
      5'b01000: n426 = 1'b0;
      5'b00100: n426 = 1'b0;
      5'b00010: n426 = 1'b1;
      5'b00001: n426 = 1'b0;
      default: n426 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n430 = 1'b0;
      5'b01000: n430 = 1'b0;
      5'b00100: n430 = 1'b1;
      5'b00010: n430 = 1'b0;
      5'b00001: n430 = 1'b0;
      default: n430 = 1'b0;
    endcase
  /* TG68K_ALU.vhd:465:33  */
  always @*
    case (n411)
      5'b10000: n433 = 1'b1;
      5'b01000: n433 = n398;
      5'b00100: n433 = n398;
      5'b00010: n433 = n398;
      5'b00001: n433 = n398;
      default: n433 = n398;
    endcase
  /* TG68K_ALU.vhd:475:42  */
  assign n434 = opcode[4:3]; // extract
  /* TG68K_ALU.vhd:475:54  */
  assign n436 = n434 == 2'b00;
  /* TG68K_ALU.vhd:475:33  */
  assign n439 = n436 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:478:53  */
  assign n441 = result[39:32]; // extract
  /* TG68K_ALU.vhd:482:17  */
  assign n458 = bf_ins ? reg_QB : bf_set2;
  /* TG68K_ALU.vhd:496:38  */
  assign n459 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n461 = $unsigned(5'b00000) > $unsigned(n459);
  assign n464 = n458[0]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n465 = n461 ? 1'b0 : n464;
  /* TG68K_ALU.vhd:496:25  */
  assign n468 = n461 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:496:38  */
  assign n471 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n473 = $unsigned(5'b00001) > $unsigned(n471);
  assign n476 = n458[1]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n477 = n473 ? 1'b0 : n476;
  assign n479 = n469[1]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n480 = n473 ? 1'b1 : n479;
  /* TG68K_ALU.vhd:496:38  */
  assign n482 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n484 = $unsigned(5'b00010) > $unsigned(n482);
  assign n487 = n458[2]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n488 = n484 ? 1'b0 : n487;
  assign n490 = n469[2]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n491 = n484 ? 1'b1 : n490;
  /* TG68K_ALU.vhd:496:38  */
  assign n493 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n495 = $unsigned(5'b00011) > $unsigned(n493);
  assign n498 = n458[3]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n499 = n495 ? 1'b0 : n498;
  assign n501 = n469[3]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n502 = n495 ? 1'b1 : n501;
  /* TG68K_ALU.vhd:496:38  */
  assign n504 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n506 = $unsigned(5'b00100) > $unsigned(n504);
  assign n509 = n458[4]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n510 = n506 ? 1'b0 : n509;
  assign n512 = n469[4]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n513 = n506 ? 1'b1 : n512;
  /* TG68K_ALU.vhd:496:38  */
  assign n515 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n517 = $unsigned(5'b00101) > $unsigned(n515);
  assign n520 = n458[5]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n521 = n517 ? 1'b0 : n520;
  assign n523 = n469[5]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n524 = n517 ? 1'b1 : n523;
  /* TG68K_ALU.vhd:496:38  */
  assign n526 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n528 = $unsigned(5'b00110) > $unsigned(n526);
  assign n531 = n458[6]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n532 = n528 ? 1'b0 : n531;
  assign n534 = n469[6]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n535 = n528 ? 1'b1 : n534;
  /* TG68K_ALU.vhd:496:38  */
  assign n537 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n539 = $unsigned(5'b00111) > $unsigned(n537);
  assign n542 = n458[7]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n543 = n539 ? 1'b0 : n542;
  assign n545 = n469[7]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n546 = n539 ? 1'b1 : n545;
  /* TG68K_ALU.vhd:496:38  */
  assign n548 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n550 = $unsigned(5'b01000) > $unsigned(n548);
  assign n553 = n458[8]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n554 = n550 ? 1'b0 : n553;
  assign n556 = n469[8]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n557 = n550 ? 1'b1 : n556;
  /* TG68K_ALU.vhd:496:38  */
  assign n559 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n561 = $unsigned(5'b01001) > $unsigned(n559);
  assign n564 = n458[9]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n565 = n561 ? 1'b0 : n564;
  assign n567 = n469[9]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n568 = n561 ? 1'b1 : n567;
  /* TG68K_ALU.vhd:496:38  */
  assign n570 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n572 = $unsigned(5'b01010) > $unsigned(n570);
  assign n575 = n458[10]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n576 = n572 ? 1'b0 : n575;
  assign n578 = n469[10]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n579 = n572 ? 1'b1 : n578;
  /* TG68K_ALU.vhd:496:38  */
  assign n581 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n583 = $unsigned(5'b01011) > $unsigned(n581);
  assign n586 = n458[11]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n587 = n583 ? 1'b0 : n586;
  assign n589 = n469[11]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n590 = n583 ? 1'b1 : n589;
  /* TG68K_ALU.vhd:496:38  */
  assign n592 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n594 = $unsigned(5'b01100) > $unsigned(n592);
  assign n597 = n458[12]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n598 = n594 ? 1'b0 : n597;
  assign n600 = n469[12]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n601 = n594 ? 1'b1 : n600;
  /* TG68K_ALU.vhd:496:38  */
  assign n603 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n605 = $unsigned(5'b01101) > $unsigned(n603);
  assign n608 = n458[13]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n609 = n605 ? 1'b0 : n608;
  assign n611 = n469[13]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n612 = n605 ? 1'b1 : n611;
  /* TG68K_ALU.vhd:496:38  */
  assign n614 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n616 = $unsigned(5'b01110) > $unsigned(n614);
  assign n619 = n458[14]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n620 = n616 ? 1'b0 : n619;
  assign n622 = n469[14]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n623 = n616 ? 1'b1 : n622;
  /* TG68K_ALU.vhd:496:38  */
  assign n625 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n627 = $unsigned(5'b01111) > $unsigned(n625);
  assign n630 = n458[15]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n631 = n627 ? 1'b0 : n630;
  assign n633 = n469[15]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n634 = n627 ? 1'b1 : n633;
  /* TG68K_ALU.vhd:496:38  */
  assign n636 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n638 = $unsigned(5'b10000) > $unsigned(n636);
  assign n641 = n458[16]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n642 = n638 ? 1'b0 : n641;
  assign n644 = n469[16]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n645 = n638 ? 1'b1 : n644;
  /* TG68K_ALU.vhd:496:38  */
  assign n647 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n649 = $unsigned(5'b10001) > $unsigned(n647);
  assign n652 = n458[17]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n653 = n649 ? 1'b0 : n652;
  assign n655 = n469[17]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n656 = n649 ? 1'b1 : n655;
  /* TG68K_ALU.vhd:496:38  */
  assign n658 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n660 = $unsigned(5'b10010) > $unsigned(n658);
  assign n663 = n458[18]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n664 = n660 ? 1'b0 : n663;
  assign n666 = n469[18]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n667 = n660 ? 1'b1 : n666;
  /* TG68K_ALU.vhd:496:38  */
  assign n669 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n671 = $unsigned(5'b10011) > $unsigned(n669);
  assign n674 = n458[19]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n675 = n671 ? 1'b0 : n674;
  assign n677 = n469[19]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n678 = n671 ? 1'b1 : n677;
  /* TG68K_ALU.vhd:496:38  */
  assign n680 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n682 = $unsigned(5'b10100) > $unsigned(n680);
  assign n685 = n458[20]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n686 = n682 ? 1'b0 : n685;
  assign n688 = n469[20]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n689 = n682 ? 1'b1 : n688;
  /* TG68K_ALU.vhd:496:38  */
  assign n691 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n693 = $unsigned(5'b10101) > $unsigned(n691);
  assign n696 = n458[21]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n697 = n693 ? 1'b0 : n696;
  assign n699 = n469[21]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n700 = n693 ? 1'b1 : n699;
  /* TG68K_ALU.vhd:496:38  */
  assign n702 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n704 = $unsigned(5'b10110) > $unsigned(n702);
  assign n707 = n458[22]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n708 = n704 ? 1'b0 : n707;
  assign n710 = n469[22]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n711 = n704 ? 1'b1 : n710;
  /* TG68K_ALU.vhd:496:38  */
  assign n713 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n715 = $unsigned(5'b10111) > $unsigned(n713);
  assign n718 = n458[23]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n719 = n715 ? 1'b0 : n718;
  assign n721 = n469[23]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n722 = n715 ? 1'b1 : n721;
  /* TG68K_ALU.vhd:496:38  */
  assign n724 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n726 = $unsigned(5'b11000) > $unsigned(n724);
  assign n729 = n458[24]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n730 = n726 ? 1'b0 : n729;
  assign n732 = n469[24]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n733 = n726 ? 1'b1 : n732;
  /* TG68K_ALU.vhd:496:38  */
  assign n735 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n737 = $unsigned(5'b11001) > $unsigned(n735);
  assign n740 = n458[25]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n741 = n737 ? 1'b0 : n740;
  assign n743 = n469[25]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n744 = n737 ? 1'b1 : n743;
  /* TG68K_ALU.vhd:496:38  */
  assign n746 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n748 = $unsigned(5'b11010) > $unsigned(n746);
  assign n751 = n458[26]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n752 = n748 ? 1'b0 : n751;
  assign n754 = n469[26]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n755 = n748 ? 1'b1 : n754;
  /* TG68K_ALU.vhd:496:38  */
  assign n757 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n759 = $unsigned(5'b11011) > $unsigned(n757);
  assign n762 = n458[27]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n763 = n759 ? 1'b0 : n762;
  assign n765 = n469[27]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n766 = n759 ? 1'b1 : n765;
  /* TG68K_ALU.vhd:496:38  */
  assign n768 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n770 = $unsigned(5'b11100) > $unsigned(n768);
  assign n773 = n458[28]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n774 = n770 ? 1'b0 : n773;
  assign n776 = n469[28]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n777 = n770 ? 1'b1 : n776;
  /* TG68K_ALU.vhd:496:38  */
  assign n779 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n781 = $unsigned(5'b11101) > $unsigned(n779);
  assign n784 = n458[29]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n785 = n781 ? 1'b0 : n784;
  assign n787 = n469[29]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n788 = n781 ? 1'b1 : n787;
  /* TG68K_ALU.vhd:496:38  */
  assign n790 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n792 = $unsigned(5'b11110) > $unsigned(n790);
  assign n795 = n458[30]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n796 = n792 ? 1'b0 : n795;
  assign n797 = n458[31]; // extract
  assign n798 = n469[30]; // extract
  /* TG68K_ALU.vhd:496:25  */
  assign n799 = n792 ? 1'b1 : n798;
  assign n800 = n469[31]; // extract
  /* TG68K_ALU.vhd:496:38  */
  assign n801 = bf_width[4:0]; // extract
  /* TG68K_ALU.vhd:496:29  */
  assign n803 = $unsigned(5'b11111) > $unsigned(n801);
  /* TG68K_ALU.vhd:496:25  */
  assign n806 = n803 ? 1'b0 : n797;
  /* TG68K_ALU.vhd:496:25  */
  assign n807 = n803 ? 1'b1 : n800;
  /* TG68K_ALU.vhd:502:37  */
  assign n809 = bf_width[4:0];  // trunc
  /* TG68K_ALU.vhd:503:32  */
  assign n812 = bf_nflag & bf_exts;
  /* TG68K_ALU.vhd:504:47  */
  assign n813 = datareg | unshifted_bitmask;
  /* TG68K_ALU.vhd:503:17  */
  assign n814 = n812 ? n813 : datareg;
  /* TG68K_ALU.vhd:510:30  */
  assign n815 = bf_loffset[4]; // extract
  /* TG68K_ALU.vhd:511:57  */
  assign n816 = unshifted_bitmask[15:0]; // extract
  /* TG68K_ALU.vhd:511:88  */
  assign n817 = unshifted_bitmask[31:16]; // extract
  /* TG68K_ALU.vhd:511:70  */
  assign n818 = {n816, n817};
  /* TG68K_ALU.vhd:510:17  */
  assign n819 = n815 ? n818 : unshifted_bitmask;
  /* TG68K_ALU.vhd:515:30  */
  assign n820 = bf_loffset[3]; // extract
  /* TG68K_ALU.vhd:516:64  */
  assign n821 = bitmaskmux3[23:0]; // extract
  /* TG68K_ALU.vhd:516:89  */
  assign n822 = bitmaskmux3[31:24]; // extract
  /* TG68K_ALU.vhd:516:77  */
  assign n823 = {n821, n822};
  /* TG68K_ALU.vhd:515:17  */
  assign n824 = n820 ? n823 : bitmaskmux3;
  /* TG68K_ALU.vhd:520:30  */
  assign n825 = bf_loffset[2]; // extract
  /* TG68K_ALU.vhd:521:51  */
  assign n827 = {bitmaskmux2, 4'b1111};
  /* TG68K_ALU.vhd:523:71  */
  assign n828 = bitmaskmux2[31:28]; // extract
  assign n829 = n827[3:0]; // extract
  /* TG68K_ALU.vhd:522:25  */
  assign n830 = bf_d32 ? n828 : n829;
  assign n831 = n827[35:4]; // extract
  /* TG68K_ALU.vhd:526:46  */
  assign n833 = {4'b1111, bitmaskmux2};
  assign n834 = {n831, n830};
  /* TG68K_ALU.vhd:520:17  */
  assign n835 = n825 ? n834 : n833;
  /* TG68K_ALU.vhd:528:30  */
  assign n836 = bf_loffset[1]; // extract
  /* TG68K_ALU.vhd:529:51  */
  assign n838 = {bitmaskmux1, 2'b11};
  /* TG68K_ALU.vhd:531:71  */
  assign n839 = bitmaskmux1[31:30]; // extract
  assign n840 = n838[1:0]; // extract
  /* TG68K_ALU.vhd:530:25  */
  assign n841 = bf_d32 ? n839 : n840;
  assign n842 = n838[37:2]; // extract
  /* TG68K_ALU.vhd:534:44  */
  assign n844 = {2'b11, bitmaskmux1};
  assign n845 = {n842, n841};
  /* TG68K_ALU.vhd:528:17  */
  assign n846 = n836 ? n845 : n844;
  /* TG68K_ALU.vhd:536:30  */
  assign n847 = bf_loffset[0]; // extract
  /* TG68K_ALU.vhd:537:47  */
  assign n849 = {1'b1, bitmaskmux0};
  /* TG68K_ALU.vhd:537:59  */
  assign n851 = {n849, 1'b1};
  /* TG68K_ALU.vhd:539:66  */
  assign n852 = bitmaskmux0[31]; // extract
  assign n853 = n851[0]; // extract
  /* TG68K_ALU.vhd:538:25  */
  assign n854 = bf_d32 ? n852 : n853;
  assign n855 = n851[39:1]; // extract
  /* TG68K_ALU.vhd:542:48  */
  assign n857 = {2'b11, bitmaskmux0};
  assign n858 = {n855, n854};
  /* TG68K_ALU.vhd:536:17  */
  assign n859 = n847 ? n858 : n857;
  /* TG68K_ALU.vhd:547:35  */
  assign n860 = {bf_ext_in, OP2out};
  /* TG68K_ALU.vhd:549:54  */
  assign n861 = OP2out[7:0]; // extract
  assign n862 = n860[39:32]; // extract
  /* TG68K_ALU.vhd:548:17  */
  assign n863 = bf_s32 ? n861 : n862;
  assign n864 = n860[31:0]; // extract
  /* TG68K_ALU.vhd:552:28  */
  assign n865 = bf_shift[0]; // extract
  /* TG68K_ALU.vhd:553:40  */
  assign n866 = shift[0]; // extract
  /* TG68K_ALU.vhd:553:49  */
  assign n867 = shift[39:1]; // extract
  /* TG68K_ALU.vhd:553:43  */
  assign n868 = {n866, n867};
  /* TG68K_ALU.vhd:552:17  */
  assign n869 = n865 ? n868 : shift;
  /* TG68K_ALU.vhd:557:28  */
  assign n870 = bf_shift[1]; // extract
  /* TG68K_ALU.vhd:558:41  */
  assign n871 = inmux0[1:0]; // extract
  /* TG68K_ALU.vhd:558:60  */
  assign n872 = inmux0[39:2]; // extract
  /* TG68K_ALU.vhd:558:53  */
  assign n873 = {n871, n872};
  /* TG68K_ALU.vhd:557:17  */
  assign n874 = n870 ? n873 : inmux0;
  /* TG68K_ALU.vhd:562:28  */
  assign n875 = bf_shift[2]; // extract
  /* TG68K_ALU.vhd:563:41  */
  assign n876 = inmux1[3:0]; // extract
  /* TG68K_ALU.vhd:563:60  */
  assign n877 = inmux1[39:4]; // extract
  /* TG68K_ALU.vhd:563:53  */
  assign n878 = {n876, n877};
  /* TG68K_ALU.vhd:562:17  */
  assign n879 = n875 ? n878 : inmux1;
  /* TG68K_ALU.vhd:567:28  */
  assign n880 = bf_shift[3]; // extract
  /* TG68K_ALU.vhd:568:41  */
  assign n881 = inmux2[7:0]; // extract
  /* TG68K_ALU.vhd:568:60  */
  assign n882 = inmux2[31:8]; // extract
  /* TG68K_ALU.vhd:568:53  */
  assign n883 = {n881, n882};
  /* TG68K_ALU.vhd:570:41  */
  assign n884 = inmux2[31:0]; // extract
  /* TG68K_ALU.vhd:567:17  */
  assign n885 = n880 ? n883 : n884;
  /* TG68K_ALU.vhd:572:28  */
  assign n886 = bf_shift[4]; // extract
  /* TG68K_ALU.vhd:573:55  */
  assign n887 = inmux3[15:0]; // extract
  /* TG68K_ALU.vhd:573:75  */
  assign n888 = inmux3[31:16]; // extract
  /* TG68K_ALU.vhd:573:68  */
  assign n889 = {n887, n888};
  /* TG68K_ALU.vhd:572:17  */
  assign n890 = n886 ? n889 : inmux3;
  /* TG68K_ALU.vhd:580:56  */
  assign n891 = bf_set2[7:0]; // extract
  /* TG68K_ALU.vhd:582:48  */
  assign n892 = ~OP2out;
  /* TG68K_ALU.vhd:583:49  */
  assign n893 = ~bf_ext_in;
  assign n894 = {n893, n892};
  /* TG68K_ALU.vhd:581:17  */
  assign n896 = bf_bchg ? n894 : 40'b0000000000000000000000000000000000000000;
  assign n897 = {n891, bf_set2};
  /* TG68K_ALU.vhd:578:17  */
  assign n898 = bf_ins ? n897 : n896;
  /* TG68K_ALU.vhd:587:17  */
  assign n900 = bf_bset ? 40'b1111111111111111111111111111111111111111 : n898;
  /* TG68K_ALU.vhd:592:48  */
  assign n901 = {bf_ext_in, OP1out};
  /* TG68K_ALU.vhd:594:48  */
  assign n902 = {bf_ext_in, OP2out};
  /* TG68K_ALU.vhd:591:17  */
  assign n903 = bf_ins ? n901 : n902;
  /* TG68K_ALU.vhd:597:43  */
  assign n904 = shifted_bitmask[0]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n905 = result_tmp[0]; // extract
  assign n906 = n900[0]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n907 = n904 ? n905 : n906;
  /* TG68K_ALU.vhd:597:43  */
  assign n909 = shifted_bitmask[1]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n910 = result_tmp[1]; // extract
  assign n911 = n900[1]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n912 = n909 ? n910 : n911;
  /* TG68K_ALU.vhd:597:43  */
  assign n914 = shifted_bitmask[2]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n915 = result_tmp[2]; // extract
  assign n916 = n900[2]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n917 = n914 ? n915 : n916;
  /* TG68K_ALU.vhd:597:43  */
  assign n919 = shifted_bitmask[3]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n920 = result_tmp[3]; // extract
  assign n921 = n900[3]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n922 = n919 ? n920 : n921;
  /* TG68K_ALU.vhd:597:43  */
  assign n924 = shifted_bitmask[4]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n925 = result_tmp[4]; // extract
  assign n926 = n900[4]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n927 = n924 ? n925 : n926;
  /* TG68K_ALU.vhd:597:43  */
  assign n929 = shifted_bitmask[5]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n930 = result_tmp[5]; // extract
  assign n931 = n900[5]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n932 = n929 ? n930 : n931;
  /* TG68K_ALU.vhd:597:43  */
  assign n934 = shifted_bitmask[6]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n935 = result_tmp[6]; // extract
  assign n936 = n900[6]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n937 = n934 ? n935 : n936;
  /* TG68K_ALU.vhd:597:43  */
  assign n939 = shifted_bitmask[7]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n940 = result_tmp[7]; // extract
  assign n941 = n900[7]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n942 = n939 ? n940 : n941;
  /* TG68K_ALU.vhd:597:43  */
  assign n944 = shifted_bitmask[8]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n945 = result_tmp[8]; // extract
  assign n946 = n900[8]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n947 = n944 ? n945 : n946;
  /* TG68K_ALU.vhd:597:43  */
  assign n949 = shifted_bitmask[9]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n950 = result_tmp[9]; // extract
  assign n951 = n900[9]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n952 = n949 ? n950 : n951;
  /* TG68K_ALU.vhd:597:43  */
  assign n954 = shifted_bitmask[10]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n955 = result_tmp[10]; // extract
  assign n956 = n900[10]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n957 = n954 ? n955 : n956;
  /* TG68K_ALU.vhd:597:43  */
  assign n959 = shifted_bitmask[11]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n960 = result_tmp[11]; // extract
  assign n961 = n900[11]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n962 = n959 ? n960 : n961;
  /* TG68K_ALU.vhd:597:43  */
  assign n964 = shifted_bitmask[12]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n965 = result_tmp[12]; // extract
  assign n966 = n900[12]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n967 = n964 ? n965 : n966;
  /* TG68K_ALU.vhd:597:43  */
  assign n969 = shifted_bitmask[13]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n970 = result_tmp[13]; // extract
  assign n971 = n900[13]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n972 = n969 ? n970 : n971;
  /* TG68K_ALU.vhd:597:43  */
  assign n974 = shifted_bitmask[14]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n975 = result_tmp[14]; // extract
  assign n976 = n900[14]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n977 = n974 ? n975 : n976;
  /* TG68K_ALU.vhd:597:43  */
  assign n979 = shifted_bitmask[15]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n980 = result_tmp[15]; // extract
  assign n981 = n900[15]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n982 = n979 ? n980 : n981;
  /* TG68K_ALU.vhd:597:43  */
  assign n984 = shifted_bitmask[16]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n985 = result_tmp[16]; // extract
  assign n986 = n900[16]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n987 = n984 ? n985 : n986;
  /* TG68K_ALU.vhd:597:43  */
  assign n989 = shifted_bitmask[17]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n990 = result_tmp[17]; // extract
  assign n991 = n900[17]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n992 = n989 ? n990 : n991;
  /* TG68K_ALU.vhd:597:43  */
  assign n994 = shifted_bitmask[18]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n995 = result_tmp[18]; // extract
  assign n996 = n900[18]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n997 = n994 ? n995 : n996;
  /* TG68K_ALU.vhd:597:43  */
  assign n999 = shifted_bitmask[19]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1000 = result_tmp[19]; // extract
  assign n1001 = n900[19]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1002 = n999 ? n1000 : n1001;
  /* TG68K_ALU.vhd:597:43  */
  assign n1004 = shifted_bitmask[20]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1005 = result_tmp[20]; // extract
  assign n1006 = n900[20]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1007 = n1004 ? n1005 : n1006;
  /* TG68K_ALU.vhd:597:43  */
  assign n1009 = shifted_bitmask[21]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1010 = result_tmp[21]; // extract
  assign n1011 = n900[21]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1012 = n1009 ? n1010 : n1011;
  /* TG68K_ALU.vhd:597:43  */
  assign n1014 = shifted_bitmask[22]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1015 = result_tmp[22]; // extract
  assign n1016 = n900[22]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1017 = n1014 ? n1015 : n1016;
  /* TG68K_ALU.vhd:597:43  */
  assign n1019 = shifted_bitmask[23]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1020 = result_tmp[23]; // extract
  assign n1021 = n900[23]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1022 = n1019 ? n1020 : n1021;
  /* TG68K_ALU.vhd:597:43  */
  assign n1024 = shifted_bitmask[24]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1025 = result_tmp[24]; // extract
  assign n1026 = n900[24]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1027 = n1024 ? n1025 : n1026;
  /* TG68K_ALU.vhd:597:43  */
  assign n1029 = shifted_bitmask[25]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1030 = result_tmp[25]; // extract
  assign n1031 = n900[25]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1032 = n1029 ? n1030 : n1031;
  /* TG68K_ALU.vhd:597:43  */
  assign n1034 = shifted_bitmask[26]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1035 = result_tmp[26]; // extract
  assign n1036 = n900[26]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1037 = n1034 ? n1035 : n1036;
  /* TG68K_ALU.vhd:597:43  */
  assign n1039 = shifted_bitmask[27]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1040 = result_tmp[27]; // extract
  assign n1041 = n900[27]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1042 = n1039 ? n1040 : n1041;
  /* TG68K_ALU.vhd:597:43  */
  assign n1044 = shifted_bitmask[28]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1045 = result_tmp[28]; // extract
  assign n1046 = n900[28]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1047 = n1044 ? n1045 : n1046;
  /* TG68K_ALU.vhd:597:43  */
  assign n1049 = shifted_bitmask[29]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1050 = result_tmp[29]; // extract
  assign n1051 = n900[29]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1052 = n1049 ? n1050 : n1051;
  /* TG68K_ALU.vhd:597:43  */
  assign n1054 = shifted_bitmask[30]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1055 = result_tmp[30]; // extract
  assign n1056 = n900[30]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1057 = n1054 ? n1055 : n1056;
  /* TG68K_ALU.vhd:597:43  */
  assign n1059 = shifted_bitmask[31]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1060 = result_tmp[31]; // extract
  assign n1061 = n900[31]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1062 = n1059 ? n1060 : n1061;
  /* TG68K_ALU.vhd:597:43  */
  assign n1064 = shifted_bitmask[32]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1065 = result_tmp[32]; // extract
  assign n1066 = n900[32]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1067 = n1064 ? n1065 : n1066;
  /* TG68K_ALU.vhd:597:43  */
  assign n1069 = shifted_bitmask[33]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1070 = result_tmp[33]; // extract
  assign n1071 = n900[33]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1072 = n1069 ? n1070 : n1071;
  /* TG68K_ALU.vhd:597:43  */
  assign n1074 = shifted_bitmask[34]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1075 = result_tmp[34]; // extract
  assign n1076 = n900[34]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1077 = n1074 ? n1075 : n1076;
  /* TG68K_ALU.vhd:597:43  */
  assign n1079 = shifted_bitmask[35]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1080 = result_tmp[35]; // extract
  assign n1081 = n900[35]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1082 = n1079 ? n1080 : n1081;
  /* TG68K_ALU.vhd:597:43  */
  assign n1084 = shifted_bitmask[36]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1085 = result_tmp[36]; // extract
  assign n1086 = n900[36]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1087 = n1084 ? n1085 : n1086;
  /* TG68K_ALU.vhd:597:43  */
  assign n1089 = shifted_bitmask[37]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1090 = result_tmp[37]; // extract
  assign n1091 = n900[37]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1092 = n1089 ? n1090 : n1091;
  /* TG68K_ALU.vhd:597:43  */
  assign n1094 = shifted_bitmask[38]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1095 = result_tmp[38]; // extract
  assign n1096 = n900[38]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1097 = n1094 ? n1095 : n1096;
  assign n1098 = n900[39]; // extract
  /* TG68K_ALU.vhd:597:43  */
  assign n1099 = shifted_bitmask[39]; // extract
  /* TG68K_ALU.vhd:598:56  */
  assign n1100 = result_tmp[39]; // extract
  /* TG68K_ALU.vhd:597:25  */
  assign n1101 = n1099 ? n1100 : n1098;
  /* TG68K_ALU.vhd:604:36  */
  assign n1103 = {1'b0, bitnr};
  /* TG68K_ALU.vhd:604:43  */
  assign n1104 = {5'b0, mask_not_zero};  //  uext
  /* TG68K_ALU.vhd:604:43  */
  assign n1105 = n1103 + n1104;
  /* TG68K_ALU.vhd:607:24  */
  assign n1106 = mask[31:28]; // extract
  /* TG68K_ALU.vhd:607:38  */
  assign n1108 = n1106 == 4'b0000;
  /* TG68K_ALU.vhd:608:32  */
  assign n1109 = mask[27:24]; // extract
  /* TG68K_ALU.vhd:608:46  */
  assign n1111 = n1109 == 4'b0000;
  /* TG68K_ALU.vhd:609:40  */
  assign n1112 = mask[23:20]; // extract
  /* TG68K_ALU.vhd:609:54  */
  assign n1114 = n1112 == 4'b0000;
  /* TG68K_ALU.vhd:610:48  */
  assign n1115 = mask[19:16]; // extract
  /* TG68K_ALU.vhd:610:62  */
  assign n1117 = n1115 == 4'b0000;
  /* TG68K_ALU.vhd:612:56  */
  assign n1119 = mask[15:12]; // extract
  /* TG68K_ALU.vhd:612:70  */
  assign n1121 = n1119 == 4'b0000;
  /* TG68K_ALU.vhd:613:64  */
  assign n1122 = mask[11:8]; // extract
  /* TG68K_ALU.vhd:613:77  */
  assign n1124 = n1122 == 4'b0000;
  /* TG68K_ALU.vhd:615:72  */
  assign n1126 = mask[7:4]; // extract
  /* TG68K_ALU.vhd:615:84  */
  assign n1128 = n1126 == 4'b0000;
  /* TG68K_ALU.vhd:617:84  */
  assign n1130 = mask[3:0]; // extract
  /* TG68K_ALU.vhd:619:84  */
  assign n1131 = mask[7:4]; // extract
  /* TG68K_ALU.vhd:615:65  */
  assign n1132 = n1128 ? n1130 : n1131;
  /* TG68K_ALU.vhd:615:65  */
  assign n1134 = n1128 ? 1'b0 : 1'b1;
  /* TG68K_ALU.vhd:622:76  */
  assign n1135 = mask[11:8]; // extract
  /* TG68K_ALU.vhd:613:57  */
  assign n1137 = n1124 ? n1132 : n1135;
  assign n1138 = {1'b0, n1134};
  assign n1139 = n1138[0]; // extract
  /* TG68K_ALU.vhd:613:57  */
  assign n1140 = n1124 ? n1139 : 1'b0;
  assign n1141 = n1138[1]; // extract
  /* TG68K_ALU.vhd:613:57  */
  assign n1143 = n1124 ? n1141 : 1'b1;
  /* TG68K_ALU.vhd:626:68  */
  assign n1144 = mask[15:12]; // extract
  /* TG68K_ALU.vhd:612:49  */
  assign n1145 = n1121 ? n1137 : n1144;
  assign n1146 = {n1143, n1140};
  /* TG68K_ALU.vhd:612:49  */
  assign n1148 = n1121 ? n1146 : 2'b11;
  /* TG68K_ALU.vhd:629:60  */
  assign n1149 = mask[19:16]; // extract
  /* TG68K_ALU.vhd:610:41  */
  assign n1152 = n1117 ? n1145 : n1149;
  assign n1153 = {1'b0, 1'b0};
  assign n1154 = {1'b0, n1148};
  assign n1155 = n1154[1:0]; // extract
  /* TG68K_ALU.vhd:610:41  */
  assign n1156 = n1117 ? n1155 : n1153;
  assign n1157 = n1154[2]; // extract
  /* TG68K_ALU.vhd:610:41  */
  assign n1159 = n1117 ? n1157 : 1'b1;
  /* TG68K_ALU.vhd:634:52  */
  assign n1160 = mask[23:20]; // extract
  /* TG68K_ALU.vhd:609:33  */
  assign n1162 = n1114 ? n1152 : n1160;
  assign n1163 = {n1159, n1156};
  assign n1164 = n1163[0]; // extract
  /* TG68K_ALU.vhd:609:33  */
  assign n1166 = n1114 ? n1164 : 1'b1;
  assign n1167 = n1163[1]; // extract
  /* TG68K_ALU.vhd:609:33  */
  assign n1168 = n1114 ? n1167 : 1'b0;
  assign n1169 = n1163[2]; // extract
  /* TG68K_ALU.vhd:609:33  */
  assign n1171 = n1114 ? n1169 : 1'b1;
  /* TG68K_ALU.vhd:638:44  */
  assign n1172 = mask[27:24]; // extract
  /* TG68K_ALU.vhd:608:25  */
  assign n1174 = n1111 ? n1162 : n1172;
  assign n1175 = {n1171, n1168, n1166};
  assign n1176 = n1175[0]; // extract
  /* TG68K_ALU.vhd:608:25  */
  assign n1177 = n1111 ? n1176 : 1'b0;
  assign n1178 = n1175[2:1]; // extract
  /* TG68K_ALU.vhd:608:25  */
  assign n1180 = n1111 ? n1178 : 2'b11;
  /* TG68K_ALU.vhd:642:36  */
  assign n1181 = mask[31:28]; // extract
  /* TG68K_ALU.vhd:607:17  */
  assign n1182 = n1108 ? n1174 : n1181;
  assign n1183 = {n1180, n1177};
  /* TG68K_ALU.vhd:607:17  */
  assign n1185 = n1108 ? n1183 : 3'b111;
  /* TG68K_ALU.vhd:645:23  */
  assign n1188 = mux[3:2]; // extract
  /* TG68K_ALU.vhd:645:35  */
  assign n1190 = n1188 == 2'b00;
  /* TG68K_ALU.vhd:647:31  */
  assign n1192 = mux[1]; // extract
  /* TG68K_ALU.vhd:647:34  */
  assign n1193 = ~n1192;
  /* TG68K_ALU.vhd:649:39  */
  assign n1195 = mux[0]; // extract
  /* TG68K_ALU.vhd:649:42  */
  assign n1196 = ~n1195;
  /* TG68K_ALU.vhd:649:33  */
  assign n1199 = n1196 ? 1'b0 : 1'b1;
  assign n1200 = n1186[0]; // extract
  /* TG68K_ALU.vhd:647:25  */
  assign n1201 = n1193 ? 1'b0 : n1200;
  /* TG68K_ALU.vhd:647:25  */
  assign n1203 = n1193 ? n1199 : 1'b1;
  /* TG68K_ALU.vhd:654:31  */
  assign n1204 = mux[3]; // extract
  /* TG68K_ALU.vhd:654:34  */
  assign n1205 = ~n1204;
  assign n1207 = n1186[0]; // extract
  /* TG68K_ALU.vhd:654:25  */
  assign n1208 = n1205 ? 1'b0 : n1207;
  assign n1209 = {1'b0, n1201};
  assign n1210 = n1209[0]; // extract
  /* TG68K_ALU.vhd:645:17  */
  assign n1211 = n1190 ? n1210 : n1208;
  assign n1212 = n1209[1]; // extract
  assign n1213 = n1186[1]; // extract
  /* TG68K_ALU.vhd:645:17  */
  assign n1214 = n1190 ? n1212 : n1213;
  /* TG68K_ALU.vhd:645:17  */
  assign n1217 = n1190 ? n1203 : 1'b1;
  /* TG68K_ALU.vhd:665:32  */
  assign n1222 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:667:66  */
  assign n1223 = OP1out[7]; // extract
  /* TG68K_ALU.vhd:666:25  */
  assign n1225 = n1222 == 2'b00;
  /* TG68K_ALU.vhd:669:66  */
  assign n1226 = OP1out[15]; // extract
  /* TG68K_ALU.vhd:668:25  */
  assign n1228 = n1222 == 2'b01;
  /* TG68K_ALU.vhd:668:34  */
  assign n1230 = n1222 == 2'b11;
  /* TG68K_ALU.vhd:668:34  */
  assign n1231 = n1228 | n1230;
  /* TG68K_ALU.vhd:671:66  */
  assign n1232 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:670:25  */
  assign n1234 = n1222 == 2'b10;
  assign n1235 = {n1234, n1231, n1225};
  /* TG68K_ALU.vhd:665:17  */
  always @*
    case (n1235)
      3'b100: n1236 = n1232;
      3'b010: n1236 = n1226;
      3'b001: n1236 = n1223;
      default: n1236 = rot_rot;
    endcase
  /* TG68K_ALU.vhd:691:24  */
  assign n1254 = exec[23]; // extract
  /* TG68K_ALU.vhd:693:39  */
  assign n1255 = n2377[4]; // extract
  /* TG68K_ALU.vhd:694:36  */
  assign n1257 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:695:47  */
  assign n1258 = n2377[4]; // extract
  /* TG68K_ALU.vhd:694:25  */
  assign n1260 = n1257 ? n1258 : 1'b0;
  /* TG68K_ALU.vhd:700:38  */
  assign n1261 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:705:48  */
  assign n1264 = OP1out[0]; // extract
  /* TG68K_ALU.vhd:706:48  */
  assign n1265 = OP1out[0]; // extract
  /* TG68K_ALU.vhd:700:25  */
  assign n1285 = n1261 ? rot_rot : n1264;
  /* TG68K_ALU.vhd:700:25  */
  assign n1286 = n1261 ? rot_rot : n1265;
  /* TG68K_ALU.vhd:691:17  */
  assign n1289 = n1254 ? n1255 : n1285;
  /* TG68K_ALU.vhd:691:17  */
  assign n1290 = n1254 ? n1260 : n1286;
  /* TG68K_ALU.vhd:691:17  */
  assign n1291 = n1254 ? OP1out : bsout;
  /* TG68K_ALU.vhd:729:28  */
  assign n1296 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:730:40  */
  assign n1297 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:731:33  */
  assign n1299 = n1297 == 2'b00;
  /* TG68K_ALU.vhd:733:33  */
  assign n1301 = n1297 == 2'b01;
  /* TG68K_ALU.vhd:733:42  */
  assign n1303 = n1297 == 2'b11;
  /* TG68K_ALU.vhd:733:42  */
  assign n1304 = n1301 | n1303;
  /* TG68K_ALU.vhd:735:33  */
  assign n1306 = n1297 == 2'b10;
  assign n1307 = {n1306, n1304, n1299};
  /* TG68K_ALU.vhd:730:25  */
  always @*
    case (n1307)
      3'b100: n1312 = 6'b100001;
      3'b010: n1312 = 6'b010001;
      3'b001: n1312 = 6'b001001;
      default: n1312 = 6'b100000;
    endcase
  /* TG68K_ALU.vhd:740:40  */
  assign n1313 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:741:33  */
  assign n1315 = n1313 == 2'b00;
  /* TG68K_ALU.vhd:743:33  */
  assign n1317 = n1313 == 2'b01;
  /* TG68K_ALU.vhd:743:42  */
  assign n1319 = n1313 == 2'b11;
  /* TG68K_ALU.vhd:743:42  */
  assign n1320 = n1317 | n1319;
  /* TG68K_ALU.vhd:745:33  */
  assign n1322 = n1313 == 2'b10;
  assign n1323 = {n1322, n1320, n1315};
  /* TG68K_ALU.vhd:740:25  */
  always @*
    case (n1323)
      3'b100: n1328 = 6'b100000;
      3'b010: n1328 = 6'b010000;
      3'b001: n1328 = 6'b001000;
      default: n1328 = 6'b100000;
    endcase
  /* TG68K_ALU.vhd:729:17  */
  assign n1329 = n1296 ? n1312 : n1328;
  /* TG68K_ALU.vhd:751:30  */
  assign n1331 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:751:42  */
  assign n1333 = n1331 == 2'b11;
  /* TG68K_ALU.vhd:751:55  */
  assign n1334 = exec[81]; // extract
  /* TG68K_ALU.vhd:751:64  */
  assign n1335 = ~n1334;
  /* TG68K_ALU.vhd:751:48  */
  assign n1336 = n1333 | n1335;
  /* TG68K_ALU.vhd:753:33  */
  assign n1337 = exe_opcode[5]; // extract
  /* TG68K_ALU.vhd:754:43  */
  assign n1338 = OP2out[5:0]; // extract
  /* TG68K_ALU.vhd:756:59  */
  assign n1339 = exe_opcode[11:9]; // extract
  /* TG68K_ALU.vhd:757:38  */
  assign n1340 = exe_opcode[11:9]; // extract
  /* TG68K_ALU.vhd:757:51  */
  assign n1342 = n1340 == 3'b000;
  /* TG68K_ALU.vhd:757:25  */
  assign n1345 = n1342 ? 3'b001 : 3'b000;
  assign n1346 = {n1345, n1339};
  /* TG68K_ALU.vhd:753:17  */
  assign n1347 = n1337 ? n1338 : n1346;
  /* TG68K_ALU.vhd:751:17  */
  assign n1349 = n1336 ? 6'b000001 : n1347;
  /* TG68K_ALU.vhd:768:29  */
  assign n1356 = $unsigned(bs_shift) < $unsigned(ring);
  /* TG68K_ALU.vhd:769:40  */
  assign n1357 = ring - bs_shift;
  /* TG68K_ALU.vhd:768:17  */
  assign n1359 = n1356 ? n1357 : 6'b000000;
  /* TG68K_ALU.vhd:771:45  */
  assign n1361 = vector[30:0]; // extract
  /* TG68K_ALU.vhd:771:38  */
  assign n1363 = {1'b0, n1361};
  /* TG68K_ALU.vhd:771:75  */
  assign n1364 = vector[31:1]; // extract
  /* TG68K_ALU.vhd:771:68  */
  assign n1366 = {1'b0, n1364};
  /* TG68K_ALU.vhd:771:60  */
  assign n1367 = n1363 ^ n1366;
  /* TG68K_ALU.vhd:771:90  */
  assign n1368 = {n1367, msb};
  /* TG68K_ALU.vhd:772:32  */
  assign n1369 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:773:25  */
  assign n1372 = n1369 == 2'b00;
  /* TG68K_ALU.vhd:775:25  */
  assign n1375 = n1369 == 2'b01;
  /* TG68K_ALU.vhd:775:34  */
  assign n1377 = n1369 == 2'b11;
  /* TG68K_ALU.vhd:775:34  */
  assign n1378 = n1375 | n1377;
  assign n1379 = {n1378, n1372};
  assign n1380 = n1368[8]; // extract
  /* TG68K_ALU.vhd:772:17  */
  always @*
    case (n1379)
      2'b10: n1381 = n1380;
      2'b01: n1381 = 1'b0;
      default: n1381 = n1380;
    endcase
  assign n1382 = n1368[16]; // extract
  /* TG68K_ALU.vhd:772:17  */
  always @*
    case (n1379)
      2'b10: n1383 = 1'b0;
      2'b01: n1383 = n1382;
      default: n1383 = n1382;
    endcase
  assign n1385 = n1368[7:0]; // extract
  assign n1386 = n1368[32:17]; // extract
  assign n1387 = n1368[15:9]; // extract
  /* TG68K_ALU.vhd:779:56  */
  assign n1388 = hot_msb[31:0]; // extract
  /* TG68K_ALU.vhd:779:48  */
  assign n1390 = {1'b0, n1388};
  /* TG68K_ALU.vhd:779:42  */
  assign n1391 = asl_over_xor - n1390;
  /* TG68K_ALU.vhd:781:28  */
  assign n1393 = rot_bits == 2'b00;
  /* TG68K_ALU.vhd:781:48  */
  assign n1394 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:781:34  */
  assign n1395 = n1394 & n1393;
  /* TG68K_ALU.vhd:782:45  */
  assign n1396 = asl_over[32]; // extract
  /* TG68K_ALU.vhd:782:33  */
  assign n1397 = ~n1396;
  /* TG68K_ALU.vhd:781:17  */
  assign n1399 = n1395 ? n1397 : 1'b0;
  /* TG68K_ALU.vhd:786:30  */
  assign n1401 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:786:33  */
  assign n1402 = ~n1401;
  /* TG68K_ALU.vhd:787:42  */
  assign n1403 = result_bs[31]; // extract
  /* TG68K_ALU.vhd:789:40  */
  assign n1404 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:791:58  */
  assign n1405 = result_bs[8]; // extract
  /* TG68K_ALU.vhd:790:33  */
  assign n1407 = n1404 == 2'b00;
  /* TG68K_ALU.vhd:793:58  */
  assign n1408 = result_bs[16]; // extract
  /* TG68K_ALU.vhd:792:33  */
  assign n1410 = n1404 == 2'b01;
  /* TG68K_ALU.vhd:792:42  */
  assign n1412 = n1404 == 2'b11;
  /* TG68K_ALU.vhd:792:42  */
  assign n1413 = n1410 | n1412;
  /* TG68K_ALU.vhd:795:58  */
  assign n1414 = result_bs[32]; // extract
  /* TG68K_ALU.vhd:794:33  */
  assign n1416 = n1404 == 2'b10;
  assign n1417 = {n1416, n1413, n1407};
  /* TG68K_ALU.vhd:789:25  */
  always @*
    case (n1417)
      3'b100: n1418 = n1414;
      3'b010: n1418 = n1408;
      3'b001: n1418 = n1405;
      default: n1418 = bs_c;
    endcase
  /* TG68K_ALU.vhd:786:17  */
  assign n1419 = n1402 ? n1403 : n1418;
  /* TG68K_ALU.vhd:801:28  */
  assign n1421 = rot_bits == 2'b11;
  /* TG68K_ALU.vhd:802:38  */
  assign n1422 = n2377[4]; // extract
  /* TG68K_ALU.vhd:803:40  */
  assign n1423 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:805:69  */
  assign n1424 = result_bs[7:0]; // extract
  /* TG68K_ALU.vhd:805:94  */
  assign n1425 = result_bs[15:8]; // extract
  /* TG68K_ALU.vhd:805:82  */
  assign n1426 = n1424 | n1425;
  /* TG68K_ALU.vhd:806:52  */
  assign n1427 = alu[7]; // extract
  /* TG68K_ALU.vhd:804:33  */
  assign n1429 = n1423 == 2'b00;
  /* TG68K_ALU.vhd:808:70  */
  assign n1430 = result_bs[15:0]; // extract
  /* TG68K_ALU.vhd:808:96  */
  assign n1431 = result_bs[31:16]; // extract
  /* TG68K_ALU.vhd:808:84  */
  assign n1432 = n1430 | n1431;
  /* TG68K_ALU.vhd:809:52  */
  assign n1433 = alu[15]; // extract
  /* TG68K_ALU.vhd:807:33  */
  assign n1435 = n1423 == 2'b01;
  /* TG68K_ALU.vhd:807:42  */
  assign n1437 = n1423 == 2'b11;
  /* TG68K_ALU.vhd:807:42  */
  assign n1438 = n1435 | n1437;
  /* TG68K_ALU.vhd:811:57  */
  assign n1439 = result_bs[31:0]; // extract
  /* TG68K_ALU.vhd:811:83  */
  assign n1440 = result_bs[63:32]; // extract
  /* TG68K_ALU.vhd:811:71  */
  assign n1441 = n1439 | n1440;
  /* TG68K_ALU.vhd:812:52  */
  assign n1442 = alu[31]; // extract
  /* TG68K_ALU.vhd:810:33  */
  assign n1444 = n1423 == 2'b10;
  assign n1445 = {n1444, n1438, n1429};
  assign n1446 = n1432[7:0]; // extract
  assign n1447 = n1441[7:0]; // extract
  /* TG68K_ALU.vhd:803:25  */
  always @*
    case (n1445)
      3'b100: n1449 = n1447;
      3'b010: n1449 = n1446;
      3'b001: n1449 = n1426;
      default: n1449 = 8'bX;
    endcase
  assign n1450 = n1432[15:8]; // extract
  assign n1451 = n1441[15:8]; // extract
  /* TG68K_ALU.vhd:803:25  */
  always @*
    case (n1445)
      3'b100: n1453 = n1451;
      3'b010: n1453 = n1450;
      3'b001: n1453 = 8'bX;
      default: n1453 = 8'bX;
    endcase
  assign n1454 = n1441[31:16]; // extract
  /* TG68K_ALU.vhd:803:25  */
  always @*
    case (n1445)
      3'b100: n1456 = n1454;
      3'b010: n1456 = 16'bX;
      3'b001: n1456 = 16'bX;
      default: n1456 = 16'bX;
    endcase
  /* TG68K_ALU.vhd:803:25  */
  always @*
    case (n1445)
      3'b100: n1457 = n1442;
      3'b010: n1457 = n1433;
      3'b001: n1457 = n1427;
      default: n1457 = n1419;
    endcase
  /* TG68K_ALU.vhd:815:38  */
  assign n1458 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:816:44  */
  assign n1459 = alu[0]; // extract
  /* TG68K_ALU.vhd:815:25  */
  assign n1460 = n1458 ? n1459 : n1457;
  /* TG68K_ALU.vhd:818:31  */
  assign n1462 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:819:40  */
  assign n1463 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:821:69  */
  assign n1464 = result_bs[7:0]; // extract
  /* TG68K_ALU.vhd:821:94  */
  assign n1465 = result_bs[16:9]; // extract
  /* TG68K_ALU.vhd:821:82  */
  assign n1466 = n1464 | n1465;
  /* TG68K_ALU.vhd:822:58  */
  assign n1467 = result_bs[8]; // extract
  /* TG68K_ALU.vhd:822:74  */
  assign n1468 = result_bs[17]; // extract
  /* TG68K_ALU.vhd:822:62  */
  assign n1469 = n1467 | n1468;
  /* TG68K_ALU.vhd:820:33  */
  assign n1471 = n1463 == 2'b00;
  /* TG68K_ALU.vhd:824:70  */
  assign n1472 = result_bs[15:0]; // extract
  /* TG68K_ALU.vhd:824:96  */
  assign n1473 = result_bs[32:17]; // extract
  /* TG68K_ALU.vhd:824:84  */
  assign n1474 = n1472 | n1473;
  /* TG68K_ALU.vhd:825:58  */
  assign n1475 = result_bs[16]; // extract
  /* TG68K_ALU.vhd:825:75  */
  assign n1476 = result_bs[33]; // extract
  /* TG68K_ALU.vhd:825:63  */
  assign n1477 = n1475 | n1476;
  /* TG68K_ALU.vhd:823:33  */
  assign n1479 = n1463 == 2'b01;
  /* TG68K_ALU.vhd:823:42  */
  assign n1481 = n1463 == 2'b11;
  /* TG68K_ALU.vhd:823:42  */
  assign n1482 = n1479 | n1481;
  /* TG68K_ALU.vhd:827:57  */
  assign n1483 = result_bs[31:0]; // extract
  /* TG68K_ALU.vhd:827:83  */
  assign n1484 = result_bs[64:33]; // extract
  /* TG68K_ALU.vhd:827:71  */
  assign n1485 = n1483 | n1484;
  /* TG68K_ALU.vhd:828:58  */
  assign n1486 = result_bs[32]; // extract
  /* TG68K_ALU.vhd:828:75  */
  assign n1487 = result_bs[65]; // extract
  /* TG68K_ALU.vhd:828:63  */
  assign n1488 = n1486 | n1487;
  /* TG68K_ALU.vhd:826:33  */
  assign n1490 = n1463 == 2'b10;
  assign n1491 = {n1490, n1482, n1471};
  assign n1492 = n1474[7:0]; // extract
  assign n1493 = n1485[7:0]; // extract
  /* TG68K_ALU.vhd:819:25  */
  always @*
    case (n1491)
      3'b100: n1495 = n1493;
      3'b010: n1495 = n1492;
      3'b001: n1495 = n1466;
      default: n1495 = 8'bX;
    endcase
  assign n1496 = n1474[15:8]; // extract
  assign n1497 = n1485[15:8]; // extract
  /* TG68K_ALU.vhd:819:25  */
  always @*
    case (n1491)
      3'b100: n1499 = n1497;
      3'b010: n1499 = n1496;
      3'b001: n1499 = 8'bX;
      default: n1499 = 8'bX;
    endcase
  assign n1500 = n1485[31:16]; // extract
  /* TG68K_ALU.vhd:819:25  */
  always @*
    case (n1491)
      3'b100: n1502 = n1500;
      3'b010: n1502 = 16'bX;
      3'b001: n1502 = 16'bX;
      default: n1502 = 16'bX;
    endcase
  /* TG68K_ALU.vhd:819:25  */
  always @*
    case (n1491)
      3'b100: n1503 = n1488;
      3'b010: n1503 = n1477;
      3'b001: n1503 = n1469;
      default: n1503 = n1419;
    endcase
  /* TG68K_ALU.vhd:832:38  */
  assign n1504 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:832:41  */
  assign n1505 = ~n1504;
  /* TG68K_ALU.vhd:833:49  */
  assign n1506 = result_bs[63:32]; // extract
  /* TG68K_ALU.vhd:835:49  */
  assign n1507 = result_bs[31:0]; // extract
  /* TG68K_ALU.vhd:832:25  */
  assign n1508 = n1505 ? n1506 : n1507;
  assign n1509 = {n1502, n1499, n1495};
  /* TG68K_ALU.vhd:818:17  */
  assign n1510 = n1462 ? n1509 : n1508;
  /* TG68K_ALU.vhd:818:17  */
  assign n1511 = n1462 ? n1503 : n1419;
  assign n1512 = {n1456, n1453, n1449};
  /* TG68K_ALU.vhd:801:17  */
  assign n1513 = n1421 ? n1512 : n1510;
  /* TG68K_ALU.vhd:801:17  */
  assign n1515 = n1421 ? n1460 : n1511;
  /* TG68K_ALU.vhd:801:17  */
  assign n1516 = n1421 ? n1422 : bs_c;
  /* TG68K_ALU.vhd:839:29  */
  assign n1518 = bs_shift == 6'b000000;
  /* TG68K_ALU.vhd:840:36  */
  assign n1520 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:841:46  */
  assign n1521 = n2377[4]; // extract
  /* TG68K_ALU.vhd:840:25  */
  assign n1523 = n1520 ? n1521 : 1'b0;
  /* TG68K_ALU.vhd:845:38  */
  assign n1524 = n2377[4]; // extract
  /* TG68K_ALU.vhd:839:17  */
  assign n1526 = n1518 ? 1'b0 : n1399;
  /* TG68K_ALU.vhd:839:17  */
  assign n1527 = n1518 ? n1523 : n1515;
  /* TG68K_ALU.vhd:839:17  */
  assign n1528 = n1518 ? n1524 : n1516;
  /* TG68K_ALU.vhd:854:45  */
  assign n1530 = bs_shift == 6'b111111;
  /* TG68K_ALU.vhd:856:48  */
  assign n1532 = $unsigned(bs_shift) > $unsigned(6'b110101);
  /* TG68K_ALU.vhd:857:66  */
  assign n1534 = bs_shift - 6'b110110;
  /* TG68K_ALU.vhd:858:48  */
  assign n1536 = $unsigned(bs_shift) > $unsigned(6'b101100);
  /* TG68K_ALU.vhd:859:66  */
  assign n1538 = bs_shift - 6'b101101;
  /* TG68K_ALU.vhd:860:48  */
  assign n1540 = $unsigned(bs_shift) > $unsigned(6'b100011);
  /* TG68K_ALU.vhd:861:66  */
  assign n1542 = bs_shift - 6'b100100;
  /* TG68K_ALU.vhd:862:48  */
  assign n1544 = $unsigned(bs_shift) > $unsigned(6'b011010);
  /* TG68K_ALU.vhd:863:66  */
  assign n1546 = bs_shift - 6'b011011;
  /* TG68K_ALU.vhd:864:48  */
  assign n1548 = $unsigned(bs_shift) > $unsigned(6'b010001);
  /* TG68K_ALU.vhd:865:66  */
  assign n1550 = bs_shift - 6'b010010;
  /* TG68K_ALU.vhd:866:48  */
  assign n1552 = $unsigned(bs_shift) > $unsigned(6'b001000);
  /* TG68K_ALU.vhd:867:66  */
  assign n1554 = bs_shift - 6'b001001;
  /* TG68K_ALU.vhd:866:33  */
  assign n1555 = n1552 ? n1554 : bs_shift;
  /* TG68K_ALU.vhd:864:33  */
  assign n1556 = n1548 ? n1550 : n1555;
  /* TG68K_ALU.vhd:862:33  */
  assign n1557 = n1544 ? n1546 : n1556;
  /* TG68K_ALU.vhd:860:33  */
  assign n1558 = n1540 ? n1542 : n1557;
  /* TG68K_ALU.vhd:858:33  */
  assign n1559 = n1536 ? n1538 : n1558;
  /* TG68K_ALU.vhd:856:33  */
  assign n1560 = n1532 ? n1534 : n1559;
  /* TG68K_ALU.vhd:854:33  */
  assign n1562 = n1530 ? 6'b000000 : n1560;
  /* TG68K_ALU.vhd:853:25  */
  assign n1564 = ring == 6'b001001;
  /* TG68K_ALU.vhd:872:45  */
  assign n1566 = $unsigned(bs_shift) > $unsigned(6'b110010);
  /* TG68K_ALU.vhd:873:66  */
  assign n1568 = bs_shift - 6'b110011;
  /* TG68K_ALU.vhd:874:48  */
  assign n1570 = $unsigned(bs_shift) > $unsigned(6'b100001);
  /* TG68K_ALU.vhd:875:66  */
  assign n1572 = bs_shift - 6'b100010;
  /* TG68K_ALU.vhd:876:48  */
  assign n1574 = $unsigned(bs_shift) > $unsigned(6'b010000);
  /* TG68K_ALU.vhd:877:66  */
  assign n1576 = bs_shift - 6'b010001;
  /* TG68K_ALU.vhd:876:33  */
  assign n1577 = n1574 ? n1576 : bs_shift;
  /* TG68K_ALU.vhd:874:33  */
  assign n1578 = n1570 ? n1572 : n1577;
  /* TG68K_ALU.vhd:872:33  */
  assign n1579 = n1566 ? n1568 : n1578;
  /* TG68K_ALU.vhd:871:25  */
  assign n1581 = ring == 6'b010001;
  /* TG68K_ALU.vhd:882:45  */
  assign n1583 = $unsigned(bs_shift) > $unsigned(6'b100000);
  /* TG68K_ALU.vhd:883:66  */
  assign n1585 = bs_shift - 6'b100001;
  /* TG68K_ALU.vhd:882:33  */
  assign n1586 = n1583 ? n1585 : bs_shift;
  /* TG68K_ALU.vhd:881:25  */
  assign n1588 = ring == 6'b100001;
  /* TG68K_ALU.vhd:887:74  */
  assign n1589 = bs_shift[2:0]; // extract
  /* TG68K_ALU.vhd:887:64  */
  assign n1591 = {3'b000, n1589};
  /* TG68K_ALU.vhd:887:25  */
  assign n1593 = ring == 6'b001000;
  /* TG68K_ALU.vhd:888:74  */
  assign n1594 = bs_shift[3:0]; // extract
  /* TG68K_ALU.vhd:888:64  */
  assign n1596 = {2'b00, n1594};
  /* TG68K_ALU.vhd:888:25  */
  assign n1598 = ring == 6'b010000;
  /* TG68K_ALU.vhd:889:74  */
  assign n1599 = bs_shift[4:0]; // extract
  /* TG68K_ALU.vhd:889:64  */
  assign n1601 = {1'b0, n1599};
  /* TG68K_ALU.vhd:889:25  */
  assign n1603 = ring == 6'b100000;
  assign n1604 = {n1603, n1598, n1593, n1588, n1581, n1564};
  /* TG68K_ALU.vhd:852:17  */
  always @*
    case (n1604)
      6'b100000: n1606 = n1601;
      6'b010000: n1606 = n1596;
      6'b001000: n1606 = n1591;
      6'b000100: n1606 = n1586;
      6'b000010: n1606 = n1579;
      6'b000001: n1606 = n1562;
      default: n1606 = 6'b000000;
    endcase
  /* TG68K_ALU.vhd:894:30  */
  assign n1607 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:894:33  */
  assign n1608 = ~n1607;
  /* TG68K_ALU.vhd:895:39  */
  assign n1609 = ring - bs_shift_mod;
  /* TG68K_ALU.vhd:894:17  */
  assign n1610 = n1608 ? n1609 : bs_shift_mod;
  /* TG68K_ALU.vhd:897:28  */
  assign n1611 = rot_bits[1]; // extract
  /* TG68K_ALU.vhd:897:31  */
  assign n1612 = ~n1611;
  /* TG68K_ALU.vhd:898:38  */
  assign n1613 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:898:41  */
  assign n1614 = ~n1613;
  /* TG68K_ALU.vhd:899:45  */
  assign n1616 = 6'b100000 - bs_shift_mod;
  /* TG68K_ALU.vhd:898:25  */
  assign n1617 = n1614 ? n1616 : n1610;
  /* TG68K_ALU.vhd:901:37  */
  assign n1618 = bs_shift == ring;
  /* TG68K_ALU.vhd:902:46  */
  assign n1619 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:902:49  */
  assign n1620 = ~n1619;
  /* TG68K_ALU.vhd:903:53  */
  assign n1622 = 6'b100000 - ring;
  /* TG68K_ALU.vhd:902:33  */
  assign n1623 = n1620 ? n1622 : ring;
  /* TG68K_ALU.vhd:901:25  */
  assign n1624 = n1618 ? n1623 : n1617;
  /* TG68K_ALU.vhd:908:37  */
  assign n1625 = $unsigned(bs_shift) > $unsigned(ring);
  /* TG68K_ALU.vhd:909:46  */
  assign n1626 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:909:49  */
  assign n1627 = ~n1626;
  /* TG68K_ALU.vhd:913:55  */
  assign n1629 = ring + 6'b000001;
  /* TG68K_ALU.vhd:909:33  */
  assign n1631 = n1627 ? 6'b000000 : n1629;
  /* TG68K_ALU.vhd:897:17  */
  assign n1633 = n1637 ? 1'b0 : n1527;
  /* TG68K_ALU.vhd:908:25  */
  assign n1634 = n1625 ? n1631 : n1624;
  /* TG68K_ALU.vhd:908:25  */
  assign n1635 = n1627 & n1625;
  /* TG68K_ALU.vhd:897:17  */
  assign n1636 = n1612 ? n1634 : n1610;
  /* TG68K_ALU.vhd:897:17  */
  assign n1637 = n1635 & n1612;
  /* TG68K_ALU.vhd:921:50  */
  assign n1638 = asr_sign[31:0]; // extract
  /* TG68K_ALU.vhd:921:74  */
  assign n1639 = hot_msb[31:0]; // extract
  /* TG68K_ALU.vhd:921:64  */
  assign n1640 = n1638 | n1639;
  assign n1642 = n1641[0]; // extract
  /* TG68K_ALU.vhd:922:28  */
  assign n1644 = rot_bits == 2'b00;
  /* TG68K_ALU.vhd:922:48  */
  assign n1645 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:922:51  */
  assign n1646 = ~n1645;
  /* TG68K_ALU.vhd:922:34  */
  assign n1647 = n1646 & n1644;
  /* TG68K_ALU.vhd:922:56  */
  assign n1648 = msb & n1647;
  /* TG68K_ALU.vhd:923:49  */
  assign n1649 = asr_sign[32:1]; // extract
  /* TG68K_ALU.vhd:923:38  */
  assign n1650 = alu | n1649;
  /* TG68K_ALU.vhd:924:37  */
  assign n1651 = $unsigned(bs_shift) > $unsigned(ring);
  /* TG68K_ALU.vhd:922:17  */
  assign n1653 = n1655 ? 1'b1 : n1633;
  /* TG68K_ALU.vhd:922:17  */
  assign n1654 = n1648 ? n1650 : alu;
  /* TG68K_ALU.vhd:922:17  */
  assign n1655 = n1651 & n1648;
  /* TG68K_ALU.vhd:929:43  */
  assign n1657 = {1'b0, OP1out};
  /* TG68K_ALU.vhd:930:32  */
  assign n1658 = exe_opcode[7:6]; // extract
  /* TG68K_ALU.vhd:932:46  */
  assign n1659 = OP1out[7]; // extract
  /* TG68K_ALU.vhd:935:44  */
  assign n1663 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:936:59  */
  assign n1664 = n2377[4]; // extract
  assign n1665 = n1660[0]; // extract
  /* TG68K_ALU.vhd:935:33  */
  assign n1666 = n1663 ? n1664 : n1665;
  assign n1667 = n1660[23:1]; // extract
  /* TG68K_ALU.vhd:931:25  */
  assign n1669 = n1658 == 2'b00;
  /* TG68K_ALU.vhd:939:46  */
  assign n1670 = OP1out[15]; // extract
  /* TG68K_ALU.vhd:942:44  */
  assign n1674 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:943:60  */
  assign n1675 = n2377[4]; // extract
  assign n1676 = n1671[0]; // extract
  /* TG68K_ALU.vhd:942:33  */
  assign n1677 = n1674 ? n1675 : n1676;
  assign n1678 = n1671[15:1]; // extract
  /* TG68K_ALU.vhd:938:25  */
  assign n1680 = n1658 == 2'b01;
  /* TG68K_ALU.vhd:938:34  */
  assign n1682 = n1658 == 2'b11;
  /* TG68K_ALU.vhd:938:34  */
  assign n1683 = n1680 | n1682;
  /* TG68K_ALU.vhd:946:46  */
  assign n1684 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:947:44  */
  assign n1686 = rot_bits == 2'b10;
  /* TG68K_ALU.vhd:948:60  */
  assign n1687 = n2377[4]; // extract
  assign n1688 = n1657[32]; // extract
  /* TG68K_ALU.vhd:947:33  */
  assign n1689 = n1686 ? n1687 : n1688;
  /* TG68K_ALU.vhd:945:25  */
  assign n1691 = n1658 == 2'b10;
  assign n1692 = {n1691, n1683, n1669};
  assign n1693 = n1657[8]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1694 = n1693;
      3'b010: n1694 = n1693;
      3'b001: n1694 = n1666;
      default: n1694 = n1693;
    endcase
  assign n1695 = n1667[6:0]; // extract
  assign n1696 = n1657[15:9]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1697 = n1696;
      3'b010: n1697 = n1696;
      3'b001: n1697 = n1695;
      default: n1697 = n1696;
    endcase
  assign n1698 = n1667[7]; // extract
  assign n1699 = n1657[16]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1700 = n1699;
      3'b010: n1700 = n1677;
      3'b001: n1700 = n1698;
      default: n1700 = n1699;
    endcase
  assign n1701 = n1667[22:8]; // extract
  assign n1702 = n1657[31:17]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1703 = n1702;
      3'b010: n1703 = n1678;
      3'b001: n1703 = n1701;
      default: n1703 = n1702;
    endcase
  assign n1704 = n1657[32]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1705 = n1689;
      3'b010: n1705 = n1704;
      3'b001: n1705 = n1704;
      default: n1705 = n1704;
    endcase
  assign n1707 = n1657[7:0]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1711 = n1684;
      3'b010: n1711 = n1670;
      3'b001: n1711 = n1659;
      default: n1711 = msb;
    endcase
  assign n1712 = n1661[7:0]; // extract
  assign n1713 = n1654[15:8]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1714 = n1713;
      3'b010: n1714 = n1713;
      3'b001: n1714 = n1712;
      default: n1714 = n1713;
    endcase
  assign n1715 = n1661[23:8]; // extract
  assign n1716 = n1654[31:16]; // extract
  /* TG68K_ALU.vhd:930:17  */
  always @*
    case (n1692)
      3'b100: n1717 = n1716;
      3'b010: n1717 = 16'b0000000000000000;
      3'b001: n1717 = n1715;
      default: n1717 = n1716;
    endcase
  assign n1719 = n1654[7:0]; // extract
  /* TG68K_ALU.vhd:952:71  */
  assign n1721 = {33'b000000000000000000000000000000000, vector};
  /* TG68K_ALU.vhd:952:84  */
  assign n1722 = {25'b0, bit_nr};  //  uext
  /* TG68K_ALU.vhd:952:80  */
  assign n1723 = {1'b0, n1722};  //  uext
  /* TG68K_ALU.vhd:952:80  */
  assign n1724 = n1721 << n1723;
  /* TG68K_ALU.vhd:963:24  */
  assign n1728 = exec[17]; // extract
  /* TG68K_ALU.vhd:964:58  */
  assign n1729 = last_data_read[7:0]; // extract
  /* TG68K_ALU.vhd:964:40  */
  assign n1730 = n2377 & n1729;
  /* TG68K_ALU.vhd:965:27  */
  assign n1731 = exec[18]; // extract
  /* TG68K_ALU.vhd:966:58  */
  assign n1732 = last_data_read[7:0]; // extract
  /* TG68K_ALU.vhd:966:40  */
  assign n1733 = n2377 ^ n1732;
  /* TG68K_ALU.vhd:967:27  */
  assign n1734 = exec[19]; // extract
  /* TG68K_ALU.vhd:968:57  */
  assign n1735 = last_data_read[7:0]; // extract
  /* TG68K_ALU.vhd:968:40  */
  assign n1736 = n2377 | n1735;
  /* TG68K_ALU.vhd:970:40  */
  assign n1737 = OP2out[7:0]; // extract
  /* TG68K_ALU.vhd:967:17  */
  assign n1738 = n1734 ? n1736 : n1737;
  /* TG68K_ALU.vhd:965:17  */
  assign n1739 = n1731 ? n1733 : n1738;
  /* TG68K_ALU.vhd:963:17  */
  assign n1740 = n1728 ? n1730 : n1739;
  /* TG68K_ALU.vhd:977:24  */
  assign n1741 = exec[28]; // extract
  /* TG68K_ALU.vhd:977:50  */
  assign n1742 = n2377[2]; // extract
  /* TG68K_ALU.vhd:977:53  */
  assign n1743 = ~n1742;
  /* TG68K_ALU.vhd:977:41  */
  assign n1744 = n1743 & n1741;
  /* TG68K_ALU.vhd:979:28  */
  assign n1745 = op1in[7:0]; // extract
  /* TG68K_ALU.vhd:979:40  */
  assign n1747 = n1745 == 8'b00000000;
  /* TG68K_ALU.vhd:981:33  */
  assign n1749 = op1in[15:8]; // extract
  /* TG68K_ALU.vhd:981:46  */
  assign n1751 = n1749 == 8'b00000000;
  /* TG68K_ALU.vhd:983:41  */
  assign n1753 = op1in[31:16]; // extract
  /* TG68K_ALU.vhd:983:55  */
  assign n1755 = n1753 == 16'b0000000000000000;
  /* TG68K_ALU.vhd:983:33  */
  assign n1758 = n1755 ? 1'b1 : 1'b0;
  assign n1759 = {n1758, 1'b1};
  /* TG68K_ALU.vhd:981:25  */
  assign n1761 = n1751 ? n1759 : 2'b00;
  assign n1762 = {n1761, 1'b1};
  /* TG68K_ALU.vhd:979:17  */
  assign n1764 = n1747 ? n1762 : 3'b000;
  /* TG68K_ALU.vhd:977:17  */
  assign n1766 = n1744 ? 3'b000 : n1764;
  /* TG68K_ALU.vhd:990:32  */
  assign n1769 = exe_datatype == 2'b00;
  /* TG68K_ALU.vhd:991:43  */
  assign n1770 = op1in[7]; // extract
  /* TG68K_ALU.vhd:991:53  */
  assign n1771 = flag_z[0]; // extract
  /* TG68K_ALU.vhd:991:46  */
  assign n1772 = {n1770, n1771};
  /* TG68K_ALU.vhd:991:67  */
  assign n1773 = addsub_ofl[0]; // extract
  /* TG68K_ALU.vhd:991:56  */
  assign n1774 = {n1772, n1773};
  /* TG68K_ALU.vhd:991:76  */
  assign n1775 = n271[0]; // extract
  /* TG68K_ALU.vhd:991:70  */
  assign n1776 = {n1774, n1775};
  /* TG68K_ALU.vhd:992:32  */
  assign n1777 = exec[12]; // extract
  /* TG68K_ALU.vhd:992:53  */
  assign n1778 = exec[13]; // extract
  /* TG68K_ALU.vhd:992:46  */
  assign n1779 = n1777 | n1778;
  assign n1780 = {vflag_a, bcd_a_carry};
  assign n1781 = n1776[1:0]; // extract
  /* TG68K_ALU.vhd:992:25  */
  assign n1782 = n1779 ? n1780 : n1781;
  assign n1783 = n1776[3:2]; // extract
  /* TG68K_ALU.vhd:996:35  */
  assign n1785 = exe_datatype == 2'b10;
  /* TG68K_ALU.vhd:996:48  */
  assign n1786 = exec[10]; // extract
  /* TG68K_ALU.vhd:996:41  */
  assign n1787 = n1785 | n1786;
  /* TG68K_ALU.vhd:997:43  */
  assign n1788 = op1in[31]; // extract
  /* TG68K_ALU.vhd:997:54  */
  assign n1789 = flag_z[2]; // extract
  /* TG68K_ALU.vhd:997:47  */
  assign n1790 = {n1788, n1789};
  /* TG68K_ALU.vhd:997:68  */
  assign n1791 = addsub_ofl[2]; // extract
  /* TG68K_ALU.vhd:997:57  */
  assign n1792 = {n1790, n1791};
  /* TG68K_ALU.vhd:997:77  */
  assign n1793 = n271[2]; // extract
  /* TG68K_ALU.vhd:997:71  */
  assign n1794 = {n1792, n1793};
  /* TG68K_ALU.vhd:999:43  */
  assign n1795 = op1in[15]; // extract
  /* TG68K_ALU.vhd:999:54  */
  assign n1796 = flag_z[1]; // extract
  /* TG68K_ALU.vhd:999:47  */
  assign n1797 = {n1795, n1796};
  /* TG68K_ALU.vhd:999:68  */
  assign n1798 = addsub_ofl[1]; // extract
  /* TG68K_ALU.vhd:999:57  */
  assign n1799 = {n1797, n1798};
  /* TG68K_ALU.vhd:999:77  */
  assign n1800 = n271[1]; // extract
  /* TG68K_ALU.vhd:999:71  */
  assign n1801 = {n1799, n1800};
  /* TG68K_ALU.vhd:996:17  */
  assign n1802 = n1787 ? n1794 : n1801;
  assign n1803 = {n1783, n1782};
  /* TG68K_ALU.vhd:990:17  */
  assign n1804 = n1769 ? n1803 : n1802;
  /* TG68K_ALU.vhd:1006:40  */
  assign n1806 = exec[59]; // extract
  /* TG68K_ALU.vhd:1006:55  */
  assign n1807 = n1806 | set_stop;
  /* TG68K_ALU.vhd:1007:71  */
  assign n1808 = data_read[7:0]; // extract
  /* TG68K_ALU.vhd:1006:33  */
  assign n1809 = n1807 ? n1808 : n2377;
  /* TG68K_ALU.vhd:1009:40  */
  assign n1810 = exec[60]; // extract
  /* TG68K_ALU.vhd:1010:71  */
  assign n1811 = data_read[7:0]; // extract
  /* TG68K_ALU.vhd:1009:33  */
  assign n1812 = n1810 ? n1811 : n1809;
  /* TG68K_ALU.vhd:1013:40  */
  assign n1813 = exec[9]; // extract
  /* TG68K_ALU.vhd:1013:66  */
  assign n1814 = ~decodeOPC;
  /* TG68K_ALU.vhd:1013:53  */
  assign n1815 = n1814 & n1813;
  /* TG68K_ALU.vhd:1014:65  */
  assign n1816 = set_flags[3]; // extract
  /* TG68K_ALU.vhd:1014:69  */
  assign n1817 = n1816 ^ rot_rot;
  /* TG68K_ALU.vhd:1014:82  */
  assign n1818 = n1817 | asl_vflag;
  /* TG68K_ALU.vhd:1013:33  */
  assign n1820 = n1815 ? n1818 : 1'b0;
  /* TG68K_ALU.vhd:1018:40  */
  assign n1821 = exec[51]; // extract
  /* TG68K_ALU.vhd:1021:56  */
  assign n1823 = micro_state == 7'b0110011;
  /* TG68K_ALU.vhd:1023:62  */
  assign n1824 = exe_opcode[8]; // extract
  /* TG68K_ALU.vhd:1023:65  */
  assign n1825 = ~n1824;
  /* TG68K_ALU.vhd:1025:92  */
  assign n1826 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1025:82  */
  assign n1827 = ~n1826;
  /* TG68K_ALU.vhd:1025:81  */
  assign n1829 = {1'b0, n1827};
  /* TG68K_ALU.vhd:1025:96  */
  assign n1831 = {n1829, 2'b00};
  /* TG68K_ALU.vhd:1023:49  */
  assign n1833 = n1825 ? n1831 : 4'b0100;
  assign n1834 = n1812[3:0]; // extract
  /* TG68K_ALU.vhd:1021:41  */
  assign n1835 = n1823 ? n1833 : n1834;
  /* TG68K_ALU.vhd:1030:43  */
  assign n1836 = exec[49]; // extract
  /* TG68K_ALU.vhd:1030:53  */
  assign n1837 = ~n1836;
  /* TG68K_ALU.vhd:1031:61  */
  assign n1838 = n2377[3:0]; // extract
  /* TG68K_ALU.vhd:1032:48  */
  assign n1839 = exec[3]; // extract
  /* TG68K_ALU.vhd:1033:70  */
  assign n1840 = set_flags[0]; // extract
  /* TG68K_ALU.vhd:1034:51  */
  assign n1841 = exec[9]; // extract
  /* TG68K_ALU.vhd:1034:76  */
  assign n1843 = rot_bits != 2'b11;
  /* TG68K_ALU.vhd:1034:64  */
  assign n1844 = n1843 & n1841;
  /* TG68K_ALU.vhd:1034:91  */
  assign n1845 = exec[23]; // extract
  /* TG68K_ALU.vhd:1034:100  */
  assign n1846 = ~n1845;
  /* TG68K_ALU.vhd:1034:83  */
  assign n1847 = n1846 & n1844;
  /* TG68K_ALU.vhd:1036:51  */
  assign n1848 = exec[81]; // extract
  assign n1849 = n1812[4]; // extract
  /* TG68K_ALU.vhd:1036:41  */
  assign n1850 = n1848 ? bs_x : n1849;
  /* TG68K_ALU.vhd:1034:41  */
  assign n1851 = n1847 ? rot_x : n1850;
  /* TG68K_ALU.vhd:1032:41  */
  assign n1852 = n1839 ? n1840 : n1851;
  /* TG68K_ALU.vhd:1040:49  */
  assign n1853 = exec[8]; // extract
  /* TG68K_ALU.vhd:1040:65  */
  assign n1854 = exec[86]; // extract
  /* TG68K_ALU.vhd:1040:58  */
  assign n1855 = n1853 | n1854;
  /* TG68K_ALU.vhd:1042:51  */
  assign n1856 = exec[21]; // extract
  /* TG68K_ALU.vhd:1042:65  */
  assign n1858 = 1'b1 & n1856;
  /* TG68K_ALU.vhd:1045:65  */
  assign n1860 = exe_opcode[15]; // extract
  /* TG68K_ALU.vhd:1045:74  */
  assign n1862 = n1860 | 1'b0;
  /* TG68K_ALU.vhd:1046:83  */
  assign n1863 = op1in[15]; // extract
  /* TG68K_ALU.vhd:1046:94  */
  assign n1864 = flag_z[1]; // extract
  /* TG68K_ALU.vhd:1046:87  */
  assign n1865 = {n1863, n1864};
  /* TG68K_ALU.vhd:1046:97  */
  assign n1867 = {n1865, 2'b00};
  /* TG68K_ALU.vhd:1048:83  */
  assign n1868 = op1in[31]; // extract
  /* TG68K_ALU.vhd:1048:94  */
  assign n1869 = flag_z[2]; // extract
  /* TG68K_ALU.vhd:1048:87  */
  assign n1870 = {n1868, n1869};
  /* TG68K_ALU.vhd:1048:97  */
  assign n1872 = {n1870, 2'b00};
  /* TG68K_ALU.vhd:1045:49  */
  assign n1873 = n1862 ? n1867 : n1872;
  /* TG68K_ALU.vhd:1043:49  */
  assign n1874 = v_flag ? 4'b1010 : n1873;
  /* TG68K_ALU.vhd:1050:51  */
  assign n1875 = exec[68]; // extract
  /* TG68K_ALU.vhd:1050:72  */
  assign n1877 = 1'b1 & n1875;
  /* TG68K_ALU.vhd:1051:70  */
  assign n1878 = set_flags[3]; // extract
  /* TG68K_ALU.vhd:1052:70  */
  assign n1879 = set_flags[2]; // extract
  /* TG68K_ALU.vhd:1052:83  */
  assign n1880 = n2377[2]; // extract
  /* TG68K_ALU.vhd:1052:74  */
  assign n1881 = n1879 & n1880;
  /* TG68K_ALU.vhd:1060:51  */
  assign n1885 = exec[5]; // extract
  /* TG68K_ALU.vhd:1060:70  */
  assign n1886 = exec[6]; // extract
  /* TG68K_ALU.vhd:1060:63  */
  assign n1887 = n1885 | n1886;
  /* TG68K_ALU.vhd:1060:90  */
  assign n1888 = exec[7]; // extract
  /* TG68K_ALU.vhd:1060:83  */
  assign n1889 = n1887 | n1888;
  /* TG68K_ALU.vhd:1060:110  */
  assign n1890 = exec[0]; // extract
  /* TG68K_ALU.vhd:1060:103  */
  assign n1891 = n1889 | n1890;
  /* TG68K_ALU.vhd:1060:131  */
  assign n1892 = exec[1]; // extract
  /* TG68K_ALU.vhd:1060:124  */
  assign n1893 = n1891 | n1892;
  /* TG68K_ALU.vhd:1060:153  */
  assign n1894 = exec[15]; // extract
  /* TG68K_ALU.vhd:1060:146  */
  assign n1895 = n1893 | n1894;
  /* TG68K_ALU.vhd:1060:174  */
  assign n1896 = exec[75]; // extract
  /* TG68K_ALU.vhd:1060:167  */
  assign n1897 = n1895 | n1896;
  /* TG68K_ALU.vhd:1060:194  */
  assign n1898 = exec[20]; // extract
  /* TG68K_ALU.vhd:1060:208  */
  assign n1900 = 1'b1 & n1898;
  /* TG68K_ALU.vhd:1060:186  */
  assign n1901 = n1897 | n1900;
  /* TG68K_ALU.vhd:1063:56  */
  assign n1904 = exec[75]; // extract
  assign n1905 = set_flags[3]; // extract
  /* TG68K_ALU.vhd:1063:49  */
  assign n1906 = n1904 ? bf_nflag : n1905;
  assign n1907 = set_flags[2]; // extract
  /* TG68K_ALU.vhd:1066:51  */
  assign n1908 = exec[9]; // extract
  /* TG68K_ALU.vhd:1067:79  */
  assign n1909 = set_flags[3:2]; // extract
  /* TG68K_ALU.vhd:1069:60  */
  assign n1911 = rot_bits == 2'b00;
  /* TG68K_ALU.vhd:1069:81  */
  assign n1912 = set_flags[3]; // extract
  /* TG68K_ALU.vhd:1069:85  */
  assign n1913 = n1912 ^ rot_rot;
  /* TG68K_ALU.vhd:1069:98  */
  assign n1914 = n1913 | asl_vflag;
  /* TG68K_ALU.vhd:1069:66  */
  assign n1915 = n1914 & n1911;
  /* TG68K_ALU.vhd:1069:49  */
  assign n1918 = n1915 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:1074:51  */
  assign n1919 = exec[81]; // extract
  /* TG68K_ALU.vhd:1075:79  */
  assign n1920 = set_flags[3:2]; // extract
  /* TG68K_ALU.vhd:1078:51  */
  assign n1921 = exec[14]; // extract
  /* TG68K_ALU.vhd:1079:61  */
  assign n1922 = ~one_bit_in;
  /* TG68K_ALU.vhd:1080:51  */
  assign n1923 = exec[87]; // extract
  /* TG68K_ALU.vhd:1085:63  */
  assign n1924 = last_flags1[0]; // extract
  /* TG68K_ALU.vhd:1085:66  */
  assign n1925 = ~n1924;
  /* TG68K_ALU.vhd:1086:74  */
  assign n1926 = n2377[0]; // extract
  /* TG68K_ALU.vhd:1086:95  */
  assign n1927 = set_flags[0]; // extract
  /* TG68K_ALU.vhd:1086:82  */
  assign n1928 = ~n1927;
  /* TG68K_ALU.vhd:1086:116  */
  assign n1929 = set_flags[2]; // extract
  /* TG68K_ALU.vhd:1086:103  */
  assign n1930 = ~n1929;
  /* TG68K_ALU.vhd:1086:99  */
  assign n1931 = n1928 & n1930;
  /* TG68K_ALU.vhd:1086:78  */
  assign n1932 = n1926 | n1931;
  /* TG68K_ALU.vhd:1088:75  */
  assign n1933 = n2377[0]; // extract
  /* TG68K_ALU.vhd:1088:92  */
  assign n1934 = set_flags[0]; // extract
  /* TG68K_ALU.vhd:1088:79  */
  assign n1935 = n1933 ^ n1934;
  /* TG68K_ALU.vhd:1088:111  */
  assign n1936 = n2377[2]; // extract
  /* TG68K_ALU.vhd:1088:102  */
  assign n1937 = ~n1936;
  /* TG68K_ALU.vhd:1088:97  */
  assign n1938 = n1935 & n1937;
  /* TG68K_ALU.vhd:1088:132  */
  assign n1939 = set_flags[2]; // extract
  /* TG68K_ALU.vhd:1088:119  */
  assign n1940 = ~n1939;
  /* TG68K_ALU.vhd:1088:115  */
  assign n1941 = n1938 & n1940;
  /* TG68K_ALU.vhd:1085:49  */
  assign n1942 = n1925 ? n1932 : n1941;
  /* TG68K_ALU.vhd:1091:66  */
  assign n1944 = n2377[2]; // extract
  /* TG68K_ALU.vhd:1091:82  */
  assign n1945 = set_flags[2]; // extract
  /* TG68K_ALU.vhd:1091:70  */
  assign n1946 = n1944 | n1945;
  /* TG68K_ALU.vhd:1092:76  */
  assign n1947 = last_flags1[0]; // extract
  /* TG68K_ALU.vhd:1092:61  */
  assign n1948 = ~n1947;
  /* TG68K_ALU.vhd:1093:51  */
  assign n1949 = exec[31]; // extract
  /* TG68K_ALU.vhd:1094:64  */
  assign n1951 = exe_datatype == 2'b01;
  /* TG68K_ALU.vhd:1095:75  */
  assign n1952 = OP1out[15]; // extract
  /* TG68K_ALU.vhd:1097:75  */
  assign n1953 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:1094:49  */
  assign n1954 = n1951 ? n1952 : n1953;
  /* TG68K_ALU.vhd:1099:58  */
  assign n1955 = OP1out[15:0]; // extract
  /* TG68K_ALU.vhd:1099:71  */
  assign n1957 = n1955 == 16'b0000000000000000;
  /* TG68K_ALU.vhd:1099:97  */
  assign n1959 = exe_datatype == 2'b01;
  /* TG68K_ALU.vhd:1099:112  */
  assign n1960 = OP1out[31:16]; // extract
  /* TG68K_ALU.vhd:1099:126  */
  assign n1962 = n1960 == 16'b0000000000000000;
  /* TG68K_ALU.vhd:1099:103  */
  assign n1963 = n1959 | n1962;
  /* TG68K_ALU.vhd:1099:80  */
  assign n1964 = n1963 & n1957;
  /* TG68K_ALU.vhd:1099:49  */
  assign n1967 = n1964 ? 1'b1 : 1'b0;
  assign n1970 = {n1954, n1967, 1'b0, 1'b0};
  assign n1971 = n1812[3:0]; // extract
  /* TG68K_ALU.vhd:1093:41  */
  assign n1972 = n1949 ? n1970 : n1971;
  assign n1973 = {n1948, n1946, 1'b0, n1942};
  /* TG68K_ALU.vhd:1080:41  */
  assign n1974 = n1923 ? n1973 : n1972;
  assign n1975 = n1974[1:0]; // extract
  assign n1976 = n1812[1:0]; // extract
  /* TG68K_ALU.vhd:1078:41  */
  assign n1977 = n1921 ? n1976 : n1975;
  assign n1978 = n1974[2]; // extract
  /* TG68K_ALU.vhd:1078:41  */
  assign n1979 = n1921 ? n1922 : n1978;
  assign n1980 = n1974[3]; // extract
  assign n1981 = n1812[3]; // extract
  /* TG68K_ALU.vhd:1078:41  */
  assign n1982 = n1921 ? n1981 : n1980;
  assign n1983 = {n1982, n1979, n1977};
  assign n1984 = {n1920, bs_v, bs_c};
  /* TG68K_ALU.vhd:1074:41  */
  assign n1985 = n1919 ? n1984 : n1983;
  assign n1986 = {n1909, n1918, rot_c};
  /* TG68K_ALU.vhd:1066:41  */
  assign n1987 = n1908 ? n1986 : n1985;
  assign n1988 = {n1906, n1907, 2'b00};
  /* TG68K_ALU.vhd:1060:41  */
  assign n1989 = n1901 ? n1988 : n1987;
  assign n1990 = {n1878, n1881, 1'b0, 1'b0};
  /* TG68K_ALU.vhd:1050:41  */
  assign n1991 = n1877 ? n1990 : n1989;
  /* TG68K_ALU.vhd:1042:41  */
  assign n1992 = n1858 ? n1874 : n1991;
  /* TG68K_ALU.vhd:1040:41  */
  assign n1993 = n1855 ? set_flags : n1992;
  assign n1994 = {n1852, n1993};
  assign n1995 = n1812[4:0]; // extract
  /* TG68K_ALU.vhd:1030:33  */
  assign n1996 = n1837 ? n1994 : n1995;
  /* TG68K_ALU.vhd:1030:33  */
  assign n1997 = n1837 ? n1838 : last_flags1;
  assign n1998 = n1996[3:0]; // extract
  /* TG68K_ALU.vhd:1020:33  */
  assign n1999 = Z_error ? n1835 : n1998;
  assign n2000 = n1996[4]; // extract
  assign n2001 = n1812[4]; // extract
  /* TG68K_ALU.vhd:1020:33  */
  assign n2002 = Z_error ? n2001 : n2000;
  /* TG68K_ALU.vhd:1020:33  */
  assign n2003 = Z_error ? last_flags1 : n1997;
  assign n2004 = {n2002, n1999};
  assign n2005 = ccrin[4:0]; // extract
  /* TG68K_ALU.vhd:1018:33  */
  assign n2006 = n1821 ? n2005 : n2004;
  assign n2007 = ccrin[7:5]; // extract
  assign n2008 = n1812[7:5]; // extract
  /* TG68K_ALU.vhd:1018:33  */
  assign n2009 = n1821 ? n2007 : n2008;
  /* TG68K_ALU.vhd:1018:33  */
  assign n2011 = n1821 ? last_flags1 : n2003;
  assign n2012 = {n2009, n2006};
  /* TG68K_ALU.vhd:1005:25  */
  assign n2013 = clkena_lw ? n2012 : n2377;
  /* TG68K_ALU.vhd:1005:25  */
  assign n2014 = clkena_lw ? n2011 : last_flags1;
  /* TG68K_ALU.vhd:1005:25  */
  assign n2015 = clkena_lw ? n1820 : asl_vflag;
  /* TG68K_ALU.vhd:1003:25  */
  assign n2017 = Reset ? 8'b00000000 : n2013;
  /* TG68K_ALU.vhd:1003:25  */
  assign n2018 = Reset ? last_flags1 : n2014;
  /* TG68K_ALU.vhd:1003:25  */
  assign n2019 = Reset ? asl_vflag : n2015;
  assign n2021 = n2017[4:0]; // extract
  assign n2022 = {3'b000, n2021};
  /* TG68K_ALU.vhd:1168:45  */
  assign n2029 = faktorb[31]; // extract
  /* TG68K_ALU.vhd:1168:34  */
  assign n2030 = n2029 & signedop;
  /* TG68K_ALU.vhd:1168:55  */
  assign n2031 = n2030 | fasign;
  /* TG68K_ALU.vhd:1169:45  */
  assign n2032 = mulu_reg[63]; // extract
  /* TG68K_ALU.vhd:1168:17  */
  assign n2034 = n2031 ? n2032 : 1'b0;
  /* TG68K_ALU.vhd:1174:44  */
  assign n2035 = faktorb[31]; // extract
  /* TG68K_ALU.vhd:1174:33  */
  assign n2036 = n2035 & signedop;
  /* TG68K_ALU.vhd:1174:17  */
  assign n2039 = n2036 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:1191:70  */
  assign n2040 = mulu_reg[63:1]; // extract
  /* TG68K_ALU.vhd:1191:61  */
  assign n2041 = {muls_msb, n2040};
  /* TG68K_ALU.vhd:1192:36  */
  assign n2042 = mulu_reg[0]; // extract
  /* TG68K_ALU.vhd:1194:88  */
  assign n2043 = mulu_reg[63:32]; // extract
  /* TG68K_ALU.vhd:1194:79  */
  assign n2044 = {muls_msb, n2043};
  /* TG68K_ALU.vhd:1194:113  */
  assign n2045 = {mulu_sign, faktorb};
  /* TG68K_ALU.vhd:1194:102  */
  assign n2046 = n2044 - n2045;
  /* TG68K_ALU.vhd:1196:88  */
  assign n2047 = mulu_reg[63:32]; // extract
  /* TG68K_ALU.vhd:1196:79  */
  assign n2048 = {muls_msb, n2047};
  /* TG68K_ALU.vhd:1196:113  */
  assign n2049 = {mulu_sign, faktorb};
  /* TG68K_ALU.vhd:1196:102  */
  assign n2050 = n2048 + n2049;
  /* TG68K_ALU.vhd:1193:33  */
  assign n2051 = fasign ? n2046 : n2050;
  assign n2052 = n2041[63:31]; // extract
  /* TG68K_ALU.vhd:1192:25  */
  assign n2053 = n2042 ? n2051 : n2052;
  assign n2054 = n2041[30:0]; // extract
  /* TG68K_ALU.vhd:1200:30  */
  assign n2055 = exe_opcode[15]; // extract
  /* TG68K_ALU.vhd:1200:39  */
  assign n2057 = n2055 | 1'b0;
  /* TG68K_ALU.vhd:1201:56  */
  assign n2058 = OP2out[15:0]; // extract
  assign n2060 = {n2058, 16'b0000000000000000};
  /* TG68K_ALU.vhd:1200:17  */
  assign n2061 = n2057 ? n2060 : OP2out;
  /* TG68K_ALU.vhd:1233:77  */
  assign n2084 = result_mulu[63:32]; // extract
  /* TG68K_ALU.vhd:1246:32  */
  assign n2092 = opcode[15]; // extract
  /* TG68K_ALU.vhd:1246:47  */
  assign n2093 = opcode[8]; // extract
  /* TG68K_ALU.vhd:1246:37  */
  assign n2094 = n2092 & n2093;
  /* TG68K_ALU.vhd:1246:66  */
  assign n2095 = opcode[15]; // extract
  /* TG68K_ALU.vhd:1246:56  */
  assign n2096 = ~n2095;
  /* TG68K_ALU.vhd:1246:81  */
  assign n2097 = sndOPC[11]; // extract
  /* TG68K_ALU.vhd:1246:71  */
  assign n2098 = n2096 & n2097;
  /* TG68K_ALU.vhd:1246:52  */
  assign n2099 = n2094 | n2098;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2101 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2102 = divs & n2101;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2103 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2104 = divs & n2103;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2105 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2106 = divs & n2105;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2107 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2108 = divs & n2107;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2109 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2110 = divs & n2109;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2111 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2112 = divs & n2111;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2113 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2114 = divs & n2113;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2115 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2116 = divs & n2115;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2117 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2118 = divs & n2117;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2119 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2120 = divs & n2119;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2121 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2122 = divs & n2121;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2123 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2124 = divs & n2123;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2125 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2126 = divs & n2125;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2127 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2128 = divs & n2127;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2129 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2130 = divs & n2129;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2131 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2132 = divs & n2131;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2133 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2134 = divs & n2133;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2135 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2136 = divs & n2135;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2137 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2138 = divs & n2137;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2139 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2140 = divs & n2139;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2141 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2142 = divs & n2141;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2143 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2144 = divs & n2143;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2145 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2146 = divs & n2145;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2147 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2148 = divs & n2147;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2149 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2150 = divs & n2149;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2151 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2152 = divs & n2151;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2153 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2154 = divs & n2153;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2155 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2156 = divs & n2155;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2157 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2158 = divs & n2157;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2159 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2160 = divs & n2159;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2161 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2162 = divs & n2161;
  /* TG68K_ALU.vhd:1248:68  */
  assign n2163 = reg_QA[31]; // extract
  /* TG68K_ALU.vhd:1248:58  */
  assign n2164 = divs & n2163;
  assign n2165 = {n2102, n2104, n2106, n2108};
  assign n2166 = {n2110, n2112, n2114, n2116};
  assign n2167 = {n2118, n2120, n2122, n2124};
  assign n2168 = {n2126, n2128, n2130, n2132};
  assign n2169 = {n2134, n2136, n2138, n2140};
  assign n2170 = {n2142, n2144, n2146, n2148};
  assign n2171 = {n2150, n2152, n2154, n2156};
  assign n2172 = {n2158, n2160, n2162, n2164};
  assign n2173 = {n2165, n2166, n2167, n2168};
  assign n2174 = {n2169, n2170, n2171, n2172};
  assign n2175 = {n2173, n2174};
  /* TG68K_ALU.vhd:1249:30  */
  assign n2176 = exe_opcode[15]; // extract
  /* TG68K_ALU.vhd:1249:39  */
  assign n2178 = n2176 | 1'b0;
  /* TG68K_ALU.vhd:1251:52  */
  assign n2179 = result_div_pre[15]; // extract
  /* TG68K_ALU.vhd:1254:38  */
  assign n2180 = exe_opcode[14]; // extract
  /* TG68K_ALU.vhd:1254:57  */
  assign n2181 = sndOPC[10]; // extract
  /* TG68K_ALU.vhd:1254:47  */
  assign n2182 = n2181 & n2180;
  /* TG68K_ALU.vhd:1254:25  */
  assign n2183 = n2182 ? reg_QB : n2175;
  /* TG68K_ALU.vhd:1257:52  */
  assign n2184 = result_div_pre[31]; // extract
  /* TG68K_ALU.vhd:1249:17  */
  assign n2185 = n2178 ? n2179 : n2184;
  assign n2186 = {n2183, reg_QA};
  assign n2187 = n2186[15:0]; // extract
  /* TG68K_ALU.vhd:1249:17  */
  assign n2188 = n2178 ? 16'b0000000000000000 : n2187;
  assign n2189 = n2186[47:16]; // extract
  /* TG68K_ALU.vhd:1249:17  */
  assign n2190 = n2178 ? reg_QA : n2189;
  assign n2191 = n2186[63:48]; // extract
  assign n2192 = n2175[31:16]; // extract
  /* TG68K_ALU.vhd:1249:17  */
  assign n2193 = n2178 ? n2192 : n2191;
  /* TG68K_ALU.vhd:1259:42  */
  assign n2195 = opcode[15]; // extract
  /* TG68K_ALU.vhd:1259:46  */
  assign n2196 = ~n2195;
  /* TG68K_ALU.vhd:1259:33  */
  assign n2197 = signedop | n2196;
  /* TG68K_ALU.vhd:1260:44  */
  assign n2198 = OP2out[31:16]; // extract
  /* TG68K_ALU.vhd:1259:17  */
  assign n2200 = n2197 ? n2198 : 16'b0000000000000000;
  /* TG68K_ALU.vhd:1264:43  */
  assign n2201 = OP2out[31]; // extract
  /* TG68K_ALU.vhd:1264:33  */
  assign n2202 = n2201 & signedop;
  /* TG68K_ALU.vhd:1265:44  */
  assign n2203 = div_reg[63:31]; // extract
  /* TG68K_ALU.vhd:1265:64  */
  assign n2205 = {1'b1, OP2out};
  /* TG68K_ALU.vhd:1265:59  */
  assign n2206 = n2203 + n2205;
  /* TG68K_ALU.vhd:1267:44  */
  assign n2207 = div_reg[63:31]; // extract
  /* TG68K_ALU.vhd:1267:64  */
  assign n2209 = {1'b0, op2outext};
  /* TG68K_ALU.vhd:1267:94  */
  assign n2210 = OP2out[15:0]; // extract
  /* TG68K_ALU.vhd:1267:87  */
  assign n2211 = {n2209, n2210};
  /* TG68K_ALU.vhd:1267:59  */
  assign n2212 = n2207 - n2211;
  /* TG68K_ALU.vhd:1264:17  */
  assign n2213 = n2202 ? n2206 : n2212;
  /* TG68K_ALU.vhd:1272:43  */
  assign n2214 = div_sub[32]; // extract
  /* TG68K_ALU.vhd:1275:58  */
  assign n2215 = div_reg[62:31]; // extract
  /* TG68K_ALU.vhd:1277:58  */
  assign n2216 = div_sub[31:0]; // extract
  /* TG68K_ALU.vhd:1274:17  */
  assign n2217 = div_bit ? n2215 : n2216;
  /* TG68K_ALU.vhd:1279:49  */
  assign n2218 = div_reg[30:0]; // extract
  /* TG68K_ALU.vhd:1279:63  */
  assign n2219 = ~div_bit;
  /* TG68K_ALU.vhd:1279:62  */
  assign n2220 = {n2218, n2219};
  /* TG68K_ALU.vhd:1282:66  */
  assign n2221 = div_quot[31:0]; // extract
  /* TG68K_ALU.vhd:1282:57  */
  assign n2223 = 32'b00000000000000000000000000000000 - n2221;
  /* TG68K_ALU.vhd:1285:64  */
  assign n2224 = div_quot[31:0]; // extract
  /* TG68K_ALU.vhd:1281:17  */
  assign n2225 = div_neg ? n2223 : n2224;
  /* TG68K_ALU.vhd:1288:44  */
  assign n2226 = ~div_bit;
  /* TG68K_ALU.vhd:1288:34  */
  assign n2227 = nozero | n2226;
  /* TG68K_ALU.vhd:1288:50  */
  assign n2228 = signedop & n2227;
  /* TG68K_ALU.vhd:1288:78  */
  assign n2229 = OP2out[31]; // extract
  /* TG68K_ALU.vhd:1288:83  */
  assign n2230 = n2229 ^ op1_sign;
  /* TG68K_ALU.vhd:1288:96  */
  assign n2231 = n2230 ^ div_qsign;
  /* TG68K_ALU.vhd:1288:67  */
  assign n2232 = n2231 & n2228;
  /* TG68K_ALU.vhd:1289:37  */
  assign n2233 = ~signedop;
  /* TG68K_ALU.vhd:1289:54  */
  assign n2234 = div_over[32]; // extract
  /* TG68K_ALU.vhd:1289:58  */
  assign n2235 = ~n2234;
  /* TG68K_ALU.vhd:1289:42  */
  assign n2236 = n2235 & n2233;
  /* TG68K_ALU.vhd:1289:25  */
  assign n2237 = n2232 | n2236;
  /* TG68K_ALU.vhd:1289:65  */
  assign n2239 = 1'b1 & n2237;
  /* TG68K_ALU.vhd:1288:17  */
  assign n2242 = n2239 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:1300:47  */
  assign n2248 = micro_state != 7'b1101001;
  /* TG68K_ALU.vhd:1304:47  */
  assign n2251 = micro_state == 7'b1100100;
  /* TG68K_ALU.vhd:1306:65  */
  assign n2252 = dividend[63]; // extract
  /* TG68K_ALU.vhd:1306:53  */
  assign n2253 = n2252 & divs;
  /* TG68K_ALU.vhd:1308:61  */
  assign n2255 = 64'b0000000000000000000000000000000000000000000000000000000000000000 - dividend;
  /* TG68K_ALU.vhd:1306:41  */
  assign n2256 = n2253 ? n2255 : dividend;
  /* TG68K_ALU.vhd:1306:41  */
  assign n2259 = n2253 ? 1'b1 : 1'b0;
  /* TG68K_ALU.vhd:1315:51  */
  assign n2260 = ~div_bit;
  /* TG68K_ALU.vhd:1315:63  */
  assign n2261 = n2260 | nozero;
  /* TG68K_ALU.vhd:1304:33  */
  assign n2262 = n2251 ? n2256 : div_quot;
  /* TG68K_ALU.vhd:1304:33  */
  assign n2264 = n2251 ? 1'b0 : n2261;
  /* TG68K_ALU.vhd:1317:47  */
  assign n2267 = micro_state == 7'b1100101;
  /* TG68K_ALU.vhd:1318:72  */
  assign n2268 = OP2out[31]; // extract
  /* TG68K_ALU.vhd:1318:77  */
  assign n2269 = n2268 ^ op1_sign;
  /* TG68K_ALU.vhd:1318:61  */
  assign n2270 = signedop & n2269;
  /* TG68K_ALU.vhd:1322:73  */
  assign n2271 = div_reg[63:32]; // extract
  /* TG68K_ALU.vhd:1322:65  */
  assign n2273 = {1'b0, n2271};
  /* TG68K_ALU.vhd:1322:93  */
  assign n2275 = {1'b0, op2outext};
  /* TG68K_ALU.vhd:1322:123  */
  assign n2276 = OP2out[15:0]; // extract
  /* TG68K_ALU.vhd:1322:116  */
  assign n2277 = {n2275, n2276};
  /* TG68K_ALU.vhd:1322:88  */
  assign n2278 = n2273 - n2277;
  /* TG68K_ALU.vhd:1325:40  */
  assign n2281 = exec[68]; // extract
  /* TG68K_ALU.vhd:1325:56  */
  assign n2282 = ~n2281;
  /* TG68K_ALU.vhd:1328:87  */
  assign n2283 = div_quot[63:32]; // extract
  /* TG68K_ALU.vhd:1328:78  */
  assign n2285 = 32'b00000000000000000000000000000000 - n2283;
  /* TG68K_ALU.vhd:1330:85  */
  assign n2286 = div_quot[63:32]; // extract
  /* TG68K_ALU.vhd:1327:41  */
  assign n2287 = op1_sign ? n2285 : n2286;
  assign n2288 = {n2287, result_div_pre};
  /* TG68K_ALU.vhd:1299:25  */
  assign n2290 = n2282 & clkena_lw;
  /* TG68K_ALU.vhd:1299:25  */
  assign n2291 = n2248 & clkena_lw;
  /* TG68K_ALU.vhd:1299:25  */
  assign n2293 = n2267 & clkena_lw;
  /* TG68K_ALU.vhd:1299:25  */
  assign n2294 = n2267 & clkena_lw;
  /* TG68K_ALU.vhd:1299:25  */
  assign n2297 = n2251 & clkena_lw;
  assign n2307 = {n106, n103};
  assign n2308 = {n270, n263, n256};
  assign n2309 = {n248, n247, n242, n200};
  /* TG68K_ALU.vhd:1002:17  */
  always @(posedge clk)
    n2310 <= n2018;
  /* TG68K_ALU.vhd:1002:17  */
  assign n2311 = {n292, n330};
  assign n2313 = {64'bZ, n2053, n2054};
  /* TG68K_ALU.vhd:1298:17  */
  assign n2314 = n2290 ? n2288 : result_div;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2315 <= n2314;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2316 = n2291 ? n2242 : v_flag;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2317 <= n2316;
  /* TG68K_ALU.vhd:1002:17  */
  always @(posedge clk)
    n2318 <= n2019;
  /* TG68K_ALU.vhd:411:17  */
  assign n2320 = clkena_lw ? n351 : bchg;
  /* TG68K_ALU.vhd:411:17  */
  always @(posedge clk)
    n2321 <= n2320;
  /* TG68K_ALU.vhd:411:17  */
  assign n2322 = clkena_lw ? n355 : bset;
  /* TG68K_ALU.vhd:411:17  */
  always @(posedge clk)
    n2323 <= n2322;
  assign n2325 = mulu_reg[31:0]; // extract
  /* TG68K_ALU.vhd:1217:17  */
  assign n2326 = clkena_lw ? n2084 : n2325;
  /* TG68K_ALU.vhd:1217:17  */
  always @(posedge clk)
    n2327 <= n2326;
  assign n2329 = {32'bZ, n2327};
  /* TG68K_ALU.vhd:1298:17  */
  assign n2332 = clkena_lw ? n2262 : div_reg;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2333 <= n2332;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2334 = {n2217, n2220};
  /* TG68K_ALU.vhd:1298:17  */
  assign n2336 = n2293 ? n2270 : div_neg;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2337 <= n2336;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2338 = n2294 ? n2278 : div_over;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2339 <= n2338;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2340 = clkena_lw ? n2264 : nozero;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2341 <= n2340;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2342 = {n2193, n2190, n2188};
  /* TG68K_ALU.vhd:1298:17  */
  assign n2343 = clkena_lw ? divs : signedop;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2344 <= n2343;
  /* TG68K_ALU.vhd:1298:17  */
  assign n2345 = n2297 ? n2259 : op1_sign;
  /* TG68K_ALU.vhd:1298:17  */
  always @(posedge clk)
    n2346 <= n2345;
  assign n2349 = {n806, n796, n785, n774, n763, n752, n741, n730, n719, n708, n697, n686, n675, n664, n653, n642, n631, n620, n609, n598, n587, n576, n565, n554, n543, n532, n521, n510, n499, n488, n477, n465};
  assign n2351 = {n1101, n1097, n1092, n1087, n1082, n1077, n1072, n1067, n1062, n1057, n1052, n1047, n1042, n1037, n1032, n1027, n1022, n1017, n1012, n1007, n1002, n997, n992, n987, n982, n977, n972, n967, n962, n957, n952, n947, n942, n937, n932, n927, n922, n917, n912, n907};
  assign n2352 = {n807, n799, n788, n777, n766, n755, n744, n733, n722, n711, n700, n689, n678, n667, n656, n645, n634, n623, n612, n601, n590, n579, n568, n557, n546, n535, n524, n513, n502, n491, n480, n468};
  assign n2354 = {n863, n864};
  assign n2355 = {n1185, n1214, n1211};
  /* TG68K_ALU.vhd:452:17  */
  assign n2356 = clkena_lw ? n414 : bf_bset;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2357 <= n2356;
  /* TG68K_ALU.vhd:452:17  */
  assign n2358 = clkena_lw ? n418 : bf_bchg;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2359 <= n2358;
  /* TG68K_ALU.vhd:452:17  */
  assign n2360 = clkena_lw ? n422 : bf_ins;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2361 <= n2360;
  /* TG68K_ALU.vhd:452:17  */
  assign n2362 = clkena_lw ? n426 : bf_exts;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2363 <= n2362;
  /* TG68K_ALU.vhd:452:17  */
  assign n2364 = clkena_lw ? n430 : bf_fffo;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2365 <= n2364;
  /* TG68K_ALU.vhd:452:17  */
  assign n2366 = clkena_lw ? n439 : bf_d32;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2367 <= n2366;
  /* TG68K_ALU.vhd:452:17  */
  assign n2368 = clkena_lw ? n433 : bf_s32;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2369 <= n2368;
  assign n2371 = {n1705, n1703, n1700, n1697, n1694, n1707};
  assign n2372 = {n1386, n1383, n1387, n1381, n1385};
  assign n2373 = {n1640, n1642};
  assign n2374 = {n1717, n1714, n1719};
  /* TG68K_ALU.vhd:452:17  */
  assign n2375 = clkena_lw ? n441 : n2376;
  /* TG68K_ALU.vhd:452:17  */
  always @(posedge clk)
    n2376 <= n2375;
  /* TG68K_ALU.vhd:1002:17  */
  always @(posedge clk)
    n2377 <= n2022;
  /* TG68K_ALU.vhd:439:38  */
  assign n2378 = OP1out[bit_number * 1 +: 1]; //(Bmux)
  /* TG68K_ALU.vhd:441:17  */
  assign n2379 = bit_number[4]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2380 = ~n2379;
  /* TG68K_ALU.vhd:441:17  */
  assign n2381 = bit_number[3]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2382 = ~n2381;
  /* TG68K_ALU.vhd:441:17  */
  assign n2383 = n2380 & n2382;
  /* TG68K_ALU.vhd:441:17  */
  assign n2384 = n2380 & n2381;
  /* TG68K_ALU.vhd:441:17  */
  assign n2385 = n2379 & n2382;
  /* TG68K_ALU.vhd:441:17  */
  assign n2386 = n2379 & n2381;
  /* TG68K_ALU.vhd:441:17  */
  assign n2387 = bit_number[2]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2388 = ~n2387;
  /* TG68K_ALU.vhd:441:17  */
  assign n2389 = n2383 & n2388;
  /* TG68K_ALU.vhd:441:17  */
  assign n2390 = n2383 & n2387;
  /* TG68K_ALU.vhd:441:17  */
  assign n2391 = n2384 & n2388;
  /* TG68K_ALU.vhd:441:17  */
  assign n2392 = n2384 & n2387;
  /* TG68K_ALU.vhd:441:17  */
  assign n2393 = n2385 & n2388;
  /* TG68K_ALU.vhd:441:17  */
  assign n2394 = n2385 & n2387;
  /* TG68K_ALU.vhd:441:17  */
  assign n2395 = n2386 & n2388;
  /* TG68K_ALU.vhd:441:17  */
  assign n2396 = n2386 & n2387;
  /* TG68K_ALU.vhd:441:17  */
  assign n2397 = bit_number[1]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2398 = ~n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2399 = n2389 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2400 = n2389 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2401 = n2390 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2402 = n2390 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2403 = n2391 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2404 = n2391 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2405 = n2392 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2406 = n2392 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2407 = n2393 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2408 = n2393 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2409 = n2394 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2410 = n2394 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2411 = n2395 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2412 = n2395 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2413 = n2396 & n2398;
  /* TG68K_ALU.vhd:441:17  */
  assign n2414 = n2396 & n2397;
  /* TG68K_ALU.vhd:441:17  */
  assign n2415 = bit_number[0]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2416 = ~n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2417 = n2399 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2418 = n2399 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2419 = n2400 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2420 = n2400 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2421 = n2401 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2422 = n2401 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2423 = n2402 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2424 = n2402 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2425 = n2403 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2426 = n2403 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2427 = n2404 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2428 = n2404 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2429 = n2405 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2430 = n2405 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2431 = n2406 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2432 = n2406 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2433 = n2407 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2434 = n2407 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2435 = n2408 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2436 = n2408 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2437 = n2409 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2438 = n2409 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2439 = n2410 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2440 = n2410 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2441 = n2411 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2442 = n2411 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2443 = n2412 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2444 = n2412 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2445 = n2413 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2446 = n2413 & n2415;
  /* TG68K_ALU.vhd:441:17  */
  assign n2447 = n2414 & n2416;
  /* TG68K_ALU.vhd:441:17  */
  assign n2448 = n2414 & n2415;
  assign n2449 = OP1out[0]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2450 = n2417 ? n387 : n2449;
  assign n2451 = OP1out[1]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2452 = n2418 ? n387 : n2451;
  assign n2453 = OP1out[2]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2454 = n2419 ? n387 : n2453;
  assign n2455 = OP1out[3]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2456 = n2420 ? n387 : n2455;
  assign n2457 = OP1out[4]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2458 = n2421 ? n387 : n2457;
  assign n2459 = OP1out[5]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2460 = n2422 ? n387 : n2459;
  assign n2461 = OP1out[6]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2462 = n2423 ? n387 : n2461;
  assign n2463 = OP1out[7]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2464 = n2424 ? n387 : n2463;
  /* TG68K_ALU.vhd:711:50  */
  assign n2465 = OP1out[8]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2466 = n2425 ? n387 : n2465;
  assign n2467 = OP1out[9]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2468 = n2426 ? n387 : n2467;
  assign n2469 = OP1out[10]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2470 = n2427 ? n387 : n2469;
  assign n2471 = OP1out[11]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2472 = n2428 ? n387 : n2471;
  /* TG68K_ALU.vhd:707:51  */
  assign n2473 = OP1out[12]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2474 = n2429 ? n387 : n2473;
  /* TG68K_ALU.vhd:701:63  */
  assign n2475 = OP1out[13]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2476 = n2430 ? n387 : n2475;
  /* TG68K_ALU.vhd:675:17  */
  assign n2477 = OP1out[14]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2478 = n2431 ? n387 : n2477;
  /* TG68K_ALU.vhd:675:17  */
  assign n2479 = OP1out[15]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2480 = n2432 ? n387 : n2479;
  assign n2481 = OP1out[16]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2482 = n2433 ? n387 : n2481;
  /* TG68K_ALU.vhd:685:25  */
  assign n2483 = OP1out[17]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2484 = n2434 ? n387 : n2483;
  /* TG68K_ALU.vhd:687:66  */
  assign n2485 = OP1out[18]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2486 = n2435 ? n387 : n2485;
  assign n2487 = OP1out[19]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2488 = n2436 ? n387 : n2487;
  /* TG68K_ALU.vhd:683:65  */
  assign n2489 = OP1out[20]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2490 = n2437 ? n387 : n2489;
  assign n2491 = OP1out[21]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2492 = n2438 ? n387 : n2491;
  assign n2493 = OP1out[22]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2494 = n2439 ? n387 : n2493;
  assign n2495 = OP1out[23]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2496 = n2440 ? n387 : n2495;
  assign n2497 = OP1out[24]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2498 = n2441 ? n387 : n2497;
  assign n2499 = OP1out[25]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2500 = n2442 ? n387 : n2499;
  assign n2501 = OP1out[26]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2502 = n2443 ? n387 : n2501;
  assign n2503 = OP1out[27]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2504 = n2444 ? n387 : n2503;
  assign n2505 = OP1out[28]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2506 = n2445 ? n387 : n2505;
  assign n2507 = OP1out[29]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2508 = n2446 ? n387 : n2507;
  assign n2509 = OP1out[30]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2510 = n2447 ? n387 : n2509;
  assign n2511 = OP1out[31]; // extract
  /* TG68K_ALU.vhd:441:17  */
  assign n2512 = n2448 ? n387 : n2511;
  assign n2513 = {n2512, n2510, n2508, n2506, n2504, n2502, n2500, n2498, n2496, n2494, n2492, n2490, n2488, n2486, n2484, n2482, n2480, n2478, n2476, n2474, n2472, n2470, n2468, n2466, n2464, n2462, n2460, n2458, n2456, n2454, n2452, n2450};
  /* TG68K_ALU.vhd:502:37  */
  assign n2514 = datareg[n809 * 1 +: 1]; //(Bmux)
  /* TG68K_ALU.vhd:767:17  */
  assign n2515 = bit_msb[5]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2516 = ~n2515;
  /* TG68K_ALU.vhd:767:17  */
  assign n2517 = bit_msb[4]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2518 = ~n2517;
  /* TG68K_ALU.vhd:767:17  */
  assign n2519 = n2516 & n2518;
  /* TG68K_ALU.vhd:767:17  */
  assign n2520 = n2516 & n2517;
  /* TG68K_ALU.vhd:767:17  */
  assign n2521 = n2515 & n2518;
  /* TG68K_ALU.vhd:767:17  */
  assign n2522 = bit_msb[3]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2523 = ~n2522;
  /* TG68K_ALU.vhd:767:17  */
  assign n2524 = n2519 & n2523;
  /* TG68K_ALU.vhd:767:17  */
  assign n2525 = n2519 & n2522;
  /* TG68K_ALU.vhd:767:17  */
  assign n2526 = n2520 & n2523;
  /* TG68K_ALU.vhd:767:17  */
  assign n2527 = n2520 & n2522;
  /* TG68K_ALU.vhd:767:17  */
  assign n2528 = n2521 & n2523;
  /* TG68K_ALU.vhd:767:17  */
  assign n2529 = bit_msb[2]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2530 = ~n2529;
  /* TG68K_ALU.vhd:767:17  */
  assign n2531 = n2524 & n2530;
  /* TG68K_ALU.vhd:767:17  */
  assign n2532 = n2524 & n2529;
  /* TG68K_ALU.vhd:767:17  */
  assign n2533 = n2525 & n2530;
  /* TG68K_ALU.vhd:767:17  */
  assign n2534 = n2525 & n2529;
  /* TG68K_ALU.vhd:767:17  */
  assign n2535 = n2526 & n2530;
  /* TG68K_ALU.vhd:767:17  */
  assign n2536 = n2526 & n2529;
  /* TG68K_ALU.vhd:767:17  */
  assign n2537 = n2527 & n2530;
  /* TG68K_ALU.vhd:767:17  */
  assign n2538 = n2527 & n2529;
  /* TG68K_ALU.vhd:767:17  */
  assign n2539 = n2528 & n2530;
  /* TG68K_ALU.vhd:767:17  */
  assign n2540 = bit_msb[1]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2541 = ~n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2542 = n2531 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2543 = n2531 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2544 = n2532 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2545 = n2532 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2546 = n2533 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2547 = n2533 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2548 = n2534 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2549 = n2534 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2550 = n2535 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2551 = n2535 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2552 = n2536 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2553 = n2536 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2554 = n2537 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2555 = n2537 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2556 = n2538 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2557 = n2538 & n2540;
  /* TG68K_ALU.vhd:767:17  */
  assign n2558 = n2539 & n2541;
  /* TG68K_ALU.vhd:767:17  */
  assign n2559 = bit_msb[0]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2560 = ~n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2561 = n2542 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2562 = n2542 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2563 = n2543 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2564 = n2543 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2565 = n2544 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2566 = n2544 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2567 = n2545 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2568 = n2545 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2569 = n2546 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2570 = n2546 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2571 = n2547 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2572 = n2547 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2573 = n2548 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2574 = n2548 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2575 = n2549 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2576 = n2549 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2577 = n2550 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2578 = n2550 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2579 = n2551 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2580 = n2551 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2581 = n2552 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2582 = n2552 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2583 = n2553 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2584 = n2553 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2585 = n2554 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2586 = n2554 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2587 = n2555 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2588 = n2555 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2589 = n2556 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2590 = n2556 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2591 = n2557 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2592 = n2557 & n2559;
  /* TG68K_ALU.vhd:767:17  */
  assign n2593 = n2558 & n2560;
  /* TG68K_ALU.vhd:767:17  */
  assign n2594 = n2558 & n2559;
  assign n2595 = n1352[0]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2596 = n2561 ? 1'b1 : n2595;
  assign n2597 = n1352[1]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2598 = n2562 ? 1'b1 : n2597;
  assign n2599 = n1352[2]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2600 = n2563 ? 1'b1 : n2599;
  assign n2601 = n1352[3]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2602 = n2564 ? 1'b1 : n2601;
  /* TG68K_ALU.vhd:452:17  */
  assign n2603 = n1352[4]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2604 = n2565 ? 1'b1 : n2603;
  /* TG68K_ALU.vhd:452:17  */
  assign n2605 = n1352[5]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2606 = n2566 ? 1'b1 : n2605;
  /* TG68K_ALU.vhd:452:17  */
  assign n2607 = n1352[6]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2608 = n2567 ? 1'b1 : n2607;
  /* TG68K_ALU.vhd:452:17  */
  assign n2609 = n1352[7]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2610 = n2568 ? 1'b1 : n2609;
  assign n2611 = n1352[8]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2612 = n2569 ? 1'b1 : n2611;
  assign n2613 = n1352[9]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2614 = n2570 ? 1'b1 : n2613;
  assign n2615 = n1352[10]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2616 = n2571 ? 1'b1 : n2615;
  /* TG68K_ALU.vhd:448:1  */
  assign n2617 = n1352[11]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2618 = n2572 ? 1'b1 : n2617;
  /* TG68K_ALU.vhd:441:26  */
  assign n2619 = n1352[12]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2620 = n2573 ? 1'b1 : n2619;
  /* TG68K_ALU.vhd:411:17  */
  assign n2621 = n1352[13]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2622 = n2574 ? 1'b1 : n2621;
  assign n2623 = n1352[14]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2624 = n2575 ? 1'b1 : n2623;
  /* TG68K_ALU.vhd:409:1  */
  assign n2625 = n1352[15]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2626 = n2576 ? 1'b1 : n2625;
  assign n2627 = n1352[16]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2628 = n2577 ? 1'b1 : n2627;
  assign n2629 = n1352[17]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2630 = n2578 ? 1'b1 : n2629;
  /* TG68K_ALU.vhd:289:1  */
  assign n2631 = n1352[18]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2632 = n2579 ? 1'b1 : n2631;
  assign n2633 = n1352[19]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2634 = n2580 ? 1'b1 : n2633;
  /* TG68K_ALU.vhd:182:16  */
  assign n2635 = n1352[20]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2636 = n2581 ? 1'b1 : n2635;
  /* TG68K_ALU.vhd:152:16  */
  assign n2637 = n1352[21]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2638 = n2582 ? 1'b1 : n2637;
  /* TG68K_ALU.vhd:147:16  */
  assign n2639 = n1352[22]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2640 = n2583 ? 1'b1 : n2639;
  /* TG68K_ALU.vhd:131:16  */
  assign n2641 = n1352[23]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2642 = n2584 ? 1'b1 : n2641;
  /* TG68K_ALU.vhd:119:16  */
  assign n2643 = n1352[24]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2644 = n2585 ? 1'b1 : n2643;
  /* TG68K_ALU.vhd:113:16  */
  assign n2645 = n1352[25]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2646 = n2586 ? 1'b1 : n2645;
  /* TG68K_ALU.vhd:1002:17  */
  assign n2647 = n1352[26]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2648 = n2587 ? 1'b1 : n2647;
  assign n2649 = n1352[27]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2650 = n2588 ? 1'b1 : n2649;
  assign n2651 = n1352[28]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2652 = n2589 ? 1'b1 : n2651;
  assign n2653 = n1352[29]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2654 = n2590 ? 1'b1 : n2653;
  assign n2655 = n1352[30]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2656 = n2591 ? 1'b1 : n2655;
  assign n2657 = n1352[31]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2658 = n2592 ? 1'b1 : n2657;
  assign n2659 = n1352[32]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2660 = n2593 ? 1'b1 : n2659;
  assign n2661 = n1352[33]; // extract
  /* TG68K_ALU.vhd:767:17  */
  assign n2662 = n2594 ? 1'b1 : n2661;
  assign n2663 = {n2662, n2660, n2658, n2656, n2654, n2652, n2650, n2648, n2646, n2644, n2642, n2640, n2638, n2636, n2634, n2632, n2630, n2628, n2626, n2624, n2622, n2620, n2618, n2616, n2614, n2612, n2610, n2608, n2606, n2604, n2602, n2600, n2598, n2596};
endmodule

