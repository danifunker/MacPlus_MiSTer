module TG68K_FPU_ALU
  (input  clk,
   input  nReset,
   input  clkena,
   input  start_operation,
   input  [6:0] operation_code,
   input  [1:0] rounding_mode,
   input  [79:0] operand_a,
   input  [79:0] operand_b,
   output [79:0] result,
   output result_valid,
   output overflow,
   output underflow,
   output inexact,
   output invalid,
   output divide_by_zero,
   output [7:0] quotient_byte,
   output operation_busy,
   output operation_done);
  wire sign_a;
  wire sign_b;
  wire sign_result;
  wire [14:0] exp_a;
  wire [14:0] exp_b;
  wire [14:0] exp_result;
  wire [63:0] mant_a;
  wire [63:0] mant_b;
  wire [63:0] mant_result;
  reg [2:0] alu_state;
  wire [64:0] mant_sum;
  wire [64:0] mant_a_aligned;
  wire [64:0] mant_b_aligned;
  wire [14:0] exp_larger;
  wire guard_bit;
  wire round_bit;
  wire sticky_bit;
  wire [127:0] mult_result;
  reg [7:0] fmod_quotient;
  wire is_zero_a;
  wire is_zero_b;
  wire is_inf_a;
  wire is_inf_b;
  wire is_nan_a;
  wire is_nan_b;
  wire is_denorm_a;
  wire is_denorm_b;
  wire is_snan_a;
  wire is_snan_b;
  wire flags_overflow;
  wire flags_underflow;
  wire flags_inexact;
  wire flags_invalid;
  wire flags_div_by_zero;
  wire [14:0] n13;
  wire n15;
  wire [63:0] n16;
  wire n18;
  wire n21;
  wire n24;
  wire [14:0] n25;
  wire n27;
  wire [63:0] n28;
  wire n30;
  wire n31;
  wire n32;
  wire [61:0] n33;
  wire n35;
  wire n36;
  wire n39;
  wire n45;
  wire n48;
  wire n50;
  wire n54;
  wire n56;
  wire n58;
  wire n62;
  wire n64;
  wire n66;
  wire n68;
  wire n70;
  wire [14:0] n73;
  wire n75;
  wire [63:0] n76;
  wire n78;
  wire n81;
  wire n84;
  wire [14:0] n85;
  wire n87;
  wire [63:0] n88;
  wire n90;
  wire n91;
  wire n92;
  wire [61:0] n93;
  wire n95;
  wire n96;
  wire n99;
  wire n105;
  wire n108;
  wire n110;
  wire n114;
  wire n116;
  wire n118;
  wire n122;
  wire n124;
  wire n126;
  wire n128;
  wire n130;
  wire n138;
  wire n142;
  wire [2:0] n145;
  wire n147;
  wire n149;
  wire n150;
  wire [14:0] n151;
  wire [63:0] n152;
  wire n153;
  wire [14:0] n154;
  wire [63:0] n155;
  wire n157;
  wire n158;
  wire [14:0] n159;
  wire [63:0] n160;
  wire n162;
  wire n163;
  wire n164;
  wire n165;
  wire n166;
  wire [14:0] n167;
  wire [63:0] n168;
  wire n170;
  wire n171;
  wire n172;
  wire n173;
  wire n174;
  wire n175;
  wire n176;
  wire [14:0] n178;
  wire [63:0] n180;
  wire [2:0] n183;
  wire n184;
  wire [14:0] n185;
  wire [63:0] n186;
  wire [2:0] n188;
  wire n189;
  wire [14:0] n190;
  wire [63:0] n191;
  wire [2:0] n193;
  wire n195;
  wire n197;
  wire n199;
  wire n200;
  wire n202;
  wire n203;
  wire n204;
  wire [30:0] n205;
  wire [31:0] n206;
  wire [31:0] n208;
  wire [31:0] n210;
  wire [31:0] n212;
  wire [30:0] n213;
  wire [14:0] n214;
  wire [1:0] n215;
  wire n217;
  wire [1:0] n218;
  wire n220;
  wire [1:0] n221;
  wire n223;
  wire [63:0] n226;
  wire [63:0] n228;
  wire [63:0] n230;
  wire n231;
  wire [62:0] n232;
  wire [63:0] n233;
  wire [63:0] n234;
  wire [63:0] n235;
  wire [14:0] n237;
  wire [63:0] n239;
  wire n241;
  wire [14:0] n244;
  wire [63:0] n246;
  wire n247;
  wire [14:0] n250;
  wire [63:0] n252;
  wire n253;
  wire n255;
  wire n258;
  wire n259;
  wire n260;
  wire n262;
  wire n263;
  wire n264;
  wire n266;
  wire [63:0] n269;
  wire n271;
  wire n272;
  wire n273;
  wire n274;
  wire n275;
  wire n276;
  wire n278;
  wire [64:0] n280;
  wire [64:0] n282;
  wire [64:0] n283;
  wire n285;
  wire [64:0] n287;
  wire [64:0] n289;
  wire [64:0] n290;
  wire n291;
  wire [64:0] n292;
  wire n293;
  wire [64:0] n294;
  wire [64:0] n295;
  wire n296;
  wire [64:0] n297;
  wire n298;
  wire [64:0] n299;
  wire n300;
  wire [64:0] n303;
  wire [14:0] n304;
  wire n306;
  wire [64:0] n311;
  wire [14:0] n312;
  wire [30:0] n313;
  wire [64:0] n314;
  wire [64:0] n317;
  wire [64:0] n320;
  wire [14:0] n321;
  wire n323;
  wire [64:0] n328;
  wire [14:0] n329;
  wire [30:0] n330;
  wire [64:0] n331;
  wire [64:0] n334;
  wire [64:0] n337;
  wire [64:0] n338;
  wire [14:0] n339;
  wire n341;
  wire [64:0] n342;
  wire n343;
  wire [64:0] n344;
  wire [64:0] n345;
  wire n346;
  wire [64:0] n347;
  wire n348;
  wire [64:0] n349;
  wire n350;
  wire [14:0] n352;
  wire [63:0] n353;
  wire n354;
  wire n355;
  wire [14:0] n357;
  wire [62:0] n358;
  wire [63:0] n360;
  wire [63:0] n361;
  wire [14:0] n362;
  wire [63:0] n363;
  wire [14:0] n364;
  wire [63:0] n365;
  wire n366;
  wire [14:0] n367;
  wire [63:0] n368;
  wire [64:0] n369;
  wire [64:0] n372;
  wire [64:0] n373;
  wire [14:0] n375;
  wire n377;
  wire [14:0] n378;
  wire [63:0] n379;
  wire [64:0] n380;
  wire [64:0] n383;
  wire [64:0] n384;
  wire [14:0] n385;
  wire n387;
  wire [14:0] n388;
  wire [63:0] n389;
  wire [64:0] n390;
  wire [64:0] n393;
  wire [64:0] n394;
  wire [14:0] n395;
  wire n397;
  wire [14:0] n399;
  wire [63:0] n401;
  wire [64:0] n402;
  wire [64:0] n405;
  wire [64:0] n406;
  wire [14:0] n407;
  wire n409;
  wire [14:0] n411;
  wire [63:0] n413;
  wire [64:0] n414;
  wire [64:0] n417;
  wire [64:0] n418;
  wire [14:0] n419;
  wire n421;
  wire [14:0] n423;
  wire [63:0] n424;
  wire [64:0] n425;
  wire [64:0] n428;
  wire [64:0] n429;
  wire [14:0] n430;
  wire n432;
  wire n434;
  wire [14:0] n436;
  wire [63:0] n438;
  wire [64:0] n439;
  wire [64:0] n442;
  wire [64:0] n443;
  wire [14:0] n444;
  wire n446;
  wire n448;
  wire n449;
  wire n450;
  wire n451;
  wire n453;
  wire [63:0] n456;
  wire n458;
  wire n459;
  wire n460;
  wire n461;
  wire n462;
  wire n463;
  wire n464;
  wire n465;
  wire n467;
  wire [64:0] n469;
  wire [64:0] n471;
  wire [64:0] n472;
  wire n474;
  wire [64:0] n476;
  wire [64:0] n478;
  wire [64:0] n479;
  wire n480;
  wire n481;
  wire [64:0] n482;
  wire [64:0] n483;
  wire n484;
  wire n485;
  wire [64:0] n486;
  wire [64:0] n487;
  wire n488;
  wire [64:0] n489;
  wire n490;
  wire [64:0] n493;
  wire [14:0] n494;
  wire n496;
  wire [64:0] n498;
  wire [14:0] n499;
  wire [30:0] n500;
  wire [64:0] n501;
  wire [64:0] n503;
  wire [64:0] n506;
  wire [14:0] n507;
  wire n509;
  wire [64:0] n511;
  wire [14:0] n512;
  wire [30:0] n513;
  wire [64:0] n514;
  wire [64:0] n516;
  wire [64:0] n518;
  wire [64:0] n519;
  wire [14:0] n520;
  wire n521;
  wire [64:0] n522;
  wire n523;
  wire [64:0] n524;
  wire [64:0] n525;
  wire n526;
  wire n527;
  wire [64:0] n528;
  wire n529;
  wire [64:0] n530;
  wire n531;
  wire [14:0] n533;
  wire [63:0] n534;
  wire n535;
  wire n536;
  wire [14:0] n538;
  wire [62:0] n539;
  wire [63:0] n541;
  wire [63:0] n542;
  wire [14:0] n543;
  wire [63:0] n544;
  wire [14:0] n545;
  wire [63:0] n546;
  wire n547;
  wire [14:0] n548;
  wire [63:0] n549;
  wire [64:0] n550;
  wire [64:0] n552;
  wire [64:0] n553;
  wire [14:0] n555;
  wire n556;
  wire [14:0] n557;
  wire [63:0] n558;
  wire [64:0] n559;
  wire [64:0] n561;
  wire [64:0] n562;
  wire [14:0] n563;
  wire n564;
  wire [14:0] n565;
  wire [63:0] n566;
  wire [64:0] n567;
  wire [64:0] n569;
  wire [64:0] n570;
  wire [14:0] n571;
  wire n572;
  wire [14:0] n574;
  wire [63:0] n576;
  wire [64:0] n577;
  wire [64:0] n579;
  wire [64:0] n580;
  wire [14:0] n581;
  wire n582;
  wire [14:0] n584;
  wire [63:0] n586;
  wire [64:0] n587;
  wire [64:0] n589;
  wire [64:0] n590;
  wire [14:0] n591;
  wire n592;
  wire [14:0] n594;
  wire [63:0] n595;
  wire [64:0] n596;
  wire [64:0] n598;
  wire [64:0] n599;
  wire [14:0] n600;
  wire n601;
  wire n603;
  wire [14:0] n605;
  wire [63:0] n607;
  wire [64:0] n608;
  wire [64:0] n610;
  wire [64:0] n611;
  wire [14:0] n612;
  wire n614;
  wire n616;
  wire n617;
  wire n618;
  wire n619;
  wire n620;
  wire n621;
  wire n622;
  wire n623;
  wire [14:0] n624;
  wire [14:0] n626;
  wire [127:0] n627;
  wire [127:0] n628;
  wire [127:0] n629;
  wire n630;
  wire [14:0] n632;
  wire [63:0] n633;
  wire [63:0] n634;
  wire [14:0] n635;
  wire [63:0] n636;
  wire [61:0] n637;
  wire n639;
  wire n641;
  wire [14:0] n643;
  wire [63:0] n645;
  wire [127:0] n646;
  wire n647;
  wire [14:0] n649;
  wire [63:0] n651;
  wire [127:0] n652;
  wire n653;
  wire n655;
  wire [14:0] n657;
  wire [63:0] n659;
  wire [127:0] n660;
  wire n661;
  wire n663;
  wire n665;
  wire [14:0] n667;
  wire [63:0] n669;
  wire [127:0] n670;
  wire n671;
  wire n673;
  wire n675;
  wire n676;
  wire n677;
  wire n678;
  wire n679;
  wire n680;
  wire n681;
  wire n682;
  wire n683;
  wire n684;
  wire n685;
  wire n690;
  wire [31:0] n691;
  wire n693;
  wire [14:0] n695;
  wire [14:0] n697;
  wire n698;
  wire n699;
  wire [14:0] n701;
  wire [63:0] n703;
  wire n707;
  wire [14:0] n708;
  wire [14:0] n710;
  wire [31:0] n711;
  wire n713;
  wire [63:0] n715;
  wire [31:0] n716;
  wire [63:0] n717;
  wire [63:0] n718;
  wire [47:0] n719;
  wire n721;
  wire [63:0] n723;
  wire [47:0] n724;
  wire [63:0] n725;
  wire [63:0] n726;
  wire [62:0] n727;
  wire [63:0] n728;
  wire [63:0] n729;
  wire [63:0] n730;
  wire [63:0] n731;
  wire [14:0] n733;
  wire [63:0] n735;
  wire n737;
  wire [14:0] n739;
  wire [63:0] n741;
  wire n742;
  wire [14:0] n744;
  wire [63:0] n746;
  wire n747;
  wire n748;
  wire [14:0] n749;
  wire [63:0] n750;
  wire n752;
  wire n753;
  wire n754;
  wire [14:0] n756;
  wire [63:0] n758;
  wire n760;
  wire n761;
  wire n763;
  wire n765;
  wire [14:0] n767;
  wire [63:0] n769;
  wire n771;
  wire n772;
  wire n774;
  wire n775;
  wire n777;
  wire [14:0] n779;
  wire [63:0] n781;
  wire n783;
  wire n784;
  wire n786;
  wire n787;
  wire n789;
  wire n791;
  wire n792;
  wire n793;
  wire n795;
  wire n796;
  wire n797;
  wire n799;
  wire n802;
  wire n803;
  wire n804;
  wire n807;
  wire n808;
  wire n809;
  wire n812;
  wire n813;
  wire n814;
  wire n815;
  wire [78:0] n816;
  wire [78:0] n817;
  wire n818;
  wire n819;
  wire n822;
  wire n824;
  wire n825;
  wire n826;
  wire n828;
  wire n830;
  wire n833;
  wire n835;
  wire n837;
  wire n838;
  wire n840;
  wire n842;
  wire n843;
  wire n844;
  wire [14:0] n847;
  wire [63:0] n850;
  wire [30:0] n851;
  wire [31:0] n852;
  wire [31:0] n854;
  wire n856;
  wire n858;
  wire [31:0] n860;
  wire n862;
  wire n864;
  wire n865;
  wire [31:0] n867;
  wire n869;
  wire n871;
  wire n872;
  wire [31:0] n874;
  wire n876;
  wire n878;
  wire n879;
  wire [31:0] n881;
  wire n883;
  wire n885;
  wire n886;
  wire [31:0] n888;
  wire n890;
  wire n892;
  wire n893;
  wire [31:0] n895;
  wire n897;
  wire n899;
  wire n900;
  wire [31:0] n902;
  wire n904;
  wire n906;
  wire n907;
  wire [31:0] n909;
  wire n911;
  wire n913;
  wire n914;
  wire [31:0] n916;
  wire n918;
  wire n920;
  wire n921;
  wire [31:0] n923;
  wire n925;
  wire n927;
  wire n928;
  wire [31:0] n930;
  wire n932;
  wire n934;
  wire n935;
  wire [31:0] n937;
  wire n939;
  wire n941;
  wire n942;
  wire [31:0] n944;
  wire n946;
  wire n948;
  wire n949;
  wire [31:0] n951;
  wire n953;
  wire n955;
  wire n956;
  wire [31:0] n958;
  wire n960;
  wire n962;
  wire n963;
  wire [31:0] n965;
  wire n967;
  wire n969;
  wire n970;
  wire [31:0] n972;
  wire n974;
  wire n976;
  wire n977;
  wire [31:0] n979;
  wire n981;
  wire n983;
  wire n984;
  wire [31:0] n986;
  wire n988;
  wire n990;
  wire n991;
  wire [31:0] n993;
  wire n995;
  wire n997;
  wire n998;
  wire [31:0] n1000;
  wire n1002;
  wire n1004;
  wire n1005;
  wire [31:0] n1007;
  wire n1009;
  wire n1011;
  wire n1012;
  wire [31:0] n1014;
  wire n1016;
  wire n1018;
  wire n1019;
  wire [31:0] n1021;
  wire n1023;
  wire n1025;
  wire n1026;
  wire [31:0] n1028;
  wire n1030;
  wire n1032;
  wire n1033;
  wire [31:0] n1035;
  wire n1037;
  wire n1039;
  wire n1040;
  wire [31:0] n1042;
  wire n1044;
  wire n1046;
  wire n1047;
  wire [31:0] n1049;
  wire n1051;
  wire n1053;
  wire n1054;
  wire [31:0] n1056;
  wire n1058;
  wire n1060;
  wire n1061;
  wire [31:0] n1063;
  wire n1065;
  wire n1067;
  wire n1068;
  wire [31:0] n1070;
  wire n1072;
  wire n1074;
  wire n1075;
  wire [31:0] n1077;
  wire n1079;
  wire n1081;
  wire n1082;
  wire [31:0] n1084;
  wire n1086;
  wire n1088;
  wire n1089;
  wire [31:0] n1091;
  wire n1093;
  wire n1095;
  wire n1096;
  wire [31:0] n1098;
  wire n1100;
  wire n1102;
  wire n1103;
  wire [31:0] n1105;
  wire n1107;
  wire n1109;
  wire n1110;
  wire [31:0] n1112;
  wire n1114;
  wire n1116;
  wire n1117;
  wire [31:0] n1119;
  wire n1121;
  wire n1123;
  wire n1124;
  wire [31:0] n1126;
  wire n1128;
  wire n1130;
  wire n1131;
  wire [31:0] n1133;
  wire n1135;
  wire n1137;
  wire n1138;
  wire [31:0] n1140;
  wire n1142;
  wire n1144;
  wire n1145;
  wire [31:0] n1147;
  wire n1149;
  wire n1151;
  wire n1152;
  wire [31:0] n1154;
  wire n1156;
  wire n1158;
  wire n1159;
  wire [31:0] n1161;
  wire n1163;
  wire n1165;
  wire n1166;
  wire [31:0] n1168;
  wire n1170;
  wire n1172;
  wire n1173;
  wire [31:0] n1175;
  wire n1177;
  wire n1179;
  wire n1180;
  wire [31:0] n1182;
  wire n1184;
  wire n1186;
  wire n1187;
  wire [31:0] n1189;
  wire n1191;
  wire n1193;
  wire n1194;
  wire [31:0] n1196;
  wire n1198;
  wire n1200;
  wire n1201;
  wire [31:0] n1203;
  wire n1205;
  wire n1207;
  wire n1208;
  wire [31:0] n1210;
  wire n1212;
  wire n1214;
  wire n1215;
  wire [31:0] n1217;
  wire n1219;
  wire n1221;
  wire n1222;
  wire [31:0] n1224;
  wire n1226;
  wire n1228;
  wire n1229;
  wire [31:0] n1231;
  wire n1233;
  wire n1235;
  wire n1236;
  wire [31:0] n1238;
  wire n1240;
  wire n1242;
  wire n1243;
  wire [31:0] n1245;
  wire n1247;
  wire n1249;
  wire n1250;
  wire [31:0] n1252;
  wire n1254;
  wire n1256;
  wire n1257;
  wire [31:0] n1259;
  wire n1261;
  wire n1263;
  wire n1264;
  wire [31:0] n1266;
  wire n1268;
  wire n1270;
  wire n1271;
  wire [31:0] n1273;
  wire n1275;
  wire n1277;
  wire n1278;
  wire [31:0] n1280;
  wire n1282;
  wire n1284;
  wire n1285;
  wire [31:0] n1287;
  wire n1289;
  wire n1291;
  wire n1292;
  wire [31:0] n1294;
  wire n1296;
  wire n1298;
  wire n1299;
  wire n1300;
  wire [63:0] n1301;
  wire [63:0] n1302;
  wire [63:0] n1303;
  wire [14:0] n1304;
  wire [63:0] n1305;
  wire n1307;
  wire [14:0] n1310;
  wire [63:0] n1312;
  wire n1313;
  wire [14:0] n1316;
  wire [63:0] n1318;
  wire n1319;
  wire n1322;
  wire [14:0] n1324;
  wire [63:0] n1326;
  wire n1327;
  wire n1329;
  wire n1332;
  wire n1334;
  wire [30:0] n1335;
  wire [31:0] n1336;
  wire [31:0] n1338;
  wire n1340;
  wire n1342;
  wire [31:0] n1344;
  wire n1346;
  wire n1348;
  wire n1349;
  wire [31:0] n1351;
  wire n1353;
  wire n1355;
  wire n1356;
  wire [31:0] n1358;
  wire n1360;
  wire n1362;
  wire n1363;
  wire [31:0] n1365;
  wire n1367;
  wire n1369;
  wire n1370;
  wire [31:0] n1372;
  wire n1374;
  wire n1376;
  wire n1377;
  wire [31:0] n1379;
  wire n1381;
  wire n1383;
  wire n1384;
  wire [31:0] n1386;
  wire n1388;
  wire n1390;
  wire n1391;
  wire [31:0] n1393;
  wire n1395;
  wire n1397;
  wire n1398;
  wire [31:0] n1400;
  wire n1402;
  wire n1404;
  wire n1405;
  wire [31:0] n1407;
  wire n1409;
  wire n1411;
  wire n1412;
  wire [31:0] n1414;
  wire n1416;
  wire n1418;
  wire n1419;
  wire [31:0] n1421;
  wire n1423;
  wire n1425;
  wire n1426;
  wire [31:0] n1428;
  wire n1430;
  wire n1432;
  wire n1433;
  wire [31:0] n1435;
  wire n1437;
  wire n1439;
  wire n1440;
  wire [31:0] n1442;
  wire n1444;
  wire n1446;
  wire n1447;
  wire [31:0] n1449;
  wire n1451;
  wire n1453;
  wire n1454;
  wire [31:0] n1456;
  wire n1458;
  wire n1460;
  wire n1461;
  wire [31:0] n1463;
  wire n1465;
  wire n1467;
  wire n1468;
  wire [31:0] n1470;
  wire n1472;
  wire n1474;
  wire n1475;
  wire [31:0] n1477;
  wire n1479;
  wire n1481;
  wire n1482;
  wire [31:0] n1484;
  wire n1486;
  wire n1488;
  wire n1489;
  wire [31:0] n1491;
  wire n1493;
  wire n1495;
  wire n1496;
  wire [31:0] n1498;
  wire n1500;
  wire n1502;
  wire n1503;
  wire [31:0] n1505;
  wire n1507;
  wire n1509;
  wire n1510;
  wire [31:0] n1512;
  wire n1514;
  wire n1516;
  wire n1517;
  wire [31:0] n1519;
  wire n1521;
  wire n1523;
  wire n1524;
  wire [31:0] n1526;
  wire n1528;
  wire n1530;
  wire n1531;
  wire [31:0] n1533;
  wire n1535;
  wire n1537;
  wire n1538;
  wire [31:0] n1540;
  wire n1542;
  wire n1544;
  wire n1545;
  wire [31:0] n1547;
  wire n1549;
  wire n1551;
  wire n1552;
  wire [31:0] n1554;
  wire n1556;
  wire n1558;
  wire n1559;
  wire [31:0] n1561;
  wire n1563;
  wire n1565;
  wire n1566;
  wire [31:0] n1568;
  wire n1570;
  wire n1572;
  wire n1573;
  wire [31:0] n1575;
  wire n1577;
  wire n1579;
  wire n1580;
  wire [31:0] n1582;
  wire n1584;
  wire n1586;
  wire n1587;
  wire [31:0] n1589;
  wire n1591;
  wire n1593;
  wire n1594;
  wire [31:0] n1596;
  wire n1598;
  wire n1600;
  wire n1601;
  wire [31:0] n1603;
  wire n1605;
  wire n1607;
  wire n1608;
  wire [31:0] n1610;
  wire n1612;
  wire n1614;
  wire n1615;
  wire [31:0] n1617;
  wire n1619;
  wire n1621;
  wire n1622;
  wire [31:0] n1624;
  wire n1626;
  wire n1628;
  wire n1629;
  wire [31:0] n1631;
  wire n1633;
  wire n1635;
  wire n1636;
  wire [31:0] n1638;
  wire n1640;
  wire n1642;
  wire n1643;
  wire [31:0] n1645;
  wire n1647;
  wire n1649;
  wire n1650;
  wire [31:0] n1652;
  wire n1654;
  wire n1656;
  wire n1657;
  wire [31:0] n1659;
  wire n1661;
  wire n1663;
  wire n1664;
  wire [31:0] n1666;
  wire n1668;
  wire n1670;
  wire n1671;
  wire [31:0] n1673;
  wire n1675;
  wire n1677;
  wire n1678;
  wire [31:0] n1680;
  wire n1682;
  wire n1684;
  wire n1685;
  wire [31:0] n1687;
  wire n1689;
  wire n1691;
  wire n1692;
  wire [31:0] n1694;
  wire n1696;
  wire n1698;
  wire n1699;
  wire [31:0] n1701;
  wire n1703;
  wire n1705;
  wire n1706;
  wire [31:0] n1708;
  wire n1710;
  wire n1712;
  wire n1713;
  wire [31:0] n1715;
  wire n1717;
  wire n1719;
  wire n1720;
  wire [31:0] n1722;
  wire n1724;
  wire n1726;
  wire n1727;
  wire [31:0] n1729;
  wire n1731;
  wire n1733;
  wire n1734;
  wire [31:0] n1736;
  wire n1738;
  wire n1740;
  wire n1741;
  wire [31:0] n1743;
  wire n1745;
  wire n1747;
  wire n1748;
  wire [31:0] n1750;
  wire n1752;
  wire n1754;
  wire n1755;
  wire [31:0] n1757;
  wire n1759;
  wire n1761;
  wire n1762;
  wire [31:0] n1764;
  wire n1766;
  wire n1768;
  wire n1769;
  wire [31:0] n1771;
  wire n1773;
  wire n1775;
  wire n1776;
  wire [31:0] n1778;
  wire n1780;
  wire n1782;
  wire n1783;
  wire n1784;
  wire [63:0] n1785;
  wire [63:0] n1786;
  wire [63:0] n1787;
  wire [14:0] n1789;
  wire [63:0] n1791;
  wire n1793;
  wire [14:0] n1796;
  wire [63:0] n1798;
  wire n1799;
  wire [14:0] n1802;
  wire [63:0] n1804;
  wire n1805;
  wire n1808;
  wire [14:0] n1810;
  wire [63:0] n1812;
  wire n1813;
  wire n1815;
  wire n1818;
  wire n1819;
  wire n1820;
  wire n1821;
  wire n1822;
  wire n1823;
  wire n1824;
  wire n1825;
  wire [14:0] n1826;
  wire [14:0] n1828;
  wire n1829;
  wire n1830;
  wire [15:0] n1831;
  wire n1833;
  wire [31:0] n1834;
  wire [63:0] n1835;
  wire [63:0] n1837;
  wire [15:0] n1838;
  wire [63:0] n1839;
  wire [63:0] n1840;
  wire [63:0] n1842;
  wire n1844;
  wire [14:0] n1846;
  wire [15:0] n1847;
  wire n1849;
  wire [31:0] n1850;
  wire [63:0] n1851;
  wire [63:0] n1853;
  wire [15:0] n1854;
  wire [63:0] n1855;
  wire [63:0] n1856;
  wire [62:0] n1857;
  wire [63:0] n1859;
  wire [63:0] n1860;
  wire [14:0] n1861;
  wire [63:0] n1862;
  wire n1863;
  wire [14:0] n1864;
  wire [63:0] n1866;
  wire n1867;
  wire [23:0] n1869;
  wire [14:0] n1871;
  wire [63:0] n1872;
  wire [63:0] n1874;
  wire n1875;
  wire n1877;
  wire [14:0] n1879;
  wire [63:0] n1881;
  wire n1882;
  wire n1883;
  wire [14:0] n1885;
  wire [63:0] n1887;
  wire n1888;
  wire n1889;
  wire [14:0] n1891;
  wire [63:0] n1893;
  wire n1894;
  wire n1895;
  wire n1897;
  wire n1899;
  wire [14:0] n1901;
  wire [63:0] n1903;
  wire n1904;
  wire n1905;
  wire n1907;
  wire n1908;
  wire n1910;
  wire [14:0] n1912;
  wire [63:0] n1914;
  wire n1915;
  wire n1916;
  wire n1918;
  wire n1919;
  wire n1921;
  wire n1922;
  wire n1923;
  wire n1924;
  wire n1925;
  wire n1926;
  wire n1927;
  wire n1928;
  wire [14:0] n1929;
  wire [14:0] n1931;
  wire [7:0] n1932;
  wire [7:0] n1933;
  wire n1934;
  wire [63:0] n1935;
  wire [14:0] n1937;
  wire [63:0] n1939;
  wire n1941;
  wire [14:0] n1943;
  wire [63:0] n1945;
  wire n1946;
  wire n1948;
  wire [14:0] n1950;
  wire [63:0] n1952;
  wire n1953;
  wire n1955;
  wire n1957;
  wire [14:0] n1959;
  wire [63:0] n1961;
  wire n1962;
  wire n1964;
  wire n1966;
  wire n1967;
  wire n1968;
  wire n1969;
  wire n1970;
  wire [14:0] n1971;
  wire n1973;
  wire [14:0] n1974;
  wire [6:0] n1976;
  wire [7:0] n1978;
  wire [63:0] n1980;
  wire [63:0] n1981;
  wire [14:0] n1982;
  wire n1984;
  wire [63:0] n1986;
  wire [63:0] n1987;
  wire [63:0] n1988;
  wire [63:0] n1989;
  wire [7:0] n1991;
  wire [14:0] n1992;
  wire [63:0] n1993;
  wire [7:0] n1995;
  wire [14:0] n1997;
  wire [63:0] n1999;
  wire [7:0] n2000;
  wire n2002;
  wire n2004;
  wire [14:0] n2006;
  wire [63:0] n2008;
  wire [7:0] n2009;
  wire n2010;
  wire n2012;
  wire n2014;
  wire n2015;
  wire n2016;
  wire n2017;
  wire n2018;
  wire [14:0] n2019;
  wire n2021;
  wire [14:0] n2022;
  wire [6:0] n2024;
  wire [7:0] n2026;
  wire [63:0] n2028;
  wire n2029;
  wire n2030;
  wire n2031;
  wire [14:0] n2032;
  wire n2034;
  wire [63:0] n2036;
  wire n2037;
  wire n2038;
  wire n2039;
  wire [14:0] n2041;
  wire n2042;
  wire n2043;
  wire [14:0] n2044;
  wire [63:0] n2045;
  wire n2046;
  wire [14:0] n2047;
  wire [63:0] n2048;
  wire [7:0] n2050;
  wire n2051;
  wire [14:0] n2052;
  wire [63:0] n2053;
  wire [7:0] n2055;
  wire n2056;
  wire [14:0] n2058;
  wire [63:0] n2060;
  wire [7:0] n2061;
  wire n2063;
  wire n2065;
  wire [14:0] n2067;
  wire [63:0] n2069;
  wire [7:0] n2070;
  wire n2071;
  wire n2073;
  wire n2075;
  wire n2076;
  wire [30:0] n2077;
  wire [31:0] n2078;
  wire n2080;
  wire [30:0] n2081;
  wire [31:0] n2082;
  wire [31:0] n2084;
  wire [31:0] n2085;
  wire [30:0] n2086;
  wire [31:0] n2087;
  wire [31:0] n2089;
  wire [31:0] n2090;
  wire [31:0] n2091;
  wire n2094;
  wire n2096;
  wire [30:0] n2097;
  wire [14:0] n2098;
  wire [14:0] n2100;
  wire [63:0] n2102;
  wire n2104;
  wire [14:0] n2106;
  wire [63:0] n2108;
  wire n2110;
  wire n2111;
  wire [14:0] n2113;
  wire [63:0] n2115;
  wire n2116;
  wire n2117;
  wire [14:0] n2121;
  wire [63:0] n2123;
  wire n2124;
  wire n2125;
  wire n2129;
  wire [14:0] n2131;
  wire [63:0] n2133;
  wire n2134;
  wire n2135;
  wire n2137;
  wire n2141;
  wire [30:0] n2142;
  wire [31:0] n2143;
  wire [31:0] n2145;
  wire n2147;
  wire [31:0] n2149;
  wire [30:0] n2150;
  wire [14:0] n2151;
  wire [31:0] n2152;
  wire [31:0] n2154;
  wire [30:0] n2155;
  wire [14:0] n2156;
  wire n2159;
  wire [14:0] n2161;
  wire n2163;
  wire [14:0] n2165;
  wire [63:0] n2168;
  wire n2171;
  wire [14:0] n2173;
  wire [63:0] n2175;
  wire n2178;
  wire [14:0] n2180;
  wire [63:0] n2182;
  wire n2185;
  wire [14:0] n2188;
  wire [63:0] n2190;
  wire n2192;
  wire [14:0] n2194;
  wire [63:0] n2196;
  wire n2198;
  wire n2200;
  wire [14:0] n2202;
  wire [63:0] n2204;
  wire n2205;
  wire n2207;
  wire [17:0] n2208;
  reg n2212;
  reg [14:0] n2215;
  reg [63:0] n2218;
  reg [64:0] n2219;
  reg [64:0] n2222;
  reg [64:0] n2223;
  reg [14:0] n2224;
  reg [127:0] n2226;
  reg [7:0] n2227;
  reg n2228;
  reg n2229;
  reg n2230;
  reg n2232;
  reg n2233;
  wire n2237;
  wire n2239;
  wire n2241;
  wire n2242;
  wire n2244;
  wire n2245;
  wire n2246;
  wire n2247;
  wire n2249;
  wire n2255;
  wire n2257;
  wire [5:0] n2260;
  wire n2264;
  wire [5:0] n2267;
  wire n2268;
  wire [5:0] n2271;
  wire n2273;
  wire n2274;
  wire [5:0] n2276;
  wire n2280;
  wire n2282;
  wire n2283;
  wire n2285;
  wire n2286;
  wire n2287;
  wire [5:0] n2289;
  wire n2293;
  wire n2295;
  wire n2296;
  wire n2298;
  wire n2299;
  wire n2300;
  wire [5:0] n2302;
  wire n2306;
  wire n2308;
  wire n2309;
  wire n2311;
  wire n2312;
  wire n2313;
  wire [5:0] n2315;
  wire n2319;
  wire n2321;
  wire n2322;
  wire n2324;
  wire n2325;
  wire n2326;
  wire [5:0] n2328;
  wire n2332;
  wire n2334;
  wire n2335;
  wire n2337;
  wire n2338;
  wire n2339;
  wire [5:0] n2341;
  wire n2345;
  wire n2347;
  wire n2348;
  wire n2350;
  wire n2351;
  wire n2352;
  wire [5:0] n2354;
  wire n2358;
  wire n2360;
  wire n2361;
  wire n2363;
  wire n2364;
  wire n2365;
  wire [5:0] n2367;
  wire n2371;
  wire n2373;
  wire n2374;
  wire n2376;
  wire n2377;
  wire n2378;
  wire [5:0] n2380;
  wire n2384;
  wire n2386;
  wire n2387;
  wire n2389;
  wire n2390;
  wire n2391;
  wire [5:0] n2393;
  wire n2397;
  wire n2399;
  wire n2400;
  wire n2402;
  wire n2403;
  wire n2404;
  wire [5:0] n2406;
  wire n2410;
  wire n2412;
  wire n2413;
  wire n2415;
  wire n2416;
  wire n2417;
  wire [5:0] n2419;
  wire n2423;
  wire n2425;
  wire n2426;
  wire n2428;
  wire n2429;
  wire n2430;
  wire [5:0] n2432;
  wire n2436;
  wire n2438;
  wire n2439;
  wire n2441;
  wire n2442;
  wire n2443;
  wire [5:0] n2445;
  wire n2449;
  wire n2451;
  wire n2452;
  wire n2454;
  wire n2455;
  wire n2456;
  wire [5:0] n2458;
  wire n2462;
  wire n2464;
  wire n2465;
  wire n2467;
  wire n2468;
  wire n2469;
  wire [5:0] n2471;
  wire n2475;
  wire n2477;
  wire n2478;
  wire n2480;
  wire n2481;
  wire n2482;
  wire [5:0] n2484;
  wire n2488;
  wire n2490;
  wire n2491;
  wire n2493;
  wire n2494;
  wire n2495;
  wire [5:0] n2497;
  wire n2501;
  wire n2503;
  wire n2504;
  wire n2506;
  wire n2507;
  wire n2508;
  wire [5:0] n2510;
  wire n2514;
  wire n2516;
  wire n2517;
  wire n2519;
  wire n2520;
  wire n2521;
  wire [5:0] n2523;
  wire n2527;
  wire n2529;
  wire n2530;
  wire n2532;
  wire n2533;
  wire n2534;
  wire [5:0] n2536;
  wire n2540;
  wire n2542;
  wire n2543;
  wire n2545;
  wire n2546;
  wire n2547;
  wire [5:0] n2549;
  wire n2553;
  wire n2555;
  wire n2556;
  wire n2558;
  wire n2559;
  wire n2560;
  wire [5:0] n2562;
  wire n2566;
  wire n2568;
  wire n2569;
  wire n2571;
  wire n2572;
  wire n2573;
  wire [5:0] n2575;
  wire n2579;
  wire n2581;
  wire n2582;
  wire n2584;
  wire n2585;
  wire n2586;
  wire [5:0] n2588;
  wire n2592;
  wire n2594;
  wire n2595;
  wire n2597;
  wire n2598;
  wire n2599;
  wire [5:0] n2601;
  wire n2605;
  wire n2607;
  wire n2608;
  wire n2610;
  wire n2611;
  wire n2612;
  wire [5:0] n2614;
  wire n2618;
  wire n2620;
  wire n2621;
  wire n2623;
  wire n2624;
  wire n2625;
  wire [5:0] n2627;
  wire n2631;
  wire n2633;
  wire n2634;
  wire n2636;
  wire n2637;
  wire n2638;
  wire [5:0] n2640;
  wire n2644;
  wire n2646;
  wire n2647;
  wire n2649;
  wire n2650;
  wire n2651;
  wire [5:0] n2653;
  wire n2657;
  wire n2659;
  wire n2660;
  wire n2662;
  wire n2663;
  wire n2664;
  wire [5:0] n2666;
  wire n2670;
  wire n2672;
  wire n2673;
  wire n2675;
  wire n2676;
  wire n2677;
  wire [5:0] n2679;
  wire n2683;
  wire n2685;
  wire n2686;
  wire n2688;
  wire n2689;
  wire n2690;
  wire [5:0] n2692;
  wire n2696;
  wire n2698;
  wire n2699;
  wire n2701;
  wire n2702;
  wire n2703;
  wire [5:0] n2705;
  wire n2709;
  wire n2711;
  wire n2712;
  wire n2714;
  wire n2715;
  wire n2716;
  wire [5:0] n2718;
  wire n2722;
  wire n2724;
  wire n2725;
  wire n2727;
  wire n2728;
  wire n2729;
  wire [5:0] n2731;
  wire n2735;
  wire n2737;
  wire n2738;
  wire n2740;
  wire n2741;
  wire n2742;
  wire [5:0] n2744;
  wire n2748;
  wire n2750;
  wire n2751;
  wire n2753;
  wire n2754;
  wire n2755;
  wire [5:0] n2757;
  wire n2761;
  wire n2763;
  wire n2764;
  wire n2766;
  wire n2767;
  wire n2768;
  wire [5:0] n2770;
  wire n2774;
  wire n2776;
  wire n2777;
  wire n2779;
  wire n2780;
  wire n2781;
  wire [5:0] n2783;
  wire n2787;
  wire n2789;
  wire n2790;
  wire n2792;
  wire n2793;
  wire n2794;
  wire [5:0] n2796;
  wire n2800;
  wire n2802;
  wire n2803;
  wire n2805;
  wire n2806;
  wire n2807;
  wire [5:0] n2809;
  wire n2813;
  wire n2815;
  wire n2816;
  wire n2818;
  wire n2819;
  wire n2820;
  wire [5:0] n2822;
  wire n2826;
  wire n2828;
  wire n2829;
  wire n2831;
  wire n2832;
  wire n2833;
  wire [5:0] n2835;
  wire n2839;
  wire n2841;
  wire n2842;
  wire n2844;
  wire n2845;
  wire n2846;
  wire [5:0] n2848;
  wire n2852;
  wire n2854;
  wire n2855;
  wire n2857;
  wire n2858;
  wire n2859;
  wire [5:0] n2861;
  wire n2865;
  wire n2867;
  wire n2868;
  wire n2870;
  wire n2871;
  wire n2872;
  wire [5:0] n2874;
  wire n2878;
  wire n2880;
  wire n2881;
  wire n2883;
  wire n2884;
  wire n2885;
  wire [5:0] n2887;
  wire n2891;
  wire n2893;
  wire n2894;
  wire n2896;
  wire n2897;
  wire n2898;
  wire [5:0] n2900;
  wire n2904;
  wire n2906;
  wire n2907;
  wire n2909;
  wire n2910;
  wire n2911;
  wire [5:0] n2913;
  wire n2917;
  wire n2919;
  wire n2920;
  wire n2922;
  wire n2923;
  wire n2924;
  wire [5:0] n2926;
  wire n2930;
  wire n2932;
  wire n2933;
  wire n2935;
  wire n2936;
  wire n2937;
  wire [5:0] n2939;
  wire n2943;
  wire n2945;
  wire n2946;
  wire n2948;
  wire n2949;
  wire n2950;
  wire [5:0] n2952;
  wire n2956;
  wire n2958;
  wire n2959;
  wire n2961;
  wire n2962;
  wire n2963;
  wire [5:0] n2965;
  wire n2969;
  wire n2971;
  wire n2972;
  wire n2974;
  wire n2975;
  wire n2976;
  wire [5:0] n2978;
  wire n2982;
  wire n2984;
  wire n2985;
  wire n2987;
  wire n2988;
  wire n2989;
  wire [5:0] n2991;
  wire n2995;
  wire n2997;
  wire n2998;
  wire n3000;
  wire n3001;
  wire n3002;
  wire [5:0] n3004;
  wire n3008;
  wire n3010;
  wire n3011;
  wire n3013;
  wire n3014;
  wire n3015;
  wire [5:0] n3017;
  wire n3021;
  wire n3023;
  wire n3024;
  wire n3026;
  wire n3027;
  wire n3028;
  wire [5:0] n3030;
  wire n3034;
  wire n3036;
  wire n3037;
  wire n3039;
  wire n3040;
  wire n3041;
  wire [5:0] n3043;
  wire n3047;
  wire n3049;
  wire n3050;
  wire n3052;
  wire n3053;
  wire n3054;
  wire [5:0] n3056;
  wire n3060;
  wire n3062;
  wire n3063;
  wire n3065;
  wire n3066;
  wire n3067;
  wire [5:0] n3069;
  wire n3075;
  wire n3078;
  wire [31:0] n3080;
  wire n3082;
  wire n3084;
  wire n3085;
  wire n3086;
  wire n3088;
  wire n3091;
  wire n3092;
  wire n3094;
  wire n3095;
  wire n3096;
  wire n3097;
  wire n3098;
  wire n3099;
  wire n3100;
  wire n3103;
  wire n3105;
  wire n3107;
  wire n3109;
  wire n3110;
  wire n3112;
  wire n3114;
  wire n3115;
  wire n3117;
  wire n3118;
  wire [2:0] n3119;
  reg n3120;
  wire [31:0] n3121;
  wire n3123;
  wire [31:0] n3124;
  wire n3126;
  wire n3127;
  wire [30:0] n3128;
  wire [31:0] n3129;
  wire [31:0] n3130;
  wire n3131;
  wire [14:0] n3133;
  wire [14:0] n3134;
  wire [30:0] n3135;
  wire [63:0] n3136;
  wire n3137;
  wire [63:0] n3139;
  wire [63:0] n3141;
  wire [14:0] n3143;
  wire [63:0] n3144;
  wire n3146;
  wire [14:0] n3147;
  wire [63:0] n3148;
  wire n3149;
  wire n3150;
  wire [14:0] n3152;
  wire [63:0] n3154;
  wire n3156;
  wire n3157;
  wire [14:0] n3158;
  wire [63:0] n3159;
  wire n3160;
  wire n3162;
  wire n3163;
  wire n3164;
  wire n3165;
  wire n3166;
  wire n3168;
  wire n3170;
  wire n3172;
  wire n3173;
  wire n3174;
  wire n3175;
  wire [61:0] n3176;
  wire n3178;
  wire n3181;
  wire n3183;
  wire n3184;
  wire n3185;
  wire n3186;
  wire n3189;
  wire n3192;
  wire n3194;
  wire n3196;
  wire n3197;
  wire n3198;
  wire n3201;
  wire n3204;
  wire n3206;
  wire n3208;
  wire n3210;
  wire n3211;
  wire n3213;
  wire n3214;
  wire n3216;
  wire n3217;
  wire n3218;
  wire [61:0] n3219;
  wire n3221;
  wire n3224;
  wire n3228;
  wire n3230;
  wire n3232;
  wire n3234;
  wire n3236;
  wire n3237;
  wire n3240;
  wire n3243;
  wire n3246;
  wire [5:0] n3247;
  reg n3249;
  reg n3251;
  reg n3254;
  wire n3257;
  wire n3258;
  wire n3259;
  wire n3260;
  wire n3262;
  wire n3264;
  wire [14:0] n3266;
  wire [14:0] n3268;
  wire [63:0] n3271;
  wire n3273;
  wire [63:0] n3275;
  wire [14:0] n3276;
  wire [63:0] n3277;
  wire n3278;
  wire n3279;
  wire [63:0] n3280;
  wire n3281;
  wire n3283;
  wire n3285;
  wire n3286;
  wire n3287;
  wire n3288;
  wire n3289;
  wire n3291;
  wire n3293;
  wire [14:0] n3295;
  wire [14:0] n3297;
  wire [63:0] n3300;
  wire n3302;
  wire [63:0] n3304;
  wire [14:0] n3305;
  wire [63:0] n3306;
  wire n3307;
  wire n3308;
  wire [63:0] n3309;
  wire n3310;
  wire n3312;
  wire n3313;
  wire n3314;
  wire n3315;
  wire n3317;
  wire n3319;
  wire [14:0] n3321;
  wire [14:0] n3323;
  wire [63:0] n3326;
  wire n3328;
  wire [63:0] n3330;
  wire [14:0] n3331;
  wire [63:0] n3332;
  wire n3333;
  wire n3334;
  wire [63:0] n3335;
  wire n3336;
  wire n3338;
  wire [3:0] n3339;
  reg [14:0] n3340;
  reg [63:0] n3341;
  reg n3342;
  wire n3343;
  wire [14:0] n3345;
  wire [63:0] n3347;
  wire n3348;
  wire n3349;
  wire n3350;
  wire n3352;
  wire n3354;
  wire n3356;
  wire [14:0] n3358;
  wire [63:0] n3360;
  wire n3361;
  wire n3362;
  wire n3363;
  wire n3366;
  wire n3367;
  wire n3369;
  wire [14:0] n3371;
  wire [63:0] n3373;
  wire n3374;
  wire n3375;
  wire n3376;
  wire n3378;
  wire n3379;
  wire n3382;
  wire [15:0] n3383;
  wire [79:0] n3384;
  wire n3386;
  wire [5:0] n3387;
  reg [79:0] n3389;
  reg n3393;
  reg n3396;
  reg n3400;
  reg n3402;
  reg n3404;
  reg n3406;
  reg [14:0] n3408;
  reg [14:0] n3410;
  reg [14:0] n3412;
  reg [63:0] n3414;
  reg [63:0] n3416;
  reg [63:0] n3418;
  reg [2:0] n3424;
  reg [64:0] n3426;
  reg [64:0] n3432;
  reg [64:0] n3434;
  reg [14:0] n3436;
  reg n3440;
  reg n3442;
  reg n3444;
  reg [127:0] n3448;
  reg [7:0] n3450;
  reg n3453;
  reg n3456;
  reg n3459;
  reg n3462;
  reg n3465;
  wire n3600;
  wire n3601;
  wire n3602;
  reg n3603;
  wire n3604;
  wire n3605;
  wire n3606;
  reg n3607;
  wire n3608;
  wire n3609;
  wire n3610;
  reg n3611;
  wire n3612;
  wire n3613;
  wire [14:0] n3614;
  reg [14:0] n3615;
  wire n3616;
  wire n3617;
  wire [14:0] n3618;
  reg [14:0] n3619;
  wire n3620;
  wire n3621;
  wire [14:0] n3622;
  reg [14:0] n3623;
  wire n3624;
  wire n3625;
  wire [63:0] n3626;
  reg [63:0] n3627;
  wire n3628;
  wire n3629;
  wire [63:0] n3630;
  reg [63:0] n3631;
  wire n3632;
  wire n3633;
  wire [63:0] n3634;
  reg [63:0] n3635;
  wire [2:0] n3636;
  reg [2:0] n3637;
  wire n3639;
  wire n3640;
  wire [64:0] n3641;
  reg [64:0] n3642;
  wire n3652;
  wire n3653;
  wire [64:0] n3654;
  reg [64:0] n3655;
  wire n3656;
  wire n3657;
  wire [64:0] n3658;
  reg [64:0] n3659;
  wire n3660;
  wire n3661;
  wire [14:0] n3662;
  reg [14:0] n3663;
  wire n3668;
  wire n3669;
  wire n3670;
  reg n3671;
  wire n3672;
  wire n3673;
  wire n3674;
  reg n3675;
  wire n3676;
  wire n3677;
  wire n3678;
  reg n3679;
  wire n3686;
  wire n3687;
  wire [127:0] n3688;
  reg [127:0] n3689;
  wire n3696;
  wire n3697;
  wire [7:0] n3698;
  reg [7:0] n3699;
  wire n3700;
  reg n3701;
  wire n3702;
  reg n3703;
  wire n3704;
  reg n3705;
  wire n3706;
  reg n3707;
  wire n3708;
  reg n3709;
  wire [79:0] n3710;
  reg [79:0] n3711;
  wire n3712;
  reg n3713;
  wire n3714;
  reg n3715;
  wire n3716;
  reg n3717;
  assign result = n3711; //(module output)
  assign result_valid = n3713; //(module output)
  assign overflow = flags_overflow; //(module output)
  assign underflow = flags_underflow; //(module output)
  assign inexact = flags_inexact; //(module output)
  assign invalid = flags_invalid; //(module output)
  assign divide_by_zero = flags_div_by_zero; //(module output)
  assign quotient_byte = fmod_quotient; //(module output)
  assign operation_busy = n3715; //(module output)
  assign operation_done = n3717; //(module output)
  /* TG68K_FPU_ALU.vhd:1279:65  */
  assign sign_a = n3603; // (signal)
  /* TG68K_FPU_ALU.vhd:92:24  */
  assign sign_b = n3607; // (signal)
  /* TG68K_FPU_ALU.vhd:92:32  */
  assign sign_result = n3611; // (signal)
  /* TG68K_FPU_ALU.vhd:956:73  */
  assign exp_a = n3615; // (signal)
  /* TG68K_FPU_ALU.vhd:1105:81  */
  assign exp_b = n3619; // (signal)
  /* TG68K_FPU_ALU.vhd:93:30  */
  assign exp_result = n3623; // (signal)
  /* TG68K_FPU_ALU.vhd:94:16  */
  assign mant_a = n3627; // (signal)
  /* TG68K_FPU_ALU.vhd:94:24  */
  assign mant_b = n3631; // (signal)
  /* TG68K_FPU_ALU.vhd:94:32  */
  assign mant_result = n3635; // (signal)
  /* TG68K_FPU_ALU.vhd:105:16  */
  always @*
    alu_state = n3637; // (isignal)
  initial
    alu_state = 3'b000;
  /* TG68K_FPU_ALU.vhd:109:16  */
  assign mant_sum = n3642; // (signal)
  /* TG68K_FPU_ALU.vhd:115:16  */
  assign mant_a_aligned = n3655; // (signal)
  /* TG68K_FPU_ALU.vhd:115:32  */
  assign mant_b_aligned = n3659; // (signal)
  /* TG68K_FPU_ALU.vhd:116:16  */
  assign exp_larger = n3663; // (signal)
  /* TG68K_FPU_ALU.vhd:120:16  */
  assign guard_bit = n3671; // (signal)
  /* TG68K_FPU_ALU.vhd:120:27  */
  assign round_bit = n3675; // (signal)
  /* TG68K_FPU_ALU.vhd:120:38  */
  assign sticky_bit = n3679; // (signal)
  /* TG68K_FPU_ALU.vhd:127:16  */
  assign mult_result = n3689; // (signal)
  /* TG68K_FPU_ALU.vhd:138:16  */
  always @*
    fmod_quotient = n3699; // (isignal)
  initial
    fmod_quotient = 8'b00000000;
  /* TG68K_FPU_ALU.vhd:146:16  */
  assign is_zero_a = n62; // (signal)
  /* TG68K_FPU_ALU.vhd:146:27  */
  assign is_zero_b = n122; // (signal)
  /* TG68K_FPU_ALU.vhd:147:16  */
  assign is_inf_a = n64; // (signal)
  /* TG68K_FPU_ALU.vhd:147:26  */
  assign is_inf_b = n124; // (signal)
  /* TG68K_FPU_ALU.vhd:148:16  */
  assign is_nan_a = n66; // (signal)
  /* TG68K_FPU_ALU.vhd:148:26  */
  assign is_nan_b = n126; // (signal)
  /* TG68K_FPU_ALU.vhd:149:16  */
  assign is_denorm_a = n68; // (signal)
  /* TG68K_FPU_ALU.vhd:149:29  */
  assign is_denorm_b = n128; // (signal)
  /* TG68K_FPU_ALU.vhd:150:16  */
  assign is_snan_a = n70; // (signal)
  /* TG68K_FPU_ALU.vhd:150:27  */
  assign is_snan_b = n130; // (signal)
  /* TG68K_FPU_ALU.vhd:159:16  */
  assign flags_overflow = n3701; // (signal)
  /* TG68K_FPU_ALU.vhd:160:16  */
  assign flags_underflow = n3703; // (signal)
  /* TG68K_FPU_ALU.vhd:161:16  */
  assign flags_inexact = n3705; // (signal)
  /* TG68K_FPU_ALU.vhd:162:16  */
  assign flags_invalid = n3707; // (signal)
  /* TG68K_FPU_ALU.vhd:163:16  */
  assign flags_div_by_zero = n3709; // (signal)
  /* TG68K_FPU_ALU.vhd:171:29  */
  assign n13 = operand_a[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:171:44  */
  assign n15 = n13 == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:172:37  */
  assign n16 = operand_a[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:172:51  */
  assign n18 = n16 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:172:25  */
  assign n21 = n18 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:172:25  */
  assign n24 = n18 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:183:32  */
  assign n25 = operand_a[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:183:47  */
  assign n27 = n25 == 15'b111111111111111;
  /* TG68K_FPU_ALU.vhd:186:37  */
  assign n28 = operand_a[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:186:51  */
  assign n30 = n28 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:197:45  */
  assign n31 = operand_a[62]; // extract
  /* TG68K_FPU_ALU.vhd:197:50  */
  assign n32 = ~n31;
  /* TG68K_FPU_ALU.vhd:197:69  */
  assign n33 = operand_a[61:0]; // extract
  /* TG68K_FPU_ALU.vhd:197:83  */
  assign n35 = n33 != 62'b00000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:197:56  */
  assign n36 = n35 & n32;
  /* TG68K_FPU_ALU.vhd:197:33  */
  assign n39 = n36 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:186:25  */
  assign n45 = n30 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:186:25  */
  assign n48 = n30 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:186:25  */
  assign n50 = n30 ? 1'b0 : n39;
  /* TG68K_FPU_ALU.vhd:183:17  */
  assign n54 = n27 ? n45 : 1'b0;
  /* TG68K_FPU_ALU.vhd:183:17  */
  assign n56 = n27 ? n48 : 1'b0;
  /* TG68K_FPU_ALU.vhd:183:17  */
  assign n58 = n27 ? n50 : 1'b0;
  /* TG68K_FPU_ALU.vhd:171:17  */
  assign n62 = n15 ? n21 : 1'b0;
  /* TG68K_FPU_ALU.vhd:171:17  */
  assign n64 = n15 ? 1'b0 : n54;
  /* TG68K_FPU_ALU.vhd:171:17  */
  assign n66 = n15 ? 1'b0 : n56;
  /* TG68K_FPU_ALU.vhd:171:17  */
  assign n68 = n15 ? n24 : 1'b0;
  /* TG68K_FPU_ALU.vhd:171:17  */
  assign n70 = n15 ? 1'b0 : n58;
  /* TG68K_FPU_ALU.vhd:215:29  */
  assign n73 = operand_b[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:215:44  */
  assign n75 = n73 == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:216:37  */
  assign n76 = operand_b[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:216:51  */
  assign n78 = n76 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:216:25  */
  assign n81 = n78 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:216:25  */
  assign n84 = n78 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:227:32  */
  assign n85 = operand_b[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:227:47  */
  assign n87 = n85 == 15'b111111111111111;
  /* TG68K_FPU_ALU.vhd:230:37  */
  assign n88 = operand_b[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:230:51  */
  assign n90 = n88 == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:241:45  */
  assign n91 = operand_b[62]; // extract
  /* TG68K_FPU_ALU.vhd:241:50  */
  assign n92 = ~n91;
  /* TG68K_FPU_ALU.vhd:241:69  */
  assign n93 = operand_b[61:0]; // extract
  /* TG68K_FPU_ALU.vhd:241:83  */
  assign n95 = n93 != 62'b00000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:241:56  */
  assign n96 = n95 & n92;
  /* TG68K_FPU_ALU.vhd:241:33  */
  assign n99 = n96 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:230:25  */
  assign n105 = n90 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:230:25  */
  assign n108 = n90 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:230:25  */
  assign n110 = n90 ? 1'b0 : n99;
  /* TG68K_FPU_ALU.vhd:227:17  */
  assign n114 = n87 ? n105 : 1'b0;
  /* TG68K_FPU_ALU.vhd:227:17  */
  assign n116 = n87 ? n108 : 1'b0;
  /* TG68K_FPU_ALU.vhd:227:17  */
  assign n118 = n87 ? n110 : 1'b0;
  /* TG68K_FPU_ALU.vhd:215:17  */
  assign n122 = n75 ? n81 : 1'b0;
  /* TG68K_FPU_ALU.vhd:215:17  */
  assign n124 = n75 ? 1'b0 : n114;
  /* TG68K_FPU_ALU.vhd:215:17  */
  assign n126 = n75 ? 1'b0 : n116;
  /* TG68K_FPU_ALU.vhd:215:17  */
  assign n128 = n75 ? n84 : 1'b0;
  /* TG68K_FPU_ALU.vhd:215:17  */
  assign n130 = n75 ? 1'b0 : n118;
  /* TG68K_FPU_ALU.vhd:267:27  */
  assign n138 = ~nReset;
  /* TG68K_FPU_ALU.vhd:289:49  */
  assign n142 = start_operation ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:289:49  */
  assign n145 = start_operation ? 3'b001 : alu_state;
  /* TG68K_FPU_ALU.vhd:284:41  */
  assign n147 = alu_state == 3'b000;
  /* TG68K_FPU_ALU.vhd:294:41  */
  assign n149 = alu_state == 3'b001;
  /* TG68K_FPU_ALU.vhd:307:68  */
  assign n150 = operand_a[79]; // extract
  /* TG68K_FPU_ALU.vhd:308:67  */
  assign n151 = operand_a[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:309:68  */
  assign n152 = operand_a[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:311:68  */
  assign n153 = operand_b[79]; // extract
  /* TG68K_FPU_ALU.vhd:312:67  */
  assign n154 = operand_b[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:313:68  */
  assign n155 = operand_b[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:316:67  */
  assign n157 = operation_code == 7'b0000000;
  /* TG68K_FPU_ALU.vhd:318:81  */
  assign n158 = operand_a[79]; // extract
  /* TG68K_FPU_ALU.vhd:319:80  */
  assign n159 = operand_a[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:320:81  */
  assign n160 = operand_a[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:322:70  */
  assign n162 = operation_code == 7'b0100010;
  /* TG68K_FPU_ALU.vhd:322:80  */
  assign n163 = is_zero_b & n162;
  /* TG68K_FPU_ALU.vhd:322:116  */
  assign n164 = ~is_denorm_a;
  /* TG68K_FPU_ALU.vhd:322:100  */
  assign n165 = n164 & n163;
  /* TG68K_FPU_ALU.vhd:324:81  */
  assign n166 = operand_a[79]; // extract
  /* TG68K_FPU_ALU.vhd:325:80  */
  assign n167 = operand_a[78:64]; // extract
  /* TG68K_FPU_ALU.vhd:326:81  */
  assign n168 = operand_a[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:328:70  */
  assign n170 = operation_code == 7'b0100011;
  /* TG68K_FPU_ALU.vhd:328:101  */
  assign n171 = is_zero_a | is_zero_b;
  /* TG68K_FPU_ALU.vhd:328:80  */
  assign n172 = n171 & n170;
  /* TG68K_FPU_ALU.vhd:330:81  */
  assign n173 = operand_a[79]; // extract
  /* TG68K_FPU_ALU.vhd:330:99  */
  assign n174 = operand_b[79]; // extract
  /* TG68K_FPU_ALU.vhd:330:86  */
  assign n175 = n173 ^ n174;
  /* TG68K_FPU_ALU.vhd:328:49  */
  assign n176 = n172 ? n175 : sign_result;
  /* TG68K_FPU_ALU.vhd:328:49  */
  assign n178 = n172 ? 15'b000000000000000 : exp_result;
  /* TG68K_FPU_ALU.vhd:328:49  */
  assign n180 = n172 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : mant_result;
  /* TG68K_FPU_ALU.vhd:328:49  */
  assign n183 = n172 ? 3'b100 : 3'b011;
  /* TG68K_FPU_ALU.vhd:322:49  */
  assign n184 = n165 ? n166 : n176;
  /* TG68K_FPU_ALU.vhd:322:49  */
  assign n185 = n165 ? n167 : n178;
  /* TG68K_FPU_ALU.vhd:322:49  */
  assign n186 = n165 ? n168 : n180;
  /* TG68K_FPU_ALU.vhd:322:49  */
  assign n188 = n165 ? 3'b100 : n183;
  /* TG68K_FPU_ALU.vhd:316:49  */
  assign n189 = n157 ? n158 : n184;
  /* TG68K_FPU_ALU.vhd:316:49  */
  assign n190 = n157 ? n159 : n185;
  /* TG68K_FPU_ALU.vhd:316:49  */
  assign n191 = n157 ? n160 : n186;
  /* TG68K_FPU_ALU.vhd:316:49  */
  assign n193 = n157 ? 3'b100 : n188;
  /* TG68K_FPU_ALU.vhd:304:41  */
  assign n195 = alu_state == 3'b010;
  /* TG68K_FPU_ALU.vhd:340:57  */
  assign n197 = operation_code == 7'b0000000;
  /* TG68K_FPU_ALU.vhd:347:57  */
  assign n199 = operation_code == 7'b0011000;
  /* TG68K_FPU_ALU.vhd:356:80  */
  assign n200 = ~sign_a;
  /* TG68K_FPU_ALU.vhd:354:57  */
  assign n202 = operation_code == 7'b0011010;
  /* TG68K_FPU_ALU.vhd:363:85  */
  assign n203 = ~is_zero_a;
  /* TG68K_FPU_ALU.vhd:363:81  */
  assign n204 = n203 & sign_a;
  /* TG68K_FPU_ALU.vhd:385:85  */
  assign n205 = {16'b0, exp_a};  //  uext
  /* TG68K_FPU_ALU.vhd:385:113  */
  assign n206 = {1'b0, n205};  //  uext
  /* TG68K_FPU_ALU.vhd:385:113  */
  assign n208 = n206 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:386:125  */
  assign n210 = $signed(n208) / $signed(32'b00000000000000000000000000000010); // sdiv
  /* TG68K_FPU_ALU.vhd:386:129  */
  assign n212 = n210 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:386:116  */
  assign n213 = n212[30:0];  // trunc
  /* TG68K_FPU_ALU.vhd:386:104  */
  assign n214 = n213[14:0];  // trunc
  /* TG68K_FPU_ALU.vhd:390:82  */
  assign n215 = mant_a[63:62]; // extract
  /* TG68K_FPU_ALU.vhd:390:97  */
  assign n217 = n215 == 2'b11;
  /* TG68K_FPU_ALU.vhd:393:85  */
  assign n218 = mant_a[63:62]; // extract
  /* TG68K_FPU_ALU.vhd:393:100  */
  assign n220 = n218 == 2'b10;
  /* TG68K_FPU_ALU.vhd:396:85  */
  assign n221 = mant_a[63:62]; // extract
  /* TG68K_FPU_ALU.vhd:396:100  */
  assign n223 = n221 == 2'b01;
  /* TG68K_FPU_ALU.vhd:396:73  */
  assign n226 = n223 ? 64'b1000111101011100001010001111010111000010100011110101110000101001 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:393:73  */
  assign n228 = n220 ? 64'b1001110110001001110110001001110110001001110110001001110110001010 : n226;
  /* TG68K_FPU_ALU.vhd:390:73  */
  assign n230 = n217 ? 64'b1010100011110101110000101000111101011100001010001111010111000011 : n228;
  /* TG68K_FPU_ALU.vhd:405:81  */
  assign n231 = exp_a[0]; // extract
  /* TG68K_FPU_ALU.vhd:408:157  */
  assign n232 = mant_result[63:1]; // extract
  /* TG68K_FPU_ALU.vhd:408:135  */
  assign n233 = {1'b0, n232};  //  uext
  /* TG68K_FPU_ALU.vhd:408:135  */
  assign n234 = mant_result + n233;
  /* TG68K_FPU_ALU.vhd:405:73  */
  assign n235 = n231 ? n234 : n230;
  /* TG68K_FPU_ALU.vhd:374:65  */
  assign n237 = is_inf_a ? 15'b111111111111111 : n214;
  /* TG68K_FPU_ALU.vhd:374:65  */
  assign n239 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n235;
  /* TG68K_FPU_ALU.vhd:374:65  */
  assign n241 = is_inf_a ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:369:65  */
  assign n244 = is_zero_a ? 15'b000000000000000 : n237;
  /* TG68K_FPU_ALU.vhd:369:65  */
  assign n246 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n239;
  /* TG68K_FPU_ALU.vhd:369:65  */
  assign n247 = is_zero_a ? flags_inexact : n241;
  /* TG68K_FPU_ALU.vhd:363:65  */
  assign n250 = n204 ? 15'b111111111111111 : n244;
  /* TG68K_FPU_ALU.vhd:363:65  */
  assign n252 = n204 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n246;
  /* TG68K_FPU_ALU.vhd:363:65  */
  assign n253 = n204 ? flags_inexact : n247;
  /* TG68K_FPU_ALU.vhd:363:65  */
  assign n255 = n204 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:361:57  */
  assign n258 = operation_code == 7'b0000100;
  /* TG68K_FPU_ALU.vhd:417:83  */
  assign n259 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:420:92  */
  assign n260 = is_snan_a | is_snan_b;
  /* TG68K_FPU_ALU.vhd:420:73  */
  assign n262 = n260 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:427:86  */
  assign n263 = is_inf_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:429:83  */
  assign n264 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:429:73  */
  assign n266 = n264 ? sign_a : 1'b0;
  /* TG68K_FPU_ALU.vhd:429:73  */
  assign n269 = n264 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:429:73  */
  assign n271 = n264 ? flags_invalid : 1'b1;
  /* TG68K_FPU_ALU.vhd:451:103  */
  assign n272 = ~is_denorm_b;
  /* TG68K_FPU_ALU.vhd:451:87  */
  assign n273 = n272 & is_zero_a;
  /* TG68K_FPU_ALU.vhd:456:103  */
  assign n274 = ~is_denorm_a;
  /* TG68K_FPU_ALU.vhd:456:87  */
  assign n275 = n274 & is_zero_b;
  /* TG68K_FPU_ALU.vhd:461:89  */
  assign n276 = is_denorm_a | is_denorm_b;
  /* TG68K_FPU_ALU.vhd:465:82  */
  assign n278 = exp_a == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:467:103  */
  assign n280 = {1'b0, mant_a};
  /* TG68K_FPU_ALU.vhd:469:103  */
  assign n282 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:465:73  */
  assign n283 = n278 ? n280 : n282;
  /* TG68K_FPU_ALU.vhd:471:82  */
  assign n285 = exp_b == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:473:103  */
  assign n287 = {1'b0, mant_b};
  /* TG68K_FPU_ALU.vhd:475:103  */
  assign n289 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:471:73  */
  assign n290 = n285 ? n287 : n289;
  /* TG68K_FPU_ALU.vhd:480:83  */
  assign n291 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:482:108  */
  assign n292 = mant_a_aligned + mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:486:99  */
  assign n293 = $unsigned(mant_a_aligned) >= $unsigned(mant_b_aligned);
  /* TG68K_FPU_ALU.vhd:487:116  */
  assign n294 = mant_a_aligned - mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:490:116  */
  assign n295 = mant_b_aligned - mant_a_aligned;
  /* TG68K_FPU_ALU.vhd:486:81  */
  assign n296 = n293 ? sign_a : sign_b;
  /* TG68K_FPU_ALU.vhd:486:81  */
  assign n297 = n293 ? n294 : n295;
  /* TG68K_FPU_ALU.vhd:480:73  */
  assign n298 = n291 ? sign_a : n296;
  /* TG68K_FPU_ALU.vhd:480:73  */
  assign n299 = n291 ? n292 : n297;
  /* TG68K_FPU_ALU.vhd:498:82  */
  assign n300 = $unsigned(exp_a) >= $unsigned(exp_b);
  /* TG68K_FPU_ALU.vhd:503:103  */
  assign n303 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:505:90  */
  assign n304 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:505:98  */
  assign n306 = $unsigned(n304) > $unsigned(15'b000000000111111);
  /* TG68K_FPU_ALU.vhd:510:149  */
  assign n311 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:510:186  */
  assign n312 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:510:160  */
  assign n313 = {16'b0, n312};  //  uext
  /* TG68K_FPU_ALU.vhd:510:124  */
  assign n314 = n311 >> n313;
  /* TG68K_FPU_ALU.vhd:505:81  */
  assign n317 = n306 ? 65'b00000000000000000000000000000000000000000000000000000000000000000 : n314;
  /* TG68K_FPU_ALU.vhd:517:103  */
  assign n320 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:519:90  */
  assign n321 = exp_b - exp_a;
  /* TG68K_FPU_ALU.vhd:519:98  */
  assign n323 = $unsigned(n321) > $unsigned(15'b000000000111111);
  /* TG68K_FPU_ALU.vhd:524:149  */
  assign n328 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:524:186  */
  assign n329 = exp_b - exp_a;
  /* TG68K_FPU_ALU.vhd:524:160  */
  assign n330 = {16'b0, n329};  //  uext
  /* TG68K_FPU_ALU.vhd:524:124  */
  assign n331 = n328 >> n330;
  /* TG68K_FPU_ALU.vhd:519:81  */
  assign n334 = n323 ? 65'b00000000000000000000000000000000000000000000000000000000000000000 : n331;
  /* TG68K_FPU_ALU.vhd:498:73  */
  assign n337 = n300 ? n303 : n334;
  /* TG68K_FPU_ALU.vhd:498:73  */
  assign n338 = n300 ? n317 : n320;
  /* TG68K_FPU_ALU.vhd:498:73  */
  assign n339 = n300 ? exp_a : exp_b;
  /* TG68K_FPU_ALU.vhd:529:84  */
  assign n341 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:531:108  */
  assign n342 = mant_a_aligned + mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:535:99  */
  assign n343 = $unsigned(mant_a_aligned) >= $unsigned(mant_b_aligned);
  /* TG68K_FPU_ALU.vhd:536:116  */
  assign n344 = mant_a_aligned - mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:539:116  */
  assign n345 = mant_b_aligned - mant_a_aligned;
  /* TG68K_FPU_ALU.vhd:535:81  */
  assign n346 = n343 ? sign_a : sign_b;
  /* TG68K_FPU_ALU.vhd:535:81  */
  assign n347 = n343 ? n344 : n345;
  /* TG68K_FPU_ALU.vhd:529:73  */
  assign n348 = n341 ? sign_a : n346;
  /* TG68K_FPU_ALU.vhd:529:73  */
  assign n349 = n341 ? n342 : n347;
  /* TG68K_FPU_ALU.vhd:545:84  */
  assign n350 = mant_sum[64]; // extract
  /* TG68K_FPU_ALU.vhd:547:133  */
  assign n352 = exp_larger + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:548:104  */
  assign n353 = mant_sum[64:1]; // extract
  /* TG68K_FPU_ALU.vhd:549:87  */
  assign n354 = mant_sum[63]; // extract
  /* TG68K_FPU_ALU.vhd:549:92  */
  assign n355 = ~n354;
  /* TG68K_FPU_ALU.vhd:551:133  */
  assign n357 = exp_larger - 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:552:104  */
  assign n358 = mant_sum[62:0]; // extract
  /* TG68K_FPU_ALU.vhd:552:118  */
  assign n360 = {n358, 1'b0};
  /* TG68K_FPU_ALU.vhd:556:104  */
  assign n361 = mant_sum[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:549:73  */
  assign n362 = n355 ? n357 : exp_larger;
  /* TG68K_FPU_ALU.vhd:549:73  */
  assign n363 = n355 ? n360 : n361;
  /* TG68K_FPU_ALU.vhd:545:73  */
  assign n364 = n350 ? n352 : n362;
  /* TG68K_FPU_ALU.vhd:545:73  */
  assign n365 = n350 ? n353 : n363;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n366 = n276 ? n298 : n348;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n367 = n276 ? exp_larger : n364;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n368 = n276 ? mant_result : n365;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n369 = n276 ? n299 : n349;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n372 = n276 ? n283 : n337;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n373 = n276 ? n290 : n338;
  /* TG68K_FPU_ALU.vhd:461:65  */
  assign n375 = n276 ? 15'b000000000000001 : n339;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n377 = n275 ? sign_a : n366;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n378 = n275 ? exp_a : n367;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n379 = n275 ? mant_a : n368;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n380 = n275 ? mant_sum : n369;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n383 = n275 ? mant_a_aligned : n372;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n384 = n275 ? mant_b_aligned : n373;
  /* TG68K_FPU_ALU.vhd:456:65  */
  assign n385 = n275 ? exp_larger : n375;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n387 = n273 ? sign_b : n377;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n388 = n273 ? exp_b : n378;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n389 = n273 ? mant_b : n379;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n390 = n273 ? mant_sum : n380;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n393 = n273 ? mant_a_aligned : n383;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n394 = n273 ? mant_b_aligned : n384;
  /* TG68K_FPU_ALU.vhd:451:65  */
  assign n395 = n273 ? exp_larger : n385;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n397 = is_inf_b ? sign_b : n387;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n399 = is_inf_b ? 15'b111111111111111 : n388;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n401 = is_inf_b ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n389;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n402 = is_inf_b ? mant_sum : n390;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n405 = is_inf_b ? mant_a_aligned : n393;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n406 = is_inf_b ? mant_b_aligned : n394;
  /* TG68K_FPU_ALU.vhd:446:65  */
  assign n407 = is_inf_b ? exp_larger : n395;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n409 = is_inf_a ? sign_a : n397;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n411 = is_inf_a ? 15'b111111111111111 : n399;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n413 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n401;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n414 = is_inf_a ? mant_sum : n402;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n417 = is_inf_a ? mant_a_aligned : n405;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n418 = is_inf_a ? mant_b_aligned : n406;
  /* TG68K_FPU_ALU.vhd:441:65  */
  assign n419 = is_inf_a ? exp_larger : n407;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n421 = n263 ? n266 : n409;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n423 = n263 ? 15'b111111111111111 : n411;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n424 = n263 ? n269 : n413;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n425 = n263 ? mant_sum : n414;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n428 = n263 ? mant_a_aligned : n417;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n429 = n263 ? mant_b_aligned : n418;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n430 = n263 ? exp_larger : n419;
  /* TG68K_FPU_ALU.vhd:427:65  */
  assign n432 = n263 ? n271 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n434 = n259 ? 1'b0 : n421;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n436 = n259 ? 15'b111111111111111 : n423;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n438 = n259 ? 64'b1100000000000000000000000000000000000000000000000000000000000000 : n424;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n439 = n259 ? mant_sum : n425;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n442 = n259 ? mant_a_aligned : n428;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n443 = n259 ? mant_b_aligned : n429;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n444 = n259 ? exp_larger : n430;
  /* TG68K_FPU_ALU.vhd:417:65  */
  assign n446 = n259 ? n262 : n432;
  /* TG68K_FPU_ALU.vhd:415:57  */
  assign n448 = operation_code == 7'b0100010;
  /* TG68K_FPU_ALU.vhd:563:83  */
  assign n449 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:569:86  */
  assign n450 = is_inf_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:571:83  */
  assign n451 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:571:73  */
  assign n453 = n451 ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:571:73  */
  assign n456 = n451 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n458 = n601 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:590:88  */
  assign n459 = ~sign_b;
  /* TG68K_FPU_ALU.vhd:593:103  */
  assign n460 = ~is_denorm_b;
  /* TG68K_FPU_ALU.vhd:593:87  */
  assign n461 = n460 & is_zero_a;
  /* TG68K_FPU_ALU.vhd:595:88  */
  assign n462 = ~sign_b;
  /* TG68K_FPU_ALU.vhd:598:103  */
  assign n463 = ~is_denorm_a;
  /* TG68K_FPU_ALU.vhd:598:87  */
  assign n464 = n463 & is_zero_b;
  /* TG68K_FPU_ALU.vhd:603:89  */
  assign n465 = is_denorm_a | is_denorm_b;
  /* TG68K_FPU_ALU.vhd:607:82  */
  assign n467 = exp_a == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:609:103  */
  assign n469 = {1'b0, mant_a};
  /* TG68K_FPU_ALU.vhd:611:103  */
  assign n471 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:607:73  */
  assign n472 = n467 ? n469 : n471;
  /* TG68K_FPU_ALU.vhd:613:82  */
  assign n474 = exp_b == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:615:103  */
  assign n476 = {1'b0, mant_b};
  /* TG68K_FPU_ALU.vhd:617:103  */
  assign n478 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:613:73  */
  assign n479 = n474 ? n476 : n478;
  /* TG68K_FPU_ALU.vhd:622:83  */
  assign n480 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:624:99  */
  assign n481 = $unsigned(mant_a_aligned) >= $unsigned(mant_b_aligned);
  /* TG68K_FPU_ALU.vhd:625:116  */
  assign n482 = mant_a_aligned - mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:628:116  */
  assign n483 = mant_b_aligned - mant_a_aligned;
  /* TG68K_FPU_ALU.vhd:629:104  */
  assign n484 = ~sign_a;
  /* TG68K_FPU_ALU.vhd:624:81  */
  assign n485 = n481 ? sign_a : n484;
  /* TG68K_FPU_ALU.vhd:624:81  */
  assign n486 = n481 ? n482 : n483;
  /* TG68K_FPU_ALU.vhd:633:108  */
  assign n487 = mant_a_aligned + mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:622:73  */
  assign n488 = n480 ? n485 : sign_a;
  /* TG68K_FPU_ALU.vhd:622:73  */
  assign n489 = n480 ? n486 : n487;
  /* TG68K_FPU_ALU.vhd:640:82  */
  assign n490 = $unsigned(exp_a) >= $unsigned(exp_b);
  /* TG68K_FPU_ALU.vhd:644:103  */
  assign n493 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:646:90  */
  assign n494 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:646:98  */
  assign n496 = $unsigned(n494) > $unsigned(15'b000000000111111);
  /* TG68K_FPU_ALU.vhd:649:149  */
  assign n498 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:649:186  */
  assign n499 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:649:160  */
  assign n500 = {16'b0, n499};  //  uext
  /* TG68K_FPU_ALU.vhd:649:124  */
  assign n501 = n498 >> n500;
  /* TG68K_FPU_ALU.vhd:646:81  */
  assign n503 = n496 ? 65'b00000000000000000000000000000000000000000000000000000000000000000 : n501;
  /* TG68K_FPU_ALU.vhd:655:103  */
  assign n506 = {1'b1, mant_b};
  /* TG68K_FPU_ALU.vhd:657:90  */
  assign n507 = exp_b - exp_a;
  /* TG68K_FPU_ALU.vhd:657:98  */
  assign n509 = $unsigned(n507) > $unsigned(15'b000000000111111);
  /* TG68K_FPU_ALU.vhd:660:149  */
  assign n511 = {1'b1, mant_a};
  /* TG68K_FPU_ALU.vhd:660:186  */
  assign n512 = exp_b - exp_a;
  /* TG68K_FPU_ALU.vhd:660:160  */
  assign n513 = {16'b0, n512};  //  uext
  /* TG68K_FPU_ALU.vhd:660:124  */
  assign n514 = n511 >> n513;
  /* TG68K_FPU_ALU.vhd:657:81  */
  assign n516 = n509 ? 65'b00000000000000000000000000000000000000000000000000000000000000000 : n514;
  /* TG68K_FPU_ALU.vhd:640:73  */
  assign n518 = n490 ? n493 : n516;
  /* TG68K_FPU_ALU.vhd:640:73  */
  assign n519 = n490 ? n503 : n506;
  /* TG68K_FPU_ALU.vhd:640:73  */
  assign n520 = n490 ? exp_a : exp_b;
  /* TG68K_FPU_ALU.vhd:665:84  */
  assign n521 = sign_a != sign_b;
  /* TG68K_FPU_ALU.vhd:667:108  */
  assign n522 = mant_a_aligned + mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:671:99  */
  assign n523 = $unsigned(mant_a_aligned) >= $unsigned(mant_b_aligned);
  /* TG68K_FPU_ALU.vhd:672:116  */
  assign n524 = mant_a_aligned - mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:675:116  */
  assign n525 = mant_b_aligned - mant_a_aligned;
  /* TG68K_FPU_ALU.vhd:676:104  */
  assign n526 = ~sign_a;
  /* TG68K_FPU_ALU.vhd:671:81  */
  assign n527 = n523 ? sign_a : n526;
  /* TG68K_FPU_ALU.vhd:671:81  */
  assign n528 = n523 ? n524 : n525;
  /* TG68K_FPU_ALU.vhd:665:73  */
  assign n529 = n521 ? sign_a : n527;
  /* TG68K_FPU_ALU.vhd:665:73  */
  assign n530 = n521 ? n522 : n528;
  /* TG68K_FPU_ALU.vhd:681:84  */
  assign n531 = mant_sum[64]; // extract
  /* TG68K_FPU_ALU.vhd:683:133  */
  assign n533 = exp_larger + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:684:104  */
  assign n534 = mant_sum[64:1]; // extract
  /* TG68K_FPU_ALU.vhd:685:87  */
  assign n535 = mant_sum[63]; // extract
  /* TG68K_FPU_ALU.vhd:685:92  */
  assign n536 = ~n535;
  /* TG68K_FPU_ALU.vhd:687:133  */
  assign n538 = exp_larger - 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:688:104  */
  assign n539 = mant_sum[62:0]; // extract
  /* TG68K_FPU_ALU.vhd:688:118  */
  assign n541 = {n539, 1'b0};
  /* TG68K_FPU_ALU.vhd:692:104  */
  assign n542 = mant_sum[63:0]; // extract
  /* TG68K_FPU_ALU.vhd:685:73  */
  assign n543 = n536 ? n538 : exp_larger;
  /* TG68K_FPU_ALU.vhd:685:73  */
  assign n544 = n536 ? n541 : n542;
  /* TG68K_FPU_ALU.vhd:681:73  */
  assign n545 = n531 ? n533 : n543;
  /* TG68K_FPU_ALU.vhd:681:73  */
  assign n546 = n531 ? n534 : n544;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n547 = n465 ? n488 : n529;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n548 = n465 ? exp_larger : n545;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n549 = n465 ? mant_result : n546;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n550 = n465 ? n489 : n530;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n552 = n465 ? n472 : n518;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n553 = n465 ? n479 : n519;
  /* TG68K_FPU_ALU.vhd:603:65  */
  assign n555 = n465 ? 15'b000000000000001 : n520;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n556 = n464 ? sign_a : n547;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n557 = n464 ? exp_a : n548;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n558 = n464 ? mant_a : n549;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n559 = n464 ? mant_sum : n550;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n561 = n464 ? mant_a_aligned : n552;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n562 = n464 ? mant_b_aligned : n553;
  /* TG68K_FPU_ALU.vhd:598:65  */
  assign n563 = n464 ? exp_larger : n555;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n564 = n461 ? n462 : n556;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n565 = n461 ? exp_b : n557;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n566 = n461 ? mant_b : n558;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n567 = n461 ? mant_sum : n559;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n569 = n461 ? mant_a_aligned : n561;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n570 = n461 ? mant_b_aligned : n562;
  /* TG68K_FPU_ALU.vhd:593:65  */
  assign n571 = n461 ? exp_larger : n563;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n572 = is_inf_b ? n459 : n564;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n574 = is_inf_b ? 15'b111111111111111 : n565;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n576 = is_inf_b ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n566;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n577 = is_inf_b ? mant_sum : n567;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n579 = is_inf_b ? mant_a_aligned : n569;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n580 = is_inf_b ? mant_b_aligned : n570;
  /* TG68K_FPU_ALU.vhd:588:65  */
  assign n581 = is_inf_b ? exp_larger : n571;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n582 = is_inf_a ? sign_a : n572;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n584 = is_inf_a ? 15'b111111111111111 : n574;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n586 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n576;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n587 = is_inf_a ? mant_sum : n577;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n589 = is_inf_a ? mant_a_aligned : n579;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n590 = is_inf_a ? mant_b_aligned : n580;
  /* TG68K_FPU_ALU.vhd:583:65  */
  assign n591 = is_inf_a ? exp_larger : n581;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n592 = n450 ? n453 : n582;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n594 = n450 ? 15'b111111111111111 : n584;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n595 = n450 ? n456 : n586;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n596 = n450 ? mant_sum : n587;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n598 = n450 ? mant_a_aligned : n589;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n599 = n450 ? mant_b_aligned : n590;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n600 = n450 ? exp_larger : n591;
  /* TG68K_FPU_ALU.vhd:569:65  */
  assign n601 = n451 & n450;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n603 = n449 ? 1'b0 : n592;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n605 = n449 ? 15'b111111111111111 : n594;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n607 = n449 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n595;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n608 = n449 ? mant_sum : n596;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n610 = n449 ? mant_a_aligned : n598;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n611 = n449 ? mant_b_aligned : n599;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n612 = n449 ? exp_larger : n600;
  /* TG68K_FPU_ALU.vhd:563:65  */
  assign n614 = n449 ? 1'b1 : n458;
  /* TG68K_FPU_ALU.vhd:561:57  */
  assign n616 = operation_code == 7'b0101000;
  /* TG68K_FPU_ALU.vhd:699:87  */
  assign n617 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:700:83  */
  assign n618 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:706:87  */
  assign n619 = is_zero_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:706:128  */
  assign n620 = is_inf_b & is_zero_a;
  /* TG68K_FPU_ALU.vhd:706:108  */
  assign n621 = n619 | n620;
  /* TG68K_FPU_ALU.vhd:712:86  */
  assign n622 = is_inf_a | is_inf_b;
  /* TG68K_FPU_ALU.vhd:716:87  */
  assign n623 = is_zero_a | is_zero_b;
  /* TG68K_FPU_ALU.vhd:722:120  */
  assign n624 = exp_a + exp_b;
  /* TG68K_FPU_ALU.vhd:722:138  */
  assign n626 = n624 - 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:727:135  */
  assign n627 = {64'b0, mant_a};  //  uext
  /* TG68K_FPU_ALU.vhd:727:135  */
  assign n628 = {64'b0, mant_b};  //  uext
  /* TG68K_FPU_ALU.vhd:727:135  */
  assign n629 = n627 * n628; // umul
  /* TG68K_FPU_ALU.vhd:729:87  */
  assign n630 = mult_result[127]; // extract
  /* TG68K_FPU_ALU.vhd:731:133  */
  assign n632 = exp_result + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:732:107  */
  assign n633 = mult_result[126:63]; // extract
  /* TG68K_FPU_ALU.vhd:735:107  */
  assign n634 = mult_result[125:62]; // extract
  /* TG68K_FPU_ALU.vhd:729:73  */
  assign n635 = n630 ? n632 : n626;
  /* TG68K_FPU_ALU.vhd:729:73  */
  assign n636 = n630 ? n633 : n634;
  /* TG68K_FPU_ALU.vhd:738:87  */
  assign n637 = mult_result[61:0]; // extract
  /* TG68K_FPU_ALU.vhd:738:101  */
  assign n639 = n637 != 62'b00000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:738:73  */
  assign n641 = n639 ? 1'b1 : flags_inexact;
  /* TG68K_FPU_ALU.vhd:716:65  */
  assign n643 = n623 ? 15'b000000000000000 : n635;
  /* TG68K_FPU_ALU.vhd:716:65  */
  assign n645 = n623 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n636;
  /* TG68K_FPU_ALU.vhd:716:65  */
  assign n646 = n623 ? mult_result : n629;
  /* TG68K_FPU_ALU.vhd:716:65  */
  assign n647 = n623 ? flags_inexact : n641;
  /* TG68K_FPU_ALU.vhd:712:65  */
  assign n649 = n622 ? 15'b111111111111111 : n643;
  /* TG68K_FPU_ALU.vhd:712:65  */
  assign n651 = n622 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n645;
  /* TG68K_FPU_ALU.vhd:712:65  */
  assign n652 = n622 ? mult_result : n646;
  /* TG68K_FPU_ALU.vhd:712:65  */
  assign n653 = n622 ? flags_inexact : n647;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n655 = n621 ? 1'b0 : n617;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n657 = n621 ? 15'b111111111111111 : n649;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n659 = n621 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n651;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n660 = n621 ? mult_result : n652;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n661 = n621 ? flags_inexact : n653;
  /* TG68K_FPU_ALU.vhd:706:65  */
  assign n663 = n621 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n665 = n618 ? 1'b0 : n655;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n667 = n618 ? 15'b111111111111111 : n657;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n669 = n618 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n659;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n670 = n618 ? mult_result : n660;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n671 = n618 ? flags_inexact : n661;
  /* TG68K_FPU_ALU.vhd:700:65  */
  assign n673 = n618 ? 1'b1 : n663;
  /* TG68K_FPU_ALU.vhd:697:57  */
  assign n675 = operation_code == 7'b0100011;
  /* TG68K_FPU_ALU.vhd:746:87  */
  assign n676 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:747:83  */
  assign n677 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:753:87  */
  assign n678 = is_inf_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:753:127  */
  assign n679 = is_zero_b & is_zero_a;
  /* TG68K_FPU_ALU.vhd:753:107  */
  assign n680 = n678 | n679;
  /* TG68K_FPU_ALU.vhd:759:91  */
  assign n681 = ~is_zero_a;
  /* TG68K_FPU_ALU.vhd:759:87  */
  assign n682 = n681 & is_zero_b;
  /* TG68K_FPU_ALU.vhd:762:95  */
  assign n683 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:765:93  */
  assign n684 = ~is_zero_a;
  /* TG68K_FPU_ALU.vhd:765:89  */
  assign n685 = n684 & is_denorm_b;
  /* TG68K_FPU_ALU.vhd:770:95  */
  assign n690 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:772:82  */
  assign n691 = mant_b[63:32]; // extract
  /* TG68K_FPU_ALU.vhd:772:97  */
  assign n693 = n691 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:779:128  */
  assign n695 = exp_a - 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:779:149  */
  assign n697 = n695 + 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:780:103  */
  assign n698 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:772:73  */
  assign n699 = n693 ? n690 : n698;
  /* TG68K_FPU_ALU.vhd:772:73  */
  assign n701 = n693 ? 15'b111111111111111 : n697;
  /* TG68K_FPU_ALU.vhd:772:73  */
  assign n703 = n693 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : mant_result;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n707 = n752 ? 1'b1 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:797:120  */
  assign n708 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:797:138  */
  assign n710 = n708 + 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:803:82  */
  assign n711 = mant_b[63:32]; // extract
  /* TG68K_FPU_ALU.vhd:803:97  */
  assign n713 = n711 != 32'b00000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:806:89  */
  assign n715 = mant_a << 31'b0000000000000000000000000100000;
  /* TG68K_FPU_ALU.vhd:806:139  */
  assign n716 = mant_b[63:32]; // extract
  /* TG68K_FPU_ALU.vhd:806:122  */
  assign n717 = {32'b0, n716};  //  uext
  /* TG68K_FPU_ALU.vhd:806:122  */
  assign n718 = n715 / n717; // udiv
  /* TG68K_FPU_ALU.vhd:808:85  */
  assign n719 = mant_b[63:16]; // extract
  /* TG68K_FPU_ALU.vhd:808:100  */
  assign n721 = n719 != 48'b000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:811:89  */
  assign n723 = mant_a << 31'b0000000000000000000000000010000;
  /* TG68K_FPU_ALU.vhd:811:139  */
  assign n724 = mant_b[63:16]; // extract
  /* TG68K_FPU_ALU.vhd:811:122  */
  assign n725 = {16'b0, n724};  //  uext
  /* TG68K_FPU_ALU.vhd:811:122  */
  assign n726 = n723 / n725; // udiv
  /* TG68K_FPU_ALU.vhd:816:123  */
  assign n727 = mant_b[63:1]; // extract
  /* TG68K_FPU_ALU.vhd:816:106  */
  assign n728 = {1'b0, n727};  //  uext
  /* TG68K_FPU_ALU.vhd:816:106  */
  assign n729 = mant_a / n728; // udiv
  /* TG68K_FPU_ALU.vhd:808:73  */
  assign n730 = n721 ? n726 : n729;
  /* TG68K_FPU_ALU.vhd:803:73  */
  assign n731 = n713 ? n718 : n730;
  /* TG68K_FPU_ALU.vhd:791:65  */
  assign n733 = is_zero_a ? 15'b000000000000000 : n710;
  /* TG68K_FPU_ALU.vhd:791:65  */
  assign n735 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n731;
  /* TG68K_FPU_ALU.vhd:791:65  */
  assign n737 = is_zero_a ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:787:65  */
  assign n739 = is_inf_b ? 15'b000000000000000 : n733;
  /* TG68K_FPU_ALU.vhd:787:65  */
  assign n741 = is_inf_b ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n735;
  /* TG68K_FPU_ALU.vhd:787:65  */
  assign n742 = is_inf_b ? flags_inexact : n737;
  /* TG68K_FPU_ALU.vhd:783:65  */
  assign n744 = is_inf_a ? 15'b111111111111111 : n739;
  /* TG68K_FPU_ALU.vhd:783:65  */
  assign n746 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n741;
  /* TG68K_FPU_ALU.vhd:783:65  */
  assign n747 = is_inf_a ? flags_inexact : n742;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n748 = n685 ? n699 : n676;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n749 = n685 ? n701 : n744;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n750 = n685 ? n703 : n746;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n752 = n693 & n685;
  /* TG68K_FPU_ALU.vhd:765:65  */
  assign n753 = n685 ? flags_inexact : n747;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n754 = n682 ? n683 : n748;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n756 = n682 ? 15'b111111111111111 : n749;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n758 = n682 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n750;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n760 = n682 ? flags_overflow : n707;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n761 = n682 ? flags_inexact : n753;
  /* TG68K_FPU_ALU.vhd:759:65  */
  assign n763 = n682 ? 1'b1 : flags_div_by_zero;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n765 = n680 ? 1'b0 : n754;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n767 = n680 ? 15'b111111111111111 : n756;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n769 = n680 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n758;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n771 = n680 ? flags_overflow : n760;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n772 = n680 ? flags_inexact : n761;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n774 = n680 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:753:65  */
  assign n775 = n680 ? flags_div_by_zero : n763;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n777 = n677 ? 1'b0 : n765;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n779 = n677 ? 15'b111111111111111 : n767;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n781 = n677 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n769;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n783 = n677 ? flags_overflow : n771;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n784 = n677 ? flags_inexact : n772;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n786 = n677 ? 1'b1 : n774;
  /* TG68K_FPU_ALU.vhd:747:65  */
  assign n787 = n677 ? flags_div_by_zero : n775;
  /* TG68K_FPU_ALU.vhd:744:57  */
  assign n789 = operation_code == 7'b0100000;
  /* TG68K_FPU_ALU.vhd:832:102  */
  assign n791 = operation_code == 7'b0111000;
  /* TG68K_FPU_ALU.vhd:832:112  */
  assign n792 = is_nan_b & n791;
  /* TG68K_FPU_ALU.vhd:832:83  */
  assign n793 = is_nan_a | n792;
  /* TG68K_FPU_ALU.vhd:835:107  */
  assign n795 = operation_code == 7'b0111010;
  /* TG68K_FPU_ALU.vhd:835:117  */
  assign n796 = n795 | is_zero_b;
  /* TG68K_FPU_ALU.vhd:835:87  */
  assign n797 = n796 & is_zero_a;
  /* TG68K_FPU_ALU.vhd:838:86  */
  assign n799 = operation_code == 7'b0111010;
  /* TG68K_FPU_ALU.vhd:843:81  */
  assign n802 = sign_a ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:846:96  */
  assign n803 = ~is_zero_a;
  /* TG68K_FPU_ALU.vhd:846:92  */
  assign n804 = n803 & sign_a;
  /* TG68K_FPU_ALU.vhd:846:73  */
  assign n807 = n804 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:840:73  */
  assign n808 = is_inf_a ? n802 : n807;
  /* TG68K_FPU_ALU.vhd:853:83  */
  assign n809 = sign_a != sign_b;
  /* TG68K_FPU_ALU.vhd:855:81  */
  assign n812 = sign_a ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:859:85  */
  assign n813 = exp_a == exp_b;
  /* TG68K_FPU_ALU.vhd:859:104  */
  assign n814 = mant_a == mant_b;
  /* TG68K_FPU_ALU.vhd:859:93  */
  assign n815 = n814 & n813;
  /* TG68K_FPU_ALU.vhd:861:95  */
  assign n816 = {exp_a, mant_a};
  /* TG68K_FPU_ALU.vhd:861:122  */
  assign n817 = {exp_b, mant_b};
  /* TG68K_FPU_ALU.vhd:861:105  */
  assign n818 = $unsigned(n816) < $unsigned(n817);
  /* TG68K_FPU_ALU.vhd:861:133  */
  assign n819 = n818 ^ sign_a;
  /* TG68K_FPU_ALU.vhd:861:73  */
  assign n822 = n819 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:859:73  */
  assign n824 = n815 ? 1'b0 : n822;
  /* TG68K_FPU_ALU.vhd:853:73  */
  assign n825 = n809 ? n812 : n824;
  /* TG68K_FPU_ALU.vhd:838:65  */
  assign n826 = n799 ? n808 : n825;
  /* TG68K_FPU_ALU.vhd:835:65  */
  assign n828 = n797 ? 1'b0 : n826;
  /* TG68K_FPU_ALU.vhd:832:65  */
  assign n830 = n793 ? 1'b0 : n828;
  /* TG68K_FPU_ALU.vhd:832:65  */
  assign n833 = n793 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:825:57  */
  assign n835 = operation_code == 7'b0111000;
  /* TG68K_FPU_ALU.vhd:825:70  */
  assign n837 = operation_code == 7'b0111010;
  /* TG68K_FPU_ALU.vhd:825:70  */
  assign n838 = n835 | n837;
  /* TG68K_FPU_ALU.vhd:887:77  */
  assign n840 = $unsigned(exp_a) < $unsigned(15'b011111111111111);
  /* TG68K_FPU_ALU.vhd:889:82  */
  assign n842 = exp_a == 15'b011111111111110;
  /* TG68K_FPU_ALU.vhd:889:135  */
  assign n843 = mant_a[63]; // extract
  /* TG68K_FPU_ALU.vhd:889:125  */
  assign n844 = n843 & n842;
  /* TG68K_FPU_ALU.vhd:889:73  */
  assign n847 = n844 ? 15'b011111111111111 : 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:889:73  */
  assign n850 = n844 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:902:85  */
  assign n851 = {16'b0, exp_a};  //  uext
  /* TG68K_FPU_ALU.vhd:902:113  */
  assign n852 = {1'b0, n851};  //  uext
  /* TG68K_FPU_ALU.vhd:902:113  */
  assign n854 = n852 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:903:85  */
  assign n856 = $signed(n854) >= $signed(32'b00000000000000000000000000111111);
  /* TG68K_FPU_ALU.vhd:913:93  */
  assign n858 = $signed(n854) <= $signed(32'b00000000000000000000000000111111);
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n860 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n862 = $signed(32'b00000000000000000000000000000000) < $signed(n860);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n864 = mant_a[0]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n865 = n862 ? 1'b0 : n864;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n867 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n869 = $signed(32'b00000000000000000000000000000001) < $signed(n867);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n871 = mant_a[1]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n872 = n869 ? 1'b0 : n871;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n874 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n876 = $signed(32'b00000000000000000000000000000010) < $signed(n874);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n878 = mant_a[2]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n879 = n876 ? 1'b0 : n878;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n881 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n883 = $signed(32'b00000000000000000000000000000011) < $signed(n881);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n885 = mant_a[3]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n886 = n883 ? 1'b0 : n885;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n888 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n890 = $signed(32'b00000000000000000000000000000100) < $signed(n888);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n892 = mant_a[4]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n893 = n890 ? 1'b0 : n892;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n895 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n897 = $signed(32'b00000000000000000000000000000101) < $signed(n895);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n899 = mant_a[5]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n900 = n897 ? 1'b0 : n899;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n902 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n904 = $signed(32'b00000000000000000000000000000110) < $signed(n902);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n906 = mant_a[6]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n907 = n904 ? 1'b0 : n906;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n909 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n911 = $signed(32'b00000000000000000000000000000111) < $signed(n909);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n913 = mant_a[7]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n914 = n911 ? 1'b0 : n913;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n916 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n918 = $signed(32'b00000000000000000000000000001000) < $signed(n916);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n920 = mant_a[8]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n921 = n918 ? 1'b0 : n920;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n923 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n925 = $signed(32'b00000000000000000000000000001001) < $signed(n923);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n927 = mant_a[9]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n928 = n925 ? 1'b0 : n927;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n930 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n932 = $signed(32'b00000000000000000000000000001010) < $signed(n930);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n934 = mant_a[10]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n935 = n932 ? 1'b0 : n934;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n937 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n939 = $signed(32'b00000000000000000000000000001011) < $signed(n937);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n941 = mant_a[11]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n942 = n939 ? 1'b0 : n941;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n944 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n946 = $signed(32'b00000000000000000000000000001100) < $signed(n944);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n948 = mant_a[12]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n949 = n946 ? 1'b0 : n948;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n951 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n953 = $signed(32'b00000000000000000000000000001101) < $signed(n951);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n955 = mant_a[13]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n956 = n953 ? 1'b0 : n955;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n958 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n960 = $signed(32'b00000000000000000000000000001110) < $signed(n958);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n962 = mant_a[14]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n963 = n960 ? 1'b0 : n962;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n965 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n967 = $signed(32'b00000000000000000000000000001111) < $signed(n965);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n969 = mant_a[15]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n970 = n967 ? 1'b0 : n969;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n972 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n974 = $signed(32'b00000000000000000000000000010000) < $signed(n972);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n976 = mant_a[16]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n977 = n974 ? 1'b0 : n976;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n979 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n981 = $signed(32'b00000000000000000000000000010001) < $signed(n979);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n983 = mant_a[17]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n984 = n981 ? 1'b0 : n983;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n986 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n988 = $signed(32'b00000000000000000000000000010010) < $signed(n986);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n990 = mant_a[18]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n991 = n988 ? 1'b0 : n990;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n993 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n995 = $signed(32'b00000000000000000000000000010011) < $signed(n993);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n997 = mant_a[19]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n998 = n995 ? 1'b0 : n997;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1000 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1002 = $signed(32'b00000000000000000000000000010100) < $signed(n1000);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1004 = mant_a[20]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1005 = n1002 ? 1'b0 : n1004;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1007 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1009 = $signed(32'b00000000000000000000000000010101) < $signed(n1007);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1011 = mant_a[21]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1012 = n1009 ? 1'b0 : n1011;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1014 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1016 = $signed(32'b00000000000000000000000000010110) < $signed(n1014);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1018 = mant_a[22]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1019 = n1016 ? 1'b0 : n1018;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1021 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1023 = $signed(32'b00000000000000000000000000010111) < $signed(n1021);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1025 = mant_a[23]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1026 = n1023 ? 1'b0 : n1025;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1028 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1030 = $signed(32'b00000000000000000000000000011000) < $signed(n1028);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1032 = mant_a[24]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1033 = n1030 ? 1'b0 : n1032;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1035 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1037 = $signed(32'b00000000000000000000000000011001) < $signed(n1035);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1039 = mant_a[25]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1040 = n1037 ? 1'b0 : n1039;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1042 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1044 = $signed(32'b00000000000000000000000000011010) < $signed(n1042);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1046 = mant_a[26]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1047 = n1044 ? 1'b0 : n1046;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1049 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1051 = $signed(32'b00000000000000000000000000011011) < $signed(n1049);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1053 = mant_a[27]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1054 = n1051 ? 1'b0 : n1053;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1056 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1058 = $signed(32'b00000000000000000000000000011100) < $signed(n1056);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1060 = mant_a[28]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1061 = n1058 ? 1'b0 : n1060;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1063 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1065 = $signed(32'b00000000000000000000000000011101) < $signed(n1063);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1067 = mant_a[29]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1068 = n1065 ? 1'b0 : n1067;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1070 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1072 = $signed(32'b00000000000000000000000000011110) < $signed(n1070);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1074 = mant_a[30]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1075 = n1072 ? 1'b0 : n1074;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1077 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1079 = $signed(32'b00000000000000000000000000011111) < $signed(n1077);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1081 = mant_a[31]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1082 = n1079 ? 1'b0 : n1081;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1084 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1086 = $signed(32'b00000000000000000000000000100000) < $signed(n1084);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1088 = mant_a[32]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1089 = n1086 ? 1'b0 : n1088;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1091 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1093 = $signed(32'b00000000000000000000000000100001) < $signed(n1091);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1095 = mant_a[33]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1096 = n1093 ? 1'b0 : n1095;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1098 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1100 = $signed(32'b00000000000000000000000000100010) < $signed(n1098);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1102 = mant_a[34]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1103 = n1100 ? 1'b0 : n1102;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1105 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1107 = $signed(32'b00000000000000000000000000100011) < $signed(n1105);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1109 = mant_a[35]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1110 = n1107 ? 1'b0 : n1109;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1112 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1114 = $signed(32'b00000000000000000000000000100100) < $signed(n1112);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1116 = mant_a[36]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1117 = n1114 ? 1'b0 : n1116;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1119 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1121 = $signed(32'b00000000000000000000000000100101) < $signed(n1119);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1123 = mant_a[37]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1124 = n1121 ? 1'b0 : n1123;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1126 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1128 = $signed(32'b00000000000000000000000000100110) < $signed(n1126);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1130 = mant_a[38]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1131 = n1128 ? 1'b0 : n1130;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1133 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1135 = $signed(32'b00000000000000000000000000100111) < $signed(n1133);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1137 = mant_a[39]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1138 = n1135 ? 1'b0 : n1137;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1140 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1142 = $signed(32'b00000000000000000000000000101000) < $signed(n1140);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1144 = mant_a[40]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1145 = n1142 ? 1'b0 : n1144;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1147 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1149 = $signed(32'b00000000000000000000000000101001) < $signed(n1147);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1151 = mant_a[41]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1152 = n1149 ? 1'b0 : n1151;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1154 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1156 = $signed(32'b00000000000000000000000000101010) < $signed(n1154);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1158 = mant_a[42]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1159 = n1156 ? 1'b0 : n1158;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1161 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1163 = $signed(32'b00000000000000000000000000101011) < $signed(n1161);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1165 = mant_a[43]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1166 = n1163 ? 1'b0 : n1165;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1168 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1170 = $signed(32'b00000000000000000000000000101100) < $signed(n1168);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1172 = mant_a[44]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1173 = n1170 ? 1'b0 : n1172;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1175 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1177 = $signed(32'b00000000000000000000000000101101) < $signed(n1175);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1179 = mant_a[45]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1180 = n1177 ? 1'b0 : n1179;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1182 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1184 = $signed(32'b00000000000000000000000000101110) < $signed(n1182);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1186 = mant_a[46]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1187 = n1184 ? 1'b0 : n1186;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1189 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1191 = $signed(32'b00000000000000000000000000101111) < $signed(n1189);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1193 = mant_a[47]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1194 = n1191 ? 1'b0 : n1193;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1196 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1198 = $signed(32'b00000000000000000000000000110000) < $signed(n1196);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1200 = mant_a[48]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1201 = n1198 ? 1'b0 : n1200;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1203 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1205 = $signed(32'b00000000000000000000000000110001) < $signed(n1203);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1207 = mant_a[49]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1208 = n1205 ? 1'b0 : n1207;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1210 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1212 = $signed(32'b00000000000000000000000000110010) < $signed(n1210);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1214 = mant_a[50]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1215 = n1212 ? 1'b0 : n1214;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1217 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1219 = $signed(32'b00000000000000000000000000110011) < $signed(n1217);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1221 = mant_a[51]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1222 = n1219 ? 1'b0 : n1221;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1224 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1226 = $signed(32'b00000000000000000000000000110100) < $signed(n1224);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1228 = mant_a[52]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1229 = n1226 ? 1'b0 : n1228;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1231 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1233 = $signed(32'b00000000000000000000000000110101) < $signed(n1231);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1235 = mant_a[53]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1236 = n1233 ? 1'b0 : n1235;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1238 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1240 = $signed(32'b00000000000000000000000000110110) < $signed(n1238);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1242 = mant_a[54]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1243 = n1240 ? 1'b0 : n1242;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1245 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1247 = $signed(32'b00000000000000000000000000110111) < $signed(n1245);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1249 = mant_a[55]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1250 = n1247 ? 1'b0 : n1249;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1252 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1254 = $signed(32'b00000000000000000000000000111000) < $signed(n1252);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1256 = mant_a[56]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1257 = n1254 ? 1'b0 : n1256;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1259 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1261 = $signed(32'b00000000000000000000000000111001) < $signed(n1259);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1263 = mant_a[57]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1264 = n1261 ? 1'b0 : n1263;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1266 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1268 = $signed(32'b00000000000000000000000000111010) < $signed(n1266);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1270 = mant_a[58]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1271 = n1268 ? 1'b0 : n1270;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1273 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1275 = $signed(32'b00000000000000000000000000111011) < $signed(n1273);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1277 = mant_a[59]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1278 = n1275 ? 1'b0 : n1277;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1280 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1282 = $signed(32'b00000000000000000000000000111100) < $signed(n1280);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1284 = mant_a[60]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1285 = n1282 ? 1'b0 : n1284;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1287 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1289 = $signed(32'b00000000000000000000000000111101) < $signed(n1287);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1291 = mant_a[61]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1292 = n1289 ? 1'b0 : n1291;
  /* TG68K_FPU_ALU.vhd:915:108  */
  assign n1294 = 32'b00000000000000000000000000111111 - n854;
  /* TG68K_FPU_ALU.vhd:915:102  */
  assign n1296 = $signed(32'b00000000000000000000000000111110) < $signed(n1294);
  /* TG68K_FPU_ALU.vhd:918:129  */
  assign n1298 = mant_a[62]; // extract
  /* TG68K_FPU_ALU.vhd:915:97  */
  assign n1299 = n1296 ? 1'b0 : n1298;
  /* TG68K_FPU_ALU.vhd:921:114  */
  assign n1300 = mant_a[63]; // extract
  assign n1301 = {n1300, n1299, n1292, n1285, n1278, n1271, n1264, n1257, n1250, n1243, n1236, n1229, n1222, n1215, n1208, n1201, n1194, n1187, n1180, n1173, n1166, n1159, n1152, n1145, n1138, n1131, n1124, n1117, n1110, n1103, n1096, n1089, n1082, n1075, n1068, n1061, n1054, n1047, n1040, n1033, n1026, n1019, n1012, n1005, n998, n991, n984, n977, n970, n963, n956, n949, n942, n935, n928, n921, n914, n907, n900, n893, n886, n879, n872, n865};
  /* TG68K_FPU_ALU.vhd:913:81  */
  assign n1302 = n858 ? n1301 : mant_a;
  /* TG68K_FPU_ALU.vhd:903:73  */
  assign n1303 = n856 ? mant_a : n1302;
  /* TG68K_FPU_ALU.vhd:887:65  */
  assign n1304 = n840 ? n847 : exp_a;
  /* TG68K_FPU_ALU.vhd:887:65  */
  assign n1305 = n840 ? n850 : n1303;
  /* TG68K_FPU_ALU.vhd:887:65  */
  assign n1307 = n840 ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:882:65  */
  assign n1310 = is_zero_a ? 15'b000000000000000 : n1304;
  /* TG68K_FPU_ALU.vhd:882:65  */
  assign n1312 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1305;
  /* TG68K_FPU_ALU.vhd:882:65  */
  assign n1313 = is_zero_a ? flags_inexact : n1307;
  /* TG68K_FPU_ALU.vhd:877:65  */
  assign n1316 = is_inf_a ? 15'b111111111111111 : n1310;
  /* TG68K_FPU_ALU.vhd:877:65  */
  assign n1318 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1312;
  /* TG68K_FPU_ALU.vhd:877:65  */
  assign n1319 = is_inf_a ? flags_inexact : n1313;
  /* TG68K_FPU_ALU.vhd:871:65  */
  assign n1322 = is_nan_a ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:871:65  */
  assign n1324 = is_nan_a ? 15'b111111111111111 : n1316;
  /* TG68K_FPU_ALU.vhd:871:65  */
  assign n1326 = is_nan_a ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1318;
  /* TG68K_FPU_ALU.vhd:871:65  */
  assign n1327 = is_nan_a ? flags_inexact : n1319;
  /* TG68K_FPU_ALU.vhd:871:65  */
  assign n1329 = is_nan_a ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:869:57  */
  assign n1332 = operation_code == 7'b0000001;
  /* TG68K_FPU_ALU.vhd:948:77  */
  assign n1334 = $unsigned(exp_a) < $unsigned(15'b011111111111111);
  /* TG68K_FPU_ALU.vhd:955:85  */
  assign n1335 = {16'b0, exp_a};  //  uext
  /* TG68K_FPU_ALU.vhd:955:113  */
  assign n1336 = {1'b0, n1335};  //  uext
  /* TG68K_FPU_ALU.vhd:955:113  */
  assign n1338 = n1336 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:956:85  */
  assign n1340 = $signed(n1338) >= $signed(32'b00000000000000000000000000111111);
  /* TG68K_FPU_ALU.vhd:966:93  */
  assign n1342 = $signed(n1338) <= $signed(32'b00000000000000000000000000111111);
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1344 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1346 = $signed(32'b00000000000000000000000000000000) < $signed(n1344);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1348 = mant_a[0]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1349 = n1346 ? 1'b0 : n1348;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1351 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1353 = $signed(32'b00000000000000000000000000000001) < $signed(n1351);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1355 = mant_a[1]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1356 = n1353 ? 1'b0 : n1355;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1358 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1360 = $signed(32'b00000000000000000000000000000010) < $signed(n1358);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1362 = mant_a[2]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1363 = n1360 ? 1'b0 : n1362;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1365 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1367 = $signed(32'b00000000000000000000000000000011) < $signed(n1365);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1369 = mant_a[3]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1370 = n1367 ? 1'b0 : n1369;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1372 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1374 = $signed(32'b00000000000000000000000000000100) < $signed(n1372);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1376 = mant_a[4]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1377 = n1374 ? 1'b0 : n1376;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1379 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1381 = $signed(32'b00000000000000000000000000000101) < $signed(n1379);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1383 = mant_a[5]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1384 = n1381 ? 1'b0 : n1383;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1386 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1388 = $signed(32'b00000000000000000000000000000110) < $signed(n1386);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1390 = mant_a[6]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1391 = n1388 ? 1'b0 : n1390;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1393 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1395 = $signed(32'b00000000000000000000000000000111) < $signed(n1393);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1397 = mant_a[7]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1398 = n1395 ? 1'b0 : n1397;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1400 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1402 = $signed(32'b00000000000000000000000000001000) < $signed(n1400);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1404 = mant_a[8]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1405 = n1402 ? 1'b0 : n1404;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1407 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1409 = $signed(32'b00000000000000000000000000001001) < $signed(n1407);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1411 = mant_a[9]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1412 = n1409 ? 1'b0 : n1411;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1414 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1416 = $signed(32'b00000000000000000000000000001010) < $signed(n1414);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1418 = mant_a[10]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1419 = n1416 ? 1'b0 : n1418;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1421 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1423 = $signed(32'b00000000000000000000000000001011) < $signed(n1421);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1425 = mant_a[11]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1426 = n1423 ? 1'b0 : n1425;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1428 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1430 = $signed(32'b00000000000000000000000000001100) < $signed(n1428);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1432 = mant_a[12]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1433 = n1430 ? 1'b0 : n1432;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1435 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1437 = $signed(32'b00000000000000000000000000001101) < $signed(n1435);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1439 = mant_a[13]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1440 = n1437 ? 1'b0 : n1439;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1442 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1444 = $signed(32'b00000000000000000000000000001110) < $signed(n1442);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1446 = mant_a[14]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1447 = n1444 ? 1'b0 : n1446;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1449 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1451 = $signed(32'b00000000000000000000000000001111) < $signed(n1449);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1453 = mant_a[15]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1454 = n1451 ? 1'b0 : n1453;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1456 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1458 = $signed(32'b00000000000000000000000000010000) < $signed(n1456);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1460 = mant_a[16]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1461 = n1458 ? 1'b0 : n1460;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1463 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1465 = $signed(32'b00000000000000000000000000010001) < $signed(n1463);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1467 = mant_a[17]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1468 = n1465 ? 1'b0 : n1467;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1470 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1472 = $signed(32'b00000000000000000000000000010010) < $signed(n1470);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1474 = mant_a[18]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1475 = n1472 ? 1'b0 : n1474;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1477 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1479 = $signed(32'b00000000000000000000000000010011) < $signed(n1477);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1481 = mant_a[19]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1482 = n1479 ? 1'b0 : n1481;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1484 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1486 = $signed(32'b00000000000000000000000000010100) < $signed(n1484);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1488 = mant_a[20]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1489 = n1486 ? 1'b0 : n1488;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1491 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1493 = $signed(32'b00000000000000000000000000010101) < $signed(n1491);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1495 = mant_a[21]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1496 = n1493 ? 1'b0 : n1495;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1498 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1500 = $signed(32'b00000000000000000000000000010110) < $signed(n1498);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1502 = mant_a[22]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1503 = n1500 ? 1'b0 : n1502;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1505 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1507 = $signed(32'b00000000000000000000000000010111) < $signed(n1505);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1509 = mant_a[23]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1510 = n1507 ? 1'b0 : n1509;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1512 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1514 = $signed(32'b00000000000000000000000000011000) < $signed(n1512);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1516 = mant_a[24]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1517 = n1514 ? 1'b0 : n1516;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1519 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1521 = $signed(32'b00000000000000000000000000011001) < $signed(n1519);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1523 = mant_a[25]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1524 = n1521 ? 1'b0 : n1523;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1526 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1528 = $signed(32'b00000000000000000000000000011010) < $signed(n1526);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1530 = mant_a[26]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1531 = n1528 ? 1'b0 : n1530;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1533 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1535 = $signed(32'b00000000000000000000000000011011) < $signed(n1533);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1537 = mant_a[27]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1538 = n1535 ? 1'b0 : n1537;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1540 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1542 = $signed(32'b00000000000000000000000000011100) < $signed(n1540);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1544 = mant_a[28]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1545 = n1542 ? 1'b0 : n1544;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1547 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1549 = $signed(32'b00000000000000000000000000011101) < $signed(n1547);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1551 = mant_a[29]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1552 = n1549 ? 1'b0 : n1551;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1554 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1556 = $signed(32'b00000000000000000000000000011110) < $signed(n1554);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1558 = mant_a[30]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1559 = n1556 ? 1'b0 : n1558;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1561 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1563 = $signed(32'b00000000000000000000000000011111) < $signed(n1561);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1565 = mant_a[31]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1566 = n1563 ? 1'b0 : n1565;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1568 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1570 = $signed(32'b00000000000000000000000000100000) < $signed(n1568);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1572 = mant_a[32]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1573 = n1570 ? 1'b0 : n1572;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1575 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1577 = $signed(32'b00000000000000000000000000100001) < $signed(n1575);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1579 = mant_a[33]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1580 = n1577 ? 1'b0 : n1579;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1582 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1584 = $signed(32'b00000000000000000000000000100010) < $signed(n1582);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1586 = mant_a[34]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1587 = n1584 ? 1'b0 : n1586;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1589 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1591 = $signed(32'b00000000000000000000000000100011) < $signed(n1589);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1593 = mant_a[35]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1594 = n1591 ? 1'b0 : n1593;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1596 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1598 = $signed(32'b00000000000000000000000000100100) < $signed(n1596);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1600 = mant_a[36]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1601 = n1598 ? 1'b0 : n1600;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1603 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1605 = $signed(32'b00000000000000000000000000100101) < $signed(n1603);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1607 = mant_a[37]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1608 = n1605 ? 1'b0 : n1607;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1610 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1612 = $signed(32'b00000000000000000000000000100110) < $signed(n1610);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1614 = mant_a[38]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1615 = n1612 ? 1'b0 : n1614;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1617 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1619 = $signed(32'b00000000000000000000000000100111) < $signed(n1617);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1621 = mant_a[39]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1622 = n1619 ? 1'b0 : n1621;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1624 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1626 = $signed(32'b00000000000000000000000000101000) < $signed(n1624);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1628 = mant_a[40]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1629 = n1626 ? 1'b0 : n1628;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1631 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1633 = $signed(32'b00000000000000000000000000101001) < $signed(n1631);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1635 = mant_a[41]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1636 = n1633 ? 1'b0 : n1635;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1638 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1640 = $signed(32'b00000000000000000000000000101010) < $signed(n1638);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1642 = mant_a[42]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1643 = n1640 ? 1'b0 : n1642;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1645 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1647 = $signed(32'b00000000000000000000000000101011) < $signed(n1645);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1649 = mant_a[43]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1650 = n1647 ? 1'b0 : n1649;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1652 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1654 = $signed(32'b00000000000000000000000000101100) < $signed(n1652);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1656 = mant_a[44]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1657 = n1654 ? 1'b0 : n1656;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1659 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1661 = $signed(32'b00000000000000000000000000101101) < $signed(n1659);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1663 = mant_a[45]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1664 = n1661 ? 1'b0 : n1663;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1666 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1668 = $signed(32'b00000000000000000000000000101110) < $signed(n1666);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1670 = mant_a[46]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1671 = n1668 ? 1'b0 : n1670;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1673 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1675 = $signed(32'b00000000000000000000000000101111) < $signed(n1673);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1677 = mant_a[47]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1678 = n1675 ? 1'b0 : n1677;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1680 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1682 = $signed(32'b00000000000000000000000000110000) < $signed(n1680);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1684 = mant_a[48]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1685 = n1682 ? 1'b0 : n1684;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1687 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1689 = $signed(32'b00000000000000000000000000110001) < $signed(n1687);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1691 = mant_a[49]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1692 = n1689 ? 1'b0 : n1691;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1694 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1696 = $signed(32'b00000000000000000000000000110010) < $signed(n1694);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1698 = mant_a[50]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1699 = n1696 ? 1'b0 : n1698;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1701 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1703 = $signed(32'b00000000000000000000000000110011) < $signed(n1701);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1705 = mant_a[51]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1706 = n1703 ? 1'b0 : n1705;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1708 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1710 = $signed(32'b00000000000000000000000000110100) < $signed(n1708);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1712 = mant_a[52]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1713 = n1710 ? 1'b0 : n1712;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1715 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1717 = $signed(32'b00000000000000000000000000110101) < $signed(n1715);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1719 = mant_a[53]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1720 = n1717 ? 1'b0 : n1719;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1722 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1724 = $signed(32'b00000000000000000000000000110110) < $signed(n1722);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1726 = mant_a[54]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1727 = n1724 ? 1'b0 : n1726;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1729 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1731 = $signed(32'b00000000000000000000000000110111) < $signed(n1729);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1733 = mant_a[55]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1734 = n1731 ? 1'b0 : n1733;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1736 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1738 = $signed(32'b00000000000000000000000000111000) < $signed(n1736);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1740 = mant_a[56]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1741 = n1738 ? 1'b0 : n1740;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1743 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1745 = $signed(32'b00000000000000000000000000111001) < $signed(n1743);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1747 = mant_a[57]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1748 = n1745 ? 1'b0 : n1747;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1750 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1752 = $signed(32'b00000000000000000000000000111010) < $signed(n1750);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1754 = mant_a[58]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1755 = n1752 ? 1'b0 : n1754;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1757 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1759 = $signed(32'b00000000000000000000000000111011) < $signed(n1757);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1761 = mant_a[59]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1762 = n1759 ? 1'b0 : n1761;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1764 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1766 = $signed(32'b00000000000000000000000000111100) < $signed(n1764);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1768 = mant_a[60]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1769 = n1766 ? 1'b0 : n1768;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1771 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1773 = $signed(32'b00000000000000000000000000111101) < $signed(n1771);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1775 = mant_a[61]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1776 = n1773 ? 1'b0 : n1775;
  /* TG68K_FPU_ALU.vhd:968:108  */
  assign n1778 = 32'b00000000000000000000000000111111 - n1338;
  /* TG68K_FPU_ALU.vhd:968:102  */
  assign n1780 = $signed(32'b00000000000000000000000000111110) < $signed(n1778);
  /* TG68K_FPU_ALU.vhd:971:129  */
  assign n1782 = mant_a[62]; // extract
  /* TG68K_FPU_ALU.vhd:968:97  */
  assign n1783 = n1780 ? 1'b0 : n1782;
  /* TG68K_FPU_ALU.vhd:974:114  */
  assign n1784 = mant_a[63]; // extract
  assign n1785 = {n1784, n1783, n1776, n1769, n1762, n1755, n1748, n1741, n1734, n1727, n1720, n1713, n1706, n1699, n1692, n1685, n1678, n1671, n1664, n1657, n1650, n1643, n1636, n1629, n1622, n1615, n1608, n1601, n1594, n1587, n1580, n1573, n1566, n1559, n1552, n1545, n1538, n1531, n1524, n1517, n1510, n1503, n1496, n1489, n1482, n1475, n1468, n1461, n1454, n1447, n1440, n1433, n1426, n1419, n1412, n1405, n1398, n1391, n1384, n1377, n1370, n1363, n1356, n1349};
  /* TG68K_FPU_ALU.vhd:966:81  */
  assign n1786 = n1342 ? n1785 : mant_a;
  /* TG68K_FPU_ALU.vhd:956:73  */
  assign n1787 = n1340 ? mant_a : n1786;
  /* TG68K_FPU_ALU.vhd:948:65  */
  assign n1789 = n1334 ? 15'b000000000000000 : exp_a;
  /* TG68K_FPU_ALU.vhd:948:65  */
  assign n1791 = n1334 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1787;
  /* TG68K_FPU_ALU.vhd:948:65  */
  assign n1793 = n1334 ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:943:65  */
  assign n1796 = is_zero_a ? 15'b000000000000000 : n1789;
  /* TG68K_FPU_ALU.vhd:943:65  */
  assign n1798 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1791;
  /* TG68K_FPU_ALU.vhd:943:65  */
  assign n1799 = is_zero_a ? flags_inexact : n1793;
  /* TG68K_FPU_ALU.vhd:938:65  */
  assign n1802 = is_inf_a ? 15'b111111111111111 : n1796;
  /* TG68K_FPU_ALU.vhd:938:65  */
  assign n1804 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1798;
  /* TG68K_FPU_ALU.vhd:938:65  */
  assign n1805 = is_inf_a ? flags_inexact : n1799;
  /* TG68K_FPU_ALU.vhd:932:65  */
  assign n1808 = is_nan_a ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:932:65  */
  assign n1810 = is_nan_a ? 15'b111111111111111 : n1802;
  /* TG68K_FPU_ALU.vhd:932:65  */
  assign n1812 = is_nan_a ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1804;
  /* TG68K_FPU_ALU.vhd:932:65  */
  assign n1813 = is_nan_a ? flags_inexact : n1805;
  /* TG68K_FPU_ALU.vhd:932:65  */
  assign n1815 = is_nan_a ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:930:57  */
  assign n1818 = operation_code == 7'b0000011;
  /* TG68K_FPU_ALU.vhd:985:87  */
  assign n1819 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:986:83  */
  assign n1820 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:992:87  */
  assign n1821 = is_inf_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:992:127  */
  assign n1822 = is_zero_b & is_zero_a;
  /* TG68K_FPU_ALU.vhd:992:107  */
  assign n1823 = n1821 | n1822;
  /* TG68K_FPU_ALU.vhd:998:91  */
  assign n1824 = ~is_zero_a;
  /* TG68K_FPU_ALU.vhd:998:87  */
  assign n1825 = n1824 & is_zero_b;
  /* TG68K_FPU_ALU.vhd:1017:120  */
  assign n1826 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1017:138  */
  assign n1828 = n1826 + 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:1019:83  */
  assign n1829 = mant_a == mant_b;
  /* TG68K_FPU_ALU.vhd:1021:96  */
  assign n1830 = $unsigned(mant_a) > $unsigned(mant_b);
  /* TG68K_FPU_ALU.vhd:1022:90  */
  assign n1831 = mant_b[63:48]; // extract
  /* TG68K_FPU_ALU.vhd:1022:105  */
  assign n1833 = n1831 != 16'b0000000000000000;
  /* TG68K_FPU_ALU.vhd:1024:112  */
  assign n1834 = mant_a[63:32]; // extract
  /* TG68K_FPU_ALU.vhd:1024:128  */
  assign n1835 = {32'b0, n1834};  //  uext
  /* TG68K_FPU_ALU.vhd:1024:128  */
  assign n1837 = $signed(n1835) * $signed(64'b0000000000000000000000000000000000000000000000000000100000000000); // smul
  /* TG68K_FPU_ALU.vhd:1024:152  */
  assign n1838 = mant_b[63:48]; // extract
  /* TG68K_FPU_ALU.vhd:1024:135  */
  assign n1839 = {48'b0, n1838};  //  uext
  /* TG68K_FPU_ALU.vhd:1024:135  */
  assign n1840 = n1837 / n1839; // udiv
  /* TG68K_FPU_ALU.vhd:1022:81  */
  assign n1842 = n1833 ? n1840 : 64'b1111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_ALU.vhd:1022:81  */
  assign n1844 = n1833 ? flags_overflow : 1'b1;
  /* TG68K_FPU_ALU.vhd:1031:133  */
  assign n1846 = exp_result - 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:1032:90  */
  assign n1847 = mant_b[63:48]; // extract
  /* TG68K_FPU_ALU.vhd:1032:105  */
  assign n1849 = n1847 != 16'b0000000000000000;
  /* TG68K_FPU_ALU.vhd:1035:112  */
  assign n1850 = mant_a[63:32]; // extract
  /* TG68K_FPU_ALU.vhd:1035:128  */
  assign n1851 = {32'b0, n1850};  //  uext
  /* TG68K_FPU_ALU.vhd:1035:128  */
  assign n1853 = $signed(n1851) * $signed(64'b0000000000000000000000000000000000000000000000000001000000000000); // smul
  /* TG68K_FPU_ALU.vhd:1035:152  */
  assign n1854 = mant_b[63:48]; // extract
  /* TG68K_FPU_ALU.vhd:1035:135  */
  assign n1855 = {48'b0, n1854};  //  uext
  /* TG68K_FPU_ALU.vhd:1035:135  */
  assign n1856 = n1853 / n1855; // udiv
  /* TG68K_FPU_ALU.vhd:1038:110  */
  assign n1857 = mant_a[62:0]; // extract
  /* TG68K_FPU_ALU.vhd:1038:124  */
  assign n1859 = {n1857, 1'b0};
  /* TG68K_FPU_ALU.vhd:1032:81  */
  assign n1860 = n1849 ? n1856 : n1859;
  /* TG68K_FPU_ALU.vhd:1021:73  */
  assign n1861 = n1830 ? n1828 : n1846;
  /* TG68K_FPU_ALU.vhd:1021:73  */
  assign n1862 = n1830 ? n1842 : n1860;
  /* TG68K_FPU_ALU.vhd:1021:73  */
  assign n1863 = n1830 ? n1844 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:1019:73  */
  assign n1864 = n1829 ? n1828 : n1861;
  /* TG68K_FPU_ALU.vhd:1019:73  */
  assign n1866 = n1829 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1862;
  /* TG68K_FPU_ALU.vhd:1019:73  */
  assign n1867 = n1829 ? flags_overflow : n1863;
  assign n1869 = n1866[63:40]; // extract
  /* TG68K_FPU_ALU.vhd:1011:65  */
  assign n1871 = is_zero_a ? 15'b000000000000000 : n1864;
  assign n1872 = {n1869, 40'b0000000000000000000000000000000000000000};
  /* TG68K_FPU_ALU.vhd:1011:65  */
  assign n1874 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1872;
  /* TG68K_FPU_ALU.vhd:1011:65  */
  assign n1875 = is_zero_a ? flags_overflow : n1867;
  /* TG68K_FPU_ALU.vhd:1011:65  */
  assign n1877 = is_zero_a ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:1007:65  */
  assign n1879 = is_inf_b ? 15'b000000000000000 : n1871;
  /* TG68K_FPU_ALU.vhd:1007:65  */
  assign n1881 = is_inf_b ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1874;
  /* TG68K_FPU_ALU.vhd:1007:65  */
  assign n1882 = is_inf_b ? flags_overflow : n1875;
  /* TG68K_FPU_ALU.vhd:1007:65  */
  assign n1883 = is_inf_b ? flags_inexact : n1877;
  /* TG68K_FPU_ALU.vhd:1003:65  */
  assign n1885 = is_inf_a ? 15'b111111111111111 : n1879;
  /* TG68K_FPU_ALU.vhd:1003:65  */
  assign n1887 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1881;
  /* TG68K_FPU_ALU.vhd:1003:65  */
  assign n1888 = is_inf_a ? flags_overflow : n1882;
  /* TG68K_FPU_ALU.vhd:1003:65  */
  assign n1889 = is_inf_a ? flags_inexact : n1883;
  /* TG68K_FPU_ALU.vhd:998:65  */
  assign n1891 = n1825 ? 15'b111111111111111 : n1885;
  /* TG68K_FPU_ALU.vhd:998:65  */
  assign n1893 = n1825 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1887;
  /* TG68K_FPU_ALU.vhd:998:65  */
  assign n1894 = n1825 ? flags_overflow : n1888;
  /* TG68K_FPU_ALU.vhd:998:65  */
  assign n1895 = n1825 ? flags_inexact : n1889;
  /* TG68K_FPU_ALU.vhd:998:65  */
  assign n1897 = n1825 ? 1'b1 : flags_div_by_zero;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1899 = n1823 ? 1'b0 : n1819;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1901 = n1823 ? 15'b111111111111111 : n1891;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1903 = n1823 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1893;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1904 = n1823 ? flags_overflow : n1894;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1905 = n1823 ? flags_inexact : n1895;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1907 = n1823 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:992:65  */
  assign n1908 = n1823 ? flags_div_by_zero : n1897;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1910 = n1820 ? 1'b0 : n1899;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1912 = n1820 ? 15'b111111111111111 : n1901;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1914 = n1820 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1903;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1915 = n1820 ? flags_overflow : n1904;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1916 = n1820 ? flags_inexact : n1905;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1918 = n1820 ? 1'b1 : n1907;
  /* TG68K_FPU_ALU.vhd:986:65  */
  assign n1919 = n1820 ? flags_div_by_zero : n1908;
  /* TG68K_FPU_ALU.vhd:983:57  */
  assign n1921 = operation_code == 7'b0100100;
  /* TG68K_FPU_ALU.vhd:1049:87  */
  assign n1922 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:1050:83  */
  assign n1923 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:1056:87  */
  assign n1924 = is_zero_b & is_inf_a;
  /* TG68K_FPU_ALU.vhd:1056:128  */
  assign n1925 = is_inf_b & is_zero_a;
  /* TG68K_FPU_ALU.vhd:1056:108  */
  assign n1926 = n1924 | n1925;
  /* TG68K_FPU_ALU.vhd:1062:86  */
  assign n1927 = is_inf_a | is_inf_b;
  /* TG68K_FPU_ALU.vhd:1066:87  */
  assign n1928 = is_zero_a | is_zero_b;
  /* TG68K_FPU_ALU.vhd:1072:120  */
  assign n1929 = exp_a + exp_b;
  /* TG68K_FPU_ALU.vhd:1072:138  */
  assign n1931 = n1929 - 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:1075:82  */
  assign n1932 = mant_a[63:56]; // extract
  /* TG68K_FPU_ALU.vhd:1075:105  */
  assign n1933 = mant_b[63:56]; // extract
  /* TG68K_FPU_ALU.vhd:1075:97  */
  assign n1934 = $unsigned(n1932) > $unsigned(n1933);
  /* TG68K_FPU_ALU.vhd:1075:73  */
  assign n1935 = n1934 ? mant_a : mant_b;
  /* TG68K_FPU_ALU.vhd:1066:65  */
  assign n1937 = n1928 ? 15'b000000000000000 : n1931;
  /* TG68K_FPU_ALU.vhd:1066:65  */
  assign n1939 = n1928 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1935;
  /* TG68K_FPU_ALU.vhd:1066:65  */
  assign n1941 = n1928 ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:1062:65  */
  assign n1943 = n1927 ? 15'b111111111111111 : n1937;
  /* TG68K_FPU_ALU.vhd:1062:65  */
  assign n1945 = n1927 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1939;
  /* TG68K_FPU_ALU.vhd:1062:65  */
  assign n1946 = n1927 ? flags_inexact : n1941;
  /* TG68K_FPU_ALU.vhd:1056:65  */
  assign n1948 = n1926 ? 1'b0 : n1922;
  /* TG68K_FPU_ALU.vhd:1056:65  */
  assign n1950 = n1926 ? 15'b111111111111111 : n1943;
  /* TG68K_FPU_ALU.vhd:1056:65  */
  assign n1952 = n1926 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1945;
  /* TG68K_FPU_ALU.vhd:1056:65  */
  assign n1953 = n1926 ? flags_inexact : n1946;
  /* TG68K_FPU_ALU.vhd:1056:65  */
  assign n1955 = n1926 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:1050:65  */
  assign n1957 = n1923 ? 1'b0 : n1948;
  /* TG68K_FPU_ALU.vhd:1050:65  */
  assign n1959 = n1923 ? 15'b111111111111111 : n1950;
  /* TG68K_FPU_ALU.vhd:1050:65  */
  assign n1961 = n1923 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1952;
  /* TG68K_FPU_ALU.vhd:1050:65  */
  assign n1962 = n1923 ? flags_inexact : n1953;
  /* TG68K_FPU_ALU.vhd:1050:65  */
  assign n1964 = n1923 ? 1'b1 : n1955;
  /* TG68K_FPU_ALU.vhd:1047:57  */
  assign n1966 = operation_code == 7'b0100111;
  /* TG68K_FPU_ALU.vhd:1086:83  */
  assign n1967 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:1086:101  */
  assign n1968 = n1967 | is_inf_a;
  /* TG68K_FPU_ALU.vhd:1086:119  */
  assign n1969 = n1968 | is_zero_b;
  /* TG68K_FPU_ALU.vhd:1100:92  */
  assign n1970 = $unsigned(exp_a) >= $unsigned(exp_b);
  /* TG68K_FPU_ALU.vhd:1105:100  */
  assign n1971 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1105:118  */
  assign n1973 = $unsigned(n1971) < $unsigned(15'b000000000000111);
  /* TG68K_FPU_ALU.vhd:1108:124  */
  assign n1974 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1107:129  */
  assign n1976 = n1974[6:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1107:110  */
  assign n1978 = {1'b0, n1976};
  /* TG68K_FPU_ALU.vhd:1111:160  */
  assign n1980 = mant_b + 64'b0000000000000000000000000000000000000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1111:138  */
  assign n1981 = mant_a % n1980; // umod
  /* TG68K_FPU_ALU.vhd:1112:103  */
  assign n1982 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1112:121  */
  assign n1984 = $unsigned(n1982) < $unsigned(15'b000000001000000);
  /* TG68K_FPU_ALU.vhd:1116:160  */
  assign n1986 = mant_b + 64'b0000000000000000000000000000000000000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1116:138  */
  assign n1987 = mant_a % n1986; // umod
  /* TG68K_FPU_ALU.vhd:1112:81  */
  assign n1988 = n1984 ? n1987 : mant_b;
  /* TG68K_FPU_ALU.vhd:1105:81  */
  assign n1989 = n1973 ? n1981 : n1988;
  /* TG68K_FPU_ALU.vhd:1105:81  */
  assign n1991 = n1973 ? n1978 : 8'b01111111;
  /* TG68K_FPU_ALU.vhd:1100:73  */
  assign n1992 = n1970 ? exp_b : exp_a;
  /* TG68K_FPU_ALU.vhd:1100:73  */
  assign n1993 = n1970 ? n1989 : mant_a;
  /* TG68K_FPU_ALU.vhd:1100:73  */
  assign n1995 = n1970 ? n1991 : 8'b00000000;
  /* TG68K_FPU_ALU.vhd:1092:65  */
  assign n1997 = is_zero_a ? 15'b000000000000000 : n1992;
  /* TG68K_FPU_ALU.vhd:1092:65  */
  assign n1999 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n1993;
  /* TG68K_FPU_ALU.vhd:1092:65  */
  assign n2000 = is_zero_a ? fmod_quotient : n1995;
  /* TG68K_FPU_ALU.vhd:1092:65  */
  assign n2002 = is_zero_a ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2004 = n1969 ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2006 = n1969 ? 15'b111111111111111 : n1997;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2008 = n1969 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n1999;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2009 = n1969 ? fmod_quotient : n2000;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2010 = n1969 ? flags_inexact : n2002;
  /* TG68K_FPU_ALU.vhd:1086:65  */
  assign n2012 = n1969 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:1084:57  */
  assign n2014 = operation_code == 7'b0100001;
  /* TG68K_FPU_ALU.vhd:1136:83  */
  assign n2015 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:1136:101  */
  assign n2016 = n2015 | is_inf_a;
  /* TG68K_FPU_ALU.vhd:1136:119  */
  assign n2017 = n2016 | is_zero_b;
  /* TG68K_FPU_ALU.vhd:1150:92  */
  assign n2018 = $unsigned(exp_a) >= $unsigned(exp_b);
  /* TG68K_FPU_ALU.vhd:1153:100  */
  assign n2019 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1153:118  */
  assign n2021 = $unsigned(n2019) < $unsigned(15'b000000000000111);
  /* TG68K_FPU_ALU.vhd:1156:124  */
  assign n2022 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1155:129  */
  assign n2024 = n2022[6:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1155:110  */
  assign n2026 = {1'b0, n2024};
  /* TG68K_FPU_ALU.vhd:1159:121  */
  assign n2028 = mant_b >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1161:110  */
  assign n2029 = mant_a[0]; // extract
  /* TG68K_FPU_ALU.vhd:1161:124  */
  assign n2030 = mant_b[0]; // extract
  /* TG68K_FPU_ALU.vhd:1161:114  */
  assign n2031 = n2029 ^ n2030;
  /* TG68K_FPU_ALU.vhd:1162:103  */
  assign n2032 = exp_a - exp_b;
  /* TG68K_FPU_ALU.vhd:1162:121  */
  assign n2034 = $unsigned(n2032) < $unsigned(15'b000000000100000);
  /* TG68K_FPU_ALU.vhd:1166:121  */
  assign n2036 = mant_b >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1167:110  */
  assign n2037 = mant_a[0]; // extract
  /* TG68K_FPU_ALU.vhd:1167:124  */
  assign n2038 = mant_b[0]; // extract
  /* TG68K_FPU_ALU.vhd:1167:114  */
  assign n2039 = n2037 ^ n2038;
  /* TG68K_FPU_ALU.vhd:1171:136  */
  assign n2041 = exp_b - 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:1173:111  */
  assign n2042 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:1162:81  */
  assign n2043 = n2034 ? n2039 : n2042;
  /* TG68K_FPU_ALU.vhd:1162:81  */
  assign n2044 = n2034 ? exp_b : n2041;
  /* TG68K_FPU_ALU.vhd:1162:81  */
  assign n2045 = n2034 ? n2036 : mant_b;
  /* TG68K_FPU_ALU.vhd:1153:81  */
  assign n2046 = n2021 ? n2031 : n2043;
  /* TG68K_FPU_ALU.vhd:1153:81  */
  assign n2047 = n2021 ? exp_b : n2044;
  /* TG68K_FPU_ALU.vhd:1153:81  */
  assign n2048 = n2021 ? n2028 : n2045;
  /* TG68K_FPU_ALU.vhd:1153:81  */
  assign n2050 = n2021 ? n2026 : 8'b01111111;
  /* TG68K_FPU_ALU.vhd:1150:73  */
  assign n2051 = n2018 ? n2046 : sign_a;
  /* TG68K_FPU_ALU.vhd:1150:73  */
  assign n2052 = n2018 ? n2047 : exp_a;
  /* TG68K_FPU_ALU.vhd:1150:73  */
  assign n2053 = n2018 ? n2048 : mant_a;
  /* TG68K_FPU_ALU.vhd:1150:73  */
  assign n2055 = n2018 ? n2050 : 8'b00000000;
  /* TG68K_FPU_ALU.vhd:1142:65  */
  assign n2056 = is_zero_a ? sign_a : n2051;
  /* TG68K_FPU_ALU.vhd:1142:65  */
  assign n2058 = is_zero_a ? 15'b000000000000000 : n2052;
  /* TG68K_FPU_ALU.vhd:1142:65  */
  assign n2060 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n2053;
  /* TG68K_FPU_ALU.vhd:1142:65  */
  assign n2061 = is_zero_a ? fmod_quotient : n2055;
  /* TG68K_FPU_ALU.vhd:1142:65  */
  assign n2063 = is_zero_a ? flags_inexact : 1'b1;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2065 = n2017 ? 1'b0 : n2056;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2067 = n2017 ? 15'b111111111111111 : n2058;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2069 = n2017 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n2060;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2070 = n2017 ? fmod_quotient : n2061;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2071 = n2017 ? flags_inexact : n2063;
  /* TG68K_FPU_ALU.vhd:1136:65  */
  assign n2073 = n2017 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:1134:57  */
  assign n2075 = operation_code == 7'b0100101;
  /* TG68K_FPU_ALU.vhd:1188:83  */
  assign n2076 = is_nan_a | is_nan_b;
  /* TG68K_FPU_ALU.vhd:1206:85  */
  assign n2077 = {16'b0, exp_a};  //  uext
  /* TG68K_FPU_ALU.vhd:1206:73  */
  assign n2078 = {1'b0, n2077};  //  uext
  /* TG68K_FPU_ALU.vhd:1207:82  */
  assign n2080 = $unsigned(exp_b) >= $unsigned(15'b011111111111111);
  /* TG68K_FPU_ALU.vhd:1209:97  */
  assign n2081 = {16'b0, exp_b};  //  uext
  /* TG68K_FPU_ALU.vhd:1209:125  */
  assign n2082 = {1'b0, n2081};  //  uext
  /* TG68K_FPU_ALU.vhd:1209:125  */
  assign n2084 = n2082 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:1210:102  */
  assign n2085 = n2078 + n2084;
  /* TG68K_FPU_ALU.vhd:1213:130  */
  assign n2086 = {16'b0, exp_b};  //  uext
  /* TG68K_FPU_ALU.vhd:1213:128  */
  assign n2087 = {1'b0, n2086};  //  uext
  /* TG68K_FPU_ALU.vhd:1213:128  */
  assign n2089 = 32'b00000000000000000011111111111111 - n2087;
  /* TG68K_FPU_ALU.vhd:1214:102  */
  assign n2090 = n2078 - n2089;
  /* TG68K_FPU_ALU.vhd:1207:73  */
  assign n2091 = n2080 ? n2085 : n2090;
  /* TG68K_FPU_ALU.vhd:1218:85  */
  assign n2094 = $signed(n2091) >= $signed(32'b00000000000000000111111111111111);
  /* TG68K_FPU_ALU.vhd:1223:88  */
  assign n2096 = $signed(n2091) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_ALU.vhd:1229:124  */
  assign n2097 = n2091[30:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1229:112  */
  assign n2098 = n2097[14:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1223:73  */
  assign n2100 = n2096 ? 15'b000000000000000 : n2098;
  /* TG68K_FPU_ALU.vhd:1223:73  */
  assign n2102 = n2096 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : mant_a;
  /* TG68K_FPU_ALU.vhd:1223:73  */
  assign n2104 = n2096 ? 1'b1 : flags_underflow;
  /* TG68K_FPU_ALU.vhd:1218:73  */
  assign n2106 = n2094 ? 15'b111111111111111 : n2100;
  /* TG68K_FPU_ALU.vhd:1218:73  */
  assign n2108 = n2094 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n2102;
  /* TG68K_FPU_ALU.vhd:1218:73  */
  assign n2110 = n2094 ? 1'b1 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:1218:73  */
  assign n2111 = n2094 ? flags_underflow : n2104;
  /* TG68K_FPU_ALU.vhd:1199:65  */
  assign n2113 = is_inf_a ? 15'b111111111111111 : n2106;
  /* TG68K_FPU_ALU.vhd:1199:65  */
  assign n2115 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n2108;
  /* TG68K_FPU_ALU.vhd:1199:65  */
  assign n2116 = is_inf_a ? flags_overflow : n2110;
  /* TG68K_FPU_ALU.vhd:1199:65  */
  assign n2117 = is_inf_a ? flags_underflow : n2111;
  /* TG68K_FPU_ALU.vhd:1194:65  */
  assign n2121 = is_zero_a ? 15'b000000000000000 : n2113;
  /* TG68K_FPU_ALU.vhd:1194:65  */
  assign n2123 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n2115;
  /* TG68K_FPU_ALU.vhd:1194:65  */
  assign n2124 = is_zero_a ? flags_overflow : n2116;
  /* TG68K_FPU_ALU.vhd:1194:65  */
  assign n2125 = is_zero_a ? flags_underflow : n2117;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2129 = n2076 ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2131 = n2076 ? 15'b111111111111111 : n2121;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2133 = n2076 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n2123;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2134 = n2076 ? flags_overflow : n2124;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2135 = n2076 ? flags_underflow : n2125;
  /* TG68K_FPU_ALU.vhd:1188:65  */
  assign n2137 = n2076 ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:1186:57  */
  assign n2141 = operation_code == 7'b0100110;
  /* TG68K_FPU_ALU.vhd:1254:85  */
  assign n2142 = {16'b0, exp_a};  //  uext
  /* TG68K_FPU_ALU.vhd:1254:113  */
  assign n2143 = {1'b0, n2142};  //  uext
  /* TG68K_FPU_ALU.vhd:1254:113  */
  assign n2145 = n2143 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:1256:85  */
  assign n2147 = $signed(n2145) >= $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_ALU.vhd:1257:133  */
  assign n2149 = n2145 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:1257:124  */
  assign n2150 = n2149[30:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1257:112  */
  assign n2151 = n2150[14:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1260:124  */
  assign n2152 = -n2145;
  /* TG68K_FPU_ALU.vhd:1260:134  */
  assign n2154 = n2152 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_ALU.vhd:1260:124  */
  assign n2155 = n2154[30:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1260:112  */
  assign n2156 = n2155[14:0];  // trunc
  /* TG68K_FPU_ALU.vhd:1256:73  */
  assign n2159 = n2147 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:1256:73  */
  assign n2161 = n2147 ? n2151 : n2156;
  /* TG68K_FPU_ALU.vhd:1247:65  */
  assign n2163 = is_zero_a ? 1'b1 : n2159;
  /* TG68K_FPU_ALU.vhd:1247:65  */
  assign n2165 = is_zero_a ? 15'b111111111111111 : n2161;
  /* TG68K_FPU_ALU.vhd:1247:65  */
  assign n2168 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1242:65  */
  assign n2171 = is_inf_a ? 1'b0 : n2163;
  /* TG68K_FPU_ALU.vhd:1242:65  */
  assign n2173 = is_inf_a ? 15'b111111111111111 : n2165;
  /* TG68K_FPU_ALU.vhd:1242:65  */
  assign n2175 = is_inf_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n2168;
  /* TG68K_FPU_ALU.vhd:1237:65  */
  assign n2178 = is_nan_a ? 1'b0 : n2171;
  /* TG68K_FPU_ALU.vhd:1237:65  */
  assign n2180 = is_nan_a ? 15'b111111111111111 : n2173;
  /* TG68K_FPU_ALU.vhd:1237:65  */
  assign n2182 = is_nan_a ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n2175;
  /* TG68K_FPU_ALU.vhd:1235:57  */
  assign n2185 = operation_code == 7'b0011110;
  /* TG68K_FPU_ALU.vhd:1279:65  */
  assign n2188 = is_zero_a ? 15'b000000000000000 : 15'b011111111111111;
  /* TG68K_FPU_ALU.vhd:1279:65  */
  assign n2190 = is_zero_a ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : mant_a;
  /* TG68K_FPU_ALU.vhd:1273:65  */
  assign n2192 = is_inf_a ? 1'b0 : sign_a;
  /* TG68K_FPU_ALU.vhd:1273:65  */
  assign n2194 = is_inf_a ? 15'b111111111111111 : n2188;
  /* TG68K_FPU_ALU.vhd:1273:65  */
  assign n2196 = is_inf_a ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n2190;
  /* TG68K_FPU_ALU.vhd:1273:65  */
  assign n2198 = is_inf_a ? 1'b1 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:1268:65  */
  assign n2200 = is_nan_a ? 1'b0 : n2192;
  /* TG68K_FPU_ALU.vhd:1268:65  */
  assign n2202 = is_nan_a ? 15'b111111111111111 : n2194;
  /* TG68K_FPU_ALU.vhd:1268:65  */
  assign n2204 = is_nan_a ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n2196;
  /* TG68K_FPU_ALU.vhd:1268:65  */
  assign n2205 = is_nan_a ? flags_invalid : n2198;
  /* TG68K_FPU_ALU.vhd:1266:57  */
  assign n2207 = operation_code == 7'b0011111;
  assign n2208 = {n2207, n2185, n2141, n2075, n2014, n1966, n1921, n1818, n1332, n838, n789, n675, n616, n448, n258, n202, n199, n197};
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2212 = n2200;
      18'b010000000000000000: n2212 = n2178;
      18'b001000000000000000: n2212 = n2129;
      18'b000100000000000000: n2212 = n2065;
      18'b000010000000000000: n2212 = n2004;
      18'b000001000000000000: n2212 = n1957;
      18'b000000100000000000: n2212 = n1910;
      18'b000000010000000000: n2212 = n1808;
      18'b000000001000000000: n2212 = n1322;
      18'b000000000100000000: n2212 = n830;
      18'b000000000010000000: n2212 = n777;
      18'b000000000001000000: n2212 = n665;
      18'b000000000000100000: n2212 = n603;
      18'b000000000000010000: n2212 = n434;
      18'b000000000000001000: n2212 = 1'b0;
      18'b000000000000000100: n2212 = n200;
      18'b000000000000000010: n2212 = 1'b0;
      18'b000000000000000001: n2212 = sign_b;
      default: n2212 = 1'b0;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2215 = n2202;
      18'b010000000000000000: n2215 = n2180;
      18'b001000000000000000: n2215 = n2131;
      18'b000100000000000000: n2215 = n2067;
      18'b000010000000000000: n2215 = n2006;
      18'b000001000000000000: n2215 = n1959;
      18'b000000100000000000: n2215 = n1912;
      18'b000000010000000000: n2215 = n1810;
      18'b000000001000000000: n2215 = n1324;
      18'b000000000100000000: n2215 = 15'b000000000000000;
      18'b000000000010000000: n2215 = n779;
      18'b000000000001000000: n2215 = n667;
      18'b000000000000100000: n2215 = n605;
      18'b000000000000010000: n2215 = n436;
      18'b000000000000001000: n2215 = n250;
      18'b000000000000000100: n2215 = exp_a;
      18'b000000000000000010: n2215 = exp_a;
      18'b000000000000000001: n2215 = exp_b;
      default: n2215 = 15'b000000000000000;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2218 = n2204;
      18'b010000000000000000: n2218 = n2182;
      18'b001000000000000000: n2218 = n2133;
      18'b000100000000000000: n2218 = n2069;
      18'b000010000000000000: n2218 = n2008;
      18'b000001000000000000: n2218 = n1961;
      18'b000000100000000000: n2218 = n1914;
      18'b000000010000000000: n2218 = n1812;
      18'b000000001000000000: n2218 = n1326;
      18'b000000000100000000: n2218 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
      18'b000000000010000000: n2218 = n781;
      18'b000000000001000000: n2218 = n669;
      18'b000000000000100000: n2218 = n607;
      18'b000000000000010000: n2218 = n438;
      18'b000000000000001000: n2218 = n252;
      18'b000000000000000100: n2218 = mant_a;
      18'b000000000000000010: n2218 = mant_a;
      18'b000000000000000001: n2218 = mant_b;
      default: n2218 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2219 = mant_sum;
      18'b010000000000000000: n2219 = mant_sum;
      18'b001000000000000000: n2219 = mant_sum;
      18'b000100000000000000: n2219 = mant_sum;
      18'b000010000000000000: n2219 = mant_sum;
      18'b000001000000000000: n2219 = mant_sum;
      18'b000000100000000000: n2219 = mant_sum;
      18'b000000010000000000: n2219 = mant_sum;
      18'b000000001000000000: n2219 = mant_sum;
      18'b000000000100000000: n2219 = mant_sum;
      18'b000000000010000000: n2219 = mant_sum;
      18'b000000000001000000: n2219 = mant_sum;
      18'b000000000000100000: n2219 = n608;
      18'b000000000000010000: n2219 = n439;
      18'b000000000000001000: n2219 = mant_sum;
      18'b000000000000000100: n2219 = mant_sum;
      18'b000000000000000010: n2219 = mant_sum;
      18'b000000000000000001: n2219 = mant_sum;
      default: n2219 = mant_sum;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2222 = mant_a_aligned;
      18'b010000000000000000: n2222 = mant_a_aligned;
      18'b001000000000000000: n2222 = mant_a_aligned;
      18'b000100000000000000: n2222 = mant_a_aligned;
      18'b000010000000000000: n2222 = mant_a_aligned;
      18'b000001000000000000: n2222 = mant_a_aligned;
      18'b000000100000000000: n2222 = mant_a_aligned;
      18'b000000010000000000: n2222 = mant_a_aligned;
      18'b000000001000000000: n2222 = mant_a_aligned;
      18'b000000000100000000: n2222 = mant_a_aligned;
      18'b000000000010000000: n2222 = mant_a_aligned;
      18'b000000000001000000: n2222 = mant_a_aligned;
      18'b000000000000100000: n2222 = n610;
      18'b000000000000010000: n2222 = n442;
      18'b000000000000001000: n2222 = mant_a_aligned;
      18'b000000000000000100: n2222 = mant_a_aligned;
      18'b000000000000000010: n2222 = mant_a_aligned;
      18'b000000000000000001: n2222 = mant_a_aligned;
      default: n2222 = mant_a_aligned;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2223 = mant_b_aligned;
      18'b010000000000000000: n2223 = mant_b_aligned;
      18'b001000000000000000: n2223 = mant_b_aligned;
      18'b000100000000000000: n2223 = mant_b_aligned;
      18'b000010000000000000: n2223 = mant_b_aligned;
      18'b000001000000000000: n2223 = mant_b_aligned;
      18'b000000100000000000: n2223 = mant_b_aligned;
      18'b000000010000000000: n2223 = mant_b_aligned;
      18'b000000001000000000: n2223 = mant_b_aligned;
      18'b000000000100000000: n2223 = mant_b_aligned;
      18'b000000000010000000: n2223 = mant_b_aligned;
      18'b000000000001000000: n2223 = mant_b_aligned;
      18'b000000000000100000: n2223 = n611;
      18'b000000000000010000: n2223 = n443;
      18'b000000000000001000: n2223 = mant_b_aligned;
      18'b000000000000000100: n2223 = mant_b_aligned;
      18'b000000000000000010: n2223 = mant_b_aligned;
      18'b000000000000000001: n2223 = mant_b_aligned;
      default: n2223 = mant_b_aligned;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2224 = exp_larger;
      18'b010000000000000000: n2224 = exp_larger;
      18'b001000000000000000: n2224 = exp_larger;
      18'b000100000000000000: n2224 = exp_larger;
      18'b000010000000000000: n2224 = exp_larger;
      18'b000001000000000000: n2224 = exp_larger;
      18'b000000100000000000: n2224 = exp_larger;
      18'b000000010000000000: n2224 = exp_larger;
      18'b000000001000000000: n2224 = exp_larger;
      18'b000000000100000000: n2224 = exp_larger;
      18'b000000000010000000: n2224 = exp_larger;
      18'b000000000001000000: n2224 = exp_larger;
      18'b000000000000100000: n2224 = n612;
      18'b000000000000010000: n2224 = n444;
      18'b000000000000001000: n2224 = exp_larger;
      18'b000000000000000100: n2224 = exp_larger;
      18'b000000000000000010: n2224 = exp_larger;
      18'b000000000000000001: n2224 = exp_larger;
      default: n2224 = exp_larger;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2226 = mult_result;
      18'b010000000000000000: n2226 = mult_result;
      18'b001000000000000000: n2226 = mult_result;
      18'b000100000000000000: n2226 = mult_result;
      18'b000010000000000000: n2226 = mult_result;
      18'b000001000000000000: n2226 = mult_result;
      18'b000000100000000000: n2226 = mult_result;
      18'b000000010000000000: n2226 = mult_result;
      18'b000000001000000000: n2226 = mult_result;
      18'b000000000100000000: n2226 = mult_result;
      18'b000000000010000000: n2226 = mult_result;
      18'b000000000001000000: n2226 = n670;
      18'b000000000000100000: n2226 = mult_result;
      18'b000000000000010000: n2226 = mult_result;
      18'b000000000000001000: n2226 = mult_result;
      18'b000000000000000100: n2226 = mult_result;
      18'b000000000000000010: n2226 = mult_result;
      18'b000000000000000001: n2226 = mult_result;
      default: n2226 = mult_result;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2227 = fmod_quotient;
      18'b010000000000000000: n2227 = fmod_quotient;
      18'b001000000000000000: n2227 = fmod_quotient;
      18'b000100000000000000: n2227 = n2070;
      18'b000010000000000000: n2227 = n2009;
      18'b000001000000000000: n2227 = fmod_quotient;
      18'b000000100000000000: n2227 = fmod_quotient;
      18'b000000010000000000: n2227 = fmod_quotient;
      18'b000000001000000000: n2227 = fmod_quotient;
      18'b000000000100000000: n2227 = fmod_quotient;
      18'b000000000010000000: n2227 = fmod_quotient;
      18'b000000000001000000: n2227 = fmod_quotient;
      18'b000000000000100000: n2227 = fmod_quotient;
      18'b000000000000010000: n2227 = fmod_quotient;
      18'b000000000000001000: n2227 = fmod_quotient;
      18'b000000000000000100: n2227 = fmod_quotient;
      18'b000000000000000010: n2227 = fmod_quotient;
      18'b000000000000000001: n2227 = fmod_quotient;
      default: n2227 = fmod_quotient;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2228 = flags_overflow;
      18'b010000000000000000: n2228 = flags_overflow;
      18'b001000000000000000: n2228 = n2134;
      18'b000100000000000000: n2228 = flags_overflow;
      18'b000010000000000000: n2228 = flags_overflow;
      18'b000001000000000000: n2228 = flags_overflow;
      18'b000000100000000000: n2228 = n1915;
      18'b000000010000000000: n2228 = flags_overflow;
      18'b000000001000000000: n2228 = flags_overflow;
      18'b000000000100000000: n2228 = flags_overflow;
      18'b000000000010000000: n2228 = n783;
      18'b000000000001000000: n2228 = flags_overflow;
      18'b000000000000100000: n2228 = flags_overflow;
      18'b000000000000010000: n2228 = flags_overflow;
      18'b000000000000001000: n2228 = flags_overflow;
      18'b000000000000000100: n2228 = flags_overflow;
      18'b000000000000000010: n2228 = flags_overflow;
      18'b000000000000000001: n2228 = flags_overflow;
      default: n2228 = flags_overflow;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2229 = flags_underflow;
      18'b010000000000000000: n2229 = flags_underflow;
      18'b001000000000000000: n2229 = n2135;
      18'b000100000000000000: n2229 = flags_underflow;
      18'b000010000000000000: n2229 = flags_underflow;
      18'b000001000000000000: n2229 = flags_underflow;
      18'b000000100000000000: n2229 = flags_underflow;
      18'b000000010000000000: n2229 = flags_underflow;
      18'b000000001000000000: n2229 = flags_underflow;
      18'b000000000100000000: n2229 = flags_underflow;
      18'b000000000010000000: n2229 = flags_underflow;
      18'b000000000001000000: n2229 = flags_underflow;
      18'b000000000000100000: n2229 = flags_underflow;
      18'b000000000000010000: n2229 = flags_underflow;
      18'b000000000000001000: n2229 = flags_underflow;
      18'b000000000000000100: n2229 = flags_underflow;
      18'b000000000000000010: n2229 = flags_underflow;
      18'b000000000000000001: n2229 = flags_underflow;
      default: n2229 = flags_underflow;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2230 = flags_inexact;
      18'b010000000000000000: n2230 = flags_inexact;
      18'b001000000000000000: n2230 = flags_inexact;
      18'b000100000000000000: n2230 = n2071;
      18'b000010000000000000: n2230 = n2010;
      18'b000001000000000000: n2230 = n1962;
      18'b000000100000000000: n2230 = n1916;
      18'b000000010000000000: n2230 = n1813;
      18'b000000001000000000: n2230 = n1327;
      18'b000000000100000000: n2230 = flags_inexact;
      18'b000000000010000000: n2230 = n784;
      18'b000000000001000000: n2230 = n671;
      18'b000000000000100000: n2230 = flags_inexact;
      18'b000000000000010000: n2230 = flags_inexact;
      18'b000000000000001000: n2230 = n253;
      18'b000000000000000100: n2230 = flags_inexact;
      18'b000000000000000010: n2230 = flags_inexact;
      18'b000000000000000001: n2230 = flags_inexact;
      default: n2230 = flags_inexact;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2232 = n2205;
      18'b010000000000000000: n2232 = flags_invalid;
      18'b001000000000000000: n2232 = n2137;
      18'b000100000000000000: n2232 = n2073;
      18'b000010000000000000: n2232 = n2012;
      18'b000001000000000000: n2232 = n1964;
      18'b000000100000000000: n2232 = n1918;
      18'b000000010000000000: n2232 = n1815;
      18'b000000001000000000: n2232 = n1329;
      18'b000000000100000000: n2232 = n833;
      18'b000000000010000000: n2232 = n786;
      18'b000000000001000000: n2232 = n673;
      18'b000000000000100000: n2232 = n614;
      18'b000000000000010000: n2232 = n446;
      18'b000000000000001000: n2232 = n255;
      18'b000000000000000100: n2232 = flags_invalid;
      18'b000000000000000010: n2232 = flags_invalid;
      18'b000000000000000001: n2232 = flags_invalid;
      default: n2232 = 1'b1;
    endcase
  /* TG68K_FPU_ALU.vhd:339:49  */
  always @*
    case (n2208)
      18'b100000000000000000: n2233 = flags_div_by_zero;
      18'b010000000000000000: n2233 = flags_div_by_zero;
      18'b001000000000000000: n2233 = flags_div_by_zero;
      18'b000100000000000000: n2233 = flags_div_by_zero;
      18'b000010000000000000: n2233 = flags_div_by_zero;
      18'b000001000000000000: n2233 = flags_div_by_zero;
      18'b000000100000000000: n2233 = n1919;
      18'b000000010000000000: n2233 = flags_div_by_zero;
      18'b000000001000000000: n2233 = flags_div_by_zero;
      18'b000000000100000000: n2233 = flags_div_by_zero;
      18'b000000000010000000: n2233 = n787;
      18'b000000000001000000: n2233 = flags_div_by_zero;
      18'b000000000000100000: n2233 = flags_div_by_zero;
      18'b000000000000010000: n2233 = flags_div_by_zero;
      18'b000000000000001000: n2233 = flags_div_by_zero;
      18'b000000000000000100: n2233 = flags_div_by_zero;
      18'b000000000000000010: n2233 = flags_div_by_zero;
      18'b000000000000000001: n2233 = flags_div_by_zero;
      default: n2233 = flags_div_by_zero;
    endcase
  /* TG68K_FPU_ALU.vhd:338:41  */
  assign n2237 = alu_state == 3'b011;
  /* TG68K_FPU_ALU.vhd:1304:63  */
  assign n2239 = exp_result == 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:1304:89  */
  assign n2241 = mant_result == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1304:74  */
  assign n2242 = n2239 | n2241;
  /* TG68K_FPU_ALU.vhd:1308:66  */
  assign n2244 = $unsigned(exp_result) >= $unsigned(15'b111111111111111);
  /* TG68K_FPU_ALU.vhd:1313:65  */
  assign n2245 = exp_result[14]; // extract
  /* TG68K_FPU_ALU.vhd:1321:71  */
  assign n2246 = mant_result[63]; // extract
  /* TG68K_FPU_ALU.vhd:1321:76  */
  assign n2247 = ~n2246;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2249 = mant_result[63]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2255 = n2249 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2257 = mant_result[62]; // extract
  /* TG68K_FPU_ALU.vhd:1327:81  */
  assign n2260 = n2255 ? 6'b000001 : 6'b000000;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2264 = n2273 ? 1'b0 : n2255;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2267 = n2257 ? n2260 : 6'b000000;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2268 = n2255 & n2257;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2271 = n2255 ? n2267 : 6'b000000;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2273 = n2268 & n2255;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2274 = mant_result[61]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2276 = n2285 ? 6'b000010 : n2271;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2280 = n2286 ? 1'b0 : n2264;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2282 = n2264 & n2274;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2283 = n2264 & n2274;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2285 = n2282 & n2264;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2286 = n2283 & n2264;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2287 = mant_result[60]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2289 = n2298 ? 6'b000011 : n2276;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2293 = n2299 ? 1'b0 : n2280;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2295 = n2280 & n2287;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2296 = n2280 & n2287;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2298 = n2295 & n2280;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2299 = n2296 & n2280;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2300 = mant_result[59]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2302 = n2311 ? 6'b000100 : n2289;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2306 = n2312 ? 1'b0 : n2293;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2308 = n2293 & n2300;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2309 = n2293 & n2300;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2311 = n2308 & n2293;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2312 = n2309 & n2293;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2313 = mant_result[58]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2315 = n2324 ? 6'b000101 : n2302;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2319 = n2325 ? 1'b0 : n2306;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2321 = n2306 & n2313;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2322 = n2306 & n2313;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2324 = n2321 & n2306;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2325 = n2322 & n2306;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2326 = mant_result[57]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2328 = n2337 ? 6'b000110 : n2315;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2332 = n2338 ? 1'b0 : n2319;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2334 = n2319 & n2326;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2335 = n2319 & n2326;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2337 = n2334 & n2319;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2338 = n2335 & n2319;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2339 = mant_result[56]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2341 = n2350 ? 6'b000111 : n2328;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2345 = n2351 ? 1'b0 : n2332;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2347 = n2332 & n2339;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2348 = n2332 & n2339;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2350 = n2347 & n2332;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2351 = n2348 & n2332;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2352 = mant_result[55]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2354 = n2363 ? 6'b001000 : n2341;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2358 = n2364 ? 1'b0 : n2345;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2360 = n2345 & n2352;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2361 = n2345 & n2352;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2363 = n2360 & n2345;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2364 = n2361 & n2345;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2365 = mant_result[54]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2367 = n2376 ? 6'b001001 : n2354;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2371 = n2377 ? 1'b0 : n2358;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2373 = n2358 & n2365;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2374 = n2358 & n2365;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2376 = n2373 & n2358;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2377 = n2374 & n2358;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2378 = mant_result[53]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2380 = n2389 ? 6'b001010 : n2367;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2384 = n2390 ? 1'b0 : n2371;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2386 = n2371 & n2378;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2387 = n2371 & n2378;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2389 = n2386 & n2371;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2390 = n2387 & n2371;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2391 = mant_result[52]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2393 = n2402 ? 6'b001011 : n2380;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2397 = n2403 ? 1'b0 : n2384;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2399 = n2384 & n2391;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2400 = n2384 & n2391;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2402 = n2399 & n2384;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2403 = n2400 & n2384;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2404 = mant_result[51]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2406 = n2415 ? 6'b001100 : n2393;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2410 = n2416 ? 1'b0 : n2397;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2412 = n2397 & n2404;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2413 = n2397 & n2404;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2415 = n2412 & n2397;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2416 = n2413 & n2397;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2417 = mant_result[50]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2419 = n2428 ? 6'b001101 : n2406;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2423 = n2429 ? 1'b0 : n2410;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2425 = n2410 & n2417;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2426 = n2410 & n2417;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2428 = n2425 & n2410;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2429 = n2426 & n2410;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2430 = mant_result[49]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2432 = n2441 ? 6'b001110 : n2419;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2436 = n2442 ? 1'b0 : n2423;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2438 = n2423 & n2430;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2439 = n2423 & n2430;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2441 = n2438 & n2423;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2442 = n2439 & n2423;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2443 = mant_result[48]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2445 = n2454 ? 6'b001111 : n2432;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2449 = n2455 ? 1'b0 : n2436;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2451 = n2436 & n2443;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2452 = n2436 & n2443;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2454 = n2451 & n2436;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2455 = n2452 & n2436;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2456 = mant_result[47]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2458 = n2467 ? 6'b010000 : n2445;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2462 = n2468 ? 1'b0 : n2449;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2464 = n2449 & n2456;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2465 = n2449 & n2456;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2467 = n2464 & n2449;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2468 = n2465 & n2449;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2469 = mant_result[46]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2471 = n2480 ? 6'b010001 : n2458;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2475 = n2481 ? 1'b0 : n2462;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2477 = n2462 & n2469;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2478 = n2462 & n2469;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2480 = n2477 & n2462;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2481 = n2478 & n2462;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2482 = mant_result[45]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2484 = n2493 ? 6'b010010 : n2471;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2488 = n2494 ? 1'b0 : n2475;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2490 = n2475 & n2482;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2491 = n2475 & n2482;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2493 = n2490 & n2475;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2494 = n2491 & n2475;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2495 = mant_result[44]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2497 = n2506 ? 6'b010011 : n2484;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2501 = n2507 ? 1'b0 : n2488;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2503 = n2488 & n2495;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2504 = n2488 & n2495;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2506 = n2503 & n2488;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2507 = n2504 & n2488;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2508 = mant_result[43]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2510 = n2519 ? 6'b010100 : n2497;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2514 = n2520 ? 1'b0 : n2501;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2516 = n2501 & n2508;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2517 = n2501 & n2508;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2519 = n2516 & n2501;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2520 = n2517 & n2501;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2521 = mant_result[42]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2523 = n2532 ? 6'b010101 : n2510;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2527 = n2533 ? 1'b0 : n2514;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2529 = n2514 & n2521;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2530 = n2514 & n2521;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2532 = n2529 & n2514;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2533 = n2530 & n2514;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2534 = mant_result[41]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2536 = n2545 ? 6'b010110 : n2523;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2540 = n2546 ? 1'b0 : n2527;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2542 = n2527 & n2534;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2543 = n2527 & n2534;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2545 = n2542 & n2527;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2546 = n2543 & n2527;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2547 = mant_result[40]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2549 = n2558 ? 6'b010111 : n2536;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2553 = n2559 ? 1'b0 : n2540;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2555 = n2540 & n2547;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2556 = n2540 & n2547;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2558 = n2555 & n2540;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2559 = n2556 & n2540;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2560 = mant_result[39]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2562 = n2571 ? 6'b011000 : n2549;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2566 = n2572 ? 1'b0 : n2553;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2568 = n2553 & n2560;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2569 = n2553 & n2560;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2571 = n2568 & n2553;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2572 = n2569 & n2553;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2573 = mant_result[38]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2575 = n2584 ? 6'b011001 : n2562;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2579 = n2585 ? 1'b0 : n2566;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2581 = n2566 & n2573;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2582 = n2566 & n2573;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2584 = n2581 & n2566;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2585 = n2582 & n2566;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2586 = mant_result[37]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2588 = n2597 ? 6'b011010 : n2575;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2592 = n2598 ? 1'b0 : n2579;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2594 = n2579 & n2586;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2595 = n2579 & n2586;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2597 = n2594 & n2579;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2598 = n2595 & n2579;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2599 = mant_result[36]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2601 = n2610 ? 6'b011011 : n2588;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2605 = n2611 ? 1'b0 : n2592;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2607 = n2592 & n2599;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2608 = n2592 & n2599;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2610 = n2607 & n2592;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2611 = n2608 & n2592;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2612 = mant_result[35]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2614 = n2623 ? 6'b011100 : n2601;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2618 = n2624 ? 1'b0 : n2605;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2620 = n2605 & n2612;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2621 = n2605 & n2612;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2623 = n2620 & n2605;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2624 = n2621 & n2605;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2625 = mant_result[34]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2627 = n2636 ? 6'b011101 : n2614;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2631 = n2637 ? 1'b0 : n2618;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2633 = n2618 & n2625;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2634 = n2618 & n2625;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2636 = n2633 & n2618;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2637 = n2634 & n2618;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2638 = mant_result[33]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2640 = n2649 ? 6'b011110 : n2627;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2644 = n2650 ? 1'b0 : n2631;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2646 = n2631 & n2638;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2647 = n2631 & n2638;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2649 = n2646 & n2631;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2650 = n2647 & n2631;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2651 = mant_result[32]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2653 = n2662 ? 6'b011111 : n2640;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2657 = n2663 ? 1'b0 : n2644;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2659 = n2644 & n2651;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2660 = n2644 & n2651;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2662 = n2659 & n2644;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2663 = n2660 & n2644;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2664 = mant_result[31]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2666 = n2675 ? 6'b100000 : n2653;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2670 = n2676 ? 1'b0 : n2657;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2672 = n2657 & n2664;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2673 = n2657 & n2664;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2675 = n2672 & n2657;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2676 = n2673 & n2657;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2677 = mant_result[30]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2679 = n2688 ? 6'b100001 : n2666;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2683 = n2689 ? 1'b0 : n2670;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2685 = n2670 & n2677;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2686 = n2670 & n2677;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2688 = n2685 & n2670;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2689 = n2686 & n2670;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2690 = mant_result[29]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2692 = n2701 ? 6'b100010 : n2679;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2696 = n2702 ? 1'b0 : n2683;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2698 = n2683 & n2690;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2699 = n2683 & n2690;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2701 = n2698 & n2683;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2702 = n2699 & n2683;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2703 = mant_result[28]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2705 = n2714 ? 6'b100011 : n2692;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2709 = n2715 ? 1'b0 : n2696;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2711 = n2696 & n2703;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2712 = n2696 & n2703;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2714 = n2711 & n2696;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2715 = n2712 & n2696;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2716 = mant_result[27]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2718 = n2727 ? 6'b100100 : n2705;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2722 = n2728 ? 1'b0 : n2709;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2724 = n2709 & n2716;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2725 = n2709 & n2716;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2727 = n2724 & n2709;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2728 = n2725 & n2709;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2729 = mant_result[26]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2731 = n2740 ? 6'b100101 : n2718;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2735 = n2741 ? 1'b0 : n2722;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2737 = n2722 & n2729;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2738 = n2722 & n2729;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2740 = n2737 & n2722;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2741 = n2738 & n2722;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2742 = mant_result[25]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2744 = n2753 ? 6'b100110 : n2731;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2748 = n2754 ? 1'b0 : n2735;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2750 = n2735 & n2742;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2751 = n2735 & n2742;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2753 = n2750 & n2735;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2754 = n2751 & n2735;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2755 = mant_result[24]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2757 = n2766 ? 6'b100111 : n2744;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2761 = n2767 ? 1'b0 : n2748;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2763 = n2748 & n2755;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2764 = n2748 & n2755;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2766 = n2763 & n2748;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2767 = n2764 & n2748;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2768 = mant_result[23]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2770 = n2779 ? 6'b101000 : n2757;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2774 = n2780 ? 1'b0 : n2761;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2776 = n2761 & n2768;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2777 = n2761 & n2768;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2779 = n2776 & n2761;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2780 = n2777 & n2761;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2781 = mant_result[22]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2783 = n2792 ? 6'b101001 : n2770;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2787 = n2793 ? 1'b0 : n2774;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2789 = n2774 & n2781;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2790 = n2774 & n2781;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2792 = n2789 & n2774;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2793 = n2790 & n2774;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2794 = mant_result[21]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2796 = n2805 ? 6'b101010 : n2783;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2800 = n2806 ? 1'b0 : n2787;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2802 = n2787 & n2794;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2803 = n2787 & n2794;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2805 = n2802 & n2787;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2806 = n2803 & n2787;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2807 = mant_result[20]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2809 = n2818 ? 6'b101011 : n2796;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2813 = n2819 ? 1'b0 : n2800;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2815 = n2800 & n2807;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2816 = n2800 & n2807;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2818 = n2815 & n2800;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2819 = n2816 & n2800;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2820 = mant_result[19]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2822 = n2831 ? 6'b101100 : n2809;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2826 = n2832 ? 1'b0 : n2813;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2828 = n2813 & n2820;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2829 = n2813 & n2820;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2831 = n2828 & n2813;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2832 = n2829 & n2813;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2833 = mant_result[18]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2835 = n2844 ? 6'b101101 : n2822;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2839 = n2845 ? 1'b0 : n2826;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2841 = n2826 & n2833;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2842 = n2826 & n2833;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2844 = n2841 & n2826;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2845 = n2842 & n2826;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2846 = mant_result[17]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2848 = n2857 ? 6'b101110 : n2835;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2852 = n2858 ? 1'b0 : n2839;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2854 = n2839 & n2846;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2855 = n2839 & n2846;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2857 = n2854 & n2839;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2858 = n2855 & n2839;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2859 = mant_result[16]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2861 = n2870 ? 6'b101111 : n2848;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2865 = n2871 ? 1'b0 : n2852;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2867 = n2852 & n2859;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2868 = n2852 & n2859;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2870 = n2867 & n2852;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2871 = n2868 & n2852;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2872 = mant_result[15]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2874 = n2883 ? 6'b110000 : n2861;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2878 = n2884 ? 1'b0 : n2865;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2880 = n2865 & n2872;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2881 = n2865 & n2872;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2883 = n2880 & n2865;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2884 = n2881 & n2865;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2885 = mant_result[14]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2887 = n2896 ? 6'b110001 : n2874;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2891 = n2897 ? 1'b0 : n2878;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2893 = n2878 & n2885;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2894 = n2878 & n2885;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2896 = n2893 & n2878;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2897 = n2894 & n2878;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2898 = mant_result[13]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2900 = n2909 ? 6'b110010 : n2887;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2904 = n2910 ? 1'b0 : n2891;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2906 = n2891 & n2898;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2907 = n2891 & n2898;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2909 = n2906 & n2891;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2910 = n2907 & n2891;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2911 = mant_result[12]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2913 = n2922 ? 6'b110011 : n2900;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2917 = n2923 ? 1'b0 : n2904;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2919 = n2904 & n2911;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2920 = n2904 & n2911;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2922 = n2919 & n2904;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2923 = n2920 & n2904;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2924 = mant_result[11]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2926 = n2935 ? 6'b110100 : n2913;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2930 = n2936 ? 1'b0 : n2917;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2932 = n2917 & n2924;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2933 = n2917 & n2924;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2935 = n2932 & n2917;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2936 = n2933 & n2917;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2937 = mant_result[10]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2939 = n2948 ? 6'b110101 : n2926;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2943 = n2949 ? 1'b0 : n2930;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2945 = n2930 & n2937;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2946 = n2930 & n2937;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2948 = n2945 & n2930;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2949 = n2946 & n2930;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2950 = mant_result[9]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2952 = n2961 ? 6'b110110 : n2939;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2956 = n2962 ? 1'b0 : n2943;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2958 = n2943 & n2950;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2959 = n2943 & n2950;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2961 = n2958 & n2943;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2962 = n2959 & n2943;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2963 = mant_result[8]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2965 = n2974 ? 6'b110111 : n2952;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2969 = n2975 ? 1'b0 : n2956;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2971 = n2956 & n2963;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2972 = n2956 & n2963;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2974 = n2971 & n2956;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2975 = n2972 & n2956;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2976 = mant_result[7]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2978 = n2987 ? 6'b111000 : n2965;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2982 = n2988 ? 1'b0 : n2969;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2984 = n2969 & n2976;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2985 = n2969 & n2976;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2987 = n2984 & n2969;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2988 = n2985 & n2969;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n2989 = mant_result[6]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2991 = n3000 ? 6'b111001 : n2978;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2995 = n3001 ? 1'b0 : n2982;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2997 = n2982 & n2989;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n2998 = n2982 & n2989;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3000 = n2997 & n2982;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3001 = n2998 & n2982;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3002 = mant_result[5]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3004 = n3013 ? 6'b111010 : n2991;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3008 = n3014 ? 1'b0 : n2995;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3010 = n2995 & n3002;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3011 = n2995 & n3002;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3013 = n3010 & n2995;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3014 = n3011 & n2995;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3015 = mant_result[4]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3017 = n3026 ? 6'b111011 : n3004;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3021 = n3027 ? 1'b0 : n3008;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3023 = n3008 & n3015;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3024 = n3008 & n3015;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3026 = n3023 & n3008;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3027 = n3024 & n3008;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3028 = mant_result[3]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3030 = n3039 ? 6'b111100 : n3017;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3034 = n3040 ? 1'b0 : n3021;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3036 = n3021 & n3028;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3037 = n3021 & n3028;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3039 = n3036 & n3021;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3040 = n3037 & n3021;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3041 = mant_result[2]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3043 = n3052 ? 6'b111101 : n3030;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3047 = n3053 ? 1'b0 : n3034;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3049 = n3034 & n3041;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3050 = n3034 & n3041;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3052 = n3049 & n3034;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3053 = n3050 & n3034;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3054 = mant_result[1]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3056 = n3065 ? 6'b111110 : n3043;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3060 = n3066 ? 1'b0 : n3047;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3062 = n3047 & n3054;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3063 = n3047 & n3054;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3065 = n3062 & n3047;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3066 = n3063 & n3047;
  /* TG68K_FPU_ALU.vhd:1326:87  */
  assign n3067 = mant_result[0]; // extract
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3069 = n3078 ? 6'b111111 : n3056;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3075 = n3060 & n3067;
  /* TG68K_FPU_ALU.vhd:1326:73  */
  assign n3078 = n3075 & n3060;
  /* TG68K_FPU_ALU.vhd:1333:79  */
  assign n3080 = {26'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1333:79  */
  assign n3082 = n3080 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1333:99  */
  assign n3084 = mant_result == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1333:83  */
  assign n3085 = n3084 & n3082;
  /* TG68K_FPU_ALU.vhd:1342:99  */
  assign n3086 = sign_a == sign_b;
  /* TG68K_FPU_ALU.vhd:1344:109  */
  assign n3088 = rounding_mode == 2'b11;
  /* TG68K_FPU_ALU.vhd:1344:89  */
  assign n3091 = n3088 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1342:89  */
  assign n3092 = n3086 ? sign_a : n3091;
  /* TG68K_FPU_ALU.vhd:1340:81  */
  assign n3094 = operation_code == 7'b0100010;
  /* TG68K_FPU_ALU.vhd:1351:99  */
  assign n3095 = ~sign_a;
  /* TG68K_FPU_ALU.vhd:1351:116  */
  assign n3096 = ~sign_b;
  /* TG68K_FPU_ALU.vhd:1351:105  */
  assign n3097 = n3096 & n3095;
  /* TG68K_FPU_ALU.vhd:1353:108  */
  assign n3098 = sign_b & sign_a;
  /* TG68K_FPU_ALU.vhd:1355:102  */
  assign n3099 = ~sign_a;
  /* TG68K_FPU_ALU.vhd:1355:108  */
  assign n3100 = sign_b & n3099;
  /* TG68K_FPU_ALU.vhd:1355:89  */
  assign n3103 = n3100 ? 1'b0 : 1'b1;
  /* TG68K_FPU_ALU.vhd:1353:89  */
  assign n3105 = n3098 ? 1'b0 : n3103;
  /* TG68K_FPU_ALU.vhd:1351:89  */
  assign n3107 = n3097 ? 1'b0 : n3105;
  /* TG68K_FPU_ALU.vhd:1349:81  */
  assign n3109 = operation_code == 7'b0101000;
  /* TG68K_FPU_ALU.vhd:1362:111  */
  assign n3110 = sign_a ^ sign_b;
  /* TG68K_FPU_ALU.vhd:1360:81  */
  assign n3112 = operation_code == 7'b0100011;
  /* TG68K_FPU_ALU.vhd:1360:94  */
  assign n3114 = operation_code == 7'b0100000;
  /* TG68K_FPU_ALU.vhd:1360:94  */
  assign n3115 = n3112 | n3114;
  /* TG68K_FPU_ALU.vhd:1360:104  */
  assign n3117 = operation_code == 7'b0100100;
  /* TG68K_FPU_ALU.vhd:1360:104  */
  assign n3118 = n3115 | n3117;
  assign n3119 = {n3118, n3109, n3094};
  /* TG68K_FPU_ALU.vhd:1339:73  */
  always @*
    case (n3119)
      3'b100: n3120 = n3110;
      3'b010: n3120 = n3107;
      3'b001: n3120 = n3092;
      default: n3120 = sign_result;
    endcase
  /* TG68K_FPU_ALU.vhd:1368:82  */
  assign n3121 = {26'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1368:82  */
  assign n3123 = $signed(n3121) > $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_ALU.vhd:1368:101  */
  assign n3124 = {26'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1368:101  */
  assign n3126 = $signed(n3124) <= $signed(32'b00000000000000000000000000111111);
  /* TG68K_FPU_ALU.vhd:1368:86  */
  assign n3127 = n3126 & n3123;
  /* TG68K_FPU_ALU.vhd:1369:76  */
  assign n3128 = {16'b0, exp_result};  //  uext
  /* TG68K_FPU_ALU.vhd:1369:109  */
  assign n3129 = {1'b0, n3128};  //  uext
  /* TG68K_FPU_ALU.vhd:1369:109  */
  assign n3130 = {26'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1369:109  */
  assign n3131 = $signed(n3129) > $signed(n3130);
  /* TG68K_FPU_ALU.vhd:1371:135  */
  assign n3133 = {9'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1371:133  */
  assign n3134 = exp_result - n3133;
  /* TG68K_FPU_ALU.vhd:1372:147  */
  assign n3135 = {25'b0, n3069};  //  uext
  /* TG68K_FPU_ALU.vhd:1372:113  */
  assign n3136 = mant_result << n3135;
  /* TG68K_FPU_ALU.vhd:1379:95  */
  assign n3137 = mant_result[63]; // extract
  /* TG68K_FPU_ALU.vhd:1381:121  */
  assign n3139 = mant_result >> 31'b0000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1379:81  */
  assign n3141 = n3137 ? n3139 : 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1369:73  */
  assign n3143 = n3131 ? n3134 : 15'b000000000000000;
  /* TG68K_FPU_ALU.vhd:1369:73  */
  assign n3144 = n3131 ? n3136 : n3141;
  /* TG68K_FPU_ALU.vhd:1369:73  */
  assign n3146 = n3131 ? flags_underflow : 1'b1;
  /* TG68K_FPU_ALU.vhd:1368:65  */
  assign n3147 = n3127 ? n3143 : exp_result;
  /* TG68K_FPU_ALU.vhd:1368:65  */
  assign n3148 = n3127 ? n3144 : mant_result;
  /* TG68K_FPU_ALU.vhd:1368:65  */
  assign n3149 = n3127 ? n3146 : flags_underflow;
  /* TG68K_FPU_ALU.vhd:1321:57  */
  assign n3150 = n3157 ? n3120 : sign_result;
  /* TG68K_FPU_ALU.vhd:1333:65  */
  assign n3152 = n3085 ? 15'b000000000000000 : n3147;
  /* TG68K_FPU_ALU.vhd:1333:65  */
  assign n3154 = n3085 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n3148;
  /* TG68K_FPU_ALU.vhd:1333:65  */
  assign n3156 = n3085 ? 1'b1 : n3149;
  /* TG68K_FPU_ALU.vhd:1321:57  */
  assign n3157 = n3085 & n2247;
  /* TG68K_FPU_ALU.vhd:1321:57  */
  assign n3158 = n2247 ? n3152 : exp_result;
  /* TG68K_FPU_ALU.vhd:1321:57  */
  assign n3159 = n2247 ? n3154 : mant_result;
  /* TG68K_FPU_ALU.vhd:1321:57  */
  assign n3160 = n2247 ? n3156 : flags_underflow;
  /* TG68K_FPU_ALU.vhd:1399:84  */
  assign n3162 = mant_sum[64]; // extract
  /* TG68K_FPU_ALU.vhd:1401:102  */
  assign n3163 = mant_sum[1]; // extract
  /* TG68K_FPU_ALU.vhd:1402:102  */
  assign n3164 = mant_sum[0]; // extract
  /* TG68K_FPU_ALU.vhd:1406:102  */
  assign n3165 = mant_sum[0]; // extract
  /* TG68K_FPU_ALU.vhd:1399:73  */
  assign n3166 = n3162 ? n3163 : n3165;
  /* TG68K_FPU_ALU.vhd:1399:73  */
  assign n3168 = n3162 ? n3164 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1397:65  */
  assign n3170 = operation_code == 7'b0100010;
  /* TG68K_FPU_ALU.vhd:1397:78  */
  assign n3172 = operation_code == 7'b0101000;
  /* TG68K_FPU_ALU.vhd:1397:78  */
  assign n3173 = n3170 | n3172;
  /* TG68K_FPU_ALU.vhd:1412:97  */
  assign n3174 = mult_result[63]; // extract
  /* TG68K_FPU_ALU.vhd:1413:97  */
  assign n3175 = mult_result[62]; // extract
  /* TG68K_FPU_ALU.vhd:1415:87  */
  assign n3176 = mult_result[61:0]; // extract
  /* TG68K_FPU_ALU.vhd:1415:101  */
  assign n3178 = n3176 != 62'b00000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1415:73  */
  assign n3181 = n3178 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1410:65  */
  assign n3183 = operation_code == 7'b0100011;
  /* TG68K_FPU_ALU.vhd:1425:97  */
  assign n3184 = mant_result[0]; // extract
  /* TG68K_FPU_ALU.vhd:1427:87  */
  assign n3185 = mant_result[0]; // extract
  /* TG68K_FPU_ALU.vhd:1427:97  */
  assign n3186 = n3185 | flags_inexact;
  /* TG68K_FPU_ALU.vhd:1427:73  */
  assign n3189 = n3186 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1427:73  */
  assign n3192 = n3186 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1420:65  */
  assign n3194 = operation_code == 7'b0100000;
  /* TG68K_FPU_ALU.vhd:1420:78  */
  assign n3196 = operation_code == 7'b0100100;
  /* TG68K_FPU_ALU.vhd:1420:78  */
  assign n3197 = n3194 | n3196;
  /* TG68K_FPU_ALU.vhd:1437:97  */
  assign n3198 = mant_result[0]; // extract
  /* TG68K_FPU_ALU.vhd:1439:73  */
  assign n3201 = flags_inexact ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1439:73  */
  assign n3204 = flags_inexact ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1434:65  */
  assign n3206 = operation_code == 7'b0000100;
  /* TG68K_FPU_ALU.vhd:1446:65  */
  assign n3208 = operation_code == 7'b0011000;
  /* TG68K_FPU_ALU.vhd:1446:78  */
  assign n3210 = operation_code == 7'b0011010;
  /* TG68K_FPU_ALU.vhd:1446:78  */
  assign n3211 = n3208 | n3210;
  /* TG68K_FPU_ALU.vhd:1446:88  */
  assign n3213 = operation_code == 7'b0000000;
  /* TG68K_FPU_ALU.vhd:1446:88  */
  assign n3214 = n3211 | n3213;
  /* TG68K_FPU_ALU.vhd:1454:92  */
  assign n3216 = $unsigned(exp_a) < $unsigned(15'b011111111111111);
  /* TG68K_FPU_ALU.vhd:1456:100  */
  assign n3217 = mant_a[63]; // extract
  /* TG68K_FPU_ALU.vhd:1457:100  */
  assign n3218 = mant_a[62]; // extract
  /* TG68K_FPU_ALU.vhd:1458:90  */
  assign n3219 = mant_a[61:0]; // extract
  /* TG68K_FPU_ALU.vhd:1458:104  */
  assign n3221 = n3219 != 62'b00000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1458:81  */
  assign n3224 = n3221 ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1454:73  */
  assign n3228 = n3216 ? n3217 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1454:73  */
  assign n3230 = n3216 ? n3218 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1454:73  */
  assign n3232 = n3216 ? n3224 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1451:65  */
  assign n3234 = operation_code == 7'b0000001;
  /* TG68K_FPU_ALU.vhd:1451:78  */
  assign n3236 = operation_code == 7'b0000011;
  /* TG68K_FPU_ALU.vhd:1451:78  */
  assign n3237 = n3234 | n3236;
  /* TG68K_FPU_ALU.vhd:1476:73  */
  assign n3240 = flags_inexact ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1476:73  */
  assign n3243 = flags_inexact ? 1'b1 : 1'b0;
  /* TG68K_FPU_ALU.vhd:1476:73  */
  assign n3246 = flags_inexact ? 1'b1 : 1'b0;
  assign n3247 = {n3237, n3214, n3206, n3197, n3183, n3173};
  /* TG68K_FPU_ALU.vhd:1396:57  */
  always @*
    case (n3247)
      6'b100000: n3249 = n3228;
      6'b010000: n3249 = 1'b0;
      6'b001000: n3249 = n3198;
      6'b000100: n3249 = n3184;
      6'b000010: n3249 = n3174;
      6'b000001: n3249 = n3166;
      default: n3249 = n3240;
    endcase
  /* TG68K_FPU_ALU.vhd:1396:57  */
  always @*
    case (n3247)
      6'b100000: n3251 = n3230;
      6'b010000: n3251 = 1'b0;
      6'b001000: n3251 = n3201;
      6'b000100: n3251 = n3189;
      6'b000010: n3251 = n3175;
      6'b000001: n3251 = n3168;
      default: n3251 = n3243;
    endcase
  /* TG68K_FPU_ALU.vhd:1396:57  */
  always @*
    case (n3247)
      6'b100000: n3254 = n3232;
      6'b010000: n3254 = 1'b0;
      6'b001000: n3254 = n3204;
      6'b000100: n3254 = n3192;
      6'b000010: n3254 = n3181;
      6'b000001: n3254 = 1'b0;
      default: n3254 = n3246;
    endcase
  /* TG68K_FPU_ALU.vhd:1493:113  */
  assign n3257 = round_bit | sticky_bit;
  /* TG68K_FPU_ALU.vhd:1493:147  */
  assign n3258 = mant_result[0]; // extract
  /* TG68K_FPU_ALU.vhd:1493:133  */
  assign n3259 = n3257 | n3258;
  /* TG68K_FPU_ALU.vhd:1493:92  */
  assign n3260 = n3259 & guard_bit;
  /* TG68K_FPU_ALU.vhd:1495:96  */
  assign n3262 = mant_result == 64'b1111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_ALU.vhd:1497:103  */
  assign n3264 = exp_result == 15'b111111111111110;
  /* TG68K_FPU_ALU.vhd:1503:122  */
  assign n3266 = exp_result + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:1497:89  */
  assign n3268 = n3264 ? 15'b111111111111111 : n3266;
  /* TG68K_FPU_ALU.vhd:1497:89  */
  assign n3271 = n3264 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1493:73  */
  assign n3273 = n3281 ? 1'b1 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:1507:116  */
  assign n3275 = mant_result + 64'b0000000000000000000000000000000000000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1493:73  */
  assign n3276 = n3279 ? n3268 : n3158;
  /* TG68K_FPU_ALU.vhd:1495:81  */
  assign n3277 = n3262 ? n3271 : n3275;
  /* TG68K_FPU_ALU.vhd:1495:81  */
  assign n3278 = n3264 & n3262;
  /* TG68K_FPU_ALU.vhd:1493:73  */
  assign n3279 = n3262 & n3260;
  /* TG68K_FPU_ALU.vhd:1493:73  */
  assign n3280 = n3260 ? n3277 : n3159;
  /* TG68K_FPU_ALU.vhd:1493:73  */
  assign n3281 = n3278 & n3260;
  /* TG68K_FPU_ALU.vhd:1492:65  */
  assign n3283 = rounding_mode == 2'b00;
  /* TG68K_FPU_ALU.vhd:1510:65  */
  assign n3285 = rounding_mode == 2'b01;
  /* TG68K_FPU_ALU.vhd:1513:88  */
  assign n3286 = ~sign_result;
  /* TG68K_FPU_ALU.vhd:1513:115  */
  assign n3287 = guard_bit | round_bit;
  /* TG68K_FPU_ALU.vhd:1513:134  */
  assign n3288 = n3287 | sticky_bit;
  /* TG68K_FPU_ALU.vhd:1513:94  */
  assign n3289 = n3288 & n3286;
  /* TG68K_FPU_ALU.vhd:1515:96  */
  assign n3291 = mant_result == 64'b1111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_ALU.vhd:1516:103  */
  assign n3293 = exp_result == 15'b111111111111110;
  /* TG68K_FPU_ALU.vhd:1522:122  */
  assign n3295 = exp_result + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:1516:89  */
  assign n3297 = n3293 ? 15'b111111111111111 : n3295;
  /* TG68K_FPU_ALU.vhd:1516:89  */
  assign n3300 = n3293 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1513:73  */
  assign n3302 = n3310 ? 1'b1 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:1526:116  */
  assign n3304 = mant_result + 64'b0000000000000000000000000000000000000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1513:73  */
  assign n3305 = n3308 ? n3297 : n3158;
  /* TG68K_FPU_ALU.vhd:1515:81  */
  assign n3306 = n3291 ? n3300 : n3304;
  /* TG68K_FPU_ALU.vhd:1515:81  */
  assign n3307 = n3293 & n3291;
  /* TG68K_FPU_ALU.vhd:1513:73  */
  assign n3308 = n3291 & n3289;
  /* TG68K_FPU_ALU.vhd:1513:73  */
  assign n3309 = n3289 ? n3306 : n3159;
  /* TG68K_FPU_ALU.vhd:1513:73  */
  assign n3310 = n3307 & n3289;
  /* TG68K_FPU_ALU.vhd:1512:65  */
  assign n3312 = rounding_mode == 2'b10;
  /* TG68K_FPU_ALU.vhd:1530:115  */
  assign n3313 = guard_bit | round_bit;
  /* TG68K_FPU_ALU.vhd:1530:134  */
  assign n3314 = n3313 | sticky_bit;
  /* TG68K_FPU_ALU.vhd:1530:94  */
  assign n3315 = n3314 & sign_result;
  /* TG68K_FPU_ALU.vhd:1532:96  */
  assign n3317 = mant_result == 64'b1111111111111111111111111111111111111111111111111111111111111111;
  /* TG68K_FPU_ALU.vhd:1533:103  */
  assign n3319 = exp_result == 15'b111111111111110;
  /* TG68K_FPU_ALU.vhd:1539:122  */
  assign n3321 = exp_result + 15'b000000000000001;
  /* TG68K_FPU_ALU.vhd:1533:89  */
  assign n3323 = n3319 ? 15'b111111111111111 : n3321;
  /* TG68K_FPU_ALU.vhd:1533:89  */
  assign n3326 = n3319 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : 64'b1000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_ALU.vhd:1530:73  */
  assign n3328 = n3336 ? 1'b1 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:1543:116  */
  assign n3330 = mant_result + 64'b0000000000000000000000000000000000000000000000000000000000000001;
  /* TG68K_FPU_ALU.vhd:1530:73  */
  assign n3331 = n3334 ? n3323 : n3158;
  /* TG68K_FPU_ALU.vhd:1532:81  */
  assign n3332 = n3317 ? n3326 : n3330;
  /* TG68K_FPU_ALU.vhd:1532:81  */
  assign n3333 = n3319 & n3317;
  /* TG68K_FPU_ALU.vhd:1530:73  */
  assign n3334 = n3317 & n3315;
  /* TG68K_FPU_ALU.vhd:1530:73  */
  assign n3335 = n3315 ? n3332 : n3159;
  /* TG68K_FPU_ALU.vhd:1530:73  */
  assign n3336 = n3333 & n3315;
  /* TG68K_FPU_ALU.vhd:1529:65  */
  assign n3338 = rounding_mode == 2'b11;
  assign n3339 = {n3338, n3312, n3285, n3283};
  /* TG68K_FPU_ALU.vhd:1491:57  */
  always @*
    case (n3339)
      4'b1000: n3340 = n3331;
      4'b0100: n3340 = n3305;
      4'b0010: n3340 = n3158;
      4'b0001: n3340 = n3276;
      default: n3340 = n3158;
    endcase
  /* TG68K_FPU_ALU.vhd:1491:57  */
  always @*
    case (n3339)
      4'b1000: n3341 = n3335;
      4'b0100: n3341 = n3309;
      4'b0010: n3341 = n3159;
      4'b0001: n3341 = n3280;
      default: n3341 = n3159;
    endcase
  /* TG68K_FPU_ALU.vhd:1491:57  */
  always @*
    case (n3339)
      4'b1000: n3342 = n3328;
      4'b0100: n3342 = n3302;
      4'b0010: n3342 = flags_overflow;
      4'b0001: n3342 = n3273;
      default: n3342 = flags_overflow;
    endcase
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3343 = n2245 ? sign_result : n3150;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3345 = n2245 ? 15'b000000000000000 : n3340;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3347 = n2245 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n3341;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3348 = n2245 ? guard_bit : n3249;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3349 = n2245 ? round_bit : n3251;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3350 = n2245 ? sticky_bit : n3254;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3352 = n2245 ? flags_overflow : n3342;
  /* TG68K_FPU_ALU.vhd:1313:49  */
  assign n3354 = n2245 ? 1'b1 : n3160;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3356 = n2244 ? sign_result : n3343;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3358 = n2244 ? 15'b111111111111111 : n3345;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3360 = n2244 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n3347;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3361 = n2244 ? guard_bit : n3348;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3362 = n2244 ? round_bit : n3349;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3363 = n2244 ? sticky_bit : n3350;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3366 = n2244 ? 1'b1 : n3352;
  /* TG68K_FPU_ALU.vhd:1308:49  */
  assign n3367 = n2244 ? flags_underflow : n3354;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3369 = n2242 ? sign_result : n3356;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3371 = n2242 ? 15'b000000000000000 : n3358;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3373 = n2242 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n3360;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3374 = n2242 ? guard_bit : n3361;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3375 = n2242 ? round_bit : n3362;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3376 = n2242 ? sticky_bit : n3363;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3378 = n2242 ? flags_overflow : n3366;
  /* TG68K_FPU_ALU.vhd:1304:49  */
  assign n3379 = n2242 ? flags_underflow : n3367;
  /* TG68K_FPU_ALU.vhd:1301:41  */
  assign n3382 = alu_state == 3'b100;
  /* TG68K_FPU_ALU.vhd:1555:71  */
  assign n3383 = {sign_result, exp_result};
  /* TG68K_FPU_ALU.vhd:1555:84  */
  assign n3384 = {n3383, mant_result};
  /* TG68K_FPU_ALU.vhd:1553:41  */
  assign n3386 = alu_state == 3'b101;
  assign n3387 = {n3386, n3382, n2237, n195, n149, n147};
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3389 = n3384;
      6'b010000: n3389 = n3711;
      6'b001000: n3389 = n3711;
      6'b000100: n3389 = n3711;
      6'b000010: n3389 = n3711;
      6'b000001: n3389 = n3711;
      default: n3389 = 80'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3393 = 1'b1;
      6'b010000: n3393 = n3713;
      6'b001000: n3393 = n3713;
      6'b000100: n3393 = n3713;
      6'b000010: n3393 = n3713;
      6'b000001: n3393 = 1'b0;
      default: n3393 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3396 = 1'b0;
      6'b010000: n3396 = n3715;
      6'b001000: n3396 = n3715;
      6'b000100: n3396 = n3715;
      6'b000010: n3396 = n3715;
      6'b000001: n3396 = n142;
      default: n3396 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3400 = 1'b1;
      6'b010000: n3400 = n3717;
      6'b001000: n3400 = n3717;
      6'b000100: n3400 = n3717;
      6'b000010: n3400 = n3717;
      6'b000001: n3400 = 1'b0;
      default: n3400 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3402 = sign_a;
      6'b010000: n3402 = sign_a;
      6'b001000: n3402 = sign_a;
      6'b000100: n3402 = n150;
      6'b000010: n3402 = sign_a;
      6'b000001: n3402 = sign_a;
      default: n3402 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3404 = sign_b;
      6'b010000: n3404 = sign_b;
      6'b001000: n3404 = sign_b;
      6'b000100: n3404 = n153;
      6'b000010: n3404 = sign_b;
      6'b000001: n3404 = sign_b;
      default: n3404 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3406 = sign_result;
      6'b010000: n3406 = n3369;
      6'b001000: n3406 = n2212;
      6'b000100: n3406 = n189;
      6'b000010: n3406 = sign_result;
      6'b000001: n3406 = sign_result;
      default: n3406 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3408 = exp_a;
      6'b010000: n3408 = exp_a;
      6'b001000: n3408 = exp_a;
      6'b000100: n3408 = n151;
      6'b000010: n3408 = exp_a;
      6'b000001: n3408 = exp_a;
      default: n3408 = 15'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3410 = exp_b;
      6'b010000: n3410 = exp_b;
      6'b001000: n3410 = exp_b;
      6'b000100: n3410 = n154;
      6'b000010: n3410 = exp_b;
      6'b000001: n3410 = exp_b;
      default: n3410 = 15'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3412 = exp_result;
      6'b010000: n3412 = n3371;
      6'b001000: n3412 = n2215;
      6'b000100: n3412 = n190;
      6'b000010: n3412 = exp_result;
      6'b000001: n3412 = exp_result;
      default: n3412 = 15'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3414 = mant_a;
      6'b010000: n3414 = mant_a;
      6'b001000: n3414 = mant_a;
      6'b000100: n3414 = n152;
      6'b000010: n3414 = mant_a;
      6'b000001: n3414 = mant_a;
      default: n3414 = 64'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3416 = mant_b;
      6'b010000: n3416 = mant_b;
      6'b001000: n3416 = mant_b;
      6'b000100: n3416 = n155;
      6'b000010: n3416 = mant_b;
      6'b000001: n3416 = mant_b;
      default: n3416 = 64'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3418 = mant_result;
      6'b010000: n3418 = n3373;
      6'b001000: n3418 = n2218;
      6'b000100: n3418 = n191;
      6'b000010: n3418 = mant_result;
      6'b000001: n3418 = mant_result;
      default: n3418 = 64'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3424 = 3'b000;
      6'b010000: n3424 = 3'b101;
      6'b001000: n3424 = 3'b100;
      6'b000100: n3424 = n193;
      6'b000010: n3424 = 3'b010;
      6'b000001: n3424 = n145;
      default: n3424 = 3'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3426 = mant_sum;
      6'b010000: n3426 = mant_sum;
      6'b001000: n3426 = n2219;
      6'b000100: n3426 = mant_sum;
      6'b000010: n3426 = mant_sum;
      6'b000001: n3426 = mant_sum;
      default: n3426 = 65'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3432 = mant_a_aligned;
      6'b010000: n3432 = mant_a_aligned;
      6'b001000: n3432 = n2222;
      6'b000100: n3432 = mant_a_aligned;
      6'b000010: n3432 = mant_a_aligned;
      6'b000001: n3432 = mant_a_aligned;
      default: n3432 = 65'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3434 = mant_b_aligned;
      6'b010000: n3434 = mant_b_aligned;
      6'b001000: n3434 = n2223;
      6'b000100: n3434 = mant_b_aligned;
      6'b000010: n3434 = mant_b_aligned;
      6'b000001: n3434 = mant_b_aligned;
      default: n3434 = 65'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3436 = exp_larger;
      6'b010000: n3436 = exp_larger;
      6'b001000: n3436 = n2224;
      6'b000100: n3436 = exp_larger;
      6'b000010: n3436 = exp_larger;
      6'b000001: n3436 = exp_larger;
      default: n3436 = 15'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3440 = guard_bit;
      6'b010000: n3440 = n3374;
      6'b001000: n3440 = guard_bit;
      6'b000100: n3440 = guard_bit;
      6'b000010: n3440 = guard_bit;
      6'b000001: n3440 = guard_bit;
      default: n3440 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3442 = round_bit;
      6'b010000: n3442 = n3375;
      6'b001000: n3442 = round_bit;
      6'b000100: n3442 = round_bit;
      6'b000010: n3442 = round_bit;
      6'b000001: n3442 = round_bit;
      default: n3442 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3444 = sticky_bit;
      6'b010000: n3444 = n3376;
      6'b001000: n3444 = sticky_bit;
      6'b000100: n3444 = sticky_bit;
      6'b000010: n3444 = sticky_bit;
      6'b000001: n3444 = sticky_bit;
      default: n3444 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3448 = mult_result;
      6'b010000: n3448 = mult_result;
      6'b001000: n3448 = n2226;
      6'b000100: n3448 = mult_result;
      6'b000010: n3448 = mult_result;
      6'b000001: n3448 = mult_result;
      default: n3448 = 128'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3450 = fmod_quotient;
      6'b010000: n3450 = fmod_quotient;
      6'b001000: n3450 = n2227;
      6'b000100: n3450 = fmod_quotient;
      6'b000010: n3450 = fmod_quotient;
      6'b000001: n3450 = fmod_quotient;
      default: n3450 = 8'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3453 = flags_overflow;
      6'b010000: n3453 = n3378;
      6'b001000: n3453 = n2228;
      6'b000100: n3453 = flags_overflow;
      6'b000010: n3453 = 1'b0;
      6'b000001: n3453 = flags_overflow;
      default: n3453 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3456 = flags_underflow;
      6'b010000: n3456 = n3379;
      6'b001000: n3456 = n2229;
      6'b000100: n3456 = flags_underflow;
      6'b000010: n3456 = 1'b0;
      6'b000001: n3456 = flags_underflow;
      default: n3456 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3459 = flags_inexact;
      6'b010000: n3459 = flags_inexact;
      6'b001000: n3459 = n2230;
      6'b000100: n3459 = flags_inexact;
      6'b000010: n3459 = 1'b0;
      6'b000001: n3459 = flags_inexact;
      default: n3459 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3462 = flags_invalid;
      6'b010000: n3462 = flags_invalid;
      6'b001000: n3462 = n2232;
      6'b000100: n3462 = flags_invalid;
      6'b000010: n3462 = 1'b0;
      6'b000001: n3462 = flags_invalid;
      default: n3462 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:283:33  */
  always @*
    case (n3387)
      6'b100000: n3465 = flags_div_by_zero;
      6'b010000: n3465 = flags_div_by_zero;
      6'b001000: n3465 = n2233;
      6'b000100: n3465 = flags_div_by_zero;
      6'b000010: n3465 = 1'b0;
      6'b000001: n3465 = flags_div_by_zero;
      default: n3465 = 1'bX;
    endcase
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3600 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3601 = clkena & n3600;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3602 = n3601 ? n3402 : sign_a;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3603 <= n3602;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3604 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3605 = clkena & n3604;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3606 = n3605 ? n3404 : sign_b;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3607 <= n3606;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3608 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3609 = clkena & n3608;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3610 = n3609 ? n3406 : sign_result;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3611 <= n3610;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3612 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3613 = clkena & n3612;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3614 = n3613 ? n3408 : exp_a;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3615 <= n3614;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3616 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3617 = clkena & n3616;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3618 = n3617 ? n3410 : exp_b;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3619 <= n3618;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3620 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3621 = clkena & n3620;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3622 = n3621 ? n3412 : exp_result;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3623 <= n3622;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3624 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3625 = clkena & n3624;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3626 = n3625 ? n3414 : mant_a;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3627 <= n3626;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3628 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3629 = clkena & n3628;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3630 = n3629 ? n3416 : mant_b;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3631 <= n3630;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3632 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3633 = clkena & n3632;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3634 = n3633 ? n3418 : mant_result;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3635 <= n3634;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3636 = clkena ? n3424 : alu_state;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3637 <= 3'b000;
    else
      n3637 <= n3636;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3639 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3640 = clkena & n3639;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3641 = n3640 ? n3426 : mant_sum;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3642 <= n3641;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3652 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3653 = clkena & n3652;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3654 = n3653 ? n3432 : mant_a_aligned;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3655 <= n3654;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3656 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3657 = clkena & n3656;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3658 = n3657 ? n3434 : mant_b_aligned;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3659 <= n3658;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3660 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3661 = clkena & n3660;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3662 = n3661 ? n3436 : exp_larger;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3663 <= n3662;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3668 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3669 = clkena & n3668;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3670 = n3669 ? n3440 : guard_bit;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3671 <= n3670;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3672 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3673 = clkena & n3672;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3674 = n3673 ? n3442 : round_bit;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3675 <= n3674;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3676 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3677 = clkena & n3676;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3678 = n3677 ? n3444 : sticky_bit;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3679 <= n3678;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3686 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3687 = clkena & n3686;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3688 = n3687 ? n3448 : mult_result;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3689 <= n3688;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3696 = ~n138;
  /* TG68K_FPU_ALU.vhd:262:9  */
  assign n3697 = clkena & n3696;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3698 = n3697 ? n3450 : fmod_quotient;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk)
    n3699 <= n3698;
  initial
    n3699 = 8'b00000000;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3700 = clkena ? n3453 : flags_overflow;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3701 <= 1'b0;
    else
      n3701 <= n3700;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3702 = clkena ? n3456 : flags_underflow;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3703 <= 1'b0;
    else
      n3703 <= n3702;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3704 = clkena ? n3459 : flags_inexact;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3705 <= 1'b0;
    else
      n3705 <= n3704;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3706 = clkena ? n3462 : flags_invalid;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3707 <= 1'b0;
    else
      n3707 <= n3706;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3708 = clkena ? n3465 : flags_div_by_zero;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3709 <= 1'b0;
    else
      n3709 <= n3708;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3710 = clkena ? n3389 : n3711;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3711 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n3711 <= n3710;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3712 = clkena ? n3393 : n3713;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3713 <= 1'b0;
    else
      n3713 <= n3712;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3714 = clkena ? n3396 : n3715;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3715 <= 1'b0;
    else
      n3715 <= n3714;
  /* TG68K_FPU_ALU.vhd:281:17  */
  assign n3716 = clkena ? n3400 : n3717;
  /* TG68K_FPU_ALU.vhd:281:17  */
  always @(posedge clk or posedge n138)
    if (n138)
      n3717 <= 1'b0;
    else
      n3717 <= n3716;
endmodule

