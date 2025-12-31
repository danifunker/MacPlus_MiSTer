module TG68K_Cache_030
  (input  clk,
   input  nreset,
   input  cacr_ie,
   input  cacr_de,
   input  cacr_ifreeze,
   input  cacr_dfreeze,
   input  cacr_wa,
   input  inv_req,
   input  [1:0] cache_op_scope,
   input  [1:0] cache_op_cache,
   input  [31:0] cache_op_addr,
   input  [31:0] i_addr,
   input  [31:0] i_addr_phys,
   input  i_req,
   input  i_cache_inhibit,
   input  [127:0] i_fill_data,
   input  i_fill_valid,
   input  [31:0] d_addr,
   input  [31:0] d_addr_phys,
   input  d_req,
   input  d_we,
   input  d_cache_inhibit,
   input  [31:0] d_data_in,
   input  [3:0] d_be,
   input  [127:0] d_fill_data,
   input  d_fill_valid,
   output [31:0] i_data,
   output i_hit,
   output i_fill_req,
   output [31:0] i_fill_addr,
   output [31:0] d_data_out,
   output d_hit,
   output d_fill_req,
   output [31:0] d_fill_addr);
  wire [383:0] i_tag_array;
  wire [15:0] i_valid_array;
  wire [2047:0] d_data_array;
  wire [383:0] d_tag_array;
  wire [15:0] d_valid_array;
  wire [3:0] i_line_idx;
  wire [23:0] i_tag;
  wire [3:0] i_offset;
  wire [3:0] d_line_idx;
  wire [23:0] d_tag;
  wire [3:0] d_offset;
  reg i_fill_req_int;
  reg d_fill_req_int;
  reg [3:0] i_fill_line_idx;
  reg [23:0] i_fill_tag;
  reg [3:0] d_fill_line_idx;
  reg [23:0] d_fill_tag;
  wire [3:0] cache_op_line_idx;
  wire [23:0] cache_op_tag;
  wire [23:0] cache_op_page_mask;
  wire [3:0] n14;
  wire [23:0] n16;
  wire [1:0] n17;
  wire [30:0] n18;
  wire [31:0] n19;
  wire [31:0] n21;
  wire [3:0] n22;
  wire [3:0] n23;
  wire [23:0] n25;
  wire [1:0] n26;
  wire [30:0] n27;
  wire [31:0] n28;
  wire [31:0] n30;
  wire [3:0] n31;
  wire [3:0] n32;
  wire [23:0] n34;
  wire [19:0] n35;
  wire [23:0] n37;
  wire n40;
  wire [3:0] n63;
  wire [3:0] n67;
  wire [15:0] n73;
  wire n75;
  wire n77;
  wire n79;
  wire n80;
  wire n82;
  wire n83;
  wire n84;
  wire n102;
  wire n104;
  wire n105;
  wire n106;
  wire [19:0] n107;
  wire [19:0] n108;
  wire n109;
  wire n110;
  wire n112;
  wire n113;
  wire n114;
  wire [19:0] n115;
  wire [19:0] n116;
  wire n117;
  wire n118;
  wire n120;
  wire n121;
  wire n122;
  wire [19:0] n123;
  wire [19:0] n124;
  wire n125;
  wire n126;
  wire n128;
  wire n129;
  wire n130;
  wire [19:0] n131;
  wire [19:0] n132;
  wire n133;
  wire n134;
  wire n136;
  wire n137;
  wire n138;
  wire [19:0] n139;
  wire [19:0] n140;
  wire n141;
  wire n142;
  wire n144;
  wire n145;
  wire n146;
  wire [19:0] n147;
  wire [19:0] n148;
  wire n149;
  wire n150;
  wire n152;
  wire n153;
  wire n154;
  wire [19:0] n155;
  wire [19:0] n156;
  wire n157;
  wire n158;
  wire n160;
  wire n161;
  wire n162;
  wire [19:0] n163;
  wire [19:0] n164;
  wire n165;
  wire n166;
  wire n168;
  wire n169;
  wire n170;
  wire [19:0] n171;
  wire [19:0] n172;
  wire n173;
  wire n174;
  wire n176;
  wire n177;
  wire n178;
  wire [19:0] n179;
  wire [19:0] n180;
  wire n181;
  wire n182;
  wire n184;
  wire n185;
  wire n186;
  wire [19:0] n187;
  wire [19:0] n188;
  wire n189;
  wire n190;
  wire n192;
  wire n193;
  wire n194;
  wire [19:0] n195;
  wire [19:0] n196;
  wire n197;
  wire n198;
  wire n200;
  wire n201;
  wire n202;
  wire [19:0] n203;
  wire [19:0] n204;
  wire n205;
  wire n206;
  wire n208;
  wire n209;
  wire n210;
  wire [19:0] n211;
  wire [19:0] n212;
  wire n213;
  wire n214;
  wire n216;
  wire n217;
  wire n218;
  wire [19:0] n219;
  wire [19:0] n220;
  wire n221;
  wire n222;
  wire n224;
  wire n225;
  wire n226;
  wire [19:0] n227;
  wire [19:0] n228;
  wire n229;
  wire n230;
  wire n232;
  wire n233;
  wire n235;
  wire [3:0] n237;
  wire [3:0] n241;
  wire n244;
  wire n245;
  wire [3:0] n247;
  wire [15:0] n251;
  wire n253;
  wire [2:0] n254;
  wire n255;
  wire n256;
  reg n257;
  wire n258;
  wire n259;
  reg n260;
  wire n261;
  wire n262;
  reg n263;
  wire n264;
  wire n265;
  reg n266;
  wire n267;
  wire n268;
  reg n269;
  wire n270;
  wire n271;
  reg n272;
  wire n273;
  wire n274;
  reg n275;
  wire n276;
  wire n277;
  reg n278;
  wire n279;
  wire n280;
  reg n281;
  wire n282;
  wire n283;
  reg n284;
  wire n285;
  wire n286;
  reg n287;
  wire n288;
  wire n289;
  reg n290;
  wire n291;
  wire n292;
  reg n293;
  wire n294;
  wire n295;
  reg n296;
  wire n297;
  wire n298;
  reg n299;
  wire n300;
  wire n301;
  reg n302;
  wire [15:0] n303;
  wire [15:0] n304;
  wire n305;
  wire n306;
  wire n307;
  wire n308;
  wire n309;
  wire [3:0] n311;
  wire n314;
  wire [3:0] n316;
  wire n319;
  wire n320;
  wire n321;
  wire [27:0] n322;
  wire [31:0] n324;
  wire n327;
  wire n330;
  wire n331;
  wire n332;
  wire n333;
  wire n334;
  wire n335;
  wire n336;
  wire n337;
  wire n338;
  wire n340;
  wire [15:0] n352;
  wire n360;
  wire n361;
  wire n362;
  wire [3:0] n364;
  wire n367;
  wire [3:0] n369;
  wire n372;
  wire n373;
  wire n374;
  wire n381;
  wire n387;
  wire n393;
  wire n399;
  wire [3:0] n401;
  reg [31:0] n402;
  wire n405;
  wire [3:0] n424;
  wire [3:0] n428;
  wire [3:0] n432;
  wire [2047:0] n436;
  wire [15:0] n438;
  wire n440;
  wire n442;
  wire n444;
  wire n445;
  wire n447;
  wire n448;
  wire n449;
  wire n467;
  wire n469;
  wire n470;
  wire n471;
  wire [19:0] n472;
  wire [19:0] n473;
  wire n474;
  wire n475;
  wire n477;
  wire n478;
  wire n479;
  wire [19:0] n480;
  wire [19:0] n481;
  wire n482;
  wire n483;
  wire n485;
  wire n486;
  wire n487;
  wire [19:0] n488;
  wire [19:0] n489;
  wire n490;
  wire n491;
  wire n493;
  wire n494;
  wire n495;
  wire [19:0] n496;
  wire [19:0] n497;
  wire n498;
  wire n499;
  wire n501;
  wire n502;
  wire n503;
  wire [19:0] n504;
  wire [19:0] n505;
  wire n506;
  wire n507;
  wire n509;
  wire n510;
  wire n511;
  wire [19:0] n512;
  wire [19:0] n513;
  wire n514;
  wire n515;
  wire n517;
  wire n518;
  wire n519;
  wire [19:0] n520;
  wire [19:0] n521;
  wire n522;
  wire n523;
  wire n525;
  wire n526;
  wire n527;
  wire [19:0] n528;
  wire [19:0] n529;
  wire n530;
  wire n531;
  wire n533;
  wire n534;
  wire n535;
  wire [19:0] n536;
  wire [19:0] n537;
  wire n538;
  wire n539;
  wire n541;
  wire n542;
  wire n543;
  wire [19:0] n544;
  wire [19:0] n545;
  wire n546;
  wire n547;
  wire n549;
  wire n550;
  wire n551;
  wire [19:0] n552;
  wire [19:0] n553;
  wire n554;
  wire n555;
  wire n557;
  wire n558;
  wire n559;
  wire [19:0] n560;
  wire [19:0] n561;
  wire n562;
  wire n563;
  wire n565;
  wire n566;
  wire n567;
  wire [19:0] n568;
  wire [19:0] n569;
  wire n570;
  wire n571;
  wire n573;
  wire n574;
  wire n575;
  wire [19:0] n576;
  wire [19:0] n577;
  wire n578;
  wire n579;
  wire n581;
  wire n582;
  wire n583;
  wire [19:0] n584;
  wire [19:0] n585;
  wire n586;
  wire n587;
  wire n589;
  wire n590;
  wire n591;
  wire [19:0] n592;
  wire [19:0] n593;
  wire n594;
  wire n595;
  wire n597;
  wire n598;
  wire n600;
  wire [3:0] n602;
  wire [3:0] n606;
  wire n609;
  wire n610;
  wire [3:0] n612;
  wire [15:0] n616;
  wire n618;
  wire [2:0] n619;
  wire n620;
  wire n621;
  reg n622;
  wire n623;
  wire n624;
  reg n625;
  wire n626;
  wire n627;
  reg n628;
  wire n629;
  wire n630;
  reg n631;
  wire n632;
  wire n633;
  reg n634;
  wire n635;
  wire n636;
  reg n637;
  wire n638;
  wire n639;
  reg n640;
  wire n641;
  wire n642;
  reg n643;
  wire n644;
  wire n645;
  reg n646;
  wire n647;
  wire n648;
  reg n649;
  wire n650;
  wire n651;
  reg n652;
  wire n653;
  wire n654;
  reg n655;
  wire n656;
  wire n657;
  reg n658;
  wire n659;
  wire n660;
  reg n661;
  wire n662;
  wire n663;
  reg n664;
  wire n665;
  wire n666;
  reg n667;
  wire [15:0] n668;
  wire [15:0] n669;
  wire n670;
  wire n671;
  wire n672;
  wire [3:0] n674;
  wire n677;
  wire [3:0] n679;
  wire n682;
  wire n683;
  wire n684;
  wire [3:0] n686;
  wire [7:0] n688;
  wire [2047:0] n690;
  wire n691;
  wire [3:0] n693;
  wire [7:0] n695;
  wire [2047:0] n697;
  wire n698;
  wire [3:0] n700;
  wire [7:0] n702;
  wire [2047:0] n704;
  wire n705;
  wire [3:0] n707;
  wire [7:0] n709;
  wire [2047:0] n711;
  wire n713;
  wire n714;
  wire [3:0] n716;
  wire [7:0] n718;
  wire [2047:0] n720;
  wire n721;
  wire [3:0] n723;
  wire [7:0] n725;
  wire [2047:0] n727;
  wire n728;
  wire [3:0] n730;
  wire [7:0] n732;
  wire [2047:0] n734;
  wire n735;
  wire [3:0] n737;
  wire [7:0] n739;
  wire [2047:0] n741;
  wire n743;
  wire n744;
  wire [3:0] n746;
  wire [7:0] n748;
  wire [2047:0] n750;
  wire n751;
  wire [3:0] n753;
  wire [7:0] n755;
  wire [2047:0] n757;
  wire n758;
  wire [3:0] n760;
  wire [7:0] n762;
  wire [2047:0] n764;
  wire n765;
  wire [3:0] n767;
  wire [7:0] n769;
  wire [2047:0] n771;
  wire n773;
  wire n774;
  wire [3:0] n776;
  wire [7:0] n778;
  wire [2047:0] n780;
  wire n781;
  wire [3:0] n783;
  wire [7:0] n785;
  wire [2047:0] n787;
  wire n788;
  wire [3:0] n790;
  wire [7:0] n792;
  wire [2047:0] n794;
  wire n795;
  wire [3:0] n797;
  wire [7:0] n799;
  wire [2047:0] n801;
  wire n803;
  wire [3:0] n804;
  reg [2047:0] n805;
  wire n806;
  wire n807;
  wire [3:0] n809;
  wire n812;
  wire [3:0] n814;
  wire n817;
  wire n818;
  wire n819;
  wire n820;
  wire [27:0] n821;
  wire [31:0] n823;
  wire [31:0] n824;
  wire n826;
  wire [3:0] n827;
  wire [23:0] n828;
  wire n829;
  wire n830;
  wire n831;
  wire n832;
  wire n833;
  wire n834;
  wire [3:0] n836;
  wire n839;
  wire [3:0] n841;
  wire n844;
  wire n845;
  wire n846;
  wire n847;
  wire [27:0] n848;
  wire [31:0] n850;
  wire [31:0] n851;
  wire n853;
  wire [3:0] n854;
  wire [23:0] n855;
  wire n856;
  wire n857;
  wire n858;
  wire n859;
  wire [31:0] n860;
  wire n861;
  wire [3:0] n862;
  wire [23:0] n863;
  wire [31:0] n864;
  wire [2047:0] n865;
  wire n866;
  wire [3:0] n867;
  wire [23:0] n868;
  wire n870;
  wire n871;
  wire n874;
  wire n875;
  wire n876;
  wire n877;
  wire [3:0] n879;
  wire [3:0] n883;
  wire n886;
  wire n887;
  wire n888;
  wire n889;
  wire [31:0] n890;
  wire n892;
  wire n893;
  wire [19:0] n894;
  wire [19:0] n895;
  wire n896;
  wire n898;
  wire n899;
  wire n901;
  wire n902;
  wire [31:0] n903;
  wire n905;
  wire n906;
  wire [19:0] n907;
  wire [19:0] n908;
  wire n909;
  wire n911;
  wire n912;
  wire n914;
  wire n915;
  wire [31:0] n916;
  wire n918;
  wire n919;
  wire [19:0] n920;
  wire [19:0] n921;
  wire n922;
  wire n924;
  wire n925;
  wire n927;
  wire n928;
  wire [31:0] n929;
  wire n931;
  wire n932;
  wire [19:0] n933;
  wire [19:0] n934;
  wire n935;
  wire n937;
  wire n938;
  wire n940;
  wire n941;
  wire [31:0] n942;
  wire n944;
  wire n945;
  wire [19:0] n946;
  wire [19:0] n947;
  wire n948;
  wire n950;
  wire n951;
  wire n953;
  wire n954;
  wire [31:0] n955;
  wire n957;
  wire n958;
  wire [19:0] n959;
  wire [19:0] n960;
  wire n961;
  wire n963;
  wire n964;
  wire n966;
  wire n967;
  wire [31:0] n968;
  wire n970;
  wire n971;
  wire [19:0] n972;
  wire [19:0] n973;
  wire n974;
  wire n976;
  wire n977;
  wire n979;
  wire n980;
  wire [31:0] n981;
  wire n983;
  wire n984;
  wire [19:0] n985;
  wire [19:0] n986;
  wire n987;
  wire n989;
  wire n990;
  wire n992;
  wire n993;
  wire [31:0] n994;
  wire n996;
  wire n997;
  wire [19:0] n998;
  wire [19:0] n999;
  wire n1000;
  wire n1002;
  wire n1003;
  wire n1005;
  wire n1006;
  wire [31:0] n1007;
  wire n1009;
  wire n1010;
  wire [19:0] n1011;
  wire [19:0] n1012;
  wire n1013;
  wire n1015;
  wire n1016;
  wire n1018;
  wire n1019;
  wire [31:0] n1020;
  wire n1022;
  wire n1023;
  wire [19:0] n1024;
  wire [19:0] n1025;
  wire n1026;
  wire n1028;
  wire n1029;
  wire n1031;
  wire n1032;
  wire [31:0] n1033;
  wire n1035;
  wire n1036;
  wire [19:0] n1037;
  wire [19:0] n1038;
  wire n1039;
  wire n1041;
  wire n1042;
  wire n1044;
  wire n1045;
  wire [31:0] n1046;
  wire n1048;
  wire n1049;
  wire [19:0] n1050;
  wire [19:0] n1051;
  wire n1052;
  wire n1054;
  wire n1055;
  wire n1057;
  wire n1058;
  wire [31:0] n1059;
  wire n1061;
  wire n1062;
  wire [19:0] n1063;
  wire [19:0] n1064;
  wire n1065;
  wire n1067;
  wire n1068;
  wire n1070;
  wire n1071;
  wire [31:0] n1072;
  wire n1074;
  wire n1075;
  wire [19:0] n1076;
  wire [19:0] n1077;
  wire n1078;
  wire n1080;
  wire n1081;
  wire n1083;
  wire n1084;
  wire [31:0] n1085;
  wire n1087;
  wire n1088;
  wire [19:0] n1089;
  wire [19:0] n1090;
  wire n1091;
  wire n1093;
  wire n1094;
  wire n1096;
  wire [15:0] n1097;
  wire [15:0] n1098;
  wire n1099;
  wire n1100;
  wire n1102;
  wire [15:0] n1114;
  wire n1122;
  wire n1123;
  wire n1124;
  wire [3:0] n1126;
  wire n1129;
  wire [3:0] n1131;
  wire n1134;
  wire n1135;
  wire n1136;
  wire [3:0] n1139;
  wire n1143;
  wire [3:0] n1145;
  wire n1149;
  wire [3:0] n1151;
  wire n1155;
  wire [3:0] n1157;
  wire n1161;
  wire [3:0] n1163;
  reg [31:0] n1164;
  wire n1165;
  wire n1166;
  wire n1169;
  wire n1170;
  reg [383:0] n1172;
  reg [15:0] n1173;
  wire n1174;
  wire [2047:0] n1175;
  reg [2047:0] n1176;
  wire n1177;
  wire n1178;
  reg [383:0] n1180;
  reg [15:0] n1181;
  reg n1182;
  reg n1183;
  wire n1184;
  wire n1185;
  wire [3:0] n1186;
  reg [3:0] n1187;
  wire n1188;
  wire n1189;
  wire [23:0] n1190;
  reg [23:0] n1191;
  wire n1192;
  wire n1193;
  wire [3:0] n1194;
  reg [3:0] n1195;
  wire n1196;
  wire n1197;
  wire [23:0] n1198;
  reg [23:0] n1199;
  wire [31:0] n1200;
  reg [31:0] n1201;
  wire [31:0] n1202;
  reg [31:0] n1203;
  wire [31:0] n1204; // mem_rd
  wire [31:0] n1205; // mem_rd
  wire [31:0] n1206; // mem_rd
  wire [31:0] n1207; // mem_rd
  wire [31:0] n1208;
  wire [31:0] n1210;
  wire [31:0] n1212;
  wire [31:0] n1214;
  wire n1216;
  wire n1217;
  wire n1218;
  wire n1219;
  wire n1220;
  wire n1221;
  wire n1222;
  wire n1223;
  wire n1224;
  wire n1225;
  wire n1226;
  wire n1227;
  wire n1228;
  wire n1229;
  wire n1230;
  wire n1231;
  wire n1232;
  wire n1233;
  wire n1234;
  wire n1235;
  wire n1236;
  wire n1237;
  wire n1238;
  wire n1239;
  wire n1240;
  wire n1241;
  wire n1242;
  wire n1243;
  wire n1244;
  wire n1245;
  wire n1246;
  wire n1247;
  wire n1248;
  wire n1249;
  wire n1250;
  wire n1251;
  wire n1252;
  wire n1253;
  wire n1254;
  wire n1255;
  wire n1256;
  wire n1257;
  wire n1258;
  wire n1259;
  wire n1260;
  wire n1261;
  wire n1262;
  wire n1263;
  wire n1264;
  wire n1265;
  wire n1266;
  wire n1267;
  wire n1268;
  wire n1269;
  wire n1270;
  wire n1271;
  wire n1272;
  wire n1273;
  wire n1274;
  wire n1275;
  wire n1276;
  wire n1277;
  wire n1278;
  wire n1279;
  wire n1280;
  wire n1281;
  wire n1282;
  wire n1283;
  wire [15:0] n1284;
  wire n1285;
  wire [23:0] n1286;
  wire n1287;
  wire n1288;
  wire n1289;
  wire n1290;
  wire n1291;
  wire n1292;
  wire n1293;
  wire n1294;
  wire n1295;
  wire n1296;
  wire n1297;
  wire n1298;
  wire n1299;
  wire n1300;
  wire n1301;
  wire n1302;
  wire n1303;
  wire n1304;
  wire n1305;
  wire n1306;
  wire n1307;
  wire n1308;
  wire n1309;
  wire n1310;
  wire n1311;
  wire n1312;
  wire n1313;
  wire n1314;
  wire n1315;
  wire n1316;
  wire n1317;
  wire n1318;
  wire n1319;
  wire n1320;
  wire n1321;
  wire n1322;
  wire n1323;
  wire n1324;
  wire n1325;
  wire n1326;
  wire n1327;
  wire n1328;
  wire n1329;
  wire n1330;
  wire n1331;
  wire n1332;
  wire n1333;
  wire n1334;
  wire n1335;
  wire n1336;
  wire n1337;
  wire n1338;
  wire n1339;
  wire n1340;
  wire n1341;
  wire n1342;
  wire n1343;
  wire n1344;
  wire n1345;
  wire n1346;
  wire n1347;
  wire n1348;
  wire n1349;
  wire n1350;
  wire n1351;
  wire n1352;
  wire n1353;
  wire n1354;
  wire [15:0] n1355;
  wire n1356;
  wire [23:0] n1357;
  wire n1358;
  wire [23:0] n1359;
  wire n1360;
  wire n1361;
  wire n1362;
  wire n1363;
  wire n1364;
  wire n1365;
  wire n1366;
  wire n1367;
  wire n1368;
  wire n1369;
  wire n1370;
  wire n1371;
  wire n1372;
  wire n1373;
  wire n1374;
  wire n1375;
  wire n1376;
  wire n1377;
  wire n1378;
  wire n1379;
  wire n1380;
  wire n1381;
  wire n1382;
  wire n1383;
  wire n1384;
  wire n1385;
  wire n1386;
  wire n1387;
  wire n1388;
  wire n1389;
  wire n1390;
  wire n1391;
  wire n1392;
  wire n1393;
  wire n1394;
  wire n1395;
  wire [127:0] n1396;
  wire [127:0] n1397;
  wire [127:0] n1398;
  wire [127:0] n1399;
  wire [127:0] n1400;
  wire [127:0] n1401;
  wire [127:0] n1402;
  wire [127:0] n1403;
  wire [127:0] n1404;
  wire [127:0] n1405;
  wire [127:0] n1406;
  wire [127:0] n1407;
  wire [127:0] n1408;
  wire [127:0] n1409;
  wire [127:0] n1410;
  wire [127:0] n1411;
  wire [127:0] n1412;
  wire [127:0] n1413;
  wire [127:0] n1414;
  wire [127:0] n1415;
  wire [127:0] n1416;
  wire [127:0] n1417;
  wire [127:0] n1418;
  wire [127:0] n1419;
  wire [127:0] n1420;
  wire [127:0] n1421;
  wire [127:0] n1422;
  wire [127:0] n1423;
  wire [127:0] n1424;
  wire [127:0] n1425;
  wire [127:0] n1426;
  wire [127:0] n1427;
  wire [2047:0] n1428;
  wire n1429;
  wire n1430;
  wire n1431;
  wire n1432;
  wire n1433;
  wire n1434;
  wire n1435;
  wire n1436;
  wire n1437;
  wire n1438;
  wire n1439;
  wire n1440;
  wire n1441;
  wire n1442;
  wire n1443;
  wire n1444;
  wire n1445;
  wire n1446;
  wire n1447;
  wire n1448;
  wire n1449;
  wire n1450;
  wire n1451;
  wire n1452;
  wire n1453;
  wire n1454;
  wire n1455;
  wire n1456;
  wire n1457;
  wire n1458;
  wire n1459;
  wire n1460;
  wire n1461;
  wire n1462;
  wire n1463;
  wire n1464;
  wire n1465;
  wire n1466;
  wire n1467;
  wire n1468;
  wire n1469;
  wire n1470;
  wire n1471;
  wire n1472;
  wire n1473;
  wire n1474;
  wire n1475;
  wire n1476;
  wire n1477;
  wire n1478;
  wire n1479;
  wire n1480;
  wire n1481;
  wire n1482;
  wire n1483;
  wire n1484;
  wire n1485;
  wire n1486;
  wire n1487;
  wire n1488;
  wire n1489;
  wire n1490;
  wire n1491;
  wire n1492;
  wire n1493;
  wire n1494;
  wire n1495;
  wire n1496;
  wire [15:0] n1497;
  wire n1498;
  wire [23:0] n1499;
  wire n1500;
  wire n1501;
  wire n1502;
  wire n1503;
  wire n1504;
  wire n1505;
  wire n1506;
  wire n1507;
  wire n1508;
  wire n1509;
  wire n1510;
  wire n1511;
  wire n1512;
  wire n1513;
  wire n1514;
  wire n1515;
  wire n1516;
  wire n1517;
  wire n1518;
  wire n1519;
  wire n1520;
  wire n1521;
  wire n1522;
  wire n1523;
  wire n1524;
  wire n1525;
  wire n1526;
  wire n1527;
  wire n1528;
  wire n1529;
  wire n1530;
  wire n1531;
  wire n1532;
  wire n1533;
  wire n1534;
  wire n1535;
  wire n1536;
  wire n1537;
  wire n1538;
  wire n1539;
  wire n1540;
  wire n1541;
  wire n1542;
  wire n1543;
  wire n1544;
  wire n1545;
  wire n1546;
  wire n1547;
  wire n1548;
  wire n1549;
  wire n1550;
  wire n1551;
  wire n1552;
  wire n1553;
  wire n1554;
  wire n1555;
  wire n1556;
  wire n1557;
  wire n1558;
  wire n1559;
  wire n1560;
  wire n1561;
  wire n1562;
  wire n1563;
  wire n1564;
  wire n1565;
  wire n1566;
  wire n1567;
  wire [15:0] n1568;
  wire n1569;
  wire [23:0] n1570;
  wire n1571;
  wire n1572;
  wire n1573;
  wire n1574;
  wire n1575;
  wire n1576;
  wire n1577;
  wire n1578;
  wire n1579;
  wire n1580;
  wire n1581;
  wire n1582;
  wire n1583;
  wire n1584;
  wire n1585;
  wire n1586;
  wire n1587;
  wire n1588;
  wire n1589;
  wire n1590;
  wire n1591;
  wire n1592;
  wire n1593;
  wire n1594;
  wire n1595;
  wire n1596;
  wire n1597;
  wire n1598;
  wire n1599;
  wire n1600;
  wire n1601;
  wire n1602;
  wire n1603;
  wire n1604;
  wire n1605;
  wire n1606;
  wire [7:0] n1607;
  wire [7:0] n1608;
  wire [119:0] n1609;
  wire [7:0] n1610;
  wire [7:0] n1611;
  wire [119:0] n1612;
  wire [7:0] n1613;
  wire [7:0] n1614;
  wire [119:0] n1615;
  wire [7:0] n1616;
  wire [7:0] n1617;
  wire [119:0] n1618;
  wire [7:0] n1619;
  wire [7:0] n1620;
  wire [119:0] n1621;
  wire [7:0] n1622;
  wire [7:0] n1623;
  wire [119:0] n1624;
  wire [7:0] n1625;
  wire [7:0] n1626;
  wire [119:0] n1627;
  wire [7:0] n1628;
  wire [7:0] n1629;
  wire [119:0] n1630;
  wire [7:0] n1631;
  wire [7:0] n1632;
  wire [119:0] n1633;
  wire [7:0] n1634;
  wire [7:0] n1635;
  wire [119:0] n1636;
  wire [7:0] n1637;
  wire [7:0] n1638;
  wire [119:0] n1639;
  wire [7:0] n1640;
  wire [7:0] n1641;
  wire [119:0] n1642;
  wire [7:0] n1643;
  wire [7:0] n1644;
  wire [119:0] n1645;
  wire [7:0] n1646;
  wire [7:0] n1647;
  wire [119:0] n1648;
  wire [7:0] n1649;
  wire [7:0] n1650;
  wire [119:0] n1651;
  wire [7:0] n1652;
  wire [7:0] n1653;
  wire [119:0] n1654;
  wire [2047:0] n1655;
  wire n1656;
  wire n1657;
  wire n1658;
  wire n1659;
  wire n1660;
  wire n1661;
  wire n1662;
  wire n1663;
  wire n1664;
  wire n1665;
  wire n1666;
  wire n1667;
  wire n1668;
  wire n1669;
  wire n1670;
  wire n1671;
  wire n1672;
  wire n1673;
  wire n1674;
  wire n1675;
  wire n1676;
  wire n1677;
  wire n1678;
  wire n1679;
  wire n1680;
  wire n1681;
  wire n1682;
  wire n1683;
  wire n1684;
  wire n1685;
  wire n1686;
  wire n1687;
  wire n1688;
  wire n1689;
  wire n1690;
  wire n1691;
  wire [7:0] n1692;
  wire [7:0] n1693;
  wire [7:0] n1694;
  wire [119:0] n1695;
  wire [7:0] n1696;
  wire [7:0] n1697;
  wire [119:0] n1698;
  wire [7:0] n1699;
  wire [7:0] n1700;
  wire [119:0] n1701;
  wire [7:0] n1702;
  wire [7:0] n1703;
  wire [119:0] n1704;
  wire [7:0] n1705;
  wire [7:0] n1706;
  wire [119:0] n1707;
  wire [7:0] n1708;
  wire [7:0] n1709;
  wire [119:0] n1710;
  wire [7:0] n1711;
  wire [7:0] n1712;
  wire [119:0] n1713;
  wire [7:0] n1714;
  wire [7:0] n1715;
  wire [119:0] n1716;
  wire [7:0] n1717;
  wire [7:0] n1718;
  wire [119:0] n1719;
  wire [7:0] n1720;
  wire [7:0] n1721;
  wire [119:0] n1722;
  wire [7:0] n1723;
  wire [7:0] n1724;
  wire [119:0] n1725;
  wire [7:0] n1726;
  wire [7:0] n1727;
  wire [119:0] n1728;
  wire [7:0] n1729;
  wire [7:0] n1730;
  wire [119:0] n1731;
  wire [7:0] n1732;
  wire [7:0] n1733;
  wire [119:0] n1734;
  wire [7:0] n1735;
  wire [7:0] n1736;
  wire [119:0] n1737;
  wire [7:0] n1738;
  wire [7:0] n1739;
  wire [111:0] n1740;
  wire [2047:0] n1741;
  wire n1742;
  wire n1743;
  wire n1744;
  wire n1745;
  wire n1746;
  wire n1747;
  wire n1748;
  wire n1749;
  wire n1750;
  wire n1751;
  wire n1752;
  wire n1753;
  wire n1754;
  wire n1755;
  wire n1756;
  wire n1757;
  wire n1758;
  wire n1759;
  wire n1760;
  wire n1761;
  wire n1762;
  wire n1763;
  wire n1764;
  wire n1765;
  wire n1766;
  wire n1767;
  wire n1768;
  wire n1769;
  wire n1770;
  wire n1771;
  wire n1772;
  wire n1773;
  wire n1774;
  wire n1775;
  wire n1776;
  wire n1777;
  wire [15:0] n1778;
  wire [7:0] n1779;
  wire [7:0] n1780;
  wire [119:0] n1781;
  wire [7:0] n1782;
  wire [7:0] n1783;
  wire [119:0] n1784;
  wire [7:0] n1785;
  wire [7:0] n1786;
  wire [119:0] n1787;
  wire [7:0] n1788;
  wire [7:0] n1789;
  wire [119:0] n1790;
  wire [7:0] n1791;
  wire [7:0] n1792;
  wire [119:0] n1793;
  wire [7:0] n1794;
  wire [7:0] n1795;
  wire [119:0] n1796;
  wire [7:0] n1797;
  wire [7:0] n1798;
  wire [119:0] n1799;
  wire [7:0] n1800;
  wire [7:0] n1801;
  wire [119:0] n1802;
  wire [7:0] n1803;
  wire [7:0] n1804;
  wire [119:0] n1805;
  wire [7:0] n1806;
  wire [7:0] n1807;
  wire [119:0] n1808;
  wire [7:0] n1809;
  wire [7:0] n1810;
  wire [119:0] n1811;
  wire [7:0] n1812;
  wire [7:0] n1813;
  wire [119:0] n1814;
  wire [7:0] n1815;
  wire [7:0] n1816;
  wire [119:0] n1817;
  wire [7:0] n1818;
  wire [7:0] n1819;
  wire [119:0] n1820;
  wire [7:0] n1821;
  wire [7:0] n1822;
  wire [119:0] n1823;
  wire [7:0] n1824;
  wire [7:0] n1825;
  wire [103:0] n1826;
  wire [2047:0] n1827;
  wire n1828;
  wire n1829;
  wire n1830;
  wire n1831;
  wire n1832;
  wire n1833;
  wire n1834;
  wire n1835;
  wire n1836;
  wire n1837;
  wire n1838;
  wire n1839;
  wire n1840;
  wire n1841;
  wire n1842;
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
  wire n1857;
  wire n1858;
  wire n1859;
  wire n1860;
  wire n1861;
  wire n1862;
  wire n1863;
  wire [23:0] n1864;
  wire [7:0] n1865;
  wire [7:0] n1866;
  wire [119:0] n1867;
  wire [7:0] n1868;
  wire [7:0] n1869;
  wire [119:0] n1870;
  wire [7:0] n1871;
  wire [7:0] n1872;
  wire [119:0] n1873;
  wire [7:0] n1874;
  wire [7:0] n1875;
  wire [119:0] n1876;
  wire [7:0] n1877;
  wire [7:0] n1878;
  wire [119:0] n1879;
  wire [7:0] n1880;
  wire [7:0] n1881;
  wire [119:0] n1882;
  wire [7:0] n1883;
  wire [7:0] n1884;
  wire [119:0] n1885;
  wire [7:0] n1886;
  wire [7:0] n1887;
  wire [119:0] n1888;
  wire [7:0] n1889;
  wire [7:0] n1890;
  wire [119:0] n1891;
  wire [7:0] n1892;
  wire [7:0] n1893;
  wire [119:0] n1894;
  wire [7:0] n1895;
  wire [7:0] n1896;
  wire [119:0] n1897;
  wire [7:0] n1898;
  wire [7:0] n1899;
  wire [119:0] n1900;
  wire [7:0] n1901;
  wire [7:0] n1902;
  wire [119:0] n1903;
  wire [7:0] n1904;
  wire [7:0] n1905;
  wire [119:0] n1906;
  wire [7:0] n1907;
  wire [7:0] n1908;
  wire [119:0] n1909;
  wire [7:0] n1910;
  wire [7:0] n1911;
  wire [95:0] n1912;
  wire [2047:0] n1913;
  wire n1914;
  wire n1915;
  wire n1916;
  wire n1917;
  wire n1918;
  wire n1919;
  wire n1920;
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
  wire n1943;
  wire n1944;
  wire n1945;
  wire n1946;
  wire n1947;
  wire n1948;
  wire n1949;
  wire [31:0] n1950;
  wire [7:0] n1951;
  wire [7:0] n1952;
  wire [119:0] n1953;
  wire [7:0] n1954;
  wire [7:0] n1955;
  wire [119:0] n1956;
  wire [7:0] n1957;
  wire [7:0] n1958;
  wire [119:0] n1959;
  wire [7:0] n1960;
  wire [7:0] n1961;
  wire [119:0] n1962;
  wire [7:0] n1963;
  wire [7:0] n1964;
  wire [119:0] n1965;
  wire [7:0] n1966;
  wire [7:0] n1967;
  wire [119:0] n1968;
  wire [7:0] n1969;
  wire [7:0] n1970;
  wire [119:0] n1971;
  wire [7:0] n1972;
  wire [7:0] n1973;
  wire [119:0] n1974;
  wire [7:0] n1975;
  wire [7:0] n1976;
  wire [119:0] n1977;
  wire [7:0] n1978;
  wire [7:0] n1979;
  wire [119:0] n1980;
  wire [7:0] n1981;
  wire [7:0] n1982;
  wire [119:0] n1983;
  wire [7:0] n1984;
  wire [7:0] n1985;
  wire [119:0] n1986;
  wire [7:0] n1987;
  wire [7:0] n1988;
  wire [119:0] n1989;
  wire [7:0] n1990;
  wire [7:0] n1991;
  wire [119:0] n1992;
  wire [7:0] n1993;
  wire [7:0] n1994;
  wire [119:0] n1995;
  wire [7:0] n1996;
  wire [7:0] n1997;
  wire [87:0] n1998;
  wire [2047:0] n1999;
  wire n2000;
  wire n2001;
  wire n2002;
  wire n2003;
  wire n2004;
  wire n2005;
  wire n2006;
  wire n2007;
  wire n2008;
  wire n2009;
  wire n2010;
  wire n2011;
  wire n2012;
  wire n2013;
  wire n2014;
  wire n2015;
  wire n2016;
  wire n2017;
  wire n2018;
  wire n2019;
  wire n2020;
  wire n2021;
  wire n2022;
  wire n2023;
  wire n2024;
  wire n2025;
  wire n2026;
  wire n2027;
  wire n2028;
  wire n2029;
  wire n2030;
  wire n2031;
  wire n2032;
  wire n2033;
  wire n2034;
  wire n2035;
  wire [39:0] n2036;
  wire [7:0] n2037;
  wire [7:0] n2038;
  wire [119:0] n2039;
  wire [7:0] n2040;
  wire [7:0] n2041;
  wire [119:0] n2042;
  wire [7:0] n2043;
  wire [7:0] n2044;
  wire [119:0] n2045;
  wire [7:0] n2046;
  wire [7:0] n2047;
  wire [119:0] n2048;
  wire [7:0] n2049;
  wire [7:0] n2050;
  wire [119:0] n2051;
  wire [7:0] n2052;
  wire [7:0] n2053;
  wire [119:0] n2054;
  wire [7:0] n2055;
  wire [7:0] n2056;
  wire [119:0] n2057;
  wire [7:0] n2058;
  wire [7:0] n2059;
  wire [119:0] n2060;
  wire [7:0] n2061;
  wire [7:0] n2062;
  wire [119:0] n2063;
  wire [7:0] n2064;
  wire [7:0] n2065;
  wire [119:0] n2066;
  wire [7:0] n2067;
  wire [7:0] n2068;
  wire [119:0] n2069;
  wire [7:0] n2070;
  wire [7:0] n2071;
  wire [119:0] n2072;
  wire [7:0] n2073;
  wire [7:0] n2074;
  wire [119:0] n2075;
  wire [7:0] n2076;
  wire [7:0] n2077;
  wire [119:0] n2078;
  wire [7:0] n2079;
  wire [7:0] n2080;
  wire [119:0] n2081;
  wire [7:0] n2082;
  wire [7:0] n2083;
  wire [79:0] n2084;
  wire [2047:0] n2085;
  wire n2086;
  wire n2087;
  wire n2088;
  wire n2089;
  wire n2090;
  wire n2091;
  wire n2092;
  wire n2093;
  wire n2094;
  wire n2095;
  wire n2096;
  wire n2097;
  wire n2098;
  wire n2099;
  wire n2100;
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
  wire [47:0] n2122;
  wire [7:0] n2123;
  wire [7:0] n2124;
  wire [119:0] n2125;
  wire [7:0] n2126;
  wire [7:0] n2127;
  wire [119:0] n2128;
  wire [7:0] n2129;
  wire [7:0] n2130;
  wire [119:0] n2131;
  wire [7:0] n2132;
  wire [7:0] n2133;
  wire [119:0] n2134;
  wire [7:0] n2135;
  wire [7:0] n2136;
  wire [119:0] n2137;
  wire [7:0] n2138;
  wire [7:0] n2139;
  wire [119:0] n2140;
  wire [7:0] n2141;
  wire [7:0] n2142;
  wire [119:0] n2143;
  wire [7:0] n2144;
  wire [7:0] n2145;
  wire [119:0] n2146;
  wire [7:0] n2147;
  wire [7:0] n2148;
  wire [119:0] n2149;
  wire [7:0] n2150;
  wire [7:0] n2151;
  wire [119:0] n2152;
  wire [7:0] n2153;
  wire [7:0] n2154;
  wire [119:0] n2155;
  wire [7:0] n2156;
  wire [7:0] n2157;
  wire [119:0] n2158;
  wire [7:0] n2159;
  wire [7:0] n2160;
  wire [119:0] n2161;
  wire [7:0] n2162;
  wire [7:0] n2163;
  wire [119:0] n2164;
  wire [7:0] n2165;
  wire [7:0] n2166;
  wire [119:0] n2167;
  wire [7:0] n2168;
  wire [7:0] n2169;
  wire [71:0] n2170;
  wire [2047:0] n2171;
  wire n2172;
  wire n2173;
  wire n2174;
  wire n2175;
  wire n2176;
  wire n2177;
  wire n2178;
  wire n2179;
  wire n2180;
  wire n2181;
  wire n2182;
  wire n2183;
  wire n2184;
  wire n2185;
  wire n2186;
  wire n2187;
  wire n2188;
  wire n2189;
  wire n2190;
  wire n2191;
  wire n2192;
  wire n2193;
  wire n2194;
  wire n2195;
  wire n2196;
  wire n2197;
  wire n2198;
  wire n2199;
  wire n2200;
  wire n2201;
  wire n2202;
  wire n2203;
  wire n2204;
  wire n2205;
  wire n2206;
  wire n2207;
  wire [55:0] n2208;
  wire [7:0] n2209;
  wire [7:0] n2210;
  wire [119:0] n2211;
  wire [7:0] n2212;
  wire [7:0] n2213;
  wire [119:0] n2214;
  wire [7:0] n2215;
  wire [7:0] n2216;
  wire [119:0] n2217;
  wire [7:0] n2218;
  wire [7:0] n2219;
  wire [119:0] n2220;
  wire [7:0] n2221;
  wire [7:0] n2222;
  wire [119:0] n2223;
  wire [7:0] n2224;
  wire [7:0] n2225;
  wire [119:0] n2226;
  wire [7:0] n2227;
  wire [7:0] n2228;
  wire [119:0] n2229;
  wire [7:0] n2230;
  wire [7:0] n2231;
  wire [119:0] n2232;
  wire [7:0] n2233;
  wire [7:0] n2234;
  wire [119:0] n2235;
  wire [7:0] n2236;
  wire [7:0] n2237;
  wire [119:0] n2238;
  wire [7:0] n2239;
  wire [7:0] n2240;
  wire [119:0] n2241;
  wire [7:0] n2242;
  wire [7:0] n2243;
  wire [119:0] n2244;
  wire [7:0] n2245;
  wire [7:0] n2246;
  wire [119:0] n2247;
  wire [7:0] n2248;
  wire [7:0] n2249;
  wire [119:0] n2250;
  wire [7:0] n2251;
  wire [7:0] n2252;
  wire [119:0] n2253;
  wire [7:0] n2254;
  wire [7:0] n2255;
  wire [63:0] n2256;
  wire [2047:0] n2257;
  wire n2258;
  wire n2259;
  wire n2260;
  wire n2261;
  wire n2262;
  wire n2263;
  wire n2264;
  wire n2265;
  wire n2266;
  wire n2267;
  wire n2268;
  wire n2269;
  wire n2270;
  wire n2271;
  wire n2272;
  wire n2273;
  wire n2274;
  wire n2275;
  wire n2276;
  wire n2277;
  wire n2278;
  wire n2279;
  wire n2280;
  wire n2281;
  wire n2282;
  wire n2283;
  wire n2284;
  wire n2285;
  wire n2286;
  wire n2287;
  wire n2288;
  wire n2289;
  wire n2290;
  wire n2291;
  wire n2292;
  wire n2293;
  wire [63:0] n2294;
  wire [7:0] n2295;
  wire [7:0] n2296;
  wire [119:0] n2297;
  wire [7:0] n2298;
  wire [7:0] n2299;
  wire [119:0] n2300;
  wire [7:0] n2301;
  wire [7:0] n2302;
  wire [119:0] n2303;
  wire [7:0] n2304;
  wire [7:0] n2305;
  wire [119:0] n2306;
  wire [7:0] n2307;
  wire [7:0] n2308;
  wire [119:0] n2309;
  wire [7:0] n2310;
  wire [7:0] n2311;
  wire [119:0] n2312;
  wire [7:0] n2313;
  wire [7:0] n2314;
  wire [119:0] n2315;
  wire [7:0] n2316;
  wire [7:0] n2317;
  wire [119:0] n2318;
  wire [7:0] n2319;
  wire [7:0] n2320;
  wire [119:0] n2321;
  wire [7:0] n2322;
  wire [7:0] n2323;
  wire [119:0] n2324;
  wire [7:0] n2325;
  wire [7:0] n2326;
  wire [119:0] n2327;
  wire [7:0] n2328;
  wire [7:0] n2329;
  wire [119:0] n2330;
  wire [7:0] n2331;
  wire [7:0] n2332;
  wire [119:0] n2333;
  wire [7:0] n2334;
  wire [7:0] n2335;
  wire [119:0] n2336;
  wire [7:0] n2337;
  wire [7:0] n2338;
  wire [119:0] n2339;
  wire [7:0] n2340;
  wire [7:0] n2341;
  wire [55:0] n2342;
  wire [2047:0] n2343;
  wire n2344;
  wire n2345;
  wire n2346;
  wire n2347;
  wire n2348;
  wire n2349;
  wire n2350;
  wire n2351;
  wire n2352;
  wire n2353;
  wire n2354;
  wire n2355;
  wire n2356;
  wire n2357;
  wire n2358;
  wire n2359;
  wire n2360;
  wire n2361;
  wire n2362;
  wire n2363;
  wire n2364;
  wire n2365;
  wire n2366;
  wire n2367;
  wire n2368;
  wire n2369;
  wire n2370;
  wire n2371;
  wire n2372;
  wire n2373;
  wire n2374;
  wire n2375;
  wire n2376;
  wire n2377;
  wire n2378;
  wire n2379;
  wire [71:0] n2380;
  wire [7:0] n2381;
  wire [7:0] n2382;
  wire [119:0] n2383;
  wire [7:0] n2384;
  wire [7:0] n2385;
  wire [119:0] n2386;
  wire [7:0] n2387;
  wire [7:0] n2388;
  wire [119:0] n2389;
  wire [7:0] n2390;
  wire [7:0] n2391;
  wire [119:0] n2392;
  wire [7:0] n2393;
  wire [7:0] n2394;
  wire [119:0] n2395;
  wire [7:0] n2396;
  wire [7:0] n2397;
  wire [119:0] n2398;
  wire [7:0] n2399;
  wire [7:0] n2400;
  wire [119:0] n2401;
  wire [7:0] n2402;
  wire [7:0] n2403;
  wire [119:0] n2404;
  wire [7:0] n2405;
  wire [7:0] n2406;
  wire [119:0] n2407;
  wire [7:0] n2408;
  wire [7:0] n2409;
  wire [119:0] n2410;
  wire [7:0] n2411;
  wire [7:0] n2412;
  wire [119:0] n2413;
  wire [7:0] n2414;
  wire [7:0] n2415;
  wire [119:0] n2416;
  wire [7:0] n2417;
  wire [7:0] n2418;
  wire [119:0] n2419;
  wire [7:0] n2420;
  wire [7:0] n2421;
  wire [119:0] n2422;
  wire [7:0] n2423;
  wire [7:0] n2424;
  wire [119:0] n2425;
  wire [7:0] n2426;
  wire [7:0] n2427;
  wire [47:0] n2428;
  wire [2047:0] n2429;
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
  wire [79:0] n2466;
  wire [7:0] n2467;
  wire [7:0] n2468;
  wire [119:0] n2469;
  wire [7:0] n2470;
  wire [7:0] n2471;
  wire [119:0] n2472;
  wire [7:0] n2473;
  wire [7:0] n2474;
  wire [119:0] n2475;
  wire [7:0] n2476;
  wire [7:0] n2477;
  wire [119:0] n2478;
  wire [7:0] n2479;
  wire [7:0] n2480;
  wire [119:0] n2481;
  wire [7:0] n2482;
  wire [7:0] n2483;
  wire [119:0] n2484;
  wire [7:0] n2485;
  wire [7:0] n2486;
  wire [119:0] n2487;
  wire [7:0] n2488;
  wire [7:0] n2489;
  wire [119:0] n2490;
  wire [7:0] n2491;
  wire [7:0] n2492;
  wire [119:0] n2493;
  wire [7:0] n2494;
  wire [7:0] n2495;
  wire [119:0] n2496;
  wire [7:0] n2497;
  wire [7:0] n2498;
  wire [119:0] n2499;
  wire [7:0] n2500;
  wire [7:0] n2501;
  wire [119:0] n2502;
  wire [7:0] n2503;
  wire [7:0] n2504;
  wire [119:0] n2505;
  wire [7:0] n2506;
  wire [7:0] n2507;
  wire [119:0] n2508;
  wire [7:0] n2509;
  wire [7:0] n2510;
  wire [119:0] n2511;
  wire [7:0] n2512;
  wire [7:0] n2513;
  wire [39:0] n2514;
  wire [2047:0] n2515;
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
  wire [87:0] n2552;
  wire [7:0] n2553;
  wire [7:0] n2554;
  wire [119:0] n2555;
  wire [7:0] n2556;
  wire [7:0] n2557;
  wire [119:0] n2558;
  wire [7:0] n2559;
  wire [7:0] n2560;
  wire [119:0] n2561;
  wire [7:0] n2562;
  wire [7:0] n2563;
  wire [119:0] n2564;
  wire [7:0] n2565;
  wire [7:0] n2566;
  wire [119:0] n2567;
  wire [7:0] n2568;
  wire [7:0] n2569;
  wire [119:0] n2570;
  wire [7:0] n2571;
  wire [7:0] n2572;
  wire [119:0] n2573;
  wire [7:0] n2574;
  wire [7:0] n2575;
  wire [119:0] n2576;
  wire [7:0] n2577;
  wire [7:0] n2578;
  wire [119:0] n2579;
  wire [7:0] n2580;
  wire [7:0] n2581;
  wire [119:0] n2582;
  wire [7:0] n2583;
  wire [7:0] n2584;
  wire [119:0] n2585;
  wire [7:0] n2586;
  wire [7:0] n2587;
  wire [119:0] n2588;
  wire [7:0] n2589;
  wire [7:0] n2590;
  wire [119:0] n2591;
  wire [7:0] n2592;
  wire [7:0] n2593;
  wire [119:0] n2594;
  wire [7:0] n2595;
  wire [7:0] n2596;
  wire [119:0] n2597;
  wire [7:0] n2598;
  wire [7:0] n2599;
  wire [31:0] n2600;
  wire [2047:0] n2601;
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
  wire [95:0] n2638;
  wire [7:0] n2639;
  wire [7:0] n2640;
  wire [119:0] n2641;
  wire [7:0] n2642;
  wire [7:0] n2643;
  wire [119:0] n2644;
  wire [7:0] n2645;
  wire [7:0] n2646;
  wire [119:0] n2647;
  wire [7:0] n2648;
  wire [7:0] n2649;
  wire [119:0] n2650;
  wire [7:0] n2651;
  wire [7:0] n2652;
  wire [119:0] n2653;
  wire [7:0] n2654;
  wire [7:0] n2655;
  wire [119:0] n2656;
  wire [7:0] n2657;
  wire [7:0] n2658;
  wire [119:0] n2659;
  wire [7:0] n2660;
  wire [7:0] n2661;
  wire [119:0] n2662;
  wire [7:0] n2663;
  wire [7:0] n2664;
  wire [119:0] n2665;
  wire [7:0] n2666;
  wire [7:0] n2667;
  wire [119:0] n2668;
  wire [7:0] n2669;
  wire [7:0] n2670;
  wire [119:0] n2671;
  wire [7:0] n2672;
  wire [7:0] n2673;
  wire [119:0] n2674;
  wire [7:0] n2675;
  wire [7:0] n2676;
  wire [119:0] n2677;
  wire [7:0] n2678;
  wire [7:0] n2679;
  wire [119:0] n2680;
  wire [7:0] n2681;
  wire [7:0] n2682;
  wire [119:0] n2683;
  wire [7:0] n2684;
  wire [7:0] n2685;
  wire [23:0] n2686;
  wire [2047:0] n2687;
  wire n2688;
  wire n2689;
  wire n2690;
  wire n2691;
  wire n2692;
  wire n2693;
  wire n2694;
  wire n2695;
  wire n2696;
  wire n2697;
  wire n2698;
  wire n2699;
  wire n2700;
  wire n2701;
  wire n2702;
  wire n2703;
  wire n2704;
  wire n2705;
  wire n2706;
  wire n2707;
  wire n2708;
  wire n2709;
  wire n2710;
  wire n2711;
  wire n2712;
  wire n2713;
  wire n2714;
  wire n2715;
  wire n2716;
  wire n2717;
  wire n2718;
  wire n2719;
  wire n2720;
  wire n2721;
  wire n2722;
  wire n2723;
  wire [103:0] n2724;
  wire [7:0] n2725;
  wire [7:0] n2726;
  wire [119:0] n2727;
  wire [7:0] n2728;
  wire [7:0] n2729;
  wire [119:0] n2730;
  wire [7:0] n2731;
  wire [7:0] n2732;
  wire [119:0] n2733;
  wire [7:0] n2734;
  wire [7:0] n2735;
  wire [119:0] n2736;
  wire [7:0] n2737;
  wire [7:0] n2738;
  wire [119:0] n2739;
  wire [7:0] n2740;
  wire [7:0] n2741;
  wire [119:0] n2742;
  wire [7:0] n2743;
  wire [7:0] n2744;
  wire [119:0] n2745;
  wire [7:0] n2746;
  wire [7:0] n2747;
  wire [119:0] n2748;
  wire [7:0] n2749;
  wire [7:0] n2750;
  wire [119:0] n2751;
  wire [7:0] n2752;
  wire [7:0] n2753;
  wire [119:0] n2754;
  wire [7:0] n2755;
  wire [7:0] n2756;
  wire [119:0] n2757;
  wire [7:0] n2758;
  wire [7:0] n2759;
  wire [119:0] n2760;
  wire [7:0] n2761;
  wire [7:0] n2762;
  wire [119:0] n2763;
  wire [7:0] n2764;
  wire [7:0] n2765;
  wire [119:0] n2766;
  wire [7:0] n2767;
  wire [7:0] n2768;
  wire [119:0] n2769;
  wire [7:0] n2770;
  wire [7:0] n2771;
  wire [15:0] n2772;
  wire [2047:0] n2773;
  wire n2774;
  wire n2775;
  wire n2776;
  wire n2777;
  wire n2778;
  wire n2779;
  wire n2780;
  wire n2781;
  wire n2782;
  wire n2783;
  wire n2784;
  wire n2785;
  wire n2786;
  wire n2787;
  wire n2788;
  wire n2789;
  wire n2790;
  wire n2791;
  wire n2792;
  wire n2793;
  wire n2794;
  wire n2795;
  wire n2796;
  wire n2797;
  wire n2798;
  wire n2799;
  wire n2800;
  wire n2801;
  wire n2802;
  wire n2803;
  wire n2804;
  wire n2805;
  wire n2806;
  wire n2807;
  wire n2808;
  wire n2809;
  wire [111:0] n2810;
  wire [7:0] n2811;
  wire [7:0] n2812;
  wire [119:0] n2813;
  wire [7:0] n2814;
  wire [7:0] n2815;
  wire [119:0] n2816;
  wire [7:0] n2817;
  wire [7:0] n2818;
  wire [119:0] n2819;
  wire [7:0] n2820;
  wire [7:0] n2821;
  wire [119:0] n2822;
  wire [7:0] n2823;
  wire [7:0] n2824;
  wire [119:0] n2825;
  wire [7:0] n2826;
  wire [7:0] n2827;
  wire [119:0] n2828;
  wire [7:0] n2829;
  wire [7:0] n2830;
  wire [119:0] n2831;
  wire [7:0] n2832;
  wire [7:0] n2833;
  wire [119:0] n2834;
  wire [7:0] n2835;
  wire [7:0] n2836;
  wire [119:0] n2837;
  wire [7:0] n2838;
  wire [7:0] n2839;
  wire [119:0] n2840;
  wire [7:0] n2841;
  wire [7:0] n2842;
  wire [119:0] n2843;
  wire [7:0] n2844;
  wire [7:0] n2845;
  wire [119:0] n2846;
  wire [7:0] n2847;
  wire [7:0] n2848;
  wire [119:0] n2849;
  wire [7:0] n2850;
  wire [7:0] n2851;
  wire [119:0] n2852;
  wire [7:0] n2853;
  wire [7:0] n2854;
  wire [119:0] n2855;
  wire [7:0] n2856;
  wire [7:0] n2857;
  wire [7:0] n2858;
  wire [2047:0] n2859;
  wire n2860;
  wire n2861;
  wire n2862;
  wire n2863;
  wire n2864;
  wire n2865;
  wire n2866;
  wire n2867;
  wire n2868;
  wire n2869;
  wire n2870;
  wire n2871;
  wire n2872;
  wire n2873;
  wire n2874;
  wire n2875;
  wire n2876;
  wire n2877;
  wire n2878;
  wire n2879;
  wire n2880;
  wire n2881;
  wire n2882;
  wire n2883;
  wire n2884;
  wire n2885;
  wire n2886;
  wire n2887;
  wire n2888;
  wire n2889;
  wire n2890;
  wire n2891;
  wire n2892;
  wire n2893;
  wire n2894;
  wire n2895;
  wire [119:0] n2896;
  wire [7:0] n2897;
  wire [7:0] n2898;
  wire [119:0] n2899;
  wire [7:0] n2900;
  wire [7:0] n2901;
  wire [119:0] n2902;
  wire [7:0] n2903;
  wire [7:0] n2904;
  wire [119:0] n2905;
  wire [7:0] n2906;
  wire [7:0] n2907;
  wire [119:0] n2908;
  wire [7:0] n2909;
  wire [7:0] n2910;
  wire [119:0] n2911;
  wire [7:0] n2912;
  wire [7:0] n2913;
  wire [119:0] n2914;
  wire [7:0] n2915;
  wire [7:0] n2916;
  wire [119:0] n2917;
  wire [7:0] n2918;
  wire [7:0] n2919;
  wire [119:0] n2920;
  wire [7:0] n2921;
  wire [7:0] n2922;
  wire [119:0] n2923;
  wire [7:0] n2924;
  wire [7:0] n2925;
  wire [119:0] n2926;
  wire [7:0] n2927;
  wire [7:0] n2928;
  wire [119:0] n2929;
  wire [7:0] n2930;
  wire [7:0] n2931;
  wire [119:0] n2932;
  wire [7:0] n2933;
  wire [7:0] n2934;
  wire [119:0] n2935;
  wire [7:0] n2936;
  wire [7:0] n2937;
  wire [119:0] n2938;
  wire [7:0] n2939;
  wire [7:0] n2940;
  wire [119:0] n2941;
  wire [7:0] n2942;
  wire [7:0] n2943;
  wire [2047:0] n2944;
  wire n2945;
  wire [23:0] n2946;
  wire n2947;
  wire [23:0] n2948;
  wire n2949;
  wire [23:0] n2950;
  wire n2951;
  wire [23:0] n2952;
  wire [127:0] n2953;
  wire [31:0] n2954;
  wire [2015:0] n2955;
  wire [2047:0] n2957;
  wire [127:0] n2958;
  wire [31:0] n2959;
  wire [1983:0] n2960;
  wire [2047:0] n2962;
  wire [127:0] n2963;
  wire [31:0] n2964;
  wire [1951:0] n2965;
  wire [2047:0] n2967;
  wire [127:0] n2968;
  wire [31:0] n2969;
  wire n2970;
  wire n2971;
  wire n2972;
  wire n2973;
  wire n2974;
  wire n2975;
  wire n2976;
  wire n2977;
  wire n2978;
  wire n2979;
  wire n2980;
  wire n2981;
  wire n2982;
  wire n2983;
  wire n2984;
  wire n2985;
  wire n2986;
  wire n2987;
  wire n2988;
  wire n2989;
  wire n2990;
  wire n2991;
  wire n2992;
  wire n2993;
  wire n2994;
  wire n2995;
  wire n2996;
  wire n2997;
  wire n2998;
  wire n2999;
  wire n3000;
  wire n3001;
  wire n3002;
  wire n3003;
  wire n3004;
  wire n3005;
  wire [23:0] n3006;
  wire n3007;
  wire [23:0] n3008;
  wire [23:0] n3009;
  wire n3010;
  wire [23:0] n3011;
  wire [23:0] n3012;
  wire n3013;
  wire [23:0] n3014;
  wire [23:0] n3015;
  wire n3016;
  wire [23:0] n3017;
  wire [23:0] n3018;
  wire n3019;
  wire [23:0] n3020;
  wire [23:0] n3021;
  wire n3022;
  wire [23:0] n3023;
  wire [23:0] n3024;
  wire n3025;
  wire [23:0] n3026;
  wire [23:0] n3027;
  wire n3028;
  wire [23:0] n3029;
  wire [23:0] n3030;
  wire n3031;
  wire [23:0] n3032;
  wire [23:0] n3033;
  wire n3034;
  wire [23:0] n3035;
  wire [23:0] n3036;
  wire n3037;
  wire [23:0] n3038;
  wire [23:0] n3039;
  wire n3040;
  wire [23:0] n3041;
  wire [23:0] n3042;
  wire n3043;
  wire [23:0] n3044;
  wire [23:0] n3045;
  wire n3046;
  wire [23:0] n3047;
  wire [23:0] n3048;
  wire n3049;
  wire [23:0] n3050;
  wire [23:0] n3051;
  wire n3052;
  wire [23:0] n3053;
  wire [383:0] n3054;
  wire n3055;
  wire n3056;
  wire n3057;
  wire n3058;
  wire n3059;
  wire n3060;
  wire n3061;
  wire n3062;
  wire n3063;
  wire n3064;
  wire n3065;
  wire n3066;
  wire n3067;
  wire n3068;
  wire n3069;
  wire n3070;
  wire n3071;
  wire n3072;
  wire n3073;
  wire n3074;
  wire n3075;
  wire n3076;
  wire n3077;
  wire n3078;
  wire n3079;
  wire n3080;
  wire n3081;
  wire n3082;
  wire n3083;
  wire n3084;
  wire n3085;
  wire n3086;
  wire n3087;
  wire n3088;
  wire n3089;
  wire n3090;
  wire [23:0] n3091;
  wire n3092;
  wire [23:0] n3093;
  wire [23:0] n3094;
  wire n3095;
  wire [23:0] n3096;
  wire [23:0] n3097;
  wire n3098;
  wire [23:0] n3099;
  wire [23:0] n3100;
  wire n3101;
  wire [23:0] n3102;
  wire [23:0] n3103;
  wire n3104;
  wire [23:0] n3105;
  wire [23:0] n3106;
  wire n3107;
  wire [23:0] n3108;
  wire [23:0] n3109;
  wire n3110;
  wire [23:0] n3111;
  wire [23:0] n3112;
  wire n3113;
  wire [23:0] n3114;
  wire [23:0] n3115;
  wire n3116;
  wire [23:0] n3117;
  wire [23:0] n3118;
  wire n3119;
  wire [23:0] n3120;
  wire [23:0] n3121;
  wire n3122;
  wire [23:0] n3123;
  wire [23:0] n3124;
  wire n3125;
  wire [23:0] n3126;
  wire [23:0] n3127;
  wire n3128;
  wire [23:0] n3129;
  wire [23:0] n3130;
  wire n3131;
  wire [23:0] n3132;
  wire [23:0] n3133;
  wire n3134;
  wire [23:0] n3135;
  wire [23:0] n3136;
  wire n3137;
  wire [23:0] n3138;
  wire [383:0] n3139;
  assign i_data = n402; //(module output)
  assign i_hit = n374; //(module output)
  assign i_fill_req = i_fill_req_int; //(module output)
  assign i_fill_addr = n1201; //(module output)
  assign d_data_out = n1164; //(module output)
  assign d_hit = n1136; //(module output)
  assign d_fill_req = d_fill_req_int; //(module output)
  assign d_fill_addr = n1203; //(module output)
  /* TG68K_Cache_030.vhd:73:10  */
  assign i_tag_array = n1172; // (signal)
  /* TG68K_Cache_030.vhd:74:10  */
  assign i_valid_array = n1173; // (signal)
  /* TG68K_Cache_030.vhd:81:10  */
  assign d_data_array = n1176; // (signal)
  /* TG68K_Cache_030.vhd:82:10  */
  assign d_tag_array = n1180; // (signal)
  /* TG68K_Cache_030.vhd:83:10  */
  assign d_valid_array = n1181; // (signal)
  /* TG68K_Cache_030.vhd:86:10  */
  assign i_line_idx = n14; // (signal)
  /* TG68K_Cache_030.vhd:87:10  */
  assign i_tag = n16; // (signal)
  /* TG68K_Cache_030.vhd:88:10  */
  assign i_offset = n22; // (signal)
  /* TG68K_Cache_030.vhd:90:10  */
  assign d_line_idx = n23; // (signal)
  /* TG68K_Cache_030.vhd:91:10  */
  assign d_tag = n25; // (signal)
  /* TG68K_Cache_030.vhd:92:10  */
  assign d_offset = n31; // (signal)
  /* TG68K_Cache_030.vhd:95:10  */
  always @*
    i_fill_req_int = n1182; // (isignal)
  initial
    i_fill_req_int = 1'b0;
  /* TG68K_Cache_030.vhd:96:10  */
  always @*
    d_fill_req_int = n1183; // (isignal)
  initial
    d_fill_req_int = 1'b0;
  /* TG68K_Cache_030.vhd:100:10  */
  always @*
    i_fill_line_idx = n1187; // (isignal)
  initial
    i_fill_line_idx = 4'b0000;
  /* TG68K_Cache_030.vhd:101:10  */
  always @*
    i_fill_tag = n1191; // (isignal)
  initial
    i_fill_tag = 24'b000000000000000000000000;
  /* TG68K_Cache_030.vhd:102:10  */
  always @*
    d_fill_line_idx = n1195; // (isignal)
  initial
    d_fill_line_idx = 4'b0000;
  /* TG68K_Cache_030.vhd:103:10  */
  always @*
    d_fill_tag = n1199; // (isignal)
  initial
    d_fill_tag = 24'b000000000000000000000000;
  /* TG68K_Cache_030.vhd:106:10  */
  assign cache_op_line_idx = n32; // (signal)
  /* TG68K_Cache_030.vhd:107:10  */
  assign cache_op_tag = n34; // (signal)
  /* TG68K_Cache_030.vhd:108:10  */
  assign cache_op_page_mask = n37; // (signal)
  /* TG68K_Cache_030.vhd:114:48  */
  assign n14 = i_addr_phys[7:4]; // extract
  /* TG68K_Cache_030.vhd:115:28  */
  assign n16 = i_addr_phys[31:8]; // extract
  /* TG68K_Cache_030.vhd:116:48  */
  assign n17 = i_addr_phys[3:2]; // extract
  /* TG68K_Cache_030.vhd:116:17  */
  assign n18 = {29'b0, n17};  //  uext
  /* TG68K_Cache_030.vhd:116:75  */
  assign n19 = {1'b0, n18};  //  uext
  /* TG68K_Cache_030.vhd:116:75  */
  assign n21 = $signed(n19) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_Cache_030.vhd:116:17  */
  assign n22 = n21[3:0];  // trunc
  /* TG68K_Cache_030.vhd:120:48  */
  assign n23 = d_addr_phys[7:4]; // extract
  /* TG68K_Cache_030.vhd:121:28  */
  assign n25 = d_addr_phys[31:8]; // extract
  /* TG68K_Cache_030.vhd:122:48  */
  assign n26 = d_addr_phys[3:2]; // extract
  /* TG68K_Cache_030.vhd:122:17  */
  assign n27 = {29'b0, n26};  //  uext
  /* TG68K_Cache_030.vhd:122:75  */
  assign n28 = {1'b0, n27};  //  uext
  /* TG68K_Cache_030.vhd:122:75  */
  assign n30 = $signed(n28) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_Cache_030.vhd:122:17  */
  assign n31 = n30[3:0];  // trunc
  /* TG68K_Cache_030.vhd:125:57  */
  assign n32 = cache_op_addr[7:4]; // extract
  /* TG68K_Cache_030.vhd:126:37  */
  assign n34 = cache_op_addr[31:8]; // extract
  /* TG68K_Cache_030.vhd:130:38  */
  assign n35 = cache_op_addr[31:12]; // extract
  /* TG68K_Cache_030.vhd:130:53  */
  assign n37 = {n35, 4'b0000};
  /* TG68K_Cache_030.vhd:135:15  */
  assign n40 = ~nreset;
  /* TG68K_Cache_030.vhd:146:21  */
  assign n63 = 4'b1111 - i_fill_line_idx;
  /* TG68K_Cache_030.vhd:147:23  */
  assign n67 = 4'b1111 - i_fill_line_idx;
  /* TG68K_Cache_030.vhd:144:7  */
  assign n73 = i_fill_valid ? n1284 : i_valid_array;
  /* TG68K_Cache_030.vhd:144:7  */
  assign n75 = i_fill_valid ? 1'b0 : i_fill_req_int;
  /* TG68K_Cache_030.vhd:153:44  */
  assign n77 = cache_op_cache == 2'b10;
  /* TG68K_Cache_030.vhd:153:69  */
  assign n79 = cache_op_cache == 2'b00;
  /* TG68K_Cache_030.vhd:153:51  */
  assign n80 = n77 | n79;
  /* TG68K_Cache_030.vhd:153:94  */
  assign n82 = cache_op_cache == 2'b11;
  /* TG68K_Cache_030.vhd:153:76  */
  assign n83 = n80 | n82;
  /* TG68K_Cache_030.vhd:153:24  */
  assign n84 = n83 & inv_req;
  /* TG68K_Cache_030.vhd:155:11  */
  assign n102 = cache_op_scope == 2'b10;
  /* TG68K_Cache_030.vhd:155:20  */
  assign n104 = cache_op_scope == 2'b11;
  /* TG68K_Cache_030.vhd:155:20  */
  assign n105 = n102 | n104;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n106 = i_valid_array[15]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n107 = i_tag_array[383:364]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n108 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n109 = n107 == n108;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n110 = n109 & n106;
  assign n112 = n73[15]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n113 = n110 ? 1'b0 : n112;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n114 = i_valid_array[14]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n115 = i_tag_array[359:340]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n116 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n117 = n115 == n116;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n118 = n117 & n114;
  assign n120 = n73[14]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n121 = n118 ? 1'b0 : n120;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n122 = i_valid_array[13]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n123 = i_tag_array[335:316]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n124 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n125 = n123 == n124;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n126 = n125 & n122;
  assign n128 = n73[13]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n129 = n126 ? 1'b0 : n128;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n130 = i_valid_array[12]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n131 = i_tag_array[311:292]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n132 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n133 = n131 == n132;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n134 = n133 & n130;
  assign n136 = n73[12]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n137 = n134 ? 1'b0 : n136;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n138 = i_valid_array[11]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n139 = i_tag_array[287:268]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n140 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n141 = n139 == n140;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n142 = n141 & n138;
  assign n144 = n73[11]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n145 = n142 ? 1'b0 : n144;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n146 = i_valid_array[10]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n147 = i_tag_array[263:244]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n148 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n149 = n147 == n148;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n150 = n149 & n146;
  assign n152 = n73[10]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n153 = n150 ? 1'b0 : n152;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n154 = i_valid_array[9]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n155 = i_tag_array[239:220]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n156 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n157 = n155 == n156;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n158 = n157 & n154;
  assign n160 = n73[9]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n161 = n158 ? 1'b0 : n160;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n162 = i_valid_array[8]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n163 = i_tag_array[215:196]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n164 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n165 = n163 == n164;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n166 = n165 & n162;
  assign n168 = n73[8]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n169 = n166 ? 1'b0 : n168;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n170 = i_valid_array[7]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n171 = i_tag_array[191:172]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n172 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n173 = n171 == n172;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n174 = n173 & n170;
  assign n176 = n73[7]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n177 = n174 ? 1'b0 : n176;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n178 = i_valid_array[6]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n179 = i_tag_array[167:148]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n180 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n181 = n179 == n180;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n182 = n181 & n178;
  assign n184 = n73[6]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n185 = n182 ? 1'b0 : n184;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n186 = i_valid_array[5]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n187 = i_tag_array[143:124]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n188 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n189 = n187 == n188;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n190 = n189 & n186;
  assign n192 = n73[5]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n193 = n190 ? 1'b0 : n192;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n194 = i_valid_array[4]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n195 = i_tag_array[119:100]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n196 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n197 = n195 == n196;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n198 = n197 & n194;
  assign n200 = n73[4]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n201 = n198 ? 1'b0 : n200;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n202 = i_valid_array[3]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n203 = i_tag_array[95:76]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n204 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n205 = n203 == n204;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n206 = n205 & n202;
  assign n208 = n73[3]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n209 = n206 ? 1'b0 : n208;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n210 = i_valid_array[2]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n211 = i_tag_array[71:52]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n212 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n213 = n211 == n212;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n214 = n213 & n210;
  assign n216 = n73[2]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n217 = n214 ? 1'b0 : n216;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n218 = i_valid_array[1]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n219 = i_tag_array[47:28]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n220 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n221 = n219 == n220;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n222 = n221 & n218;
  assign n224 = n73[1]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n225 = n222 ? 1'b0 : n224;
  /* TG68K_Cache_030.vhd:162:31  */
  assign n226 = i_valid_array[0]; // extract
  /* TG68K_Cache_030.vhd:163:33  */
  assign n227 = i_tag_array[23:4]; // extract
  /* TG68K_Cache_030.vhd:164:37  */
  assign n228 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:163:78  */
  assign n229 = n227 == n228;
  /* TG68K_Cache_030.vhd:162:41  */
  assign n230 = n229 & n226;
  assign n232 = n73[0]; // extract
  /* TG68K_Cache_030.vhd:162:15  */
  assign n233 = n230 ? 1'b0 : n232;
  /* TG68K_Cache_030.vhd:159:11  */
  assign n235 = cache_op_scope == 2'b01;
  /* TG68K_Cache_030.vhd:170:30  */
  assign n237 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:171:28  */
  assign n241 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:171:47  */
  assign n244 = n1286 == cache_op_tag;
  /* TG68K_Cache_030.vhd:170:55  */
  assign n245 = n244 & n1285;
  /* TG68K_Cache_030.vhd:172:29  */
  assign n247 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:170:13  */
  assign n251 = n245 ? n1355 : n73;
  /* TG68K_Cache_030.vhd:168:11  */
  assign n253 = cache_op_scope == 2'b00;
  assign n254 = {n253, n235, n105};
  assign n255 = n251[0]; // extract
  assign n256 = n73[0]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n257 = n255;
      3'b010: n257 = n233;
      3'b001: n257 = 1'b0;
      default: n257 = n256;
    endcase
  assign n258 = n251[1]; // extract
  assign n259 = n73[1]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n260 = n258;
      3'b010: n260 = n225;
      3'b001: n260 = 1'b0;
      default: n260 = n259;
    endcase
  assign n261 = n251[2]; // extract
  assign n262 = n73[2]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n263 = n261;
      3'b010: n263 = n217;
      3'b001: n263 = 1'b0;
      default: n263 = n262;
    endcase
  assign n264 = n251[3]; // extract
  assign n265 = n73[3]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n266 = n264;
      3'b010: n266 = n209;
      3'b001: n266 = 1'b0;
      default: n266 = n265;
    endcase
  assign n267 = n251[4]; // extract
  assign n268 = n73[4]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n269 = n267;
      3'b010: n269 = n201;
      3'b001: n269 = 1'b0;
      default: n269 = n268;
    endcase
  assign n270 = n251[5]; // extract
  assign n271 = n73[5]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n272 = n270;
      3'b010: n272 = n193;
      3'b001: n272 = 1'b0;
      default: n272 = n271;
    endcase
  assign n273 = n251[6]; // extract
  assign n274 = n73[6]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n275 = n273;
      3'b010: n275 = n185;
      3'b001: n275 = 1'b0;
      default: n275 = n274;
    endcase
  assign n276 = n251[7]; // extract
  assign n277 = n73[7]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n278 = n276;
      3'b010: n278 = n177;
      3'b001: n278 = 1'b0;
      default: n278 = n277;
    endcase
  assign n279 = n251[8]; // extract
  assign n280 = n73[8]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n281 = n279;
      3'b010: n281 = n169;
      3'b001: n281 = 1'b0;
      default: n281 = n280;
    endcase
  assign n282 = n251[9]; // extract
  assign n283 = n73[9]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n284 = n282;
      3'b010: n284 = n161;
      3'b001: n284 = 1'b0;
      default: n284 = n283;
    endcase
  assign n285 = n251[10]; // extract
  assign n286 = n73[10]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n287 = n285;
      3'b010: n287 = n153;
      3'b001: n287 = 1'b0;
      default: n287 = n286;
    endcase
  assign n288 = n251[11]; // extract
  assign n289 = n73[11]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n290 = n288;
      3'b010: n290 = n145;
      3'b001: n290 = 1'b0;
      default: n290 = n289;
    endcase
  assign n291 = n251[12]; // extract
  assign n292 = n73[12]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n293 = n291;
      3'b010: n293 = n137;
      3'b001: n293 = 1'b0;
      default: n293 = n292;
    endcase
  assign n294 = n251[13]; // extract
  assign n295 = n73[13]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n296 = n294;
      3'b010: n296 = n129;
      3'b001: n296 = 1'b0;
      default: n296 = n295;
    endcase
  assign n297 = n251[14]; // extract
  assign n298 = n73[14]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n299 = n297;
      3'b010: n299 = n121;
      3'b001: n299 = 1'b0;
      default: n299 = n298;
    endcase
  assign n300 = n251[15]; // extract
  assign n301 = n73[15]; // extract
  /* TG68K_Cache_030.vhd:154:9  */
  always @*
    case (n254)
      3'b100: n302 = n300;
      3'b010: n302 = n113;
      3'b001: n302 = 1'b0;
      default: n302 = n301;
    endcase
  assign n303 = {n302, n299, n296, n293, n290, n287, n284, n281, n278, n275, n272, n269, n266, n263, n260, n257};
  /* TG68K_Cache_030.vhd:153:7  */
  assign n304 = n84 ? n303 : n73;
  /* TG68K_Cache_030.vhd:182:22  */
  assign n305 = cacr_ie & i_req;
  /* TG68K_Cache_030.vhd:182:60  */
  assign n306 = ~i_cache_inhibit;
  /* TG68K_Cache_030.vhd:182:40  */
  assign n307 = n306 & n305;
  /* TG68K_Cache_030.vhd:182:85  */
  assign n308 = ~i_fill_req_int;
  /* TG68K_Cache_030.vhd:182:66  */
  assign n309 = n308 & n307;
  /* TG68K_Cache_030.vhd:184:26  */
  assign n311 = 4'b1111 - i_line_idx;
  /* TG68K_Cache_030.vhd:184:38  */
  assign n314 = ~n1356;
  /* TG68K_Cache_030.vhd:184:59  */
  assign n316 = 4'b1111 - i_line_idx;
  /* TG68K_Cache_030.vhd:184:71  */
  assign n319 = n1357 != i_tag;
  /* TG68K_Cache_030.vhd:184:44  */
  assign n320 = n314 | n319;
  /* TG68K_Cache_030.vhd:186:27  */
  assign n321 = ~cacr_ifreeze;
  /* TG68K_Cache_030.vhd:192:39  */
  assign n322 = i_addr_phys[31:4]; // extract
  /* TG68K_Cache_030.vhd:192:63  */
  assign n324 = {n322, 4'b0000};
  /* TG68K_Cache_030.vhd:182:7  */
  assign n327 = n335 ? 1'b1 : n75;
  /* TG68K_Cache_030.vhd:184:9  */
  assign n330 = n321 & n320;
  /* TG68K_Cache_030.vhd:184:9  */
  assign n331 = n321 & n320;
  /* TG68K_Cache_030.vhd:184:9  */
  assign n332 = n321 & n320;
  /* TG68K_Cache_030.vhd:184:9  */
  assign n333 = n321 & n320;
  /* TG68K_Cache_030.vhd:182:7  */
  assign n334 = n330 & n309;
  /* TG68K_Cache_030.vhd:182:7  */
  assign n335 = n331 & n309;
  /* TG68K_Cache_030.vhd:182:7  */
  assign n336 = n332 & n309;
  /* TG68K_Cache_030.vhd:182:7  */
  assign n337 = n333 & n309;
  /* TG68K_Cache_030.vhd:199:31  */
  assign n338 = cacr_ifreeze & i_fill_req_int;
  /* TG68K_Cache_030.vhd:199:7  */
  assign n340 = n338 ? 1'b0 : n327;
  assign n352 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  /* TG68K_Cache_030.vhd:209:36  */
  assign n360 = i_req & cacr_ie;
  /* TG68K_Cache_030.vhd:209:72  */
  assign n361 = ~i_cache_inhibit;
  /* TG68K_Cache_030.vhd:209:52  */
  assign n362 = n361 & n360;
  /* TG68K_Cache_030.vhd:210:36  */
  assign n364 = 4'b1111 - i_line_idx;
  /* TG68K_Cache_030.vhd:209:78  */
  assign n367 = n1358 & n362;
  /* TG68K_Cache_030.vhd:210:70  */
  assign n369 = 4'b1111 - i_line_idx;
  /* TG68K_Cache_030.vhd:210:82  */
  assign n372 = n1359 == i_tag;
  /* TG68K_Cache_030.vhd:210:54  */
  assign n373 = n372 & n367;
  /* TG68K_Cache_030.vhd:209:16  */
  assign n374 = n373 ? 1'b1 : 1'b0;
  /* TG68K_Cache_030.vhd:216:55  */
  assign n381 = i_offset == 4'b0000;
  /* TG68K_Cache_030.vhd:217:55  */
  assign n387 = i_offset == 4'b0100;
  /* TG68K_Cache_030.vhd:218:55  */
  assign n393 = i_offset == 4'b1000;
  /* TG68K_Cache_030.vhd:219:55  */
  assign n399 = i_offset == 4'b1100;
  assign n401 = {n399, n393, n387, n381};
  /* TG68K_Cache_030.vhd:215:3  */
  always @*
    case (n401)
      4'b1000: n402 = n1204;
      4'b0100: n402 = n1205;
      4'b0010: n402 = n1206;
      4'b0001: n402 = n1207;
      default: n402 = 32'b00000000000000000000000000000000;
    endcase
  /* TG68K_Cache_030.vhd:225:15  */
  assign n405 = ~nreset;
  /* TG68K_Cache_030.vhd:235:22  */
  assign n424 = 4'b1111 - d_fill_line_idx;
  /* TG68K_Cache_030.vhd:236:21  */
  assign n428 = 4'b1111 - d_fill_line_idx;
  /* TG68K_Cache_030.vhd:237:23  */
  assign n432 = 4'b1111 - d_fill_line_idx;
  /* TG68K_Cache_030.vhd:234:7  */
  assign n436 = d_fill_valid ? n1428 : d_data_array;
  /* TG68K_Cache_030.vhd:234:7  */
  assign n438 = d_fill_valid ? n1497 : d_valid_array;
  /* TG68K_Cache_030.vhd:234:7  */
  assign n440 = d_fill_valid ? 1'b0 : d_fill_req_int;
  /* TG68K_Cache_030.vhd:243:44  */
  assign n442 = cache_op_cache == 2'b01;
  /* TG68K_Cache_030.vhd:243:69  */
  assign n444 = cache_op_cache == 2'b00;
  /* TG68K_Cache_030.vhd:243:51  */
  assign n445 = n442 | n444;
  /* TG68K_Cache_030.vhd:243:94  */
  assign n447 = cache_op_cache == 2'b11;
  /* TG68K_Cache_030.vhd:243:76  */
  assign n448 = n445 | n447;
  /* TG68K_Cache_030.vhd:243:24  */
  assign n449 = n448 & inv_req;
  /* TG68K_Cache_030.vhd:245:11  */
  assign n467 = cache_op_scope == 2'b10;
  /* TG68K_Cache_030.vhd:245:20  */
  assign n469 = cache_op_scope == 2'b11;
  /* TG68K_Cache_030.vhd:245:20  */
  assign n470 = n467 | n469;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n471 = d_valid_array[15]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n472 = d_tag_array[383:364]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n473 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n474 = n472 == n473;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n475 = n474 & n471;
  assign n477 = n438[15]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n478 = n475 ? 1'b0 : n477;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n479 = d_valid_array[14]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n480 = d_tag_array[359:340]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n481 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n482 = n480 == n481;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n483 = n482 & n479;
  assign n485 = n438[14]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n486 = n483 ? 1'b0 : n485;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n487 = d_valid_array[13]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n488 = d_tag_array[335:316]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n489 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n490 = n488 == n489;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n491 = n490 & n487;
  assign n493 = n438[13]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n494 = n491 ? 1'b0 : n493;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n495 = d_valid_array[12]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n496 = d_tag_array[311:292]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n497 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n498 = n496 == n497;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n499 = n498 & n495;
  assign n501 = n438[12]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n502 = n499 ? 1'b0 : n501;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n503 = d_valid_array[11]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n504 = d_tag_array[287:268]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n505 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n506 = n504 == n505;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n507 = n506 & n503;
  assign n509 = n438[11]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n510 = n507 ? 1'b0 : n509;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n511 = d_valid_array[10]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n512 = d_tag_array[263:244]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n513 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n514 = n512 == n513;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n515 = n514 & n511;
  assign n517 = n438[10]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n518 = n515 ? 1'b0 : n517;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n519 = d_valid_array[9]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n520 = d_tag_array[239:220]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n521 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n522 = n520 == n521;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n523 = n522 & n519;
  assign n525 = n438[9]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n526 = n523 ? 1'b0 : n525;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n527 = d_valid_array[8]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n528 = d_tag_array[215:196]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n529 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n530 = n528 == n529;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n531 = n530 & n527;
  assign n533 = n438[8]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n534 = n531 ? 1'b0 : n533;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n535 = d_valid_array[7]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n536 = d_tag_array[191:172]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n537 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n538 = n536 == n537;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n539 = n538 & n535;
  assign n541 = n438[7]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n542 = n539 ? 1'b0 : n541;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n543 = d_valid_array[6]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n544 = d_tag_array[167:148]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n545 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n546 = n544 == n545;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n547 = n546 & n543;
  assign n549 = n438[6]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n550 = n547 ? 1'b0 : n549;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n551 = d_valid_array[5]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n552 = d_tag_array[143:124]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n553 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n554 = n552 == n553;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n555 = n554 & n551;
  assign n557 = n438[5]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n558 = n555 ? 1'b0 : n557;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n559 = d_valid_array[4]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n560 = d_tag_array[119:100]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n561 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n562 = n560 == n561;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n563 = n562 & n559;
  assign n565 = n438[4]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n566 = n563 ? 1'b0 : n565;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n567 = d_valid_array[3]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n568 = d_tag_array[95:76]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n569 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n570 = n568 == n569;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n571 = n570 & n567;
  assign n573 = n438[3]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n574 = n571 ? 1'b0 : n573;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n575 = d_valid_array[2]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n576 = d_tag_array[71:52]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n577 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n578 = n576 == n577;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n579 = n578 & n575;
  assign n581 = n438[2]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n582 = n579 ? 1'b0 : n581;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n583 = d_valid_array[1]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n584 = d_tag_array[47:28]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n585 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n586 = n584 == n585;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n587 = n586 & n583;
  assign n589 = n438[1]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n590 = n587 ? 1'b0 : n589;
  /* TG68K_Cache_030.vhd:252:31  */
  assign n591 = d_valid_array[0]; // extract
  /* TG68K_Cache_030.vhd:253:33  */
  assign n592 = d_tag_array[23:4]; // extract
  /* TG68K_Cache_030.vhd:254:37  */
  assign n593 = cache_op_page_mask[23:4]; // extract
  /* TG68K_Cache_030.vhd:253:78  */
  assign n594 = n592 == n593;
  /* TG68K_Cache_030.vhd:252:41  */
  assign n595 = n594 & n591;
  assign n597 = n438[0]; // extract
  /* TG68K_Cache_030.vhd:252:15  */
  assign n598 = n595 ? 1'b0 : n597;
  /* TG68K_Cache_030.vhd:249:11  */
  assign n600 = cache_op_scope == 2'b01;
  /* TG68K_Cache_030.vhd:260:30  */
  assign n602 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:261:28  */
  assign n606 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:261:47  */
  assign n609 = n1499 == cache_op_tag;
  /* TG68K_Cache_030.vhd:260:55  */
  assign n610 = n609 & n1498;
  /* TG68K_Cache_030.vhd:262:29  */
  assign n612 = 4'b1111 - cache_op_line_idx;
  /* TG68K_Cache_030.vhd:260:13  */
  assign n616 = n610 ? n1568 : n438;
  /* TG68K_Cache_030.vhd:258:11  */
  assign n618 = cache_op_scope == 2'b00;
  assign n619 = {n618, n600, n470};
  assign n620 = n616[0]; // extract
  assign n621 = n438[0]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n622 = n620;
      3'b010: n622 = n598;
      3'b001: n622 = 1'b0;
      default: n622 = n621;
    endcase
  assign n623 = n616[1]; // extract
  assign n624 = n438[1]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n625 = n623;
      3'b010: n625 = n590;
      3'b001: n625 = 1'b0;
      default: n625 = n624;
    endcase
  assign n626 = n616[2]; // extract
  assign n627 = n438[2]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n628 = n626;
      3'b010: n628 = n582;
      3'b001: n628 = 1'b0;
      default: n628 = n627;
    endcase
  assign n629 = n616[3]; // extract
  assign n630 = n438[3]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n631 = n629;
      3'b010: n631 = n574;
      3'b001: n631 = 1'b0;
      default: n631 = n630;
    endcase
  assign n632 = n616[4]; // extract
  assign n633 = n438[4]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n634 = n632;
      3'b010: n634 = n566;
      3'b001: n634 = 1'b0;
      default: n634 = n633;
    endcase
  assign n635 = n616[5]; // extract
  assign n636 = n438[5]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n637 = n635;
      3'b010: n637 = n558;
      3'b001: n637 = 1'b0;
      default: n637 = n636;
    endcase
  assign n638 = n616[6]; // extract
  assign n639 = n438[6]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n640 = n638;
      3'b010: n640 = n550;
      3'b001: n640 = 1'b0;
      default: n640 = n639;
    endcase
  assign n641 = n616[7]; // extract
  assign n642 = n438[7]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n643 = n641;
      3'b010: n643 = n542;
      3'b001: n643 = 1'b0;
      default: n643 = n642;
    endcase
  assign n644 = n616[8]; // extract
  assign n645 = n438[8]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n646 = n644;
      3'b010: n646 = n534;
      3'b001: n646 = 1'b0;
      default: n646 = n645;
    endcase
  assign n647 = n616[9]; // extract
  assign n648 = n438[9]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n649 = n647;
      3'b010: n649 = n526;
      3'b001: n649 = 1'b0;
      default: n649 = n648;
    endcase
  assign n650 = n616[10]; // extract
  assign n651 = n438[10]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n652 = n650;
      3'b010: n652 = n518;
      3'b001: n652 = 1'b0;
      default: n652 = n651;
    endcase
  assign n653 = n616[11]; // extract
  assign n654 = n438[11]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n655 = n653;
      3'b010: n655 = n510;
      3'b001: n655 = 1'b0;
      default: n655 = n654;
    endcase
  assign n656 = n616[12]; // extract
  assign n657 = n438[12]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n658 = n656;
      3'b010: n658 = n502;
      3'b001: n658 = 1'b0;
      default: n658 = n657;
    endcase
  assign n659 = n616[13]; // extract
  assign n660 = n438[13]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n661 = n659;
      3'b010: n661 = n494;
      3'b001: n661 = 1'b0;
      default: n661 = n660;
    endcase
  assign n662 = n616[14]; // extract
  assign n663 = n438[14]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n664 = n662;
      3'b010: n664 = n486;
      3'b001: n664 = 1'b0;
      default: n664 = n663;
    endcase
  assign n665 = n616[15]; // extract
  assign n666 = n438[15]; // extract
  /* TG68K_Cache_030.vhd:244:9  */
  always @*
    case (n619)
      3'b100: n667 = n665;
      3'b010: n667 = n478;
      3'b001: n667 = 1'b0;
      default: n667 = n666;
    endcase
  assign n668 = {n667, n664, n661, n658, n655, n652, n649, n646, n643, n640, n637, n634, n631, n628, n625, n622};
  /* TG68K_Cache_030.vhd:243:7  */
  assign n669 = n449 ? n668 : n438;
  /* TG68K_Cache_030.vhd:270:22  */
  assign n670 = cacr_de & d_req;
  /* TG68K_Cache_030.vhd:270:60  */
  assign n671 = ~d_cache_inhibit;
  /* TG68K_Cache_030.vhd:270:40  */
  assign n672 = n671 & n670;
  /* TG68K_Cache_030.vhd:272:41  */
  assign n674 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:272:23  */
  assign n677 = n1569 & d_we;
  /* TG68K_Cache_030.vhd:272:75  */
  assign n679 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:272:87  */
  assign n682 = n1570 == d_tag;
  /* TG68K_Cache_030.vhd:272:59  */
  assign n683 = n682 & n677;
  /* TG68K_Cache_030.vhd:276:22  */
  assign n684 = d_be[0]; // extract
  /* TG68K_Cache_030.vhd:276:50  */
  assign n686 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:276:89  */
  assign n688 = d_data_in[7:0]; // extract
  /* TG68K_Cache_030.vhd:276:15  */
  assign n690 = n684 ? n1655 : n436;
  /* TG68K_Cache_030.vhd:277:22  */
  assign n691 = d_be[1]; // extract
  /* TG68K_Cache_030.vhd:277:50  */
  assign n693 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:277:89  */
  assign n695 = d_data_in[15:8]; // extract
  /* TG68K_Cache_030.vhd:277:15  */
  assign n697 = n691 ? n1741 : n690;
  /* TG68K_Cache_030.vhd:278:22  */
  assign n698 = d_be[2]; // extract
  /* TG68K_Cache_030.vhd:278:50  */
  assign n700 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:278:89  */
  assign n702 = d_data_in[23:16]; // extract
  /* TG68K_Cache_030.vhd:278:15  */
  assign n704 = n698 ? n1827 : n697;
  /* TG68K_Cache_030.vhd:279:22  */
  assign n705 = d_be[3]; // extract
  /* TG68K_Cache_030.vhd:279:50  */
  assign n707 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:279:89  */
  assign n709 = d_data_in[31:24]; // extract
  /* TG68K_Cache_030.vhd:279:15  */
  assign n711 = n705 ? n1913 : n704;
  /* TG68K_Cache_030.vhd:275:13  */
  assign n713 = d_offset == 4'b0000;
  /* TG68K_Cache_030.vhd:281:22  */
  assign n714 = d_be[0]; // extract
  /* TG68K_Cache_030.vhd:281:50  */
  assign n716 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:281:89  */
  assign n718 = d_data_in[7:0]; // extract
  /* TG68K_Cache_030.vhd:281:15  */
  assign n720 = n714 ? n1999 : n436;
  /* TG68K_Cache_030.vhd:282:22  */
  assign n721 = d_be[1]; // extract
  /* TG68K_Cache_030.vhd:282:50  */
  assign n723 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:282:89  */
  assign n725 = d_data_in[15:8]; // extract
  /* TG68K_Cache_030.vhd:282:15  */
  assign n727 = n721 ? n2085 : n720;
  /* TG68K_Cache_030.vhd:283:22  */
  assign n728 = d_be[2]; // extract
  /* TG68K_Cache_030.vhd:283:50  */
  assign n730 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:283:89  */
  assign n732 = d_data_in[23:16]; // extract
  /* TG68K_Cache_030.vhd:283:15  */
  assign n734 = n728 ? n2171 : n727;
  /* TG68K_Cache_030.vhd:284:22  */
  assign n735 = d_be[3]; // extract
  /* TG68K_Cache_030.vhd:284:50  */
  assign n737 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:284:89  */
  assign n739 = d_data_in[31:24]; // extract
  /* TG68K_Cache_030.vhd:284:15  */
  assign n741 = n735 ? n2257 : n734;
  /* TG68K_Cache_030.vhd:280:13  */
  assign n743 = d_offset == 4'b0100;
  /* TG68K_Cache_030.vhd:286:22  */
  assign n744 = d_be[0]; // extract
  /* TG68K_Cache_030.vhd:286:50  */
  assign n746 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:286:89  */
  assign n748 = d_data_in[7:0]; // extract
  /* TG68K_Cache_030.vhd:286:15  */
  assign n750 = n744 ? n2343 : n436;
  /* TG68K_Cache_030.vhd:287:22  */
  assign n751 = d_be[1]; // extract
  /* TG68K_Cache_030.vhd:287:50  */
  assign n753 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:287:89  */
  assign n755 = d_data_in[15:8]; // extract
  /* TG68K_Cache_030.vhd:287:15  */
  assign n757 = n751 ? n2429 : n750;
  /* TG68K_Cache_030.vhd:288:22  */
  assign n758 = d_be[2]; // extract
  /* TG68K_Cache_030.vhd:288:50  */
  assign n760 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:288:89  */
  assign n762 = d_data_in[23:16]; // extract
  /* TG68K_Cache_030.vhd:288:15  */
  assign n764 = n758 ? n2515 : n757;
  /* TG68K_Cache_030.vhd:289:22  */
  assign n765 = d_be[3]; // extract
  /* TG68K_Cache_030.vhd:289:50  */
  assign n767 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:289:89  */
  assign n769 = d_data_in[31:24]; // extract
  /* TG68K_Cache_030.vhd:289:15  */
  assign n771 = n765 ? n2601 : n764;
  /* TG68K_Cache_030.vhd:285:13  */
  assign n773 = d_offset == 4'b1000;
  /* TG68K_Cache_030.vhd:291:22  */
  assign n774 = d_be[0]; // extract
  /* TG68K_Cache_030.vhd:291:50  */
  assign n776 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:291:90  */
  assign n778 = d_data_in[7:0]; // extract
  /* TG68K_Cache_030.vhd:291:15  */
  assign n780 = n774 ? n2687 : n436;
  /* TG68K_Cache_030.vhd:292:22  */
  assign n781 = d_be[1]; // extract
  /* TG68K_Cache_030.vhd:292:50  */
  assign n783 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:292:90  */
  assign n785 = d_data_in[15:8]; // extract
  /* TG68K_Cache_030.vhd:292:15  */
  assign n787 = n781 ? n2773 : n780;
  /* TG68K_Cache_030.vhd:293:22  */
  assign n788 = d_be[2]; // extract
  /* TG68K_Cache_030.vhd:293:50  */
  assign n790 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:293:90  */
  assign n792 = d_data_in[23:16]; // extract
  /* TG68K_Cache_030.vhd:293:15  */
  assign n794 = n788 ? n2859 : n787;
  /* TG68K_Cache_030.vhd:294:22  */
  assign n795 = d_be[3]; // extract
  /* TG68K_Cache_030.vhd:294:50  */
  assign n797 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:294:90  */
  assign n799 = d_data_in[31:24]; // extract
  /* TG68K_Cache_030.vhd:294:15  */
  assign n801 = n795 ? n2944 : n794;
  /* TG68K_Cache_030.vhd:290:13  */
  assign n803 = d_offset == 4'b1100;
  assign n804 = {n803, n773, n743, n713};
  /* TG68K_Cache_030.vhd:274:11  */
  always @*
    case (n804)
      4'b1000: n805 = n801;
      4'b0100: n805 = n771;
      4'b0010: n805 = n741;
      4'b0001: n805 = n711;
      default: n805 = n436;
    endcase
  /* TG68K_Cache_030.vhd:297:20  */
  assign n806 = ~d_we;
  /* TG68K_Cache_030.vhd:300:29  */
  assign n807 = ~d_fill_req_int;
  /* TG68K_Cache_030.vhd:300:54  */
  assign n809 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:300:66  */
  assign n812 = ~n2945;
  /* TG68K_Cache_030.vhd:300:87  */
  assign n814 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:300:99  */
  assign n817 = n2946 != d_tag;
  /* TG68K_Cache_030.vhd:300:72  */
  assign n818 = n812 | n817;
  /* TG68K_Cache_030.vhd:300:35  */
  assign n819 = n818 & n807;
  /* TG68K_Cache_030.vhd:302:29  */
  assign n820 = ~cacr_dfreeze;
  /* TG68K_Cache_030.vhd:308:41  */
  assign n821 = d_addr_phys[31:4]; // extract
  /* TG68K_Cache_030.vhd:308:65  */
  assign n823 = {n821, 4'b0000};
  /* TG68K_Cache_030.vhd:300:11  */
  assign n824 = n829 ? n823 : n1203;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n826 = n830 ? 1'b1 : n440;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n827 = n831 ? d_line_idx : d_fill_line_idx;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n828 = n832 ? d_tag : d_fill_tag;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n829 = n820 & n819;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n830 = n820 & n819;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n831 = n820 & n819;
  /* TG68K_Cache_030.vhd:300:11  */
  assign n832 = n820 & n819;
  /* TG68K_Cache_030.vhd:314:29  */
  assign n833 = ~d_fill_req_int;
  /* TG68K_Cache_030.vhd:314:35  */
  assign n834 = cacr_wa & n833;
  /* TG68K_Cache_030.vhd:314:72  */
  assign n836 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:314:84  */
  assign n839 = ~n2947;
  /* TG68K_Cache_030.vhd:314:105  */
  assign n841 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:314:117  */
  assign n844 = n2948 != d_tag;
  /* TG68K_Cache_030.vhd:314:90  */
  assign n845 = n839 | n844;
  /* TG68K_Cache_030.vhd:314:53  */
  assign n846 = n845 & n834;
  /* TG68K_Cache_030.vhd:317:29  */
  assign n847 = ~cacr_dfreeze;
  /* TG68K_Cache_030.vhd:323:41  */
  assign n848 = d_addr_phys[31:4]; // extract
  /* TG68K_Cache_030.vhd:323:65  */
  assign n850 = {n848, 4'b0000};
  /* TG68K_Cache_030.vhd:314:11  */
  assign n851 = n856 ? n850 : n1203;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n853 = n857 ? 1'b1 : n440;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n854 = n858 ? d_line_idx : d_fill_line_idx;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n855 = n859 ? d_tag : d_fill_tag;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n856 = n847 & n846;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n857 = n847 & n846;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n858 = n847 & n846;
  /* TG68K_Cache_030.vhd:314:11  */
  assign n859 = n847 & n846;
  /* TG68K_Cache_030.vhd:297:9  */
  assign n860 = n806 ? n824 : n851;
  /* TG68K_Cache_030.vhd:297:9  */
  assign n861 = n806 ? n826 : n853;
  /* TG68K_Cache_030.vhd:297:9  */
  assign n862 = n806 ? n827 : n854;
  /* TG68K_Cache_030.vhd:297:9  */
  assign n863 = n806 ? n828 : n855;
  /* TG68K_Cache_030.vhd:272:9  */
  assign n864 = n683 ? n1203 : n860;
  /* TG68K_Cache_030.vhd:270:7  */
  assign n865 = n870 ? n805 : n436;
  /* TG68K_Cache_030.vhd:272:9  */
  assign n866 = n683 ? n440 : n861;
  /* TG68K_Cache_030.vhd:272:9  */
  assign n867 = n683 ? d_fill_line_idx : n862;
  /* TG68K_Cache_030.vhd:272:9  */
  assign n868 = n683 ? d_fill_tag : n863;
  /* TG68K_Cache_030.vhd:270:7  */
  assign n870 = n683 & n672;
  /* TG68K_Cache_030.vhd:270:7  */
  assign n871 = n672 ? n866 : n440;
  /* TG68K_Cache_030.vhd:332:22  */
  assign n874 = d_we & d_req;
  /* TG68K_Cache_030.vhd:332:37  */
  assign n875 = cacr_de & n874;
  /* TG68K_Cache_030.vhd:332:75  */
  assign n876 = ~d_cache_inhibit;
  /* TG68K_Cache_030.vhd:332:55  */
  assign n877 = n876 & n875;
  /* TG68K_Cache_030.vhd:334:31  */
  assign n879 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:334:65  */
  assign n883 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:334:77  */
  assign n886 = n2950 == d_tag;
  /* TG68K_Cache_030.vhd:334:49  */
  assign n887 = n886 & n2949;
  /* TG68K_Cache_030.vhd:334:12  */
  assign n888 = ~n887;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n889 = d_valid_array[15]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n890 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n892 = 32'b00000000000000000000000000000000 != n890;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n893 = n892 & n889;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n894 = d_tag_array[383:364]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n895 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n896 = n894 == n895;
  assign n898 = n669[15]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n899 = n901 ? 1'b0 : n898;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n901 = n896 & n893;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n902 = d_valid_array[14]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n903 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n905 = 32'b00000000000000000000000000000001 != n903;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n906 = n905 & n902;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n907 = d_tag_array[359:340]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n908 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n909 = n907 == n908;
  assign n911 = n669[14]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n912 = n914 ? 1'b0 : n911;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n914 = n909 & n906;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n915 = d_valid_array[13]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n916 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n918 = 32'b00000000000000000000000000000010 != n916;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n919 = n918 & n915;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n920 = d_tag_array[335:316]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n921 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n922 = n920 == n921;
  assign n924 = n669[13]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n925 = n927 ? 1'b0 : n924;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n927 = n922 & n919;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n928 = d_valid_array[12]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n929 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n931 = 32'b00000000000000000000000000000011 != n929;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n932 = n931 & n928;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n933 = d_tag_array[311:292]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n934 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n935 = n933 == n934;
  assign n937 = n669[12]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n938 = n940 ? 1'b0 : n937;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n940 = n935 & n932;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n941 = d_valid_array[11]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n942 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n944 = 32'b00000000000000000000000000000100 != n942;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n945 = n944 & n941;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n946 = d_tag_array[287:268]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n947 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n948 = n946 == n947;
  assign n950 = n669[11]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n951 = n953 ? 1'b0 : n950;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n953 = n948 & n945;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n954 = d_valid_array[10]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n955 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n957 = 32'b00000000000000000000000000000101 != n955;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n958 = n957 & n954;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n959 = d_tag_array[263:244]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n960 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n961 = n959 == n960;
  assign n963 = n669[10]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n964 = n966 ? 1'b0 : n963;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n966 = n961 & n958;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n967 = d_valid_array[9]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n968 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n970 = 32'b00000000000000000000000000000110 != n968;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n971 = n970 & n967;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n972 = d_tag_array[239:220]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n973 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n974 = n972 == n973;
  assign n976 = n669[9]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n977 = n979 ? 1'b0 : n976;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n979 = n974 & n971;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n980 = d_valid_array[8]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n981 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n983 = 32'b00000000000000000000000000000111 != n981;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n984 = n983 & n980;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n985 = d_tag_array[215:196]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n986 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n987 = n985 == n986;
  assign n989 = n669[8]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n990 = n992 ? 1'b0 : n989;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n992 = n987 & n984;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n993 = d_valid_array[7]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n994 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n996 = 32'b00000000000000000000000000001000 != n994;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n997 = n996 & n993;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n998 = d_tag_array[191:172]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n999 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1000 = n998 == n999;
  assign n1002 = n669[7]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1003 = n1005 ? 1'b0 : n1002;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1005 = n1000 & n997;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1006 = d_valid_array[6]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1007 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1009 = 32'b00000000000000000000000000001001 != n1007;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1010 = n1009 & n1006;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1011 = d_tag_array[167:148]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1012 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1013 = n1011 == n1012;
  assign n1015 = n669[6]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1016 = n1018 ? 1'b0 : n1015;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1018 = n1013 & n1010;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1019 = d_valid_array[5]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1020 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1022 = 32'b00000000000000000000000000001010 != n1020;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1023 = n1022 & n1019;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1024 = d_tag_array[143:124]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1025 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1026 = n1024 == n1025;
  assign n1028 = n669[5]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1029 = n1031 ? 1'b0 : n1028;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1031 = n1026 & n1023;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1032 = d_valid_array[4]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1033 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1035 = 32'b00000000000000000000000000001011 != n1033;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1036 = n1035 & n1032;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1037 = d_tag_array[119:100]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1038 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1039 = n1037 == n1038;
  assign n1041 = n669[4]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1042 = n1044 ? 1'b0 : n1041;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1044 = n1039 & n1036;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1045 = d_valid_array[3]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1046 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1048 = 32'b00000000000000000000000000001100 != n1046;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1049 = n1048 & n1045;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1050 = d_tag_array[95:76]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1051 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1052 = n1050 == n1051;
  assign n1054 = n669[3]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1055 = n1057 ? 1'b0 : n1054;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1057 = n1052 & n1049;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1058 = d_valid_array[2]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1059 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1061 = 32'b00000000000000000000000000001101 != n1059;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1062 = n1061 & n1058;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1063 = d_tag_array[71:52]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1064 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1065 = n1063 == n1064;
  assign n1067 = n669[2]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1068 = n1070 ? 1'b0 : n1067;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1070 = n1065 & n1062;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1071 = d_valid_array[1]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1072 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1074 = 32'b00000000000000000000000000001110 != n1072;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1075 = n1074 & n1071;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1076 = d_tag_array[47:28]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1077 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1078 = n1076 == n1077;
  assign n1080 = n669[1]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1081 = n1083 ? 1'b0 : n1080;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1083 = n1078 & n1075;
  /* TG68K_Cache_030.vhd:337:29  */
  assign n1084 = d_valid_array[0]; // extract
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1085 = {28'b0, d_line_idx};  //  uext
  /* TG68K_Cache_030.vhd:337:45  */
  assign n1087 = 32'b00000000000000000000000000001111 != n1085;
  /* TG68K_Cache_030.vhd:337:39  */
  assign n1088 = n1087 & n1084;
  /* TG68K_Cache_030.vhd:339:32  */
  assign n1089 = d_tag_array[23:4]; // extract
  /* TG68K_Cache_030.vhd:340:23  */
  assign n1090 = d_tag[23:4]; // extract
  /* TG68K_Cache_030.vhd:339:77  */
  assign n1091 = n1089 == n1090;
  assign n1093 = n669[0]; // extract
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1094 = n1096 ? 1'b0 : n1093;
  /* TG68K_Cache_030.vhd:337:13  */
  assign n1096 = n1091 & n1088;
  assign n1097 = {n899, n912, n925, n938, n951, n964, n977, n990, n1003, n1016, n1029, n1042, n1055, n1068, n1081, n1094};
  /* TG68K_Cache_030.vhd:332:7  */
  assign n1098 = n1099 ? n1097 : n669;
  /* TG68K_Cache_030.vhd:332:7  */
  assign n1099 = n888 & n877;
  /* TG68K_Cache_030.vhd:351:31  */
  assign n1100 = cacr_dfreeze & d_fill_req_int;
  /* TG68K_Cache_030.vhd:351:7  */
  assign n1102 = n1100 ? 1'b0 : n871;
  assign n1114 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  /* TG68K_Cache_030.vhd:361:36  */
  assign n1122 = d_req & cacr_de;
  /* TG68K_Cache_030.vhd:361:72  */
  assign n1123 = ~d_cache_inhibit;
  /* TG68K_Cache_030.vhd:361:52  */
  assign n1124 = n1123 & n1122;
  /* TG68K_Cache_030.vhd:362:36  */
  assign n1126 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:361:78  */
  assign n1129 = n2951 & n1124;
  /* TG68K_Cache_030.vhd:362:70  */
  assign n1131 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:362:82  */
  assign n1134 = n2952 == d_tag;
  /* TG68K_Cache_030.vhd:362:54  */
  assign n1135 = n1134 & n1129;
  /* TG68K_Cache_030.vhd:361:16  */
  assign n1136 = n1135 ? 1'b1 : 1'b0;
  /* TG68K_Cache_030.vhd:368:32  */
  assign n1139 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:368:59  */
  assign n1143 = d_offset == 4'b0000;
  /* TG68K_Cache_030.vhd:369:32  */
  assign n1145 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:369:59  */
  assign n1149 = d_offset == 4'b0100;
  /* TG68K_Cache_030.vhd:370:32  */
  assign n1151 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:370:59  */
  assign n1155 = d_offset == 4'b1000;
  /* TG68K_Cache_030.vhd:371:32  */
  assign n1157 = 4'b1111 - d_line_idx;
  /* TG68K_Cache_030.vhd:371:59  */
  assign n1161 = d_offset == 4'b1100;
  assign n1163 = {n1161, n1155, n1149, n1143};
  /* TG68K_Cache_030.vhd:367:3  */
  always @*
    case (n1163)
      4'b1000: n1164 = n2969;
      4'b0100: n1164 = n2964;
      4'b0010: n1164 = n2959;
      4'b0001: n1164 = n2954;
      default: n1164 = 32'b00000000000000000000000000000000;
    endcase
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1165 = ~n40;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1166 = i_fill_valid & n1165;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1169 = ~n40;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1170 = i_fill_valid & n1169;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk)
    n1172 <= n3054;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk or posedge n40)
    if (n40)
      n1173 <= n352;
    else
      n1173 <= n304;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1174 = ~n405;
  /* TG68K_Cache_030.vhd:232:5  */
  assign n1175 = n1174 ? n865 : d_data_array;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk)
    n1176 <= n1175;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1177 = ~n405;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1178 = d_fill_valid & n1177;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk)
    n1180 <= n3139;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk or posedge n405)
    if (n405)
      n1181 <= n1114;
    else
      n1181 <= n1098;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk or posedge n40)
    if (n40)
      n1182 <= 1'b0;
    else
      n1182 <= n340;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk or posedge n405)
    if (n405)
      n1183 <= 1'b0;
    else
      n1183 <= n1102;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1184 = ~n40;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1185 = n336 & n1184;
  /* TG68K_Cache_030.vhd:142:5  */
  assign n1186 = n1185 ? i_line_idx : i_fill_line_idx;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk)
    n1187 <= n1186;
  initial
    n1187 = 4'b0000;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1188 = ~n40;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1189 = n337 & n1188;
  /* TG68K_Cache_030.vhd:142:5  */
  assign n1190 = n1189 ? i_tag : i_fill_tag;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk)
    n1191 <= n1190;
  initial
    n1191 = 24'b000000000000000000000000;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1192 = ~n405;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1193 = n672 & n1192;
  /* TG68K_Cache_030.vhd:232:5  */
  assign n1194 = n1193 ? n867 : d_fill_line_idx;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk)
    n1195 <= n1194;
  initial
    n1195 = 4'b0000;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1196 = ~n405;
  /* TG68K_Cache_030.vhd:223:3  */
  assign n1197 = n672 & n1196;
  /* TG68K_Cache_030.vhd:232:5  */
  assign n1198 = n1197 ? n868 : d_fill_tag;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk)
    n1199 <= n1198;
  initial
    n1199 = 24'b000000000000000000000000;
  /* TG68K_Cache_030.vhd:142:5  */
  assign n1200 = n334 ? n324 : n1201;
  /* TG68K_Cache_030.vhd:142:5  */
  always @(posedge clk or posedge n40)
    if (n40)
      n1201 <= 32'b00000000000000000000000000000000;
    else
      n1201 <= n1200;
  /* TG68K_Cache_030.vhd:232:5  */
  assign n1202 = n672 ? n864 : n1203;
  /* TG68K_Cache_030.vhd:232:5  */
  always @(posedge clk or posedge n405)
    if (n405)
      n1203 <= 32'b00000000000000000000000000000000;
    else
      n1203 <= n1202;
  /* TG68K_Cache_030.vhd:216:28  */
  reg [31:0] i_data_array_n1[15:0] ; // memory
  assign n1207 = i_data_array_n1[i_line_idx];
  always @(posedge clk)
    if (n1166)
      i_data_array_n1[i_fill_line_idx] <= n1208;
  /* TG68K_Cache_030.vhd:216:28  */
  reg [31:0] i_data_array_n2[15:0] ; // memory
  assign n1206 = i_data_array_n2[i_line_idx];
  always @(posedge clk)
    if (n1166)
      i_data_array_n2[i_fill_line_idx] <= n1210;
  /* TG68K_Cache_030.vhd:217:28  */
  reg [31:0] i_data_array_n3[15:0] ; // memory
  assign n1205 = i_data_array_n3[i_line_idx];
  always @(posedge clk)
    if (n1166)
      i_data_array_n3[i_fill_line_idx] <= n1212;
  /* TG68K_Cache_030.vhd:217:28  */
  reg [31:0] i_data_array_n4[15:0] ; // memory
  assign n1204 = i_data_array_n4[i_line_idx];
  always @(posedge clk)
    if (n1166)
      i_data_array_n4[i_fill_line_idx] <= n1214;
  /* TG68K_Cache_030.vhd:219:28  */
  /* TG68K_Cache_030.vhd:218:28  */
  /* TG68K_Cache_030.vhd:217:28  */
  /* TG68K_Cache_030.vhd:216:28  */
  /* TG68K_Cache_030.vhd:145:22  */
  assign n1208 = i_fill_data[31:0]; // extract
  /* TG68K_Cache_030.vhd:216:39  */
  /* TG68K_Cache_030.vhd:217:39  */
  assign n1210 = i_fill_data[63:32]; // extract
  /* TG68K_Cache_030.vhd:218:39  */
  /* TG68K_Cache_030.vhd:219:39  */
  assign n1212 = i_fill_data[95:64]; // extract
  /* TG68K_Cache_030.vhd:218:28  */
  /* TG68K_Cache_030.vhd:218:28  */
  assign n1214 = i_fill_data[127:96]; // extract
  /* TG68K_Cache_030.vhd:219:28  */
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1216 = n67[3]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1217 = ~n1216;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1218 = n67[2]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1219 = ~n1218;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1220 = n1217 & n1219;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1221 = n1217 & n1218;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1222 = n1216 & n1219;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1223 = n1216 & n1218;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1224 = n67[1]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1225 = ~n1224;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1226 = n1220 & n1225;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1227 = n1220 & n1224;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1228 = n1221 & n1225;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1229 = n1221 & n1224;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1230 = n1222 & n1225;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1231 = n1222 & n1224;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1232 = n1223 & n1225;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1233 = n1223 & n1224;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1234 = n67[0]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1235 = ~n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1236 = n1226 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1237 = n1226 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1238 = n1227 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1239 = n1227 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1240 = n1228 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1241 = n1228 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1242 = n1229 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1243 = n1229 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1244 = n1230 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1245 = n1230 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1246 = n1231 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1247 = n1231 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1248 = n1232 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1249 = n1232 & n1234;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1250 = n1233 & n1235;
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1251 = n1233 & n1234;
  assign n1252 = i_valid_array[0]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1253 = n1236 ? 1'b1 : n1252;
  /* TG68K_Cache_030.vhd:142:5  */
  assign n1254 = i_valid_array[1]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1255 = n1237 ? 1'b1 : n1254;
  /* TG68K_Cache_030.vhd:142:5  */
  assign n1256 = i_valid_array[2]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1257 = n1238 ? 1'b1 : n1256;
  /* TG68K_Cache_030.vhd:133:3  */
  assign n1258 = i_valid_array[3]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1259 = n1239 ? 1'b1 : n1258;
  /* TG68K_Cache_030.vhd:120:17  */
  assign n1260 = i_valid_array[4]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1261 = n1240 ? 1'b1 : n1260;
  /* TG68K_Cache_030.vhd:225:5  */
  assign n1262 = i_valid_array[5]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1263 = n1241 ? 1'b1 : n1262;
  assign n1264 = i_valid_array[6]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1265 = n1242 ? 1'b1 : n1264;
  assign n1266 = i_valid_array[7]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1267 = n1243 ? 1'b1 : n1266;
  assign n1268 = i_valid_array[8]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1269 = n1244 ? 1'b1 : n1268;
  assign n1270 = i_valid_array[9]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1271 = n1245 ? 1'b1 : n1270;
  assign n1272 = i_valid_array[10]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1273 = n1246 ? 1'b1 : n1272;
  assign n1274 = i_valid_array[11]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1275 = n1247 ? 1'b1 : n1274;
  assign n1276 = i_valid_array[12]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1277 = n1248 ? 1'b1 : n1276;
  assign n1278 = i_valid_array[13]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1279 = n1249 ? 1'b1 : n1278;
  assign n1280 = i_valid_array[14]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1281 = n1250 ? 1'b1 : n1280;
  assign n1282 = i_valid_array[15]; // extract
  /* TG68K_Cache_030.vhd:147:9  */
  assign n1283 = n1251 ? 1'b1 : n1282;
  assign n1284 = {n1283, n1281, n1279, n1277, n1275, n1273, n1271, n1269, n1267, n1265, n1263, n1261, n1259, n1257, n1255, n1253};
  /* TG68K_Cache_030.vhd:170:30  */
  assign n1285 = i_valid_array[n237 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:171:28  */
  assign n1286 = i_tag_array[n241 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1287 = n247[3]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1288 = ~n1287;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1289 = n247[2]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1290 = ~n1289;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1291 = n1288 & n1290;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1292 = n1288 & n1289;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1293 = n1287 & n1290;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1294 = n1287 & n1289;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1295 = n247[1]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1296 = ~n1295;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1297 = n1291 & n1296;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1298 = n1291 & n1295;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1299 = n1292 & n1296;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1300 = n1292 & n1295;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1301 = n1293 & n1296;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1302 = n1293 & n1295;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1303 = n1294 & n1296;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1304 = n1294 & n1295;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1305 = n247[0]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1306 = ~n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1307 = n1297 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1308 = n1297 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1309 = n1298 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1310 = n1298 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1311 = n1299 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1312 = n1299 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1313 = n1300 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1314 = n1300 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1315 = n1301 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1316 = n1301 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1317 = n1302 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1318 = n1302 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1319 = n1303 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1320 = n1303 & n1305;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1321 = n1304 & n1306;
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1322 = n1304 & n1305;
  assign n1323 = n73[0]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1324 = n1307 ? 1'b0 : n1323;
  assign n1325 = n73[1]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1326 = n1308 ? 1'b0 : n1325;
  assign n1327 = n73[2]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1328 = n1309 ? 1'b0 : n1327;
  assign n1329 = n73[3]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1330 = n1310 ? 1'b0 : n1329;
  assign n1331 = n73[4]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1332 = n1311 ? 1'b0 : n1331;
  assign n1333 = n73[5]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1334 = n1312 ? 1'b0 : n1333;
  assign n1335 = n73[6]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1336 = n1313 ? 1'b0 : n1335;
  assign n1337 = n73[7]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1338 = n1314 ? 1'b0 : n1337;
  assign n1339 = n73[8]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1340 = n1315 ? 1'b0 : n1339;
  assign n1341 = n73[9]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1342 = n1316 ? 1'b0 : n1341;
  assign n1343 = n73[10]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1344 = n1317 ? 1'b0 : n1343;
  assign n1345 = n73[11]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1346 = n1318 ? 1'b0 : n1345;
  assign n1347 = n73[12]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1348 = n1319 ? 1'b0 : n1347;
  assign n1349 = n73[13]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1350 = n1320 ? 1'b0 : n1349;
  assign n1351 = n73[14]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1352 = n1321 ? 1'b0 : n1351;
  assign n1353 = n73[15]; // extract
  /* TG68K_Cache_030.vhd:172:15  */
  assign n1354 = n1322 ? 1'b0 : n1353;
  assign n1355 = {n1354, n1352, n1350, n1348, n1346, n1344, n1342, n1340, n1338, n1336, n1334, n1332, n1330, n1328, n1326, n1324};
  /* TG68K_Cache_030.vhd:184:26  */
  assign n1356 = i_valid_array[n311 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:184:59  */
  assign n1357 = i_tag_array[n316 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:210:36  */
  assign n1358 = i_valid_array[n364 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:210:70  */
  assign n1359 = i_tag_array[n369 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1360 = n424[3]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1361 = ~n1360;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1362 = n424[2]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1363 = ~n1362;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1364 = n1361 & n1363;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1365 = n1361 & n1362;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1366 = n1360 & n1363;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1367 = n1360 & n1362;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1368 = n424[1]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1369 = ~n1368;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1370 = n1364 & n1369;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1371 = n1364 & n1368;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1372 = n1365 & n1369;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1373 = n1365 & n1368;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1374 = n1366 & n1369;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1375 = n1366 & n1368;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1376 = n1367 & n1369;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1377 = n1367 & n1368;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1378 = n424[0]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1379 = ~n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1380 = n1370 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1381 = n1370 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1382 = n1371 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1383 = n1371 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1384 = n1372 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1385 = n1372 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1386 = n1373 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1387 = n1373 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1388 = n1374 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1389 = n1374 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1390 = n1375 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1391 = n1375 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1392 = n1376 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1393 = n1376 & n1378;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1394 = n1377 & n1379;
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1395 = n1377 & n1378;
  assign n1396 = d_data_array[127:0]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1397 = n1380 ? d_fill_data : n1396;
  assign n1398 = d_data_array[255:128]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1399 = n1381 ? d_fill_data : n1398;
  assign n1400 = d_data_array[383:256]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1401 = n1382 ? d_fill_data : n1400;
  assign n1402 = d_data_array[511:384]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1403 = n1383 ? d_fill_data : n1402;
  assign n1404 = d_data_array[639:512]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1405 = n1384 ? d_fill_data : n1404;
  assign n1406 = d_data_array[767:640]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1407 = n1385 ? d_fill_data : n1406;
  assign n1408 = d_data_array[895:768]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1409 = n1386 ? d_fill_data : n1408;
  assign n1410 = d_data_array[1023:896]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1411 = n1387 ? d_fill_data : n1410;
  assign n1412 = d_data_array[1151:1024]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1413 = n1388 ? d_fill_data : n1412;
  assign n1414 = d_data_array[1279:1152]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1415 = n1389 ? d_fill_data : n1414;
  assign n1416 = d_data_array[1407:1280]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1417 = n1390 ? d_fill_data : n1416;
  assign n1418 = d_data_array[1535:1408]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1419 = n1391 ? d_fill_data : n1418;
  assign n1420 = d_data_array[1663:1536]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1421 = n1392 ? d_fill_data : n1420;
  assign n1422 = d_data_array[1791:1664]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1423 = n1393 ? d_fill_data : n1422;
  assign n1424 = d_data_array[1919:1792]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1425 = n1394 ? d_fill_data : n1424;
  assign n1426 = d_data_array[2047:1920]; // extract
  /* TG68K_Cache_030.vhd:235:9  */
  assign n1427 = n1395 ? d_fill_data : n1426;
  assign n1428 = {n1427, n1425, n1423, n1421, n1419, n1417, n1415, n1413, n1411, n1409, n1407, n1405, n1403, n1401, n1399, n1397};
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1429 = n432[3]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1430 = ~n1429;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1431 = n432[2]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1432 = ~n1431;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1433 = n1430 & n1432;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1434 = n1430 & n1431;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1435 = n1429 & n1432;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1436 = n1429 & n1431;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1437 = n432[1]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1438 = ~n1437;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1439 = n1433 & n1438;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1440 = n1433 & n1437;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1441 = n1434 & n1438;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1442 = n1434 & n1437;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1443 = n1435 & n1438;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1444 = n1435 & n1437;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1445 = n1436 & n1438;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1446 = n1436 & n1437;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1447 = n432[0]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1448 = ~n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1449 = n1439 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1450 = n1439 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1451 = n1440 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1452 = n1440 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1453 = n1441 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1454 = n1441 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1455 = n1442 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1456 = n1442 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1457 = n1443 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1458 = n1443 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1459 = n1444 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1460 = n1444 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1461 = n1445 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1462 = n1445 & n1447;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1463 = n1446 & n1448;
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1464 = n1446 & n1447;
  assign n1465 = d_valid_array[0]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1466 = n1449 ? 1'b1 : n1465;
  assign n1467 = d_valid_array[1]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1468 = n1450 ? 1'b1 : n1467;
  assign n1469 = d_valid_array[2]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1470 = n1451 ? 1'b1 : n1469;
  assign n1471 = d_valid_array[3]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1472 = n1452 ? 1'b1 : n1471;
  assign n1473 = d_valid_array[4]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1474 = n1453 ? 1'b1 : n1473;
  assign n1475 = d_valid_array[5]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1476 = n1454 ? 1'b1 : n1475;
  assign n1477 = d_valid_array[6]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1478 = n1455 ? 1'b1 : n1477;
  assign n1479 = d_valid_array[7]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1480 = n1456 ? 1'b1 : n1479;
  assign n1481 = d_valid_array[8]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1482 = n1457 ? 1'b1 : n1481;
  assign n1483 = d_valid_array[9]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1484 = n1458 ? 1'b1 : n1483;
  assign n1485 = d_valid_array[10]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1486 = n1459 ? 1'b1 : n1485;
  assign n1487 = d_valid_array[11]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1488 = n1460 ? 1'b1 : n1487;
  assign n1489 = d_valid_array[12]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1490 = n1461 ? 1'b1 : n1489;
  assign n1491 = d_valid_array[13]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1492 = n1462 ? 1'b1 : n1491;
  assign n1493 = d_valid_array[14]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1494 = n1463 ? 1'b1 : n1493;
  assign n1495 = d_valid_array[15]; // extract
  /* TG68K_Cache_030.vhd:237:9  */
  assign n1496 = n1464 ? 1'b1 : n1495;
  assign n1497 = {n1496, n1494, n1492, n1490, n1488, n1486, n1484, n1482, n1480, n1478, n1476, n1474, n1472, n1470, n1468, n1466};
  /* TG68K_Cache_030.vhd:260:30  */
  assign n1498 = d_valid_array[n602 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:261:28  */
  assign n1499 = d_tag_array[n606 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1500 = n612[3]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1501 = ~n1500;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1502 = n612[2]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1503 = ~n1502;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1504 = n1501 & n1503;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1505 = n1501 & n1502;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1506 = n1500 & n1503;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1507 = n1500 & n1502;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1508 = n612[1]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1509 = ~n1508;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1510 = n1504 & n1509;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1511 = n1504 & n1508;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1512 = n1505 & n1509;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1513 = n1505 & n1508;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1514 = n1506 & n1509;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1515 = n1506 & n1508;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1516 = n1507 & n1509;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1517 = n1507 & n1508;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1518 = n612[0]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1519 = ~n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1520 = n1510 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1521 = n1510 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1522 = n1511 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1523 = n1511 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1524 = n1512 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1525 = n1512 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1526 = n1513 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1527 = n1513 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1528 = n1514 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1529 = n1514 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1530 = n1515 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1531 = n1515 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1532 = n1516 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1533 = n1516 & n1518;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1534 = n1517 & n1519;
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1535 = n1517 & n1518;
  assign n1536 = n438[0]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1537 = n1520 ? 1'b0 : n1536;
  assign n1538 = n438[1]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1539 = n1521 ? 1'b0 : n1538;
  assign n1540 = n438[2]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1541 = n1522 ? 1'b0 : n1540;
  assign n1542 = n438[3]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1543 = n1523 ? 1'b0 : n1542;
  assign n1544 = n438[4]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1545 = n1524 ? 1'b0 : n1544;
  assign n1546 = n438[5]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1547 = n1525 ? 1'b0 : n1546;
  assign n1548 = n438[6]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1549 = n1526 ? 1'b0 : n1548;
  assign n1550 = n438[7]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1551 = n1527 ? 1'b0 : n1550;
  assign n1552 = n438[8]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1553 = n1528 ? 1'b0 : n1552;
  assign n1554 = n438[9]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1555 = n1529 ? 1'b0 : n1554;
  assign n1556 = n438[10]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1557 = n1530 ? 1'b0 : n1556;
  assign n1558 = n438[11]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1559 = n1531 ? 1'b0 : n1558;
  assign n1560 = n438[12]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1561 = n1532 ? 1'b0 : n1560;
  assign n1562 = n438[13]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1563 = n1533 ? 1'b0 : n1562;
  assign n1564 = n438[14]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1565 = n1534 ? 1'b0 : n1564;
  assign n1566 = n438[15]; // extract
  /* TG68K_Cache_030.vhd:262:15  */
  assign n1567 = n1535 ? 1'b0 : n1566;
  assign n1568 = {n1567, n1565, n1563, n1561, n1559, n1557, n1555, n1553, n1551, n1549, n1547, n1545, n1543, n1541, n1539, n1537};
  /* TG68K_Cache_030.vhd:272:41  */
  assign n1569 = d_valid_array[n674 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:272:75  */
  assign n1570 = d_tag_array[n679 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1571 = n686[3]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1572 = ~n1571;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1573 = n686[2]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1574 = ~n1573;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1575 = n1572 & n1574;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1576 = n1572 & n1573;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1577 = n1571 & n1574;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1578 = n1571 & n1573;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1579 = n686[1]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1580 = ~n1579;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1581 = n1575 & n1580;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1582 = n1575 & n1579;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1583 = n1576 & n1580;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1584 = n1576 & n1579;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1585 = n1577 & n1580;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1586 = n1577 & n1579;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1587 = n1578 & n1580;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1588 = n1578 & n1579;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1589 = n686[0]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1590 = ~n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1591 = n1581 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1592 = n1581 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1593 = n1582 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1594 = n1582 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1595 = n1583 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1596 = n1583 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1597 = n1584 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1598 = n1584 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1599 = n1585 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1600 = n1585 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1601 = n1586 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1602 = n1586 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1603 = n1587 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1604 = n1587 & n1589;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1605 = n1588 & n1590;
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1606 = n1588 & n1589;
  assign n1607 = n436[7:0]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1608 = n1591 ? n688 : n1607;
  assign n1609 = n436[127:8]; // extract
  assign n1610 = n436[135:128]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1611 = n1592 ? n688 : n1610;
  assign n1612 = n436[255:136]; // extract
  assign n1613 = n436[263:256]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1614 = n1593 ? n688 : n1613;
  assign n1615 = n436[383:264]; // extract
  assign n1616 = n436[391:384]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1617 = n1594 ? n688 : n1616;
  assign n1618 = n436[511:392]; // extract
  assign n1619 = n436[519:512]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1620 = n1595 ? n688 : n1619;
  assign n1621 = n436[639:520]; // extract
  assign n1622 = n436[647:640]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1623 = n1596 ? n688 : n1622;
  assign n1624 = n436[767:648]; // extract
  assign n1625 = n436[775:768]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1626 = n1597 ? n688 : n1625;
  assign n1627 = n436[895:776]; // extract
  assign n1628 = n436[903:896]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1629 = n1598 ? n688 : n1628;
  assign n1630 = n436[1023:904]; // extract
  assign n1631 = n436[1031:1024]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1632 = n1599 ? n688 : n1631;
  assign n1633 = n436[1151:1032]; // extract
  assign n1634 = n436[1159:1152]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1635 = n1600 ? n688 : n1634;
  assign n1636 = n436[1279:1160]; // extract
  assign n1637 = n436[1287:1280]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1638 = n1601 ? n688 : n1637;
  assign n1639 = n436[1407:1288]; // extract
  assign n1640 = n436[1415:1408]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1641 = n1602 ? n688 : n1640;
  assign n1642 = n436[1535:1416]; // extract
  assign n1643 = n436[1543:1536]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1644 = n1603 ? n688 : n1643;
  assign n1645 = n436[1663:1544]; // extract
  assign n1646 = n436[1671:1664]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1647 = n1604 ? n688 : n1646;
  assign n1648 = n436[1791:1672]; // extract
  assign n1649 = n436[1799:1792]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1650 = n1605 ? n688 : n1649;
  assign n1651 = n436[1919:1800]; // extract
  assign n1652 = n436[1927:1920]; // extract
  /* TG68K_Cache_030.vhd:276:37  */
  assign n1653 = n1606 ? n688 : n1652;
  assign n1654 = n436[2047:1928]; // extract
  assign n1655 = {n1654, n1653, n1651, n1650, n1648, n1647, n1645, n1644, n1642, n1641, n1639, n1638, n1636, n1635, n1633, n1632, n1630, n1629, n1627, n1626, n1624, n1623, n1621, n1620, n1618, n1617, n1615, n1614, n1612, n1611, n1609, n1608};
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1656 = n693[3]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1657 = ~n1656;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1658 = n693[2]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1659 = ~n1658;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1660 = n1657 & n1659;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1661 = n1657 & n1658;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1662 = n1656 & n1659;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1663 = n1656 & n1658;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1664 = n693[1]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1665 = ~n1664;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1666 = n1660 & n1665;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1667 = n1660 & n1664;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1668 = n1661 & n1665;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1669 = n1661 & n1664;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1670 = n1662 & n1665;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1671 = n1662 & n1664;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1672 = n1663 & n1665;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1673 = n1663 & n1664;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1674 = n693[0]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1675 = ~n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1676 = n1666 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1677 = n1666 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1678 = n1667 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1679 = n1667 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1680 = n1668 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1681 = n1668 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1682 = n1669 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1683 = n1669 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1684 = n1670 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1685 = n1670 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1686 = n1671 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1687 = n1671 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1688 = n1672 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1689 = n1672 & n1674;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1690 = n1673 & n1675;
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1691 = n1673 & n1674;
  assign n1692 = n690[7:0]; // extract
  assign n1693 = n690[15:8]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1694 = n1676 ? n695 : n1693;
  assign n1695 = n690[135:16]; // extract
  assign n1696 = n690[143:136]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1697 = n1677 ? n695 : n1696;
  assign n1698 = n690[263:144]; // extract
  assign n1699 = n690[271:264]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1700 = n1678 ? n695 : n1699;
  assign n1701 = n690[391:272]; // extract
  assign n1702 = n690[399:392]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1703 = n1679 ? n695 : n1702;
  assign n1704 = n690[519:400]; // extract
  assign n1705 = n690[527:520]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1706 = n1680 ? n695 : n1705;
  assign n1707 = n690[647:528]; // extract
  assign n1708 = n690[655:648]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1709 = n1681 ? n695 : n1708;
  assign n1710 = n690[775:656]; // extract
  assign n1711 = n690[783:776]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1712 = n1682 ? n695 : n1711;
  assign n1713 = n690[903:784]; // extract
  assign n1714 = n690[911:904]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1715 = n1683 ? n695 : n1714;
  assign n1716 = n690[1031:912]; // extract
  assign n1717 = n690[1039:1032]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1718 = n1684 ? n695 : n1717;
  assign n1719 = n690[1159:1040]; // extract
  assign n1720 = n690[1167:1160]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1721 = n1685 ? n695 : n1720;
  assign n1722 = n690[1287:1168]; // extract
  assign n1723 = n690[1295:1288]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1724 = n1686 ? n695 : n1723;
  assign n1725 = n690[1415:1296]; // extract
  assign n1726 = n690[1423:1416]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1727 = n1687 ? n695 : n1726;
  assign n1728 = n690[1543:1424]; // extract
  assign n1729 = n690[1551:1544]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1730 = n1688 ? n695 : n1729;
  assign n1731 = n690[1671:1552]; // extract
  assign n1732 = n690[1679:1672]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1733 = n1689 ? n695 : n1732;
  assign n1734 = n690[1799:1680]; // extract
  assign n1735 = n690[1807:1800]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1736 = n1690 ? n695 : n1735;
  assign n1737 = n690[1927:1808]; // extract
  assign n1738 = n690[1935:1928]; // extract
  /* TG68K_Cache_030.vhd:277:37  */
  assign n1739 = n1691 ? n695 : n1738;
  assign n1740 = n690[2047:1936]; // extract
  assign n1741 = {n1740, n1739, n1737, n1736, n1734, n1733, n1731, n1730, n1728, n1727, n1725, n1724, n1722, n1721, n1719, n1718, n1716, n1715, n1713, n1712, n1710, n1709, n1707, n1706, n1704, n1703, n1701, n1700, n1698, n1697, n1695, n1694, n1692};
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1742 = n700[3]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1743 = ~n1742;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1744 = n700[2]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1745 = ~n1744;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1746 = n1743 & n1745;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1747 = n1743 & n1744;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1748 = n1742 & n1745;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1749 = n1742 & n1744;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1750 = n700[1]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1751 = ~n1750;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1752 = n1746 & n1751;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1753 = n1746 & n1750;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1754 = n1747 & n1751;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1755 = n1747 & n1750;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1756 = n1748 & n1751;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1757 = n1748 & n1750;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1758 = n1749 & n1751;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1759 = n1749 & n1750;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1760 = n700[0]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1761 = ~n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1762 = n1752 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1763 = n1752 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1764 = n1753 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1765 = n1753 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1766 = n1754 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1767 = n1754 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1768 = n1755 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1769 = n1755 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1770 = n1756 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1771 = n1756 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1772 = n1757 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1773 = n1757 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1774 = n1758 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1775 = n1758 & n1760;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1776 = n1759 & n1761;
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1777 = n1759 & n1760;
  assign n1778 = n697[15:0]; // extract
  assign n1779 = n697[23:16]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1780 = n1762 ? n702 : n1779;
  assign n1781 = n697[143:24]; // extract
  assign n1782 = n697[151:144]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1783 = n1763 ? n702 : n1782;
  assign n1784 = n697[271:152]; // extract
  assign n1785 = n697[279:272]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1786 = n1764 ? n702 : n1785;
  assign n1787 = n697[399:280]; // extract
  assign n1788 = n697[407:400]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1789 = n1765 ? n702 : n1788;
  assign n1790 = n697[527:408]; // extract
  assign n1791 = n697[535:528]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1792 = n1766 ? n702 : n1791;
  assign n1793 = n697[655:536]; // extract
  assign n1794 = n697[663:656]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1795 = n1767 ? n702 : n1794;
  assign n1796 = n697[783:664]; // extract
  assign n1797 = n697[791:784]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1798 = n1768 ? n702 : n1797;
  assign n1799 = n697[911:792]; // extract
  assign n1800 = n697[919:912]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1801 = n1769 ? n702 : n1800;
  assign n1802 = n697[1039:920]; // extract
  assign n1803 = n697[1047:1040]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1804 = n1770 ? n702 : n1803;
  assign n1805 = n697[1167:1048]; // extract
  assign n1806 = n697[1175:1168]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1807 = n1771 ? n702 : n1806;
  assign n1808 = n697[1295:1176]; // extract
  assign n1809 = n697[1303:1296]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1810 = n1772 ? n702 : n1809;
  assign n1811 = n697[1423:1304]; // extract
  assign n1812 = n697[1431:1424]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1813 = n1773 ? n702 : n1812;
  assign n1814 = n697[1551:1432]; // extract
  assign n1815 = n697[1559:1552]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1816 = n1774 ? n702 : n1815;
  assign n1817 = n697[1679:1560]; // extract
  assign n1818 = n697[1687:1680]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1819 = n1775 ? n702 : n1818;
  assign n1820 = n697[1807:1688]; // extract
  assign n1821 = n697[1815:1808]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1822 = n1776 ? n702 : n1821;
  assign n1823 = n697[1935:1816]; // extract
  assign n1824 = n697[1943:1936]; // extract
  /* TG68K_Cache_030.vhd:278:37  */
  assign n1825 = n1777 ? n702 : n1824;
  assign n1826 = n697[2047:1944]; // extract
  assign n1827 = {n1826, n1825, n1823, n1822, n1820, n1819, n1817, n1816, n1814, n1813, n1811, n1810, n1808, n1807, n1805, n1804, n1802, n1801, n1799, n1798, n1796, n1795, n1793, n1792, n1790, n1789, n1787, n1786, n1784, n1783, n1781, n1780, n1778};
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1828 = n707[3]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1829 = ~n1828;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1830 = n707[2]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1831 = ~n1830;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1832 = n1829 & n1831;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1833 = n1829 & n1830;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1834 = n1828 & n1831;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1835 = n1828 & n1830;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1836 = n707[1]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1837 = ~n1836;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1838 = n1832 & n1837;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1839 = n1832 & n1836;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1840 = n1833 & n1837;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1841 = n1833 & n1836;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1842 = n1834 & n1837;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1843 = n1834 & n1836;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1844 = n1835 & n1837;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1845 = n1835 & n1836;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1846 = n707[0]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1847 = ~n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1848 = n1838 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1849 = n1838 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1850 = n1839 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1851 = n1839 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1852 = n1840 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1853 = n1840 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1854 = n1841 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1855 = n1841 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1856 = n1842 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1857 = n1842 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1858 = n1843 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1859 = n1843 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1860 = n1844 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1861 = n1844 & n1846;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1862 = n1845 & n1847;
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1863 = n1845 & n1846;
  assign n1864 = n704[23:0]; // extract
  assign n1865 = n704[31:24]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1866 = n1848 ? n709 : n1865;
  assign n1867 = n704[151:32]; // extract
  assign n1868 = n704[159:152]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1869 = n1849 ? n709 : n1868;
  assign n1870 = n704[279:160]; // extract
  assign n1871 = n704[287:280]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1872 = n1850 ? n709 : n1871;
  assign n1873 = n704[407:288]; // extract
  assign n1874 = n704[415:408]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1875 = n1851 ? n709 : n1874;
  assign n1876 = n704[535:416]; // extract
  assign n1877 = n704[543:536]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1878 = n1852 ? n709 : n1877;
  assign n1879 = n704[663:544]; // extract
  assign n1880 = n704[671:664]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1881 = n1853 ? n709 : n1880;
  assign n1882 = n704[791:672]; // extract
  assign n1883 = n704[799:792]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1884 = n1854 ? n709 : n1883;
  assign n1885 = n704[919:800]; // extract
  assign n1886 = n704[927:920]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1887 = n1855 ? n709 : n1886;
  assign n1888 = n704[1047:928]; // extract
  assign n1889 = n704[1055:1048]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1890 = n1856 ? n709 : n1889;
  assign n1891 = n704[1175:1056]; // extract
  assign n1892 = n704[1183:1176]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1893 = n1857 ? n709 : n1892;
  assign n1894 = n704[1303:1184]; // extract
  assign n1895 = n704[1311:1304]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1896 = n1858 ? n709 : n1895;
  assign n1897 = n704[1431:1312]; // extract
  assign n1898 = n704[1439:1432]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1899 = n1859 ? n709 : n1898;
  assign n1900 = n704[1559:1440]; // extract
  assign n1901 = n704[1567:1560]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1902 = n1860 ? n709 : n1901;
  assign n1903 = n704[1687:1568]; // extract
  assign n1904 = n704[1695:1688]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1905 = n1861 ? n709 : n1904;
  assign n1906 = n704[1815:1696]; // extract
  assign n1907 = n704[1823:1816]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1908 = n1862 ? n709 : n1907;
  assign n1909 = n704[1943:1824]; // extract
  assign n1910 = n704[1951:1944]; // extract
  /* TG68K_Cache_030.vhd:279:37  */
  assign n1911 = n1863 ? n709 : n1910;
  assign n1912 = n704[2047:1952]; // extract
  assign n1913 = {n1912, n1911, n1909, n1908, n1906, n1905, n1903, n1902, n1900, n1899, n1897, n1896, n1894, n1893, n1891, n1890, n1888, n1887, n1885, n1884, n1882, n1881, n1879, n1878, n1876, n1875, n1873, n1872, n1870, n1869, n1867, n1866, n1864};
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1914 = n716[3]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1915 = ~n1914;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1916 = n716[2]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1917 = ~n1916;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1918 = n1915 & n1917;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1919 = n1915 & n1916;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1920 = n1914 & n1917;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1921 = n1914 & n1916;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1922 = n716[1]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1923 = ~n1922;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1924 = n1918 & n1923;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1925 = n1918 & n1922;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1926 = n1919 & n1923;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1927 = n1919 & n1922;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1928 = n1920 & n1923;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1929 = n1920 & n1922;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1930 = n1921 & n1923;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1931 = n1921 & n1922;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1932 = n716[0]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1933 = ~n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1934 = n1924 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1935 = n1924 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1936 = n1925 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1937 = n1925 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1938 = n1926 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1939 = n1926 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1940 = n1927 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1941 = n1927 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1942 = n1928 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1943 = n1928 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1944 = n1929 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1945 = n1929 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1946 = n1930 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1947 = n1930 & n1932;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1948 = n1931 & n1933;
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1949 = n1931 & n1932;
  assign n1950 = n436[31:0]; // extract
  assign n1951 = n436[39:32]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1952 = n1934 ? n718 : n1951;
  assign n1953 = n436[159:40]; // extract
  assign n1954 = n436[167:160]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1955 = n1935 ? n718 : n1954;
  assign n1956 = n436[287:168]; // extract
  assign n1957 = n436[295:288]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1958 = n1936 ? n718 : n1957;
  assign n1959 = n436[415:296]; // extract
  assign n1960 = n436[423:416]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1961 = n1937 ? n718 : n1960;
  assign n1962 = n436[543:424]; // extract
  assign n1963 = n436[551:544]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1964 = n1938 ? n718 : n1963;
  assign n1965 = n436[671:552]; // extract
  assign n1966 = n436[679:672]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1967 = n1939 ? n718 : n1966;
  assign n1968 = n436[799:680]; // extract
  assign n1969 = n436[807:800]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1970 = n1940 ? n718 : n1969;
  assign n1971 = n436[927:808]; // extract
  assign n1972 = n436[935:928]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1973 = n1941 ? n718 : n1972;
  assign n1974 = n436[1055:936]; // extract
  assign n1975 = n436[1063:1056]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1976 = n1942 ? n718 : n1975;
  assign n1977 = n436[1183:1064]; // extract
  assign n1978 = n436[1191:1184]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1979 = n1943 ? n718 : n1978;
  assign n1980 = n436[1311:1192]; // extract
  assign n1981 = n436[1319:1312]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1982 = n1944 ? n718 : n1981;
  assign n1983 = n436[1439:1320]; // extract
  assign n1984 = n436[1447:1440]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1985 = n1945 ? n718 : n1984;
  assign n1986 = n436[1567:1448]; // extract
  assign n1987 = n436[1575:1568]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1988 = n1946 ? n718 : n1987;
  assign n1989 = n436[1695:1576]; // extract
  assign n1990 = n436[1703:1696]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1991 = n1947 ? n718 : n1990;
  assign n1992 = n436[1823:1704]; // extract
  assign n1993 = n436[1831:1824]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1994 = n1948 ? n718 : n1993;
  assign n1995 = n436[1951:1832]; // extract
  assign n1996 = n436[1959:1952]; // extract
  /* TG68K_Cache_030.vhd:281:37  */
  assign n1997 = n1949 ? n718 : n1996;
  assign n1998 = n436[2047:1960]; // extract
  assign n1999 = {n1998, n1997, n1995, n1994, n1992, n1991, n1989, n1988, n1986, n1985, n1983, n1982, n1980, n1979, n1977, n1976, n1974, n1973, n1971, n1970, n1968, n1967, n1965, n1964, n1962, n1961, n1959, n1958, n1956, n1955, n1953, n1952, n1950};
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2000 = n723[3]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2001 = ~n2000;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2002 = n723[2]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2003 = ~n2002;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2004 = n2001 & n2003;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2005 = n2001 & n2002;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2006 = n2000 & n2003;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2007 = n2000 & n2002;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2008 = n723[1]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2009 = ~n2008;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2010 = n2004 & n2009;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2011 = n2004 & n2008;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2012 = n2005 & n2009;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2013 = n2005 & n2008;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2014 = n2006 & n2009;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2015 = n2006 & n2008;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2016 = n2007 & n2009;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2017 = n2007 & n2008;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2018 = n723[0]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2019 = ~n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2020 = n2010 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2021 = n2010 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2022 = n2011 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2023 = n2011 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2024 = n2012 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2025 = n2012 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2026 = n2013 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2027 = n2013 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2028 = n2014 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2029 = n2014 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2030 = n2015 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2031 = n2015 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2032 = n2016 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2033 = n2016 & n2018;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2034 = n2017 & n2019;
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2035 = n2017 & n2018;
  assign n2036 = n720[39:0]; // extract
  assign n2037 = n720[47:40]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2038 = n2020 ? n725 : n2037;
  assign n2039 = n720[167:48]; // extract
  assign n2040 = n720[175:168]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2041 = n2021 ? n725 : n2040;
  assign n2042 = n720[295:176]; // extract
  assign n2043 = n720[303:296]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2044 = n2022 ? n725 : n2043;
  assign n2045 = n720[423:304]; // extract
  assign n2046 = n720[431:424]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2047 = n2023 ? n725 : n2046;
  assign n2048 = n720[551:432]; // extract
  assign n2049 = n720[559:552]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2050 = n2024 ? n725 : n2049;
  assign n2051 = n720[679:560]; // extract
  assign n2052 = n720[687:680]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2053 = n2025 ? n725 : n2052;
  assign n2054 = n720[807:688]; // extract
  assign n2055 = n720[815:808]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2056 = n2026 ? n725 : n2055;
  assign n2057 = n720[935:816]; // extract
  assign n2058 = n720[943:936]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2059 = n2027 ? n725 : n2058;
  assign n2060 = n720[1063:944]; // extract
  assign n2061 = n720[1071:1064]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2062 = n2028 ? n725 : n2061;
  assign n2063 = n720[1191:1072]; // extract
  assign n2064 = n720[1199:1192]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2065 = n2029 ? n725 : n2064;
  assign n2066 = n720[1319:1200]; // extract
  assign n2067 = n720[1327:1320]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2068 = n2030 ? n725 : n2067;
  assign n2069 = n720[1447:1328]; // extract
  assign n2070 = n720[1455:1448]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2071 = n2031 ? n725 : n2070;
  assign n2072 = n720[1575:1456]; // extract
  assign n2073 = n720[1583:1576]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2074 = n2032 ? n725 : n2073;
  assign n2075 = n720[1703:1584]; // extract
  assign n2076 = n720[1711:1704]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2077 = n2033 ? n725 : n2076;
  assign n2078 = n720[1831:1712]; // extract
  assign n2079 = n720[1839:1832]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2080 = n2034 ? n725 : n2079;
  assign n2081 = n720[1959:1840]; // extract
  assign n2082 = n720[1967:1960]; // extract
  /* TG68K_Cache_030.vhd:282:37  */
  assign n2083 = n2035 ? n725 : n2082;
  assign n2084 = n720[2047:1968]; // extract
  assign n2085 = {n2084, n2083, n2081, n2080, n2078, n2077, n2075, n2074, n2072, n2071, n2069, n2068, n2066, n2065, n2063, n2062, n2060, n2059, n2057, n2056, n2054, n2053, n2051, n2050, n2048, n2047, n2045, n2044, n2042, n2041, n2039, n2038, n2036};
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2086 = n730[3]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2087 = ~n2086;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2088 = n730[2]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2089 = ~n2088;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2090 = n2087 & n2089;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2091 = n2087 & n2088;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2092 = n2086 & n2089;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2093 = n2086 & n2088;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2094 = n730[1]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2095 = ~n2094;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2096 = n2090 & n2095;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2097 = n2090 & n2094;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2098 = n2091 & n2095;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2099 = n2091 & n2094;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2100 = n2092 & n2095;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2101 = n2092 & n2094;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2102 = n2093 & n2095;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2103 = n2093 & n2094;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2104 = n730[0]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2105 = ~n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2106 = n2096 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2107 = n2096 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2108 = n2097 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2109 = n2097 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2110 = n2098 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2111 = n2098 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2112 = n2099 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2113 = n2099 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2114 = n2100 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2115 = n2100 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2116 = n2101 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2117 = n2101 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2118 = n2102 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2119 = n2102 & n2104;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2120 = n2103 & n2105;
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2121 = n2103 & n2104;
  assign n2122 = n727[47:0]; // extract
  assign n2123 = n727[55:48]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2124 = n2106 ? n732 : n2123;
  assign n2125 = n727[175:56]; // extract
  assign n2126 = n727[183:176]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2127 = n2107 ? n732 : n2126;
  assign n2128 = n727[303:184]; // extract
  assign n2129 = n727[311:304]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2130 = n2108 ? n732 : n2129;
  assign n2131 = n727[431:312]; // extract
  assign n2132 = n727[439:432]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2133 = n2109 ? n732 : n2132;
  assign n2134 = n727[559:440]; // extract
  assign n2135 = n727[567:560]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2136 = n2110 ? n732 : n2135;
  assign n2137 = n727[687:568]; // extract
  assign n2138 = n727[695:688]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2139 = n2111 ? n732 : n2138;
  assign n2140 = n727[815:696]; // extract
  assign n2141 = n727[823:816]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2142 = n2112 ? n732 : n2141;
  assign n2143 = n727[943:824]; // extract
  assign n2144 = n727[951:944]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2145 = n2113 ? n732 : n2144;
  assign n2146 = n727[1071:952]; // extract
  assign n2147 = n727[1079:1072]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2148 = n2114 ? n732 : n2147;
  assign n2149 = n727[1199:1080]; // extract
  assign n2150 = n727[1207:1200]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2151 = n2115 ? n732 : n2150;
  assign n2152 = n727[1327:1208]; // extract
  assign n2153 = n727[1335:1328]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2154 = n2116 ? n732 : n2153;
  assign n2155 = n727[1455:1336]; // extract
  assign n2156 = n727[1463:1456]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2157 = n2117 ? n732 : n2156;
  assign n2158 = n727[1583:1464]; // extract
  assign n2159 = n727[1591:1584]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2160 = n2118 ? n732 : n2159;
  assign n2161 = n727[1711:1592]; // extract
  assign n2162 = n727[1719:1712]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2163 = n2119 ? n732 : n2162;
  assign n2164 = n727[1839:1720]; // extract
  assign n2165 = n727[1847:1840]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2166 = n2120 ? n732 : n2165;
  assign n2167 = n727[1967:1848]; // extract
  assign n2168 = n727[1975:1968]; // extract
  /* TG68K_Cache_030.vhd:283:37  */
  assign n2169 = n2121 ? n732 : n2168;
  assign n2170 = n727[2047:1976]; // extract
  assign n2171 = {n2170, n2169, n2167, n2166, n2164, n2163, n2161, n2160, n2158, n2157, n2155, n2154, n2152, n2151, n2149, n2148, n2146, n2145, n2143, n2142, n2140, n2139, n2137, n2136, n2134, n2133, n2131, n2130, n2128, n2127, n2125, n2124, n2122};
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2172 = n737[3]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2173 = ~n2172;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2174 = n737[2]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2175 = ~n2174;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2176 = n2173 & n2175;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2177 = n2173 & n2174;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2178 = n2172 & n2175;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2179 = n2172 & n2174;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2180 = n737[1]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2181 = ~n2180;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2182 = n2176 & n2181;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2183 = n2176 & n2180;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2184 = n2177 & n2181;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2185 = n2177 & n2180;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2186 = n2178 & n2181;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2187 = n2178 & n2180;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2188 = n2179 & n2181;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2189 = n2179 & n2180;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2190 = n737[0]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2191 = ~n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2192 = n2182 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2193 = n2182 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2194 = n2183 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2195 = n2183 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2196 = n2184 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2197 = n2184 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2198 = n2185 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2199 = n2185 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2200 = n2186 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2201 = n2186 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2202 = n2187 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2203 = n2187 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2204 = n2188 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2205 = n2188 & n2190;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2206 = n2189 & n2191;
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2207 = n2189 & n2190;
  assign n2208 = n734[55:0]; // extract
  assign n2209 = n734[63:56]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2210 = n2192 ? n739 : n2209;
  assign n2211 = n734[183:64]; // extract
  assign n2212 = n734[191:184]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2213 = n2193 ? n739 : n2212;
  assign n2214 = n734[311:192]; // extract
  assign n2215 = n734[319:312]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2216 = n2194 ? n739 : n2215;
  assign n2217 = n734[439:320]; // extract
  assign n2218 = n734[447:440]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2219 = n2195 ? n739 : n2218;
  assign n2220 = n734[567:448]; // extract
  assign n2221 = n734[575:568]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2222 = n2196 ? n739 : n2221;
  assign n2223 = n734[695:576]; // extract
  assign n2224 = n734[703:696]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2225 = n2197 ? n739 : n2224;
  assign n2226 = n734[823:704]; // extract
  assign n2227 = n734[831:824]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2228 = n2198 ? n739 : n2227;
  assign n2229 = n734[951:832]; // extract
  assign n2230 = n734[959:952]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2231 = n2199 ? n739 : n2230;
  assign n2232 = n734[1079:960]; // extract
  assign n2233 = n734[1087:1080]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2234 = n2200 ? n739 : n2233;
  assign n2235 = n734[1207:1088]; // extract
  assign n2236 = n734[1215:1208]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2237 = n2201 ? n739 : n2236;
  assign n2238 = n734[1335:1216]; // extract
  assign n2239 = n734[1343:1336]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2240 = n2202 ? n739 : n2239;
  assign n2241 = n734[1463:1344]; // extract
  assign n2242 = n734[1471:1464]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2243 = n2203 ? n739 : n2242;
  assign n2244 = n734[1591:1472]; // extract
  assign n2245 = n734[1599:1592]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2246 = n2204 ? n739 : n2245;
  assign n2247 = n734[1719:1600]; // extract
  assign n2248 = n734[1727:1720]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2249 = n2205 ? n739 : n2248;
  assign n2250 = n734[1847:1728]; // extract
  assign n2251 = n734[1855:1848]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2252 = n2206 ? n739 : n2251;
  assign n2253 = n734[1975:1856]; // extract
  assign n2254 = n734[1983:1976]; // extract
  /* TG68K_Cache_030.vhd:284:37  */
  assign n2255 = n2207 ? n739 : n2254;
  assign n2256 = n734[2047:1984]; // extract
  assign n2257 = {n2256, n2255, n2253, n2252, n2250, n2249, n2247, n2246, n2244, n2243, n2241, n2240, n2238, n2237, n2235, n2234, n2232, n2231, n2229, n2228, n2226, n2225, n2223, n2222, n2220, n2219, n2217, n2216, n2214, n2213, n2211, n2210, n2208};
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2258 = n746[3]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2259 = ~n2258;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2260 = n746[2]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2261 = ~n2260;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2262 = n2259 & n2261;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2263 = n2259 & n2260;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2264 = n2258 & n2261;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2265 = n2258 & n2260;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2266 = n746[1]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2267 = ~n2266;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2268 = n2262 & n2267;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2269 = n2262 & n2266;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2270 = n2263 & n2267;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2271 = n2263 & n2266;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2272 = n2264 & n2267;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2273 = n2264 & n2266;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2274 = n2265 & n2267;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2275 = n2265 & n2266;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2276 = n746[0]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2277 = ~n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2278 = n2268 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2279 = n2268 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2280 = n2269 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2281 = n2269 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2282 = n2270 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2283 = n2270 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2284 = n2271 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2285 = n2271 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2286 = n2272 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2287 = n2272 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2288 = n2273 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2289 = n2273 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2290 = n2274 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2291 = n2274 & n2276;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2292 = n2275 & n2277;
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2293 = n2275 & n2276;
  assign n2294 = n436[63:0]; // extract
  assign n2295 = n436[71:64]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2296 = n2278 ? n748 : n2295;
  assign n2297 = n436[191:72]; // extract
  assign n2298 = n436[199:192]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2299 = n2279 ? n748 : n2298;
  assign n2300 = n436[319:200]; // extract
  assign n2301 = n436[327:320]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2302 = n2280 ? n748 : n2301;
  assign n2303 = n436[447:328]; // extract
  assign n2304 = n436[455:448]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2305 = n2281 ? n748 : n2304;
  assign n2306 = n436[575:456]; // extract
  assign n2307 = n436[583:576]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2308 = n2282 ? n748 : n2307;
  assign n2309 = n436[703:584]; // extract
  assign n2310 = n436[711:704]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2311 = n2283 ? n748 : n2310;
  assign n2312 = n436[831:712]; // extract
  assign n2313 = n436[839:832]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2314 = n2284 ? n748 : n2313;
  assign n2315 = n436[959:840]; // extract
  assign n2316 = n436[967:960]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2317 = n2285 ? n748 : n2316;
  assign n2318 = n436[1087:968]; // extract
  assign n2319 = n436[1095:1088]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2320 = n2286 ? n748 : n2319;
  assign n2321 = n436[1215:1096]; // extract
  assign n2322 = n436[1223:1216]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2323 = n2287 ? n748 : n2322;
  assign n2324 = n436[1343:1224]; // extract
  assign n2325 = n436[1351:1344]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2326 = n2288 ? n748 : n2325;
  assign n2327 = n436[1471:1352]; // extract
  assign n2328 = n436[1479:1472]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2329 = n2289 ? n748 : n2328;
  assign n2330 = n436[1599:1480]; // extract
  assign n2331 = n436[1607:1600]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2332 = n2290 ? n748 : n2331;
  assign n2333 = n436[1727:1608]; // extract
  assign n2334 = n436[1735:1728]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2335 = n2291 ? n748 : n2334;
  assign n2336 = n436[1855:1736]; // extract
  assign n2337 = n436[1863:1856]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2338 = n2292 ? n748 : n2337;
  assign n2339 = n436[1983:1864]; // extract
  assign n2340 = n436[1991:1984]; // extract
  /* TG68K_Cache_030.vhd:286:37  */
  assign n2341 = n2293 ? n748 : n2340;
  assign n2342 = n436[2047:1992]; // extract
  assign n2343 = {n2342, n2341, n2339, n2338, n2336, n2335, n2333, n2332, n2330, n2329, n2327, n2326, n2324, n2323, n2321, n2320, n2318, n2317, n2315, n2314, n2312, n2311, n2309, n2308, n2306, n2305, n2303, n2302, n2300, n2299, n2297, n2296, n2294};
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2344 = n753[3]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2345 = ~n2344;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2346 = n753[2]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2347 = ~n2346;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2348 = n2345 & n2347;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2349 = n2345 & n2346;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2350 = n2344 & n2347;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2351 = n2344 & n2346;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2352 = n753[1]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2353 = ~n2352;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2354 = n2348 & n2353;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2355 = n2348 & n2352;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2356 = n2349 & n2353;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2357 = n2349 & n2352;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2358 = n2350 & n2353;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2359 = n2350 & n2352;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2360 = n2351 & n2353;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2361 = n2351 & n2352;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2362 = n753[0]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2363 = ~n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2364 = n2354 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2365 = n2354 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2366 = n2355 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2367 = n2355 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2368 = n2356 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2369 = n2356 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2370 = n2357 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2371 = n2357 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2372 = n2358 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2373 = n2358 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2374 = n2359 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2375 = n2359 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2376 = n2360 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2377 = n2360 & n2362;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2378 = n2361 & n2363;
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2379 = n2361 & n2362;
  assign n2380 = n750[71:0]; // extract
  assign n2381 = n750[79:72]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2382 = n2364 ? n755 : n2381;
  assign n2383 = n750[199:80]; // extract
  assign n2384 = n750[207:200]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2385 = n2365 ? n755 : n2384;
  assign n2386 = n750[327:208]; // extract
  assign n2387 = n750[335:328]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2388 = n2366 ? n755 : n2387;
  assign n2389 = n750[455:336]; // extract
  assign n2390 = n750[463:456]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2391 = n2367 ? n755 : n2390;
  assign n2392 = n750[583:464]; // extract
  assign n2393 = n750[591:584]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2394 = n2368 ? n755 : n2393;
  assign n2395 = n750[711:592]; // extract
  assign n2396 = n750[719:712]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2397 = n2369 ? n755 : n2396;
  assign n2398 = n750[839:720]; // extract
  assign n2399 = n750[847:840]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2400 = n2370 ? n755 : n2399;
  assign n2401 = n750[967:848]; // extract
  assign n2402 = n750[975:968]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2403 = n2371 ? n755 : n2402;
  assign n2404 = n750[1095:976]; // extract
  assign n2405 = n750[1103:1096]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2406 = n2372 ? n755 : n2405;
  assign n2407 = n750[1223:1104]; // extract
  assign n2408 = n750[1231:1224]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2409 = n2373 ? n755 : n2408;
  assign n2410 = n750[1351:1232]; // extract
  assign n2411 = n750[1359:1352]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2412 = n2374 ? n755 : n2411;
  assign n2413 = n750[1479:1360]; // extract
  assign n2414 = n750[1487:1480]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2415 = n2375 ? n755 : n2414;
  assign n2416 = n750[1607:1488]; // extract
  assign n2417 = n750[1615:1608]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2418 = n2376 ? n755 : n2417;
  assign n2419 = n750[1735:1616]; // extract
  assign n2420 = n750[1743:1736]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2421 = n2377 ? n755 : n2420;
  assign n2422 = n750[1863:1744]; // extract
  assign n2423 = n750[1871:1864]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2424 = n2378 ? n755 : n2423;
  assign n2425 = n750[1991:1872]; // extract
  assign n2426 = n750[1999:1992]; // extract
  /* TG68K_Cache_030.vhd:287:37  */
  assign n2427 = n2379 ? n755 : n2426;
  assign n2428 = n750[2047:2000]; // extract
  assign n2429 = {n2428, n2427, n2425, n2424, n2422, n2421, n2419, n2418, n2416, n2415, n2413, n2412, n2410, n2409, n2407, n2406, n2404, n2403, n2401, n2400, n2398, n2397, n2395, n2394, n2392, n2391, n2389, n2388, n2386, n2385, n2383, n2382, n2380};
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2430 = n760[3]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2431 = ~n2430;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2432 = n760[2]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2433 = ~n2432;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2434 = n2431 & n2433;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2435 = n2431 & n2432;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2436 = n2430 & n2433;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2437 = n2430 & n2432;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2438 = n760[1]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2439 = ~n2438;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2440 = n2434 & n2439;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2441 = n2434 & n2438;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2442 = n2435 & n2439;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2443 = n2435 & n2438;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2444 = n2436 & n2439;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2445 = n2436 & n2438;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2446 = n2437 & n2439;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2447 = n2437 & n2438;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2448 = n760[0]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2449 = ~n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2450 = n2440 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2451 = n2440 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2452 = n2441 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2453 = n2441 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2454 = n2442 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2455 = n2442 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2456 = n2443 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2457 = n2443 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2458 = n2444 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2459 = n2444 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2460 = n2445 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2461 = n2445 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2462 = n2446 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2463 = n2446 & n2448;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2464 = n2447 & n2449;
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2465 = n2447 & n2448;
  assign n2466 = n757[79:0]; // extract
  assign n2467 = n757[87:80]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2468 = n2450 ? n762 : n2467;
  assign n2469 = n757[207:88]; // extract
  assign n2470 = n757[215:208]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2471 = n2451 ? n762 : n2470;
  assign n2472 = n757[335:216]; // extract
  assign n2473 = n757[343:336]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2474 = n2452 ? n762 : n2473;
  assign n2475 = n757[463:344]; // extract
  assign n2476 = n757[471:464]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2477 = n2453 ? n762 : n2476;
  assign n2478 = n757[591:472]; // extract
  assign n2479 = n757[599:592]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2480 = n2454 ? n762 : n2479;
  assign n2481 = n757[719:600]; // extract
  assign n2482 = n757[727:720]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2483 = n2455 ? n762 : n2482;
  assign n2484 = n757[847:728]; // extract
  assign n2485 = n757[855:848]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2486 = n2456 ? n762 : n2485;
  assign n2487 = n757[975:856]; // extract
  assign n2488 = n757[983:976]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2489 = n2457 ? n762 : n2488;
  assign n2490 = n757[1103:984]; // extract
  assign n2491 = n757[1111:1104]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2492 = n2458 ? n762 : n2491;
  assign n2493 = n757[1231:1112]; // extract
  assign n2494 = n757[1239:1232]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2495 = n2459 ? n762 : n2494;
  assign n2496 = n757[1359:1240]; // extract
  assign n2497 = n757[1367:1360]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2498 = n2460 ? n762 : n2497;
  assign n2499 = n757[1487:1368]; // extract
  assign n2500 = n757[1495:1488]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2501 = n2461 ? n762 : n2500;
  assign n2502 = n757[1615:1496]; // extract
  assign n2503 = n757[1623:1616]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2504 = n2462 ? n762 : n2503;
  assign n2505 = n757[1743:1624]; // extract
  assign n2506 = n757[1751:1744]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2507 = n2463 ? n762 : n2506;
  assign n2508 = n757[1871:1752]; // extract
  assign n2509 = n757[1879:1872]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2510 = n2464 ? n762 : n2509;
  assign n2511 = n757[1999:1880]; // extract
  assign n2512 = n757[2007:2000]; // extract
  /* TG68K_Cache_030.vhd:288:37  */
  assign n2513 = n2465 ? n762 : n2512;
  assign n2514 = n757[2047:2008]; // extract
  assign n2515 = {n2514, n2513, n2511, n2510, n2508, n2507, n2505, n2504, n2502, n2501, n2499, n2498, n2496, n2495, n2493, n2492, n2490, n2489, n2487, n2486, n2484, n2483, n2481, n2480, n2478, n2477, n2475, n2474, n2472, n2471, n2469, n2468, n2466};
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2516 = n767[3]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2517 = ~n2516;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2518 = n767[2]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2519 = ~n2518;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2520 = n2517 & n2519;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2521 = n2517 & n2518;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2522 = n2516 & n2519;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2523 = n2516 & n2518;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2524 = n767[1]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2525 = ~n2524;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2526 = n2520 & n2525;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2527 = n2520 & n2524;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2528 = n2521 & n2525;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2529 = n2521 & n2524;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2530 = n2522 & n2525;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2531 = n2522 & n2524;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2532 = n2523 & n2525;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2533 = n2523 & n2524;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2534 = n767[0]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2535 = ~n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2536 = n2526 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2537 = n2526 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2538 = n2527 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2539 = n2527 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2540 = n2528 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2541 = n2528 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2542 = n2529 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2543 = n2529 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2544 = n2530 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2545 = n2530 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2546 = n2531 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2547 = n2531 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2548 = n2532 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2549 = n2532 & n2534;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2550 = n2533 & n2535;
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2551 = n2533 & n2534;
  assign n2552 = n764[87:0]; // extract
  assign n2553 = n764[95:88]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2554 = n2536 ? n769 : n2553;
  assign n2555 = n764[215:96]; // extract
  assign n2556 = n764[223:216]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2557 = n2537 ? n769 : n2556;
  assign n2558 = n764[343:224]; // extract
  assign n2559 = n764[351:344]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2560 = n2538 ? n769 : n2559;
  assign n2561 = n764[471:352]; // extract
  assign n2562 = n764[479:472]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2563 = n2539 ? n769 : n2562;
  assign n2564 = n764[599:480]; // extract
  assign n2565 = n764[607:600]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2566 = n2540 ? n769 : n2565;
  assign n2567 = n764[727:608]; // extract
  assign n2568 = n764[735:728]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2569 = n2541 ? n769 : n2568;
  assign n2570 = n764[855:736]; // extract
  assign n2571 = n764[863:856]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2572 = n2542 ? n769 : n2571;
  assign n2573 = n764[983:864]; // extract
  assign n2574 = n764[991:984]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2575 = n2543 ? n769 : n2574;
  assign n2576 = n764[1111:992]; // extract
  assign n2577 = n764[1119:1112]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2578 = n2544 ? n769 : n2577;
  assign n2579 = n764[1239:1120]; // extract
  assign n2580 = n764[1247:1240]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2581 = n2545 ? n769 : n2580;
  assign n2582 = n764[1367:1248]; // extract
  assign n2583 = n764[1375:1368]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2584 = n2546 ? n769 : n2583;
  assign n2585 = n764[1495:1376]; // extract
  assign n2586 = n764[1503:1496]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2587 = n2547 ? n769 : n2586;
  assign n2588 = n764[1623:1504]; // extract
  assign n2589 = n764[1631:1624]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2590 = n2548 ? n769 : n2589;
  assign n2591 = n764[1751:1632]; // extract
  assign n2592 = n764[1759:1752]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2593 = n2549 ? n769 : n2592;
  assign n2594 = n764[1879:1760]; // extract
  assign n2595 = n764[1887:1880]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2596 = n2550 ? n769 : n2595;
  assign n2597 = n764[2007:1888]; // extract
  assign n2598 = n764[2015:2008]; // extract
  /* TG68K_Cache_030.vhd:289:37  */
  assign n2599 = n2551 ? n769 : n2598;
  assign n2600 = n764[2047:2016]; // extract
  assign n2601 = {n2600, n2599, n2597, n2596, n2594, n2593, n2591, n2590, n2588, n2587, n2585, n2584, n2582, n2581, n2579, n2578, n2576, n2575, n2573, n2572, n2570, n2569, n2567, n2566, n2564, n2563, n2561, n2560, n2558, n2557, n2555, n2554, n2552};
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2602 = n776[3]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2603 = ~n2602;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2604 = n776[2]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2605 = ~n2604;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2606 = n2603 & n2605;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2607 = n2603 & n2604;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2608 = n2602 & n2605;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2609 = n2602 & n2604;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2610 = n776[1]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2611 = ~n2610;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2612 = n2606 & n2611;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2613 = n2606 & n2610;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2614 = n2607 & n2611;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2615 = n2607 & n2610;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2616 = n2608 & n2611;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2617 = n2608 & n2610;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2618 = n2609 & n2611;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2619 = n2609 & n2610;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2620 = n776[0]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2621 = ~n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2622 = n2612 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2623 = n2612 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2624 = n2613 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2625 = n2613 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2626 = n2614 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2627 = n2614 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2628 = n2615 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2629 = n2615 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2630 = n2616 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2631 = n2616 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2632 = n2617 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2633 = n2617 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2634 = n2618 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2635 = n2618 & n2620;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2636 = n2619 & n2621;
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2637 = n2619 & n2620;
  assign n2638 = n436[95:0]; // extract
  assign n2639 = n436[103:96]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2640 = n2622 ? n778 : n2639;
  assign n2641 = n436[223:104]; // extract
  assign n2642 = n436[231:224]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2643 = n2623 ? n778 : n2642;
  assign n2644 = n436[351:232]; // extract
  assign n2645 = n436[359:352]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2646 = n2624 ? n778 : n2645;
  assign n2647 = n436[479:360]; // extract
  assign n2648 = n436[487:480]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2649 = n2625 ? n778 : n2648;
  assign n2650 = n436[607:488]; // extract
  assign n2651 = n436[615:608]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2652 = n2626 ? n778 : n2651;
  assign n2653 = n436[735:616]; // extract
  assign n2654 = n436[743:736]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2655 = n2627 ? n778 : n2654;
  assign n2656 = n436[863:744]; // extract
  assign n2657 = n436[871:864]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2658 = n2628 ? n778 : n2657;
  assign n2659 = n436[991:872]; // extract
  assign n2660 = n436[999:992]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2661 = n2629 ? n778 : n2660;
  assign n2662 = n436[1119:1000]; // extract
  assign n2663 = n436[1127:1120]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2664 = n2630 ? n778 : n2663;
  assign n2665 = n436[1247:1128]; // extract
  assign n2666 = n436[1255:1248]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2667 = n2631 ? n778 : n2666;
  assign n2668 = n436[1375:1256]; // extract
  assign n2669 = n436[1383:1376]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2670 = n2632 ? n778 : n2669;
  assign n2671 = n436[1503:1384]; // extract
  assign n2672 = n436[1511:1504]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2673 = n2633 ? n778 : n2672;
  assign n2674 = n436[1631:1512]; // extract
  assign n2675 = n436[1639:1632]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2676 = n2634 ? n778 : n2675;
  assign n2677 = n436[1759:1640]; // extract
  assign n2678 = n436[1767:1760]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2679 = n2635 ? n778 : n2678;
  assign n2680 = n436[1887:1768]; // extract
  assign n2681 = n436[1895:1888]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2682 = n2636 ? n778 : n2681;
  assign n2683 = n436[2015:1896]; // extract
  assign n2684 = n436[2023:2016]; // extract
  /* TG68K_Cache_030.vhd:291:37  */
  assign n2685 = n2637 ? n778 : n2684;
  assign n2686 = n436[2047:2024]; // extract
  assign n2687 = {n2686, n2685, n2683, n2682, n2680, n2679, n2677, n2676, n2674, n2673, n2671, n2670, n2668, n2667, n2665, n2664, n2662, n2661, n2659, n2658, n2656, n2655, n2653, n2652, n2650, n2649, n2647, n2646, n2644, n2643, n2641, n2640, n2638};
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2688 = n783[3]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2689 = ~n2688;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2690 = n783[2]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2691 = ~n2690;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2692 = n2689 & n2691;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2693 = n2689 & n2690;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2694 = n2688 & n2691;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2695 = n2688 & n2690;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2696 = n783[1]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2697 = ~n2696;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2698 = n2692 & n2697;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2699 = n2692 & n2696;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2700 = n2693 & n2697;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2701 = n2693 & n2696;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2702 = n2694 & n2697;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2703 = n2694 & n2696;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2704 = n2695 & n2697;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2705 = n2695 & n2696;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2706 = n783[0]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2707 = ~n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2708 = n2698 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2709 = n2698 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2710 = n2699 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2711 = n2699 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2712 = n2700 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2713 = n2700 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2714 = n2701 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2715 = n2701 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2716 = n2702 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2717 = n2702 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2718 = n2703 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2719 = n2703 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2720 = n2704 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2721 = n2704 & n2706;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2722 = n2705 & n2707;
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2723 = n2705 & n2706;
  assign n2724 = n780[103:0]; // extract
  assign n2725 = n780[111:104]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2726 = n2708 ? n785 : n2725;
  assign n2727 = n780[231:112]; // extract
  assign n2728 = n780[239:232]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2729 = n2709 ? n785 : n2728;
  assign n2730 = n780[359:240]; // extract
  assign n2731 = n780[367:360]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2732 = n2710 ? n785 : n2731;
  assign n2733 = n780[487:368]; // extract
  assign n2734 = n780[495:488]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2735 = n2711 ? n785 : n2734;
  assign n2736 = n780[615:496]; // extract
  assign n2737 = n780[623:616]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2738 = n2712 ? n785 : n2737;
  assign n2739 = n780[743:624]; // extract
  assign n2740 = n780[751:744]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2741 = n2713 ? n785 : n2740;
  assign n2742 = n780[871:752]; // extract
  assign n2743 = n780[879:872]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2744 = n2714 ? n785 : n2743;
  assign n2745 = n780[999:880]; // extract
  assign n2746 = n780[1007:1000]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2747 = n2715 ? n785 : n2746;
  assign n2748 = n780[1127:1008]; // extract
  assign n2749 = n780[1135:1128]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2750 = n2716 ? n785 : n2749;
  assign n2751 = n780[1255:1136]; // extract
  assign n2752 = n780[1263:1256]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2753 = n2717 ? n785 : n2752;
  assign n2754 = n780[1383:1264]; // extract
  assign n2755 = n780[1391:1384]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2756 = n2718 ? n785 : n2755;
  assign n2757 = n780[1511:1392]; // extract
  assign n2758 = n780[1519:1512]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2759 = n2719 ? n785 : n2758;
  assign n2760 = n780[1639:1520]; // extract
  assign n2761 = n780[1647:1640]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2762 = n2720 ? n785 : n2761;
  assign n2763 = n780[1767:1648]; // extract
  assign n2764 = n780[1775:1768]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2765 = n2721 ? n785 : n2764;
  assign n2766 = n780[1895:1776]; // extract
  assign n2767 = n780[1903:1896]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2768 = n2722 ? n785 : n2767;
  assign n2769 = n780[2023:1904]; // extract
  assign n2770 = n780[2031:2024]; // extract
  /* TG68K_Cache_030.vhd:292:37  */
  assign n2771 = n2723 ? n785 : n2770;
  assign n2772 = n780[2047:2032]; // extract
  assign n2773 = {n2772, n2771, n2769, n2768, n2766, n2765, n2763, n2762, n2760, n2759, n2757, n2756, n2754, n2753, n2751, n2750, n2748, n2747, n2745, n2744, n2742, n2741, n2739, n2738, n2736, n2735, n2733, n2732, n2730, n2729, n2727, n2726, n2724};
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2774 = n790[3]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2775 = ~n2774;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2776 = n790[2]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2777 = ~n2776;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2778 = n2775 & n2777;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2779 = n2775 & n2776;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2780 = n2774 & n2777;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2781 = n2774 & n2776;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2782 = n790[1]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2783 = ~n2782;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2784 = n2778 & n2783;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2785 = n2778 & n2782;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2786 = n2779 & n2783;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2787 = n2779 & n2782;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2788 = n2780 & n2783;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2789 = n2780 & n2782;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2790 = n2781 & n2783;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2791 = n2781 & n2782;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2792 = n790[0]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2793 = ~n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2794 = n2784 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2795 = n2784 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2796 = n2785 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2797 = n2785 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2798 = n2786 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2799 = n2786 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2800 = n2787 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2801 = n2787 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2802 = n2788 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2803 = n2788 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2804 = n2789 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2805 = n2789 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2806 = n2790 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2807 = n2790 & n2792;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2808 = n2791 & n2793;
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2809 = n2791 & n2792;
  assign n2810 = n787[111:0]; // extract
  assign n2811 = n787[119:112]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2812 = n2794 ? n792 : n2811;
  assign n2813 = n787[239:120]; // extract
  assign n2814 = n787[247:240]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2815 = n2795 ? n792 : n2814;
  assign n2816 = n787[367:248]; // extract
  assign n2817 = n787[375:368]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2818 = n2796 ? n792 : n2817;
  assign n2819 = n787[495:376]; // extract
  assign n2820 = n787[503:496]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2821 = n2797 ? n792 : n2820;
  assign n2822 = n787[623:504]; // extract
  assign n2823 = n787[631:624]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2824 = n2798 ? n792 : n2823;
  assign n2825 = n787[751:632]; // extract
  assign n2826 = n787[759:752]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2827 = n2799 ? n792 : n2826;
  assign n2828 = n787[879:760]; // extract
  assign n2829 = n787[887:880]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2830 = n2800 ? n792 : n2829;
  assign n2831 = n787[1007:888]; // extract
  assign n2832 = n787[1015:1008]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2833 = n2801 ? n792 : n2832;
  assign n2834 = n787[1135:1016]; // extract
  assign n2835 = n787[1143:1136]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2836 = n2802 ? n792 : n2835;
  assign n2837 = n787[1263:1144]; // extract
  assign n2838 = n787[1271:1264]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2839 = n2803 ? n792 : n2838;
  assign n2840 = n787[1391:1272]; // extract
  assign n2841 = n787[1399:1392]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2842 = n2804 ? n792 : n2841;
  assign n2843 = n787[1519:1400]; // extract
  assign n2844 = n787[1527:1520]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2845 = n2805 ? n792 : n2844;
  assign n2846 = n787[1647:1528]; // extract
  assign n2847 = n787[1655:1648]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2848 = n2806 ? n792 : n2847;
  assign n2849 = n787[1775:1656]; // extract
  assign n2850 = n787[1783:1776]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2851 = n2807 ? n792 : n2850;
  assign n2852 = n787[1903:1784]; // extract
  assign n2853 = n787[1911:1904]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2854 = n2808 ? n792 : n2853;
  assign n2855 = n787[2031:1912]; // extract
  assign n2856 = n787[2039:2032]; // extract
  /* TG68K_Cache_030.vhd:293:37  */
  assign n2857 = n2809 ? n792 : n2856;
  assign n2858 = n787[2047:2040]; // extract
  assign n2859 = {n2858, n2857, n2855, n2854, n2852, n2851, n2849, n2848, n2846, n2845, n2843, n2842, n2840, n2839, n2837, n2836, n2834, n2833, n2831, n2830, n2828, n2827, n2825, n2824, n2822, n2821, n2819, n2818, n2816, n2815, n2813, n2812, n2810};
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2860 = n797[3]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2861 = ~n2860;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2862 = n797[2]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2863 = ~n2862;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2864 = n2861 & n2863;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2865 = n2861 & n2862;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2866 = n2860 & n2863;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2867 = n2860 & n2862;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2868 = n797[1]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2869 = ~n2868;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2870 = n2864 & n2869;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2871 = n2864 & n2868;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2872 = n2865 & n2869;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2873 = n2865 & n2868;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2874 = n2866 & n2869;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2875 = n2866 & n2868;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2876 = n2867 & n2869;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2877 = n2867 & n2868;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2878 = n797[0]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2879 = ~n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2880 = n2870 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2881 = n2870 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2882 = n2871 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2883 = n2871 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2884 = n2872 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2885 = n2872 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2886 = n2873 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2887 = n2873 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2888 = n2874 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2889 = n2874 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2890 = n2875 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2891 = n2875 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2892 = n2876 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2893 = n2876 & n2878;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2894 = n2877 & n2879;
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2895 = n2877 & n2878;
  assign n2896 = n794[119:0]; // extract
  assign n2897 = n794[127:120]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2898 = n2880 ? n799 : n2897;
  assign n2899 = n794[247:128]; // extract
  assign n2900 = n794[255:248]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2901 = n2881 ? n799 : n2900;
  assign n2902 = n794[375:256]; // extract
  assign n2903 = n794[383:376]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2904 = n2882 ? n799 : n2903;
  assign n2905 = n794[503:384]; // extract
  assign n2906 = n794[511:504]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2907 = n2883 ? n799 : n2906;
  assign n2908 = n794[631:512]; // extract
  assign n2909 = n794[639:632]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2910 = n2884 ? n799 : n2909;
  assign n2911 = n794[759:640]; // extract
  assign n2912 = n794[767:760]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2913 = n2885 ? n799 : n2912;
  assign n2914 = n794[887:768]; // extract
  assign n2915 = n794[895:888]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2916 = n2886 ? n799 : n2915;
  assign n2917 = n794[1015:896]; // extract
  assign n2918 = n794[1023:1016]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2919 = n2887 ? n799 : n2918;
  assign n2920 = n794[1143:1024]; // extract
  assign n2921 = n794[1151:1144]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2922 = n2888 ? n799 : n2921;
  assign n2923 = n794[1271:1152]; // extract
  assign n2924 = n794[1279:1272]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2925 = n2889 ? n799 : n2924;
  assign n2926 = n794[1399:1280]; // extract
  assign n2927 = n794[1407:1400]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2928 = n2890 ? n799 : n2927;
  assign n2929 = n794[1527:1408]; // extract
  assign n2930 = n794[1535:1528]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2931 = n2891 ? n799 : n2930;
  assign n2932 = n794[1655:1536]; // extract
  assign n2933 = n794[1663:1656]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2934 = n2892 ? n799 : n2933;
  assign n2935 = n794[1783:1664]; // extract
  assign n2936 = n794[1791:1784]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2937 = n2893 ? n799 : n2936;
  assign n2938 = n794[1911:1792]; // extract
  assign n2939 = n794[1919:1912]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2940 = n2894 ? n799 : n2939;
  assign n2941 = n794[2039:1920]; // extract
  assign n2942 = n794[2047:2040]; // extract
  /* TG68K_Cache_030.vhd:294:37  */
  assign n2943 = n2895 ? n799 : n2942;
  assign n2944 = {n2943, n2941, n2940, n2938, n2937, n2935, n2934, n2932, n2931, n2929, n2928, n2926, n2925, n2923, n2922, n2920, n2919, n2917, n2916, n2914, n2913, n2911, n2910, n2908, n2907, n2905, n2904, n2902, n2901, n2899, n2898, n2896};
  /* TG68K_Cache_030.vhd:300:54  */
  assign n2945 = d_valid_array[n809 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:300:87  */
  assign n2946 = d_tag_array[n814 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:314:72  */
  assign n2947 = d_valid_array[n836 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:314:105  */
  assign n2948 = d_tag_array[n841 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:334:31  */
  assign n2949 = d_valid_array[n879 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:334:65  */
  assign n2950 = d_tag_array[n883 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:362:36  */
  assign n2951 = d_valid_array[n1126 * 1 +: 1]; //(Bmux)
  /* TG68K_Cache_030.vhd:362:70  */
  assign n2952 = d_tag_array[n1131 * 24 +: 24]; //(Bmux)
  /* TG68K_Cache_030.vhd:368:32  */
  assign n2953 = d_data_array[n1139 * 128 +: 128]; //(Bmux)
  /* TG68K_Cache_030.vhd:362:70  */
  assign n2954 = n2953[31:0]; // extract
  /* TG68K_Cache_030.vhd:368:43  */
  assign n2955 = d_data_array[2047:32]; // extract
  /* TG68K_Cache_030.vhd:362:36  */
  assign n2957 = {32'bX, n2955};
  /* TG68K_Cache_030.vhd:369:32  */
  assign n2958 = n2957[n1145 * 128 +: 128]; //(Bmux)
  /* TG68K_Cache_030.vhd:334:31  */
  assign n2959 = n2958[31:0]; // extract
  /* TG68K_Cache_030.vhd:369:43  */
  assign n2960 = d_data_array[2047:64]; // extract
  /* TG68K_Cache_030.vhd:314:105  */
  assign n2962 = {64'bX, n2960};
  /* TG68K_Cache_030.vhd:370:32  */
  assign n2963 = n2962[n1151 * 128 +: 128]; //(Bmux)
  /* TG68K_Cache_030.vhd:300:87  */
  assign n2964 = n2963[31:0]; // extract
  /* TG68K_Cache_030.vhd:370:43  */
  assign n2965 = d_data_array[2047:96]; // extract
  /* TG68K_Cache_030.vhd:300:54  */
  assign n2967 = {96'bX, n2965};
  /* TG68K_Cache_030.vhd:371:32  */
  assign n2968 = n2967[n1157 * 128 +: 128]; //(Bmux)
  assign n2969 = n2968[31:0]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2970 = n63[3]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2971 = ~n2970;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2972 = n63[2]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2973 = ~n2972;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2974 = n2971 & n2973;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2975 = n2971 & n2972;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2976 = n2970 & n2973;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2977 = n2970 & n2972;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2978 = n63[1]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2979 = ~n2978;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2980 = n2974 & n2979;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2981 = n2974 & n2978;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2982 = n2975 & n2979;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2983 = n2975 & n2978;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2984 = n2976 & n2979;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2985 = n2976 & n2978;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2986 = n2977 & n2979;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2987 = n2977 & n2978;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2988 = n63[0]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2989 = ~n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2990 = n2980 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2991 = n2980 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2992 = n2981 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2993 = n2981 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2994 = n2982 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2995 = n2982 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2996 = n2983 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2997 = n2983 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2998 = n2984 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n2999 = n2984 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3000 = n2985 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3001 = n2985 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3002 = n2986 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3003 = n2986 & n2988;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3004 = n2987 & n2989;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3005 = n2987 & n2988;
  assign n3006 = i_tag_array[23:0]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3007 = n2990 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3008 = n3007 ? i_fill_tag : n3006;
  assign n3009 = i_tag_array[47:24]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3010 = n2991 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3011 = n3010 ? i_fill_tag : n3009;
  assign n3012 = i_tag_array[71:48]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3013 = n2992 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3014 = n3013 ? i_fill_tag : n3012;
  assign n3015 = i_tag_array[95:72]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3016 = n2993 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3017 = n3016 ? i_fill_tag : n3015;
  assign n3018 = i_tag_array[119:96]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3019 = n2994 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3020 = n3019 ? i_fill_tag : n3018;
  assign n3021 = i_tag_array[143:120]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3022 = n2995 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3023 = n3022 ? i_fill_tag : n3021;
  assign n3024 = i_tag_array[167:144]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3025 = n2996 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3026 = n3025 ? i_fill_tag : n3024;
  assign n3027 = i_tag_array[191:168]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3028 = n2997 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3029 = n3028 ? i_fill_tag : n3027;
  assign n3030 = i_tag_array[215:192]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3031 = n2998 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3032 = n3031 ? i_fill_tag : n3030;
  assign n3033 = i_tag_array[239:216]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3034 = n2999 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3035 = n3034 ? i_fill_tag : n3033;
  assign n3036 = i_tag_array[263:240]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3037 = n3000 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3038 = n3037 ? i_fill_tag : n3036;
  assign n3039 = i_tag_array[287:264]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3040 = n3001 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3041 = n3040 ? i_fill_tag : n3039;
  assign n3042 = i_tag_array[311:288]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3043 = n3002 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3044 = n3043 ? i_fill_tag : n3042;
  assign n3045 = i_tag_array[335:312]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3046 = n3003 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3047 = n3046 ? i_fill_tag : n3045;
  assign n3048 = i_tag_array[359:336]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3049 = n3004 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3050 = n3049 ? i_fill_tag : n3048;
  assign n3051 = i_tag_array[383:360]; // extract
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3052 = n3005 & n1170;
  /* TG68K_Cache_030.vhd:146:9  */
  assign n3053 = n3052 ? i_fill_tag : n3051;
  assign n3054 = {n3053, n3050, n3047, n3044, n3041, n3038, n3035, n3032, n3029, n3026, n3023, n3020, n3017, n3014, n3011, n3008};
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3055 = n428[3]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3056 = ~n3055;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3057 = n428[2]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3058 = ~n3057;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3059 = n3056 & n3058;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3060 = n3056 & n3057;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3061 = n3055 & n3058;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3062 = n3055 & n3057;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3063 = n428[1]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3064 = ~n3063;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3065 = n3059 & n3064;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3066 = n3059 & n3063;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3067 = n3060 & n3064;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3068 = n3060 & n3063;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3069 = n3061 & n3064;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3070 = n3061 & n3063;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3071 = n3062 & n3064;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3072 = n3062 & n3063;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3073 = n428[0]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3074 = ~n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3075 = n3065 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3076 = n3065 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3077 = n3066 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3078 = n3066 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3079 = n3067 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3080 = n3067 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3081 = n3068 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3082 = n3068 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3083 = n3069 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3084 = n3069 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3085 = n3070 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3086 = n3070 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3087 = n3071 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3088 = n3071 & n3073;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3089 = n3072 & n3074;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3090 = n3072 & n3073;
  assign n3091 = d_tag_array[23:0]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3092 = n3075 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3093 = n3092 ? d_fill_tag : n3091;
  assign n3094 = d_tag_array[47:24]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3095 = n3076 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3096 = n3095 ? d_fill_tag : n3094;
  assign n3097 = d_tag_array[71:48]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3098 = n3077 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3099 = n3098 ? d_fill_tag : n3097;
  assign n3100 = d_tag_array[95:72]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3101 = n3078 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3102 = n3101 ? d_fill_tag : n3100;
  assign n3103 = d_tag_array[119:96]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3104 = n3079 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3105 = n3104 ? d_fill_tag : n3103;
  assign n3106 = d_tag_array[143:120]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3107 = n3080 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3108 = n3107 ? d_fill_tag : n3106;
  assign n3109 = d_tag_array[167:144]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3110 = n3081 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3111 = n3110 ? d_fill_tag : n3109;
  assign n3112 = d_tag_array[191:168]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3113 = n3082 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3114 = n3113 ? d_fill_tag : n3112;
  assign n3115 = d_tag_array[215:192]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3116 = n3083 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3117 = n3116 ? d_fill_tag : n3115;
  assign n3118 = d_tag_array[239:216]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3119 = n3084 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3120 = n3119 ? d_fill_tag : n3118;
  assign n3121 = d_tag_array[263:240]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3122 = n3085 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3123 = n3122 ? d_fill_tag : n3121;
  assign n3124 = d_tag_array[287:264]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3125 = n3086 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3126 = n3125 ? d_fill_tag : n3124;
  assign n3127 = d_tag_array[311:288]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3128 = n3087 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3129 = n3128 ? d_fill_tag : n3127;
  assign n3130 = d_tag_array[335:312]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3131 = n3088 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3132 = n3131 ? d_fill_tag : n3130;
  assign n3133 = d_tag_array[359:336]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3134 = n3089 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3135 = n3134 ? d_fill_tag : n3133;
  assign n3136 = d_tag_array[383:360]; // extract
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3137 = n3090 & n1178;
  /* TG68K_Cache_030.vhd:236:9  */
  assign n3138 = n3137 ? d_fill_tag : n3136;
  assign n3139 = {n3138, n3135, n3132, n3129, n3126, n3123, n3120, n3117, n3114, n3111, n3108, n3105, n3102, n3099, n3096, n3093};
endmodule

