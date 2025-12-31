module TG68K_FPU_Transcendental
  (input  clk,
   input  nReset,
   input  clkena,
   input  start_operation,
   input  [6:0] operation_code,
   input  [79:0] operand,
   output [79:0] result,
   output result_valid,
   output overflow,
   output underflow,
   output inexact,
   output invalid,
   output operation_busy,
   output operation_done);
  reg [2:0] trans_state;
  wire [63:0] cordic_x;
  wire [63:0] cordic_y;
  wire [63:0] cordic_z;
  wire [4:0] cordic_iteration;
  wire cordic_mode;
  wire input_sign;
  wire [14:0] input_exp;
  wire [63:0] input_mant;
  wire input_zero;
  wire input_inf;
  wire input_nan;
  wire result_sign;
  wire [14:0] result_exp;
  wire [63:0] result_mant;
  wire [79:0] series_term;
  wire [79:0] series_sum;
  wire [3:0] iteration_count;
  wire trans_overflow;
  wire trans_underflow;
  wire trans_inexact;
  wire trans_invalid;
  wire [79:0] exp_argument;
  wire [79:0] log_argument;
  wire [127:0] x_squared;
  wire [127:0] x_cubed;
  wire [127:0] x_fifth;
  wire [63:0] x3_div6;
  wire [63:0] cordic_shift_x;
  wire [63:0] cordic_shift_y;
  wire [63:0] cordic_atan_val;
  wire [63:0] x5_div120;
  wire [63:0] x_n;
  wire [63:0] a_div_x_n;
  wire [63:0] x_next;
  wire [63:0] final_mant;
  wire n10;
  wire [14:0] n11;
  wire [63:0] n12;
  wire [14:0] n13;
  wire n15;
  wire [63:0] n16;
  wire n18;
  wire n19;
  wire n22;
  wire [14:0] n23;
  wire n25;
  wire n26;
  wire n27;
  wire [62:0] n28;
  wire n30;
  wire n31;
  wire n34;
  wire [14:0] n35;
  wire n37;
  wire n38;
  wire [62:0] n39;
  wire n41;
  wire n42;
  wire n43;
  wire n44;
  wire n47;
  wire n50;
  wire n54;
  wire [2:0] n57;
  wire [3:0] n61;
  wire n63;
  wire n65;
  wire n67;
  wire n68;
  wire n70;
  wire n71;
  wire n72;
  wire [63:0] n75;
  wire n77;
  wire n79;
  wire [1:0] n80;
  reg n83;
  reg [14:0] n86;
  reg [63:0] n88;
  reg n90;
  wire [2:0] n93;
  wire n94;
  wire [14:0] n95;
  wire [63:0] n96;
  wire n97;
  wire [2:0] n99;
  wire n100;
  wire [14:0] n102;
  wire [63:0] n103;
  wire n104;
  wire n106;
  wire n107;
  wire n108;
  wire [2:0] n111;
  wire n112;
  wire [14:0] n114;
  wire [63:0] n116;
  wire [2:0] n118;
  wire n120;
  wire [14:0] n122;
  wire [63:0] n124;
  wire n126;
  wire n128;
  wire n130;
  wire n132;
  wire n133;
  wire n135;
  wire [14:0] n138;
  wire [63:0] n141;
  wire [2:0] n144;
  wire n145;
  wire [14:0] n146;
  wire [63:0] n147;
  wire n150;
  wire n152;
  wire n153;
  wire n155;
  wire n156;
  wire [2:0] n159;
  wire n161;
  wire [14:0] n163;
  wire [63:0] n165;
  wire [79:0] n166;
  wire [2:0] n168;
  wire n170;
  wire [14:0] n172;
  wire [63:0] n174;
  wire n176;
  wire [79:0] n177;
  wire n179;
  wire n181;
  wire n182;
  wire n184;
  wire n185;
  wire [2:0] n186;
  reg [2:0] n188;
  reg n189;
  reg [14:0] n190;
  reg [63:0] n191;
  reg n192;
  reg [79:0] n194;
  wire n196;
  wire [31:0] n197;
  wire n199;
  wire n200;
  wire n201;
  wire [14:0] n203;
  wire [14:0] n205;
  wire [14:0] n207;
  wire [14:0] n209;
  wire [14:0] n211;
  wire [14:0] n213;
  wire [14:0] n215;
  wire [14:0] n216;
  wire [31:0] n217;
  wire [31:0] n219;
  wire [3:0] n220;
  wire [31:0] n221;
  wire n223;
  wire [15:0] n224;
  wire n226;
  wire [15:0] n227;
  wire [31:0] n228;
  wire [31:0] n230;
  wire [15:0] n231;
  wire [31:0] n232;
  wire [31:0] n233;
  wire [63:0] n234;
  wire [63:0] n235;
  wire [63:0] n236;
  wire [63:0] n238;
  wire [31:0] n239;
  wire [31:0] n241;
  wire [3:0] n242;
  wire n243;
  wire [63:0] n245;
  wire [63:0] n246;
  wire [63:0] n248;
  wire [63:0] n249;
  wire [63:0] n251;
  wire [63:0] n252;
  wire [63:0] n253;
  wire n254;
  wire n255;
  wire [62:0] n256;
  wire [63:0] n258;
  wire [14:0] n260;
  wire [14:0] n261;
  wire [63:0] n262;
  wire [2:0] n264;
  wire n266;
  wire [14:0] n267;
  wire [63:0] n268;
  wire [3:0] n269;
  wire n271;
  wire [63:0] n272;
  wire [63:0] n273;
  wire [63:0] n274;
  wire [63:0] n275;
  wire [2:0] n276;
  wire n277;
  wire [14:0] n278;
  wire [63:0] n279;
  wire [3:0] n280;
  wire n281;
  wire [63:0] n283;
  wire [63:0] n284;
  wire [63:0] n285;
  wire [63:0] n286;
  wire n288;
  wire n290;
  wire [2:0] n293;
  wire [4:0] n295;
  wire n296;
  wire [14:0] n297;
  wire [63:0] n298;
  wire n300;
  wire n302;
  wire [2:0] n305;
  wire [4:0] n307;
  wire n309;
  wire [14:0] n311;
  wire [63:0] n313;
  wire n315;
  wire [31:0] n316;
  wire n318;
  wire n320;
  wire n321;
  wire n322;
  wire [62:0] n323;
  wire n325;
  wire n326;
  wire [31:0] n327;
  wire [31:0] n329;
  wire [3:0] n330;
  wire [2:0] n332;
  wire n334;
  wire [14:0] n336;
  wire [63:0] n338;
  wire [3:0] n339;
  wire [79:0] n340;
  wire [31:0] n341;
  wire n343;
  wire [31:0] n344;
  wire n346;
  wire n348;
  wire [14:0] n350;
  wire [30:0] n351;
  wire [30:0] n354;
  wire [79:0] n355;
  wire [14:0] n357;
  wire [30:0] n358;
  wire [30:0] n361;
  wire [30:0] n362;
  wire [79:0] n363;
  wire [79:0] n364;
  wire [31:0] n365;
  wire n367;
  wire n368;
  wire [62:0] n369;
  wire [79:0] n370;
  wire [79:0] n371;
  wire [79:0] n372;
  wire [79:0] n373;
  wire n374;
  wire n375;
  wire [79:0] n376;
  wire [79:0] n377;
  wire [31:0] n378;
  wire [31:0] n380;
  wire [3:0] n381;
  wire [14:0] n382;
  wire n384;
  wire [63:0] n385;
  wire n387;
  wire n388;
  wire n389;
  wire [14:0] n390;
  wire [63:0] n391;
  wire n393;
  wire [14:0] n395;
  wire [63:0] n397;
  wire [2:0] n399;
  wire n400;
  wire [14:0] n401;
  wire [63:0] n402;
  wire [79:0] n403;
  wire [79:0] n404;
  wire [3:0] n405;
  wire n407;
  wire [2:0] n408;
  wire n409;
  wire [14:0] n410;
  wire [63:0] n411;
  wire [79:0] n412;
  wire [79:0] n413;
  wire [3:0] n414;
  wire n415;
  wire [79:0] n416;
  wire n418;
  wire [31:0] n419;
  wire n421;
  wire [31:0] n422;
  wire [31:0] n424;
  wire [3:0] n425;
  wire n427;
  wire [31:0] n428;
  wire n430;
  wire n431;
  wire [14:0] n433;
  wire [63:0] n434;
  wire [14:0] n437;
  wire [63:0] n439;
  wire [2:0] n441;
  wire n443;
  wire [14:0] n444;
  wire [63:0] n445;
  wire [3:0] n446;
  wire n448;
  wire [31:0] n449;
  wire n451;
  wire [31:0] n452;
  wire [31:0] n454;
  wire [3:0] n455;
  wire n457;
  wire [31:0] n458;
  wire n460;
  wire n461;
  wire [14:0] n463;
  wire [63:0] n464;
  wire [14:0] n467;
  wire [63:0] n469;
  wire [2:0] n471;
  wire n473;
  wire [14:0] n474;
  wire [63:0] n475;
  wire [3:0] n476;
  wire n478;
  wire [31:0] n479;
  wire n481;
  wire [31:0] n482;
  wire [31:0] n484;
  wire [3:0] n485;
  wire [2:0] n487;
  wire n488;
  wire [14:0] n490;
  wire [63:0] n492;
  wire [79:0] n493;
  wire [3:0] n494;
  wire [31:0] n495;
  wire n497;
  wire [31:0] n498;
  wire n500;
  wire [31:0] n501;
  wire [31:0] n502;
  wire [63:0] n503;
  wire [63:0] n504;
  wire [63:0] n505;
  wire [127:0] n506;
  wire [31:0] n507;
  wire n509;
  wire [31:0] n510;
  wire [31:0] n511;
  wire [63:0] n512;
  wire [63:0] n513;
  wire [63:0] n514;
  wire [127:0] n515;
  wire [31:0] n516;
  wire n518;
  wire [31:0] n519;
  wire [31:0] n521;
  wire [63:0] n522;
  wire [31:0] n523;
  wire n525;
  wire [79:0] n526;
  wire [79:0] n527;
  wire [31:0] n528;
  wire n530;
  wire [31:0] n531;
  wire [31:0] n532;
  wire [63:0] n533;
  wire [63:0] n534;
  wire [63:0] n535;
  wire [127:0] n536;
  wire [31:0] n537;
  wire n539;
  wire [63:0] n540;
  wire [127:0] n541;
  wire [127:0] n543;
  wire [127:0] n545;
  wire [63:0] n546;
  wire [31:0] n547;
  wire n549;
  wire [79:0] n550;
  wire [79:0] n551;
  wire [79:0] n552;
  wire [79:0] n553;
  wire [63:0] n554;
  wire [79:0] n555;
  wire [127:0] n556;
  wire [63:0] n557;
  wire [79:0] n558;
  wire [127:0] n559;
  wire [63:0] n560;
  wire [79:0] n561;
  wire [127:0] n562;
  wire [63:0] n563;
  wire [63:0] n564;
  wire [79:0] n565;
  wire [127:0] n566;
  wire [127:0] n567;
  wire [63:0] n568;
  wire [63:0] n569;
  wire [79:0] n570;
  wire [127:0] n571;
  wire [127:0] n572;
  wire [127:0] n573;
  wire [63:0] n574;
  wire [63:0] n575;
  wire [31:0] n576;
  wire [31:0] n578;
  wire [3:0] n579;
  wire [14:0] n580;
  wire n582;
  wire [14:0] n583;
  wire [63:0] n584;
  wire [14:0] n586;
  wire [63:0] n588;
  wire [2:0] n590;
  wire n591;
  wire [14:0] n592;
  wire [63:0] n593;
  wire [79:0] n594;
  wire [3:0] n595;
  wire n597;
  wire n598;
  wire [127:0] n599;
  wire [127:0] n600;
  wire [63:0] n601;
  wire [63:0] n602;
  wire [2:0] n603;
  wire n604;
  wire [14:0] n605;
  wire [63:0] n606;
  wire [79:0] n607;
  wire [3:0] n608;
  wire n609;
  wire [127:0] n610;
  wire [127:0] n611;
  wire [127:0] n612;
  wire [63:0] n613;
  wire [63:0] n614;
  wire n616;
  wire [31:0] n617;
  wire n619;
  wire [31:0] n620;
  wire [31:0] n622;
  wire [3:0] n623;
  wire [2:0] n625;
  wire n626;
  wire [14:0] n628;
  wire [63:0] n630;
  wire [79:0] n631;
  wire [3:0] n632;
  wire [31:0] n633;
  wire n635;
  wire [31:0] n636;
  wire n638;
  wire [31:0] n639;
  wire [31:0] n640;
  wire [63:0] n641;
  wire [63:0] n642;
  wire [63:0] n643;
  wire [127:0] n644;
  wire [31:0] n645;
  wire n647;
  wire [31:0] n648;
  wire [31:0] n649;
  wire [63:0] n650;
  wire [63:0] n651;
  wire [63:0] n652;
  wire [127:0] n653;
  wire [31:0] n654;
  wire n656;
  wire [31:0] n657;
  wire [31:0] n659;
  wire [63:0] n660;
  wire [31:0] n661;
  wire n663;
  wire [79:0] n664;
  wire [79:0] n665;
  wire [31:0] n666;
  wire n668;
  wire [31:0] n669;
  wire [31:0] n670;
  wire [63:0] n671;
  wire [63:0] n672;
  wire [63:0] n673;
  wire [127:0] n674;
  wire [31:0] n675;
  wire n677;
  wire [63:0] n678;
  wire [63:0] n680;
  wire [31:0] n681;
  wire n683;
  wire [79:0] n684;
  wire [79:0] n685;
  wire [79:0] n686;
  wire [79:0] n687;
  wire [63:0] n688;
  wire [79:0] n689;
  wire [127:0] n690;
  wire [63:0] n691;
  wire [79:0] n692;
  wire [127:0] n693;
  wire [63:0] n694;
  wire [79:0] n695;
  wire [127:0] n696;
  wire [63:0] n697;
  wire [63:0] n698;
  wire [79:0] n699;
  wire [127:0] n700;
  wire [127:0] n701;
  wire [63:0] n702;
  wire [63:0] n703;
  wire [79:0] n704;
  wire [127:0] n705;
  wire [127:0] n706;
  wire [127:0] n707;
  wire [63:0] n708;
  wire [63:0] n709;
  wire [31:0] n710;
  wire [31:0] n712;
  wire [3:0] n713;
  wire n715;
  wire [14:0] n717;
  wire [14:0] n718;
  wire [63:0] n719;
  wire [14:0] n720;
  wire [63:0] n721;
  wire [2:0] n723;
  wire n724;
  wire [14:0] n725;
  wire [63:0] n726;
  wire [79:0] n727;
  wire [3:0] n728;
  wire n730;
  wire n731;
  wire [127:0] n732;
  wire [127:0] n733;
  wire [63:0] n734;
  wire [63:0] n735;
  wire [2:0] n736;
  wire n737;
  wire [14:0] n738;
  wire [63:0] n739;
  wire [79:0] n740;
  wire [3:0] n741;
  wire n742;
  wire [127:0] n743;
  wire [127:0] n744;
  wire [127:0] n745;
  wire [63:0] n746;
  wire [63:0] n747;
  wire n749;
  wire [31:0] n750;
  wire n752;
  wire [31:0] n753;
  wire [31:0] n755;
  wire [3:0] n756;
  wire [2:0] n758;
  wire n760;
  wire [14:0] n762;
  wire [63:0] n764;
  wire [79:0] n766;
  wire [3:0] n767;
  wire [31:0] n768;
  wire n770;
  wire [31:0] n771;
  wire n773;
  wire [31:0] n774;
  wire [31:0] n775;
  wire [63:0] n776;
  wire [63:0] n777;
  wire [63:0] n778;
  wire [127:0] n779;
  wire [31:0] n780;
  wire n782;
  wire [63:0] n783;
  wire [63:0] n785;
  wire [79:0] n786;
  wire [79:0] n787;
  wire [31:0] n788;
  wire n790;
  wire [31:0] n791;
  wire [31:0] n792;
  wire [63:0] n793;
  wire [63:0] n794;
  wire [63:0] n795;
  wire [127:0] n796;
  wire [31:0] n797;
  wire n799;
  wire [63:0] n800;
  wire [63:0] n802;
  wire [79:0] n803;
  wire [79:0] n804;
  wire [31:0] n805;
  wire n807;
  wire [31:0] n808;
  wire [31:0] n809;
  wire [63:0] n810;
  wire [63:0] n811;
  wire [63:0] n812;
  wire [127:0] n813;
  wire [31:0] n814;
  wire n816;
  wire [63:0] n817;
  wire [63:0] n819;
  wire [31:0] n820;
  wire n822;
  wire [79:0] n823;
  wire [79:0] n824;
  wire [79:0] n825;
  wire [79:0] n826;
  wire [63:0] n827;
  wire [79:0] n828;
  wire [127:0] n829;
  wire [63:0] n830;
  wire [79:0] n831;
  wire [127:0] n832;
  wire [63:0] n833;
  wire [79:0] n834;
  wire [127:0] n835;
  wire [127:0] n836;
  wire [63:0] n837;
  wire [79:0] n838;
  wire [127:0] n839;
  wire [127:0] n840;
  wire [63:0] n841;
  wire [79:0] n842;
  wire [127:0] n843;
  wire [127:0] n844;
  wire [127:0] n845;
  wire [63:0] n846;
  wire [31:0] n847;
  wire [31:0] n849;
  wire [3:0] n850;
  wire n852;
  wire [14:0] n854;
  wire [14:0] n855;
  wire [63:0] n856;
  wire [14:0] n857;
  wire [63:0] n858;
  wire [2:0] n860;
  wire n862;
  wire [14:0] n863;
  wire [63:0] n864;
  wire [79:0] n865;
  wire [3:0] n866;
  wire n868;
  wire n869;
  wire [127:0] n870;
  wire [127:0] n871;
  wire [63:0] n872;
  wire [2:0] n873;
  wire n874;
  wire [14:0] n875;
  wire [63:0] n876;
  wire [79:0] n877;
  wire [3:0] n878;
  wire n879;
  wire [127:0] n880;
  wire [127:0] n881;
  wire [127:0] n882;
  wire [63:0] n883;
  wire n885;
  wire [31:0] n886;
  wire n888;
  wire n890;
  wire [31:0] n891;
  wire [31:0] n893;
  wire [3:0] n894;
  wire [2:0] n896;
  wire n897;
  wire [14:0] n899;
  wire [63:0] n901;
  wire [79:0] n902;
  wire [3:0] n903;
  wire [2:0] n905;
  wire n906;
  wire [14:0] n908;
  wire [63:0] n910;
  wire [79:0] n911;
  wire [3:0] n912;
  wire [31:0] n913;
  wire n915;
  wire [31:0] n916;
  wire n918;
  wire [31:0] n919;
  wire [31:0] n920;
  wire [63:0] n921;
  wire [63:0] n922;
  wire [63:0] n923;
  wire [127:0] n924;
  wire [31:0] n925;
  wire n927;
  wire [31:0] n928;
  wire [31:0] n929;
  wire [63:0] n930;
  wire [63:0] n931;
  wire [63:0] n932;
  wire [127:0] n933;
  wire [31:0] n934;
  wire n936;
  wire [31:0] n937;
  wire [31:0] n939;
  wire [63:0] n940;
  wire [31:0] n941;
  wire n943;
  wire [79:0] n944;
  wire [79:0] n945;
  wire [31:0] n946;
  wire n948;
  wire [31:0] n949;
  wire [31:0] n950;
  wire [63:0] n951;
  wire [63:0] n952;
  wire [63:0] n953;
  wire [127:0] n954;
  wire [31:0] n955;
  wire n957;
  wire [63:0] n958;
  wire [127:0] n959;
  wire [127:0] n961;
  wire [127:0] n963;
  wire [63:0] n964;
  wire [31:0] n965;
  wire n967;
  wire [79:0] n968;
  wire [79:0] n969;
  wire [79:0] n970;
  wire [79:0] n971;
  wire [63:0] n972;
  wire [79:0] n973;
  wire [127:0] n974;
  wire [63:0] n975;
  wire [79:0] n976;
  wire [127:0] n977;
  wire [63:0] n978;
  wire [79:0] n979;
  wire [127:0] n980;
  wire [63:0] n981;
  wire [63:0] n982;
  wire [79:0] n983;
  wire [127:0] n984;
  wire [127:0] n985;
  wire [63:0] n986;
  wire [63:0] n987;
  wire [79:0] n988;
  wire [127:0] n989;
  wire [127:0] n990;
  wire [127:0] n991;
  wire [63:0] n992;
  wire [63:0] n993;
  wire [31:0] n994;
  wire [31:0] n996;
  wire [3:0] n997;
  wire [14:0] n998;
  wire n1000;
  wire [14:0] n1001;
  wire [63:0] n1002;
  wire [14:0] n1004;
  wire [63:0] n1006;
  wire [2:0] n1008;
  wire n1009;
  wire [14:0] n1010;
  wire [63:0] n1011;
  wire [79:0] n1012;
  wire [3:0] n1013;
  wire n1015;
  wire n1016;
  wire [127:0] n1017;
  wire [127:0] n1018;
  wire [63:0] n1019;
  wire [63:0] n1020;
  wire [2:0] n1021;
  wire n1022;
  wire [14:0] n1023;
  wire [63:0] n1024;
  wire [79:0] n1025;
  wire [3:0] n1026;
  wire n1027;
  wire [127:0] n1028;
  wire [127:0] n1029;
  wire [127:0] n1030;
  wire [63:0] n1031;
  wire [63:0] n1032;
  wire n1034;
  wire [31:0] n1035;
  wire n1037;
  wire n1039;
  wire n1041;
  wire n1043;
  wire n1044;
  wire n1045;
  wire n1047;
  wire [1:0] n1048;
  wire n1050;
  wire n1051;
  wire [31:0] n1052;
  wire [31:0] n1054;
  wire [3:0] n1055;
  wire [2:0] n1057;
  wire n1058;
  wire [14:0] n1060;
  wire [63:0] n1062;
  wire [79:0] n1063;
  wire [3:0] n1064;
  wire [2:0] n1066;
  wire n1067;
  wire [14:0] n1069;
  wire [63:0] n1071;
  wire [79:0] n1072;
  wire [3:0] n1073;
  wire [2:0] n1075;
  wire n1077;
  wire [14:0] n1079;
  wire [63:0] n1081;
  wire [79:0] n1082;
  wire [3:0] n1083;
  wire n1085;
  wire [31:0] n1086;
  wire n1088;
  wire [31:0] n1089;
  wire n1091;
  wire [31:0] n1092;
  wire [31:0] n1093;
  wire [63:0] n1094;
  wire [63:0] n1095;
  wire [63:0] n1096;
  wire [127:0] n1097;
  wire [31:0] n1098;
  wire n1100;
  wire [31:0] n1101;
  wire [31:0] n1102;
  wire [63:0] n1103;
  wire [63:0] n1104;
  wire [63:0] n1105;
  wire [127:0] n1106;
  wire [31:0] n1107;
  wire n1109;
  wire [31:0] n1110;
  wire [31:0] n1112;
  wire [63:0] n1113;
  wire [31:0] n1114;
  wire n1116;
  wire [79:0] n1117;
  wire [79:0] n1118;
  wire [31:0] n1119;
  wire n1121;
  wire [31:0] n1122;
  wire [31:0] n1123;
  wire [63:0] n1124;
  wire [63:0] n1125;
  wire [63:0] n1126;
  wire [127:0] n1127;
  wire [31:0] n1128;
  wire n1130;
  wire [63:0] n1131;
  wire [127:0] n1132;
  wire [127:0] n1134;
  wire [127:0] n1136;
  wire [63:0] n1137;
  wire [31:0] n1138;
  wire n1140;
  wire [79:0] n1141;
  wire [79:0] n1142;
  wire [79:0] n1143;
  wire [79:0] n1144;
  wire [63:0] n1145;
  wire [79:0] n1146;
  wire [127:0] n1147;
  wire [63:0] n1148;
  wire [79:0] n1149;
  wire [127:0] n1150;
  wire [63:0] n1151;
  wire [79:0] n1152;
  wire [127:0] n1153;
  wire [63:0] n1154;
  wire [63:0] n1155;
  wire [79:0] n1156;
  wire [127:0] n1157;
  wire [127:0] n1158;
  wire [63:0] n1159;
  wire [63:0] n1160;
  wire [79:0] n1161;
  wire [127:0] n1162;
  wire [127:0] n1163;
  wire [127:0] n1164;
  wire [63:0] n1165;
  wire [63:0] n1166;
  wire [31:0] n1167;
  wire [31:0] n1169;
  wire [3:0] n1170;
  wire [14:0] n1171;
  wire [63:0] n1172;
  wire [2:0] n1174;
  wire n1175;
  wire [14:0] n1176;
  wire [63:0] n1177;
  wire [79:0] n1178;
  wire [3:0] n1179;
  wire n1181;
  wire n1182;
  wire [127:0] n1183;
  wire [127:0] n1184;
  wire [63:0] n1185;
  wire [63:0] n1186;
  wire [2:0] n1187;
  wire n1188;
  wire [14:0] n1189;
  wire [63:0] n1190;
  wire [79:0] n1191;
  wire [3:0] n1192;
  wire n1193;
  wire n1194;
  wire [127:0] n1195;
  wire [127:0] n1196;
  wire [127:0] n1197;
  wire [63:0] n1198;
  wire [63:0] n1199;
  wire n1201;
  wire [31:0] n1202;
  wire n1204;
  wire n1206;
  wire n1208;
  wire n1210;
  wire n1211;
  wire n1212;
  wire n1214;
  wire [1:0] n1215;
  wire n1217;
  wire n1218;
  wire n1219;
  wire n1220;
  wire n1222;
  wire [1:0] n1223;
  wire n1225;
  wire n1226;
  wire n1227;
  wire [31:0] n1228;
  wire [31:0] n1230;
  wire [3:0] n1231;
  wire [2:0] n1233;
  wire n1235;
  wire [14:0] n1237;
  wire [63:0] n1239;
  wire [79:0] n1241;
  wire [3:0] n1242;
  wire [2:0] n1244;
  wire n1246;
  wire [14:0] n1248;
  wire [63:0] n1250;
  wire [79:0] n1251;
  wire [3:0] n1252;
  wire [2:0] n1254;
  wire n1256;
  wire [14:0] n1258;
  wire [63:0] n1260;
  wire [79:0] n1261;
  wire [3:0] n1262;
  wire [2:0] n1264;
  wire n1266;
  wire [14:0] n1268;
  wire [63:0] n1270;
  wire [79:0] n1271;
  wire [3:0] n1272;
  wire n1274;
  wire [31:0] n1275;
  wire n1277;
  wire [31:0] n1278;
  wire n1280;
  wire [31:0] n1281;
  wire [31:0] n1282;
  wire [63:0] n1283;
  wire [63:0] n1284;
  wire [63:0] n1285;
  wire [127:0] n1286;
  wire [31:0] n1287;
  wire n1289;
  wire n1290;
  wire [79:0] n1292;
  wire [79:0] n1294;
  wire [79:0] n1295;
  wire [31:0] n1296;
  wire n1298;
  wire [31:0] n1299;
  wire [31:0] n1300;
  wire [63:0] n1301;
  wire [63:0] n1302;
  wire [63:0] n1303;
  wire [127:0] n1304;
  wire [31:0] n1305;
  wire n1307;
  wire [31:0] n1308;
  wire [31:0] n1310;
  wire [63:0] n1311;
  wire [31:0] n1312;
  wire n1314;
  wire n1315;
  wire [79:0] n1316;
  wire [79:0] n1317;
  wire [79:0] n1318;
  wire [79:0] n1319;
  wire [79:0] n1320;
  wire [31:0] n1321;
  wire n1323;
  wire [31:0] n1324;
  wire [31:0] n1325;
  wire [63:0] n1326;
  wire [63:0] n1327;
  wire [63:0] n1328;
  wire [127:0] n1329;
  wire [31:0] n1330;
  wire n1332;
  wire [63:0] n1333;
  wire [127:0] n1334;
  wire [127:0] n1336;
  wire [127:0] n1338;
  wire [63:0] n1339;
  wire [63:0] n1340;
  wire [127:0] n1341;
  wire [63:0] n1342;
  wire [79:0] n1343;
  wire [127:0] n1344;
  wire [63:0] n1345;
  wire [79:0] n1346;
  wire [127:0] n1347;
  wire [63:0] n1348;
  wire [63:0] n1349;
  wire [79:0] n1350;
  wire [127:0] n1351;
  wire [127:0] n1352;
  wire [63:0] n1353;
  wire [63:0] n1354;
  wire [79:0] n1355;
  wire [127:0] n1356;
  wire [127:0] n1357;
  wire [63:0] n1358;
  wire [63:0] n1359;
  wire [79:0] n1360;
  wire [127:0] n1361;
  wire [127:0] n1362;
  wire [127:0] n1363;
  wire [63:0] n1364;
  wire [63:0] n1365;
  wire [31:0] n1366;
  wire [31:0] n1368;
  wire [3:0] n1369;
  wire [14:0] n1370;
  wire [63:0] n1371;
  wire [2:0] n1373;
  wire n1375;
  wire [14:0] n1376;
  wire [63:0] n1377;
  wire [79:0] n1378;
  wire [3:0] n1379;
  wire n1381;
  wire n1382;
  wire [127:0] n1383;
  wire [127:0] n1384;
  wire [63:0] n1385;
  wire [63:0] n1386;
  wire [2:0] n1387;
  wire n1388;
  wire [14:0] n1389;
  wire [63:0] n1390;
  wire [79:0] n1391;
  wire [3:0] n1392;
  wire n1393;
  wire n1394;
  wire [127:0] n1395;
  wire [127:0] n1396;
  wire [127:0] n1397;
  wire [63:0] n1398;
  wire [63:0] n1399;
  wire n1401;
  wire n1403;
  wire [2:0] n1406;
  wire [4:0] n1408;
  wire n1409;
  wire [14:0] n1410;
  wire [63:0] n1411;
  wire [2:0] n1413;
  wire [4:0] n1414;
  wire n1415;
  wire [14:0] n1417;
  wire [63:0] n1419;
  wire n1421;
  wire [31:0] n1422;
  wire n1424;
  wire n1426;
  wire [31:0] n1427;
  wire [31:0] n1429;
  wire [3:0] n1430;
  wire [2:0] n1432;
  wire n1433;
  wire [14:0] n1435;
  wire [63:0] n1437;
  wire [3:0] n1438;
  wire [2:0] n1440;
  wire n1442;
  wire [14:0] n1444;
  wire [63:0] n1446;
  wire [3:0] n1447;
  wire n1449;
  wire [31:0] n1450;
  wire n1452;
  wire [31:0] n1453;
  wire [31:0] n1455;
  wire [3:0] n1456;
  wire [2:0] n1458;
  wire n1459;
  wire [14:0] n1460;
  wire [63:0] n1461;
  wire [3:0] n1462;
  wire [2:0] n1463;
  wire n1464;
  wire [14:0] n1465;
  wire [63:0] n1466;
  wire [3:0] n1467;
  wire n1469;
  wire n1470;
  wire n1472;
  wire [31:0] n1473;
  wire n1475;
  wire n1477;
  wire n1478;
  wire n1479;
  wire n1481;
  wire n1482;
  wire [31:0] n1483;
  wire [31:0] n1485;
  wire [3:0] n1486;
  wire [2:0] n1488;
  wire n1490;
  wire [14:0] n1492;
  wire [63:0] n1494;
  wire [79:0] n1496;
  wire [79:0] n1498;
  wire [3:0] n1499;
  wire n1501;
  wire [79:0] n1502;
  wire [2:0] n1504;
  wire n1506;
  wire [14:0] n1508;
  wire [63:0] n1510;
  wire [79:0] n1511;
  wire [79:0] n1512;
  wire [3:0] n1513;
  wire n1514;
  wire n1516;
  wire [79:0] n1517;
  wire [2:0] n1519;
  wire n1521;
  wire [14:0] n1523;
  wire [63:0] n1525;
  wire [79:0] n1526;
  wire [79:0] n1527;
  wire [3:0] n1528;
  wire n1529;
  wire n1530;
  wire [79:0] n1531;
  wire [31:0] n1532;
  wire n1534;
  wire [31:0] n1535;
  wire n1537;
  wire [79:0] n1538;
  wire [31:0] n1539;
  wire n1541;
  wire [15:0] n1542;
  wire [15:0] n1543;
  wire [31:0] n1544;
  wire [31:0] n1545;
  wire [31:0] n1546;
  wire [31:0] n1548;
  wire [79:0] n1549;
  wire [79:0] n1550;
  wire [31:0] n1551;
  wire n1553;
  wire [15:0] n1554;
  wire [15:0] n1555;
  wire [31:0] n1556;
  wire [31:0] n1557;
  wire [31:0] n1558;
  wire [15:0] n1559;
  wire [47:0] n1560;
  wire [47:0] n1561;
  wire [47:0] n1562;
  wire [47:0] n1564;
  wire [79:0] n1565;
  wire [79:0] n1566;
  wire [31:0] n1567;
  wire n1569;
  wire [79:0] n1571;
  wire [79:0] n1572;
  wire [79:0] n1573;
  wire [79:0] n1574;
  wire [79:0] n1575;
  wire [79:0] n1576;
  wire [79:0] n1577;
  wire [79:0] n1578;
  wire [79:0] n1579;
  wire [79:0] n1580;
  wire [31:0] n1581;
  wire [31:0] n1583;
  wire [3:0] n1584;
  wire n1585;
  wire [14:0] n1586;
  wire [63:0] n1587;
  wire [2:0] n1589;
  wire n1590;
  wire [14:0] n1591;
  wire [63:0] n1592;
  wire [79:0] n1593;
  wire [79:0] n1594;
  wire [3:0] n1595;
  wire n1597;
  wire [2:0] n1598;
  wire n1599;
  wire [14:0] n1600;
  wire [63:0] n1601;
  wire [79:0] n1602;
  wire [79:0] n1603;
  wire [3:0] n1604;
  wire n1605;
  wire n1606;
  wire n1607;
  wire [79:0] n1608;
  wire n1610;
  wire [31:0] n1611;
  wire n1613;
  wire n1615;
  wire n1616;
  wire n1617;
  wire n1619;
  wire n1620;
  wire [31:0] n1621;
  wire [31:0] n1623;
  wire [3:0] n1624;
  wire [2:0] n1626;
  wire n1628;
  wire [14:0] n1630;
  wire [63:0] n1632;
  wire [79:0] n1633;
  wire [79:0] n1634;
  wire [3:0] n1635;
  wire n1637;
  wire [79:0] n1638;
  wire [2:0] n1640;
  wire n1642;
  wire [14:0] n1644;
  wire [63:0] n1646;
  wire [79:0] n1647;
  wire [79:0] n1648;
  wire [3:0] n1649;
  wire n1650;
  wire n1652;
  wire [79:0] n1653;
  wire [2:0] n1655;
  wire n1657;
  wire [14:0] n1659;
  wire [63:0] n1661;
  wire [79:0] n1662;
  wire [79:0] n1663;
  wire [3:0] n1664;
  wire n1665;
  wire n1666;
  wire [79:0] n1667;
  wire [31:0] n1668;
  wire n1670;
  wire [31:0] n1671;
  wire n1673;
  wire [15:0] n1674;
  wire [15:0] n1675;
  wire [31:0] n1676;
  wire [31:0] n1677;
  wire [31:0] n1678;
  wire [31:0] n1680;
  wire [79:0] n1681;
  wire [79:0] n1682;
  wire [31:0] n1683;
  wire n1685;
  wire [15:0] n1686;
  wire [15:0] n1687;
  wire [31:0] n1688;
  wire [31:0] n1689;
  wire [31:0] n1690;
  wire [15:0] n1691;
  wire [47:0] n1692;
  wire [47:0] n1693;
  wire [47:0] n1694;
  wire [47:0] n1696;
  wire [79:0] n1697;
  wire [79:0] n1698;
  wire [31:0] n1699;
  wire n1701;
  wire [79:0] n1703;
  wire [79:0] n1704;
  wire [79:0] n1705;
  wire [79:0] n1706;
  wire [79:0] n1707;
  wire [79:0] n1708;
  wire [79:0] n1709;
  wire [79:0] n1710;
  wire [31:0] n1711;
  wire [31:0] n1713;
  wire [3:0] n1714;
  wire n1715;
  wire [14:0] n1716;
  wire [63:0] n1717;
  wire [2:0] n1719;
  wire n1720;
  wire [14:0] n1721;
  wire [63:0] n1722;
  wire [79:0] n1723;
  wire [79:0] n1724;
  wire [3:0] n1725;
  wire n1727;
  wire [2:0] n1728;
  wire n1729;
  wire [14:0] n1730;
  wire [63:0] n1731;
  wire [79:0] n1732;
  wire [79:0] n1733;
  wire [3:0] n1734;
  wire n1735;
  wire n1736;
  wire n1737;
  wire [79:0] n1738;
  wire n1740;
  wire [31:0] n1741;
  wire n1743;
  wire n1745;
  wire n1746;
  wire n1748;
  wire n1750;
  wire n1751;
  wire n1752;
  wire [31:0] n1753;
  wire [31:0] n1755;
  wire [3:0] n1756;
  wire [2:0] n1758;
  wire n1760;
  wire [14:0] n1762;
  wire [63:0] n1764;
  wire [79:0] n1765;
  wire [79:0] n1766;
  wire [3:0] n1767;
  wire [79:0] n1768;
  wire [2:0] n1770;
  wire n1772;
  wire [14:0] n1774;
  wire [63:0] n1776;
  wire [79:0] n1777;
  wire [79:0] n1778;
  wire [3:0] n1779;
  wire [79:0] n1780;
  wire [2:0] n1782;
  wire n1784;
  wire [14:0] n1786;
  wire [63:0] n1788;
  wire [79:0] n1789;
  wire [79:0] n1790;
  wire [3:0] n1791;
  wire n1793;
  wire [79:0] n1794;
  wire [31:0] n1795;
  wire n1797;
  wire [31:0] n1798;
  wire n1800;
  wire [15:0] n1801;
  wire [15:0] n1802;
  wire [31:0] n1803;
  wire [31:0] n1804;
  wire [31:0] n1805;
  wire [31:0] n1807;
  wire [79:0] n1808;
  wire [78:0] n1810;
  wire [79:0] n1811;
  wire [31:0] n1812;
  wire n1814;
  wire [15:0] n1815;
  wire [15:0] n1816;
  wire [31:0] n1817;
  wire [31:0] n1818;
  wire [31:0] n1819;
  wire [15:0] n1820;
  wire [47:0] n1821;
  wire [47:0] n1822;
  wire [47:0] n1823;
  wire [47:0] n1825;
  wire [79:0] n1826;
  wire [79:0] n1827;
  wire [31:0] n1828;
  wire n1830;
  wire [79:0] n1832;
  wire [78:0] n1834;
  wire [79:0] n1835;
  wire [79:0] n1836;
  wire [79:0] n1837;
  wire [79:0] n1838;
  wire [79:0] n1839;
  wire [79:0] n1840;
  wire [79:0] n1841;
  wire [79:0] n1842;
  wire [79:0] n1843;
  wire [31:0] n1844;
  wire [31:0] n1846;
  wire [3:0] n1847;
  wire n1848;
  wire [14:0] n1849;
  wire [63:0] n1850;
  wire [2:0] n1852;
  wire n1853;
  wire [14:0] n1854;
  wire [63:0] n1855;
  wire [79:0] n1856;
  wire [79:0] n1857;
  wire [3:0] n1858;
  wire n1860;
  wire [2:0] n1861;
  wire n1862;
  wire [14:0] n1863;
  wire [63:0] n1864;
  wire [79:0] n1865;
  wire [79:0] n1866;
  wire [3:0] n1867;
  wire n1868;
  wire n1869;
  wire [79:0] n1870;
  wire n1872;
  wire [31:0] n1873;
  wire n1875;
  wire [31:0] n1876;
  wire [31:0] n1878;
  wire [3:0] n1879;
  wire [2:0] n1881;
  wire n1883;
  wire [14:0] n1885;
  wire [63:0] n1887;
  wire [3:0] n1888;
  wire [31:0] n1889;
  wire n1891;
  wire [31:0] n1892;
  wire [31:0] n1894;
  wire [3:0] n1895;
  wire n1897;
  wire n1898;
  wire n1899;
  wire n1901;
  wire n1902;
  wire [13:0] n1903;
  wire [14:0] n1904;
  wire [14:0] n1906;
  wire [14:0] n1908;
  wire n1910;
  wire [14:0] n1912;
  wire n1913;
  wire n1915;
  wire [2:0] n1917;
  wire n1919;
  wire [14:0] n1920;
  wire [63:0] n1922;
  wire [3:0] n1923;
  wire n1924;
  wire n1925;
  wire [2:0] n1926;
  wire n1927;
  wire [14:0] n1928;
  wire [63:0] n1929;
  wire [3:0] n1930;
  wire n1931;
  wire n1932;
  wire n1934;
  wire n1936;
  wire [31:0] n1937;
  wire n1939;
  wire [31:0] n1940;
  wire [31:0] n1942;
  wire [3:0] n1943;
  wire [2:0] n1945;
  wire n1947;
  wire [14:0] n1949;
  wire [63:0] n1951;
  wire [3:0] n1952;
  wire [31:0] n1953;
  wire n1955;
  wire [31:0] n1956;
  wire [31:0] n1958;
  wire [3:0] n1959;
  wire n1961;
  wire n1962;
  wire n1963;
  wire n1965;
  wire n1966;
  wire [14:0] n1967;
  wire [14:0] n1969;
  wire [14:0] n1971;
  wire [14:0] n1973;
  wire n1975;
  wire [14:0] n1977;
  wire n1978;
  wire n1980;
  wire [2:0] n1982;
  wire n1984;
  wire [14:0] n1985;
  wire [63:0] n1987;
  wire [3:0] n1988;
  wire n1989;
  wire n1990;
  wire [2:0] n1991;
  wire n1992;
  wire [14:0] n1993;
  wire [63:0] n1994;
  wire [3:0] n1995;
  wire n1996;
  wire n1997;
  wire n1999;
  wire n2001;
  wire [18:0] n2002;
  reg [2:0] n2004;
  reg [4:0] n2005;
  reg n2007;
  reg [14:0] n2009;
  reg [63:0] n2011;
  reg [79:0] n2012;
  reg [79:0] n2013;
  reg [3:0] n2014;
  reg n2015;
  reg n2016;
  reg n2019;
  reg n2021;
  reg [79:0] n2022;
  reg [79:0] n2023;
  reg [127:0] n2024;
  reg [127:0] n2025;
  reg [127:0] n2026;
  reg [63:0] n2027;
  reg [63:0] n2028;
  reg [63:0] n2029;
  reg [63:0] n2030;
  reg [63:0] n2031;
  reg [63:0] n2032;
  wire n2034;
  wire n2036;
  wire [31:0] n2037;
  wire n2039;
  wire [29:0] n2040;
  wire [63:0] n2041;
  wire [31:0] n2042;
  wire [31:0] n2044;
  wire [4:0] n2045;
  wire n2047;
  wire n2049;
  wire n2050;
  wire [29:0] n2051;
  wire [63:0] n2052;
  wire [29:0] n2053;
  wire [63:0] n2054;
  wire [31:0] n2055;
  wire [31:0] n2057;
  wire [4:0] n2058;
  wire n2060;
  wire [1:0] n2061;
  reg [2:0] n2063;
  reg [63:0] n2065;
  reg [63:0] n2067;
  reg [63:0] n2069;
  reg [4:0] n2070;
  reg n2073;
  wire [31:0] n2074;
  wire n2076;
  wire [31:0] n2077;
  wire [31:0] n2079;
  wire [30:0] n2080;
  wire [63:0] n2081;
  wire [31:0] n2082;
  wire [31:0] n2084;
  wire [30:0] n2085;
  wire [63:0] n2086;
  wire [31:0] n2087;
  wire [31:0] n2089;
  wire [3:0] n2090;
  wire n2096;
  wire n2098;
  wire [63:0] n2099;
  wire [63:0] n2100;
  wire [63:0] n2101;
  wire [63:0] n2102;
  wire [63:0] n2103;
  wire [63:0] n2104;
  wire [63:0] n2105;
  wire [63:0] n2106;
  wire [63:0] n2107;
  wire n2109;
  wire [63:0] n2110;
  wire [63:0] n2111;
  wire [63:0] n2112;
  wire [63:0] n2113;
  wire [63:0] n2114;
  wire [63:0] n2115;
  wire [63:0] n2116;
  wire [63:0] n2117;
  wire [63:0] n2118;
  wire [63:0] n2119;
  wire [63:0] n2120;
  wire [63:0] n2121;
  wire [31:0] n2122;
  wire [31:0] n2124;
  wire [4:0] n2125;
  wire [63:0] n2126;
  wire n2128;
  wire [63:0] n2129;
  wire n2131;
  wire n2132;
  wire [63:0] n2133;
  wire n2135;
  wire [2:0] n2136;
  reg n2140;
  reg [14:0] n2144;
  reg [63:0] n2145;
  wire [2:0] n2147;
  wire [63:0] n2148;
  wire [63:0] n2149;
  wire [63:0] n2150;
  wire [4:0] n2151;
  wire n2152;
  wire [14:0] n2153;
  wire [63:0] n2154;
  wire [63:0] n2155;
  wire [63:0] n2156;
  wire [63:0] n2157;
  wire [2:0] n2158;
  wire [63:0] n2159;
  wire [63:0] n2160;
  wire [63:0] n2161;
  wire [4:0] n2162;
  wire n2163;
  wire n2164;
  wire [14:0] n2165;
  wire [63:0] n2166;
  wire [63:0] n2167;
  wire [63:0] n2168;
  wire [63:0] n2169;
  wire n2171;
  wire n2173;
  wire n2175;
  wire n2176;
  wire n2177;
  wire n2178;
  wire n2179;
  wire [62:0] n2180;
  wire [63:0] n2182;
  wire n2183;
  wire [61:0] n2184;
  wire [63:0] n2186;
  wire [59:0] n2187;
  wire [63:0] n2189;
  wire [14:0] n2192;
  wire [63:0] n2193;
  wire [14:0] n2195;
  wire [63:0] n2196;
  wire [14:0] n2197;
  wire [63:0] n2198;
  wire n2200;
  wire n2201;
  wire [62:0] n2202;
  wire n2204;
  wire n2205;
  wire n2207;
  wire n2208;
  wire n2210;
  wire n2212;
  wire n2213;
  wire n2214;
  wire n2215;
  wire n2217;
  wire n2218;
  wire n2220;
  wire n2221;
  wire n2222;
  wire n2223;
  wire n2224;
  wire n2225;
  wire [1:0] n2226;
  wire [61:0] n2227;
  wire [61:0] n2228;
  wire [61:0] n2229;
  wire [1:0] n2230;
  wire [1:0] n2231;
  wire n2233;
  wire [15:0] n2234;
  wire [79:0] n2235;
  wire n2237;
  wire [7:0] n2238;
  reg [79:0] n2240;
  reg n2244;
  reg n2247;
  reg n2251;
  reg [2:0] n2256;
  reg [63:0] n2258;
  reg [63:0] n2260;
  reg [63:0] n2262;
  reg [4:0] n2264;
  reg n2266;
  reg n2268;
  reg [14:0] n2270;
  wire [61:0] n2271;
  wire [61:0] n2272;
  wire [61:0] n2273;
  wire [61:0] n2274;
  wire [61:0] n2275;
  reg [61:0] n2277;
  wire [1:0] n2278;
  wire [1:0] n2279;
  wire [1:0] n2280;
  wire [1:0] n2281;
  wire [1:0] n2282;
  reg [1:0] n2284;
  reg [79:0] n2288;
  reg [79:0] n2290;
  reg [3:0] n2292;
  reg n2295;
  reg n2298;
  reg n2301;
  reg n2304;
  reg [79:0] n2308;
  reg [79:0] n2310;
  reg [127:0] n2312;
  reg [127:0] n2314;
  reg [127:0] n2316;
  reg [63:0] n2318;
  reg [63:0] n2320;
  reg [63:0] n2322;
  reg [63:0] n2324;
  reg [63:0] n2326;
  reg [63:0] n2328;
  reg [63:0] n2330;
  reg [63:0] n2332;
  reg [63:0] n2334;
  wire [63:0] n2347;
  wire [2:0] n2454;
  reg [2:0] n2455;
  wire n2456;
  wire n2457;
  wire [63:0] n2458;
  reg [63:0] n2459;
  wire n2460;
  wire n2461;
  wire [63:0] n2462;
  reg [63:0] n2463;
  wire n2464;
  wire n2465;
  wire [63:0] n2466;
  reg [63:0] n2467;
  wire n2468;
  wire n2469;
  wire [4:0] n2470;
  reg [4:0] n2471;
  wire n2472;
  wire n2473;
  wire n2474;
  reg n2475;
  wire n2476;
  wire n2477;
  wire n2478;
  reg n2479;
  wire n2480;
  wire n2481;
  wire [14:0] n2482;
  reg [14:0] n2483;
  wire n2484;
  wire n2485;
  wire [63:0] n2486;
  reg [63:0] n2487;
  wire n2492;
  wire n2493;
  wire [79:0] n2494;
  reg [79:0] n2495;
  wire n2496;
  wire n2497;
  wire [79:0] n2498;
  reg [79:0] n2499;
  wire n2500;
  wire n2501;
  wire [3:0] n2502;
  reg [3:0] n2503;
  wire n2504;
  reg n2505;
  wire n2506;
  reg n2507;
  wire n2508;
  reg n2509;
  wire n2510;
  reg n2511;
  wire n2516;
  wire n2517;
  wire [79:0] n2518;
  reg [79:0] n2519;
  wire n2520;
  wire n2521;
  wire [79:0] n2522;
  reg [79:0] n2523;
  wire n2525;
  wire n2526;
  wire [127:0] n2527;
  reg [127:0] n2528;
  wire n2529;
  wire n2530;
  wire [127:0] n2531;
  reg [127:0] n2532;
  wire n2533;
  wire n2534;
  wire [127:0] n2535;
  reg [127:0] n2536;
  wire n2537;
  wire n2538;
  wire [63:0] n2539;
  reg [63:0] n2540;
  wire n2541;
  wire n2542;
  wire [63:0] n2543;
  reg [63:0] n2544;
  wire n2545;
  wire n2546;
  wire [63:0] n2547;
  reg [63:0] n2548;
  wire n2549;
  wire n2550;
  wire [63:0] n2551;
  reg [63:0] n2552;
  wire n2553;
  wire n2554;
  wire [63:0] n2555;
  reg [63:0] n2556;
  wire n2558;
  wire n2559;
  wire [63:0] n2560;
  reg [63:0] n2561;
  wire n2562;
  wire n2563;
  wire [63:0] n2564;
  reg [63:0] n2565;
  wire n2566;
  wire n2567;
  wire [63:0] n2568;
  reg [63:0] n2569;
  wire n2570;
  wire n2571;
  wire [63:0] n2572;
  reg [63:0] n2573;
  wire [79:0] n2574;
  reg [79:0] n2575;
  wire n2576;
  reg n2577;
  wire n2578;
  reg n2579;
  wire n2580;
  reg n2581;
  wire [63:0] n2584; // mem_rd
  assign result = n2575; //(module output)
  assign result_valid = n2577; //(module output)
  assign overflow = trans_overflow; //(module output)
  assign underflow = trans_underflow; //(module output)
  assign inexact = trans_inexact; //(module output)
  assign invalid = trans_invalid; //(module output)
  assign operation_busy = n2579; //(module output)
  assign operation_done = n2581; //(module output)
  /* TG68K_FPU_Transcendental.vhd:102:16  */
  always @*
    trans_state = n2455; // (isignal)
  initial
    trans_state = 3'b000;
  /* TG68K_FPU_Transcendental.vhd:126:16  */
  assign cordic_x = n2459; // (signal)
  /* TG68K_FPU_Transcendental.vhd:126:26  */
  assign cordic_y = n2463; // (signal)
  /* TG68K_FPU_Transcendental.vhd:126:36  */
  assign cordic_z = n2467; // (signal)
  /* TG68K_FPU_Transcendental.vhd:127:16  */
  assign cordic_iteration = n2471; // (signal)
  /* TG68K_FPU_Transcendental.vhd:128:16  */
  assign cordic_mode = n2475; // (signal)
  /* TG68K_FPU_Transcendental.vhd:131:16  */
  assign input_sign = n10; // (signal)
  /* TG68K_FPU_Transcendental.vhd:132:16  */
  assign input_exp = n11; // (signal)
  /* TG68K_FPU_Transcendental.vhd:133:16  */
  assign input_mant = n12; // (signal)
  /* TG68K_FPU_Transcendental.vhd:134:16  */
  assign input_zero = n22; // (signal)
  /* TG68K_FPU_Transcendental.vhd:135:16  */
  assign input_inf = n34; // (signal)
  /* TG68K_FPU_Transcendental.vhd:136:16  */
  assign input_nan = n47; // (signal)
  /* TG68K_FPU_Transcendental.vhd:139:16  */
  assign result_sign = n2479; // (signal)
  /* TG68K_FPU_Transcendental.vhd:140:16  */
  assign result_exp = n2483; // (signal)
  /* TG68K_FPU_Transcendental.vhd:141:16  */
  assign result_mant = n2487; // (signal)
  /* TG68K_FPU_Transcendental.vhd:145:16  */
  assign series_term = n2495; // (signal)
  /* TG68K_FPU_Transcendental.vhd:146:16  */
  assign series_sum = n2499; // (signal)
  /* TG68K_FPU_Transcendental.vhd:147:16  */
  assign iteration_count = n2503; // (signal)
  /* TG68K_FPU_Transcendental.vhd:150:16  */
  assign trans_overflow = n2505; // (signal)
  /* TG68K_FPU_Transcendental.vhd:151:16  */
  assign trans_underflow = n2507; // (signal)
  /* TG68K_FPU_Transcendental.vhd:152:16  */
  assign trans_inexact = n2509; // (signal)
  /* TG68K_FPU_Transcendental.vhd:153:16  */
  assign trans_invalid = n2511; // (signal)
  /* TG68K_FPU_Transcendental.vhd:157:16  */
  assign exp_argument = n2519; // (signal)
  /* TG68K_FPU_Transcendental.vhd:158:16  */
  assign log_argument = n2523; // (signal)
  /* TG68K_FPU_Transcendental.vhd:162:16  */
  assign x_squared = n2528; // (signal)
  /* TG68K_FPU_Transcendental.vhd:163:16  */
  assign x_cubed = n2532; // (signal)
  /* TG68K_FPU_Transcendental.vhd:164:16  */
  assign x_fifth = n2536; // (signal)
  /* TG68K_FPU_Transcendental.vhd:165:16  */
  assign x3_div6 = n2540; // (signal)
  /* TG68K_FPU_Transcendental.vhd:168:16  */
  assign cordic_shift_x = n2544; // (signal)
  /* TG68K_FPU_Transcendental.vhd:169:16  */
  assign cordic_shift_y = n2548; // (signal)
  /* TG68K_FPU_Transcendental.vhd:170:16  */
  assign cordic_atan_val = n2552; // (signal)
  /* TG68K_FPU_Transcendental.vhd:171:16  */
  assign x5_div120 = n2556; // (signal)
  /* TG68K_FPU_Transcendental.vhd:175:16  */
  assign x_n = n2561; // (signal)
  /* TG68K_FPU_Transcendental.vhd:176:16  */
  assign a_div_x_n = n2565; // (signal)
  /* TG68K_FPU_Transcendental.vhd:177:16  */
  assign x_next = n2569; // (signal)
  /* TG68K_FPU_Transcendental.vhd:178:16  */
  assign final_mant = n2573; // (signal)
  /* TG68K_FPU_Transcendental.vhd:185:38  */
  assign n10 = operand[79]; // extract
  /* TG68K_FPU_Transcendental.vhd:186:37  */
  assign n11 = operand[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:187:38  */
  assign n12 = operand[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:190:27  */
  assign n13 = operand[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:190:42  */
  assign n15 = n13 == 15'b000000000000000;
  /* TG68K_FPU_Transcendental.vhd:190:73  */
  assign n16 = operand[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:190:87  */
  assign n18 = n16 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:190:62  */
  assign n19 = n18 & n15;
  /* TG68K_FPU_Transcendental.vhd:190:17  */
  assign n22 = n19 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:196:27  */
  assign n23 = operand[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:196:42  */
  assign n25 = n23 == 15'b111111111111111;
  /* TG68K_FPU_Transcendental.vhd:196:73  */
  assign n26 = operand[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:196:62  */
  assign n27 = n26 & n25;
  /* TG68K_FPU_Transcendental.vhd:196:95  */
  assign n28 = operand[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:196:109  */
  assign n30 = n28 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:196:84  */
  assign n31 = n30 & n27;
  /* TG68K_FPU_Transcendental.vhd:196:17  */
  assign n34 = n31 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:202:27  */
  assign n35 = operand[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:202:42  */
  assign n37 = n35 == 15'b111111111111111;
  /* TG68K_FPU_Transcendental.vhd:202:78  */
  assign n38 = operand[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:202:100  */
  assign n39 = operand[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:202:114  */
  assign n41 = n39 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:202:89  */
  assign n42 = n41 & n38;
  /* TG68K_FPU_Transcendental.vhd:202:66  */
  assign n43 = ~n42;
  /* TG68K_FPU_Transcendental.vhd:202:62  */
  assign n44 = n43 & n37;
  /* TG68K_FPU_Transcendental.vhd:202:17  */
  assign n47 = n44 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:219:27  */
  assign n50 = ~nReset;
  /* TG68K_FPU_Transcendental.vhd:242:49  */
  assign n54 = start_operation ? 1'b1 : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:242:49  */
  assign n57 = start_operation ? 3'b001 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:242:49  */
  assign n61 = start_operation ? 4'b0000 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:233:41  */
  assign n63 = trans_state == 3'b000;
  /* TG68K_FPU_Transcendental.vhd:260:65  */
  assign n65 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:260:78  */
  assign n67 = operation_code == 7'b0011101;
  /* TG68K_FPU_Transcendental.vhd:260:78  */
  assign n68 = n65 | n67;
  /* TG68K_FPU_Transcendental.vhd:260:88  */
  assign n70 = operation_code == 7'b0001111;
  /* TG68K_FPU_Transcendental.vhd:260:88  */
  assign n71 = n68 | n70;
  /* TG68K_FPU_Transcendental.vhd:267:87  */
  assign n72 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:267:73  */
  assign n75 = n72 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : 64'b1100000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:267:73  */
  assign n77 = n72 ? trans_invalid : 1'b1;
  /* TG68K_FPU_Transcendental.vhd:266:65  */
  assign n79 = operation_code == 7'b0000100;
  assign n80 = {n79, n71};
  /* TG68K_FPU_Transcendental.vhd:259:57  */
  always @*
    case (n80)
      2'b10: n83 = 1'b0;
      2'b01: n83 = 1'b0;
      default: n83 = input_sign;
    endcase
  /* TG68K_FPU_Transcendental.vhd:259:57  */
  always @*
    case (n80)
      2'b10: n86 = 15'b111111111111111;
      2'b01: n86 = 15'b111111111111111;
      default: n86 = input_exp;
    endcase
  /* TG68K_FPU_Transcendental.vhd:259:57  */
  always @*
    case (n80)
      2'b10: n88 = n75;
      2'b01: n88 = 64'b1100000000000000000000000000000000000000000000000000000000000000;
      default: n88 = input_mant;
    endcase
  /* TG68K_FPU_Transcendental.vhd:259:57  */
  always @*
    case (n80)
      2'b10: n90 = n77;
      2'b01: n90 = 1'b1;
      default: n90 = trans_invalid;
    endcase
  /* TG68K_FPU_Transcendental.vhd:257:49  */
  assign n93 = input_inf ? 3'b111 : 3'b010;
  /* TG68K_FPU_Transcendental.vhd:257:49  */
  assign n94 = input_inf ? n83 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:257:49  */
  assign n95 = input_inf ? n86 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:257:49  */
  assign n96 = input_inf ? n88 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:257:49  */
  assign n97 = input_inf ? n90 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:251:49  */
  assign n99 = input_nan ? 3'b111 : n93;
  /* TG68K_FPU_Transcendental.vhd:251:49  */
  assign n100 = input_nan ? input_sign : n94;
  /* TG68K_FPU_Transcendental.vhd:251:49  */
  assign n102 = input_nan ? 15'b111111111111111 : n95;
  /* TG68K_FPU_Transcendental.vhd:251:49  */
  assign n103 = input_nan ? input_mant : n96;
  /* TG68K_FPU_Transcendental.vhd:251:49  */
  assign n104 = input_nan ? trans_invalid : n97;
  /* TG68K_FPU_Transcendental.vhd:249:41  */
  assign n106 = trans_state == 3'b001;
  /* TG68K_FPU_Transcendental.vhd:294:100  */
  assign n107 = ~input_zero;
  /* TG68K_FPU_Transcendental.vhd:294:85  */
  assign n108 = n107 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:301:65  */
  assign n111 = input_zero ? 3'b111 : 3'b011;
  /* TG68K_FPU_Transcendental.vhd:301:65  */
  assign n112 = input_zero ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:301:65  */
  assign n114 = input_zero ? 15'b000000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:301:65  */
  assign n116 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:294:65  */
  assign n118 = n108 ? 3'b111 : n111;
  /* TG68K_FPU_Transcendental.vhd:294:65  */
  assign n120 = n108 ? 1'b0 : n112;
  /* TG68K_FPU_Transcendental.vhd:294:65  */
  assign n122 = n108 ? 15'b111111111111111 : n114;
  /* TG68K_FPU_Transcendental.vhd:294:65  */
  assign n124 = n108 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n116;
  /* TG68K_FPU_Transcendental.vhd:294:65  */
  assign n126 = n108 ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:293:57  */
  assign n128 = operation_code == 7'b0000100;
  /* TG68K_FPU_Transcendental.vhd:314:91  */
  assign n130 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:314:119  */
  assign n132 = operation_code == 7'b0001111;
  /* TG68K_FPU_Transcendental.vhd:314:101  */
  assign n133 = n130 | n132;
  /* TG68K_FPU_Transcendental.vhd:314:73  */
  assign n135 = n133 ? input_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:314:73  */
  assign n138 = n133 ? 15'b000000000000000 : 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:314:73  */
  assign n141 = n133 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:312:65  */
  assign n144 = input_zero ? 3'b111 : 3'b011;
  /* TG68K_FPU_Transcendental.vhd:312:65  */
  assign n145 = input_zero ? n135 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:312:65  */
  assign n146 = input_zero ? n138 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:312:65  */
  assign n147 = input_zero ? n141 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:311:57  */
  assign n150 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:311:70  */
  assign n152 = operation_code == 7'b0011101;
  /* TG68K_FPU_Transcendental.vhd:311:70  */
  assign n153 = n150 | n152;
  /* TG68K_FPU_Transcendental.vhd:311:80  */
  assign n155 = operation_code == 7'b0001111;
  /* TG68K_FPU_Transcendental.vhd:311:80  */
  assign n156 = n153 | n155;
  /* TG68K_FPU_Transcendental.vhd:338:65  */
  assign n159 = input_zero ? 3'b111 : 3'b011;
  /* TG68K_FPU_Transcendental.vhd:338:65  */
  assign n161 = input_zero ? 1'b1 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:338:65  */
  assign n163 = input_zero ? 15'b111111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:338:65  */
  assign n165 = input_zero ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:338:65  */
  assign n166 = input_zero ? log_argument : operand;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n168 = input_sign ? 3'b111 : n159;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n170 = input_sign ? 1'b0 : n161;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n172 = input_sign ? 15'b111111111111111 : n163;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n174 = input_sign ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n165;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n176 = input_sign ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:331:65  */
  assign n177 = input_sign ? log_argument : n166;
  /* TG68K_FPU_Transcendental.vhd:330:57  */
  assign n179 = operation_code == 7'b0010100;
  /* TG68K_FPU_Transcendental.vhd:330:71  */
  assign n181 = operation_code == 7'b0010110;
  /* TG68K_FPU_Transcendental.vhd:330:71  */
  assign n182 = n179 | n181;
  /* TG68K_FPU_Transcendental.vhd:330:82  */
  assign n184 = operation_code == 7'b0010101;
  /* TG68K_FPU_Transcendental.vhd:330:82  */
  assign n185 = n182 | n184;
  assign n186 = {n185, n156, n128};
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n188 = n168;
      3'b010: n188 = n144;
      3'b001: n188 = n118;
      default: n188 = 3'b011;
    endcase
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n189 = n170;
      3'b010: n189 = n145;
      3'b001: n189 = n120;
      default: n189 = result_sign;
    endcase
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n190 = n172;
      3'b010: n190 = n146;
      3'b001: n190 = n122;
      default: n190 = result_exp;
    endcase
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n191 = n174;
      3'b010: n191 = n147;
      3'b001: n191 = n124;
      default: n191 = result_mant;
    endcase
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n192 = n176;
      3'b010: n192 = trans_invalid;
      3'b001: n192 = n126;
      default: n192 = trans_invalid;
    endcase
  /* TG68K_FPU_Transcendental.vhd:292:49  */
  always @*
    case (n186)
      3'b100: n194 = n177;
      3'b010: n194 = log_argument;
      3'b001: n194 = log_argument;
      default: n194 = log_argument;
    endcase
  /* TG68K_FPU_Transcendental.vhd:290:41  */
  assign n196 = trans_state == 3'b010;
  /* TG68K_FPU_Transcendental.vhd:359:84  */
  assign n197 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:359:84  */
  assign n199 = n197 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:362:85  */
  assign n200 = input_exp[0]; // extract
  /* TG68K_FPU_Transcendental.vhd:362:89  */
  assign n201 = ~n200;
  /* TG68K_FPU_Transcendental.vhd:364:144  */
  assign n203 = input_exp - 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:364:112  */
  assign n205 = n203 >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:364:156  */
  assign n207 = n205 + 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:367:144  */
  assign n209 = input_exp - 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:367:152  */
  assign n211 = n209 + 15'b000000000000001;
  /* TG68K_FPU_Transcendental.vhd:367:112  */
  assign n213 = n211 >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:367:160  */
  assign n215 = n213 + 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:362:73  */
  assign n216 = n201 ? n207 : n215;
  /* TG68K_FPU_Transcendental.vhd:371:108  */
  assign n217 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:371:108  */
  assign n219 = n217 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:371:92  */
  assign n220 = n219[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:372:87  */
  assign n221 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:372:87  */
  assign n223 = $signed(n221) < $signed(32'b00000000000000000000000000001000);
  /* TG68K_FPU_Transcendental.vhd:375:88  */
  assign n224 = x_n[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:375:104  */
  assign n226 = $unsigned(n224) > $unsigned(16'b0000000000000000);
  /* TG68K_FPU_Transcendental.vhd:378:115  */
  assign n227 = input_mant[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:378:131  */
  assign n228 = {16'b0, n227};  //  uext
  /* TG68K_FPU_Transcendental.vhd:378:131  */
  assign n230 = $signed(n228) * $signed(32'b00000000000000010000000000000000); // smul
  /* TG68K_FPU_Transcendental.vhd:378:153  */
  assign n231 = x_n[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:378:139  */
  assign n232 = {16'b0, n231};  //  uext
  /* TG68K_FPU_Transcendental.vhd:378:139  */
  assign n233 = n230 / n232; // udiv
  /* TG68K_FPU_Transcendental.vhd:378:89  */
  assign n234 = {32'b0, n233};  //  uext
  /* TG68K_FPU_Transcendental.vhd:375:73  */
  assign n235 = n226 ? n234 : input_mant;
  /* TG68K_FPU_Transcendental.vhd:385:126  */
  assign n236 = x_n + a_div_x_n;
  /* TG68K_FPU_Transcendental.vhd:385:100  */
  assign n238 = n236 >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:387:108  */
  assign n239 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:387:108  */
  assign n241 = n239 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:387:92  */
  assign n242 = n241[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:394:85  */
  assign n243 = input_exp[0]; // extract
  /* TG68K_FPU_Transcendental.vhd:399:89  */
  assign n245 = x_n >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:398:103  */
  assign n246 = x_n + n245;
  /* TG68K_FPU_Transcendental.vhd:400:89  */
  assign n248 = x_n >> 31'b0000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:399:119  */
  assign n249 = n246 + n248;
  /* TG68K_FPU_Transcendental.vhd:401:89  */
  assign n251 = x_n >> 31'b0000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:400:119  */
  assign n252 = n249 - n251;
  /* TG68K_FPU_Transcendental.vhd:394:73  */
  assign n253 = n243 ? n252 : x_n;
  /* TG68K_FPU_Transcendental.vhd:409:86  */
  assign n254 = final_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:409:91  */
  assign n255 = ~n254;
  /* TG68K_FPU_Transcendental.vhd:411:106  */
  assign n256 = final_mant[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:411:120  */
  assign n258 = {n256, 1'b0};
  /* TG68K_FPU_Transcendental.vhd:412:133  */
  assign n260 = result_exp - 15'b000000000000001;
  /* TG68K_FPU_Transcendental.vhd:409:73  */
  assign n261 = n255 ? n260 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:409:73  */
  assign n262 = n255 ? n258 : final_mant;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n264 = n223 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n266 = n223 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n267 = n223 ? result_exp : n261;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n268 = n223 ? result_mant : n262;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n269 = n223 ? n242 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n271 = n223 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n272 = n223 ? x_next : x_n;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n273 = n223 ? n235 : a_div_x_n;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n274 = n223 ? n238 : x_next;
  /* TG68K_FPU_Transcendental.vhd:372:65  */
  assign n275 = n223 ? final_mant : n253;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n276 = n199 ? trans_state : n264;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n277 = n199 ? result_sign : n266;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n278 = n199 ? n216 : n267;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n279 = n199 ? result_mant : n268;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n280 = n199 ? n220 : n269;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n281 = n199 ? trans_inexact : n271;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n283 = n199 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n272;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n284 = n199 ? a_div_x_n : n273;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n285 = n199 ? x_next : n274;
  /* TG68K_FPU_Transcendental.vhd:359:65  */
  assign n286 = n199 ? final_mant : n275;
  /* TG68K_FPU_Transcendental.vhd:357:57  */
  assign n288 = operation_code == 7'b0000100;
  /* TG68K_FPU_Transcendental.vhd:422:88  */
  assign n290 = $unsigned(input_exp) < $unsigned(15'b011111111110101);
  /* TG68K_FPU_Transcendental.vhd:422:65  */
  assign n293 = n290 ? 3'b110 : 3'b101;
  /* TG68K_FPU_Transcendental.vhd:422:65  */
  assign n295 = n290 ? cordic_iteration : 5'b00000;
  /* TG68K_FPU_Transcendental.vhd:422:65  */
  assign n296 = n290 ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:422:65  */
  assign n297 = n290 ? input_exp : result_exp;
  /* TG68K_FPU_Transcendental.vhd:422:65  */
  assign n298 = n290 ? input_mant : result_mant;
  /* TG68K_FPU_Transcendental.vhd:420:57  */
  assign n300 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:436:88  */
  assign n302 = $unsigned(input_exp) < $unsigned(15'b011111111110101);
  /* TG68K_FPU_Transcendental.vhd:436:65  */
  assign n305 = n302 ? 3'b110 : 3'b101;
  /* TG68K_FPU_Transcendental.vhd:436:65  */
  assign n307 = n302 ? cordic_iteration : 5'b00000;
  /* TG68K_FPU_Transcendental.vhd:436:65  */
  assign n309 = n302 ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:436:65  */
  assign n311 = n302 ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:436:65  */
  assign n313 = n302 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:434:57  */
  assign n315 = operation_code == 7'b0011101;
  /* TG68K_FPU_Transcendental.vhd:450:84  */
  assign n316 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:450:84  */
  assign n318 = n316 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:452:96  */
  assign n320 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:452:135  */
  assign n321 = input_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:452:121  */
  assign n322 = n321 & n320;
  /* TG68K_FPU_Transcendental.vhd:452:160  */
  assign n323 = input_mant[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:452:174  */
  assign n325 = n323 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:452:146  */
  assign n326 = n325 & n322;
  /* TG68K_FPU_Transcendental.vhd:460:116  */
  assign n327 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:460:116  */
  assign n329 = n327 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:460:100  */
  assign n330 = n329[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n332 = n326 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n334 = n326 ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n336 = n326 ? 15'b000000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n338 = n326 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n339 = n326 ? iteration_count : n330;
  /* TG68K_FPU_Transcendental.vhd:452:73  */
  assign n340 = n326 ? log_argument : operand;
  /* TG68K_FPU_Transcendental.vhd:462:87  */
  assign n341 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:462:87  */
  assign n343 = $signed(n341) <= $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:465:92  */
  assign n344 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:465:92  */
  assign n346 = n344 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:467:104  */
  assign n348 = $unsigned(input_exp) >= $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:470:125  */
  assign n350 = input_exp - 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:470:134  */
  assign n351 = {16'b0, n350};  //  uext
  /* TG68K_FPU_Transcendental.vhd:470:134  */
  assign n354 = n351 * 31'b0000000000000001011000101110010; // umul
  /* TG68K_FPU_Transcendental.vhd:470:97  */
  assign n355 = {49'b0, n354};  //  uext
  /* TG68K_FPU_Transcendental.vhd:475:119  */
  assign n357 = 15'b011111111111111 - input_exp;
  /* TG68K_FPU_Transcendental.vhd:475:142  */
  assign n358 = {16'b0, n357};  //  uext
  /* TG68K_FPU_Transcendental.vhd:475:142  */
  assign n361 = n358 * 31'b0000000000000001011000101110010; // umul
  /* TG68K_FPU_Transcendental.vhd:475:104  */
  assign n362 = -n361;
  /* TG68K_FPU_Transcendental.vhd:475:97  */
  assign n363 = {{49{n362[30]}}, n362}; // sext
  /* TG68K_FPU_Transcendental.vhd:467:81  */
  assign n364 = n348 ? n355 : n363;
  /* TG68K_FPU_Transcendental.vhd:478:95  */
  assign n365 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:478:95  */
  assign n367 = $signed(n365) <= $signed(32'b00000000000000000000000000000100);
  /* TG68K_FPU_Transcendental.vhd:482:94  */
  assign n368 = input_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:484:147  */
  assign n369 = input_mant[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:484:121  */
  assign n370 = {17'b0, n369};  //  uext
  /* TG68K_FPU_Transcendental.vhd:486:141  */
  assign n371 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:478:73  */
  assign n372 = n374 ? n370 : series_term;
  /* TG68K_FPU_Transcendental.vhd:478:73  */
  assign n373 = n375 ? n371 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:478:73  */
  assign n374 = n368 & n367;
  /* TG68K_FPU_Transcendental.vhd:478:73  */
  assign n375 = n368 & n367;
  /* TG68K_FPU_Transcendental.vhd:465:73  */
  assign n376 = n346 ? series_term : n372;
  /* TG68K_FPU_Transcendental.vhd:465:73  */
  assign n377 = n346 ? n364 : n373;
  /* TG68K_FPU_Transcendental.vhd:492:108  */
  assign n378 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:492:108  */
  assign n380 = n378 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:492:92  */
  assign n381 = n380[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:496:95  */
  assign n382 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:496:111  */
  assign n384 = n382 == 15'b000000000000000;
  /* TG68K_FPU_Transcendental.vhd:496:129  */
  assign n385 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:496:143  */
  assign n387 = n385 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:496:115  */
  assign n388 = n387 & n384;
  /* TG68K_FPU_Transcendental.vhd:503:106  */
  assign n389 = series_sum[79]; // extract
  /* TG68K_FPU_Transcendental.vhd:504:105  */
  assign n390 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:505:106  */
  assign n391 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:496:73  */
  assign n393 = n388 ? 1'b0 : n389;
  /* TG68K_FPU_Transcendental.vhd:496:73  */
  assign n395 = n388 ? 15'b000000000000000 : n390;
  /* TG68K_FPU_Transcendental.vhd:496:73  */
  assign n397 = n388 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n391;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n399 = n343 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n400 = n343 ? result_sign : n393;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n401 = n343 ? result_exp : n395;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n402 = n343 ? result_mant : n397;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n403 = n343 ? n376 : series_term;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n404 = n343 ? n377 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n405 = n343 ? n381 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:462:65  */
  assign n407 = n343 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n408 = n318 ? n332 : n399;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n409 = n318 ? n334 : n400;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n410 = n318 ? n336 : n401;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n411 = n318 ? n338 : n402;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n412 = n318 ? series_term : n403;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n413 = n318 ? series_sum : n404;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n414 = n318 ? n339 : n405;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n415 = n318 ? trans_inexact : n407;
  /* TG68K_FPU_Transcendental.vhd:450:65  */
  assign n416 = n318 ? n340 : log_argument;
  /* TG68K_FPU_Transcendental.vhd:448:57  */
  assign n418 = operation_code == 7'b0010100;
  /* TG68K_FPU_Transcendental.vhd:512:84  */
  assign n419 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:512:84  */
  assign n421 = $signed(n419) < $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:513:108  */
  assign n422 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:513:108  */
  assign n424 = n422 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:513:92  */
  assign n425 = n424[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:517:96  */
  assign n427 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:517:135  */
  assign n428 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:517:150  */
  assign n430 = n428 == 32'b10000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:517:121  */
  assign n431 = n430 & n427;
  /* TG68K_FPU_Transcendental.vhd:526:140  */
  assign n433 = input_exp - 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:526:113  */
  assign n434 = {49'b0, n433};  //  uext
  /* TG68K_FPU_Transcendental.vhd:517:73  */
  assign n437 = n431 ? 15'b000000000000000 : 15'b011111111111101;
  /* TG68K_FPU_Transcendental.vhd:517:73  */
  assign n439 = n431 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n434;
  /* TG68K_FPU_Transcendental.vhd:512:65  */
  assign n441 = n421 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:512:65  */
  assign n443 = n421 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:512:65  */
  assign n444 = n421 ? result_exp : n437;
  /* TG68K_FPU_Transcendental.vhd:512:65  */
  assign n445 = n421 ? result_mant : n439;
  /* TG68K_FPU_Transcendental.vhd:512:65  */
  assign n446 = n421 ? n425 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:510:57  */
  assign n448 = operation_code == 7'b0010101;
  /* TG68K_FPU_Transcendental.vhd:534:84  */
  assign n449 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:534:84  */
  assign n451 = $signed(n449) < $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:535:108  */
  assign n452 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:535:108  */
  assign n454 = n452 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:535:92  */
  assign n455 = n454[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:539:96  */
  assign n457 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:539:135  */
  assign n458 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:539:150  */
  assign n460 = n458 == 32'b10000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:539:121  */
  assign n461 = n460 & n457;
  /* TG68K_FPU_Transcendental.vhd:548:140  */
  assign n463 = input_exp - 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:548:113  */
  assign n464 = {49'b0, n463};  //  uext
  /* TG68K_FPU_Transcendental.vhd:539:73  */
  assign n467 = n461 ? 15'b000000000000000 : 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:539:73  */
  assign n469 = n461 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n464;
  /* TG68K_FPU_Transcendental.vhd:534:65  */
  assign n471 = n451 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:534:65  */
  assign n473 = n451 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:534:65  */
  assign n474 = n451 ? result_exp : n467;
  /* TG68K_FPU_Transcendental.vhd:534:65  */
  assign n475 = n451 ? result_mant : n469;
  /* TG68K_FPU_Transcendental.vhd:534:65  */
  assign n476 = n451 ? n455 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:532:57  */
  assign n478 = operation_code == 7'b0010110;
  /* TG68K_FPU_Transcendental.vhd:557:84  */
  assign n479 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:557:84  */
  assign n481 = n479 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:568:116  */
  assign n482 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:568:116  */
  assign n484 = n482 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:568:100  */
  assign n485 = n484[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n487 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n488 = input_zero ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n490 = input_zero ? 15'b000000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n492 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n493 = input_zero ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:559:73  */
  assign n494 = input_zero ? iteration_count : n485;
  /* TG68K_FPU_Transcendental.vhd:570:87  */
  assign n495 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:570:87  */
  assign n497 = $signed(n495) <= $signed(32'b00000000000000000000000000001000);
  /* TG68K_FPU_Transcendental.vhd:572:92  */
  assign n498 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:572:92  */
  assign n500 = n498 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:575:115  */
  assign n501 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:575:152  */
  assign n502 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:575:131  */
  assign n503 = {32'b0, n501};  //  uext
  /* TG68K_FPU_Transcendental.vhd:575:131  */
  assign n504 = {32'b0, n502};  //  uext
  /* TG68K_FPU_Transcendental.vhd:575:131  */
  assign n505 = n503 * n504; // umul
  /* TG68K_FPU_Transcendental.vhd:575:89  */
  assign n506 = {64'b0, n505};  //  uext
  /* TG68K_FPU_Transcendental.vhd:577:95  */
  assign n507 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:577:95  */
  assign n509 = n507 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:580:114  */
  assign n510 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:580:152  */
  assign n511 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:580:131  */
  assign n512 = {32'b0, n510};  //  uext
  /* TG68K_FPU_Transcendental.vhd:580:131  */
  assign n513 = {32'b0, n511};  //  uext
  /* TG68K_FPU_Transcendental.vhd:580:131  */
  assign n514 = n512 * n513; // umul
  /* TG68K_FPU_Transcendental.vhd:580:89  */
  assign n515 = {64'b0, n514};  //  uext
  /* TG68K_FPU_Transcendental.vhd:582:95  */
  assign n516 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:582:95  */
  assign n518 = n516 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:584:132  */
  assign n519 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:584:149  */
  assign n521 = n519 / 32'b00000000000000000000000000000011; // udiv
  /* TG68K_FPU_Transcendental.vhd:584:109  */
  assign n522 = {32'b0, n521};  //  uext
  /* TG68K_FPU_Transcendental.vhd:585:95  */
  assign n523 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:585:95  */
  assign n525 = n523 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:588:89  */
  assign n526 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:587:133  */
  assign n527 = series_sum + n526;
  /* TG68K_FPU_Transcendental.vhd:589:95  */
  assign n528 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:589:95  */
  assign n530 = n528 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:592:112  */
  assign n531 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:592:149  */
  assign n532 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:592:129  */
  assign n533 = {32'b0, n531};  //  uext
  /* TG68K_FPU_Transcendental.vhd:592:129  */
  assign n534 = {32'b0, n532};  //  uext
  /* TG68K_FPU_Transcendental.vhd:592:129  */
  assign n535 = n533 * n534; // umul
  /* TG68K_FPU_Transcendental.vhd:592:89  */
  assign n536 = {64'b0, n535};  //  uext
  /* TG68K_FPU_Transcendental.vhd:594:95  */
  assign n537 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:594:95  */
  assign n539 = n537 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:596:146  */
  assign n540 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:596:163  */
  assign n541 = {64'b0, n540};  //  uext
  /* TG68K_FPU_Transcendental.vhd:596:163  */
  assign n543 = $signed(n541) * $signed(128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010); // smul
  /* TG68K_FPU_Transcendental.vhd:596:118  */
  assign n545 = n543 >> 31'b0000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:596:111  */
  assign n546 = n545[63:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:597:95  */
  assign n547 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:597:95  */
  assign n549 = n547 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:600:89  */
  assign n550 = {16'b0, x5_div120};  //  uext
  /* TG68K_FPU_Transcendental.vhd:599:133  */
  assign n551 = series_sum + n550;
  /* TG68K_FPU_Transcendental.vhd:597:73  */
  assign n552 = n549 ? n551 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:594:73  */
  assign n553 = n539 ? series_sum : n552;
  /* TG68K_FPU_Transcendental.vhd:594:73  */
  assign n554 = n539 ? n546 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:589:73  */
  assign n555 = n530 ? series_sum : n553;
  /* TG68K_FPU_Transcendental.vhd:589:73  */
  assign n556 = n530 ? n536 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:589:73  */
  assign n557 = n530 ? x5_div120 : n554;
  /* TG68K_FPU_Transcendental.vhd:585:73  */
  assign n558 = n525 ? n527 : n555;
  /* TG68K_FPU_Transcendental.vhd:585:73  */
  assign n559 = n525 ? x_fifth : n556;
  /* TG68K_FPU_Transcendental.vhd:585:73  */
  assign n560 = n525 ? x5_div120 : n557;
  /* TG68K_FPU_Transcendental.vhd:582:73  */
  assign n561 = n518 ? series_sum : n558;
  /* TG68K_FPU_Transcendental.vhd:582:73  */
  assign n562 = n518 ? x_fifth : n559;
  /* TG68K_FPU_Transcendental.vhd:582:73  */
  assign n563 = n518 ? n522 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:582:73  */
  assign n564 = n518 ? x5_div120 : n560;
  /* TG68K_FPU_Transcendental.vhd:577:73  */
  assign n565 = n509 ? series_sum : n561;
  /* TG68K_FPU_Transcendental.vhd:577:73  */
  assign n566 = n509 ? n515 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:577:73  */
  assign n567 = n509 ? x_fifth : n562;
  /* TG68K_FPU_Transcendental.vhd:577:73  */
  assign n568 = n509 ? x3_div6 : n563;
  /* TG68K_FPU_Transcendental.vhd:577:73  */
  assign n569 = n509 ? x5_div120 : n564;
  /* TG68K_FPU_Transcendental.vhd:572:73  */
  assign n570 = n500 ? series_sum : n565;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n571 = n598 ? n506 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:572:73  */
  assign n572 = n500 ? x_cubed : n566;
  /* TG68K_FPU_Transcendental.vhd:572:73  */
  assign n573 = n500 ? x_fifth : n567;
  /* TG68K_FPU_Transcendental.vhd:572:73  */
  assign n574 = n500 ? x3_div6 : n568;
  /* TG68K_FPU_Transcendental.vhd:572:73  */
  assign n575 = n500 ? x5_div120 : n569;
  /* TG68K_FPU_Transcendental.vhd:602:108  */
  assign n576 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:602:108  */
  assign n578 = n576 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:602:92  */
  assign n579 = n578[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:608:95  */
  assign n580 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:608:111  */
  assign n582 = $unsigned(n580) > $unsigned(15'b100000000001001);
  /* TG68K_FPU_Transcendental.vhd:613:105  */
  assign n583 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:614:106  */
  assign n584 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:608:73  */
  assign n586 = n582 ? 15'b100000000001001 : n583;
  /* TG68K_FPU_Transcendental.vhd:608:73  */
  assign n588 = n582 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n584;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n590 = n497 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n591 = n497 ? result_sign : input_sign;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n592 = n497 ? result_exp : n586;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n593 = n497 ? result_mant : n588;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n594 = n497 ? n570 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n595 = n497 ? n579 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n597 = n497 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n598 = n500 & n497;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n599 = n497 ? n572 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n600 = n497 ? n573 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n601 = n497 ? n574 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:570:65  */
  assign n602 = n497 ? n575 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n603 = n481 ? n487 : n590;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n604 = n481 ? n488 : n591;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n605 = n481 ? n490 : n592;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n606 = n481 ? n492 : n593;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n607 = n481 ? n493 : n594;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n608 = n481 ? n494 : n595;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n609 = n481 ? trans_inexact : n597;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n610 = n481 ? x_squared : n571;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n611 = n481 ? x_cubed : n599;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n612 = n481 ? x_fifth : n600;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n613 = n481 ? x3_div6 : n601;
  /* TG68K_FPU_Transcendental.vhd:557:65  */
  assign n614 = n481 ? x5_div120 : n602;
  /* TG68K_FPU_Transcendental.vhd:554:57  */
  assign n616 = operation_code == 7'b0001111;
  /* TG68K_FPU_Transcendental.vhd:622:84  */
  assign n617 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:622:84  */
  assign n619 = n617 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:632:116  */
  assign n620 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:632:116  */
  assign n622 = n620 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:632:100  */
  assign n623 = n622[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n625 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n626 = input_zero ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n628 = input_zero ? 15'b000000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n630 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n631 = input_zero ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:623:73  */
  assign n632 = input_zero ? iteration_count : n623;
  /* TG68K_FPU_Transcendental.vhd:634:87  */
  assign n633 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:634:87  */
  assign n635 = $signed(n633) <= $signed(32'b00000000000000000000000000000111);
  /* TG68K_FPU_Transcendental.vhd:636:92  */
  assign n636 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:636:92  */
  assign n638 = n636 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:639:115  */
  assign n639 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:639:152  */
  assign n640 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:639:131  */
  assign n641 = {32'b0, n639};  //  uext
  /* TG68K_FPU_Transcendental.vhd:639:131  */
  assign n642 = {32'b0, n640};  //  uext
  /* TG68K_FPU_Transcendental.vhd:639:131  */
  assign n643 = n641 * n642; // umul
  /* TG68K_FPU_Transcendental.vhd:639:89  */
  assign n644 = {64'b0, n643};  //  uext
  /* TG68K_FPU_Transcendental.vhd:641:95  */
  assign n645 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:641:95  */
  assign n647 = n645 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:644:114  */
  assign n648 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:644:152  */
  assign n649 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:644:131  */
  assign n650 = {32'b0, n648};  //  uext
  /* TG68K_FPU_Transcendental.vhd:644:131  */
  assign n651 = {32'b0, n649};  //  uext
  /* TG68K_FPU_Transcendental.vhd:644:131  */
  assign n652 = n650 * n651; // umul
  /* TG68K_FPU_Transcendental.vhd:644:89  */
  assign n653 = {64'b0, n652};  //  uext
  /* TG68K_FPU_Transcendental.vhd:646:95  */
  assign n654 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:646:95  */
  assign n656 = n654 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:648:132  */
  assign n657 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:648:149  */
  assign n659 = n657 / 32'b00000000000000000000000000000110; // udiv
  /* TG68K_FPU_Transcendental.vhd:648:109  */
  assign n660 = {32'b0, n659};  //  uext
  /* TG68K_FPU_Transcendental.vhd:649:95  */
  assign n661 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:649:95  */
  assign n663 = n661 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:652:89  */
  assign n664 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:651:133  */
  assign n665 = series_sum + n664;
  /* TG68K_FPU_Transcendental.vhd:653:95  */
  assign n666 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:653:95  */
  assign n668 = n666 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:656:112  */
  assign n669 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:656:149  */
  assign n670 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:656:129  */
  assign n671 = {32'b0, n669};  //  uext
  /* TG68K_FPU_Transcendental.vhd:656:129  */
  assign n672 = {32'b0, n670};  //  uext
  /* TG68K_FPU_Transcendental.vhd:656:129  */
  assign n673 = n671 * n672; // umul
  /* TG68K_FPU_Transcendental.vhd:656:89  */
  assign n674 = {64'b0, n673};  //  uext
  /* TG68K_FPU_Transcendental.vhd:658:95  */
  assign n675 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:658:95  */
  assign n677 = n675 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:660:139  */
  assign n678 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:660:111  */
  assign n680 = n678 >> 31'b0000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:661:95  */
  assign n681 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:661:95  */
  assign n683 = n681 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:664:89  */
  assign n684 = {16'b0, x5_div120};  //  uext
  /* TG68K_FPU_Transcendental.vhd:663:133  */
  assign n685 = series_sum + n684;
  /* TG68K_FPU_Transcendental.vhd:661:73  */
  assign n686 = n683 ? n685 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:658:73  */
  assign n687 = n677 ? series_sum : n686;
  /* TG68K_FPU_Transcendental.vhd:658:73  */
  assign n688 = n677 ? n680 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:653:73  */
  assign n689 = n668 ? series_sum : n687;
  /* TG68K_FPU_Transcendental.vhd:653:73  */
  assign n690 = n668 ? n674 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:653:73  */
  assign n691 = n668 ? x5_div120 : n688;
  /* TG68K_FPU_Transcendental.vhd:649:73  */
  assign n692 = n663 ? n665 : n689;
  /* TG68K_FPU_Transcendental.vhd:649:73  */
  assign n693 = n663 ? x_fifth : n690;
  /* TG68K_FPU_Transcendental.vhd:649:73  */
  assign n694 = n663 ? x5_div120 : n691;
  /* TG68K_FPU_Transcendental.vhd:646:73  */
  assign n695 = n656 ? series_sum : n692;
  /* TG68K_FPU_Transcendental.vhd:646:73  */
  assign n696 = n656 ? x_fifth : n693;
  /* TG68K_FPU_Transcendental.vhd:646:73  */
  assign n697 = n656 ? n660 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:646:73  */
  assign n698 = n656 ? x5_div120 : n694;
  /* TG68K_FPU_Transcendental.vhd:641:73  */
  assign n699 = n647 ? series_sum : n695;
  /* TG68K_FPU_Transcendental.vhd:641:73  */
  assign n700 = n647 ? n653 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:641:73  */
  assign n701 = n647 ? x_fifth : n696;
  /* TG68K_FPU_Transcendental.vhd:641:73  */
  assign n702 = n647 ? x3_div6 : n697;
  /* TG68K_FPU_Transcendental.vhd:641:73  */
  assign n703 = n647 ? x5_div120 : n698;
  /* TG68K_FPU_Transcendental.vhd:636:73  */
  assign n704 = n638 ? series_sum : n699;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n705 = n731 ? n644 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:636:73  */
  assign n706 = n638 ? x_cubed : n700;
  /* TG68K_FPU_Transcendental.vhd:636:73  */
  assign n707 = n638 ? x_fifth : n701;
  /* TG68K_FPU_Transcendental.vhd:636:73  */
  assign n708 = n638 ? x3_div6 : n702;
  /* TG68K_FPU_Transcendental.vhd:636:73  */
  assign n709 = n638 ? x5_div120 : n703;
  /* TG68K_FPU_Transcendental.vhd:666:108  */
  assign n710 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:666:108  */
  assign n712 = n710 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:666:92  */
  assign n713 = n712[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:671:96  */
  assign n715 = $unsigned(input_exp) >= $unsigned(15'b100000000000011);
  /* TG68K_FPU_Transcendental.vhd:673:132  */
  assign n717 = input_exp + 15'b000000000000001;
  /* TG68K_FPU_Transcendental.vhd:677:105  */
  assign n718 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:678:106  */
  assign n719 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:671:73  */
  assign n720 = n715 ? n717 : n718;
  /* TG68K_FPU_Transcendental.vhd:671:73  */
  assign n721 = n715 ? input_mant : n719;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n723 = n635 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n724 = n635 ? result_sign : input_sign;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n725 = n635 ? result_exp : n720;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n726 = n635 ? result_mant : n721;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n727 = n635 ? n704 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n728 = n635 ? n713 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n730 = n635 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n731 = n638 & n635;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n732 = n635 ? n706 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n733 = n635 ? n707 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n734 = n635 ? n708 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:634:65  */
  assign n735 = n635 ? n709 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n736 = n619 ? n625 : n723;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n737 = n619 ? n626 : n724;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n738 = n619 ? n628 : n725;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n739 = n619 ? n630 : n726;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n740 = n619 ? n631 : n727;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n741 = n619 ? n632 : n728;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n742 = n619 ? trans_inexact : n730;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n743 = n619 ? x_squared : n705;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n744 = n619 ? x_cubed : n732;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n745 = n619 ? x_fifth : n733;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n746 = n619 ? x3_div6 : n734;
  /* TG68K_FPU_Transcendental.vhd:622:65  */
  assign n747 = n619 ? x5_div120 : n735;
  /* TG68K_FPU_Transcendental.vhd:619:57  */
  assign n749 = operation_code == 7'b0001011;
  /* TG68K_FPU_Transcendental.vhd:686:84  */
  assign n750 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:686:84  */
  assign n752 = n750 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:696:116  */
  assign n753 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:696:116  */
  assign n755 = n753 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:696:100  */
  assign n756 = n755[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n758 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n760 = input_zero ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n762 = input_zero ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n764 = input_zero ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n766 = input_zero ? series_sum : 80'b00111111111111111000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:687:73  */
  assign n767 = input_zero ? iteration_count : n756;
  /* TG68K_FPU_Transcendental.vhd:698:87  */
  assign n768 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:698:87  */
  assign n770 = $signed(n768) <= $signed(32'b00000000000000000000000000000111);
  /* TG68K_FPU_Transcendental.vhd:700:92  */
  assign n771 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:700:92  */
  assign n773 = n771 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:703:115  */
  assign n774 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:703:152  */
  assign n775 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:703:131  */
  assign n776 = {32'b0, n774};  //  uext
  /* TG68K_FPU_Transcendental.vhd:703:131  */
  assign n777 = {32'b0, n775};  //  uext
  /* TG68K_FPU_Transcendental.vhd:703:131  */
  assign n778 = n776 * n777; // umul
  /* TG68K_FPU_Transcendental.vhd:703:89  */
  assign n779 = {64'b0, n778};  //  uext
  /* TG68K_FPU_Transcendental.vhd:705:95  */
  assign n780 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:705:95  */
  assign n782 = n780 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:708:126  */
  assign n783 = x_squared[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:708:96  */
  assign n785 = n783 >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:708:89  */
  assign n786 = {16'b0, n785};  //  uext
  /* TG68K_FPU_Transcendental.vhd:707:133  */
  assign n787 = series_sum + n786;
  /* TG68K_FPU_Transcendental.vhd:709:95  */
  assign n788 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:709:95  */
  assign n790 = n788 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:712:114  */
  assign n791 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:712:151  */
  assign n792 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:712:131  */
  assign n793 = {32'b0, n791};  //  uext
  /* TG68K_FPU_Transcendental.vhd:712:131  */
  assign n794 = {32'b0, n792};  //  uext
  /* TG68K_FPU_Transcendental.vhd:712:131  */
  assign n795 = n793 * n794; // umul
  /* TG68K_FPU_Transcendental.vhd:712:89  */
  assign n796 = {64'b0, n795};  //  uext
  /* TG68K_FPU_Transcendental.vhd:714:95  */
  assign n797 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:714:95  */
  assign n799 = n797 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:717:124  */
  assign n800 = x_cubed[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:717:96  */
  assign n802 = n800 >> 31'b0000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:717:89  */
  assign n803 = {16'b0, n802};  //  uext
  /* TG68K_FPU_Transcendental.vhd:716:133  */
  assign n804 = series_sum + n803;
  /* TG68K_FPU_Transcendental.vhd:718:95  */
  assign n805 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:718:95  */
  assign n807 = n805 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:721:112  */
  assign n808 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:721:149  */
  assign n809 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:721:129  */
  assign n810 = {32'b0, n808};  //  uext
  /* TG68K_FPU_Transcendental.vhd:721:129  */
  assign n811 = {32'b0, n809};  //  uext
  /* TG68K_FPU_Transcendental.vhd:721:129  */
  assign n812 = n810 * n811; // umul
  /* TG68K_FPU_Transcendental.vhd:721:89  */
  assign n813 = {64'b0, n812};  //  uext
  /* TG68K_FPU_Transcendental.vhd:723:95  */
  assign n814 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:723:95  */
  assign n816 = n814 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:725:139  */
  assign n817 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:725:111  */
  assign n819 = n817 >> 31'b0000000000000000000000000001001;
  /* TG68K_FPU_Transcendental.vhd:726:95  */
  assign n820 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:726:95  */
  assign n822 = n820 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:729:89  */
  assign n823 = {16'b0, x5_div120};  //  uext
  /* TG68K_FPU_Transcendental.vhd:728:133  */
  assign n824 = series_sum + n823;
  /* TG68K_FPU_Transcendental.vhd:726:73  */
  assign n825 = n822 ? n824 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:723:73  */
  assign n826 = n816 ? series_sum : n825;
  /* TG68K_FPU_Transcendental.vhd:723:73  */
  assign n827 = n816 ? n819 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:718:73  */
  assign n828 = n807 ? series_sum : n826;
  /* TG68K_FPU_Transcendental.vhd:718:73  */
  assign n829 = n807 ? n813 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:718:73  */
  assign n830 = n807 ? x5_div120 : n827;
  /* TG68K_FPU_Transcendental.vhd:714:73  */
  assign n831 = n799 ? n804 : n828;
  /* TG68K_FPU_Transcendental.vhd:714:73  */
  assign n832 = n799 ? x_fifth : n829;
  /* TG68K_FPU_Transcendental.vhd:714:73  */
  assign n833 = n799 ? x5_div120 : n830;
  /* TG68K_FPU_Transcendental.vhd:709:73  */
  assign n834 = n790 ? series_sum : n831;
  /* TG68K_FPU_Transcendental.vhd:709:73  */
  assign n835 = n790 ? n796 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:709:73  */
  assign n836 = n790 ? x_fifth : n832;
  /* TG68K_FPU_Transcendental.vhd:709:73  */
  assign n837 = n790 ? x5_div120 : n833;
  /* TG68K_FPU_Transcendental.vhd:705:73  */
  assign n838 = n782 ? n787 : n834;
  /* TG68K_FPU_Transcendental.vhd:705:73  */
  assign n839 = n782 ? x_cubed : n835;
  /* TG68K_FPU_Transcendental.vhd:705:73  */
  assign n840 = n782 ? x_fifth : n836;
  /* TG68K_FPU_Transcendental.vhd:705:73  */
  assign n841 = n782 ? x5_div120 : n837;
  /* TG68K_FPU_Transcendental.vhd:700:73  */
  assign n842 = n773 ? series_sum : n838;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n843 = n869 ? n779 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:700:73  */
  assign n844 = n773 ? x_cubed : n839;
  /* TG68K_FPU_Transcendental.vhd:700:73  */
  assign n845 = n773 ? x_fifth : n840;
  /* TG68K_FPU_Transcendental.vhd:700:73  */
  assign n846 = n773 ? x5_div120 : n841;
  /* TG68K_FPU_Transcendental.vhd:731:108  */
  assign n847 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:731:108  */
  assign n849 = n847 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:731:92  */
  assign n850 = n849[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:736:96  */
  assign n852 = $unsigned(input_exp) >= $unsigned(15'b100000000000011);
  /* TG68K_FPU_Transcendental.vhd:738:132  */
  assign n854 = input_exp + 15'b000000000000001;
  /* TG68K_FPU_Transcendental.vhd:742:105  */
  assign n855 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:743:106  */
  assign n856 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:736:73  */
  assign n857 = n852 ? n854 : n855;
  /* TG68K_FPU_Transcendental.vhd:736:73  */
  assign n858 = n852 ? input_mant : n856;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n860 = n770 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n862 = n770 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n863 = n770 ? result_exp : n857;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n864 = n770 ? result_mant : n858;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n865 = n770 ? n842 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n866 = n770 ? n850 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n868 = n770 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n869 = n773 & n770;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n870 = n770 ? n844 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n871 = n770 ? n845 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:698:65  */
  assign n872 = n770 ? n846 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n873 = n752 ? n758 : n860;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n874 = n752 ? n760 : n862;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n875 = n752 ? n762 : n863;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n876 = n752 ? n764 : n864;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n877 = n752 ? n766 : n865;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n878 = n752 ? n767 : n866;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n879 = n752 ? trans_inexact : n868;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n880 = n752 ? x_squared : n843;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n881 = n752 ? x_cubed : n870;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n882 = n752 ? x_fifth : n871;
  /* TG68K_FPU_Transcendental.vhd:686:65  */
  assign n883 = n752 ? x5_div120 : n872;
  /* TG68K_FPU_Transcendental.vhd:683:57  */
  assign n885 = operation_code == 7'b0011001;
  /* TG68K_FPU_Transcendental.vhd:751:84  */
  assign n886 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:751:84  */
  assign n888 = n886 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:760:104  */
  assign n890 = $unsigned(input_exp) >= $unsigned(15'b100000000000010);
  /* TG68K_FPU_Transcendental.vhd:769:124  */
  assign n891 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:769:124  */
  assign n893 = n891 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:769:108  */
  assign n894 = n893[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n896 = n890 ? 3'b110 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n897 = n890 ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n899 = n890 ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n901 = n890 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n902 = n890 ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:760:81  */
  assign n903 = n890 ? iteration_count : n894;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n905 = input_zero ? 3'b111 : n896;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n906 = input_zero ? input_sign : n897;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n908 = input_zero ? 15'b000000000000000 : n899;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n910 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n901;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n911 = input_zero ? series_sum : n902;
  /* TG68K_FPU_Transcendental.vhd:752:73  */
  assign n912 = input_zero ? iteration_count : n903;
  /* TG68K_FPU_Transcendental.vhd:772:87  */
  assign n913 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:772:87  */
  assign n915 = $signed(n913) <= $signed(32'b00000000000000000000000000001000);
  /* TG68K_FPU_Transcendental.vhd:775:92  */
  assign n916 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:775:92  */
  assign n918 = n916 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:778:115  */
  assign n919 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:778:152  */
  assign n920 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:778:131  */
  assign n921 = {32'b0, n919};  //  uext
  /* TG68K_FPU_Transcendental.vhd:778:131  */
  assign n922 = {32'b0, n920};  //  uext
  /* TG68K_FPU_Transcendental.vhd:778:131  */
  assign n923 = n921 * n922; // umul
  /* TG68K_FPU_Transcendental.vhd:778:89  */
  assign n924 = {64'b0, n923};  //  uext
  /* TG68K_FPU_Transcendental.vhd:780:95  */
  assign n925 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:780:95  */
  assign n927 = n925 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:783:114  */
  assign n928 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:783:152  */
  assign n929 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:783:131  */
  assign n930 = {32'b0, n928};  //  uext
  /* TG68K_FPU_Transcendental.vhd:783:131  */
  assign n931 = {32'b0, n929};  //  uext
  /* TG68K_FPU_Transcendental.vhd:783:131  */
  assign n932 = n930 * n931; // umul
  /* TG68K_FPU_Transcendental.vhd:783:89  */
  assign n933 = {64'b0, n932};  //  uext
  /* TG68K_FPU_Transcendental.vhd:785:95  */
  assign n934 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:785:95  */
  assign n936 = n934 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:787:132  */
  assign n937 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:787:149  */
  assign n939 = n937 / 32'b00000000000000000000000000000011; // udiv
  /* TG68K_FPU_Transcendental.vhd:787:109  */
  assign n940 = {32'b0, n939};  //  uext
  /* TG68K_FPU_Transcendental.vhd:788:95  */
  assign n941 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:788:95  */
  assign n943 = n941 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:791:89  */
  assign n944 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:790:133  */
  assign n945 = series_sum - n944;
  /* TG68K_FPU_Transcendental.vhd:792:95  */
  assign n946 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:792:95  */
  assign n948 = n946 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:795:112  */
  assign n949 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:795:149  */
  assign n950 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:795:129  */
  assign n951 = {32'b0, n949};  //  uext
  /* TG68K_FPU_Transcendental.vhd:795:129  */
  assign n952 = {32'b0, n950};  //  uext
  /* TG68K_FPU_Transcendental.vhd:795:129  */
  assign n953 = n951 * n952; // umul
  /* TG68K_FPU_Transcendental.vhd:795:89  */
  assign n954 = {64'b0, n953};  //  uext
  /* TG68K_FPU_Transcendental.vhd:797:95  */
  assign n955 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:797:95  */
  assign n957 = n955 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:799:146  */
  assign n958 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:799:163  */
  assign n959 = {64'b0, n958};  //  uext
  /* TG68K_FPU_Transcendental.vhd:799:163  */
  assign n961 = $signed(n959) * $signed(128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010); // smul
  /* TG68K_FPU_Transcendental.vhd:799:118  */
  assign n963 = n961 >> 31'b0000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:799:111  */
  assign n964 = n963[63:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:800:95  */
  assign n965 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:800:95  */
  assign n967 = n965 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:803:89  */
  assign n968 = {16'b0, x5_div120};  //  uext
  /* TG68K_FPU_Transcendental.vhd:802:133  */
  assign n969 = series_sum + n968;
  /* TG68K_FPU_Transcendental.vhd:800:73  */
  assign n970 = n967 ? n969 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:797:73  */
  assign n971 = n957 ? series_sum : n970;
  /* TG68K_FPU_Transcendental.vhd:797:73  */
  assign n972 = n957 ? n964 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:792:73  */
  assign n973 = n948 ? series_sum : n971;
  /* TG68K_FPU_Transcendental.vhd:792:73  */
  assign n974 = n948 ? n954 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:792:73  */
  assign n975 = n948 ? x5_div120 : n972;
  /* TG68K_FPU_Transcendental.vhd:788:73  */
  assign n976 = n943 ? n945 : n973;
  /* TG68K_FPU_Transcendental.vhd:788:73  */
  assign n977 = n943 ? x_fifth : n974;
  /* TG68K_FPU_Transcendental.vhd:788:73  */
  assign n978 = n943 ? x5_div120 : n975;
  /* TG68K_FPU_Transcendental.vhd:785:73  */
  assign n979 = n936 ? series_sum : n976;
  /* TG68K_FPU_Transcendental.vhd:785:73  */
  assign n980 = n936 ? x_fifth : n977;
  /* TG68K_FPU_Transcendental.vhd:785:73  */
  assign n981 = n936 ? n940 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:785:73  */
  assign n982 = n936 ? x5_div120 : n978;
  /* TG68K_FPU_Transcendental.vhd:780:73  */
  assign n983 = n927 ? series_sum : n979;
  /* TG68K_FPU_Transcendental.vhd:780:73  */
  assign n984 = n927 ? n933 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:780:73  */
  assign n985 = n927 ? x_fifth : n980;
  /* TG68K_FPU_Transcendental.vhd:780:73  */
  assign n986 = n927 ? x3_div6 : n981;
  /* TG68K_FPU_Transcendental.vhd:780:73  */
  assign n987 = n927 ? x5_div120 : n982;
  /* TG68K_FPU_Transcendental.vhd:775:73  */
  assign n988 = n918 ? series_sum : n983;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n989 = n1016 ? n924 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:775:73  */
  assign n990 = n918 ? x_cubed : n984;
  /* TG68K_FPU_Transcendental.vhd:775:73  */
  assign n991 = n918 ? x_fifth : n985;
  /* TG68K_FPU_Transcendental.vhd:775:73  */
  assign n992 = n918 ? x3_div6 : n986;
  /* TG68K_FPU_Transcendental.vhd:775:73  */
  assign n993 = n918 ? x5_div120 : n987;
  /* TG68K_FPU_Transcendental.vhd:805:108  */
  assign n994 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:805:108  */
  assign n996 = n994 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:805:92  */
  assign n997 = n996[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:811:95  */
  assign n998 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:811:111  */
  assign n1000 = $unsigned(n998) >= $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:816:105  */
  assign n1001 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:817:106  */
  assign n1002 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:811:73  */
  assign n1004 = n1000 ? 15'b011111111111111 : n1001;
  /* TG68K_FPU_Transcendental.vhd:811:73  */
  assign n1006 = n1000 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1002;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1008 = n915 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1009 = n915 ? result_sign : input_sign;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1010 = n915 ? result_exp : n1004;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1011 = n915 ? result_mant : n1006;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1012 = n915 ? n988 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1013 = n915 ? n997 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1015 = n915 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1016 = n918 & n915;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1017 = n915 ? n990 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1018 = n915 ? n991 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1019 = n915 ? n992 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:772:65  */
  assign n1020 = n915 ? n993 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1021 = n888 ? n905 : n1008;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1022 = n888 ? n906 : n1009;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1023 = n888 ? n908 : n1010;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1024 = n888 ? n910 : n1011;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1025 = n888 ? n911 : n1012;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1026 = n888 ? n912 : n1013;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1027 = n888 ? trans_inexact : n1015;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1028 = n888 ? x_squared : n989;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1029 = n888 ? x_cubed : n1017;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1030 = n888 ? x_fifth : n1018;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1031 = n888 ? x3_div6 : n1019;
  /* TG68K_FPU_Transcendental.vhd:751:65  */
  assign n1032 = n888 ? x5_div120 : n1020;
  /* TG68K_FPU_Transcendental.vhd:748:57  */
  assign n1034 = operation_code == 7'b0001001;
  /* TG68K_FPU_Transcendental.vhd:825:84  */
  assign n1035 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:825:84  */
  assign n1037 = n1035 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:827:96  */
  assign n1039 = $unsigned(input_exp) > $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:828:97  */
  assign n1041 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:828:137  */
  assign n1043 = $unsigned(input_mant) > $unsigned(64'b1000000000000000000000000000000000000000000000000000000000000000);
  /* TG68K_FPU_Transcendental.vhd:828:122  */
  assign n1044 = n1043 & n1041;
  /* TG68K_FPU_Transcendental.vhd:827:121  */
  assign n1045 = n1039 | n1044;
  /* TG68K_FPU_Transcendental.vhd:841:99  */
  assign n1047 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:842:89  */
  assign n1048 = input_mant[63:62]; // extract
  /* TG68K_FPU_Transcendental.vhd:842:104  */
  assign n1050 = n1048 == 2'b10;
  /* TG68K_FPU_Transcendental.vhd:841:124  */
  assign n1051 = n1050 & n1047;
  /* TG68K_FPU_Transcendental.vhd:851:116  */
  assign n1052 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:851:116  */
  assign n1054 = n1052 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:851:100  */
  assign n1055 = n1054[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1057 = n1051 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1058 = n1051 ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1060 = n1051 ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1062 = n1051 ? 64'b1100100100001111110110101010001000100001011010001100001000110101 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1063 = n1051 ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:841:73  */
  assign n1064 = n1051 ? iteration_count : n1055;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1066 = input_zero ? 3'b111 : n1057;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1067 = input_zero ? input_sign : n1058;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1069 = input_zero ? 15'b000000000000000 : n1060;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1071 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1062;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1072 = input_zero ? series_sum : n1063;
  /* TG68K_FPU_Transcendental.vhd:835:73  */
  assign n1073 = input_zero ? iteration_count : n1064;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1075 = n1045 ? 3'b111 : n1066;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1077 = n1045 ? 1'b0 : n1067;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1079 = n1045 ? 15'b111111111111111 : n1069;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1081 = n1045 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n1071;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1082 = n1045 ? series_sum : n1072;
  /* TG68K_FPU_Transcendental.vhd:827:73  */
  assign n1083 = n1045 ? iteration_count : n1073;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1085 = n1194 ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:853:87  */
  assign n1086 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:853:87  */
  assign n1088 = $signed(n1086) <= $signed(32'b00000000000000000000000000001000);
  /* TG68K_FPU_Transcendental.vhd:855:92  */
  assign n1089 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:855:92  */
  assign n1091 = n1089 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:858:115  */
  assign n1092 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:858:152  */
  assign n1093 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:858:131  */
  assign n1094 = {32'b0, n1092};  //  uext
  /* TG68K_FPU_Transcendental.vhd:858:131  */
  assign n1095 = {32'b0, n1093};  //  uext
  /* TG68K_FPU_Transcendental.vhd:858:131  */
  assign n1096 = n1094 * n1095; // umul
  /* TG68K_FPU_Transcendental.vhd:858:89  */
  assign n1097 = {64'b0, n1096};  //  uext
  /* TG68K_FPU_Transcendental.vhd:860:95  */
  assign n1098 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:860:95  */
  assign n1100 = n1098 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:863:114  */
  assign n1101 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:863:152  */
  assign n1102 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:863:131  */
  assign n1103 = {32'b0, n1101};  //  uext
  /* TG68K_FPU_Transcendental.vhd:863:131  */
  assign n1104 = {32'b0, n1102};  //  uext
  /* TG68K_FPU_Transcendental.vhd:863:131  */
  assign n1105 = n1103 * n1104; // umul
  /* TG68K_FPU_Transcendental.vhd:863:89  */
  assign n1106 = {64'b0, n1105};  //  uext
  /* TG68K_FPU_Transcendental.vhd:865:95  */
  assign n1107 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:865:95  */
  assign n1109 = n1107 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:867:132  */
  assign n1110 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:867:149  */
  assign n1112 = n1110 / 32'b00000000000000000000000000000110; // udiv
  /* TG68K_FPU_Transcendental.vhd:867:109  */
  assign n1113 = {32'b0, n1112};  //  uext
  /* TG68K_FPU_Transcendental.vhd:868:95  */
  assign n1114 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:868:95  */
  assign n1116 = n1114 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:871:89  */
  assign n1117 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:870:133  */
  assign n1118 = series_sum + n1117;
  /* TG68K_FPU_Transcendental.vhd:872:95  */
  assign n1119 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:872:95  */
  assign n1121 = n1119 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:875:112  */
  assign n1122 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:875:149  */
  assign n1123 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:875:129  */
  assign n1124 = {32'b0, n1122};  //  uext
  /* TG68K_FPU_Transcendental.vhd:875:129  */
  assign n1125 = {32'b0, n1123};  //  uext
  /* TG68K_FPU_Transcendental.vhd:875:129  */
  assign n1126 = n1124 * n1125; // umul
  /* TG68K_FPU_Transcendental.vhd:875:89  */
  assign n1127 = {64'b0, n1126};  //  uext
  /* TG68K_FPU_Transcendental.vhd:877:95  */
  assign n1128 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:877:95  */
  assign n1130 = n1128 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:879:146  */
  assign n1131 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:879:163  */
  assign n1132 = {64'b0, n1131};  //  uext
  /* TG68K_FPU_Transcendental.vhd:879:163  */
  assign n1134 = $signed(n1132) * $signed(128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011); // smul
  /* TG68K_FPU_Transcendental.vhd:879:118  */
  assign n1136 = n1134 >> 31'b0000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:879:111  */
  assign n1137 = n1136[63:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:880:95  */
  assign n1138 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:880:95  */
  assign n1140 = n1138 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:883:89  */
  assign n1141 = {16'b0, x5_div120};  //  uext
  /* TG68K_FPU_Transcendental.vhd:882:133  */
  assign n1142 = series_sum + n1141;
  /* TG68K_FPU_Transcendental.vhd:880:73  */
  assign n1143 = n1140 ? n1142 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:877:73  */
  assign n1144 = n1130 ? series_sum : n1143;
  /* TG68K_FPU_Transcendental.vhd:877:73  */
  assign n1145 = n1130 ? n1137 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:872:73  */
  assign n1146 = n1121 ? series_sum : n1144;
  /* TG68K_FPU_Transcendental.vhd:872:73  */
  assign n1147 = n1121 ? n1127 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:872:73  */
  assign n1148 = n1121 ? x5_div120 : n1145;
  /* TG68K_FPU_Transcendental.vhd:868:73  */
  assign n1149 = n1116 ? n1118 : n1146;
  /* TG68K_FPU_Transcendental.vhd:868:73  */
  assign n1150 = n1116 ? x_fifth : n1147;
  /* TG68K_FPU_Transcendental.vhd:868:73  */
  assign n1151 = n1116 ? x5_div120 : n1148;
  /* TG68K_FPU_Transcendental.vhd:865:73  */
  assign n1152 = n1109 ? series_sum : n1149;
  /* TG68K_FPU_Transcendental.vhd:865:73  */
  assign n1153 = n1109 ? x_fifth : n1150;
  /* TG68K_FPU_Transcendental.vhd:865:73  */
  assign n1154 = n1109 ? n1113 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:865:73  */
  assign n1155 = n1109 ? x5_div120 : n1151;
  /* TG68K_FPU_Transcendental.vhd:860:73  */
  assign n1156 = n1100 ? series_sum : n1152;
  /* TG68K_FPU_Transcendental.vhd:860:73  */
  assign n1157 = n1100 ? n1106 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:860:73  */
  assign n1158 = n1100 ? x_fifth : n1153;
  /* TG68K_FPU_Transcendental.vhd:860:73  */
  assign n1159 = n1100 ? x3_div6 : n1154;
  /* TG68K_FPU_Transcendental.vhd:860:73  */
  assign n1160 = n1100 ? x5_div120 : n1155;
  /* TG68K_FPU_Transcendental.vhd:855:73  */
  assign n1161 = n1091 ? series_sum : n1156;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1162 = n1182 ? n1097 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:855:73  */
  assign n1163 = n1091 ? x_cubed : n1157;
  /* TG68K_FPU_Transcendental.vhd:855:73  */
  assign n1164 = n1091 ? x_fifth : n1158;
  /* TG68K_FPU_Transcendental.vhd:855:73  */
  assign n1165 = n1091 ? x3_div6 : n1159;
  /* TG68K_FPU_Transcendental.vhd:855:73  */
  assign n1166 = n1091 ? x5_div120 : n1160;
  /* TG68K_FPU_Transcendental.vhd:885:108  */
  assign n1167 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:885:108  */
  assign n1169 = n1167 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:885:92  */
  assign n1170 = n1169[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:890:97  */
  assign n1171 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:891:98  */
  assign n1172 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1174 = n1088 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1175 = n1088 ? result_sign : input_sign;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1176 = n1088 ? result_exp : n1171;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1177 = n1088 ? result_mant : n1172;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1178 = n1088 ? n1161 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1179 = n1088 ? n1170 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1181 = n1088 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1182 = n1091 & n1088;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1183 = n1088 ? n1163 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1184 = n1088 ? n1164 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1185 = n1088 ? n1165 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:853:65  */
  assign n1186 = n1088 ? n1166 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1187 = n1037 ? n1075 : n1174;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1188 = n1037 ? n1077 : n1175;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1189 = n1037 ? n1079 : n1176;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1190 = n1037 ? n1081 : n1177;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1191 = n1037 ? n1082 : n1178;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1192 = n1037 ? n1083 : n1179;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1193 = n1037 ? trans_inexact : n1181;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1194 = n1045 & n1037;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1195 = n1037 ? x_squared : n1162;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1196 = n1037 ? x_cubed : n1183;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1197 = n1037 ? x_fifth : n1184;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1198 = n1037 ? x3_div6 : n1185;
  /* TG68K_FPU_Transcendental.vhd:825:65  */
  assign n1199 = n1037 ? x5_div120 : n1186;
  /* TG68K_FPU_Transcendental.vhd:822:57  */
  assign n1201 = operation_code == 7'b0001100;
  /* TG68K_FPU_Transcendental.vhd:899:84  */
  assign n1202 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:899:84  */
  assign n1204 = n1202 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:901:96  */
  assign n1206 = $unsigned(input_exp) > $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:902:97  */
  assign n1208 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:902:137  */
  assign n1210 = $unsigned(input_mant) > $unsigned(64'b1000000000000000000000000000000000000000000000000000000000000000);
  /* TG68K_FPU_Transcendental.vhd:902:122  */
  assign n1211 = n1210 & n1208;
  /* TG68K_FPU_Transcendental.vhd:901:121  */
  assign n1212 = n1206 | n1211;
  /* TG68K_FPU_Transcendental.vhd:915:99  */
  assign n1214 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:916:89  */
  assign n1215 = input_mant[63:62]; // extract
  /* TG68K_FPU_Transcendental.vhd:916:104  */
  assign n1217 = n1215 == 2'b10;
  /* TG68K_FPU_Transcendental.vhd:915:124  */
  assign n1218 = n1217 & n1214;
  /* TG68K_FPU_Transcendental.vhd:916:126  */
  assign n1219 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:916:111  */
  assign n1220 = n1219 & n1218;
  /* TG68K_FPU_Transcendental.vhd:922:99  */
  assign n1222 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:923:89  */
  assign n1223 = input_mant[63:62]; // extract
  /* TG68K_FPU_Transcendental.vhd:923:104  */
  assign n1225 = n1223 == 2'b10;
  /* TG68K_FPU_Transcendental.vhd:922:124  */
  assign n1226 = n1225 & n1222;
  /* TG68K_FPU_Transcendental.vhd:923:111  */
  assign n1227 = input_sign & n1226;
  /* TG68K_FPU_Transcendental.vhd:932:116  */
  assign n1228 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:932:116  */
  assign n1230 = n1228 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:932:100  */
  assign n1231 = n1230[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1233 = n1227 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1235 = n1227 ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1237 = n1227 ? 15'b100000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1239 = n1227 ? 64'b1100100100001111110110101010001000100001011010001100001000110101 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1241 = n1227 ? series_sum : 80'b00111111111111111100100100001111110110101010001000100001011010001100001000110101;
  /* TG68K_FPU_Transcendental.vhd:922:73  */
  assign n1242 = n1227 ? iteration_count : n1231;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1244 = n1220 ? 3'b111 : n1233;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1246 = n1220 ? 1'b0 : n1235;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1248 = n1220 ? 15'b000000000000000 : n1237;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1250 = n1220 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1239;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1251 = n1220 ? series_sum : n1241;
  /* TG68K_FPU_Transcendental.vhd:915:73  */
  assign n1252 = n1220 ? iteration_count : n1242;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1254 = input_zero ? 3'b111 : n1244;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1256 = input_zero ? 1'b0 : n1246;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1258 = input_zero ? 15'b011111111111111 : n1248;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1260 = input_zero ? 64'b1100100100001111110110101010001000100001011010001100001000110101 : n1250;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1261 = input_zero ? series_sum : n1251;
  /* TG68K_FPU_Transcendental.vhd:909:73  */
  assign n1262 = input_zero ? iteration_count : n1252;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1264 = n1212 ? 3'b111 : n1254;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1266 = n1212 ? 1'b0 : n1256;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1268 = n1212 ? 15'b111111111111111 : n1258;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1270 = n1212 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n1260;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1271 = n1212 ? series_sum : n1261;
  /* TG68K_FPU_Transcendental.vhd:901:73  */
  assign n1272 = n1212 ? iteration_count : n1262;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1274 = n1394 ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:934:87  */
  assign n1275 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:934:87  */
  assign n1277 = $signed(n1275) <= $signed(32'b00000000000000000000000000001000);
  /* TG68K_FPU_Transcendental.vhd:937:92  */
  assign n1278 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:937:92  */
  assign n1280 = n1278 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:940:115  */
  assign n1281 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:940:152  */
  assign n1282 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:940:131  */
  assign n1283 = {32'b0, n1281};  //  uext
  /* TG68K_FPU_Transcendental.vhd:940:131  */
  assign n1284 = {32'b0, n1282};  //  uext
  /* TG68K_FPU_Transcendental.vhd:940:131  */
  assign n1285 = n1283 * n1284; // umul
  /* TG68K_FPU_Transcendental.vhd:940:89  */
  assign n1286 = {64'b0, n1285};  //  uext
  /* TG68K_FPU_Transcendental.vhd:942:95  */
  assign n1287 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:942:95  */
  assign n1289 = n1287 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:944:95  */
  assign n1290 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:945:138  */
  assign n1292 = 80'b00111111111111111100100100001111110110101010001000100001011010001100001000110101 - operand;
  /* TG68K_FPU_Transcendental.vhd:948:138  */
  assign n1294 = 80'b00111111111111111100100100001111110110101010001000100001011010001100001000110101 + operand;
  /* TG68K_FPU_Transcendental.vhd:944:81  */
  assign n1295 = n1290 ? n1292 : n1294;
  /* TG68K_FPU_Transcendental.vhd:951:95  */
  assign n1296 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:951:95  */
  assign n1298 = n1296 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:954:114  */
  assign n1299 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:954:152  */
  assign n1300 = input_mant[63:32]; // extract
  /* TG68K_FPU_Transcendental.vhd:954:131  */
  assign n1301 = {32'b0, n1299};  //  uext
  /* TG68K_FPU_Transcendental.vhd:954:131  */
  assign n1302 = {32'b0, n1300};  //  uext
  /* TG68K_FPU_Transcendental.vhd:954:131  */
  assign n1303 = n1301 * n1302; // umul
  /* TG68K_FPU_Transcendental.vhd:954:89  */
  assign n1304 = {64'b0, n1303};  //  uext
  /* TG68K_FPU_Transcendental.vhd:956:95  */
  assign n1305 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:956:95  */
  assign n1307 = n1305 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:958:132  */
  assign n1308 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:958:149  */
  assign n1310 = n1308 / 32'b00000000000000000000000000000110; // udiv
  /* TG68K_FPU_Transcendental.vhd:958:109  */
  assign n1311 = {32'b0, n1310};  //  uext
  /* TG68K_FPU_Transcendental.vhd:959:95  */
  assign n1312 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:959:95  */
  assign n1314 = n1312 == 32'b00000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:961:95  */
  assign n1315 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:963:97  */
  assign n1316 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:962:141  */
  assign n1317 = series_sum - n1316;
  /* TG68K_FPU_Transcendental.vhd:966:97  */
  assign n1318 = {16'b0, x3_div6};  //  uext
  /* TG68K_FPU_Transcendental.vhd:965:141  */
  assign n1319 = series_sum + n1318;
  /* TG68K_FPU_Transcendental.vhd:961:81  */
  assign n1320 = n1315 ? n1317 : n1319;
  /* TG68K_FPU_Transcendental.vhd:968:95  */
  assign n1321 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:968:95  */
  assign n1323 = n1321 == 32'b00000000000000000000000000000110;
  /* TG68K_FPU_Transcendental.vhd:971:112  */
  assign n1324 = x_cubed[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:971:149  */
  assign n1325 = x_squared[127:96]; // extract
  /* TG68K_FPU_Transcendental.vhd:971:129  */
  assign n1326 = {32'b0, n1324};  //  uext
  /* TG68K_FPU_Transcendental.vhd:971:129  */
  assign n1327 = {32'b0, n1325};  //  uext
  /* TG68K_FPU_Transcendental.vhd:971:129  */
  assign n1328 = n1326 * n1327; // umul
  /* TG68K_FPU_Transcendental.vhd:971:89  */
  assign n1329 = {64'b0, n1328};  //  uext
  /* TG68K_FPU_Transcendental.vhd:973:95  */
  assign n1330 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:973:95  */
  assign n1332 = n1330 == 32'b00000000000000000000000000000111;
  /* TG68K_FPU_Transcendental.vhd:975:146  */
  assign n1333 = x_fifth[127:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:975:163  */
  assign n1334 = {64'b0, n1333};  //  uext
  /* TG68K_FPU_Transcendental.vhd:975:163  */
  assign n1336 = $signed(n1334) * $signed(128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011); // smul
  /* TG68K_FPU_Transcendental.vhd:975:118  */
  assign n1338 = n1336 >> 31'b0000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:975:111  */
  assign n1339 = n1338[63:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:973:73  */
  assign n1340 = n1332 ? n1339 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:968:73  */
  assign n1341 = n1323 ? n1329 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:968:73  */
  assign n1342 = n1323 ? x5_div120 : n1340;
  /* TG68K_FPU_Transcendental.vhd:959:73  */
  assign n1343 = n1314 ? n1320 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:959:73  */
  assign n1344 = n1314 ? x_fifth : n1341;
  /* TG68K_FPU_Transcendental.vhd:959:73  */
  assign n1345 = n1314 ? x5_div120 : n1342;
  /* TG68K_FPU_Transcendental.vhd:956:73  */
  assign n1346 = n1307 ? series_sum : n1343;
  /* TG68K_FPU_Transcendental.vhd:956:73  */
  assign n1347 = n1307 ? x_fifth : n1344;
  /* TG68K_FPU_Transcendental.vhd:956:73  */
  assign n1348 = n1307 ? n1311 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:956:73  */
  assign n1349 = n1307 ? x5_div120 : n1345;
  /* TG68K_FPU_Transcendental.vhd:951:73  */
  assign n1350 = n1298 ? series_sum : n1346;
  /* TG68K_FPU_Transcendental.vhd:951:73  */
  assign n1351 = n1298 ? n1304 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:951:73  */
  assign n1352 = n1298 ? x_fifth : n1347;
  /* TG68K_FPU_Transcendental.vhd:951:73  */
  assign n1353 = n1298 ? x3_div6 : n1348;
  /* TG68K_FPU_Transcendental.vhd:951:73  */
  assign n1354 = n1298 ? x5_div120 : n1349;
  /* TG68K_FPU_Transcendental.vhd:942:73  */
  assign n1355 = n1289 ? n1295 : n1350;
  /* TG68K_FPU_Transcendental.vhd:942:73  */
  assign n1356 = n1289 ? x_cubed : n1351;
  /* TG68K_FPU_Transcendental.vhd:942:73  */
  assign n1357 = n1289 ? x_fifth : n1352;
  /* TG68K_FPU_Transcendental.vhd:942:73  */
  assign n1358 = n1289 ? x3_div6 : n1353;
  /* TG68K_FPU_Transcendental.vhd:942:73  */
  assign n1359 = n1289 ? x5_div120 : n1354;
  /* TG68K_FPU_Transcendental.vhd:937:73  */
  assign n1360 = n1280 ? series_sum : n1355;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1361 = n1382 ? n1286 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:937:73  */
  assign n1362 = n1280 ? x_cubed : n1356;
  /* TG68K_FPU_Transcendental.vhd:937:73  */
  assign n1363 = n1280 ? x_fifth : n1357;
  /* TG68K_FPU_Transcendental.vhd:937:73  */
  assign n1364 = n1280 ? x3_div6 : n1358;
  /* TG68K_FPU_Transcendental.vhd:937:73  */
  assign n1365 = n1280 ? x5_div120 : n1359;
  /* TG68K_FPU_Transcendental.vhd:977:108  */
  assign n1366 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:977:108  */
  assign n1368 = n1366 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:977:92  */
  assign n1369 = n1368[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:982:97  */
  assign n1370 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:983:98  */
  assign n1371 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1373 = n1277 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1375 = n1277 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1376 = n1277 ? result_exp : n1370;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1377 = n1277 ? result_mant : n1371;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1378 = n1277 ? n1360 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1379 = n1277 ? n1369 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1381 = n1277 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1382 = n1280 & n1277;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1383 = n1277 ? n1362 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1384 = n1277 ? n1363 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1385 = n1277 ? n1364 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:934:65  */
  assign n1386 = n1277 ? n1365 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1387 = n1204 ? n1264 : n1373;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1388 = n1204 ? n1266 : n1375;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1389 = n1204 ? n1268 : n1376;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1390 = n1204 ? n1270 : n1377;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1391 = n1204 ? n1271 : n1378;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1392 = n1204 ? n1272 : n1379;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1393 = n1204 ? trans_inexact : n1381;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1394 = n1212 & n1204;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1395 = n1204 ? x_squared : n1361;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1396 = n1204 ? x_cubed : n1383;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1397 = n1204 ? x_fifth : n1384;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1398 = n1204 ? x3_div6 : n1385;
  /* TG68K_FPU_Transcendental.vhd:899:65  */
  assign n1399 = n1204 ? x5_div120 : n1386;
  /* TG68K_FPU_Transcendental.vhd:895:57  */
  assign n1401 = operation_code == 7'b0011100;
  /* TG68K_FPU_Transcendental.vhd:995:91  */
  assign n1403 = $unsigned(input_exp) < $unsigned(15'b011111111110101);
  /* TG68K_FPU_Transcendental.vhd:995:65  */
  assign n1406 = n1403 ? 3'b110 : 3'b101;
  /* TG68K_FPU_Transcendental.vhd:995:65  */
  assign n1408 = n1403 ? cordic_iteration : 5'b00000;
  /* TG68K_FPU_Transcendental.vhd:995:65  */
  assign n1409 = n1403 ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:995:65  */
  assign n1410 = n1403 ? input_exp : result_exp;
  /* TG68K_FPU_Transcendental.vhd:995:65  */
  assign n1411 = n1403 ? input_mant : result_mant;
  /* TG68K_FPU_Transcendental.vhd:989:65  */
  assign n1413 = input_zero ? 3'b111 : n1406;
  /* TG68K_FPU_Transcendental.vhd:989:65  */
  assign n1414 = input_zero ? cordic_iteration : n1408;
  /* TG68K_FPU_Transcendental.vhd:989:65  */
  assign n1415 = input_zero ? input_sign : n1409;
  /* TG68K_FPU_Transcendental.vhd:989:65  */
  assign n1417 = input_zero ? 15'b000000000000000 : n1410;
  /* TG68K_FPU_Transcendental.vhd:989:65  */
  assign n1419 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1411;
  /* TG68K_FPU_Transcendental.vhd:987:57  */
  assign n1421 = operation_code == 7'b0001010;
  /* TG68K_FPU_Transcendental.vhd:1009:84  */
  assign n1422 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1009:84  */
  assign n1424 = n1422 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1011:96  */
  assign n1426 = $unsigned(input_exp) >= $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:1025:116  */
  assign n1427 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1025:116  */
  assign n1429 = n1427 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1025:100  */
  assign n1430 = n1429[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1018:73  */
  assign n1432 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1018:73  */
  assign n1433 = input_zero ? input_sign : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1018:73  */
  assign n1435 = input_zero ? 15'b000000000000000 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1018:73  */
  assign n1437 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1018:73  */
  assign n1438 = input_zero ? iteration_count : n1430;
  /* TG68K_FPU_Transcendental.vhd:1011:73  */
  assign n1440 = n1426 ? 3'b111 : n1432;
  /* TG68K_FPU_Transcendental.vhd:1011:73  */
  assign n1442 = n1426 ? 1'b0 : n1433;
  /* TG68K_FPU_Transcendental.vhd:1011:73  */
  assign n1444 = n1426 ? 15'b111111111111111 : n1435;
  /* TG68K_FPU_Transcendental.vhd:1011:73  */
  assign n1446 = n1426 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n1437;
  /* TG68K_FPU_Transcendental.vhd:1011:73  */
  assign n1447 = n1426 ? iteration_count : n1438;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1449 = n1470 ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:1027:87  */
  assign n1450 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1027:87  */
  assign n1452 = $signed(n1450) < $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:1028:108  */
  assign n1453 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1028:108  */
  assign n1455 = n1453 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1028:92  */
  assign n1456 = n1455[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1027:65  */
  assign n1458 = n1452 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1027:65  */
  assign n1459 = n1452 ? result_sign : input_sign;
  /* TG68K_FPU_Transcendental.vhd:1027:65  */
  assign n1460 = n1452 ? result_exp : input_exp;
  /* TG68K_FPU_Transcendental.vhd:1027:65  */
  assign n1461 = n1452 ? result_mant : input_mant;
  /* TG68K_FPU_Transcendental.vhd:1027:65  */
  assign n1462 = n1452 ? n1456 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1463 = n1424 ? n1440 : n1458;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1464 = n1424 ? n1442 : n1459;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1465 = n1424 ? n1444 : n1460;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1466 = n1424 ? n1446 : n1461;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1467 = n1424 ? n1447 : n1462;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1469 = n1424 ? trans_inexact : 1'b1;
  /* TG68K_FPU_Transcendental.vhd:1009:65  */
  assign n1470 = n1426 & n1424;
  /* TG68K_FPU_Transcendental.vhd:1007:57  */
  assign n1472 = operation_code == 7'b0001101;
  /* TG68K_FPU_Transcendental.vhd:1042:84  */
  assign n1473 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1042:84  */
  assign n1475 = n1473 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1051:125  */
  assign n1477 = $unsigned(input_exp) > $unsigned(15'b100000000000101);
  /* TG68K_FPU_Transcendental.vhd:1051:101  */
  assign n1478 = n1477 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:1058:98  */
  assign n1479 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:1058:128  */
  assign n1481 = $unsigned(input_exp) > $unsigned(15'b100000000000101);
  /* TG68K_FPU_Transcendental.vhd:1058:104  */
  assign n1482 = n1481 & n1479;
  /* TG68K_FPU_Transcendental.vhd:1070:124  */
  assign n1483 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1070:124  */
  assign n1485 = n1483 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1070:108  */
  assign n1486 = n1485[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1488 = n1482 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1490 = n1482 ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1492 = n1482 ? 15'b111111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1494 = n1482 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1496 = n1482 ? series_term : 80'b00111111111111111000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1498 = n1482 ? series_sum : 80'b00111111111111111000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1499 = n1482 ? iteration_count : n1486;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1501 = n1482 ? 1'b1 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1058:81  */
  assign n1502 = n1482 ? exp_argument : operand;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1504 = n1478 ? 3'b111 : n1488;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1506 = n1478 ? 1'b0 : n1490;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1508 = n1478 ? 15'b000000000000000 : n1492;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1510 = n1478 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1494;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1511 = n1478 ? series_term : n1496;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1512 = n1478 ? series_sum : n1498;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1513 = n1478 ? iteration_count : n1499;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1514 = n1478 ? trans_overflow : n1501;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1516 = n1478 ? 1'b1 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1051:81  */
  assign n1517 = n1478 ? exp_argument : n1502;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1519 = input_zero ? 3'b111 : n1504;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1521 = input_zero ? 1'b0 : n1506;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1523 = input_zero ? 15'b011111111111111 : n1508;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1525 = input_zero ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1510;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1526 = input_zero ? series_term : n1511;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1527 = input_zero ? series_sum : n1512;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1528 = input_zero ? iteration_count : n1513;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1529 = input_zero ? trans_overflow : n1514;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1530 = input_zero ? trans_underflow : n1516;
  /* TG68K_FPU_Transcendental.vhd:1043:73  */
  assign n1531 = input_zero ? exp_argument : n1517;
  /* TG68K_FPU_Transcendental.vhd:1073:87  */
  assign n1532 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1073:87  */
  assign n1534 = $signed(n1532) <= $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:1075:92  */
  assign n1535 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1075:92  */
  assign n1537 = n1535 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1078:133  */
  assign n1538 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1079:95  */
  assign n1539 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1079:95  */
  assign n1541 = n1539 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:1082:117  */
  assign n1542 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1082:156  */
  assign n1543 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1082:133  */
  assign n1544 = {16'b0, n1542};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1082:133  */
  assign n1545 = {16'b0, n1543};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1082:133  */
  assign n1546 = n1544 * n1545; // umul
  /* TG68K_FPU_Transcendental.vhd:1082:172  */
  assign n1548 = n1546 / 32'b00000000000000000000000000000010; // udiv
  /* TG68K_FPU_Transcendental.vhd:1082:89  */
  assign n1549 = {48'b0, n1548};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1084:133  */
  assign n1550 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1085:95  */
  assign n1551 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1085:95  */
  assign n1553 = n1551 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:1088:117  */
  assign n1554 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1088:156  */
  assign n1555 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1088:133  */
  assign n1556 = {16'b0, n1554};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1088:133  */
  assign n1557 = {16'b0, n1555};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1088:133  */
  assign n1558 = n1556 * n1557; // umul
  /* TG68K_FPU_Transcendental.vhd:1089:117  */
  assign n1559 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1088:172  */
  assign n1560 = {16'b0, n1558};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1088:172  */
  assign n1561 = {32'b0, n1559};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1088:172  */
  assign n1562 = n1560 * n1561; // umul
  /* TG68K_FPU_Transcendental.vhd:1089:133  */
  assign n1564 = n1562 / 48'b000000000000000000000000000000000000000000000110; // udiv
  /* TG68K_FPU_Transcendental.vhd:1088:89  */
  assign n1565 = {32'b0, n1564};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1091:133  */
  assign n1566 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1092:95  */
  assign n1567 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1092:95  */
  assign n1569 = n1567 == 32'b00000000000000000000000000000100;
  /* TG68K_FPU_Transcendental.vhd:1095:89  */
  assign n1571 = exp_argument >> 31'b0000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:1097:133  */
  assign n1572 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1092:73  */
  assign n1573 = n1569 ? n1571 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1092:73  */
  assign n1574 = n1569 ? n1572 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1085:73  */
  assign n1575 = n1553 ? n1565 : n1573;
  /* TG68K_FPU_Transcendental.vhd:1085:73  */
  assign n1576 = n1553 ? n1566 : n1574;
  /* TG68K_FPU_Transcendental.vhd:1079:73  */
  assign n1577 = n1541 ? n1549 : n1575;
  /* TG68K_FPU_Transcendental.vhd:1079:73  */
  assign n1578 = n1541 ? n1550 : n1576;
  /* TG68K_FPU_Transcendental.vhd:1075:73  */
  assign n1579 = n1537 ? exp_argument : n1577;
  /* TG68K_FPU_Transcendental.vhd:1075:73  */
  assign n1580 = n1537 ? n1538 : n1578;
  /* TG68K_FPU_Transcendental.vhd:1102:108  */
  assign n1581 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1102:108  */
  assign n1583 = n1581 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1102:92  */
  assign n1584 = n1583[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1106:98  */
  assign n1585 = series_sum[79]; // extract
  /* TG68K_FPU_Transcendental.vhd:1107:97  */
  assign n1586 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:1108:98  */
  assign n1587 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1589 = n1534 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1590 = n1534 ? result_sign : n1585;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1591 = n1534 ? result_exp : n1586;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1592 = n1534 ? result_mant : n1587;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1593 = n1534 ? n1579 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1594 = n1534 ? n1580 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1595 = n1534 ? n1584 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1073:65  */
  assign n1597 = n1534 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1598 = n1475 ? n1519 : n1589;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1599 = n1475 ? n1521 : n1590;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1600 = n1475 ? n1523 : n1591;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1601 = n1475 ? n1525 : n1592;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1602 = n1475 ? n1526 : n1593;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1603 = n1475 ? n1527 : n1594;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1604 = n1475 ? n1528 : n1595;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1605 = n1475 ? n1529 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1606 = n1475 ? n1530 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1607 = n1475 ? trans_inexact : n1597;
  /* TG68K_FPU_Transcendental.vhd:1042:65  */
  assign n1608 = n1475 ? n1531 : exp_argument;
  /* TG68K_FPU_Transcendental.vhd:1040:57  */
  assign n1610 = operation_code == 7'b0010000;
  /* TG68K_FPU_Transcendental.vhd:1114:84  */
  assign n1611 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1114:84  */
  assign n1613 = n1611 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1123:125  */
  assign n1615 = $unsigned(input_exp) > $unsigned(15'b100000000000101);
  /* TG68K_FPU_Transcendental.vhd:1123:101  */
  assign n1616 = n1615 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:1130:98  */
  assign n1617 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:1130:128  */
  assign n1619 = $unsigned(input_exp) > $unsigned(15'b100000000000101);
  /* TG68K_FPU_Transcendental.vhd:1130:104  */
  assign n1620 = n1619 & n1617;
  /* TG68K_FPU_Transcendental.vhd:1142:124  */
  assign n1621 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1142:124  */
  assign n1623 = n1621 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1142:108  */
  assign n1624 = n1623[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1626 = n1620 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1628 = n1620 ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1630 = n1620 ? 15'b111111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1632 = n1620 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1633 = n1620 ? series_term : operand;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1634 = n1620 ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1635 = n1620 ? iteration_count : n1624;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1637 = n1620 ? 1'b1 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1130:81  */
  assign n1638 = n1620 ? exp_argument : operand;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1640 = n1616 ? 3'b111 : n1626;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1642 = n1616 ? 1'b1 : n1628;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1644 = n1616 ? 15'b011111111111111 : n1630;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1646 = n1616 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1632;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1647 = n1616 ? series_term : n1633;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1648 = n1616 ? series_sum : n1634;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1649 = n1616 ? iteration_count : n1635;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1650 = n1616 ? trans_overflow : n1637;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1652 = n1616 ? 1'b1 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1123:81  */
  assign n1653 = n1616 ? exp_argument : n1638;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1655 = input_zero ? 3'b111 : n1640;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1657 = input_zero ? 1'b0 : n1642;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1659 = input_zero ? 15'b000000000000000 : n1644;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1661 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1646;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1662 = input_zero ? series_term : n1647;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1663 = input_zero ? series_sum : n1648;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1664 = input_zero ? iteration_count : n1649;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1665 = input_zero ? trans_overflow : n1650;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1666 = input_zero ? trans_underflow : n1652;
  /* TG68K_FPU_Transcendental.vhd:1115:73  */
  assign n1667 = input_zero ? exp_argument : n1653;
  /* TG68K_FPU_Transcendental.vhd:1145:87  */
  assign n1668 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1145:87  */
  assign n1670 = $signed(n1668) <= $signed(32'b00000000000000000000000000000101);
  /* TG68K_FPU_Transcendental.vhd:1147:92  */
  assign n1671 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1147:92  */
  assign n1673 = n1671 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1150:117  */
  assign n1674 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1150:156  */
  assign n1675 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1150:133  */
  assign n1676 = {16'b0, n1674};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1150:133  */
  assign n1677 = {16'b0, n1675};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1150:133  */
  assign n1678 = n1676 * n1677; // umul
  /* TG68K_FPU_Transcendental.vhd:1150:172  */
  assign n1680 = n1678 / 32'b00000000000000000000000000000010; // udiv
  /* TG68K_FPU_Transcendental.vhd:1150:89  */
  assign n1681 = {48'b0, n1680};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1152:133  */
  assign n1682 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1153:95  */
  assign n1683 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1153:95  */
  assign n1685 = n1683 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:1156:117  */
  assign n1686 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1156:156  */
  assign n1687 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1156:133  */
  assign n1688 = {16'b0, n1686};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1156:133  */
  assign n1689 = {16'b0, n1687};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1156:133  */
  assign n1690 = n1688 * n1689; // umul
  /* TG68K_FPU_Transcendental.vhd:1157:117  */
  assign n1691 = exp_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1156:172  */
  assign n1692 = {16'b0, n1690};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1156:172  */
  assign n1693 = {32'b0, n1691};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1156:172  */
  assign n1694 = n1692 * n1693; // umul
  /* TG68K_FPU_Transcendental.vhd:1157:133  */
  assign n1696 = n1694 / 48'b000000000000000000000000000000000000000000000110; // udiv
  /* TG68K_FPU_Transcendental.vhd:1156:89  */
  assign n1697 = {32'b0, n1696};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1159:133  */
  assign n1698 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1160:95  */
  assign n1699 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1160:95  */
  assign n1701 = n1699 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:1163:89  */
  assign n1703 = exp_argument >> 31'b0000000000000000000000000000101;
  /* TG68K_FPU_Transcendental.vhd:1165:133  */
  assign n1704 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1160:73  */
  assign n1705 = n1701 ? n1703 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1160:73  */
  assign n1706 = n1701 ? n1704 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1153:73  */
  assign n1707 = n1685 ? n1697 : n1705;
  /* TG68K_FPU_Transcendental.vhd:1153:73  */
  assign n1708 = n1685 ? n1698 : n1706;
  /* TG68K_FPU_Transcendental.vhd:1147:73  */
  assign n1709 = n1673 ? n1681 : n1707;
  /* TG68K_FPU_Transcendental.vhd:1147:73  */
  assign n1710 = n1673 ? n1682 : n1708;
  /* TG68K_FPU_Transcendental.vhd:1170:108  */
  assign n1711 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1170:108  */
  assign n1713 = n1711 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1170:92  */
  assign n1714 = n1713[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1174:98  */
  assign n1715 = series_sum[79]; // extract
  /* TG68K_FPU_Transcendental.vhd:1175:97  */
  assign n1716 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:1176:98  */
  assign n1717 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1719 = n1670 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1720 = n1670 ? result_sign : n1715;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1721 = n1670 ? result_exp : n1716;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1722 = n1670 ? result_mant : n1717;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1723 = n1670 ? n1709 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1724 = n1670 ? n1710 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1725 = n1670 ? n1714 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1145:65  */
  assign n1727 = n1670 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1728 = n1613 ? n1655 : n1719;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1729 = n1613 ? n1657 : n1720;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1730 = n1613 ? n1659 : n1721;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1731 = n1613 ? n1661 : n1722;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1732 = n1613 ? n1662 : n1723;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1733 = n1613 ? n1663 : n1724;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1734 = n1613 ? n1664 : n1725;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1735 = n1613 ? n1665 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1736 = n1613 ? n1666 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1737 = n1613 ? trans_inexact : n1727;
  /* TG68K_FPU_Transcendental.vhd:1114:65  */
  assign n1738 = n1613 ? n1667 : exp_argument;
  /* TG68K_FPU_Transcendental.vhd:1112:57  */
  assign n1740 = operation_code == 7'b0000111;
  /* TG68K_FPU_Transcendental.vhd:1182:84  */
  assign n1741 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1182:84  */
  assign n1743 = n1741 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1183:117  */
  assign n1745 = $unsigned(input_exp) >= $unsigned(15'b011111111111111);
  /* TG68K_FPU_Transcendental.vhd:1183:93  */
  assign n1746 = n1745 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:1196:99  */
  assign n1748 = input_exp == 15'b011111111111111;
  /* TG68K_FPU_Transcendental.vhd:1197:90  */
  assign n1750 = input_mant == 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1196:124  */
  assign n1751 = n1750 & n1748;
  /* TG68K_FPU_Transcendental.vhd:1197:112  */
  assign n1752 = input_sign & n1751;
  /* TG68K_FPU_Transcendental.vhd:1209:116  */
  assign n1753 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1209:116  */
  assign n1755 = n1753 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1209:100  */
  assign n1756 = n1755[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1758 = n1752 ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1760 = n1752 ? 1'b1 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1762 = n1752 ? 15'b111111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1764 = n1752 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1765 = n1752 ? series_term : operand;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1766 = n1752 ? series_sum : operand;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1767 = n1752 ? iteration_count : n1756;
  /* TG68K_FPU_Transcendental.vhd:1196:73  */
  assign n1768 = n1752 ? log_argument : operand;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1770 = input_zero ? 3'b111 : n1758;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1772 = input_zero ? 1'b0 : n1760;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1774 = input_zero ? 15'b000000000000000 : n1762;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1776 = input_zero ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1764;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1777 = input_zero ? series_term : n1765;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1778 = input_zero ? series_sum : n1766;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1779 = input_zero ? iteration_count : n1767;
  /* TG68K_FPU_Transcendental.vhd:1190:73  */
  assign n1780 = input_zero ? log_argument : n1768;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1782 = n1746 ? 3'b111 : n1770;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1784 = n1746 ? 1'b0 : n1772;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1786 = n1746 ? 15'b111111111111111 : n1774;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1788 = n1746 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n1776;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1789 = n1746 ? series_term : n1777;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1790 = n1746 ? series_sum : n1778;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1791 = n1746 ? iteration_count : n1779;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1793 = n1869 ? 1'b1 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:1183:73  */
  assign n1794 = n1746 ? log_argument : n1780;
  /* TG68K_FPU_Transcendental.vhd:1211:87  */
  assign n1795 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1211:87  */
  assign n1797 = $signed(n1795) <= $signed(32'b00000000000000000000000000000101);
  /* TG68K_FPU_Transcendental.vhd:1213:92  */
  assign n1798 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1213:92  */
  assign n1800 = n1798 == 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1216:117  */
  assign n1801 = log_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1216:156  */
  assign n1802 = log_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1216:133  */
  assign n1803 = {16'b0, n1801};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1216:133  */
  assign n1804 = {16'b0, n1802};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1216:133  */
  assign n1805 = n1803 * n1804; // umul
  /* TG68K_FPU_Transcendental.vhd:1216:172  */
  assign n1807 = n1805 / 32'b00000000000000000000000000000010; // udiv
  /* TG68K_FPU_Transcendental.vhd:1216:89  */
  assign n1808 = {48'b0, n1807};  //  uext
  assign n1810 = n1808[78:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1219:133  */
  assign n1811 = series_sum - series_term;
  /* TG68K_FPU_Transcendental.vhd:1220:95  */
  assign n1812 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1220:95  */
  assign n1814 = n1812 == 32'b00000000000000000000000000000010;
  /* TG68K_FPU_Transcendental.vhd:1223:117  */
  assign n1815 = log_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1223:156  */
  assign n1816 = log_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1223:133  */
  assign n1817 = {16'b0, n1815};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1223:133  */
  assign n1818 = {16'b0, n1816};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1223:133  */
  assign n1819 = n1817 * n1818; // umul
  /* TG68K_FPU_Transcendental.vhd:1224:117  */
  assign n1820 = log_argument[63:48]; // extract
  /* TG68K_FPU_Transcendental.vhd:1223:172  */
  assign n1821 = {16'b0, n1819};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1223:172  */
  assign n1822 = {32'b0, n1820};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1223:172  */
  assign n1823 = n1821 * n1822; // umul
  /* TG68K_FPU_Transcendental.vhd:1224:133  */
  assign n1825 = n1823 / 48'b000000000000000000000000000000000000000000000011; // udiv
  /* TG68K_FPU_Transcendental.vhd:1223:89  */
  assign n1826 = {32'b0, n1825};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1226:133  */
  assign n1827 = series_sum + series_term;
  /* TG68K_FPU_Transcendental.vhd:1227:95  */
  assign n1828 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1227:95  */
  assign n1830 = n1828 == 32'b00000000000000000000000000000011;
  /* TG68K_FPU_Transcendental.vhd:1230:89  */
  assign n1832 = log_argument >> 31'b0000000000000000000000000000010;
  assign n1834 = n1832[78:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1233:133  */
  assign n1835 = series_sum - series_term;
  assign n1836 = {1'b1, n1834};
  /* TG68K_FPU_Transcendental.vhd:1227:73  */
  assign n1837 = n1830 ? n1836 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1227:73  */
  assign n1838 = n1830 ? n1835 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1220:73  */
  assign n1839 = n1814 ? n1826 : n1837;
  /* TG68K_FPU_Transcendental.vhd:1220:73  */
  assign n1840 = n1814 ? n1827 : n1838;
  assign n1841 = {1'b1, n1810};
  /* TG68K_FPU_Transcendental.vhd:1213:73  */
  assign n1842 = n1800 ? n1841 : n1839;
  /* TG68K_FPU_Transcendental.vhd:1213:73  */
  assign n1843 = n1800 ? n1811 : n1840;
  /* TG68K_FPU_Transcendental.vhd:1238:108  */
  assign n1844 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1238:108  */
  assign n1846 = n1844 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1238:92  */
  assign n1847 = n1846[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1242:98  */
  assign n1848 = series_sum[79]; // extract
  /* TG68K_FPU_Transcendental.vhd:1243:97  */
  assign n1849 = series_sum[78:64]; // extract
  /* TG68K_FPU_Transcendental.vhd:1244:98  */
  assign n1850 = series_sum[63:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1852 = n1797 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1853 = n1797 ? result_sign : n1848;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1854 = n1797 ? result_exp : n1849;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1855 = n1797 ? result_mant : n1850;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1856 = n1797 ? n1842 : series_term;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1857 = n1797 ? n1843 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1858 = n1797 ? n1847 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1211:65  */
  assign n1860 = n1797 ? 1'b1 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1861 = n1743 ? n1782 : n1852;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1862 = n1743 ? n1784 : n1853;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1863 = n1743 ? n1786 : n1854;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1864 = n1743 ? n1788 : n1855;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1865 = n1743 ? n1789 : n1856;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1866 = n1743 ? n1790 : n1857;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1867 = n1743 ? n1791 : n1858;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1868 = n1743 ? trans_inexact : n1860;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1869 = n1746 & n1743;
  /* TG68K_FPU_Transcendental.vhd:1182:65  */
  assign n1870 = n1743 ? n1794 : log_argument;
  /* TG68K_FPU_Transcendental.vhd:1180:57  */
  assign n1872 = operation_code == 7'b0000101;
  /* TG68K_FPU_Transcendental.vhd:1250:84  */
  assign n1873 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1250:84  */
  assign n1875 = n1873 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1258:116  */
  assign n1876 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1258:116  */
  assign n1878 = n1876 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1258:100  */
  assign n1879 = n1878[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1251:73  */
  assign n1881 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1251:73  */
  assign n1883 = input_zero ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1251:73  */
  assign n1885 = input_zero ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1251:73  */
  assign n1887 = input_zero ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1251:73  */
  assign n1888 = input_zero ? iteration_count : n1879;
  /* TG68K_FPU_Transcendental.vhd:1260:87  */
  assign n1889 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1260:87  */
  assign n1891 = $signed(n1889) < $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:1261:108  */
  assign n1892 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1261:108  */
  assign n1894 = n1892 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1261:92  */
  assign n1895 = n1894[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1265:117  */
  assign n1897 = $unsigned(input_exp) > $unsigned(15'b100000000000010);
  /* TG68K_FPU_Transcendental.vhd:1265:93  */
  assign n1898 = n1897 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:1271:90  */
  assign n1899 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:1271:120  */
  assign n1901 = $unsigned(input_exp) > $unsigned(15'b100000000000010);
  /* TG68K_FPU_Transcendental.vhd:1271:96  */
  assign n1902 = n1901 & n1899;
  /* TG68K_FPU_Transcendental.vhd:1280:171  */
  assign n1903 = input_mant[63:50]; // extract
  /* TG68K_FPU_Transcendental.vhd:1280:145  */
  assign n1904 = {1'b0, n1903};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1280:143  */
  assign n1906 = 15'b011111111111111 + n1904;
  /* TG68K_FPU_Transcendental.vhd:1271:73  */
  assign n1908 = n1902 ? 15'b111111111111111 : n1906;
  /* TG68K_FPU_Transcendental.vhd:1271:73  */
  assign n1910 = n1902 ? 1'b1 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1265:73  */
  assign n1912 = n1898 ? 15'b000000000000000 : n1908;
  /* TG68K_FPU_Transcendental.vhd:1265:73  */
  assign n1913 = n1898 ? trans_overflow : n1910;
  /* TG68K_FPU_Transcendental.vhd:1265:73  */
  assign n1915 = n1898 ? 1'b1 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1917 = n1891 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1919 = n1891 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1920 = n1891 ? result_exp : n1912;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1922 = n1891 ? result_mant : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1923 = n1891 ? n1895 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1924 = n1891 ? trans_overflow : n1913;
  /* TG68K_FPU_Transcendental.vhd:1260:65  */
  assign n1925 = n1891 ? trans_underflow : n1915;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1926 = n1875 ? n1881 : n1917;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1927 = n1875 ? n1883 : n1919;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1928 = n1875 ? n1885 : n1920;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1929 = n1875 ? n1887 : n1922;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1930 = n1875 ? n1888 : n1923;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1931 = n1875 ? trans_overflow : n1924;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1932 = n1875 ? trans_underflow : n1925;
  /* TG68K_FPU_Transcendental.vhd:1250:65  */
  assign n1934 = n1875 ? trans_inexact : 1'b1;
  /* TG68K_FPU_Transcendental.vhd:1248:57  */
  assign n1936 = operation_code == 7'b0010001;
  /* TG68K_FPU_Transcendental.vhd:1289:84  */
  assign n1937 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1289:84  */
  assign n1939 = n1937 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1297:116  */
  assign n1940 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1297:116  */
  assign n1942 = n1940 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1297:100  */
  assign n1943 = n1942[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1290:73  */
  assign n1945 = input_zero ? 3'b111 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:1290:73  */
  assign n1947 = input_zero ? 1'b0 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:1290:73  */
  assign n1949 = input_zero ? 15'b011111111111111 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1290:73  */
  assign n1951 = input_zero ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1290:73  */
  assign n1952 = input_zero ? iteration_count : n1943;
  /* TG68K_FPU_Transcendental.vhd:1299:87  */
  assign n1953 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1299:87  */
  assign n1955 = $signed(n1953) < $signed(32'b00000000000000000000000000000110);
  /* TG68K_FPU_Transcendental.vhd:1300:108  */
  assign n1956 = {28'b0, iteration_count};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1300:108  */
  assign n1958 = n1956 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1300:92  */
  assign n1959 = n1958[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1304:117  */
  assign n1961 = $unsigned(input_exp) > $unsigned(15'b100000000000001);
  /* TG68K_FPU_Transcendental.vhd:1304:93  */
  assign n1962 = n1961 & input_sign;
  /* TG68K_FPU_Transcendental.vhd:1310:90  */
  assign n1963 = ~input_sign;
  /* TG68K_FPU_Transcendental.vhd:1310:120  */
  assign n1965 = $unsigned(input_exp) > $unsigned(15'b100000000000001);
  /* TG68K_FPU_Transcendental.vhd:1310:96  */
  assign n1966 = n1965 & n1963;
  /* TG68K_FPU_Transcendental.vhd:1319:183  */
  assign n1967 = input_mant[63:49]; // extract
  /* TG68K_FPU_Transcendental.vhd:1319:152  */
  assign n1969 = n1967 >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1319:143  */
  assign n1971 = 15'b011111111111111 + n1969;
  /* TG68K_FPU_Transcendental.vhd:1310:73  */
  assign n1973 = n1966 ? 15'b111111111111111 : n1971;
  /* TG68K_FPU_Transcendental.vhd:1310:73  */
  assign n1975 = n1966 ? 1'b1 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:1304:73  */
  assign n1977 = n1962 ? 15'b000000000000000 : n1973;
  /* TG68K_FPU_Transcendental.vhd:1304:73  */
  assign n1978 = n1962 ? trans_overflow : n1975;
  /* TG68K_FPU_Transcendental.vhd:1304:73  */
  assign n1980 = n1962 ? 1'b1 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1982 = n1955 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1984 = n1955 ? result_sign : 1'b0;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1985 = n1955 ? result_exp : n1977;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1987 = n1955 ? result_mant : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1988 = n1955 ? n1959 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1989 = n1955 ? trans_overflow : n1978;
  /* TG68K_FPU_Transcendental.vhd:1299:65  */
  assign n1990 = n1955 ? trans_underflow : n1980;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1991 = n1939 ? n1945 : n1982;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1992 = n1939 ? n1947 : n1984;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1993 = n1939 ? n1949 : n1985;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1994 = n1939 ? n1951 : n1987;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1995 = n1939 ? n1952 : n1988;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1996 = n1939 ? trans_overflow : n1989;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1997 = n1939 ? trans_underflow : n1990;
  /* TG68K_FPU_Transcendental.vhd:1289:65  */
  assign n1999 = n1939 ? trans_inexact : 1'b1;
  /* TG68K_FPU_Transcendental.vhd:1287:57  */
  assign n2001 = operation_code == 7'b0010010;
  assign n2002 = {n2001, n1936, n1872, n1740, n1610, n1472, n1421, n1401, n1201, n1034, n885, n749, n616, n478, n448, n418, n315, n300, n288};
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2004 = n1991;
      19'b0100000000000000000: n2004 = n1926;
      19'b0010000000000000000: n2004 = n1861;
      19'b0001000000000000000: n2004 = n1728;
      19'b0000100000000000000: n2004 = n1598;
      19'b0000010000000000000: n2004 = n1463;
      19'b0000001000000000000: n2004 = n1413;
      19'b0000000100000000000: n2004 = n1387;
      19'b0000000010000000000: n2004 = n1187;
      19'b0000000001000000000: n2004 = n1021;
      19'b0000000000100000000: n2004 = n873;
      19'b0000000000010000000: n2004 = n736;
      19'b0000000000001000000: n2004 = n603;
      19'b0000000000000100000: n2004 = n471;
      19'b0000000000000010000: n2004 = n441;
      19'b0000000000000001000: n2004 = n408;
      19'b0000000000000000100: n2004 = n305;
      19'b0000000000000000010: n2004 = n293;
      19'b0000000000000000001: n2004 = n276;
      default: n2004 = 3'b111;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2005 = cordic_iteration;
      19'b0100000000000000000: n2005 = cordic_iteration;
      19'b0010000000000000000: n2005 = cordic_iteration;
      19'b0001000000000000000: n2005 = cordic_iteration;
      19'b0000100000000000000: n2005 = cordic_iteration;
      19'b0000010000000000000: n2005 = cordic_iteration;
      19'b0000001000000000000: n2005 = n1414;
      19'b0000000100000000000: n2005 = cordic_iteration;
      19'b0000000010000000000: n2005 = cordic_iteration;
      19'b0000000001000000000: n2005 = cordic_iteration;
      19'b0000000000100000000: n2005 = cordic_iteration;
      19'b0000000000010000000: n2005 = cordic_iteration;
      19'b0000000000001000000: n2005 = cordic_iteration;
      19'b0000000000000100000: n2005 = cordic_iteration;
      19'b0000000000000010000: n2005 = cordic_iteration;
      19'b0000000000000001000: n2005 = cordic_iteration;
      19'b0000000000000000100: n2005 = n307;
      19'b0000000000000000010: n2005 = n295;
      19'b0000000000000000001: n2005 = cordic_iteration;
      default: n2005 = cordic_iteration;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2007 = n1992;
      19'b0100000000000000000: n2007 = n1927;
      19'b0010000000000000000: n2007 = n1862;
      19'b0001000000000000000: n2007 = n1729;
      19'b0000100000000000000: n2007 = n1599;
      19'b0000010000000000000: n2007 = n1464;
      19'b0000001000000000000: n2007 = n1415;
      19'b0000000100000000000: n2007 = n1388;
      19'b0000000010000000000: n2007 = n1188;
      19'b0000000001000000000: n2007 = n1022;
      19'b0000000000100000000: n2007 = n874;
      19'b0000000000010000000: n2007 = n737;
      19'b0000000000001000000: n2007 = n604;
      19'b0000000000000100000: n2007 = n473;
      19'b0000000000000010000: n2007 = n443;
      19'b0000000000000001000: n2007 = n409;
      19'b0000000000000000100: n2007 = n309;
      19'b0000000000000000010: n2007 = n296;
      19'b0000000000000000001: n2007 = n277;
      default: n2007 = 1'b0;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2009 = n1993;
      19'b0100000000000000000: n2009 = n1928;
      19'b0010000000000000000: n2009 = n1863;
      19'b0001000000000000000: n2009 = n1730;
      19'b0000100000000000000: n2009 = n1600;
      19'b0000010000000000000: n2009 = n1465;
      19'b0000001000000000000: n2009 = n1417;
      19'b0000000100000000000: n2009 = n1389;
      19'b0000000010000000000: n2009 = n1189;
      19'b0000000001000000000: n2009 = n1023;
      19'b0000000000100000000: n2009 = n875;
      19'b0000000000010000000: n2009 = n738;
      19'b0000000000001000000: n2009 = n605;
      19'b0000000000000100000: n2009 = n474;
      19'b0000000000000010000: n2009 = n444;
      19'b0000000000000001000: n2009 = n410;
      19'b0000000000000000100: n2009 = n311;
      19'b0000000000000000010: n2009 = n297;
      19'b0000000000000000001: n2009 = n278;
      default: n2009 = 15'b111111111111111;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2011 = n1994;
      19'b0100000000000000000: n2011 = n1929;
      19'b0010000000000000000: n2011 = n1864;
      19'b0001000000000000000: n2011 = n1731;
      19'b0000100000000000000: n2011 = n1601;
      19'b0000010000000000000: n2011 = n1466;
      19'b0000001000000000000: n2011 = n1419;
      19'b0000000100000000000: n2011 = n1390;
      19'b0000000010000000000: n2011 = n1190;
      19'b0000000001000000000: n2011 = n1024;
      19'b0000000000100000000: n2011 = n876;
      19'b0000000000010000000: n2011 = n739;
      19'b0000000000001000000: n2011 = n606;
      19'b0000000000000100000: n2011 = n475;
      19'b0000000000000010000: n2011 = n445;
      19'b0000000000000001000: n2011 = n411;
      19'b0000000000000000100: n2011 = n313;
      19'b0000000000000000010: n2011 = n298;
      19'b0000000000000000001: n2011 = n279;
      default: n2011 = 64'b1100000000000000000000000000000000000000000000000000000000000000;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2012 = series_term;
      19'b0100000000000000000: n2012 = series_term;
      19'b0010000000000000000: n2012 = n1865;
      19'b0001000000000000000: n2012 = n1732;
      19'b0000100000000000000: n2012 = n1602;
      19'b0000010000000000000: n2012 = series_term;
      19'b0000001000000000000: n2012 = series_term;
      19'b0000000100000000000: n2012 = series_term;
      19'b0000000010000000000: n2012 = series_term;
      19'b0000000001000000000: n2012 = series_term;
      19'b0000000000100000000: n2012 = series_term;
      19'b0000000000010000000: n2012 = series_term;
      19'b0000000000001000000: n2012 = series_term;
      19'b0000000000000100000: n2012 = series_term;
      19'b0000000000000010000: n2012 = series_term;
      19'b0000000000000001000: n2012 = n412;
      19'b0000000000000000100: n2012 = series_term;
      19'b0000000000000000010: n2012 = series_term;
      19'b0000000000000000001: n2012 = series_term;
      default: n2012 = series_term;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2013 = series_sum;
      19'b0100000000000000000: n2013 = series_sum;
      19'b0010000000000000000: n2013 = n1866;
      19'b0001000000000000000: n2013 = n1733;
      19'b0000100000000000000: n2013 = n1603;
      19'b0000010000000000000: n2013 = series_sum;
      19'b0000001000000000000: n2013 = series_sum;
      19'b0000000100000000000: n2013 = n1391;
      19'b0000000010000000000: n2013 = n1191;
      19'b0000000001000000000: n2013 = n1025;
      19'b0000000000100000000: n2013 = n877;
      19'b0000000000010000000: n2013 = n740;
      19'b0000000000001000000: n2013 = n607;
      19'b0000000000000100000: n2013 = series_sum;
      19'b0000000000000010000: n2013 = series_sum;
      19'b0000000000000001000: n2013 = n413;
      19'b0000000000000000100: n2013 = series_sum;
      19'b0000000000000000010: n2013 = series_sum;
      19'b0000000000000000001: n2013 = series_sum;
      default: n2013 = series_sum;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2014 = n1995;
      19'b0100000000000000000: n2014 = n1930;
      19'b0010000000000000000: n2014 = n1867;
      19'b0001000000000000000: n2014 = n1734;
      19'b0000100000000000000: n2014 = n1604;
      19'b0000010000000000000: n2014 = n1467;
      19'b0000001000000000000: n2014 = iteration_count;
      19'b0000000100000000000: n2014 = n1392;
      19'b0000000010000000000: n2014 = n1192;
      19'b0000000001000000000: n2014 = n1026;
      19'b0000000000100000000: n2014 = n878;
      19'b0000000000010000000: n2014 = n741;
      19'b0000000000001000000: n2014 = n608;
      19'b0000000000000100000: n2014 = n476;
      19'b0000000000000010000: n2014 = n446;
      19'b0000000000000001000: n2014 = n414;
      19'b0000000000000000100: n2014 = iteration_count;
      19'b0000000000000000010: n2014 = iteration_count;
      19'b0000000000000000001: n2014 = n280;
      default: n2014 = iteration_count;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2015 = n1996;
      19'b0100000000000000000: n2015 = n1931;
      19'b0010000000000000000: n2015 = trans_overflow;
      19'b0001000000000000000: n2015 = n1735;
      19'b0000100000000000000: n2015 = n1605;
      19'b0000010000000000000: n2015 = trans_overflow;
      19'b0000001000000000000: n2015 = trans_overflow;
      19'b0000000100000000000: n2015 = trans_overflow;
      19'b0000000010000000000: n2015 = trans_overflow;
      19'b0000000001000000000: n2015 = trans_overflow;
      19'b0000000000100000000: n2015 = trans_overflow;
      19'b0000000000010000000: n2015 = trans_overflow;
      19'b0000000000001000000: n2015 = trans_overflow;
      19'b0000000000000100000: n2015 = trans_overflow;
      19'b0000000000000010000: n2015 = trans_overflow;
      19'b0000000000000001000: n2015 = trans_overflow;
      19'b0000000000000000100: n2015 = trans_overflow;
      19'b0000000000000000010: n2015 = trans_overflow;
      19'b0000000000000000001: n2015 = trans_overflow;
      default: n2015 = trans_overflow;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2016 = n1997;
      19'b0100000000000000000: n2016 = n1932;
      19'b0010000000000000000: n2016 = trans_underflow;
      19'b0001000000000000000: n2016 = n1736;
      19'b0000100000000000000: n2016 = n1606;
      19'b0000010000000000000: n2016 = trans_underflow;
      19'b0000001000000000000: n2016 = trans_underflow;
      19'b0000000100000000000: n2016 = trans_underflow;
      19'b0000000010000000000: n2016 = trans_underflow;
      19'b0000000001000000000: n2016 = trans_underflow;
      19'b0000000000100000000: n2016 = trans_underflow;
      19'b0000000000010000000: n2016 = trans_underflow;
      19'b0000000000001000000: n2016 = trans_underflow;
      19'b0000000000000100000: n2016 = trans_underflow;
      19'b0000000000000010000: n2016 = trans_underflow;
      19'b0000000000000001000: n2016 = trans_underflow;
      19'b0000000000000000100: n2016 = trans_underflow;
      19'b0000000000000000010: n2016 = trans_underflow;
      19'b0000000000000000001: n2016 = trans_underflow;
      default: n2016 = trans_underflow;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2019 = n1999;
      19'b0100000000000000000: n2019 = n1934;
      19'b0010000000000000000: n2019 = n1868;
      19'b0001000000000000000: n2019 = n1737;
      19'b0000100000000000000: n2019 = n1607;
      19'b0000010000000000000: n2019 = n1469;
      19'b0000001000000000000: n2019 = trans_inexact;
      19'b0000000100000000000: n2019 = n1393;
      19'b0000000010000000000: n2019 = n1193;
      19'b0000000001000000000: n2019 = n1027;
      19'b0000000000100000000: n2019 = n879;
      19'b0000000000010000000: n2019 = n742;
      19'b0000000000001000000: n2019 = n609;
      19'b0000000000000100000: n2019 = 1'b1;
      19'b0000000000000010000: n2019 = 1'b1;
      19'b0000000000000001000: n2019 = n415;
      19'b0000000000000000100: n2019 = trans_inexact;
      19'b0000000000000000010: n2019 = trans_inexact;
      19'b0000000000000000001: n2019 = n281;
      default: n2019 = trans_inexact;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2021 = trans_invalid;
      19'b0100000000000000000: n2021 = trans_invalid;
      19'b0010000000000000000: n2021 = n1793;
      19'b0001000000000000000: n2021 = trans_invalid;
      19'b0000100000000000000: n2021 = trans_invalid;
      19'b0000010000000000000: n2021 = n1449;
      19'b0000001000000000000: n2021 = trans_invalid;
      19'b0000000100000000000: n2021 = n1274;
      19'b0000000010000000000: n2021 = n1085;
      19'b0000000001000000000: n2021 = trans_invalid;
      19'b0000000000100000000: n2021 = trans_invalid;
      19'b0000000000010000000: n2021 = trans_invalid;
      19'b0000000000001000000: n2021 = trans_invalid;
      19'b0000000000000100000: n2021 = trans_invalid;
      19'b0000000000000010000: n2021 = trans_invalid;
      19'b0000000000000001000: n2021 = trans_invalid;
      19'b0000000000000000100: n2021 = trans_invalid;
      19'b0000000000000000010: n2021 = trans_invalid;
      19'b0000000000000000001: n2021 = trans_invalid;
      default: n2021 = 1'b1;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2022 = exp_argument;
      19'b0100000000000000000: n2022 = exp_argument;
      19'b0010000000000000000: n2022 = exp_argument;
      19'b0001000000000000000: n2022 = n1738;
      19'b0000100000000000000: n2022 = n1608;
      19'b0000010000000000000: n2022 = exp_argument;
      19'b0000001000000000000: n2022 = exp_argument;
      19'b0000000100000000000: n2022 = exp_argument;
      19'b0000000010000000000: n2022 = exp_argument;
      19'b0000000001000000000: n2022 = exp_argument;
      19'b0000000000100000000: n2022 = exp_argument;
      19'b0000000000010000000: n2022 = exp_argument;
      19'b0000000000001000000: n2022 = exp_argument;
      19'b0000000000000100000: n2022 = exp_argument;
      19'b0000000000000010000: n2022 = exp_argument;
      19'b0000000000000001000: n2022 = exp_argument;
      19'b0000000000000000100: n2022 = exp_argument;
      19'b0000000000000000010: n2022 = exp_argument;
      19'b0000000000000000001: n2022 = exp_argument;
      default: n2022 = exp_argument;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2023 = log_argument;
      19'b0100000000000000000: n2023 = log_argument;
      19'b0010000000000000000: n2023 = n1870;
      19'b0001000000000000000: n2023 = log_argument;
      19'b0000100000000000000: n2023 = log_argument;
      19'b0000010000000000000: n2023 = log_argument;
      19'b0000001000000000000: n2023 = log_argument;
      19'b0000000100000000000: n2023 = log_argument;
      19'b0000000010000000000: n2023 = log_argument;
      19'b0000000001000000000: n2023 = log_argument;
      19'b0000000000100000000: n2023 = log_argument;
      19'b0000000000010000000: n2023 = log_argument;
      19'b0000000000001000000: n2023 = log_argument;
      19'b0000000000000100000: n2023 = log_argument;
      19'b0000000000000010000: n2023 = log_argument;
      19'b0000000000000001000: n2023 = n416;
      19'b0000000000000000100: n2023 = log_argument;
      19'b0000000000000000010: n2023 = log_argument;
      19'b0000000000000000001: n2023 = log_argument;
      default: n2023 = log_argument;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2024 = x_squared;
      19'b0100000000000000000: n2024 = x_squared;
      19'b0010000000000000000: n2024 = x_squared;
      19'b0001000000000000000: n2024 = x_squared;
      19'b0000100000000000000: n2024 = x_squared;
      19'b0000010000000000000: n2024 = x_squared;
      19'b0000001000000000000: n2024 = x_squared;
      19'b0000000100000000000: n2024 = n1395;
      19'b0000000010000000000: n2024 = n1195;
      19'b0000000001000000000: n2024 = n1028;
      19'b0000000000100000000: n2024 = n880;
      19'b0000000000010000000: n2024 = n743;
      19'b0000000000001000000: n2024 = n610;
      19'b0000000000000100000: n2024 = x_squared;
      19'b0000000000000010000: n2024 = x_squared;
      19'b0000000000000001000: n2024 = x_squared;
      19'b0000000000000000100: n2024 = x_squared;
      19'b0000000000000000010: n2024 = x_squared;
      19'b0000000000000000001: n2024 = x_squared;
      default: n2024 = x_squared;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2025 = x_cubed;
      19'b0100000000000000000: n2025 = x_cubed;
      19'b0010000000000000000: n2025 = x_cubed;
      19'b0001000000000000000: n2025 = x_cubed;
      19'b0000100000000000000: n2025 = x_cubed;
      19'b0000010000000000000: n2025 = x_cubed;
      19'b0000001000000000000: n2025 = x_cubed;
      19'b0000000100000000000: n2025 = n1396;
      19'b0000000010000000000: n2025 = n1196;
      19'b0000000001000000000: n2025 = n1029;
      19'b0000000000100000000: n2025 = n881;
      19'b0000000000010000000: n2025 = n744;
      19'b0000000000001000000: n2025 = n611;
      19'b0000000000000100000: n2025 = x_cubed;
      19'b0000000000000010000: n2025 = x_cubed;
      19'b0000000000000001000: n2025 = x_cubed;
      19'b0000000000000000100: n2025 = x_cubed;
      19'b0000000000000000010: n2025 = x_cubed;
      19'b0000000000000000001: n2025 = x_cubed;
      default: n2025 = x_cubed;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2026 = x_fifth;
      19'b0100000000000000000: n2026 = x_fifth;
      19'b0010000000000000000: n2026 = x_fifth;
      19'b0001000000000000000: n2026 = x_fifth;
      19'b0000100000000000000: n2026 = x_fifth;
      19'b0000010000000000000: n2026 = x_fifth;
      19'b0000001000000000000: n2026 = x_fifth;
      19'b0000000100000000000: n2026 = n1397;
      19'b0000000010000000000: n2026 = n1197;
      19'b0000000001000000000: n2026 = n1030;
      19'b0000000000100000000: n2026 = n882;
      19'b0000000000010000000: n2026 = n745;
      19'b0000000000001000000: n2026 = n612;
      19'b0000000000000100000: n2026 = x_fifth;
      19'b0000000000000010000: n2026 = x_fifth;
      19'b0000000000000001000: n2026 = x_fifth;
      19'b0000000000000000100: n2026 = x_fifth;
      19'b0000000000000000010: n2026 = x_fifth;
      19'b0000000000000000001: n2026 = x_fifth;
      default: n2026 = x_fifth;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2027 = x3_div6;
      19'b0100000000000000000: n2027 = x3_div6;
      19'b0010000000000000000: n2027 = x3_div6;
      19'b0001000000000000000: n2027 = x3_div6;
      19'b0000100000000000000: n2027 = x3_div6;
      19'b0000010000000000000: n2027 = x3_div6;
      19'b0000001000000000000: n2027 = x3_div6;
      19'b0000000100000000000: n2027 = n1398;
      19'b0000000010000000000: n2027 = n1198;
      19'b0000000001000000000: n2027 = n1031;
      19'b0000000000100000000: n2027 = x3_div6;
      19'b0000000000010000000: n2027 = n746;
      19'b0000000000001000000: n2027 = n613;
      19'b0000000000000100000: n2027 = x3_div6;
      19'b0000000000000010000: n2027 = x3_div6;
      19'b0000000000000001000: n2027 = x3_div6;
      19'b0000000000000000100: n2027 = x3_div6;
      19'b0000000000000000010: n2027 = x3_div6;
      19'b0000000000000000001: n2027 = x3_div6;
      default: n2027 = x3_div6;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2028 = x5_div120;
      19'b0100000000000000000: n2028 = x5_div120;
      19'b0010000000000000000: n2028 = x5_div120;
      19'b0001000000000000000: n2028 = x5_div120;
      19'b0000100000000000000: n2028 = x5_div120;
      19'b0000010000000000000: n2028 = x5_div120;
      19'b0000001000000000000: n2028 = x5_div120;
      19'b0000000100000000000: n2028 = n1399;
      19'b0000000010000000000: n2028 = n1199;
      19'b0000000001000000000: n2028 = n1032;
      19'b0000000000100000000: n2028 = n883;
      19'b0000000000010000000: n2028 = n747;
      19'b0000000000001000000: n2028 = n614;
      19'b0000000000000100000: n2028 = x5_div120;
      19'b0000000000000010000: n2028 = x5_div120;
      19'b0000000000000001000: n2028 = x5_div120;
      19'b0000000000000000100: n2028 = x5_div120;
      19'b0000000000000000010: n2028 = x5_div120;
      19'b0000000000000000001: n2028 = x5_div120;
      default: n2028 = x5_div120;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2029 = x_n;
      19'b0100000000000000000: n2029 = x_n;
      19'b0010000000000000000: n2029 = x_n;
      19'b0001000000000000000: n2029 = x_n;
      19'b0000100000000000000: n2029 = x_n;
      19'b0000010000000000000: n2029 = x_n;
      19'b0000001000000000000: n2029 = x_n;
      19'b0000000100000000000: n2029 = x_n;
      19'b0000000010000000000: n2029 = x_n;
      19'b0000000001000000000: n2029 = x_n;
      19'b0000000000100000000: n2029 = x_n;
      19'b0000000000010000000: n2029 = x_n;
      19'b0000000000001000000: n2029 = x_n;
      19'b0000000000000100000: n2029 = x_n;
      19'b0000000000000010000: n2029 = x_n;
      19'b0000000000000001000: n2029 = x_n;
      19'b0000000000000000100: n2029 = x_n;
      19'b0000000000000000010: n2029 = x_n;
      19'b0000000000000000001: n2029 = n283;
      default: n2029 = x_n;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2030 = a_div_x_n;
      19'b0100000000000000000: n2030 = a_div_x_n;
      19'b0010000000000000000: n2030 = a_div_x_n;
      19'b0001000000000000000: n2030 = a_div_x_n;
      19'b0000100000000000000: n2030 = a_div_x_n;
      19'b0000010000000000000: n2030 = a_div_x_n;
      19'b0000001000000000000: n2030 = a_div_x_n;
      19'b0000000100000000000: n2030 = a_div_x_n;
      19'b0000000010000000000: n2030 = a_div_x_n;
      19'b0000000001000000000: n2030 = a_div_x_n;
      19'b0000000000100000000: n2030 = a_div_x_n;
      19'b0000000000010000000: n2030 = a_div_x_n;
      19'b0000000000001000000: n2030 = a_div_x_n;
      19'b0000000000000100000: n2030 = a_div_x_n;
      19'b0000000000000010000: n2030 = a_div_x_n;
      19'b0000000000000001000: n2030 = a_div_x_n;
      19'b0000000000000000100: n2030 = a_div_x_n;
      19'b0000000000000000010: n2030 = a_div_x_n;
      19'b0000000000000000001: n2030 = n284;
      default: n2030 = a_div_x_n;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2031 = x_next;
      19'b0100000000000000000: n2031 = x_next;
      19'b0010000000000000000: n2031 = x_next;
      19'b0001000000000000000: n2031 = x_next;
      19'b0000100000000000000: n2031 = x_next;
      19'b0000010000000000000: n2031 = x_next;
      19'b0000001000000000000: n2031 = x_next;
      19'b0000000100000000000: n2031 = x_next;
      19'b0000000010000000000: n2031 = x_next;
      19'b0000000001000000000: n2031 = x_next;
      19'b0000000000100000000: n2031 = x_next;
      19'b0000000000010000000: n2031 = x_next;
      19'b0000000000001000000: n2031 = x_next;
      19'b0000000000000100000: n2031 = x_next;
      19'b0000000000000010000: n2031 = x_next;
      19'b0000000000000001000: n2031 = x_next;
      19'b0000000000000000100: n2031 = x_next;
      19'b0000000000000000010: n2031 = x_next;
      19'b0000000000000000001: n2031 = n285;
      default: n2031 = x_next;
    endcase
  /* TG68K_FPU_Transcendental.vhd:356:49  */
  always @*
    case (n2002)
      19'b1000000000000000000: n2032 = final_mant;
      19'b0100000000000000000: n2032 = final_mant;
      19'b0010000000000000000: n2032 = final_mant;
      19'b0001000000000000000: n2032 = final_mant;
      19'b0000100000000000000: n2032 = final_mant;
      19'b0000010000000000000: n2032 = final_mant;
      19'b0000001000000000000: n2032 = final_mant;
      19'b0000000100000000000: n2032 = final_mant;
      19'b0000000010000000000: n2032 = final_mant;
      19'b0000000001000000000: n2032 = final_mant;
      19'b0000000000100000000: n2032 = final_mant;
      19'b0000000000010000000: n2032 = final_mant;
      19'b0000000000001000000: n2032 = final_mant;
      19'b0000000000000100000: n2032 = final_mant;
      19'b0000000000000010000: n2032 = final_mant;
      19'b0000000000000001000: n2032 = final_mant;
      19'b0000000000000000100: n2032 = final_mant;
      19'b0000000000000000010: n2032 = final_mant;
      19'b0000000000000000001: n2032 = n286;
      default: n2032 = final_mant;
    endcase
  /* TG68K_FPU_Transcendental.vhd:354:41  */
  assign n2034 = trans_state == 3'b011;
  /* TG68K_FPU_Transcendental.vhd:1335:41  */
  assign n2036 = trans_state == 3'b100;
  /* TG68K_FPU_Transcendental.vhd:1341:69  */
  assign n2037 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1341:69  */
  assign n2039 = n2037 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1350:118  */
  assign n2040 = input_mant[63:34]; // extract
  /* TG68K_FPU_Transcendental.vhd:1350:92  */
  assign n2041 = {34'b0, n2040};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1352:110  */
  assign n2042 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1352:110  */
  assign n2044 = n2042 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1352:93  */
  assign n2045 = n2044[4:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1344:65  */
  assign n2047 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:1344:78  */
  assign n2049 = operation_code == 7'b0011101;
  /* TG68K_FPU_Transcendental.vhd:1344:78  */
  assign n2050 = n2047 | n2049;
  /* TG68K_FPU_Transcendental.vhd:1355:118  */
  assign n2051 = input_mant[63:34]; // extract
  /* TG68K_FPU_Transcendental.vhd:1355:92  */
  assign n2052 = {34'b0, n2051};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1356:115  */
  assign n2053 = operand[39:10]; // extract
  /* TG68K_FPU_Transcendental.vhd:1356:92  */
  assign n2054 = {34'b0, n2053};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1359:110  */
  assign n2055 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1359:110  */
  assign n2057 = n2055 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1359:93  */
  assign n2058 = n2057[4:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1353:65  */
  assign n2060 = operation_code == 7'b0001010;
  assign n2061 = {n2060, n2050};
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2063 = trans_state;
      2'b01: n2063 = trans_state;
      default: n2063 = 3'b110;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2065 = n2052;
      2'b01: n2065 = 64'b0000000000000000000000000000000001101010000010011110011001100111;
      default: n2065 = cordic_x;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2067 = n2054;
      2'b01: n2067 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
      default: n2067 = cordic_y;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2069 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
      2'b01: n2069 = n2041;
      default: n2069 = cordic_z;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2070 = n2058;
      2'b01: n2070 = n2045;
      default: n2070 = cordic_iteration;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1343:57  */
  always @*
    case (n2061)
      2'b10: n2073 = 1'b1;
      2'b01: n2073 = 1'b0;
      default: n2073 = cordic_mode;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1364:72  */
  assign n2074 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1364:72  */
  assign n2076 = $signed(n2074) <= $signed(32'b00000000000000000000000000001111);
  /* TG68K_FPU_Transcendental.vhd:1367:114  */
  assign n2077 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1367:114  */
  assign n2079 = n2077 - 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1367:97  */
  assign n2080 = n2079[30:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1367:75  */
  assign n2081 = $signed(cordic_x) >>> n2080;
  /* TG68K_FPU_Transcendental.vhd:1368:114  */
  assign n2082 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1368:114  */
  assign n2084 = n2082 - 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1368:97  */
  assign n2085 = n2084[30:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1368:75  */
  assign n2086 = $signed(cordic_y) >>> n2085;
  /* TG68K_FPU_Transcendental.vhd:1369:118  */
  assign n2087 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1369:118  */
  assign n2089 = n2087 - 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1369:118  */
  assign n2090 = n2089[3:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1371:72  */
  assign n2096 = ~cordic_mode;
  /* TG68K_FPU_Transcendental.vhd:1373:77  */
  assign n2098 = $signed(cordic_z) >= $signed(64'b0000000000000000000000000000000000000000000000000000000000000000);
  /* TG68K_FPU_Transcendental.vhd:1375:94  */
  assign n2099 = cordic_x - cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:1376:94  */
  assign n2100 = cordic_y + cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:1377:94  */
  assign n2101 = cordic_z - cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:1380:94  */
  assign n2102 = cordic_x + cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:1381:94  */
  assign n2103 = cordic_y - cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:1382:94  */
  assign n2104 = cordic_z + cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:1373:65  */
  assign n2105 = n2098 ? n2099 : n2102;
  /* TG68K_FPU_Transcendental.vhd:1373:65  */
  assign n2106 = n2098 ? n2100 : n2103;
  /* TG68K_FPU_Transcendental.vhd:1373:65  */
  assign n2107 = n2098 ? n2101 : n2104;
  /* TG68K_FPU_Transcendental.vhd:1386:77  */
  assign n2109 = $signed(cordic_y) >= $signed(64'b0000000000000000000000000000000000000000000000000000000000000000);
  /* TG68K_FPU_Transcendental.vhd:1387:94  */
  assign n2110 = cordic_x + cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:1388:94  */
  assign n2111 = cordic_y - cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:1389:94  */
  assign n2112 = cordic_z + cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:1391:94  */
  assign n2113 = cordic_x - cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:1392:94  */
  assign n2114 = cordic_y + cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:1393:94  */
  assign n2115 = cordic_z - cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:1386:65  */
  assign n2116 = n2109 ? n2110 : n2113;
  /* TG68K_FPU_Transcendental.vhd:1386:65  */
  assign n2117 = n2109 ? n2111 : n2114;
  /* TG68K_FPU_Transcendental.vhd:1386:65  */
  assign n2118 = n2109 ? n2112 : n2115;
  /* TG68K_FPU_Transcendental.vhd:1371:57  */
  assign n2119 = n2096 ? n2105 : n2116;
  /* TG68K_FPU_Transcendental.vhd:1371:57  */
  assign n2120 = n2096 ? n2106 : n2117;
  /* TG68K_FPU_Transcendental.vhd:1371:57  */
  assign n2121 = n2096 ? n2107 : n2118;
  /* TG68K_FPU_Transcendental.vhd:1397:94  */
  assign n2122 = {27'b0, cordic_iteration};  //  uext
  /* TG68K_FPU_Transcendental.vhd:1397:94  */
  assign n2124 = n2122 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_Transcendental.vhd:1397:77  */
  assign n2125 = n2124[4:0];  // trunc
  /* TG68K_FPU_Transcendental.vhd:1405:121  */
  assign n2126 = $signed(cordic_y) >= 0 ? cordic_y : -cordic_y;
  /* TG68K_FPU_Transcendental.vhd:1401:65  */
  assign n2128 = operation_code == 7'b0001110;
  /* TG68K_FPU_Transcendental.vhd:1410:121  */
  assign n2129 = $signed(cordic_x) >= 0 ? cordic_x : -cordic_x;
  /* TG68K_FPU_Transcendental.vhd:1406:65  */
  assign n2131 = operation_code == 7'b0011101;
  /* TG68K_FPU_Transcendental.vhd:1413:96  */
  assign n2132 = cordic_z[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1415:121  */
  assign n2133 = $signed(cordic_z) >= 0 ? cordic_z : -cordic_z;
  /* TG68K_FPU_Transcendental.vhd:1411:65  */
  assign n2135 = operation_code == 7'b0001010;
  assign n2136 = {n2135, n2131, n2128};
  /* TG68K_FPU_Transcendental.vhd:1400:57  */
  always @*
    case (n2136)
      3'b100: n2140 = n2132;
      3'b010: n2140 = 1'b0;
      3'b001: n2140 = input_sign;
      default: n2140 = result_sign;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1400:57  */
  always @*
    case (n2136)
      3'b100: n2144 = 15'b011111111111111;
      3'b010: n2144 = 15'b011111111111110;
      3'b001: n2144 = 15'b011111111111110;
      default: n2144 = result_exp;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1400:57  */
  always @*
    case (n2136)
      3'b100: n2145 = n2133;
      3'b010: n2145 = n2129;
      3'b001: n2145 = n2126;
      default: n2145 = result_mant;
    endcase
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2147 = n2076 ? trans_state : 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2148 = n2076 ? n2119 : cordic_x;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2149 = n2076 ? n2120 : cordic_y;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2150 = n2076 ? n2121 : cordic_z;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2151 = n2076 ? n2125 : cordic_iteration;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2152 = n2076 ? result_sign : n2140;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2153 = n2076 ? result_exp : n2144;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2154 = n2076 ? result_mant : n2145;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2155 = n2076 ? n2081 : cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2156 = n2076 ? n2086 : cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:1364:49  */
  assign n2157 = n2076 ? n2584 : cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2158 = n2039 ? n2063 : n2147;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2159 = n2039 ? n2065 : n2148;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2160 = n2039 ? n2067 : n2149;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2161 = n2039 ? n2069 : n2150;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2162 = n2039 ? n2070 : n2151;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2163 = n2039 ? n2073 : cordic_mode;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2164 = n2039 ? result_sign : n2152;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2165 = n2039 ? result_exp : n2153;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2166 = n2039 ? result_mant : n2154;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2167 = n2039 ? cordic_shift_x : n2155;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2168 = n2039 ? cordic_shift_y : n2156;
  /* TG68K_FPU_Transcendental.vhd:1341:49  */
  assign n2169 = n2039 ? cordic_atan_val : n2157;
  /* TG68K_FPU_Transcendental.vhd:1339:41  */
  assign n2171 = trans_state == 3'b101;
  /* TG68K_FPU_Transcendental.vhd:1425:63  */
  assign n2173 = result_exp == 15'b000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1425:99  */
  assign n2175 = result_mant != 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1425:83  */
  assign n2176 = n2175 & n2173;
  /* TG68K_FPU_Transcendental.vhd:1427:71  */
  assign n2177 = result_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1427:76  */
  assign n2178 = ~n2177;
  /* TG68K_FPU_Transcendental.vhd:1429:79  */
  assign n2179 = result_mant[62]; // extract
  /* TG68K_FPU_Transcendental.vhd:1430:99  */
  assign n2180 = result_mant[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1430:113  */
  assign n2182 = {n2180, 1'b0};
  /* TG68K_FPU_Transcendental.vhd:1432:82  */
  assign n2183 = result_mant[61]; // extract
  /* TG68K_FPU_Transcendental.vhd:1433:99  */
  assign n2184 = result_mant[61:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1433:113  */
  assign n2186 = {n2184, 2'b00};
  /* TG68K_FPU_Transcendental.vhd:1437:99  */
  assign n2187 = result_mant[59:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1437:113  */
  assign n2189 = {n2187, 4'b0000};
  /* TG68K_FPU_Transcendental.vhd:1432:65  */
  assign n2192 = n2183 ? 15'b000000000000010 : 15'b000000000000100;
  /* TG68K_FPU_Transcendental.vhd:1432:65  */
  assign n2193 = n2183 ? n2186 : n2189;
  /* TG68K_FPU_Transcendental.vhd:1429:65  */
  assign n2195 = n2179 ? 15'b000000000000001 : n2192;
  /* TG68K_FPU_Transcendental.vhd:1429:65  */
  assign n2196 = n2179 ? n2182 : n2193;
  /* TG68K_FPU_Transcendental.vhd:1425:49  */
  assign n2197 = n2225 ? n2195 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:1427:57  */
  assign n2198 = n2178 ? n2196 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:1441:66  */
  assign n2200 = result_exp == 15'b111111111111111;
  /* TG68K_FPU_Transcendental.vhd:1443:71  */
  assign n2201 = result_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1443:97  */
  assign n2202 = result_mant[62:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1443:111  */
  assign n2204 = n2202 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Transcendental.vhd:1443:82  */
  assign n2205 = n2204 & n2201;
  assign n2207 = result_mant[62]; // extract
  /* TG68K_FPU_Transcendental.vhd:1443:57  */
  assign n2208 = n2205 ? n2207 : 1'b1;
  /* TG68K_FPU_Transcendental.vhd:1450:76  */
  assign n2210 = $unsigned(result_exp) > $unsigned(15'b000000000000000);
  /* TG68K_FPU_Transcendental.vhd:1450:105  */
  assign n2212 = $unsigned(result_exp) < $unsigned(15'b111111111111111);
  /* TG68K_FPU_Transcendental.vhd:1450:80  */
  assign n2213 = n2212 & n2210;
  /* TG68K_FPU_Transcendental.vhd:1452:71  */
  assign n2214 = result_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1452:76  */
  assign n2215 = ~n2214;
  assign n2217 = result_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1450:49  */
  assign n2218 = n2220 ? 1'b1 : n2217;
  /* TG68K_FPU_Transcendental.vhd:1450:49  */
  assign n2220 = n2215 & n2213;
  assign n2221 = result_mant[62]; // extract
  /* TG68K_FPU_Transcendental.vhd:1441:49  */
  assign n2222 = n2200 ? n2208 : n2221;
  assign n2223 = result_mant[63]; // extract
  /* TG68K_FPU_Transcendental.vhd:1441:49  */
  assign n2224 = n2200 ? n2223 : n2218;
  /* TG68K_FPU_Transcendental.vhd:1425:49  */
  assign n2225 = n2178 & n2176;
  assign n2226 = {n2224, n2222};
  assign n2227 = n2198[61:0]; // extract
  assign n2228 = result_mant[61:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:1425:49  */
  assign n2229 = n2176 ? n2227 : n2228;
  assign n2230 = n2198[63:62]; // extract
  /* TG68K_FPU_Transcendental.vhd:1425:49  */
  assign n2231 = n2176 ? n2230 : n2226;
  /* TG68K_FPU_Transcendental.vhd:1423:41  */
  assign n2233 = trans_state == 3'b110;
  /* TG68K_FPU_Transcendental.vhd:1460:71  */
  assign n2234 = {result_sign, result_exp};
  /* TG68K_FPU_Transcendental.vhd:1460:84  */
  assign n2235 = {n2234, result_mant};
  /* TG68K_FPU_Transcendental.vhd:1458:41  */
  assign n2237 = trans_state == 3'b111;
  assign n2238 = {n2237, n2233, n2171, n2036, n2034, n196, n106, n63};
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2240 = n2235;
      8'b01000000: n2240 = n2575;
      8'b00100000: n2240 = n2575;
      8'b00010000: n2240 = n2575;
      8'b00001000: n2240 = n2575;
      8'b00000100: n2240 = n2575;
      8'b00000010: n2240 = n2575;
      8'b00000001: n2240 = n2575;
      default: n2240 = 80'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2244 = 1'b1;
      8'b01000000: n2244 = n2577;
      8'b00100000: n2244 = n2577;
      8'b00010000: n2244 = n2577;
      8'b00001000: n2244 = n2577;
      8'b00000100: n2244 = n2577;
      8'b00000010: n2244 = n2577;
      8'b00000001: n2244 = 1'b0;
      default: n2244 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2247 = 1'b0;
      8'b01000000: n2247 = n2579;
      8'b00100000: n2247 = n2579;
      8'b00010000: n2247 = n2579;
      8'b00001000: n2247 = n2579;
      8'b00000100: n2247 = n2579;
      8'b00000010: n2247 = n2579;
      8'b00000001: n2247 = n54;
      default: n2247 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2251 = 1'b1;
      8'b01000000: n2251 = n2581;
      8'b00100000: n2251 = n2581;
      8'b00010000: n2251 = n2581;
      8'b00001000: n2251 = n2581;
      8'b00000100: n2251 = n2581;
      8'b00000010: n2251 = n2581;
      8'b00000001: n2251 = 1'b0;
      default: n2251 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2256 = 3'b000;
      8'b01000000: n2256 = 3'b111;
      8'b00100000: n2256 = n2158;
      8'b00010000: n2256 = 3'b110;
      8'b00001000: n2256 = n2004;
      8'b00000100: n2256 = n188;
      8'b00000010: n2256 = n99;
      8'b00000001: n2256 = n57;
      default: n2256 = 3'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2258 = cordic_x;
      8'b01000000: n2258 = cordic_x;
      8'b00100000: n2258 = n2159;
      8'b00010000: n2258 = cordic_x;
      8'b00001000: n2258 = cordic_x;
      8'b00000100: n2258 = cordic_x;
      8'b00000010: n2258 = cordic_x;
      8'b00000001: n2258 = cordic_x;
      default: n2258 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2260 = cordic_y;
      8'b01000000: n2260 = cordic_y;
      8'b00100000: n2260 = n2160;
      8'b00010000: n2260 = cordic_y;
      8'b00001000: n2260 = cordic_y;
      8'b00000100: n2260 = cordic_y;
      8'b00000010: n2260 = cordic_y;
      8'b00000001: n2260 = cordic_y;
      default: n2260 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2262 = cordic_z;
      8'b01000000: n2262 = cordic_z;
      8'b00100000: n2262 = n2161;
      8'b00010000: n2262 = cordic_z;
      8'b00001000: n2262 = cordic_z;
      8'b00000100: n2262 = cordic_z;
      8'b00000010: n2262 = cordic_z;
      8'b00000001: n2262 = cordic_z;
      default: n2262 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2264 = cordic_iteration;
      8'b01000000: n2264 = cordic_iteration;
      8'b00100000: n2264 = n2162;
      8'b00010000: n2264 = cordic_iteration;
      8'b00001000: n2264 = n2005;
      8'b00000100: n2264 = cordic_iteration;
      8'b00000010: n2264 = cordic_iteration;
      8'b00000001: n2264 = cordic_iteration;
      default: n2264 = 5'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2266 = cordic_mode;
      8'b01000000: n2266 = cordic_mode;
      8'b00100000: n2266 = n2163;
      8'b00010000: n2266 = cordic_mode;
      8'b00001000: n2266 = cordic_mode;
      8'b00000100: n2266 = cordic_mode;
      8'b00000010: n2266 = cordic_mode;
      8'b00000001: n2266 = cordic_mode;
      default: n2266 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2268 = result_sign;
      8'b01000000: n2268 = result_sign;
      8'b00100000: n2268 = n2164;
      8'b00010000: n2268 = result_sign;
      8'b00001000: n2268 = n2007;
      8'b00000100: n2268 = n189;
      8'b00000010: n2268 = n100;
      8'b00000001: n2268 = result_sign;
      default: n2268 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2270 = result_exp;
      8'b01000000: n2270 = n2197;
      8'b00100000: n2270 = n2165;
      8'b00010000: n2270 = result_exp;
      8'b00001000: n2270 = n2009;
      8'b00000100: n2270 = n190;
      8'b00000010: n2270 = n102;
      8'b00000001: n2270 = result_exp;
      default: n2270 = 15'bX;
    endcase
  assign n2271 = n103[61:0]; // extract
  assign n2272 = n191[61:0]; // extract
  assign n2273 = n2011[61:0]; // extract
  assign n2274 = n2166[61:0]; // extract
  assign n2275 = result_mant[61:0]; // extract
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2277 = n2275;
      8'b01000000: n2277 = n2229;
      8'b00100000: n2277 = n2274;
      8'b00010000: n2277 = n2275;
      8'b00001000: n2277 = n2273;
      8'b00000100: n2277 = n2272;
      8'b00000010: n2277 = n2271;
      8'b00000001: n2277 = n2275;
      default: n2277 = 62'bX;
    endcase
  assign n2278 = n103[63:62]; // extract
  assign n2279 = n191[63:62]; // extract
  assign n2280 = n2011[63:62]; // extract
  assign n2281 = n2166[63:62]; // extract
  assign n2282 = result_mant[63:62]; // extract
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2284 = n2282;
      8'b01000000: n2284 = n2231;
      8'b00100000: n2284 = n2281;
      8'b00010000: n2284 = n2282;
      8'b00001000: n2284 = n2280;
      8'b00000100: n2284 = n2279;
      8'b00000010: n2284 = n2278;
      8'b00000001: n2284 = n2282;
      default: n2284 = 2'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2288 = series_term;
      8'b01000000: n2288 = series_term;
      8'b00100000: n2288 = series_term;
      8'b00010000: n2288 = series_term;
      8'b00001000: n2288 = n2012;
      8'b00000100: n2288 = series_term;
      8'b00000010: n2288 = series_term;
      8'b00000001: n2288 = series_term;
      default: n2288 = 80'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2290 = series_sum;
      8'b01000000: n2290 = series_sum;
      8'b00100000: n2290 = series_sum;
      8'b00010000: n2290 = series_sum;
      8'b00001000: n2290 = n2013;
      8'b00000100: n2290 = series_sum;
      8'b00000010: n2290 = series_sum;
      8'b00000001: n2290 = series_sum;
      default: n2290 = 80'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2292 = iteration_count;
      8'b01000000: n2292 = iteration_count;
      8'b00100000: n2292 = iteration_count;
      8'b00010000: n2292 = iteration_count;
      8'b00001000: n2292 = n2014;
      8'b00000100: n2292 = iteration_count;
      8'b00000010: n2292 = iteration_count;
      8'b00000001: n2292 = n61;
      default: n2292 = 4'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2295 = trans_overflow;
      8'b01000000: n2295 = trans_overflow;
      8'b00100000: n2295 = trans_overflow;
      8'b00010000: n2295 = trans_overflow;
      8'b00001000: n2295 = n2015;
      8'b00000100: n2295 = trans_overflow;
      8'b00000010: n2295 = trans_overflow;
      8'b00000001: n2295 = 1'b0;
      default: n2295 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2298 = trans_underflow;
      8'b01000000: n2298 = trans_underflow;
      8'b00100000: n2298 = trans_underflow;
      8'b00010000: n2298 = trans_underflow;
      8'b00001000: n2298 = n2016;
      8'b00000100: n2298 = trans_underflow;
      8'b00000010: n2298 = trans_underflow;
      8'b00000001: n2298 = 1'b0;
      default: n2298 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2301 = trans_inexact;
      8'b01000000: n2301 = trans_inexact;
      8'b00100000: n2301 = trans_inexact;
      8'b00010000: n2301 = trans_inexact;
      8'b00001000: n2301 = n2019;
      8'b00000100: n2301 = trans_inexact;
      8'b00000010: n2301 = trans_inexact;
      8'b00000001: n2301 = 1'b0;
      default: n2301 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2304 = trans_invalid;
      8'b01000000: n2304 = trans_invalid;
      8'b00100000: n2304 = trans_invalid;
      8'b00010000: n2304 = trans_invalid;
      8'b00001000: n2304 = n2021;
      8'b00000100: n2304 = n192;
      8'b00000010: n2304 = n104;
      8'b00000001: n2304 = 1'b0;
      default: n2304 = 1'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2308 = exp_argument;
      8'b01000000: n2308 = exp_argument;
      8'b00100000: n2308 = exp_argument;
      8'b00010000: n2308 = exp_argument;
      8'b00001000: n2308 = n2022;
      8'b00000100: n2308 = exp_argument;
      8'b00000010: n2308 = exp_argument;
      8'b00000001: n2308 = exp_argument;
      default: n2308 = 80'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2310 = log_argument;
      8'b01000000: n2310 = log_argument;
      8'b00100000: n2310 = log_argument;
      8'b00010000: n2310 = log_argument;
      8'b00001000: n2310 = n2023;
      8'b00000100: n2310 = n194;
      8'b00000010: n2310 = log_argument;
      8'b00000001: n2310 = log_argument;
      default: n2310 = 80'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2312 = x_squared;
      8'b01000000: n2312 = x_squared;
      8'b00100000: n2312 = x_squared;
      8'b00010000: n2312 = x_squared;
      8'b00001000: n2312 = n2024;
      8'b00000100: n2312 = x_squared;
      8'b00000010: n2312 = x_squared;
      8'b00000001: n2312 = x_squared;
      default: n2312 = 128'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2314 = x_cubed;
      8'b01000000: n2314 = x_cubed;
      8'b00100000: n2314 = x_cubed;
      8'b00010000: n2314 = x_cubed;
      8'b00001000: n2314 = n2025;
      8'b00000100: n2314 = x_cubed;
      8'b00000010: n2314 = x_cubed;
      8'b00000001: n2314 = x_cubed;
      default: n2314 = 128'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2316 = x_fifth;
      8'b01000000: n2316 = x_fifth;
      8'b00100000: n2316 = x_fifth;
      8'b00010000: n2316 = x_fifth;
      8'b00001000: n2316 = n2026;
      8'b00000100: n2316 = x_fifth;
      8'b00000010: n2316 = x_fifth;
      8'b00000001: n2316 = x_fifth;
      default: n2316 = 128'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2318 = x3_div6;
      8'b01000000: n2318 = x3_div6;
      8'b00100000: n2318 = x3_div6;
      8'b00010000: n2318 = x3_div6;
      8'b00001000: n2318 = n2027;
      8'b00000100: n2318 = x3_div6;
      8'b00000010: n2318 = x3_div6;
      8'b00000001: n2318 = x3_div6;
      default: n2318 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2320 = cordic_shift_x;
      8'b01000000: n2320 = cordic_shift_x;
      8'b00100000: n2320 = n2167;
      8'b00010000: n2320 = cordic_shift_x;
      8'b00001000: n2320 = cordic_shift_x;
      8'b00000100: n2320 = cordic_shift_x;
      8'b00000010: n2320 = cordic_shift_x;
      8'b00000001: n2320 = cordic_shift_x;
      default: n2320 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2322 = cordic_shift_y;
      8'b01000000: n2322 = cordic_shift_y;
      8'b00100000: n2322 = n2168;
      8'b00010000: n2322 = cordic_shift_y;
      8'b00001000: n2322 = cordic_shift_y;
      8'b00000100: n2322 = cordic_shift_y;
      8'b00000010: n2322 = cordic_shift_y;
      8'b00000001: n2322 = cordic_shift_y;
      default: n2322 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2324 = cordic_atan_val;
      8'b01000000: n2324 = cordic_atan_val;
      8'b00100000: n2324 = n2169;
      8'b00010000: n2324 = cordic_atan_val;
      8'b00001000: n2324 = cordic_atan_val;
      8'b00000100: n2324 = cordic_atan_val;
      8'b00000010: n2324 = cordic_atan_val;
      8'b00000001: n2324 = cordic_atan_val;
      default: n2324 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2326 = x5_div120;
      8'b01000000: n2326 = x5_div120;
      8'b00100000: n2326 = x5_div120;
      8'b00010000: n2326 = x5_div120;
      8'b00001000: n2326 = n2028;
      8'b00000100: n2326 = x5_div120;
      8'b00000010: n2326 = x5_div120;
      8'b00000001: n2326 = x5_div120;
      default: n2326 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2328 = x_n;
      8'b01000000: n2328 = x_n;
      8'b00100000: n2328 = x_n;
      8'b00010000: n2328 = x_n;
      8'b00001000: n2328 = n2029;
      8'b00000100: n2328 = x_n;
      8'b00000010: n2328 = x_n;
      8'b00000001: n2328 = x_n;
      default: n2328 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2330 = a_div_x_n;
      8'b01000000: n2330 = a_div_x_n;
      8'b00100000: n2330 = a_div_x_n;
      8'b00010000: n2330 = a_div_x_n;
      8'b00001000: n2330 = n2030;
      8'b00000100: n2330 = a_div_x_n;
      8'b00000010: n2330 = a_div_x_n;
      8'b00000001: n2330 = a_div_x_n;
      default: n2330 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2332 = x_next;
      8'b01000000: n2332 = x_next;
      8'b00100000: n2332 = x_next;
      8'b00010000: n2332 = x_next;
      8'b00001000: n2332 = n2031;
      8'b00000100: n2332 = x_next;
      8'b00000010: n2332 = x_next;
      8'b00000001: n2332 = x_next;
      default: n2332 = 64'bX;
    endcase
  /* TG68K_FPU_Transcendental.vhd:232:33  */
  always @*
    case (n2238)
      8'b10000000: n2334 = final_mant;
      8'b01000000: n2334 = final_mant;
      8'b00100000: n2334 = final_mant;
      8'b00010000: n2334 = final_mant;
      8'b00001000: n2334 = n2032;
      8'b00000100: n2334 = final_mant;
      8'b00000010: n2334 = final_mant;
      8'b00000001: n2334 = final_mant;
      default: n2334 = 64'bX;
    endcase
  assign n2347 = {n2284, n2277};
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2454 = clkena ? n2256 : trans_state;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2455 <= 3'b000;
    else
      n2455 <= n2454;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2456 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2457 = clkena & n2456;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2458 = n2457 ? n2258 : cordic_x;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2459 <= n2458;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2460 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2461 = clkena & n2460;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2462 = n2461 ? n2260 : cordic_y;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2463 <= n2462;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2464 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2465 = clkena & n2464;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2466 = n2465 ? n2262 : cordic_z;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2467 <= n2466;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2468 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2469 = clkena & n2468;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2470 = n2469 ? n2264 : cordic_iteration;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2471 <= n2470;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2472 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2473 = clkena & n2472;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2474 = n2473 ? n2266 : cordic_mode;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2475 <= n2474;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2476 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2477 = clkena & n2476;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2478 = n2477 ? n2268 : result_sign;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2479 <= n2478;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2480 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2481 = clkena & n2480;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2482 = n2481 ? n2270 : result_exp;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2483 <= n2482;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2484 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2485 = clkena & n2484;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2486 = n2485 ? n2347 : result_mant;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2487 <= n2486;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2492 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2493 = clkena & n2492;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2494 = n2493 ? n2288 : series_term;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2495 <= n2494;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2496 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2497 = clkena & n2496;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2498 = n2497 ? n2290 : series_sum;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2499 <= n2498;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2500 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2501 = clkena & n2500;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2502 = n2501 ? n2292 : iteration_count;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2503 <= n2502;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2504 = clkena ? n2295 : trans_overflow;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2505 <= 1'b0;
    else
      n2505 <= n2504;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2506 = clkena ? n2298 : trans_underflow;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2507 <= 1'b0;
    else
      n2507 <= n2506;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2508 = clkena ? n2301 : trans_inexact;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2509 <= 1'b0;
    else
      n2509 <= n2508;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2510 = clkena ? n2304 : trans_invalid;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2511 <= 1'b0;
    else
      n2511 <= n2510;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2516 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2517 = clkena & n2516;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2518 = n2517 ? n2308 : exp_argument;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2519 <= n2518;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2520 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2521 = clkena & n2520;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2522 = n2521 ? n2310 : log_argument;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2523 <= n2522;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2525 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2526 = clkena & n2525;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2527 = n2526 ? n2312 : x_squared;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2528 <= n2527;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2529 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2530 = clkena & n2529;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2531 = n2530 ? n2314 : x_cubed;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2532 <= n2531;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2533 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2534 = clkena & n2533;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2535 = n2534 ? n2316 : x_fifth;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2536 <= n2535;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2537 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2538 = clkena & n2537;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2539 = n2538 ? n2318 : x3_div6;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2540 <= n2539;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2541 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2542 = clkena & n2541;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2543 = n2542 ? n2320 : cordic_shift_x;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2544 <= n2543;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2545 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2546 = clkena & n2545;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2547 = n2546 ? n2322 : cordic_shift_y;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2548 <= n2547;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2549 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2550 = clkena & n2549;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2551 = n2550 ? n2324 : cordic_atan_val;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2552 <= n2551;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2553 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2554 = clkena & n2553;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2555 = n2554 ? n2326 : x5_div120;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2556 <= n2555;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2558 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2559 = clkena & n2558;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2560 = n2559 ? n2328 : x_n;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2561 <= n2560;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2562 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2563 = clkena & n2562;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2564 = n2563 ? n2330 : a_div_x_n;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2565 <= n2564;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2566 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2567 = clkena & n2566;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2568 = n2567 ? n2332 : x_next;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2569 <= n2568;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2570 = ~n50;
  /* TG68K_FPU_Transcendental.vhd:217:9  */
  assign n2571 = clkena & n2570;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2572 = n2571 ? n2334 : final_mant;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk)
    n2573 <= n2572;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2574 = clkena ? n2240 : n2575;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2575 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n2575 <= n2574;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2576 = clkena ? n2244 : n2577;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2577 <= 1'b0;
    else
      n2577 <= n2576;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2578 = clkena ? n2247 : n2579;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2579 <= 1'b0;
    else
      n2579 <= n2578;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  assign n2580 = clkena ? n2251 : n2581;
  /* TG68K_FPU_Transcendental.vhd:230:17  */
  always @(posedge clk or posedge n50)
    if (n50)
      n2581 <= 1'b0;
    else
      n2581 <= n2580;
  /* TG68K_FPU_Transcendental.vhd:1369:118  */
  reg [63:0] n2582[15:0] ; // memory
  initial begin
    n2582[15] = 64'b0000000000000001111111111111111111111111111111111111111111111111;
    n2582[14] = 64'b0000000000000011111111111111111111111111111111111111111010101011;
    n2582[13] = 64'b0000000000000111111111111111111111111111111111111111010101010101;
    n2582[12] = 64'b0000000000001111111111111111111111111111111110101010101010101011;
    n2582[11] = 64'b0000000000011111111111111111111111111110101010101010101010101011;
    n2582[10] = 64'b0000000000111111111111111111111111110101010101011010101010101011;
    n2582[9] = 64'b0000000001111111111111111111110101010101010110101011101110011101;
    n2582[8] = 64'b0000000011111111111111111010101010101011010101010101011101101011;
    n2582[7] = 64'b0000000111111111111111010101010101011011101110111001011101110110;
    n2582[6] = 64'b0000001111111111111010101010101101110111010101110011101010111010;
    n2582[5] = 64'b0000011111111111010101010110111011101010010111110111101001011110;
    n2582[4] = 64'b0000111111111010101011011110100011010101101110001111000010111011;
    n2582[3] = 64'b0001111111010101101110101001101010101100001011110110101011000101;
    n2582[2] = 64'b0011111010110110111010111111001011011001001001111101101011010100;
    n2582[1] = 64'b0111011010110001100111000001010110000110010100001001111100100110;
    n2582[0] = 64'b1100100100001111110110101010001000100001011010001100001000110101;
    end
  assign n2584 = n2582[n2090];
  /* TG68K_FPU_Transcendental.vhd:1369:118  */
endmodule

