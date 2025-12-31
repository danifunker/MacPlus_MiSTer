module tg68k_fpu_packeddecimal
  (input  clk,
   input  nreset,
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
  wire n939;
  wire [2:0] n942;
  wire n944;
  wire n945;
  wire n946;
  wire [11:0] n947;
  wire [67:0] n948;
  wire [3:0] n949;
  wire n951;
  wire n954;
  wire [3:0] n956;
  wire n958;
  wire n960;
  wire [3:0] n961;
  wire n963;
  wire n965;
  wire [3:0] n966;
  wire n968;
  wire n970;
  wire [3:0] n971;
  wire n973;
  wire n975;
  wire [3:0] n976;
  wire n978;
  wire n980;
  wire [3:0] n981;
  wire n983;
  wire n985;
  wire [3:0] n986;
  wire n988;
  wire n990;
  wire [3:0] n991;
  wire n993;
  wire n995;
  wire [3:0] n996;
  wire n998;
  wire n1000;
  wire [3:0] n1001;
  wire n1003;
  wire n1005;
  wire [3:0] n1006;
  wire n1008;
  wire n1010;
  wire [3:0] n1011;
  wire n1013;
  wire n1015;
  wire [3:0] n1016;
  wire n1018;
  wire n1020;
  wire [3:0] n1021;
  wire n1023;
  wire n1025;
  wire [3:0] n1026;
  wire n1028;
  wire n1030;
  wire [3:0] n1031;
  wire n1033;
  wire n1035;
  wire [3:0] n1036;
  wire n1038;
  wire n1040;
  wire [3:0] n1041;
  wire n1043;
  wire n1045;
  wire [3:0] n1046;
  wire n1048;
  wire n1050;
  wire n1051;
  wire [14:0] n1052;
  wire [30:0] n1053;
  wire [31:0] n1054;
  wire [31:0] n1056;
  wire [63:0] n1057;
  wire [14:0] n1059;
  wire n1061;
  wire n1062;
  wire [62:0] n1063;
  wire n1065;
  wire n1066;
  wire [95:0] n1085;
  wire n1087;
  wire n1089;
  wire [2:0] n1091;
  wire [67:0] n1092;
  wire [67:0] n1093;
  wire [11:0] n1095;
  wire [78:0] n1096;
  wire n1098;
  wire [95:0] n1100;
  wire [2:0] n1103;
  wire [95:0] n1104;
  wire n1105;
  wire n1106;
  wire [2:0] n1107;
  wire n1108;
  wire n1109;
  wire [95:0] n1110;
  wire n1111;
  wire n1112;
  wire [2:0] n1114;
  wire [67:0] n1115;
  wire [11:0] n1116;
  wire [127:0] n1117;
  wire [127:0] n1118;
  wire [31:0] n1119;
  wire n1120;
  wire n1121;
  wire n1123;
  wire [31:0] n1124;
  wire n1126;
  wire [63:0] n1128;
  wire [127:0] n1130;
  wire [31:0] n1131;
  wire n1133;
  wire [3:0] n1134;
  wire [30:0] n1135;
  wire [31:0] n1136;
  wire n1138;
  wire [3:0] n1139;
  wire [30:0] n1140;
  wire [31:0] n1141;
  wire n1143;
  wire [3:0] n1144;
  wire [30:0] n1145;
  wire [31:0] n1146;
  wire n1148;
  wire [3:0] n1149;
  wire [30:0] n1150;
  wire [31:0] n1151;
  wire n1153;
  wire [3:0] n1154;
  wire [30:0] n1155;
  wire [31:0] n1156;
  wire n1158;
  wire [3:0] n1159;
  wire [30:0] n1160;
  wire [31:0] n1161;
  wire n1163;
  wire [3:0] n1164;
  wire [30:0] n1165;
  wire [31:0] n1166;
  wire n1168;
  wire [3:0] n1169;
  wire [30:0] n1170;
  wire [31:0] n1171;
  wire n1173;
  wire [3:0] n1174;
  wire [30:0] n1175;
  wire [31:0] n1176;
  wire n1178;
  wire [3:0] n1179;
  wire [30:0] n1180;
  wire [31:0] n1181;
  wire n1183;
  wire [3:0] n1184;
  wire [30:0] n1185;
  wire [31:0] n1186;
  wire n1188;
  wire [3:0] n1189;
  wire [30:0] n1190;
  wire [31:0] n1191;
  wire n1193;
  wire [3:0] n1194;
  wire [30:0] n1195;
  wire [31:0] n1196;
  wire n1198;
  wire [3:0] n1199;
  wire [30:0] n1200;
  wire [31:0] n1201;
  wire n1203;
  wire [3:0] n1204;
  wire [30:0] n1205;
  wire [31:0] n1206;
  wire n1208;
  wire [3:0] n1209;
  wire [30:0] n1210;
  wire [31:0] n1211;
  wire n1213;
  wire [3:0] n1214;
  wire [30:0] n1215;
  wire [31:0] n1216;
  wire n1218;
  wire [16:0] n1219;
  reg [31:0] n1221;
  wire [255:0] n1222;
  wire [255:0] n1224;
  wire [127:0] n1225;
  wire [30:0] n1226;
  wire [127:0] n1227;
  wire [127:0] n1228;
  wire [31:0] n1229;
  wire [31:0] n1231;
  wire [5:0] n1232;
  wire [3:0] n1241;
  wire [30:0] n1242;
  wire [31:0] n1243;
  wire [3:0] n1245;
  wire [30:0] n1246;
  wire [31:0] n1247;
  wire [3:0] n1249;
  wire [30:0] n1250;
  wire [31:0] n1251;
  wire n1254;
  wire n1256;
  wire n1257;
  wire n1259;
  wire n1260;
  wire n1264;
  wire [31:0] n1270;
  wire [31:0] n1272;
  wire [31:0] n1274;
  wire [31:0] n1275;
  wire [31:0] n1276;
  wire [31:0] n1281;
  wire [31:0] n1282;
  wire [31:0] n1283;
  wire [31:0] n1284;
  wire [10:0] n1285;
  wire [3:0] n1294;
  wire [30:0] n1295;
  wire [31:0] n1296;
  wire [3:0] n1298;
  wire [30:0] n1299;
  wire [31:0] n1300;
  wire [3:0] n1302;
  wire [30:0] n1303;
  wire [31:0] n1304;
  wire n1307;
  wire n1309;
  wire n1310;
  wire n1312;
  wire n1313;
  wire n1317;
  wire [31:0] n1323;
  wire [31:0] n1325;
  wire [31:0] n1327;
  wire [31:0] n1328;
  wire [31:0] n1329;
  wire [31:0] n1334;
  wire [31:0] n1335;
  wire [31:0] n1336;
  wire [10:0] n1337;
  wire [10:0] n1338;
  wire [63:0] n1339;
  wire [2:0] n1341;
  wire [63:0] n1342;
  wire [10:0] n1343;
  wire [5:0] n1345;
  wire [127:0] n1346;
  wire n1349;
  wire [31:0] n1350;
  wire n1352;
  wire n1354;
  wire [31:0] n1356;
  wire [31:0] n1358;
  wire [10:0] n1359;
  wire [31:0] n1361;
  wire [31:0] n1363;
  wire [31:0] n1364;
  wire [10:0] n1365;
  wire [10:0] n1366;
  wire n1369;
  wire [67:0] n1371;
  wire [10:0] n1372;
  wire n1373;
  wire [127:0] n1374;
  wire [31:0] n1375;
  wire n1377;
  wire [3:0] n1378;
  wire [3:0] n1380;
  wire n1382;
  wire [3:0] n1383;
  wire [3:0] n1385;
  wire n1387;
  wire [3:0] n1388;
  wire [3:0] n1390;
  wire n1392;
  wire [3:0] n1393;
  wire [3:0] n1395;
  wire n1397;
  wire [3:0] n1398;
  wire [3:0] n1400;
  wire n1402;
  wire [3:0] n1403;
  wire [3:0] n1405;
  wire n1407;
  wire [3:0] n1408;
  wire [3:0] n1410;
  wire n1412;
  wire [3:0] n1413;
  wire [3:0] n1415;
  wire n1417;
  wire [3:0] n1418;
  wire [3:0] n1420;
  wire n1422;
  wire [3:0] n1423;
  wire [3:0] n1425;
  wire n1427;
  wire [3:0] n1428;
  wire [3:0] n1430;
  wire n1432;
  wire [3:0] n1433;
  wire [3:0] n1435;
  wire n1437;
  wire [3:0] n1438;
  wire [3:0] n1440;
  wire n1442;
  wire [3:0] n1443;
  wire [3:0] n1445;
  wire n1447;
  wire [3:0] n1448;
  wire [3:0] n1450;
  wire n1452;
  wire [3:0] n1453;
  wire [3:0] n1455;
  wire n1457;
  wire [3:0] n1458;
  wire [3:0] n1460;
  wire n1462;
  wire [16:0] n1463;
  wire [3:0] n1464;
  reg [3:0] n1465;
  wire [3:0] n1466;
  reg [3:0] n1467;
  wire [3:0] n1468;
  reg [3:0] n1469;
  wire [3:0] n1470;
  reg [3:0] n1471;
  wire [3:0] n1472;
  reg [3:0] n1473;
  wire [3:0] n1474;
  reg [3:0] n1475;
  wire [3:0] n1476;
  reg [3:0] n1477;
  wire [3:0] n1478;
  reg [3:0] n1479;
  wire [3:0] n1480;
  reg [3:0] n1481;
  wire [3:0] n1482;
  reg [3:0] n1483;
  wire [3:0] n1484;
  reg [3:0] n1485;
  wire [3:0] n1486;
  reg [3:0] n1487;
  wire [3:0] n1488;
  reg [3:0] n1489;
  wire [3:0] n1490;
  reg [3:0] n1491;
  wire [3:0] n1492;
  reg [3:0] n1493;
  wire [3:0] n1494;
  reg [3:0] n1495;
  wire [3:0] n1496;
  reg [3:0] n1497;
  wire [31:0] n1498;
  wire [31:0] n1500;
  wire [5:0] n1501;
  wire [31:0] n1502;
  wire [31:0] n1503;
  wire [31:0] n1504;
  wire [10:0] n1505;
  wire [31:0] n1506;
  wire n1508;
  wire [31:0] n1510;
  wire [31:0] n1511;
  wire [31:0] n1518;
  wire [30:0] n1519;
  wire [3:0] n1520;
  wire [31:0] n1524;
  wire [31:0] n1526;
  wire [30:0] n1527;
  wire [3:0] n1528;
  wire [31:0] n1531;
  wire [31:0] n1533;
  wire [30:0] n1534;
  wire [3:0] n1535;
  wire [11:0] n1536;
  wire [31:0] n1538;
  wire [31:0] n1545;
  wire [30:0] n1546;
  wire [3:0] n1547;
  wire [31:0] n1551;
  wire [31:0] n1553;
  wire [30:0] n1554;
  wire [3:0] n1555;
  wire [31:0] n1558;
  wire [31:0] n1560;
  wire [30:0] n1561;
  wire [3:0] n1562;
  wire [11:0] n1563;
  wire [11:0] n1564;
  wire n1567;
  wire n1569;
  wire [2:0] n1571;
  wire [67:0] n1572;
  wire [67:0] n1573;
  wire [11:0] n1574;
  wire [10:0] n1575;
  wire n1576;
  wire [5:0] n1577;
  wire n1579;
  wire n1581;
  wire [31:0] n1582;
  wire [31:0] n1584;
  wire [31:0] n1586;
  wire [31:0] n1588;
  wire n1590;
  wire [79:0] n1592;
  wire n1594;
  wire [15:0] n1596;
  wire [16:0] n1598;
  wire [79:0] n1600;
  wire [30:0] n1601;
  wire [14:0] n1602;
  wire [15:0] n1603;
  wire [79:0] n1604;
  wire [79:0] n1605;
  wire n1607;
  wire [79:0] n1608;
  wire n1609;
  wire [79:0] n1611;
  wire n1612;
  wire n1615;
  wire n1617;
  wire n1618;
  wire [1:0] n1619;
  wire [3:0] n1621;
  wire [15:0] n1622;
  wire [16:0] n1624;
  wire [27:0] n1626;
  wire [95:0] n1627;
  wire [95:0] n1628;
  wire n1630;
  wire [6:0] n1631;
  reg n1635;
  reg n1639;
  reg [79:0] n1641;
  reg [95:0] n1643;
  reg n1646;
  reg n1650;
  reg n1653;
  reg [2:0] n1658;
  reg [67:0] n1660;
  reg [11:0] n1662;
  reg [63:0] n1664;
  reg [10:0] n1666;
  reg [127:0] n1668;
  reg [31:0] n1670;
  reg n1672;
  reg n1674;
  reg [5:0] n1677;
  reg [127:0] n1679;
  wire n1754;
  wire n1755;
  wire [127:0] n1756;
  reg [127:0] n1757;
  wire [2:0] n1766;
  reg [2:0] n1767;
  wire n1768;
  wire n1769;
  wire [67:0] n1770;
  reg [67:0] n1771;
  wire n1772;
  wire n1773;
  wire [11:0] n1774;
  reg [11:0] n1775;
  wire n1776;
  wire n1777;
  wire [63:0] n1778;
  reg [63:0] n1779;
  wire n1781;
  wire n1782;
  wire [10:0] n1783;
  reg [10:0] n1784;
  wire n1785;
  wire n1786;
  wire [127:0] n1787;
  reg [127:0] n1788;
  wire n1789;
  wire n1790;
  wire [31:0] n1791;
  reg [31:0] n1792;
  wire n1793;
  wire n1794;
  wire n1795;
  reg n1796;
  wire n1797;
  wire n1798;
  wire n1799;
  reg n1800;
  wire [5:0] n1801;
  reg [5:0] n1802;
  wire n1803;
  reg n1804;
  wire n1805;
  reg n1806;
  wire [79:0] n1807;
  reg [79:0] n1808;
  wire [95:0] n1809;
  reg [95:0] n1810;
  wire n1811;
  reg n1812;
  wire n1813;
  reg n1814;
  wire n1815;
  reg n1816;
  assign conversion_done = n1804; //(module output)
  assign conversion_valid = n1806; //(module output)
  assign extended_out = n1808; //(module output)
  assign packed_out = n1810; //(module output)
  assign overflow = n1812; //(module output)
  assign inexact = n1814; //(module output)
  assign invalid = n1816; //(module output)
  /* TG68K_FPU_PackedDecimal.vhd:78:12  */
  always @*
    packed_state = n1767; // (isignal)
  initial
    packed_state = 3'b000;
  /* TG68K_FPU_PackedDecimal.vhd:85:12  */
  assign bcd_digits = n1771; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:86:12  */
  assign bcd_exponent = n1775; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:87:12  */
  assign binary_mantissa = n1779; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:89:12  */
  assign decimal_exponent = n1784; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:92:12  */
  assign work_mantissa = n1788; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:93:12  */
  assign work_exponent = n1792; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:94:12  */
  assign result_sign = n1796; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:95:12  */
  assign exp_sign = n1800; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:123:12  */
  assign cycle_count = n1802; // (signal)
  /* TG68K_FPU_PackedDecimal.vhd:128:18  */
  always @*
    packed_conversion_temp_mantissa = n1757; // (isignal)
  initial
    packed_conversion_temp_mantissa = 128'bX;
  /* TG68K_FPU_PackedDecimal.vhd:133:19  */
  assign n939 = ~nreset;
  /* TG68K_FPU_PackedDecimal.vhd:155:25  */
  assign n942 = start_conversion ? 3'b001 : packed_state;
  /* TG68K_FPU_PackedDecimal.vhd:147:21  */
  assign n944 = packed_state == 3'b000;
  /* TG68K_FPU_PackedDecimal.vhd:163:53  */
  assign n945 = packed_in[95]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:164:50  */
  assign n946 = packed_in[94]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:165:54  */
  assign n947 = packed_in[91:80]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:166:52  */
  assign n948 = packed_in[67:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n949 = bcd_digits[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n951 = $unsigned(n949) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n954 = n951 ? 1'b1 : 1'b0;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n956 = bcd_digits[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n958 = $unsigned(n956) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n960 = n958 ? 1'b1 : n954;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n961 = bcd_digits[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n963 = $unsigned(n961) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n965 = n963 ? 1'b1 : n960;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n966 = bcd_digits[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n968 = $unsigned(n966) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n970 = n968 ? 1'b1 : n965;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n971 = bcd_digits[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n973 = $unsigned(n971) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n975 = n973 ? 1'b1 : n970;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n976 = bcd_digits[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n978 = $unsigned(n976) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n980 = n978 ? 1'b1 : n975;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n981 = bcd_digits[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n983 = $unsigned(n981) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n985 = n983 ? 1'b1 : n980;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n986 = bcd_digits[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n988 = $unsigned(n986) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n990 = n988 ? 1'b1 : n985;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n991 = bcd_digits[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n993 = $unsigned(n991) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n995 = n993 ? 1'b1 : n990;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n996 = bcd_digits[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n998 = $unsigned(n996) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1000 = n998 ? 1'b1 : n995;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1001 = bcd_digits[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1003 = $unsigned(n1001) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1005 = n1003 ? 1'b1 : n1000;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1006 = bcd_digits[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1008 = $unsigned(n1006) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1010 = n1008 ? 1'b1 : n1005;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1011 = bcd_digits[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1013 = $unsigned(n1011) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1015 = n1013 ? 1'b1 : n1010;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1016 = bcd_digits[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1018 = $unsigned(n1016) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1020 = n1018 ? 1'b1 : n1015;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1021 = bcd_digits[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1023 = $unsigned(n1021) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1025 = n1023 ? 1'b1 : n1020;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1026 = bcd_digits[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1028 = $unsigned(n1026) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1030 = n1028 ? 1'b1 : n1025;
  /* TG68K_FPU_PackedDecimal.vhd:171:55  */
  assign n1031 = bcd_digits[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:171:75  */
  assign n1033 = $unsigned(n1031) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:171:33  */
  assign n1035 = n1033 ? 1'b1 : n1030;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n1036 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n1038 = $unsigned(n1036) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n1040 = n1038 ? 1'b1 : n1035;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n1041 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n1043 = $unsigned(n1041) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n1045 = n1043 ? 1'b1 : n1040;
  /* TG68K_FPU_PackedDecimal.vhd:178:57  */
  assign n1046 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:178:77  */
  assign n1048 = $unsigned(n1046) > $unsigned(4'b1001);
  /* TG68K_FPU_PackedDecimal.vhd:178:33  */
  assign n1050 = n1048 ? 1'b1 : n1045;
  /* TG68K_FPU_PackedDecimal.vhd:187:55  */
  assign n1051 = extended_in[79]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:188:77  */
  assign n1052 = extended_in[78:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:188:46  */
  assign n1053 = {16'b0, n1052};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:188:94  */
  assign n1054 = {1'b0, n1053};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:188:94  */
  assign n1056 = n1054 - 32'b00000000000000000011111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:189:70  */
  assign n1057 = extended_in[63:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:193:43  */
  assign n1059 = extended_in[78:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:193:58  */
  assign n1061 = n1059 == 15'b111111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:195:47  */
  assign n1062 = extended_in[63]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:195:73  */
  assign n1063 = extended_in[62:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:195:87  */
  assign n1065 = n1063 == 63'b000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:195:58  */
  assign n1066 = n1065 & n1062;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n1085 = n1066 ? n1810 : 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1087 = n1105 ? 1'b1 : n1812;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n1089 = n1066 ? n1816 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:195:33  */
  assign n1091 = n1066 ? packed_state : 3'b110;
  assign n1092 = {4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001, 4'b1001};
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1093 = n1108 ? n1092 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1095 = n1109 ? 12'b100110011001 : bcd_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:209:46  */
  assign n1096 = extended_in[78:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:209:60  */
  assign n1098 = n1096 == 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:209:29  */
  assign n1100 = n1098 ? 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : n1810;
  /* TG68K_FPU_PackedDecimal.vhd:209:29  */
  assign n1103 = n1098 ? 3'b110 : 3'b011;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1104 = n1061 ? n1085 : n1100;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1105 = n1066 & n1061;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1106 = n1061 ? n1089 : n1816;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1107 = n1061 ? n1091 : n1103;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1108 = n1066 & n1061;
  /* TG68K_FPU_PackedDecimal.vhd:193:29  */
  assign n1109 = n1066 & n1061;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1110 = packed_to_extended ? n1810 : n1104;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1111 = packed_to_extended ? n1812 : n1087;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1112 = packed_to_extended ? n1050 : n1106;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1114 = packed_to_extended ? 3'b010 : n1107;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1115 = packed_to_extended ? n948 : n1093;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1116 = packed_to_extended ? n947 : n1095;
  assign n1117 = {64'b0000000000000000000000000000000000000000000000000000000000000000, n1057};
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1118 = packed_to_extended ? work_mantissa : n1117;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1119 = packed_to_extended ? work_exponent : n1056;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1120 = packed_to_extended ? n945 : n1051;
  /* TG68K_FPU_PackedDecimal.vhd:160:25  */
  assign n1121 = packed_to_extended ? n946 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:159:21  */
  assign n1123 = packed_state == 3'b001;
  /* TG68K_FPU_PackedDecimal.vhd:221:40  */
  assign n1124 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:221:40  */
  assign n1126 = n1124 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:221:25  */
  assign n1128 = n1126 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : binary_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:221:25  */
  assign n1130 = n1126 ? 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:226:40  */
  assign n1131 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:226:40  */
  assign n1133 = $signed(n1131) < $signed(32'b00000000000000000000000000010001);
  /* TG68K_FPU_PackedDecimal.vhd:229:89  */
  assign n1134 = bcd_digits[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:229:59  */
  assign n1135 = {27'b0, n1134};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:229:44  */
  assign n1136 = {1'b0, n1135};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:229:33  */
  assign n1138 = cycle_count == 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:230:89  */
  assign n1139 = bcd_digits[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:230:59  */
  assign n1140 = {27'b0, n1139};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:230:44  */
  assign n1141 = {1'b0, n1140};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:230:33  */
  assign n1143 = cycle_count == 6'b000001;
  /* TG68K_FPU_PackedDecimal.vhd:231:89  */
  assign n1144 = bcd_digits[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:231:59  */
  assign n1145 = {27'b0, n1144};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:231:44  */
  assign n1146 = {1'b0, n1145};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:231:33  */
  assign n1148 = cycle_count == 6'b000010;
  /* TG68K_FPU_PackedDecimal.vhd:232:89  */
  assign n1149 = bcd_digits[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:232:59  */
  assign n1150 = {27'b0, n1149};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:232:44  */
  assign n1151 = {1'b0, n1150};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:232:33  */
  assign n1153 = cycle_count == 6'b000011;
  /* TG68K_FPU_PackedDecimal.vhd:233:89  */
  assign n1154 = bcd_digits[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:233:59  */
  assign n1155 = {27'b0, n1154};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:233:44  */
  assign n1156 = {1'b0, n1155};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:233:33  */
  assign n1158 = cycle_count == 6'b000100;
  /* TG68K_FPU_PackedDecimal.vhd:234:89  */
  assign n1159 = bcd_digits[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:234:59  */
  assign n1160 = {27'b0, n1159};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:234:44  */
  assign n1161 = {1'b0, n1160};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:234:33  */
  assign n1163 = cycle_count == 6'b000101;
  /* TG68K_FPU_PackedDecimal.vhd:235:89  */
  assign n1164 = bcd_digits[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:235:59  */
  assign n1165 = {27'b0, n1164};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:235:44  */
  assign n1166 = {1'b0, n1165};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:235:33  */
  assign n1168 = cycle_count == 6'b000110;
  /* TG68K_FPU_PackedDecimal.vhd:236:89  */
  assign n1169 = bcd_digits[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:236:59  */
  assign n1170 = {27'b0, n1169};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:236:44  */
  assign n1171 = {1'b0, n1170};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:236:33  */
  assign n1173 = cycle_count == 6'b000111;
  /* TG68K_FPU_PackedDecimal.vhd:237:89  */
  assign n1174 = bcd_digits[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:237:59  */
  assign n1175 = {27'b0, n1174};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:237:44  */
  assign n1176 = {1'b0, n1175};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:237:33  */
  assign n1178 = cycle_count == 6'b001000;
  /* TG68K_FPU_PackedDecimal.vhd:238:89  */
  assign n1179 = bcd_digits[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:238:59  */
  assign n1180 = {27'b0, n1179};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:238:44  */
  assign n1181 = {1'b0, n1180};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:238:33  */
  assign n1183 = cycle_count == 6'b001001;
  /* TG68K_FPU_PackedDecimal.vhd:239:89  */
  assign n1184 = bcd_digits[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:239:59  */
  assign n1185 = {27'b0, n1184};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:239:44  */
  assign n1186 = {1'b0, n1185};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:239:33  */
  assign n1188 = cycle_count == 6'b001010;
  /* TG68K_FPU_PackedDecimal.vhd:240:89  */
  assign n1189 = bcd_digits[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:240:59  */
  assign n1190 = {27'b0, n1189};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:240:44  */
  assign n1191 = {1'b0, n1190};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:240:33  */
  assign n1193 = cycle_count == 6'b001011;
  /* TG68K_FPU_PackedDecimal.vhd:241:89  */
  assign n1194 = bcd_digits[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:241:59  */
  assign n1195 = {27'b0, n1194};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:241:44  */
  assign n1196 = {1'b0, n1195};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:241:33  */
  assign n1198 = cycle_count == 6'b001100;
  /* TG68K_FPU_PackedDecimal.vhd:242:89  */
  assign n1199 = bcd_digits[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:242:59  */
  assign n1200 = {27'b0, n1199};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:242:44  */
  assign n1201 = {1'b0, n1200};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:242:33  */
  assign n1203 = cycle_count == 6'b001101;
  /* TG68K_FPU_PackedDecimal.vhd:243:89  */
  assign n1204 = bcd_digits[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:243:59  */
  assign n1205 = {27'b0, n1204};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:243:44  */
  assign n1206 = {1'b0, n1205};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:243:33  */
  assign n1208 = cycle_count == 6'b001110;
  /* TG68K_FPU_PackedDecimal.vhd:244:89  */
  assign n1209 = bcd_digits[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:244:59  */
  assign n1210 = {27'b0, n1209};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:244:44  */
  assign n1211 = {1'b0, n1210};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:244:33  */
  assign n1213 = cycle_count == 6'b001111;
  /* TG68K_FPU_PackedDecimal.vhd:245:89  */
  assign n1214 = bcd_digits[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:245:59  */
  assign n1215 = {27'b0, n1214};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:245:44  */
  assign n1216 = {1'b0, n1215};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:245:33  */
  assign n1218 = cycle_count == 6'b010000;
  assign n1219 = {n1218, n1213, n1208, n1203, n1198, n1193, n1188, n1183, n1178, n1173, n1168, n1163, n1158, n1153, n1148, n1143, n1138};
  /* TG68K_FPU_PackedDecimal.vhd:228:29  */
  always @*
    case (n1219)
      17'b10000000000000000: n1221 = n1216;
      17'b01000000000000000: n1221 = n1211;
      17'b00100000000000000: n1221 = n1206;
      17'b00010000000000000: n1221 = n1201;
      17'b00001000000000000: n1221 = n1196;
      17'b00000100000000000: n1221 = n1191;
      17'b00000010000000000: n1221 = n1186;
      17'b00000001000000000: n1221 = n1181;
      17'b00000000100000000: n1221 = n1176;
      17'b00000000010000000: n1221 = n1171;
      17'b00000000001000000: n1221 = n1166;
      17'b00000000000100000: n1221 = n1161;
      17'b00000000000010000: n1221 = n1156;
      17'b00000000000001000: n1221 = n1151;
      17'b00000000000000100: n1221 = n1146;
      17'b00000000000000010: n1221 = n1141;
      17'b00000000000000001: n1221 = n1136;
      default: n1221 = 32'b00000000000000000000000000000000;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:249:67  */
  assign n1222 = {128'b0, n1130};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:249:67  */
  assign n1224 = $signed(n1222) * $signed(256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:249:46  */
  assign n1225 = n1224[127:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n1226 = n1221[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n1227 = {97'b0, n1226};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:249:78  */
  assign n1228 = n1225 + n1227;
  /* TG68K_FPU_PackedDecimal.vhd:250:56  */
  assign n1229 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:250:56  */
  assign n1231 = n1229 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_PackedDecimal.vhd:250:44  */
  assign n1232 = n1231[5:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:101:38  */
  assign n1241 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:101:15  */
  assign n1242 = {27'b0, n1241};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:101:9  */
  assign n1243 = {1'b0, n1242};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:38  */
  assign n1245 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:102:15  */
  assign n1246 = {27'b0, n1245};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:9  */
  assign n1247 = {1'b0, n1246};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:38  */
  assign n1249 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:103:15  */
  assign n1250 = {27'b0, n1249};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:9  */
  assign n1251 = {1'b0, n1250};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:104:15  */
  assign n1254 = $signed(n1243) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:25  */
  assign n1256 = $signed(n1247) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:19  */
  assign n1257 = n1254 | n1256;
  /* TG68K_FPU_PackedDecimal.vhd:104:35  */
  assign n1259 = $signed(n1251) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:29  */
  assign n1260 = n1257 | n1259;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n1264 = n1260 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n1270 = n1260 ? 32'b11111111111111111111111111111111 : 32'bX;
  /* TG68K_FPU_PackedDecimal.vhd:107:19  */
  assign n1272 = $signed(n1251) * $signed(32'b00000000000000000000000001100100); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:30  */
  assign n1274 = $signed(n1247) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:25  */
  assign n1275 = n1272 + n1274;
  /* TG68K_FPU_PackedDecimal.vhd:107:35  */
  assign n1276 = n1275 + n1243;
  /* TG68K_FPU_PackedDecimal.vhd:107:9  */
  assign n1281 = n1264 ? n1276 : n1270;
  /* TG68K_FPU_PackedDecimal.vhd:254:53  */
  assign n1282 = -n1281;
  /* TG68K_FPU_PackedDecimal.vhd:254:84  */
  assign n1283 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:254:82  */
  assign n1284 = n1282 - n1283;
  /* TG68K_FPU_PackedDecimal.vhd:254:53  */
  assign n1285 = n1284[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:101:38  */
  assign n1294 = bcd_exponent[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:101:15  */
  assign n1295 = {27'b0, n1294};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:101:9  */
  assign n1296 = {1'b0, n1295};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:38  */
  assign n1298 = bcd_exponent[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:102:15  */
  assign n1299 = {27'b0, n1298};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:102:9  */
  assign n1300 = {1'b0, n1299};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:38  */
  assign n1302 = bcd_exponent[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:103:15  */
  assign n1303 = {27'b0, n1302};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:103:9  */
  assign n1304 = {1'b0, n1303};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:104:15  */
  assign n1307 = $signed(n1296) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:25  */
  assign n1309 = $signed(n1300) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:19  */
  assign n1310 = n1307 | n1309;
  /* TG68K_FPU_PackedDecimal.vhd:104:35  */
  assign n1312 = $signed(n1304) > $signed(32'b00000000000000000000000000001001);
  /* TG68K_FPU_PackedDecimal.vhd:104:29  */
  assign n1313 = n1310 | n1312;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n1317 = n1313 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:104:9  */
  assign n1323 = n1313 ? 32'b11111111111111111111111111111111 : 32'bX;
  /* TG68K_FPU_PackedDecimal.vhd:107:19  */
  assign n1325 = $signed(n1304) * $signed(32'b00000000000000000000000001100100); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:30  */
  assign n1327 = $signed(n1300) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:107:25  */
  assign n1328 = n1325 + n1327;
  /* TG68K_FPU_PackedDecimal.vhd:107:35  */
  assign n1329 = n1328 + n1296;
  /* TG68K_FPU_PackedDecimal.vhd:107:9  */
  assign n1334 = n1317 ? n1329 : n1323;
  /* TG68K_FPU_PackedDecimal.vhd:256:83  */
  assign n1335 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:256:81  */
  assign n1336 = n1334 - n1335;
  /* TG68K_FPU_PackedDecimal.vhd:256:53  */
  assign n1337 = n1336[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:253:29  */
  assign n1338 = exp_sign ? n1285 : n1337;
  /* TG68K_FPU_PackedDecimal.vhd:259:78  */
  assign n1339 = n1130[63:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n1341 = n1133 ? packed_state : 3'b100;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n1342 = n1133 ? n1128 : n1339;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n1343 = n1133 ? decimal_exponent : n1338;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n1345 = n1133 ? n1232 : 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:226:25  */
  assign n1346 = n1133 ? n1228 : n1130;
  /* TG68K_FPU_PackedDecimal.vhd:218:21  */
  assign n1349 = packed_state == 3'b010;
  /* TG68K_FPU_PackedDecimal.vhd:267:40  */
  assign n1350 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:267:40  */
  assign n1352 = n1350 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:274:46  */
  assign n1354 = $signed(work_exponent) > $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:275:67  */
  assign n1356 = $signed(work_exponent) * $signed(32'b00000000000000000000000000000011); // smul
  /* TG68K_FPU_PackedDecimal.vhd:275:71  */
  assign n1358 = $signed(n1356) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:275:53  */
  assign n1359 = n1358[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:278:68  */
  assign n1361 = $signed(work_exponent) * $signed(32'b00000000000000000000000000000011); // smul
  /* TG68K_FPU_PackedDecimal.vhd:278:72  */
  assign n1363 = $signed(n1361) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:278:53  */
  assign n1364 = -n1363;
  /* TG68K_FPU_PackedDecimal.vhd:278:53  */
  assign n1365 = n1364[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:274:29  */
  assign n1366 = n1354 ? n1359 : n1365;
  /* TG68K_FPU_PackedDecimal.vhd:274:29  */
  assign n1369 = n1354 ? 1'b0 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n1371 = n1352 ? 68'b00000000000000000000000000000000000000000000000000000000000000000000 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n1372 = n1352 ? n1366 : decimal_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n1373 = n1352 ? n1369 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:267:25  */
  assign n1374 = n1352 ? work_mantissa : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:283:40  */
  assign n1375 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:283:40  */
  assign n1377 = $signed(n1375) < $signed(32'b00000000000000000000000000010001);
  /* TG68K_FPU_PackedDecimal.vhd:286:102  */
  assign n1378 = n1374[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:286:115  */
  assign n1380 = n1378 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:286:33  */
  assign n1382 = cycle_count == 6'b000000;
  /* TG68K_FPU_PackedDecimal.vhd:287:102  */
  assign n1383 = n1374[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:287:115  */
  assign n1385 = n1383 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:287:33  */
  assign n1387 = cycle_count == 6'b000001;
  /* TG68K_FPU_PackedDecimal.vhd:288:102  */
  assign n1388 = n1374[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:288:116  */
  assign n1390 = n1388 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:288:33  */
  assign n1392 = cycle_count == 6'b000010;
  /* TG68K_FPU_PackedDecimal.vhd:289:102  */
  assign n1393 = n1374[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:289:117  */
  assign n1395 = n1393 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:289:33  */
  assign n1397 = cycle_count == 6'b000011;
  /* TG68K_FPU_PackedDecimal.vhd:290:102  */
  assign n1398 = n1374[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:290:117  */
  assign n1400 = n1398 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:290:33  */
  assign n1402 = cycle_count == 6'b000100;
  /* TG68K_FPU_PackedDecimal.vhd:291:102  */
  assign n1403 = n1374[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:291:117  */
  assign n1405 = n1403 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:291:33  */
  assign n1407 = cycle_count == 6'b000101;
  /* TG68K_FPU_PackedDecimal.vhd:292:102  */
  assign n1408 = n1374[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:292:117  */
  assign n1410 = n1408 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:292:33  */
  assign n1412 = cycle_count == 6'b000110;
  /* TG68K_FPU_PackedDecimal.vhd:293:102  */
  assign n1413 = n1374[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:293:117  */
  assign n1415 = n1413 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:293:33  */
  assign n1417 = cycle_count == 6'b000111;
  /* TG68K_FPU_PackedDecimal.vhd:294:102  */
  assign n1418 = n1374[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:294:117  */
  assign n1420 = n1418 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:294:33  */
  assign n1422 = cycle_count == 6'b001000;
  /* TG68K_FPU_PackedDecimal.vhd:295:102  */
  assign n1423 = n1374[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:295:117  */
  assign n1425 = n1423 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:295:33  */
  assign n1427 = cycle_count == 6'b001001;
  /* TG68K_FPU_PackedDecimal.vhd:296:102  */
  assign n1428 = n1374[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:296:117  */
  assign n1430 = n1428 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:296:33  */
  assign n1432 = cycle_count == 6'b001010;
  /* TG68K_FPU_PackedDecimal.vhd:297:102  */
  assign n1433 = n1374[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:297:117  */
  assign n1435 = n1433 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:297:33  */
  assign n1437 = cycle_count == 6'b001011;
  /* TG68K_FPU_PackedDecimal.vhd:298:102  */
  assign n1438 = n1374[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:298:117  */
  assign n1440 = n1438 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:298:33  */
  assign n1442 = cycle_count == 6'b001100;
  /* TG68K_FPU_PackedDecimal.vhd:299:102  */
  assign n1443 = n1374[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:299:117  */
  assign n1445 = n1443 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:299:33  */
  assign n1447 = cycle_count == 6'b001101;
  /* TG68K_FPU_PackedDecimal.vhd:300:102  */
  assign n1448 = n1374[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:300:117  */
  assign n1450 = n1448 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:300:33  */
  assign n1452 = cycle_count == 6'b001110;
  /* TG68K_FPU_PackedDecimal.vhd:301:102  */
  assign n1453 = n1374[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:301:117  */
  assign n1455 = n1453 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:301:33  */
  assign n1457 = cycle_count == 6'b001111;
  /* TG68K_FPU_PackedDecimal.vhd:302:102  */
  assign n1458 = n1374[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:302:117  */
  assign n1460 = n1458 & 4'b1001;
  /* TG68K_FPU_PackedDecimal.vhd:302:33  */
  assign n1462 = cycle_count == 6'b010000;
  assign n1463 = {n1462, n1457, n1452, n1447, n1442, n1437, n1432, n1427, n1422, n1417, n1412, n1407, n1402, n1397, n1392, n1387, n1382};
  assign n1464 = n1371[3:0]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1465 = n1464;
      17'b01000000000000000: n1465 = n1464;
      17'b00100000000000000: n1465 = n1464;
      17'b00010000000000000: n1465 = n1464;
      17'b00001000000000000: n1465 = n1464;
      17'b00000100000000000: n1465 = n1464;
      17'b00000010000000000: n1465 = n1464;
      17'b00000001000000000: n1465 = n1464;
      17'b00000000100000000: n1465 = n1464;
      17'b00000000010000000: n1465 = n1464;
      17'b00000000001000000: n1465 = n1464;
      17'b00000000000100000: n1465 = n1464;
      17'b00000000000010000: n1465 = n1464;
      17'b00000000000001000: n1465 = n1464;
      17'b00000000000000100: n1465 = n1464;
      17'b00000000000000010: n1465 = n1464;
      17'b00000000000000001: n1465 = n1380;
      default: n1465 = n1464;
    endcase
  assign n1466 = n1371[7:4]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1467 = n1466;
      17'b01000000000000000: n1467 = n1466;
      17'b00100000000000000: n1467 = n1466;
      17'b00010000000000000: n1467 = n1466;
      17'b00001000000000000: n1467 = n1466;
      17'b00000100000000000: n1467 = n1466;
      17'b00000010000000000: n1467 = n1466;
      17'b00000001000000000: n1467 = n1466;
      17'b00000000100000000: n1467 = n1466;
      17'b00000000010000000: n1467 = n1466;
      17'b00000000001000000: n1467 = n1466;
      17'b00000000000100000: n1467 = n1466;
      17'b00000000000010000: n1467 = n1466;
      17'b00000000000001000: n1467 = n1466;
      17'b00000000000000100: n1467 = n1466;
      17'b00000000000000010: n1467 = n1385;
      17'b00000000000000001: n1467 = n1466;
      default: n1467 = n1466;
    endcase
  assign n1468 = n1371[11:8]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1469 = n1468;
      17'b01000000000000000: n1469 = n1468;
      17'b00100000000000000: n1469 = n1468;
      17'b00010000000000000: n1469 = n1468;
      17'b00001000000000000: n1469 = n1468;
      17'b00000100000000000: n1469 = n1468;
      17'b00000010000000000: n1469 = n1468;
      17'b00000001000000000: n1469 = n1468;
      17'b00000000100000000: n1469 = n1468;
      17'b00000000010000000: n1469 = n1468;
      17'b00000000001000000: n1469 = n1468;
      17'b00000000000100000: n1469 = n1468;
      17'b00000000000010000: n1469 = n1468;
      17'b00000000000001000: n1469 = n1468;
      17'b00000000000000100: n1469 = n1390;
      17'b00000000000000010: n1469 = n1468;
      17'b00000000000000001: n1469 = n1468;
      default: n1469 = n1468;
    endcase
  assign n1470 = n1371[15:12]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1471 = n1470;
      17'b01000000000000000: n1471 = n1470;
      17'b00100000000000000: n1471 = n1470;
      17'b00010000000000000: n1471 = n1470;
      17'b00001000000000000: n1471 = n1470;
      17'b00000100000000000: n1471 = n1470;
      17'b00000010000000000: n1471 = n1470;
      17'b00000001000000000: n1471 = n1470;
      17'b00000000100000000: n1471 = n1470;
      17'b00000000010000000: n1471 = n1470;
      17'b00000000001000000: n1471 = n1470;
      17'b00000000000100000: n1471 = n1470;
      17'b00000000000010000: n1471 = n1470;
      17'b00000000000001000: n1471 = n1395;
      17'b00000000000000100: n1471 = n1470;
      17'b00000000000000010: n1471 = n1470;
      17'b00000000000000001: n1471 = n1470;
      default: n1471 = n1470;
    endcase
  assign n1472 = n1371[19:16]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1473 = n1472;
      17'b01000000000000000: n1473 = n1472;
      17'b00100000000000000: n1473 = n1472;
      17'b00010000000000000: n1473 = n1472;
      17'b00001000000000000: n1473 = n1472;
      17'b00000100000000000: n1473 = n1472;
      17'b00000010000000000: n1473 = n1472;
      17'b00000001000000000: n1473 = n1472;
      17'b00000000100000000: n1473 = n1472;
      17'b00000000010000000: n1473 = n1472;
      17'b00000000001000000: n1473 = n1472;
      17'b00000000000100000: n1473 = n1472;
      17'b00000000000010000: n1473 = n1400;
      17'b00000000000001000: n1473 = n1472;
      17'b00000000000000100: n1473 = n1472;
      17'b00000000000000010: n1473 = n1472;
      17'b00000000000000001: n1473 = n1472;
      default: n1473 = n1472;
    endcase
  assign n1474 = n1371[23:20]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1475 = n1474;
      17'b01000000000000000: n1475 = n1474;
      17'b00100000000000000: n1475 = n1474;
      17'b00010000000000000: n1475 = n1474;
      17'b00001000000000000: n1475 = n1474;
      17'b00000100000000000: n1475 = n1474;
      17'b00000010000000000: n1475 = n1474;
      17'b00000001000000000: n1475 = n1474;
      17'b00000000100000000: n1475 = n1474;
      17'b00000000010000000: n1475 = n1474;
      17'b00000000001000000: n1475 = n1474;
      17'b00000000000100000: n1475 = n1405;
      17'b00000000000010000: n1475 = n1474;
      17'b00000000000001000: n1475 = n1474;
      17'b00000000000000100: n1475 = n1474;
      17'b00000000000000010: n1475 = n1474;
      17'b00000000000000001: n1475 = n1474;
      default: n1475 = n1474;
    endcase
  assign n1476 = n1371[27:24]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1477 = n1476;
      17'b01000000000000000: n1477 = n1476;
      17'b00100000000000000: n1477 = n1476;
      17'b00010000000000000: n1477 = n1476;
      17'b00001000000000000: n1477 = n1476;
      17'b00000100000000000: n1477 = n1476;
      17'b00000010000000000: n1477 = n1476;
      17'b00000001000000000: n1477 = n1476;
      17'b00000000100000000: n1477 = n1476;
      17'b00000000010000000: n1477 = n1476;
      17'b00000000001000000: n1477 = n1410;
      17'b00000000000100000: n1477 = n1476;
      17'b00000000000010000: n1477 = n1476;
      17'b00000000000001000: n1477 = n1476;
      17'b00000000000000100: n1477 = n1476;
      17'b00000000000000010: n1477 = n1476;
      17'b00000000000000001: n1477 = n1476;
      default: n1477 = n1476;
    endcase
  assign n1478 = n1371[31:28]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1479 = n1478;
      17'b01000000000000000: n1479 = n1478;
      17'b00100000000000000: n1479 = n1478;
      17'b00010000000000000: n1479 = n1478;
      17'b00001000000000000: n1479 = n1478;
      17'b00000100000000000: n1479 = n1478;
      17'b00000010000000000: n1479 = n1478;
      17'b00000001000000000: n1479 = n1478;
      17'b00000000100000000: n1479 = n1478;
      17'b00000000010000000: n1479 = n1415;
      17'b00000000001000000: n1479 = n1478;
      17'b00000000000100000: n1479 = n1478;
      17'b00000000000010000: n1479 = n1478;
      17'b00000000000001000: n1479 = n1478;
      17'b00000000000000100: n1479 = n1478;
      17'b00000000000000010: n1479 = n1478;
      17'b00000000000000001: n1479 = n1478;
      default: n1479 = n1478;
    endcase
  assign n1480 = n1371[35:32]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1481 = n1480;
      17'b01000000000000000: n1481 = n1480;
      17'b00100000000000000: n1481 = n1480;
      17'b00010000000000000: n1481 = n1480;
      17'b00001000000000000: n1481 = n1480;
      17'b00000100000000000: n1481 = n1480;
      17'b00000010000000000: n1481 = n1480;
      17'b00000001000000000: n1481 = n1480;
      17'b00000000100000000: n1481 = n1420;
      17'b00000000010000000: n1481 = n1480;
      17'b00000000001000000: n1481 = n1480;
      17'b00000000000100000: n1481 = n1480;
      17'b00000000000010000: n1481 = n1480;
      17'b00000000000001000: n1481 = n1480;
      17'b00000000000000100: n1481 = n1480;
      17'b00000000000000010: n1481 = n1480;
      17'b00000000000000001: n1481 = n1480;
      default: n1481 = n1480;
    endcase
  assign n1482 = n1371[39:36]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1483 = n1482;
      17'b01000000000000000: n1483 = n1482;
      17'b00100000000000000: n1483 = n1482;
      17'b00010000000000000: n1483 = n1482;
      17'b00001000000000000: n1483 = n1482;
      17'b00000100000000000: n1483 = n1482;
      17'b00000010000000000: n1483 = n1482;
      17'b00000001000000000: n1483 = n1425;
      17'b00000000100000000: n1483 = n1482;
      17'b00000000010000000: n1483 = n1482;
      17'b00000000001000000: n1483 = n1482;
      17'b00000000000100000: n1483 = n1482;
      17'b00000000000010000: n1483 = n1482;
      17'b00000000000001000: n1483 = n1482;
      17'b00000000000000100: n1483 = n1482;
      17'b00000000000000010: n1483 = n1482;
      17'b00000000000000001: n1483 = n1482;
      default: n1483 = n1482;
    endcase
  assign n1484 = n1371[43:40]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1485 = n1484;
      17'b01000000000000000: n1485 = n1484;
      17'b00100000000000000: n1485 = n1484;
      17'b00010000000000000: n1485 = n1484;
      17'b00001000000000000: n1485 = n1484;
      17'b00000100000000000: n1485 = n1484;
      17'b00000010000000000: n1485 = n1430;
      17'b00000001000000000: n1485 = n1484;
      17'b00000000100000000: n1485 = n1484;
      17'b00000000010000000: n1485 = n1484;
      17'b00000000001000000: n1485 = n1484;
      17'b00000000000100000: n1485 = n1484;
      17'b00000000000010000: n1485 = n1484;
      17'b00000000000001000: n1485 = n1484;
      17'b00000000000000100: n1485 = n1484;
      17'b00000000000000010: n1485 = n1484;
      17'b00000000000000001: n1485 = n1484;
      default: n1485 = n1484;
    endcase
  assign n1486 = n1371[47:44]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1487 = n1486;
      17'b01000000000000000: n1487 = n1486;
      17'b00100000000000000: n1487 = n1486;
      17'b00010000000000000: n1487 = n1486;
      17'b00001000000000000: n1487 = n1486;
      17'b00000100000000000: n1487 = n1435;
      17'b00000010000000000: n1487 = n1486;
      17'b00000001000000000: n1487 = n1486;
      17'b00000000100000000: n1487 = n1486;
      17'b00000000010000000: n1487 = n1486;
      17'b00000000001000000: n1487 = n1486;
      17'b00000000000100000: n1487 = n1486;
      17'b00000000000010000: n1487 = n1486;
      17'b00000000000001000: n1487 = n1486;
      17'b00000000000000100: n1487 = n1486;
      17'b00000000000000010: n1487 = n1486;
      17'b00000000000000001: n1487 = n1486;
      default: n1487 = n1486;
    endcase
  assign n1488 = n1371[51:48]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1489 = n1488;
      17'b01000000000000000: n1489 = n1488;
      17'b00100000000000000: n1489 = n1488;
      17'b00010000000000000: n1489 = n1488;
      17'b00001000000000000: n1489 = n1440;
      17'b00000100000000000: n1489 = n1488;
      17'b00000010000000000: n1489 = n1488;
      17'b00000001000000000: n1489 = n1488;
      17'b00000000100000000: n1489 = n1488;
      17'b00000000010000000: n1489 = n1488;
      17'b00000000001000000: n1489 = n1488;
      17'b00000000000100000: n1489 = n1488;
      17'b00000000000010000: n1489 = n1488;
      17'b00000000000001000: n1489 = n1488;
      17'b00000000000000100: n1489 = n1488;
      17'b00000000000000010: n1489 = n1488;
      17'b00000000000000001: n1489 = n1488;
      default: n1489 = n1488;
    endcase
  assign n1490 = n1371[55:52]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1491 = n1490;
      17'b01000000000000000: n1491 = n1490;
      17'b00100000000000000: n1491 = n1490;
      17'b00010000000000000: n1491 = n1445;
      17'b00001000000000000: n1491 = n1490;
      17'b00000100000000000: n1491 = n1490;
      17'b00000010000000000: n1491 = n1490;
      17'b00000001000000000: n1491 = n1490;
      17'b00000000100000000: n1491 = n1490;
      17'b00000000010000000: n1491 = n1490;
      17'b00000000001000000: n1491 = n1490;
      17'b00000000000100000: n1491 = n1490;
      17'b00000000000010000: n1491 = n1490;
      17'b00000000000001000: n1491 = n1490;
      17'b00000000000000100: n1491 = n1490;
      17'b00000000000000010: n1491 = n1490;
      17'b00000000000000001: n1491 = n1490;
      default: n1491 = n1490;
    endcase
  assign n1492 = n1371[59:56]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1493 = n1492;
      17'b01000000000000000: n1493 = n1492;
      17'b00100000000000000: n1493 = n1450;
      17'b00010000000000000: n1493 = n1492;
      17'b00001000000000000: n1493 = n1492;
      17'b00000100000000000: n1493 = n1492;
      17'b00000010000000000: n1493 = n1492;
      17'b00000001000000000: n1493 = n1492;
      17'b00000000100000000: n1493 = n1492;
      17'b00000000010000000: n1493 = n1492;
      17'b00000000001000000: n1493 = n1492;
      17'b00000000000100000: n1493 = n1492;
      17'b00000000000010000: n1493 = n1492;
      17'b00000000000001000: n1493 = n1492;
      17'b00000000000000100: n1493 = n1492;
      17'b00000000000000010: n1493 = n1492;
      17'b00000000000000001: n1493 = n1492;
      default: n1493 = n1492;
    endcase
  assign n1494 = n1371[63:60]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1495 = n1494;
      17'b01000000000000000: n1495 = n1455;
      17'b00100000000000000: n1495 = n1494;
      17'b00010000000000000: n1495 = n1494;
      17'b00001000000000000: n1495 = n1494;
      17'b00000100000000000: n1495 = n1494;
      17'b00000010000000000: n1495 = n1494;
      17'b00000001000000000: n1495 = n1494;
      17'b00000000100000000: n1495 = n1494;
      17'b00000000010000000: n1495 = n1494;
      17'b00000000001000000: n1495 = n1494;
      17'b00000000000100000: n1495 = n1494;
      17'b00000000000010000: n1495 = n1494;
      17'b00000000000001000: n1495 = n1494;
      17'b00000000000000100: n1495 = n1494;
      17'b00000000000000010: n1495 = n1494;
      17'b00000000000000001: n1495 = n1494;
      default: n1495 = n1494;
    endcase
  assign n1496 = n1371[67:64]; // extract
  /* TG68K_FPU_PackedDecimal.vhd:285:29  */
  always @*
    case (n1463)
      17'b10000000000000000: n1497 = n1460;
      17'b01000000000000000: n1497 = n1496;
      17'b00100000000000000: n1497 = n1496;
      17'b00010000000000000: n1497 = n1496;
      17'b00001000000000000: n1497 = n1496;
      17'b00000100000000000: n1497 = n1496;
      17'b00000010000000000: n1497 = n1496;
      17'b00000001000000000: n1497 = n1496;
      17'b00000000100000000: n1497 = n1496;
      17'b00000000010000000: n1497 = n1496;
      17'b00000000001000000: n1497 = n1496;
      17'b00000000000100000: n1497 = n1496;
      17'b00000000000010000: n1497 = n1496;
      17'b00000000000001000: n1497 = n1496;
      17'b00000000000000100: n1497 = n1496;
      17'b00000000000000010: n1497 = n1496;
      17'b00000000000000001: n1497 = n1496;
      default: n1497 = n1496;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:305:56  */
  assign n1498 = {26'b0, cycle_count};  //  uext
  /* TG68K_FPU_PackedDecimal.vhd:305:56  */
  assign n1500 = n1498 + 32'b00000000000000000000000000000001;
  /* TG68K_FPU_PackedDecimal.vhd:305:44  */
  assign n1501 = n1500[5:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:308:66  */
  assign n1502 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:308:68  */
  assign n1503 = {{25{k_factor[6]}}, k_factor}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:308:66  */
  assign n1504 = n1502 + n1503;
  /* TG68K_FPU_PackedDecimal.vhd:308:49  */
  assign n1505 = n1504[10:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:311:49  */
  assign n1506 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:311:49  */
  assign n1508 = $signed(n1506) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:313:63  */
  assign n1510 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:313:63  */
  assign n1511 = -n1510;
  /* TG68K_FPU_PackedDecimal.vhd:114:65  */
  assign n1518 = n1511 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:114:60  */
  assign n1519 = n1518[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:114:48  */
  assign n1520 = n1519[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:115:22  */
  assign n1524 = $signed(n1511) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:116:65  */
  assign n1526 = n1524 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:116:60  */
  assign n1527 = n1526[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:116:48  */
  assign n1528 = n1527[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:117:22  */
  assign n1531 = $signed(n1524) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:118:66  */
  assign n1533 = n1531 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:118:61  */
  assign n1534 = n1533[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:118:49  */
  assign n1535 = n1534[3:0];  // trunc
  assign n1536 = {n1535, n1528, n1520};
  /* TG68K_FPU_PackedDecimal.vhd:316:63  */
  assign n1538 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:114:65  */
  assign n1545 = n1538 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:114:60  */
  assign n1546 = n1545[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:114:48  */
  assign n1547 = n1546[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:115:22  */
  assign n1551 = $signed(n1538) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:116:65  */
  assign n1553 = n1551 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:116:60  */
  assign n1554 = n1553[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:116:48  */
  assign n1555 = n1554[3:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:117:22  */
  assign n1558 = $signed(n1551) / $signed(32'b00000000000000000000000000001010); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:118:66  */
  assign n1560 = n1558 % 32'b00000000000000000000000000001010; // smod
  /* TG68K_FPU_PackedDecimal.vhd:118:61  */
  assign n1561 = n1560[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:118:49  */
  assign n1562 = n1561[3:0];  // trunc
  assign n1563 = {n1562, n1555, n1547};
  /* TG68K_FPU_PackedDecimal.vhd:311:29  */
  assign n1564 = n1508 ? n1536 : n1563;
  /* TG68K_FPU_PackedDecimal.vhd:311:29  */
  assign n1567 = n1508 ? 1'b1 : 1'b0;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1569 = n1377 ? n1814 : 1'b1;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1571 = n1377 ? packed_state : 3'b110;
  assign n1572 = {n1497, n1495, n1493, n1491, n1489, n1487, n1485, n1483, n1481, n1479, n1477, n1475, n1473, n1471, n1469, n1467, n1465};
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1573 = n1377 ? n1572 : n1371;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1574 = n1377 ? bcd_exponent : n1564;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1575 = n1377 ? n1372 : n1505;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1576 = n1377 ? n1373 : n1567;
  /* TG68K_FPU_PackedDecimal.vhd:283:25  */
  assign n1577 = n1377 ? n1501 : cycle_count;
  /* TG68K_FPU_PackedDecimal.vhd:264:21  */
  assign n1579 = packed_state == 3'b011;
  /* TG68K_FPU_PackedDecimal.vhd:325:44  */
  assign n1581 = binary_mantissa == 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_PackedDecimal.vhd:331:58  */
  assign n1582 = {{21{decimal_exponent[10]}}, decimal_exponent}; // sext
  /* TG68K_FPU_PackedDecimal.vhd:331:58  */
  assign n1584 = $signed(n1582) * $signed(32'b00000000000000000000000000001010); // smul
  /* TG68K_FPU_PackedDecimal.vhd:331:63  */
  assign n1586 = $signed(n1584) / $signed(32'b00000000000000000000000000000011); // sdiv
  /* TG68K_FPU_PackedDecimal.vhd:331:67  */
  assign n1588 = n1586 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_PackedDecimal.vhd:333:41  */
  assign n1590 = $signed(n1588) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_PackedDecimal.vhd:335:61  */
  assign n1592 = {result_sign, 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_PackedDecimal.vhd:336:44  */
  assign n1594 = $signed(n1588) > $signed(32'b00000000000000000111111111111111);
  /* TG68K_FPU_PackedDecimal.vhd:339:61  */
  assign n1596 = {result_sign, 15'b111111111111111};
  /* TG68K_FPU_PackedDecimal.vhd:339:81  */
  assign n1598 = {n1596, 1'b1};
  /* TG68K_FPU_PackedDecimal.vhd:339:87  */
  assign n1600 = {n1598, 63'b000000000000000000000000000000000000000000000000000000000000000};
  /* TG68K_FPU_PackedDecimal.vhd:342:92  */
  assign n1601 = n1588[30:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:342:80  */
  assign n1602 = n1601[14:0];  // trunc
  /* TG68K_FPU_PackedDecimal.vhd:342:61  */
  assign n1603 = {result_sign, n1602};
  /* TG68K_FPU_PackedDecimal.vhd:342:107  */
  assign n1604 = {n1603, binary_mantissa};
  /* TG68K_FPU_PackedDecimal.vhd:336:29  */
  assign n1605 = n1594 ? n1600 : n1604;
  /* TG68K_FPU_PackedDecimal.vhd:336:29  */
  assign n1607 = n1594 ? 1'b1 : n1812;
  /* TG68K_FPU_PackedDecimal.vhd:333:29  */
  assign n1608 = n1590 ? n1592 : n1605;
  /* TG68K_FPU_PackedDecimal.vhd:333:29  */
  assign n1609 = n1590 ? n1812 : n1607;
  /* TG68K_FPU_PackedDecimal.vhd:325:25  */
  assign n1611 = n1581 ? 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000 : n1608;
  /* TG68K_FPU_PackedDecimal.vhd:325:25  */
  assign n1612 = n1581 ? n1812 : n1609;
  /* TG68K_FPU_PackedDecimal.vhd:323:21  */
  assign n1615 = packed_state == 3'b100;
  /* TG68K_FPU_PackedDecimal.vhd:348:21  */
  assign n1617 = packed_state == 3'b101;
  /* TG68K_FPU_PackedDecimal.vhd:354:47  */
  assign n1618 = ~packed_to_extended;
  /* TG68K_FPU_PackedDecimal.vhd:356:55  */
  assign n1619 = {result_sign, exp_sign};
  /* TG68K_FPU_PackedDecimal.vhd:356:66  */
  assign n1621 = {n1619, 2'b00};
  /* TG68K_FPU_PackedDecimal.vhd:356:73  */
  assign n1622 = {n1621, bcd_exponent};
  /* TG68K_FPU_PackedDecimal.vhd:356:88  */
  assign n1624 = {n1622, 1'b0};
  /* TG68K_FPU_PackedDecimal.vhd:356:94  */
  assign n1626 = {n1624, 11'b00000000000};
  /* TG68K_FPU_PackedDecimal.vhd:356:110  */
  assign n1627 = {n1626, bcd_digits};
  /* TG68K_FPU_PackedDecimal.vhd:354:25  */
  assign n1628 = n1618 ? n1627 : n1810;
  /* TG68K_FPU_PackedDecimal.vhd:353:21  */
  assign n1630 = packed_state == 3'b110;
  assign n1631 = {n1630, n1617, n1615, n1579, n1349, n1123, n944};
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1635 = 1'b1;
      7'b0100000: n1635 = n1804;
      7'b0010000: n1635 = n1804;
      7'b0001000: n1635 = n1804;
      7'b0000100: n1635 = n1804;
      7'b0000010: n1635 = n1804;
      7'b0000001: n1635 = 1'b0;
      default: n1635 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1639 = 1'b1;
      7'b0100000: n1639 = n1806;
      7'b0010000: n1639 = n1806;
      7'b0001000: n1639 = n1806;
      7'b0000100: n1639 = n1806;
      7'b0000010: n1639 = n1806;
      7'b0000001: n1639 = 1'b0;
      default: n1639 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1641 = n1808;
      7'b0100000: n1641 = n1808;
      7'b0010000: n1641 = n1611;
      7'b0001000: n1641 = n1808;
      7'b0000100: n1641 = n1808;
      7'b0000010: n1641 = n1808;
      7'b0000001: n1641 = n1808;
      default: n1641 = 80'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1643 = n1628;
      7'b0100000: n1643 = n1810;
      7'b0010000: n1643 = n1810;
      7'b0001000: n1643 = n1810;
      7'b0000100: n1643 = n1810;
      7'b0000010: n1643 = n1110;
      7'b0000001: n1643 = n1810;
      default: n1643 = 96'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1646 = n1812;
      7'b0100000: n1646 = n1812;
      7'b0010000: n1646 = n1612;
      7'b0001000: n1646 = n1812;
      7'b0000100: n1646 = n1812;
      7'b0000010: n1646 = n1111;
      7'b0000001: n1646 = 1'b0;
      default: n1646 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1650 = n1814;
      7'b0100000: n1650 = n1814;
      7'b0010000: n1650 = 1'b1;
      7'b0001000: n1650 = n1569;
      7'b0000100: n1650 = n1814;
      7'b0000010: n1650 = n1814;
      7'b0000001: n1650 = 1'b0;
      default: n1650 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1653 = n1816;
      7'b0100000: n1653 = n1816;
      7'b0010000: n1653 = n1816;
      7'b0001000: n1653 = n1816;
      7'b0000100: n1653 = n1816;
      7'b0000010: n1653 = n1112;
      7'b0000001: n1653 = 1'b0;
      default: n1653 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1658 = 3'b000;
      7'b0100000: n1658 = 3'b110;
      7'b0010000: n1658 = 3'b110;
      7'b0001000: n1658 = n1571;
      7'b0000100: n1658 = n1341;
      7'b0000010: n1658 = n1114;
      7'b0000001: n1658 = n942;
      default: n1658 = 3'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1660 = bcd_digits;
      7'b0100000: n1660 = bcd_digits;
      7'b0010000: n1660 = bcd_digits;
      7'b0001000: n1660 = n1573;
      7'b0000100: n1660 = bcd_digits;
      7'b0000010: n1660 = n1115;
      7'b0000001: n1660 = bcd_digits;
      default: n1660 = 68'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1662 = bcd_exponent;
      7'b0100000: n1662 = bcd_exponent;
      7'b0010000: n1662 = bcd_exponent;
      7'b0001000: n1662 = n1574;
      7'b0000100: n1662 = bcd_exponent;
      7'b0000010: n1662 = n1116;
      7'b0000001: n1662 = bcd_exponent;
      default: n1662 = 12'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1664 = binary_mantissa;
      7'b0100000: n1664 = binary_mantissa;
      7'b0010000: n1664 = binary_mantissa;
      7'b0001000: n1664 = binary_mantissa;
      7'b0000100: n1664 = n1342;
      7'b0000010: n1664 = binary_mantissa;
      7'b0000001: n1664 = binary_mantissa;
      default: n1664 = 64'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1666 = decimal_exponent;
      7'b0100000: n1666 = decimal_exponent;
      7'b0010000: n1666 = decimal_exponent;
      7'b0001000: n1666 = n1575;
      7'b0000100: n1666 = n1343;
      7'b0000010: n1666 = decimal_exponent;
      7'b0000001: n1666 = decimal_exponent;
      default: n1666 = 11'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1668 = work_mantissa;
      7'b0100000: n1668 = work_mantissa;
      7'b0010000: n1668 = work_mantissa;
      7'b0001000: n1668 = work_mantissa;
      7'b0000100: n1668 = work_mantissa;
      7'b0000010: n1668 = n1118;
      7'b0000001: n1668 = work_mantissa;
      default: n1668 = 128'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1670 = work_exponent;
      7'b0100000: n1670 = work_exponent;
      7'b0010000: n1670 = work_exponent;
      7'b0001000: n1670 = work_exponent;
      7'b0000100: n1670 = work_exponent;
      7'b0000010: n1670 = n1119;
      7'b0000001: n1670 = work_exponent;
      default: n1670 = 32'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1672 = result_sign;
      7'b0100000: n1672 = result_sign;
      7'b0010000: n1672 = result_sign;
      7'b0001000: n1672 = result_sign;
      7'b0000100: n1672 = result_sign;
      7'b0000010: n1672 = n1120;
      7'b0000001: n1672 = result_sign;
      default: n1672 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1674 = exp_sign;
      7'b0100000: n1674 = exp_sign;
      7'b0010000: n1674 = exp_sign;
      7'b0001000: n1674 = n1576;
      7'b0000100: n1674 = exp_sign;
      7'b0000010: n1674 = n1121;
      7'b0000001: n1674 = exp_sign;
      default: n1674 = 1'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1677 = cycle_count;
      7'b0100000: n1677 = cycle_count;
      7'b0010000: n1677 = cycle_count;
      7'b0001000: n1677 = n1577;
      7'b0000100: n1677 = n1345;
      7'b0000010: n1677 = cycle_count;
      7'b0000001: n1677 = 6'b000000;
      default: n1677 = 6'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:146:17  */
  always @*
    case (n1631)
      7'b1000000: n1679 = packed_conversion_temp_mantissa;
      7'b0100000: n1679 = packed_conversion_temp_mantissa;
      7'b0010000: n1679 = packed_conversion_temp_mantissa;
      7'b0001000: n1679 = n1374;
      7'b0000100: n1679 = n1346;
      7'b0000010: n1679 = packed_conversion_temp_mantissa;
      7'b0000001: n1679 = packed_conversion_temp_mantissa;
      default: n1679 = 128'bX;
    endcase
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1754 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1755 = clkena & n1754;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1756 = n1755 ? n1679 : packed_conversion_temp_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1757 <= n1756;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1766 = clkena ? n1658 : packed_state;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1767 <= 3'b000;
    else
      n1767 <= n1766;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1768 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1769 = clkena & n1768;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1770 = n1769 ? n1660 : bcd_digits;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1771 <= n1770;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1772 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1773 = clkena & n1772;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1774 = n1773 ? n1662 : bcd_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1775 <= n1774;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1776 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1777 = clkena & n1776;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1778 = n1777 ? n1664 : binary_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1779 <= n1778;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1781 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1782 = clkena & n1781;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1783 = n1782 ? n1666 : decimal_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1784 <= n1783;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1785 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1786 = clkena & n1785;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1787 = n1786 ? n1668 : work_mantissa;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1788 <= n1787;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1789 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1790 = clkena & n1789;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1791 = n1790 ? n1670 : work_exponent;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1792 <= n1791;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1793 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1794 = clkena & n1793;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1795 = n1794 ? n1672 : result_sign;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1796 <= n1795;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1797 = ~n939;
  /* TG68K_FPU_PackedDecimal.vhd:127:5  */
  assign n1798 = clkena & n1797;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1799 = n1798 ? n1674 : exp_sign;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk)
    n1800 <= n1799;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1801 = clkena ? n1677 : cycle_count;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1802 <= 6'b000000;
    else
      n1802 <= n1801;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1803 = clkena ? n1635 : n1804;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1804 <= 1'b0;
    else
      n1804 <= n1803;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1805 = clkena ? n1639 : n1806;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1806 <= 1'b0;
    else
      n1806 <= n1805;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1807 = clkena ? n1641 : n1808;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1808 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n1808 <= n1807;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1809 = clkena ? n1643 : n1810;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1810 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n1810 <= n1809;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1811 = clkena ? n1646 : n1812;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1812 <= 1'b0;
    else
      n1812 <= n1811;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1813 = clkena ? n1650 : n1814;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1814 <= 1'b0;
    else
      n1814 <= n1813;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  assign n1815 = clkena ? n1653 : n1816;
  /* TG68K_FPU_PackedDecimal.vhd:144:9  */
  always @(posedge clk or posedge n939)
    if (n939)
      n1816 <= 1'b0;
    else
      n1816 <= n1815;
endmodule

module TG68K_FPU_Converter
  (input  clk,
   input  nReset,
   input  clkena,
   input  start_conversion,
   input  [2:0] source_format,
   input  [2:0] dest_format,
   input  [95:0] data_in,
   output conversion_done,
   output conversion_valid,
   output [79:0] data_out,
   output overflow,
   output underflow,
   output inexact,
   output invalid);
  reg [2:0] conv_state;
  wire dest_sign;
  wire [14:0] dest_exp;
  wire [63:0] dest_mant;
  wire [79:0] dest_extended;
  wire [31:0] int_value;
  wire [31:0] int_magnitude;
  wire [4:0] leading_zeros;
  wire single_sign;
  wire [7:0] single_exp;
  wire [22:0] single_mant;
  wire double_sign;
  wire [10:0] double_exp;
  wire [51:0] double_mant;
  wire conv_overflow;
  wire conv_underflow;
  wire conv_inexact;
  wire conv_invalid;
  wire packed_start;
  wire packed_done;
  wire packed_to_ext;
  wire [6:0] packed_k_factor;
  wire [79:0] packed_ext_out;
  wire [95:0] packed_dec_out;
  wire packed_overflow;
  wire packed_inexact;
  wire packed_invalid;
  wire \packed_converter.conversion_valid ;
  wire [15:0] n15;
  wire [79:0] n16;
  wire n20;
  wire [2:0] n23;
  wire n25;
  wire [7:0] n26;
  wire [31:0] n27;
  wire n29;
  wire [15:0] n30;
  wire [31:0] n31;
  wire n33;
  wire [31:0] n34;
  wire n36;
  wire n37;
  wire [7:0] n38;
  wire [22:0] n39;
  wire n41;
  wire n42;
  wire [10:0] n43;
  wire [51:0] n44;
  wire n46;
  wire n47;
  wire [14:0] n48;
  wire [63:0] n49;
  wire n51;
  wire n53;
  wire [6:0] n54;
  reg [2:0] n63;
  reg n64;
  reg [14:0] n65;
  reg [63:0] n66;
  reg [31:0] n67;
  reg n68;
  reg [7:0] n69;
  reg [22:0] n70;
  reg n71;
  reg [10:0] n72;
  reg [51:0] n73;
  reg n75;
  reg n77;
  reg n79;
  reg [6:0] n81;
  wire n83;
  wire n85;
  wire n87;
  wire [31:0] n88;
  wire n91;
  wire [31:0] n92;
  wire n94;
  wire n100;
  wire n102;
  wire [4:0] n105;
  wire n109;
  wire [4:0] n111;
  wire n113;
  wire [4:0] n115;
  wire n118;
  wire n119;
  wire [4:0] n121;
  wire n125;
  wire n126;
  wire n128;
  wire n129;
  wire n131;
  wire n132;
  wire [4:0] n134;
  wire n138;
  wire n139;
  wire n141;
  wire n142;
  wire n144;
  wire n145;
  wire [4:0] n147;
  wire n151;
  wire n152;
  wire n154;
  wire n155;
  wire n157;
  wire n158;
  wire [4:0] n160;
  wire n164;
  wire n165;
  wire n167;
  wire n168;
  wire n170;
  wire n171;
  wire [4:0] n173;
  wire n177;
  wire n178;
  wire n180;
  wire n181;
  wire n183;
  wire n184;
  wire [4:0] n186;
  wire n190;
  wire n191;
  wire n193;
  wire n194;
  wire n196;
  wire n197;
  wire [4:0] n199;
  wire n203;
  wire n204;
  wire n206;
  wire n207;
  wire n209;
  wire n210;
  wire [4:0] n212;
  wire n216;
  wire n217;
  wire n219;
  wire n220;
  wire n222;
  wire n223;
  wire [4:0] n225;
  wire n229;
  wire n230;
  wire n232;
  wire n233;
  wire n235;
  wire n236;
  wire [4:0] n238;
  wire n242;
  wire n243;
  wire n245;
  wire n246;
  wire n248;
  wire n249;
  wire [4:0] n251;
  wire n255;
  wire n256;
  wire n258;
  wire n259;
  wire n261;
  wire n262;
  wire [4:0] n264;
  wire n268;
  wire n269;
  wire n271;
  wire n272;
  wire n274;
  wire n275;
  wire [4:0] n277;
  wire n281;
  wire n282;
  wire n284;
  wire n285;
  wire n287;
  wire n288;
  wire [4:0] n290;
  wire n294;
  wire n295;
  wire n297;
  wire n298;
  wire n300;
  wire n301;
  wire [4:0] n303;
  wire n307;
  wire n308;
  wire n310;
  wire n311;
  wire n313;
  wire n314;
  wire [4:0] n316;
  wire n320;
  wire n321;
  wire n323;
  wire n324;
  wire n326;
  wire n327;
  wire [4:0] n329;
  wire n333;
  wire n334;
  wire n336;
  wire n337;
  wire n339;
  wire n340;
  wire [4:0] n342;
  wire n346;
  wire n347;
  wire n349;
  wire n350;
  wire n352;
  wire n353;
  wire [4:0] n355;
  wire n359;
  wire n360;
  wire n362;
  wire n363;
  wire n365;
  wire n366;
  wire [4:0] n368;
  wire n372;
  wire n373;
  wire n375;
  wire n376;
  wire n378;
  wire n379;
  wire [4:0] n381;
  wire n385;
  wire n386;
  wire n388;
  wire n389;
  wire n391;
  wire n392;
  wire [4:0] n394;
  wire n398;
  wire n399;
  wire n401;
  wire n402;
  wire n404;
  wire n405;
  wire [4:0] n407;
  wire n411;
  wire n412;
  wire n414;
  wire n415;
  wire n417;
  wire n418;
  wire [4:0] n420;
  wire n424;
  wire n425;
  wire n427;
  wire n428;
  wire n430;
  wire n431;
  wire [4:0] n433;
  wire n437;
  wire n438;
  wire n440;
  wire n441;
  wire n443;
  wire n444;
  wire [4:0] n446;
  wire n450;
  wire n451;
  wire n453;
  wire n454;
  wire n456;
  wire n457;
  wire [4:0] n459;
  wire n463;
  wire n464;
  wire n466;
  wire n467;
  wire n469;
  wire n470;
  wire [4:0] n472;
  wire n476;
  wire n477;
  wire n479;
  wire n480;
  wire n482;
  wire n483;
  wire [4:0] n485;
  wire n489;
  wire n490;
  wire n492;
  wire n493;
  wire n495;
  wire n496;
  wire [4:0] n498;
  wire n503;
  wire n506;
  wire [2:0] n510;
  wire n512;
  wire [14:0] n514;
  wire [63:0] n516;
  wire [31:0] n517;
  wire [4:0] n518;
  wire n520;
  wire n522;
  wire n523;
  wire n525;
  wire n526;
  wire n528;
  wire n530;
  wire n532;
  wire [23:0] n534;
  wire [63:0] n536;
  wire [63:0] n538;
  wire [30:0] n539;
  wire [31:0] n540;
  wire [31:0] n542;
  wire [31:0] n544;
  wire [30:0] n545;
  wire [14:0] n546;
  wire [23:0] n548;
  wire [63:0] n550;
  wire [14:0] n552;
  wire [63:0] n553;
  wire [14:0] n556;
  wire [63:0] n558;
  wire n561;
  wire n563;
  wire n565;
  wire n567;
  wire [52:0] n569;
  wire [63:0] n571;
  wire [63:0] n573;
  wire [30:0] n574;
  wire [31:0] n575;
  wire [31:0] n577;
  wire [31:0] n579;
  wire [30:0] n580;
  wire [14:0] n581;
  wire [52:0] n583;
  wire [63:0] n585;
  wire [14:0] n587;
  wire [63:0] n588;
  wire [14:0] n591;
  wire [63:0] n593;
  wire n596;
  wire n597;
  wire [14:0] n598;
  wire [63:0] n599;
  wire [2:0] n601;
  wire n602;
  wire [14:0] n603;
  wire [63:0] n604;
  wire n605;
  wire n606;
  wire n607;
  wire n609;
  wire [3:0] n610;
  reg [2:0] n614;
  reg n615;
  reg [14:0] n616;
  reg [63:0] n617;
  reg [31:0] n618;
  reg [4:0] n619;
  reg n620;
  reg n621;
  reg n623;
  reg n625;
  wire n628;
  wire n630;
  wire [31:0] n631;
  wire [31:0] n633;
  wire [31:0] n635;
  wire [30:0] n636;
  wire [14:0] n637;
  wire [31:0] n638;
  wire n640;
  wire [63:0] n642;
  wire [31:0] n643;
  wire n645;
  wire [63:0] n647;
  wire [30:0] n648;
  wire [63:0] n649;
  wire [63:0] n651;
  wire [63:0] n652;
  wire [14:0] n654;
  wire [63:0] n656;
  wire n659;
  wire [15:0] n660;
  wire [79:0] n661;
  wire n663;
  wire n665;
  wire [15:0] n666;
  wire [79:0] n667;
  wire [1:0] n668;
  reg n671;
  reg n674;
  reg [79:0] n675;
  reg [2:0] n679;
  reg n681;
  reg n683;
  reg [6:0] n685;
  wire n687;
  wire [79:0] n688;
  wire n689;
  wire n690;
  wire n691;
  wire n693;
  wire n695;
  wire [79:0] n696;
  wire [2:0] n698;
  wire n699;
  wire n700;
  wire n701;
  wire n703;
  wire [5:0] n704;
  reg n707;
  reg n710;
  reg [79:0] n712;
  reg [2:0] n715;
  reg n717;
  reg [14:0] n719;
  reg [63:0] n721;
  reg [31:0] n723;
  reg [31:0] n725;
  reg [4:0] n727;
  reg n729;
  reg [7:0] n731;
  reg [22:0] n733;
  reg n735;
  reg [10:0] n737;
  reg [51:0] n739;
  reg n742;
  reg n745;
  reg n748;
  reg n751;
  reg n754;
  reg n756;
  reg [6:0] n758;
  wire [2:0] n846;
  reg [2:0] n847;
  wire n851;
  wire n852;
  wire n853;
  reg n854;
  wire n855;
  wire n856;
  wire [14:0] n857;
  reg [14:0] n858;
  wire n859;
  wire n860;
  wire [63:0] n861;
  reg [63:0] n862;
  wire n863;
  wire n864;
  wire [31:0] n865;
  reg [31:0] n866;
  wire n868;
  wire n869;
  wire [31:0] n870;
  reg [31:0] n871;
  wire n872;
  wire n873;
  wire [4:0] n874;
  reg [4:0] n875;
  wire n876;
  wire n877;
  wire n878;
  reg n879;
  wire n880;
  wire n881;
  wire [7:0] n882;
  reg [7:0] n883;
  wire n884;
  wire n885;
  wire [22:0] n886;
  reg [22:0] n887;
  wire n888;
  wire n889;
  wire n890;
  reg n891;
  wire n892;
  wire n893;
  wire [10:0] n894;
  reg [10:0] n895;
  wire n896;
  wire n897;
  wire [51:0] n898;
  reg [51:0] n899;
  wire n900;
  reg n901;
  wire n902;
  reg n903;
  wire n904;
  reg n905;
  wire n906;
  reg n907;
  wire n908;
  wire n909;
  wire n910;
  reg n911;
  wire n912;
  wire n913;
  wire n914;
  reg n915;
  wire n916;
  wire n917;
  wire [6:0] n918;
  reg [6:0] n919;
  wire n920;
  reg n921;
  wire n922;
  reg n923;
  wire [79:0] n924;
  reg [79:0] n925;
  assign conversion_done = n921; //(module output)
  assign conversion_valid = n923; //(module output)
  assign data_out = n925; //(module output)
  assign overflow = conv_overflow; //(module output)
  assign underflow = conv_underflow; //(module output)
  assign inexact = conv_inexact; //(module output)
  assign invalid = conv_invalid; //(module output)
  /* TG68K_FPU_Converter.vhd:82:16  */
  always @*
    conv_state = n847; // (isignal)
  initial
    conv_state = 3'b000;
  /* TG68K_FPU_Converter.vhd:88:16  */
  assign dest_sign = n854; // (signal)
  /* TG68K_FPU_Converter.vhd:89:16  */
  assign dest_exp = n858; // (signal)
  /* TG68K_FPU_Converter.vhd:90:16  */
  assign dest_mant = n862; // (signal)
  /* TG68K_FPU_Converter.vhd:91:16  */
  assign dest_extended = n16; // (signal)
  /* TG68K_FPU_Converter.vhd:94:16  */
  assign int_value = n866; // (signal)
  /* TG68K_FPU_Converter.vhd:96:16  */
  assign int_magnitude = n871; // (signal)
  /* TG68K_FPU_Converter.vhd:97:16  */
  assign leading_zeros = n875; // (signal)
  /* TG68K_FPU_Converter.vhd:100:16  */
  assign single_sign = n879; // (signal)
  /* TG68K_FPU_Converter.vhd:101:16  */
  assign single_exp = n883; // (signal)
  /* TG68K_FPU_Converter.vhd:102:16  */
  assign single_mant = n887; // (signal)
  /* TG68K_FPU_Converter.vhd:105:16  */
  assign double_sign = n891; // (signal)
  /* TG68K_FPU_Converter.vhd:106:16  */
  assign double_exp = n895; // (signal)
  /* TG68K_FPU_Converter.vhd:107:16  */
  assign double_mant = n899; // (signal)
  /* TG68K_FPU_Converter.vhd:110:16  */
  assign conv_overflow = n901; // (signal)
  /* TG68K_FPU_Converter.vhd:111:16  */
  assign conv_underflow = n903; // (signal)
  /* TG68K_FPU_Converter.vhd:112:16  */
  assign conv_inexact = n905; // (signal)
  /* TG68K_FPU_Converter.vhd:113:16  */
  assign conv_invalid = n907; // (signal)
  /* TG68K_FPU_Converter.vhd:116:16  */
  assign packed_start = n911; // (signal)
  /* TG68K_FPU_Converter.vhd:119:16  */
  assign packed_to_ext = n915; // (signal)
  /* TG68K_FPU_Converter.vhd:120:16  */
  assign packed_k_factor = n919; // (signal)
  /* TG68K_FPU_Converter.vhd:130:9  */
  tg68k_fpu_packeddecimal packed_converter (
    .clk(clk),
    .nreset(nReset),
    .clkena(clkena),
    .start_conversion(packed_start),
    .packed_to_extended(packed_to_ext),
    .k_factor(packed_k_factor),
    .extended_in(dest_extended),
    .packed_in(data_in),
    .conversion_done(packed_done),
    .conversion_valid(),
    .extended_out(packed_ext_out),
    .packed_out(packed_dec_out),
    .overflow(packed_overflow),
    .inexact(packed_inexact),
    .invalid(packed_invalid));
  /* TG68K_FPU_Converter.vhd:158:36  */
  assign n15 = {dest_sign, dest_exp};
  /* TG68K_FPU_Converter.vhd:158:47  */
  assign n16 = {n15, dest_mant};
  /* TG68K_FPU_Converter.vhd:165:27  */
  assign n20 = ~nReset;
  /* TG68K_FPU_Converter.vhd:186:49  */
  assign n23 = start_conversion ? 3'b001 : conv_state;
  /* TG68K_FPU_Converter.vhd:178:41  */
  assign n25 = conv_state == 3'b000;
  /* TG68K_FPU_Converter.vhd:195:99  */
  assign n26 = data_in[7:0]; // extract
  /* TG68K_FPU_Converter.vhd:195:78  */
  assign n27 = {{24{n26[7]}}, n26}; // sext
  /* TG68K_FPU_Converter.vhd:193:57  */
  assign n29 = source_format == 3'b110;
  /* TG68K_FPU_Converter.vhd:200:99  */
  assign n30 = data_in[15:0]; // extract
  /* TG68K_FPU_Converter.vhd:200:78  */
  assign n31 = {{16{n30[15]}}, n30}; // sext
  /* TG68K_FPU_Converter.vhd:198:57  */
  assign n33 = source_format == 3'b100;
  /* TG68K_FPU_Converter.vhd:205:92  */
  assign n34 = data_in[31:0]; // extract
  /* TG68K_FPU_Converter.vhd:203:57  */
  assign n36 = source_format == 3'b000;
  /* TG68K_FPU_Converter.vhd:210:87  */
  assign n37 = data_in[31]; // extract
  /* TG68K_FPU_Converter.vhd:211:86  */
  assign n38 = data_in[30:23]; // extract
  /* TG68K_FPU_Converter.vhd:212:87  */
  assign n39 = data_in[22:0]; // extract
  /* TG68K_FPU_Converter.vhd:208:57  */
  assign n41 = source_format == 3'b001;
  /* TG68K_FPU_Converter.vhd:217:87  */
  assign n42 = data_in[63]; // extract
  /* TG68K_FPU_Converter.vhd:218:86  */
  assign n43 = data_in[62:52]; // extract
  /* TG68K_FPU_Converter.vhd:219:87  */
  assign n44 = data_in[51:0]; // extract
  /* TG68K_FPU_Converter.vhd:215:57  */
  assign n46 = source_format == 3'b101;
  /* TG68K_FPU_Converter.vhd:224:85  */
  assign n47 = data_in[79]; // extract
  /* TG68K_FPU_Converter.vhd:225:84  */
  assign n48 = data_in[78:64]; // extract
  /* TG68K_FPU_Converter.vhd:226:85  */
  assign n49 = data_in[63:0]; // extract
  /* TG68K_FPU_Converter.vhd:222:57  */
  assign n51 = source_format == 3'b010;
  /* TG68K_FPU_Converter.vhd:229:57  */
  assign n53 = source_format == 3'b011;
  assign n54 = {n53, n51, n46, n41, n36, n33, n29};
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n63 = 3'b010;
      7'b0100000: n63 = 3'b101;
      7'b0010000: n63 = 3'b010;
      7'b0001000: n63 = 3'b010;
      7'b0000100: n63 = 3'b010;
      7'b0000010: n63 = 3'b010;
      7'b0000001: n63 = 3'b010;
      default: n63 = 3'b101;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n64 = dest_sign;
      7'b0100000: n64 = n47;
      7'b0010000: n64 = dest_sign;
      7'b0001000: n64 = dest_sign;
      7'b0000100: n64 = dest_sign;
      7'b0000010: n64 = dest_sign;
      7'b0000001: n64 = dest_sign;
      default: n64 = dest_sign;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n65 = dest_exp;
      7'b0100000: n65 = n48;
      7'b0010000: n65 = dest_exp;
      7'b0001000: n65 = dest_exp;
      7'b0000100: n65 = dest_exp;
      7'b0000010: n65 = dest_exp;
      7'b0000001: n65 = dest_exp;
      default: n65 = dest_exp;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n66 = dest_mant;
      7'b0100000: n66 = n49;
      7'b0010000: n66 = dest_mant;
      7'b0001000: n66 = dest_mant;
      7'b0000100: n66 = dest_mant;
      7'b0000010: n66 = dest_mant;
      7'b0000001: n66 = dest_mant;
      default: n66 = dest_mant;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n67 = int_value;
      7'b0100000: n67 = int_value;
      7'b0010000: n67 = int_value;
      7'b0001000: n67 = int_value;
      7'b0000100: n67 = n34;
      7'b0000010: n67 = n31;
      7'b0000001: n67 = n27;
      default: n67 = int_value;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n68 = single_sign;
      7'b0100000: n68 = single_sign;
      7'b0010000: n68 = single_sign;
      7'b0001000: n68 = n37;
      7'b0000100: n68 = single_sign;
      7'b0000010: n68 = single_sign;
      7'b0000001: n68 = single_sign;
      default: n68 = single_sign;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n69 = single_exp;
      7'b0100000: n69 = single_exp;
      7'b0010000: n69 = single_exp;
      7'b0001000: n69 = n38;
      7'b0000100: n69 = single_exp;
      7'b0000010: n69 = single_exp;
      7'b0000001: n69 = single_exp;
      default: n69 = single_exp;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n70 = single_mant;
      7'b0100000: n70 = single_mant;
      7'b0010000: n70 = single_mant;
      7'b0001000: n70 = n39;
      7'b0000100: n70 = single_mant;
      7'b0000010: n70 = single_mant;
      7'b0000001: n70 = single_mant;
      default: n70 = single_mant;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n71 = double_sign;
      7'b0100000: n71 = double_sign;
      7'b0010000: n71 = n42;
      7'b0001000: n71 = double_sign;
      7'b0000100: n71 = double_sign;
      7'b0000010: n71 = double_sign;
      7'b0000001: n71 = double_sign;
      default: n71 = double_sign;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n72 = double_exp;
      7'b0100000: n72 = double_exp;
      7'b0010000: n72 = n43;
      7'b0001000: n72 = double_exp;
      7'b0000100: n72 = double_exp;
      7'b0000010: n72 = double_exp;
      7'b0000001: n72 = double_exp;
      default: n72 = double_exp;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n73 = double_mant;
      7'b0100000: n73 = double_mant;
      7'b0010000: n73 = n44;
      7'b0001000: n73 = double_mant;
      7'b0000100: n73 = double_mant;
      7'b0000010: n73 = double_mant;
      7'b0000001: n73 = double_mant;
      default: n73 = double_mant;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n75 = conv_invalid;
      7'b0100000: n75 = conv_invalid;
      7'b0010000: n75 = conv_invalid;
      7'b0001000: n75 = conv_invalid;
      7'b0000100: n75 = conv_invalid;
      7'b0000010: n75 = conv_invalid;
      7'b0000001: n75 = conv_invalid;
      default: n75 = 1'b1;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n77 = 1'b1;
      7'b0100000: n77 = packed_start;
      7'b0010000: n77 = packed_start;
      7'b0001000: n77 = packed_start;
      7'b0000100: n77 = packed_start;
      7'b0000010: n77 = packed_start;
      7'b0000001: n77 = packed_start;
      default: n77 = packed_start;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n79 = 1'b1;
      7'b0100000: n79 = packed_to_ext;
      7'b0010000: n79 = packed_to_ext;
      7'b0001000: n79 = packed_to_ext;
      7'b0000100: n79 = packed_to_ext;
      7'b0000010: n79 = packed_to_ext;
      7'b0000001: n79 = packed_to_ext;
      default: n79 = packed_to_ext;
    endcase
  /* TG68K_FPU_Converter.vhd:192:49  */
  always @*
    case (n54)
      7'b1000000: n81 = 7'b0000000;
      7'b0100000: n81 = packed_k_factor;
      7'b0010000: n81 = packed_k_factor;
      7'b0001000: n81 = packed_k_factor;
      7'b0000100: n81 = packed_k_factor;
      7'b0000010: n81 = packed_k_factor;
      7'b0000001: n81 = packed_k_factor;
      default: n81 = packed_k_factor;
    endcase
  /* TG68K_FPU_Converter.vhd:190:41  */
  assign n83 = conv_state == 3'b001;
  /* TG68K_FPU_Converter.vhd:245:78  */
  assign n85 = int_value == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Converter.vhd:252:86  */
  assign n87 = $signed(int_value) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_FPU_Converter.vhd:254:115  */
  assign n88 = -int_value;
  /* TG68K_FPU_Converter.vhd:252:73  */
  assign n91 = n87 ? 1'b1 : 1'b0;
  /* TG68K_FPU_Converter.vhd:252:73  */
  assign n92 = n87 ? n88 : int_value;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n94 = int_magnitude[31]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n100 = n94 ? 1'b0 : 1'b1;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n102 = int_magnitude[30]; // extract
  /* TG68K_FPU_Converter.vhd:264:89  */
  assign n105 = n100 ? 5'b00001 : 5'b00000;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n109 = n118 ? 1'b0 : n100;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n111 = n102 ? n105 : 5'b00000;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n113 = n100 & n102;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n115 = n100 ? n111 : 5'b00000;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n118 = n113 & n100;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n119 = int_magnitude[29]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n121 = n129 ? 5'b00010 : n115;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n125 = n131 ? 1'b0 : n109;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n126 = n109 & n119;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n128 = n109 & n119;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n129 = n126 & n109;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n131 = n128 & n109;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n132 = int_magnitude[28]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n134 = n142 ? 5'b00011 : n121;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n138 = n144 ? 1'b0 : n125;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n139 = n125 & n132;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n141 = n125 & n132;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n142 = n139 & n125;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n144 = n141 & n125;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n145 = int_magnitude[27]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n147 = n155 ? 5'b00100 : n134;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n151 = n157 ? 1'b0 : n138;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n152 = n138 & n145;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n154 = n138 & n145;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n155 = n152 & n138;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n157 = n154 & n138;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n158 = int_magnitude[26]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n160 = n168 ? 5'b00101 : n147;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n164 = n170 ? 1'b0 : n151;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n165 = n151 & n158;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n167 = n151 & n158;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n168 = n165 & n151;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n170 = n167 & n151;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n171 = int_magnitude[25]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n173 = n181 ? 5'b00110 : n160;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n177 = n183 ? 1'b0 : n164;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n178 = n164 & n171;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n180 = n164 & n171;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n181 = n178 & n164;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n183 = n180 & n164;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n184 = int_magnitude[24]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n186 = n194 ? 5'b00111 : n173;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n190 = n196 ? 1'b0 : n177;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n191 = n177 & n184;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n193 = n177 & n184;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n194 = n191 & n177;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n196 = n193 & n177;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n197 = int_magnitude[23]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n199 = n207 ? 5'b01000 : n186;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n203 = n209 ? 1'b0 : n190;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n204 = n190 & n197;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n206 = n190 & n197;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n207 = n204 & n190;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n209 = n206 & n190;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n210 = int_magnitude[22]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n212 = n220 ? 5'b01001 : n199;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n216 = n222 ? 1'b0 : n203;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n217 = n203 & n210;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n219 = n203 & n210;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n220 = n217 & n203;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n222 = n219 & n203;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n223 = int_magnitude[21]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n225 = n233 ? 5'b01010 : n212;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n229 = n235 ? 1'b0 : n216;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n230 = n216 & n223;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n232 = n216 & n223;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n233 = n230 & n216;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n235 = n232 & n216;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n236 = int_magnitude[20]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n238 = n246 ? 5'b01011 : n225;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n242 = n248 ? 1'b0 : n229;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n243 = n229 & n236;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n245 = n229 & n236;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n246 = n243 & n229;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n248 = n245 & n229;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n249 = int_magnitude[19]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n251 = n259 ? 5'b01100 : n238;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n255 = n261 ? 1'b0 : n242;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n256 = n242 & n249;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n258 = n242 & n249;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n259 = n256 & n242;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n261 = n258 & n242;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n262 = int_magnitude[18]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n264 = n272 ? 5'b01101 : n251;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n268 = n274 ? 1'b0 : n255;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n269 = n255 & n262;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n271 = n255 & n262;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n272 = n269 & n255;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n274 = n271 & n255;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n275 = int_magnitude[17]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n277 = n285 ? 5'b01110 : n264;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n281 = n287 ? 1'b0 : n268;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n282 = n268 & n275;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n284 = n268 & n275;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n285 = n282 & n268;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n287 = n284 & n268;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n288 = int_magnitude[16]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n290 = n298 ? 5'b01111 : n277;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n294 = n300 ? 1'b0 : n281;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n295 = n281 & n288;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n297 = n281 & n288;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n298 = n295 & n281;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n300 = n297 & n281;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n301 = int_magnitude[15]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n303 = n311 ? 5'b10000 : n290;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n307 = n313 ? 1'b0 : n294;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n308 = n294 & n301;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n310 = n294 & n301;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n311 = n308 & n294;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n313 = n310 & n294;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n314 = int_magnitude[14]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n316 = n324 ? 5'b10001 : n303;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n320 = n326 ? 1'b0 : n307;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n321 = n307 & n314;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n323 = n307 & n314;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n324 = n321 & n307;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n326 = n323 & n307;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n327 = int_magnitude[13]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n329 = n337 ? 5'b10010 : n316;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n333 = n339 ? 1'b0 : n320;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n334 = n320 & n327;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n336 = n320 & n327;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n337 = n334 & n320;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n339 = n336 & n320;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n340 = int_magnitude[12]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n342 = n350 ? 5'b10011 : n329;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n346 = n352 ? 1'b0 : n333;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n347 = n333 & n340;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n349 = n333 & n340;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n350 = n347 & n333;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n352 = n349 & n333;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n353 = int_magnitude[11]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n355 = n363 ? 5'b10100 : n342;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n359 = n365 ? 1'b0 : n346;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n360 = n346 & n353;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n362 = n346 & n353;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n363 = n360 & n346;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n365 = n362 & n346;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n366 = int_magnitude[10]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n368 = n376 ? 5'b10101 : n355;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n372 = n378 ? 1'b0 : n359;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n373 = n359 & n366;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n375 = n359 & n366;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n376 = n373 & n359;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n378 = n375 & n359;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n379 = int_magnitude[9]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n381 = n389 ? 5'b10110 : n368;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n385 = n391 ? 1'b0 : n372;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n386 = n372 & n379;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n388 = n372 & n379;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n389 = n386 & n372;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n391 = n388 & n372;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n392 = int_magnitude[8]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n394 = n402 ? 5'b10111 : n381;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n398 = n404 ? 1'b0 : n385;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n399 = n385 & n392;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n401 = n385 & n392;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n402 = n399 & n385;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n404 = n401 & n385;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n405 = int_magnitude[7]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n407 = n415 ? 5'b11000 : n394;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n411 = n417 ? 1'b0 : n398;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n412 = n398 & n405;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n414 = n398 & n405;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n415 = n412 & n398;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n417 = n414 & n398;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n418 = int_magnitude[6]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n420 = n428 ? 5'b11001 : n407;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n424 = n430 ? 1'b0 : n411;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n425 = n411 & n418;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n427 = n411 & n418;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n428 = n425 & n411;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n430 = n427 & n411;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n431 = int_magnitude[5]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n433 = n441 ? 5'b11010 : n420;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n437 = n443 ? 1'b0 : n424;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n438 = n424 & n431;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n440 = n424 & n431;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n441 = n438 & n424;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n443 = n440 & n424;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n444 = int_magnitude[4]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n446 = n454 ? 5'b11011 : n433;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n450 = n456 ? 1'b0 : n437;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n451 = n437 & n444;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n453 = n437 & n444;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n454 = n451 & n437;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n456 = n453 & n437;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n457 = int_magnitude[3]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n459 = n467 ? 5'b11100 : n446;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n463 = n469 ? 1'b0 : n450;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n464 = n450 & n457;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n466 = n450 & n457;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n467 = n464 & n450;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n469 = n466 & n450;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n470 = int_magnitude[2]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n472 = n480 ? 5'b11101 : n459;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n476 = n482 ? 1'b0 : n463;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n477 = n463 & n470;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n479 = n463 & n470;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n480 = n477 & n463;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n482 = n479 & n463;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n483 = int_magnitude[1]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n485 = n493 ? 5'b11110 : n472;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n489 = n495 ? 1'b0 : n476;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n490 = n476 & n483;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n492 = n476 & n483;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n493 = n490 & n476;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n495 = n492 & n476;
  /* TG68K_FPU_Converter.vhd:263:97  */
  assign n496 = int_magnitude[0]; // extract
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n498 = n506 ? 5'b11111 : n485;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n503 = n489 & n496;
  /* TG68K_FPU_Converter.vhd:263:81  */
  assign n506 = n503 & n489;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n510 = n85 ? conv_state : 3'b011;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n512 = n85 ? 1'b0 : n91;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n514 = n85 ? 15'b000000000000000 : dest_exp;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n516 = n85 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : dest_mant;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n517 = n85 ? int_magnitude : n92;
  /* TG68K_FPU_Converter.vhd:245:65  */
  assign n518 = n85 ? leading_zeros : n498;
  /* TG68K_FPU_Converter.vhd:243:57  */
  assign n520 = source_format == 3'b110;
  /* TG68K_FPU_Converter.vhd:243:74  */
  assign n522 = source_format == 3'b100;
  /* TG68K_FPU_Converter.vhd:243:74  */
  assign n523 = n520 | n522;
  /* TG68K_FPU_Converter.vhd:243:88  */
  assign n525 = source_format == 3'b000;
  /* TG68K_FPU_Converter.vhd:243:88  */
  assign n526 = n523 | n525;
  /* TG68K_FPU_Converter.vhd:276:79  */
  assign n528 = single_exp == 8'b00000000;
  /* TG68K_FPU_Converter.vhd:280:82  */
  assign n530 = single_exp == 8'b11111111;
  /* TG68K_FPU_Converter.vhd:283:88  */
  assign n532 = single_mant == 23'b00000000000000000000000;
  /* TG68K_FPU_Converter.vhd:288:98  */
  assign n534 = {1'b1, single_mant};
  /* TG68K_FPU_Converter.vhd:288:112  */
  assign n536 = {n534, 40'b0000000000000000000000000000000000000000};
  /* TG68K_FPU_Converter.vhd:283:73  */
  assign n538 = n532 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n536;
  /* TG68K_FPU_Converter.vhd:292:85  */
  assign n539 = {23'b0, single_exp};  //  uext
  /* TG68K_FPU_Converter.vhd:292:118  */
  assign n540 = {1'b0, n539};  //  uext
  /* TG68K_FPU_Converter.vhd:292:118  */
  assign n542 = n540 - 32'b00000000000000000000000001111111;
  /* TG68K_FPU_Converter.vhd:292:136  */
  assign n544 = n542 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_Converter.vhd:293:114  */
  assign n545 = n544[30:0];  // trunc
  /* TG68K_FPU_Converter.vhd:293:102  */
  assign n546 = n545[14:0];  // trunc
  /* TG68K_FPU_Converter.vhd:295:90  */
  assign n548 = {1'b1, single_mant};
  /* TG68K_FPU_Converter.vhd:295:104  */
  assign n550 = {n548, 40'b0000000000000000000000000000000000000000};
  /* TG68K_FPU_Converter.vhd:280:65  */
  assign n552 = n530 ? 15'b111111111111111 : n546;
  /* TG68K_FPU_Converter.vhd:280:65  */
  assign n553 = n530 ? n538 : n550;
  /* TG68K_FPU_Converter.vhd:276:65  */
  assign n556 = n528 ? 15'b000000000000000 : n552;
  /* TG68K_FPU_Converter.vhd:276:65  */
  assign n558 = n528 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n553;
  /* TG68K_FPU_Converter.vhd:272:57  */
  assign n561 = source_format == 3'b001;
  /* TG68K_FPU_Converter.vhd:303:79  */
  assign n563 = double_exp == 11'b00000000000;
  /* TG68K_FPU_Converter.vhd:307:82  */
  assign n565 = double_exp == 11'b11111111111;
  /* TG68K_FPU_Converter.vhd:310:88  */
  assign n567 = double_mant == 52'b0000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Converter.vhd:315:98  */
  assign n569 = {1'b1, double_mant};
  /* TG68K_FPU_Converter.vhd:315:112  */
  assign n571 = {n569, 11'b00000000000};
  /* TG68K_FPU_Converter.vhd:310:73  */
  assign n573 = n567 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 : n571;
  /* TG68K_FPU_Converter.vhd:319:85  */
  assign n574 = {20'b0, double_exp};  //  uext
  /* TG68K_FPU_Converter.vhd:319:118  */
  assign n575 = {1'b0, n574};  //  uext
  /* TG68K_FPU_Converter.vhd:319:118  */
  assign n577 = n575 - 32'b00000000000000000000001111111111;
  /* TG68K_FPU_Converter.vhd:319:136  */
  assign n579 = n577 + 32'b00000000000000000011111111111111;
  /* TG68K_FPU_Converter.vhd:320:114  */
  assign n580 = n579[30:0];  // trunc
  /* TG68K_FPU_Converter.vhd:320:102  */
  assign n581 = n580[14:0];  // trunc
  /* TG68K_FPU_Converter.vhd:322:90  */
  assign n583 = {1'b1, double_mant};
  /* TG68K_FPU_Converter.vhd:322:104  */
  assign n585 = {n583, 11'b00000000000};
  /* TG68K_FPU_Converter.vhd:307:65  */
  assign n587 = n565 ? 15'b111111111111111 : n581;
  /* TG68K_FPU_Converter.vhd:307:65  */
  assign n588 = n565 ? n573 : n585;
  /* TG68K_FPU_Converter.vhd:303:65  */
  assign n591 = n563 ? 15'b000000000000000 : n587;
  /* TG68K_FPU_Converter.vhd:303:65  */
  assign n593 = n563 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n588;
  /* TG68K_FPU_Converter.vhd:299:57  */
  assign n596 = source_format == 3'b101;
  /* TG68K_FPU_Converter.vhd:331:100  */
  assign n597 = packed_ext_out[79]; // extract
  /* TG68K_FPU_Converter.vhd:332:99  */
  assign n598 = packed_ext_out[78:64]; // extract
  /* TG68K_FPU_Converter.vhd:333:100  */
  assign n599 = packed_ext_out[63:0]; // extract
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n601 = packed_done ? 3'b101 : conv_state;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n602 = packed_done ? n597 : dest_sign;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n603 = packed_done ? n598 : dest_exp;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n604 = packed_done ? n599 : dest_mant;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n605 = packed_done ? packed_overflow : conv_overflow;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n606 = packed_done ? packed_inexact : conv_inexact;
  /* TG68K_FPU_Converter.vhd:329:65  */
  assign n607 = packed_done ? packed_invalid : conv_invalid;
  /* TG68K_FPU_Converter.vhd:326:57  */
  assign n609 = source_format == 3'b011;
  assign n610 = {n609, n596, n561, n526};
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n614 = n601;
      4'b0100: n614 = 3'b101;
      4'b0010: n614 = 3'b101;
      4'b0001: n614 = n510;
      default: n614 = 3'b101;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n615 = n602;
      4'b0100: n615 = double_sign;
      4'b0010: n615 = single_sign;
      4'b0001: n615 = n512;
      default: n615 = dest_sign;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n616 = n603;
      4'b0100: n616 = n591;
      4'b0010: n616 = n556;
      4'b0001: n616 = n514;
      default: n616 = dest_exp;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n617 = n604;
      4'b0100: n617 = n593;
      4'b0010: n617 = n558;
      4'b0001: n617 = n516;
      default: n617 = dest_mant;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n618 = int_magnitude;
      4'b0100: n618 = int_magnitude;
      4'b0010: n618 = int_magnitude;
      4'b0001: n618 = n517;
      default: n618 = int_magnitude;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n619 = leading_zeros;
      4'b0100: n619 = leading_zeros;
      4'b0010: n619 = leading_zeros;
      4'b0001: n619 = n518;
      default: n619 = leading_zeros;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n620 = n605;
      4'b0100: n620 = conv_overflow;
      4'b0010: n620 = conv_overflow;
      4'b0001: n620 = conv_overflow;
      default: n620 = conv_overflow;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n621 = n606;
      4'b0100: n621 = conv_inexact;
      4'b0010: n621 = conv_inexact;
      4'b0001: n621 = conv_inexact;
      default: n621 = conv_inexact;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n623 = n607;
      4'b0100: n623 = conv_invalid;
      4'b0010: n623 = conv_invalid;
      4'b0001: n623 = conv_invalid;
      default: n623 = 1'b1;
    endcase
  /* TG68K_FPU_Converter.vhd:242:49  */
  always @*
    case (n610)
      4'b1000: n625 = 1'b0;
      4'b0100: n625 = packed_start;
      4'b0010: n625 = packed_start;
      4'b0001: n625 = packed_start;
      default: n625 = packed_start;
    endcase
  /* TG68K_FPU_Converter.vhd:241:41  */
  assign n628 = conv_state == 3'b010;
  /* TG68K_FPU_Converter.vhd:347:66  */
  assign n630 = int_magnitude == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Converter.vhd:352:93  */
  assign n631 = {27'b0, leading_zeros};  //  uext
  /* TG68K_FPU_Converter.vhd:352:93  */
  assign n633 = 32'b00000000000000000000000000011111 - n631;
  /* TG68K_FPU_Converter.vhd:352:87  */
  assign n635 = 32'b00000000000000000011111111111111 + n633;
  /* TG68K_FPU_Converter.vhd:353:98  */
  assign n636 = n635[30:0];  // trunc
  /* TG68K_FPU_Converter.vhd:353:86  */
  assign n637 = n636[14:0];  // trunc
  /* TG68K_FPU_Converter.vhd:357:74  */
  assign n638 = {27'b0, leading_zeros};  //  uext
  /* TG68K_FPU_Converter.vhd:357:74  */
  assign n640 = n638 == 32'b00000000000000000000000000000000;
  /* TG68K_FPU_Converter.vhd:359:92  */
  assign n642 = {int_magnitude, 32'b00000000000000000000000000000000};
  /* TG68K_FPU_Converter.vhd:360:77  */
  assign n643 = {27'b0, leading_zeros};  //  uext
  /* TG68K_FPU_Converter.vhd:360:77  */
  assign n645 = $signed(n643) <= $signed(32'b00000000000000000000000000011111);
  /* TG68K_FPU_Converter.vhd:362:129  */
  assign n647 = {int_magnitude, 32'b00000000000000000000000000000000};
  /* TG68K_FPU_Converter.vhd:362:145  */
  assign n648 = {26'b0, leading_zeros};  //  uext
  /* TG68K_FPU_Converter.vhd:362:95  */
  assign n649 = n647 << n648;
  /* TG68K_FPU_Converter.vhd:360:57  */
  assign n651 = n645 ? n649 : 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* TG68K_FPU_Converter.vhd:357:57  */
  assign n652 = n640 ? n642 : n651;
  /* TG68K_FPU_Converter.vhd:347:49  */
  assign n654 = n630 ? 15'b000000000000000 : n637;
  /* TG68K_FPU_Converter.vhd:347:49  */
  assign n656 = n630 ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n652;
  /* TG68K_FPU_Converter.vhd:345:41  */
  assign n659 = conv_state == 3'b011;
  /* TG68K_FPU_Converter.vhd:375:87  */
  assign n660 = {dest_sign, dest_exp};
  /* TG68K_FPU_Converter.vhd:375:98  */
  assign n661 = {n660, dest_mant};
  /* TG68K_FPU_Converter.vhd:373:57  */
  assign n663 = dest_format == 3'b010;
  /* TG68K_FPU_Converter.vhd:379:57  */
  assign n665 = dest_format == 3'b011;
  /* TG68K_FPU_Converter.vhd:387:87  */
  assign n666 = {dest_sign, dest_exp};
  /* TG68K_FPU_Converter.vhd:387:98  */
  assign n667 = {n666, dest_mant};
  assign n668 = {n665, n663};
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n671 = n921;
      2'b01: n671 = 1'b1;
      default: n671 = 1'b1;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n674 = n923;
      2'b01: n674 = 1'b1;
      default: n674 = 1'b1;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n675 = n925;
      2'b01: n675 = n661;
      default: n675 = n667;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n679 = 3'b100;
      2'b01: n679 = 3'b000;
      default: n679 = 3'b000;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n681 = 1'b1;
      2'b01: n681 = packed_start;
      default: n681 = packed_start;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n683 = 1'b0;
      2'b01: n683 = packed_to_ext;
      default: n683 = packed_to_ext;
    endcase
  /* TG68K_FPU_Converter.vhd:372:49  */
  always @*
    case (n668)
      2'b10: n685 = 7'b0000000;
      2'b01: n685 = packed_k_factor;
      default: n685 = packed_k_factor;
    endcase
  /* TG68K_FPU_Converter.vhd:370:41  */
  assign n687 = conv_state == 3'b101;
  /* TG68K_FPU_Converter.vhd:398:83  */
  assign n688 = packed_dec_out[79:0]; // extract
  /* TG68K_FPU_Converter.vhd:399:88  */
  assign n689 = conv_overflow | packed_overflow;
  /* TG68K_FPU_Converter.vhd:400:86  */
  assign n690 = conv_inexact | packed_inexact;
  /* TG68K_FPU_Converter.vhd:401:86  */
  assign n691 = conv_invalid | packed_invalid;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n693 = packed_done ? 1'b1 : n921;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n695 = packed_done ? 1'b1 : n923;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n696 = packed_done ? n688 : n925;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n698 = packed_done ? 3'b000 : conv_state;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n699 = packed_done ? n689 : conv_overflow;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n700 = packed_done ? n690 : conv_inexact;
  /* TG68K_FPU_Converter.vhd:396:49  */
  assign n701 = packed_done ? n691 : conv_invalid;
  /* TG68K_FPU_Converter.vhd:393:41  */
  assign n703 = conv_state == 3'b100;
  assign n704 = {n703, n687, n659, n628, n83, n25};
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n707 = n693;
      6'b010000: n707 = n671;
      6'b001000: n707 = n921;
      6'b000100: n707 = n921;
      6'b000010: n707 = n921;
      6'b000001: n707 = 1'b0;
      default: n707 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n710 = n695;
      6'b010000: n710 = n674;
      6'b001000: n710 = n923;
      6'b000100: n710 = n923;
      6'b000010: n710 = n923;
      6'b000001: n710 = 1'b0;
      default: n710 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n712 = n696;
      6'b010000: n712 = n675;
      6'b001000: n712 = n925;
      6'b000100: n712 = n925;
      6'b000010: n712 = n925;
      6'b000001: n712 = n925;
      default: n712 = 80'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n715 = n698;
      6'b010000: n715 = n679;
      6'b001000: n715 = 3'b101;
      6'b000100: n715 = n614;
      6'b000010: n715 = n63;
      6'b000001: n715 = n23;
      default: n715 = 3'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n717 = dest_sign;
      6'b010000: n717 = dest_sign;
      6'b001000: n717 = dest_sign;
      6'b000100: n717 = n615;
      6'b000010: n717 = n64;
      6'b000001: n717 = dest_sign;
      default: n717 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n719 = dest_exp;
      6'b010000: n719 = dest_exp;
      6'b001000: n719 = n654;
      6'b000100: n719 = n616;
      6'b000010: n719 = n65;
      6'b000001: n719 = dest_exp;
      default: n719 = 15'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n721 = dest_mant;
      6'b010000: n721 = dest_mant;
      6'b001000: n721 = n656;
      6'b000100: n721 = n617;
      6'b000010: n721 = n66;
      6'b000001: n721 = dest_mant;
      default: n721 = 64'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n723 = int_value;
      6'b010000: n723 = int_value;
      6'b001000: n723 = int_value;
      6'b000100: n723 = int_value;
      6'b000010: n723 = n67;
      6'b000001: n723 = int_value;
      default: n723 = 32'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n725 = int_magnitude;
      6'b010000: n725 = int_magnitude;
      6'b001000: n725 = int_magnitude;
      6'b000100: n725 = n618;
      6'b000010: n725 = int_magnitude;
      6'b000001: n725 = int_magnitude;
      default: n725 = 32'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n727 = leading_zeros;
      6'b010000: n727 = leading_zeros;
      6'b001000: n727 = leading_zeros;
      6'b000100: n727 = n619;
      6'b000010: n727 = leading_zeros;
      6'b000001: n727 = leading_zeros;
      default: n727 = 5'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n729 = single_sign;
      6'b010000: n729 = single_sign;
      6'b001000: n729 = single_sign;
      6'b000100: n729 = single_sign;
      6'b000010: n729 = n68;
      6'b000001: n729 = single_sign;
      default: n729 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n731 = single_exp;
      6'b010000: n731 = single_exp;
      6'b001000: n731 = single_exp;
      6'b000100: n731 = single_exp;
      6'b000010: n731 = n69;
      6'b000001: n731 = single_exp;
      default: n731 = 8'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n733 = single_mant;
      6'b010000: n733 = single_mant;
      6'b001000: n733 = single_mant;
      6'b000100: n733 = single_mant;
      6'b000010: n733 = n70;
      6'b000001: n733 = single_mant;
      default: n733 = 23'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n735 = double_sign;
      6'b010000: n735 = double_sign;
      6'b001000: n735 = double_sign;
      6'b000100: n735 = double_sign;
      6'b000010: n735 = n71;
      6'b000001: n735 = double_sign;
      default: n735 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n737 = double_exp;
      6'b010000: n737 = double_exp;
      6'b001000: n737 = double_exp;
      6'b000100: n737 = double_exp;
      6'b000010: n737 = n72;
      6'b000001: n737 = double_exp;
      default: n737 = 11'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n739 = double_mant;
      6'b010000: n739 = double_mant;
      6'b001000: n739 = double_mant;
      6'b000100: n739 = double_mant;
      6'b000010: n739 = n73;
      6'b000001: n739 = double_mant;
      default: n739 = 52'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n742 = n699;
      6'b010000: n742 = conv_overflow;
      6'b001000: n742 = conv_overflow;
      6'b000100: n742 = n620;
      6'b000010: n742 = conv_overflow;
      6'b000001: n742 = 1'b0;
      default: n742 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n745 = conv_underflow;
      6'b010000: n745 = conv_underflow;
      6'b001000: n745 = conv_underflow;
      6'b000100: n745 = conv_underflow;
      6'b000010: n745 = conv_underflow;
      6'b000001: n745 = 1'b0;
      default: n745 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n748 = n700;
      6'b010000: n748 = conv_inexact;
      6'b001000: n748 = conv_inexact;
      6'b000100: n748 = n621;
      6'b000010: n748 = conv_inexact;
      6'b000001: n748 = 1'b0;
      default: n748 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n751 = n701;
      6'b010000: n751 = conv_invalid;
      6'b001000: n751 = conv_invalid;
      6'b000100: n751 = n623;
      6'b000010: n751 = n75;
      6'b000001: n751 = 1'b0;
      default: n751 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n754 = 1'b0;
      6'b010000: n754 = n681;
      6'b001000: n754 = packed_start;
      6'b000100: n754 = n625;
      6'b000010: n754 = n77;
      6'b000001: n754 = packed_start;
      default: n754 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n756 = packed_to_ext;
      6'b010000: n756 = n683;
      6'b001000: n756 = packed_to_ext;
      6'b000100: n756 = packed_to_ext;
      6'b000010: n756 = n79;
      6'b000001: n756 = packed_to_ext;
      default: n756 = 1'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:177:33  */
  always @*
    case (n704)
      6'b100000: n758 = packed_k_factor;
      6'b010000: n758 = n685;
      6'b001000: n758 = packed_k_factor;
      6'b000100: n758 = packed_k_factor;
      6'b000010: n758 = n81;
      6'b000001: n758 = packed_k_factor;
      default: n758 = 7'bX;
    endcase
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n846 = clkena ? n715 : conv_state;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n847 <= 3'b000;
    else
      n847 <= n846;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n851 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n852 = clkena & n851;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n853 = n852 ? n717 : dest_sign;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n854 <= n853;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n855 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n856 = clkena & n855;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n857 = n856 ? n719 : dest_exp;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n858 <= n857;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n859 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n860 = clkena & n859;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n861 = n860 ? n721 : dest_mant;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n862 <= n861;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n863 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n864 = clkena & n863;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n865 = n864 ? n723 : int_value;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n866 <= n865;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n868 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n869 = clkena & n868;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n870 = n869 ? n725 : int_magnitude;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n871 <= n870;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n872 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n873 = clkena & n872;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n874 = n873 ? n727 : leading_zeros;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n875 <= n874;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n876 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n877 = clkena & n876;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n878 = n877 ? n729 : single_sign;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n879 <= n878;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n880 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n881 = clkena & n880;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n882 = n881 ? n731 : single_exp;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n883 <= n882;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n884 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n885 = clkena & n884;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n886 = n885 ? n733 : single_mant;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n887 <= n886;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n888 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n889 = clkena & n888;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n890 = n889 ? n735 : double_sign;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n891 <= n890;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n892 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n893 = clkena & n892;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n894 = n893 ? n737 : double_exp;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n895 <= n894;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n896 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n897 = clkena & n896;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n898 = n897 ? n739 : double_mant;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n899 <= n898;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n900 = clkena ? n742 : conv_overflow;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n901 <= 1'b0;
    else
      n901 <= n900;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n902 = clkena ? n745 : conv_underflow;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n903 <= 1'b0;
    else
      n903 <= n902;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n904 = clkena ? n748 : conv_inexact;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n905 <= 1'b0;
    else
      n905 <= n904;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n906 = clkena ? n751 : conv_invalid;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n907 <= 1'b0;
    else
      n907 <= n906;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n908 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n909 = clkena & n908;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n910 = n909 ? n754 : packed_start;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n911 <= n910;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n912 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n913 = clkena & n912;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n914 = n913 ? n756 : packed_to_ext;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n915 <= n914;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n916 = ~n20;
  /* TG68K_FPU_Converter.vhd:161:9  */
  assign n917 = clkena & n916;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n918 = n917 ? n758 : packed_k_factor;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk)
    n919 <= n918;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n920 = clkena ? n707 : n921;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n921 <= 1'b0;
    else
      n921 <= n920;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n922 = clkena ? n710 : n923;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n923 <= 1'b0;
    else
      n923 <= n922;
  /* TG68K_FPU_Converter.vhd:175:17  */
  assign n924 = clkena ? n712 : n925;
  /* TG68K_FPU_Converter.vhd:175:17  */
  always @(posedge clk or posedge n20)
    if (n20)
      n925 <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    else
      n925 <= n924;
endmodule

