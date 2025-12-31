module TG68K_PMMU_030
  (input  clk,
   input  nreset,
   input  reg_we,
   input  reg_re,
   input  [4:0] reg_sel,
   input  [31:0] reg_wdat,
   input  reg_part,
   input  reg_fd,
   input  ptest_req,
   input  pflush_req,
   input  pload_req,
   input  [2:0] pmmu_fc,
   input  [31:0] pmmu_addr,
   input  [15:0] pmmu_brief,
   input  req,
   input  is_insn,
   input  rw,
   input  [2:0] fc,
   input  [31:0] addr_log,
   input  mem_ack,
   input  mem_berr,
   input  [31:0] mem_rdat,
   input  mmu_config_ack,
   output [31:0] reg_rdat,
   output [31:0] addr_phys,
   output cache_inhibit,
   output write_protect,
   output fault,
   output [31:0] fault_status,
   output tc_enable,
   output mem_req,
   output mem_we,
   output [31:0] mem_addr,
   output [31:0] mem_wdat,
   output busy,
   output mmu_config_err);
  wire [31:0] tc;
  wire [31:0] crp_h;
  wire [31:0] crp_l;
  wire [31:0] srp_h;
  wire [31:0] srp_l;
  wire [31:0] tt0;
  wire [31:0] tt1;
  wire [31:0] mmusr;
  wire tc_en;
  reg [31:0] desc_addr_reg;
  reg [31:0] addr_phys_reg;
  reg cache_inhibit_reg;
  reg write_protect_reg;
  reg fault_reg;
  reg [31:0] fault_status_reg;
  reg walker_fault;
  reg [31:0] walker_fault_status;
  reg walker_fault_ack;
  reg walker_fault_ack_pending;
  reg walker_completed_ack;
  reg [31:0] saved_addr_log;
  reg [2:0] saved_fc;
  reg saved_is_insn;
  reg saved_rw;
  reg translation_pending;
  wire [255:0] atc_log_base;
  wire [255:0] atc_phys_base;
  wire [31:0] atc_attr;
  wire [7:0] atc_valid;
  wire [23:0] atc_fc;
  wire [7:0] atc_is_insn;
  wire [39:0] atc_shift;
  wire [7:0] atc_global;
  reg [2:0] atc_rr;
  wire walk_req;
  reg walker_completed;
  reg [19:0] tc_idx_bits;
  reg [3:0] tc_page_size;
  reg [3:0] tc_page_shift;
  reg tc_sre;
  reg tc_fcl;
  reg mmusr_update_req;
  reg mmusr_update_ack;
  reg [31:0] mmusr_update_value;
  reg mmu_config_error;
  reg [3:0] wstate;
  reg [31:0] walk_log_base;
  reg [31:0] walk_phys_base;
  reg [4:0] walk_page_shift;
  reg ptest_update_mmusr;
  reg pflush_clear_atc;
  reg atc_flush_req;
  reg ptest_req_prev;
  reg pflush_req_prev;
  reg pload_req_prev;
  reg ptest_active;
  reg [31:0] ptest_addr;
  reg [2:0] ptest_fc;
  reg ptest_rw;
  reg pload_active;
  reg [31:0] pload_addr;
  reg [2:0] pload_fc;
  reg pload_rw;
  reg [31:0] pflush_addr;
  reg [2:0] pflush_fc;
  reg [4:0] pflush_mode;
  reg [2:0] walk_level;
  reg [31:0] walk_desc;
  reg [31:0] walk_desc_high;
  reg [31:0] walk_desc_low;
  reg walk_desc_is_long;
  reg [31:0] walk_addr;
  reg [31:0] walk_vpn;
  reg [7:0] walk_attr;
  reg walk_global;
  reg walk_supervisor;
  reg [31:0] indirect_addr;
  reg indirect_target_long;
  reg walk_limit_valid;
  reg walk_limit_lu;
  reg [14:0] walk_limit_value;
  reg [31:0] desc_update_data;
  wire n96;
  wire n99;
  wire n100;
  wire n101;
  wire [31:0] n104;
  wire [31:0] n105;
  wire n108;
  wire [31:0] n109;
  wire n111;
  wire [31:0] n119;
  wire n120;
  wire n123;
  wire n125;
  wire [31:0] n127;
  wire n128;
  wire n131;
  wire n133;
  wire [31:0] n135;
  wire n136;
  wire [3:0] n138;
  wire [30:0] n139;
  wire [31:0] n140;
  wire n142;
  wire [3:0] n156;
  wire [30:0] n157;
  wire [31:0] n158;
  wire [3:0] n160;
  wire [30:0] n161;
  wire [31:0] n162;
  wire n165;
  wire [31:0] n167;
  wire [3:0] n168;
  wire [30:0] n169;
  wire [31:0] n170;
  wire [3:0] n172;
  wire [30:0] n173;
  wire [31:0] n174;
  wire [3:0] n176;
  wire [30:0] n177;
  wire [31:0] n178;
  wire [3:0] n180;
  wire [30:0] n181;
  wire [31:0] n182;
  wire n190;
  wire n192;
  wire n193;
  wire [31:0] n195;
  wire [31:0] n196;
  wire n199;
  wire [31:0] n200;
  wire n202;
  wire [31:0] n203;
  wire n205;
  wire [31:0] n206;
  wire n208;
  wire [31:0] n209;
  wire [31:0] n210;
  wire [31:0] n211;
  wire [31:0] n212;
  wire [31:0] n213;
  wire n215;
  wire n219;
  wire n220;
  wire n221;
  wire n223;
  wire n224;
  wire n227;
  wire n228;
  wire n229;
  wire n230;
  wire n231;
  wire [22:0] n233;
  wire [6:0] n234;
  wire [31:0] n237;
  wire n238;
  wire n241;
  wire n243;
  wire [31:0] n245;
  wire [1:0] n246;
  wire n248;
  wire n251;
  wire [31:0] n253;
  wire [31:0] n254;
  wire [31:0] n255;
  wire n256;
  wire n257;
  wire n260;
  wire n262;
  wire [31:0] n264;
  wire [1:0] n265;
  wire n267;
  wire n270;
  wire [31:0] n272;
  wire [31:0] n273;
  wire [31:0] n274;
  wire n275;
  wire n276;
  wire n279;
  wire n281;
  wire n282;
  wire n284;
  wire n285;
  wire n286;
  wire n288;
  wire n289;
  wire n290;
  wire n292;
  wire n293;
  wire n294;
  wire n296;
  wire n297;
  wire n299;
  wire [5:0] n300;
  reg [31:0] n301;
  reg [31:0] n302;
  reg [31:0] n303;
  reg [31:0] n304;
  reg [31:0] n305;
  reg [31:0] n306;
  reg [31:0] n307;
  wire n308;
  reg n309;
  wire n310;
  reg n311;
  wire n312;
  reg n313;
  wire n314;
  reg n315;
  reg n316;
  reg n318;
  wire [2:0] n337;
  wire n338;
  wire n339;
  wire [2:0] n340;
  wire [2:0] n341;
  wire [8:0] n343;
  wire [15:0] n344;
  wire [2:0] n345;
  wire n346;
  wire n348;
  wire [31:0] n362;
  wire n426;
  wire [31:0] n427;
  wire n429;
  wire [31:0] n430;
  wire n432;
  wire [31:0] n433;
  wire n435;
  wire n436;
  wire [31:0] n437;
  wire n439;
  wire n440;
  wire n441;
  wire [31:0] n442;
  wire n444;
  wire n445;
  wire [31:0] n446;
  wire n448;
  wire n449;
  wire n450;
  wire [31:0] n451;
  wire [15:0] n452;
  wire [31:0] n454;
  wire n456;
  wire [31:0] n457;
  wire n459;
  wire n460;
  wire n461;
  wire [3:0] n472;
  wire [30:0] n473;
  wire [3:0] n475;
  wire [30:0] n476;
  wire [3:0] n478;
  wire [30:0] n479;
  wire [3:0] n481;
  wire [30:0] n482;
  wire [4:0] n484;
  wire [4:0] n485;
  wire [4:0] n486;
  wire [4:0] n487;
  wire [3:0] n499;
  wire [30:0] n500;
  wire [31:0] n501;
  wire n503;
  wire [31:0] n505;
  wire n512;
  wire n514;
  wire n515;
  wire [31:0] n517;
  wire [3:0] n518;
  wire [3:0] n519;
  wire n606;
  wire [31:0] n607;
  wire n609;
  wire n610;
  reg [2:0] n611_hit_idx;
  wire n626;
  wire n629;
  wire n630;
  wire n631;
  wire n632;
  wire n634;
  wire [31:0] n636;
  wire n645;
  wire n661;
  wire [7:0] n663;
  wire [7:0] n665;
  wire [2:0] n667;
  wire [2:0] n669;
  wire [7:0] n671;
  wire n673;
  wire n676;
  wire n683;
  wire n685;
  wire n687;
  wire [7:0] n688;
  wire [7:0] n689;
  wire [7:0] n690;
  wire n692;
  wire n695;
  wire n698;
  wire n699;
  wire n701;
  wire [2:0] n703;
  wire [2:0] n704;
  wire [2:0] n705;
  wire n707;
  wire n710;
  wire n713;
  wire n714;
  wire n716;
  wire n718;
  wire n719;
  wire n721;
  wire n722;
  wire n724;
  wire n726;
  wire n727;
  wire n728;
  wire n729;
  wire n730;
  wire n731;
  wire n732;
  wire n733;
  wire n735;
  wire n737;
  wire n738;
  wire n739;
  wire n740;
  wire n742;
  wire n744;
  wire n746;
  wire n747;
  wire n748;
  wire n749;
  wire n750;
  wire n751;
  wire n752;
  wire n754;
  wire n755;
  wire n756;
  wire n757;
  wire n758;
  wire n760;
  wire n762;
  wire n764;
  wire n765;
  wire n766;
  wire n767;
  wire n768;
  wire n769;
  wire n770;
  wire n785;
  wire [7:0] n787;
  wire [7:0] n789;
  wire [2:0] n791;
  wire [2:0] n793;
  wire [7:0] n795;
  wire n797;
  wire n800;
  wire n807;
  wire n809;
  wire n811;
  wire [7:0] n812;
  wire [7:0] n813;
  wire [7:0] n814;
  wire n816;
  wire n819;
  wire n822;
  wire n823;
  wire n825;
  wire [2:0] n827;
  wire [2:0] n828;
  wire [2:0] n829;
  wire n831;
  wire n834;
  wire n837;
  wire n838;
  wire n840;
  wire n842;
  wire n843;
  wire n845;
  wire n846;
  wire n848;
  wire n850;
  wire n851;
  wire n852;
  wire n853;
  wire n854;
  wire n855;
  wire n856;
  wire n857;
  wire n859;
  wire n861;
  wire n862;
  wire n863;
  wire n864;
  wire n866;
  wire n868;
  wire n870;
  wire n871;
  wire n872;
  wire n873;
  wire n874;
  wire n875;
  wire n876;
  wire n878;
  wire n879;
  wire n880;
  wire n881;
  wire n882;
  wire n884;
  wire n886;
  wire n888;
  wire n889;
  wire n890;
  wire n891;
  wire n892;
  wire n893;
  wire n894;
  localparam [31:0] n903 = 32'b00000000000000000000000000000000;
  wire [19:0] n904;
  wire [1:0] n911;
  wire [2:0] n914;
  wire [31:0] n915;
  localparam [31:0] n924 = 32'b00000000000000000000000000000000;
  wire [19:0] n925;
  wire [1:0] n932;
  wire [2:0] n935;
  wire [31:0] n936;
  wire n937;
  wire [4:0] n939;
  wire [31:0] n940;
  wire n947;
  wire n949;
  wire n950;
  wire n953;
  wire [31:0] n959;
  wire [30:0] n960;
  wire [31:0] n962;
  wire [31:0] n964;
  wire [31:0] n966;
  wire [31:0] n967;
  wire [31:0] n972;
  wire [2:0] n978;
  wire n979;
  wire n980;
  wire n981;
  wire n982;
  wire [31:0] n983;
  wire n984;
  wire n985;
  wire n993;
  wire n995;
  wire n998;
  wire [4:0] n1000;
  wire [31:0] n1001;
  wire n1008;
  wire n1010;
  wire n1011;
  wire n1014;
  wire [31:0] n1020;
  wire [30:0] n1021;
  wire [31:0] n1023;
  wire [31:0] n1025;
  wire [31:0] n1027;
  wire [31:0] n1028;
  wire [31:0] n1033;
  wire [2:0] n1039;
  wire n1040;
  wire n1041;
  wire n1042;
  wire n1043;
  wire [31:0] n1044;
  wire n1045;
  wire n1046;
  wire n1053;
  wire [2:0] n1056;
  wire n1057;
  wire [2:0] n1059;
  wire n1061;
  wire [4:0] n1063;
  wire [31:0] n1064;
  wire n1071;
  wire n1073;
  wire n1074;
  wire n1077;
  wire [31:0] n1083;
  wire [30:0] n1084;
  wire [31:0] n1086;
  wire [31:0] n1088;
  wire [31:0] n1090;
  wire [31:0] n1091;
  wire [31:0] n1096;
  wire [2:0] n1102;
  wire n1103;
  wire n1104;
  wire n1105;
  wire n1106;
  wire [31:0] n1107;
  wire n1108;
  wire n1109;
  wire n1116;
  wire [2:0] n1118;
  wire n1119;
  wire n1120;
  wire n1122;
  wire [4:0] n1124;
  wire [31:0] n1125;
  wire n1132;
  wire n1134;
  wire n1135;
  wire n1138;
  wire [31:0] n1144;
  wire [30:0] n1145;
  wire [31:0] n1147;
  wire [31:0] n1149;
  wire [31:0] n1151;
  wire [31:0] n1152;
  wire [31:0] n1157;
  wire [2:0] n1163;
  wire n1164;
  wire n1165;
  wire n1166;
  wire n1167;
  wire [31:0] n1168;
  wire n1169;
  wire n1170;
  wire n1177;
  wire [2:0] n1179;
  wire n1180;
  wire n1181;
  wire n1183;
  wire [4:0] n1185;
  wire [31:0] n1186;
  wire n1193;
  wire n1195;
  wire n1196;
  wire n1199;
  wire [31:0] n1205;
  wire [30:0] n1206;
  wire [31:0] n1208;
  wire [31:0] n1210;
  wire [31:0] n1212;
  wire [31:0] n1213;
  wire [31:0] n1218;
  wire [2:0] n1224;
  wire n1225;
  wire n1226;
  wire n1227;
  wire n1228;
  wire [31:0] n1229;
  wire n1230;
  wire n1231;
  wire n1238;
  wire [2:0] n1240;
  wire n1241;
  wire n1242;
  wire n1244;
  wire [4:0] n1246;
  wire [31:0] n1247;
  wire n1254;
  wire n1256;
  wire n1257;
  wire n1260;
  wire [31:0] n1266;
  wire [30:0] n1267;
  wire [31:0] n1269;
  wire [31:0] n1271;
  wire [31:0] n1273;
  wire [31:0] n1274;
  wire [31:0] n1279;
  wire [2:0] n1285;
  wire n1286;
  wire n1287;
  wire n1288;
  wire n1289;
  wire [31:0] n1290;
  wire n1291;
  wire n1292;
  wire n1299;
  wire [2:0] n1301;
  wire n1302;
  wire n1303;
  wire n1305;
  wire [4:0] n1307;
  wire [31:0] n1308;
  wire n1315;
  wire n1317;
  wire n1318;
  wire n1321;
  wire [31:0] n1327;
  wire [30:0] n1328;
  wire [31:0] n1330;
  wire [31:0] n1332;
  wire [31:0] n1334;
  wire [31:0] n1335;
  wire [31:0] n1340;
  wire [2:0] n1346;
  wire n1347;
  wire n1348;
  wire n1349;
  wire n1350;
  wire [31:0] n1351;
  wire n1352;
  wire n1353;
  wire n1360;
  wire [2:0] n1362;
  wire n1363;
  wire n1364;
  wire n1366;
  wire [4:0] n1368;
  wire [31:0] n1369;
  wire n1376;
  wire n1378;
  wire n1379;
  wire n1382;
  wire [31:0] n1388;
  wire [30:0] n1389;
  wire [31:0] n1391;
  wire [31:0] n1393;
  wire [31:0] n1395;
  wire [31:0] n1396;
  wire [31:0] n1401;
  wire [2:0] n1407;
  wire n1408;
  wire n1409;
  wire n1410;
  wire n1411;
  wire [31:0] n1412;
  wire n1413;
  wire n1414;
  wire n1421;
  wire [2:0] n1423;
  wire n1424;
  wire n1425;
  wire n1427;
  wire n1428;
  wire [2:0] n1430;
  wire n1433;
  wire [2:0] n1438;
  wire [2:0] n1442;
  wire [31:0] n1445;
  wire [31:0] n1446;
  wire [2:0] n1448;
  wire n1451;
  wire n1452;
  wire [2:0] n1454;
  wire n1457;
  wire n1458;
  wire [2:0] n1461;
  localparam [31:0] n1470 = 32'b00000000000000000000000000000000;
  wire [15:0] n1471;
  wire n1477;
  wire [1:0] n1484;
  wire [2:0] n1487;
  wire [31:0] n1488;
  wire [2:0] n1490;
  wire [2:0] n1494;
  wire [31:0] n1497;
  wire [31:0] n1498;
  wire [2:0] n1500;
  wire [2:0] n1504;
  wire n1507;
  wire [2:0] n1509;
  wire [2:0] n1513;
  wire [31:0] n1516;
  wire [31:0] n1517;
  wire [2:0] n1521;
  wire [2:0] n1525;
  wire [2:0] n1530;
  wire [2:0] n1534;
  localparam [31:0] n1542 = 32'b00000000000000000000000000000000;
  wire [19:0] n1543;
  wire [1:0] n1549;
  wire [2:0] n1552;
  wire [31:0] n1553;
  wire [31:0] n1554;
  wire n1555;
  wire n1556;
  wire n1558;
  wire [31:0] n1559;
  wire [31:0] n1563;
  wire n1564;
  wire n1565;
  wire n1567;
  wire [31:0] n1568;
  wire n1570;
  wire [31:0] n1571;
  wire [31:0] n1576;
  wire n1577;
  wire n1579;
  wire n1581;
  wire [31:0] n1582;
  wire n1584;
  wire [31:0] n1585;
  wire [31:0] n1591;
  wire n1592;
  wire n1593;
  wire n1594;
  wire [31:0] n1595;
  wire n1596;
  wire [31:0] n1597;
  wire n1602;
  wire n1603;
  wire n1604;
  wire n1605;
  wire n1606;
  wire [31:0] n1617;
  wire [2:0] n1618;
  wire n1619;
  wire n1620;
  wire n1622;
  wire n1624;
  wire [31:0] n1625;
  wire n1626;
  wire n1627;
  wire n1628;
  wire [31:0] n1629;
  wire [31:0] n1630;
  wire [2:0] n1631;
  wire n1632;
  wire n1633;
  wire n1634;
  wire n1635;
  wire n1636;
  wire [31:0] n1637;
  wire [31:0] n1642;
  wire n1643;
  wire n1644;
  wire n1646;
  wire [31:0] n1647;
  wire [31:0] n1648;
  wire [2:0] n1649;
  wire n1650;
  wire n1651;
  wire n1652;
  wire n1653;
  wire n1654;
  wire [31:0] n1655;
  wire [2:0] n1659;
  wire [31:0] n1665;
  wire n1666;
  wire n1667;
  wire n1669;
  wire [31:0] n1670;
  wire [31:0] n1671;
  wire [2:0] n1672;
  wire n1673;
  wire n1674;
  wire n1675;
  wire n1676;
  wire n1677;
  wire [31:0] n1678;
  wire [2:0] n1682;
  wire [31:0] n1688;
  wire n1690;
  wire n1692;
  wire n1694;
  wire [31:0] n1696;
  wire [31:0] n1697;
  wire [2:0] n1698;
  wire n1699;
  wire n1700;
  wire n1702;
  wire n1703;
  wire n1704;
  wire [31:0] n1705;
  wire [2:0] n1710;
  wire [31:0] n1735;
  wire n1736;
  wire n1737;
  wire n1738;
  wire [31:0] n1739;
  wire [31:0] n1740;
  wire [2:0] n1741;
  wire n1742;
  wire n1743;
  wire n1744;
  wire n1745;
  wire n1746;
  wire [31:0] n1747;
  wire [2:0] n1749;
  wire n1761;
  wire n1762;
  wire n1777;
  wire [7:0] n1779;
  wire [7:0] n1781;
  wire [2:0] n1783;
  wire [2:0] n1785;
  wire [7:0] n1787;
  wire n1789;
  wire n1792;
  wire n1799;
  wire n1803;
  wire [7:0] n1804;
  wire [7:0] n1805;
  wire [7:0] n1806;
  wire n1808;
  wire n1811;
  wire n1814;
  wire n1815;
  wire n1817;
  wire [2:0] n1819;
  wire [2:0] n1820;
  wire [2:0] n1821;
  wire n1823;
  wire n1826;
  wire n1829;
  wire n1830;
  wire n1832;
  wire n1834;
  wire n1835;
  wire n1837;
  wire n1845;
  wire n1846;
  wire n1847;
  wire n1848;
  wire n1849;
  wire n1851;
  wire n1853;
  wire n1854;
  wire n1855;
  wire n1856;
  wire n1858;
  wire n1860;
  wire n1862;
  wire n1863;
  wire n1864;
  wire n1865;
  wire n1866;
  wire n1867;
  wire n1868;
  wire n1870;
  wire n1871;
  wire n1872;
  wire n1873;
  wire n1874;
  wire n1876;
  wire n1880;
  wire n1881;
  wire n1883;
  wire n1884;
  wire n1886;
  wire n1901;
  wire [7:0] n1903;
  wire [7:0] n1905;
  wire [2:0] n1907;
  wire [2:0] n1909;
  wire [7:0] n1911;
  wire n1913;
  wire n1916;
  wire n1923;
  wire n1927;
  wire [7:0] n1928;
  wire [7:0] n1929;
  wire [7:0] n1930;
  wire n1932;
  wire n1935;
  wire n1938;
  wire n1939;
  wire n1941;
  wire [2:0] n1943;
  wire [2:0] n1944;
  wire [2:0] n1945;
  wire n1947;
  wire n1950;
  wire n1953;
  wire n1954;
  wire n1956;
  wire n1958;
  wire n1959;
  wire n1961;
  wire n1969;
  wire n1970;
  wire n1971;
  wire n1972;
  wire n1973;
  wire n1975;
  wire n1977;
  wire n1978;
  wire n1979;
  wire n1980;
  wire n1982;
  wire n1984;
  wire n1986;
  wire n1987;
  wire n1988;
  wire n1989;
  wire n1990;
  wire n1991;
  wire n1992;
  wire n1994;
  wire n1995;
  wire n1996;
  wire n1997;
  wire n1998;
  wire n2000;
  wire n2004;
  wire n2005;
  wire n2007;
  wire n2008;
  wire n2010;
  localparam [31:0] n2017 = 32'b00000000000000000000000000000000;
  wire [19:0] n2018;
  wire [1:0] n2025;
  wire [2:0] n2028;
  wire [31:0] n2029;
  localparam [31:0] n2036 = 32'b00000000000000000000000000000000;
  wire [19:0] n2037;
  wire [1:0] n2044;
  wire [2:0] n2047;
  wire [31:0] n2048;
  wire [31:0] n2049;
  wire [2:0] n2050;
  wire n2052;
  wire n2053;
  wire n2055;
  wire n2057;
  wire n2059;
  wire [31:0] n2060;
  wire [31:0] n2061;
  wire [2:0] n2062;
  wire n2063;
  wire n2064;
  wire n2065;
  wire n2066;
  wire n2068;
  wire [31:0] n2069;
  wire [31:0] n2070;
  wire [2:0] n2071;
  wire n2072;
  wire n2073;
  wire n2074;
  wire n2075;
  wire n2076;
  wire [31:0] n2077;
  wire n2084;
  wire n2085;
  wire n2086;
  wire n2087;
  wire n2088;
  wire n2089;
  wire n2090;
  wire n2091;
  wire n2098;
  wire n2099;
  wire n2114;
  wire [7:0] n2116;
  wire [7:0] n2118;
  wire [2:0] n2120;
  wire [2:0] n2122;
  wire [7:0] n2124;
  wire n2126;
  wire n2129;
  wire n2136;
  wire [7:0] n2141;
  wire [7:0] n2142;
  wire [7:0] n2143;
  wire n2145;
  wire n2148;
  wire n2151;
  wire n2152;
  wire n2154;
  wire [2:0] n2156;
  wire [2:0] n2157;
  wire [2:0] n2158;
  wire n2160;
  wire n2163;
  wire n2166;
  wire n2167;
  wire n2169;
  wire n2171;
  wire n2172;
  wire n2174;
  wire n2182;
  wire n2183;
  wire n2184;
  wire n2185;
  wire n2186;
  wire n2188;
  wire n2191;
  wire n2192;
  wire n2193;
  wire n2195;
  wire n2200;
  wire n2202;
  wire n2204;
  wire n2208;
  wire n2210;
  wire n2213;
  wire n2218;
  wire n2221;
  wire n2238;
  wire [7:0] n2240;
  wire [7:0] n2242;
  wire [2:0] n2244;
  wire [2:0] n2246;
  wire [7:0] n2248;
  wire n2250;
  wire n2253;
  wire n2260;
  wire [7:0] n2265;
  wire [7:0] n2266;
  wire [7:0] n2267;
  wire n2269;
  wire n2272;
  wire n2275;
  wire n2276;
  wire n2278;
  wire [2:0] n2280;
  wire [2:0] n2281;
  wire [2:0] n2282;
  wire n2284;
  wire n2287;
  wire n2290;
  wire n2291;
  wire n2293;
  wire n2295;
  wire n2296;
  wire n2298;
  wire n2306;
  wire n2307;
  wire n2308;
  wire n2309;
  wire n2310;
  wire n2312;
  wire n2315;
  wire n2316;
  wire n2317;
  wire n2319;
  wire n2324;
  wire n2326;
  wire n2328;
  wire n2332;
  wire n2334;
  wire n2337;
  wire n2342;
  wire n2345;
  wire n2348;
  wire n2349;
  wire n2350;
  wire n2351;
  wire [4:0] n2353;
  wire [31:0] n2354;
  wire n2361;
  wire n2363;
  wire n2364;
  wire n2367;
  wire [31:0] n2373;
  wire [30:0] n2374;
  wire [31:0] n2376;
  wire [31:0] n2378;
  wire [31:0] n2380;
  wire [31:0] n2381;
  wire [31:0] n2386;
  wire [2:0] n2387;
  wire n2388;
  wire n2389;
  wire n2390;
  wire n2391;
  wire [31:0] n2392;
  wire n2393;
  wire n2394;
  wire n2397;
  wire [2:0] n2399;
  wire n2401;
  wire n2403;
  wire n2405;
  wire [4:0] n2407;
  wire [31:0] n2408;
  wire n2415;
  wire n2417;
  wire n2418;
  wire n2421;
  wire [31:0] n2427;
  wire [30:0] n2428;
  wire [31:0] n2430;
  wire [31:0] n2432;
  wire [31:0] n2434;
  wire [31:0] n2435;
  wire [31:0] n2440;
  wire [2:0] n2441;
  wire n2442;
  wire n2443;
  wire n2444;
  wire n2445;
  wire [31:0] n2446;
  wire n2447;
  wire n2448;
  wire n2450;
  wire [2:0] n2452;
  wire n2453;
  wire n2454;
  wire n2456;
  wire [4:0] n2458;
  wire [31:0] n2459;
  wire n2466;
  wire n2468;
  wire n2469;
  wire n2472;
  wire [31:0] n2478;
  wire [30:0] n2479;
  wire [31:0] n2481;
  wire [31:0] n2483;
  wire [31:0] n2485;
  wire [31:0] n2486;
  wire [31:0] n2491;
  wire [2:0] n2492;
  wire n2493;
  wire n2494;
  wire n2495;
  wire n2496;
  wire [31:0] n2497;
  wire n2498;
  wire n2499;
  wire n2501;
  wire [2:0] n2503;
  wire n2504;
  wire n2505;
  wire n2507;
  wire [4:0] n2509;
  wire [31:0] n2510;
  wire n2517;
  wire n2519;
  wire n2520;
  wire n2523;
  wire [31:0] n2529;
  wire [30:0] n2530;
  wire [31:0] n2532;
  wire [31:0] n2534;
  wire [31:0] n2536;
  wire [31:0] n2537;
  wire [31:0] n2542;
  wire [2:0] n2543;
  wire n2544;
  wire n2545;
  wire n2546;
  wire n2547;
  wire [31:0] n2548;
  wire n2549;
  wire n2550;
  wire n2552;
  wire [2:0] n2554;
  wire n2555;
  wire n2556;
  wire n2558;
  wire [4:0] n2560;
  wire [31:0] n2561;
  wire n2568;
  wire n2570;
  wire n2571;
  wire n2574;
  wire [31:0] n2580;
  wire [30:0] n2581;
  wire [31:0] n2583;
  wire [31:0] n2585;
  wire [31:0] n2587;
  wire [31:0] n2588;
  wire [31:0] n2593;
  wire [2:0] n2594;
  wire n2595;
  wire n2596;
  wire n2597;
  wire n2598;
  wire [31:0] n2599;
  wire n2600;
  wire n2601;
  wire n2603;
  wire [2:0] n2605;
  wire n2606;
  wire n2607;
  wire n2609;
  wire [4:0] n2611;
  wire [31:0] n2612;
  wire n2619;
  wire n2621;
  wire n2622;
  wire n2625;
  wire [31:0] n2631;
  wire [30:0] n2632;
  wire [31:0] n2634;
  wire [31:0] n2636;
  wire [31:0] n2638;
  wire [31:0] n2639;
  wire [31:0] n2644;
  wire [2:0] n2645;
  wire n2646;
  wire n2647;
  wire n2648;
  wire n2649;
  wire [31:0] n2650;
  wire n2651;
  wire n2652;
  wire n2654;
  wire [2:0] n2656;
  wire n2657;
  wire n2658;
  wire n2660;
  wire [4:0] n2662;
  wire [31:0] n2663;
  wire n2670;
  wire n2672;
  wire n2673;
  wire n2676;
  wire [31:0] n2682;
  wire [30:0] n2683;
  wire [31:0] n2685;
  wire [31:0] n2687;
  wire [31:0] n2689;
  wire [31:0] n2690;
  wire [31:0] n2695;
  wire [2:0] n2696;
  wire n2697;
  wire n2698;
  wire n2699;
  wire n2700;
  wire [31:0] n2701;
  wire n2702;
  wire n2703;
  wire n2705;
  wire [2:0] n2707;
  wire n2708;
  wire n2709;
  wire n2711;
  wire [4:0] n2713;
  wire [31:0] n2714;
  wire n2721;
  wire n2723;
  wire n2724;
  wire n2727;
  wire [31:0] n2733;
  wire [30:0] n2734;
  wire [31:0] n2736;
  wire [31:0] n2738;
  wire [31:0] n2740;
  wire [31:0] n2741;
  wire [31:0] n2746;
  wire [2:0] n2747;
  wire n2748;
  wire n2749;
  wire n2750;
  wire n2751;
  wire [31:0] n2752;
  wire n2753;
  wire n2754;
  wire n2756;
  wire [2:0] n2758;
  wire n2759;
  wire n2760;
  wire n2762;
  wire [31:0] n2763;
  wire [2:0] n2764;
  wire n2766;
  wire n2767;
  wire n2769;
  wire n2771;
  wire n2772;
  wire n2773;
  wire n2774;
  wire n2775;
  wire n2776;
  wire n2777;
  wire [2:0] n2779;
  wire n2781;
  wire n2782;
  wire n2783;
  wire n2784;
  wire n2785;
  wire n2786;
  wire n2788;
  wire n2796;
  wire n2797;
  wire n2798;
  wire n2799;
  wire n2800;
  wire n2801;
  wire n2803;
  wire n2811;
  wire n2812;
  wire n2827;
  wire [7:0] n2829;
  wire [7:0] n2831;
  wire [2:0] n2833;
  wire [2:0] n2835;
  wire [7:0] n2837;
  wire n2839;
  wire n2842;
  wire n2849;
  wire [7:0] n2854;
  wire [7:0] n2855;
  wire [7:0] n2856;
  wire n2858;
  wire n2861;
  wire n2864;
  wire n2865;
  wire n2867;
  wire [2:0] n2869;
  wire [2:0] n2870;
  wire [2:0] n2871;
  wire n2873;
  wire n2876;
  wire n2879;
  wire n2880;
  wire n2882;
  wire n2884;
  wire n2885;
  wire n2887;
  wire n2895;
  wire n2896;
  wire n2897;
  wire n2898;
  wire n2899;
  wire n2901;
  wire n2904;
  wire n2905;
  wire n2906;
  wire n2908;
  wire n2913;
  wire n2915;
  wire n2917;
  wire n2921;
  wire n2923;
  wire n2926;
  wire n2931;
  wire n2934;
  wire n2951;
  wire [7:0] n2953;
  wire [7:0] n2955;
  wire [2:0] n2957;
  wire [2:0] n2959;
  wire [7:0] n2961;
  wire n2963;
  wire n2966;
  wire n2973;
  wire [7:0] n2978;
  wire [7:0] n2979;
  wire [7:0] n2980;
  wire n2982;
  wire n2985;
  wire n2988;
  wire n2989;
  wire n2991;
  wire [2:0] n2993;
  wire [2:0] n2994;
  wire [2:0] n2995;
  wire n2997;
  wire n3000;
  wire n3003;
  wire n3004;
  wire n3006;
  wire n3008;
  wire n3009;
  wire n3011;
  wire n3019;
  wire n3020;
  wire n3021;
  wire n3022;
  wire n3023;
  wire n3025;
  wire n3028;
  wire n3029;
  wire n3030;
  wire n3032;
  wire n3037;
  wire n3039;
  wire n3041;
  wire n3045;
  wire n3047;
  wire n3050;
  wire n3055;
  wire n3058;
  wire n3061;
  wire n3062;
  wire [4:0] n3064;
  wire [31:0] n3065;
  wire n3072;
  wire n3074;
  wire n3075;
  wire n3078;
  wire [31:0] n3084;
  wire [30:0] n3085;
  wire [31:0] n3087;
  wire [31:0] n3089;
  wire [31:0] n3091;
  wire [31:0] n3092;
  wire [31:0] n3097;
  wire [2:0] n3098;
  wire n3099;
  wire n3100;
  wire n3101;
  wire n3102;
  wire [31:0] n3103;
  wire n3104;
  wire n3105;
  wire n3108;
  wire [2:0] n3110;
  wire n3112;
  wire n3114;
  wire n3116;
  wire [4:0] n3118;
  wire [31:0] n3119;
  wire n3126;
  wire n3128;
  wire n3129;
  wire n3132;
  wire [31:0] n3138;
  wire [30:0] n3139;
  wire [31:0] n3141;
  wire [31:0] n3143;
  wire [31:0] n3145;
  wire [31:0] n3146;
  wire [31:0] n3151;
  wire [2:0] n3152;
  wire n3153;
  wire n3154;
  wire n3155;
  wire n3156;
  wire [31:0] n3157;
  wire n3158;
  wire n3159;
  wire n3161;
  wire [2:0] n3163;
  wire n3164;
  wire n3165;
  wire n3167;
  wire [4:0] n3169;
  wire [31:0] n3170;
  wire n3177;
  wire n3179;
  wire n3180;
  wire n3183;
  wire [31:0] n3189;
  wire [30:0] n3190;
  wire [31:0] n3192;
  wire [31:0] n3194;
  wire [31:0] n3196;
  wire [31:0] n3197;
  wire [31:0] n3202;
  wire [2:0] n3203;
  wire n3204;
  wire n3205;
  wire n3206;
  wire n3207;
  wire [31:0] n3208;
  wire n3209;
  wire n3210;
  wire n3212;
  wire [2:0] n3214;
  wire n3215;
  wire n3216;
  wire n3218;
  wire [4:0] n3220;
  wire [31:0] n3221;
  wire n3228;
  wire n3230;
  wire n3231;
  wire n3234;
  wire [31:0] n3240;
  wire [30:0] n3241;
  wire [31:0] n3243;
  wire [31:0] n3245;
  wire [31:0] n3247;
  wire [31:0] n3248;
  wire [31:0] n3253;
  wire [2:0] n3254;
  wire n3255;
  wire n3256;
  wire n3257;
  wire n3258;
  wire [31:0] n3259;
  wire n3260;
  wire n3261;
  wire n3263;
  wire [2:0] n3265;
  wire n3266;
  wire n3267;
  wire n3269;
  wire [4:0] n3271;
  wire [31:0] n3272;
  wire n3279;
  wire n3281;
  wire n3282;
  wire n3285;
  wire [31:0] n3291;
  wire [30:0] n3292;
  wire [31:0] n3294;
  wire [31:0] n3296;
  wire [31:0] n3298;
  wire [31:0] n3299;
  wire [31:0] n3304;
  wire [2:0] n3305;
  wire n3306;
  wire n3307;
  wire n3308;
  wire n3309;
  wire [31:0] n3310;
  wire n3311;
  wire n3312;
  wire n3314;
  wire [2:0] n3316;
  wire n3317;
  wire n3318;
  wire n3320;
  wire [4:0] n3322;
  wire [31:0] n3323;
  wire n3330;
  wire n3332;
  wire n3333;
  wire n3336;
  wire [31:0] n3342;
  wire [30:0] n3343;
  wire [31:0] n3345;
  wire [31:0] n3347;
  wire [31:0] n3349;
  wire [31:0] n3350;
  wire [31:0] n3355;
  wire [2:0] n3356;
  wire n3357;
  wire n3358;
  wire n3359;
  wire n3360;
  wire [31:0] n3361;
  wire n3362;
  wire n3363;
  wire n3365;
  wire [2:0] n3367;
  wire n3368;
  wire n3369;
  wire n3371;
  wire [4:0] n3373;
  wire [31:0] n3374;
  wire n3381;
  wire n3383;
  wire n3384;
  wire n3387;
  wire [31:0] n3393;
  wire [30:0] n3394;
  wire [31:0] n3396;
  wire [31:0] n3398;
  wire [31:0] n3400;
  wire [31:0] n3401;
  wire [31:0] n3406;
  wire [2:0] n3407;
  wire n3408;
  wire n3409;
  wire n3410;
  wire n3411;
  wire [31:0] n3412;
  wire n3413;
  wire n3414;
  wire n3416;
  wire [2:0] n3418;
  wire n3419;
  wire n3420;
  wire n3422;
  wire [4:0] n3424;
  wire [31:0] n3425;
  wire n3432;
  wire n3434;
  wire n3435;
  wire n3438;
  wire [31:0] n3444;
  wire [30:0] n3445;
  wire [31:0] n3447;
  wire [31:0] n3449;
  wire [31:0] n3451;
  wire [31:0] n3452;
  wire [31:0] n3457;
  wire [2:0] n3458;
  wire n3459;
  wire n3460;
  wire n3461;
  wire n3462;
  wire [31:0] n3463;
  wire n3464;
  wire n3465;
  wire n3467;
  wire [2:0] n3469;
  wire n3470;
  wire n3471;
  wire n3473;
  wire [2:0] n3475;
  wire n3478;
  wire [2:0] n3483;
  wire [2:0] n3487;
  wire [31:0] n3490;
  wire [31:0] n3491;
  wire [2:0] n3493;
  wire n3496;
  wire n3497;
  wire [2:0] n3499;
  wire n3502;
  wire n3503;
  wire [2:0] n3506;
  localparam [31:0] n3515 = 32'b00000000000000000000000000000000;
  wire [15:0] n3516;
  wire n3522;
  wire [1:0] n3529;
  wire [2:0] n3532;
  wire [31:0] n3533;
  wire [2:0] n3535;
  wire [2:0] n3539;
  wire [31:0] n3542;
  wire [31:0] n3543;
  wire [2:0] n3545;
  wire [2:0] n3549;
  wire [2:0] n3553;
  wire [2:0] n3557;
  wire [31:0] n3560;
  wire [31:0] n3561;
  wire [2:0] n3563;
  wire [2:0] n3567;
  wire [2:0] n3572;
  wire [2:0] n3576;
  localparam [31:0] n3584 = 32'b00000000000000000000000000000000;
  wire [19:0] n3585;
  wire [1:0] n3591;
  wire [2:0] n3594;
  wire [31:0] n3595;
  wire [31:0] n3596;
  wire n3597;
  wire n3598;
  wire n3601;
  wire [31:0] n3602;
  wire n3604;
  wire [31:0] n3605;
  wire [31:0] n3610;
  wire n3611;
  wire n3613;
  wire n3615;
  wire [31:0] n3616;
  wire n3618;
  wire [31:0] n3619;
  wire n3625;
  wire n3627;
  wire [31:0] n3628;
  wire n3630;
  wire n3632;
  wire n3633;
  wire [31:0] n3634;
  wire n3635;
  wire [31:0] n3636;
  wire [31:0] n3641;
  wire n3642;
  wire n3643;
  wire n3644;
  wire [31:0] n3645;
  wire n3647;
  wire n3648;
  wire [31:0] n3649;
  wire [2:0] n3651;
  wire n3657;
  wire n3659;
  wire n3660;
  wire n3661;
  wire n3663;
  wire n3665;
  wire [31:0] n3666;
  wire n3667;
  wire n3668;
  wire n3669;
  wire [31:0] n3670;
  wire n3671;
  wire n3672;
  wire n3674;
  wire n3675;
  wire n3676;
  wire [31:0] n3677;
  wire [2:0] n3679;
  wire [31:0] n3691;
  wire n3693;
  wire n3695;
  wire n3697;
  wire [31:0] n3698;
  wire n3700;
  wire n3702;
  wire n3703;
  wire n3705;
  wire n3707;
  wire [31:0] n3708;
  wire [2:0] n3710;
  wire n3723;
  wire n3725;
  wire n3804;
  wire [2:0] n3805;
  reg [2:0] n3806;
  wire n3853;
  wire n3919;
  wire n3921;
  wire [4:0] n3930;
  wire [31:0] n3932;
  wire n3939;
  wire n3941;
  wire n3942;
  wire n3945;
  wire [31:0] n3951;
  wire [30:0] n3952;
  wire [31:0] n3954;
  wire [31:0] n3956;
  wire [31:0] n3958;
  wire [31:0] n3959;
  wire [31:0] n3964;
  wire n3965;
  wire n3966;
  wire [27:0] n3967;
  wire [31:0] n3969;
  wire [27:0] n3970;
  wire [31:0] n3972;
  wire [31:0] n3974;
  wire n3976;
  wire [3:0] n3978;
  wire [31:0] n3979;
  wire [31:0] n3981;
  wire [4:0] n3982;
  wire [2:0] n3985;
  wire [31:0] n3986;
  wire [31:0] n3987;
  wire [7:0] n3991;
  wire n3993;
  wire n3995;
  wire n3999;
  wire [28:0] n4007;
  wire [31:0] n4008;
  wire [31:0] n4009;
  wire [31:0] n4011;
  wire [31:0] n4013;
  wire n4024;
  wire n4026;
  wire n4027;
  wire n4031;
  wire [31:0] n4037;
  wire [1:0] n4038;
  wire [1:0] n4040;
  wire [31:0] n4043;
  wire [31:0] n4045;
  wire n4048;
  wire n4051;
  wire [31:0] n4054;
  wire n4055;
  wire n4057;
  wire n4058;
  wire n4060;
  wire [31:0] n4062;
  wire n4065;
  wire [4:0] n4066;
  wire [31:0] n4067;
  wire [31:0] n4068;
  wire [31:0] n4069;
  wire n4070;
  wire n4071;
  wire n4073;
  wire [4:0] n4074;
  wire [31:0] n4075;
  wire [31:0] n4076;
  wire [31:0] n4077;
  wire n4078;
  wire n4079;
  wire n4081;
  wire [4:0] n4082;
  wire [31:0] n4083;
  wire [31:0] n4084;
  wire [31:0] n4085;
  wire n4086;
  wire n4087;
  wire [31:0] n4089;
  wire n4092;
  wire n4094;
  wire n4095;
  wire n4098;
  wire [31:0] n4101;
  wire n4102;
  wire n4104;
  wire n4105;
  wire n4107;
  wire [31:0] n4109;
  wire [30:0] n4111;
  wire [31:0] n4112;
  wire [31:0] n4113;
  wire [31:0] n4115;
  wire [31:0] n4117;
  wire [30:0] n4118;
  wire [31:0] n4119;
  wire [31:0] n4120;
  wire [30:0] n4121;
  wire [31:0] n4122;
  wire [31:0] n4124;
  wire [31:0] n4130;
  wire n4131;
  wire n4132;
  wire [31:0] n4133;
  wire n4134;
  wire [14:0] n4135;
  wire [30:0] n4136;
  wire [14:0] n4137;
  wire n4138;
  localparam [31:0] n4147 = 32'b00000000000000000000000000000000;
  wire [15:0] n4148;
  wire n4155;
  wire [1:0] n4162;
  wire [2:0] n4164;
  wire [31:0] n4165;
  wire n4167;
  wire [31:0] n4168;
  wire [3:0] n4170;
  wire [30:0] n4171;
  wire [14:0] n4172;
  wire n4173;
  localparam [31:0] n4182 = 32'b00000000000000000000000000000000;
  wire [15:0] n4183;
  wire n4190;
  wire [1:0] n4197;
  wire [2:0] n4199;
  wire [31:0] n4200;
  wire n4202;
  wire [31:0] n4203;
  wire [3:0] n4205;
  wire n4206;
  wire [31:0] n4207;
  wire [3:0] n4208;
  wire [27:0] n4209;
  wire [31:0] n4211;
  wire [31:0] n4213;
  wire [30:0] n4214;
  wire [31:0] n4215;
  wire [31:0] n4216;
  wire n4225;
  localparam [31:0] n4234 = 32'b00000000000000000000000000000000;
  wire [15:0] n4235;
  wire n4242;
  wire [1:0] n4249;
  wire [2:0] n4251;
  wire [31:0] n4252;
  wire [1:0] n4261;
  wire n4263;
  localparam [31:0] n4274 = 32'b00000000000000000000000000000000;
  wire [15:0] n4275;
  wire n4282;
  wire [1:0] n4289;
  wire [2:0] n4291;
  wire [31:0] n4292;
  wire [1:0] n4298;
  wire n4300;
  wire [1:0] n4306;
  wire n4308;
  wire [27:0] n4313;
  wire [31:0] n4315;
  wire [31:0] n4316;
  wire [31:0] n4318;
  wire [2:0] n4319;
  wire [3:0] n4322;
  wire [2:0] n4323;
  wire [31:0] n4324;
  wire n4326;
  wire [3:0] n4328;
  wire [2:0] n4329;
  wire n4332;
  wire [31:0] n4333;
  wire n4334;
  wire n4336;
  wire [31:0] n4337;
  wire [3:0] n4339;
  wire [2:0] n4340;
  wire n4342;
  wire [31:0] n4343;
  wire n4346;
  wire n4348;
  wire n4349;
  wire n4350;
  wire [3:0] n4351;
  wire [2:0] n4352;
  wire [31:0] n4353;
  wire [31:0] n4354;
  wire n4355;
  wire [31:0] n4356;
  wire n4358;
  wire n4360;
  wire n4362;
  wire [31:0] n4363;
  wire [3:0] n4365;
  wire [2:0] n4366;
  wire [31:0] n4367;
  wire [31:0] n4368;
  wire n4369;
  wire [31:0] n4370;
  wire n4373;
  wire n4375;
  wire [31:0] n4376;
  wire [31:0] n4377;
  wire n4378;
  wire [31:0] n4379;
  wire [3:0] n4380;
  wire [2:0] n4381;
  wire [31:0] n4382;
  wire [31:0] n4383;
  wire n4384;
  wire [31:0] n4385;
  wire n4387;
  wire n4389;
  wire n4390;
  wire [31:0] n4392;
  localparam [31:0] n4401 = 32'b00000000000000000000000000000000;
  wire [15:0] n4402;
  wire n4409;
  wire [1:0] n4416;
  wire [2:0] n4418;
  wire [31:0] n4419;
  wire [1:0] n4425;
  wire n4427;
  wire [27:0] n4433;
  wire [31:0] n4435;
  wire [31:0] n4436;
  wire [31:0] n4438;
  wire [2:0] n4439;
  wire n4440;
  wire [14:0] n4441;
  wire n4442;
  wire n4443;
  wire [3:0] n4446;
  wire [2:0] n4447;
  wire [31:0] n4448;
  wire n4449;
  wire n4451;
  wire n4452;
  wire [14:0] n4453;
  wire n4455;
  wire [3:0] n4456;
  wire [2:0] n4457;
  wire [31:0] n4458;
  wire [31:0] n4459;
  wire n4460;
  wire n4461;
  wire n4462;
  wire [14:0] n4463;
  wire n4465;
  wire n4467;
  wire [31:0] n4468;
  wire [3:0] n4470;
  wire [2:0] n4471;
  wire [31:0] n4472;
  wire [31:0] n4473;
  wire n4476;
  wire n4477;
  wire n4478;
  wire [14:0] n4479;
  wire n4481;
  wire [31:0] n4482;
  wire n4483;
  wire [31:0] n4484;
  wire [3:0] n4485;
  wire [2:0] n4486;
  wire [31:0] n4487;
  wire [31:0] n4488;
  wire n4490;
  wire n4491;
  wire n4492;
  wire [14:0] n4493;
  wire n4495;
  wire [28:0] n4503;
  wire [31:0] n4504;
  wire [31:0] n4505;
  wire [31:0] n4507;
  wire [31:0] n4509;
  wire n4520;
  wire n4522;
  wire n4523;
  wire n4527;
  wire [31:0] n4533;
  wire [1:0] n4534;
  wire [1:0] n4536;
  wire [31:0] n4539;
  wire [31:0] n4541;
  wire n4544;
  wire n4547;
  wire [31:0] n4550;
  wire n4551;
  wire n4553;
  wire n4554;
  wire n4556;
  wire [31:0] n4558;
  wire n4561;
  wire [4:0] n4562;
  wire [31:0] n4563;
  wire [31:0] n4564;
  wire [31:0] n4565;
  wire n4566;
  wire n4567;
  wire n4569;
  wire [4:0] n4570;
  wire [31:0] n4571;
  wire [31:0] n4572;
  wire [31:0] n4573;
  wire n4574;
  wire n4575;
  wire n4577;
  wire [4:0] n4578;
  wire [31:0] n4579;
  wire [31:0] n4580;
  wire [31:0] n4581;
  wire n4582;
  wire n4583;
  wire [31:0] n4585;
  wire n4588;
  wire n4590;
  wire n4591;
  wire n4594;
  wire [31:0] n4597;
  wire n4598;
  wire n4600;
  wire n4601;
  wire n4603;
  wire [31:0] n4605;
  wire [30:0] n4607;
  wire [31:0] n4608;
  wire [31:0] n4609;
  wire [31:0] n4611;
  wire [31:0] n4613;
  wire [30:0] n4614;
  wire [31:0] n4615;
  wire [31:0] n4616;
  wire [30:0] n4617;
  wire [31:0] n4618;
  wire [31:0] n4620;
  wire [31:0] n4626;
  wire [27:0] n4627;
  wire [31:0] n4629;
  wire [31:0] n4631;
  wire [30:0] n4632;
  wire [31:0] n4633;
  wire [31:0] n4634;
  wire n4635;
  wire [30:0] n4636;
  wire [14:0] n4637;
  wire n4638;
  localparam [31:0] n4647 = 32'b00000000000000000000000000000000;
  wire [15:0] n4648;
  wire n4655;
  wire [1:0] n4662;
  wire [2:0] n4664;
  wire [31:0] n4665;
  wire n4667;
  wire [31:0] n4668;
  wire [3:0] n4670;
  wire [30:0] n4671;
  wire [14:0] n4672;
  wire n4673;
  localparam [31:0] n4682 = 32'b00000000000000000000000000000000;
  wire [15:0] n4683;
  wire n4690;
  wire [1:0] n4697;
  wire [2:0] n4699;
  wire [31:0] n4700;
  wire n4702;
  wire [31:0] n4703;
  wire [3:0] n4705;
  wire n4706;
  wire [31:0] n4707;
  wire [3:0] n4708;
  wire n4709;
  wire [31:0] n4710;
  wire [3:0] n4711;
  wire n4713;
  wire n4720;
  wire [31:0] n4721;
  wire [31:0] n4722;
  localparam [31:0] n4731 = 32'b00000000000000000000000000000000;
  wire [15:0] n4732;
  wire n4739;
  wire [1:0] n4746;
  wire [2:0] n4748;
  wire [31:0] n4749;
  wire [1:0] n4755;
  wire n4757;
  localparam [31:0] n4766 = 32'b00000000000000000000000000000000;
  wire [15:0] n4767;
  wire n4774;
  wire [1:0] n4781;
  wire [2:0] n4783;
  wire [31:0] n4784;
  wire [1:0] n4792;
  wire n4794;
  wire [1:0] n4800;
  wire n4802;
  wire [4:0] n4803;
  wire [31:0] n4804;
  wire n4806;
  wire [29:0] n4807;
  wire [31:0] n4809;
  wire [27:0] n4810;
  wire [31:0] n4812;
  wire [31:0] n4813;
  wire [31:0] n4815;
  wire [2:0] n4816;
  wire [3:0] n4819;
  wire [2:0] n4820;
  wire [31:0] n4821;
  wire [31:0] n4822;
  wire n4824;
  wire n4826;
  wire [3:0] n4828;
  wire [2:0] n4829;
  wire [31:0] n4830;
  wire [31:0] n4831;
  wire n4832;
  wire n4833;
  wire [3:0] n4835;
  wire [2:0] n4836;
  wire n4839;
  wire [31:0] n4840;
  wire [31:0] n4841;
  wire n4842;
  wire n4843;
  wire n4845;
  wire [31:0] n4846;
  wire [3:0] n4848;
  wire [2:0] n4849;
  wire n4851;
  wire [31:0] n4852;
  wire [31:0] n4855;
  wire n4856;
  wire n4857;
  wire n4859;
  wire n4860;
  wire n4861;
  wire [3:0] n4862;
  wire [2:0] n4863;
  wire [31:0] n4864;
  wire [31:0] n4865;
  wire n4866;
  wire [31:0] n4867;
  wire [31:0] n4869;
  wire n4870;
  wire n4871;
  wire n4873;
  wire n4875;
  wire [31:0] n4876;
  wire [3:0] n4878;
  wire [2:0] n4879;
  wire [31:0] n4880;
  wire [31:0] n4881;
  wire n4882;
  wire [31:0] n4883;
  wire [31:0] n4886;
  wire n4887;
  wire n4888;
  wire n4889;
  wire n4890;
  wire n4891;
  wire n4892;
  wire [31:0] n4893;
  wire [3:0] n4894;
  wire [2:0] n4895;
  wire [31:0] n4896;
  wire [31:0] n4897;
  wire n4898;
  wire [31:0] n4899;
  wire [31:0] n4901;
  wire n4902;
  wire n4903;
  wire n4905;
  wire n4906;
  wire [31:0] n4908;
  localparam [31:0] n4917 = 32'b00000000000000000000000000000000;
  wire [15:0] n4918;
  wire n4925;
  wire [1:0] n4932;
  wire [2:0] n4934;
  wire [31:0] n4935;
  wire [1:0] n4941;
  wire n4943;
  wire [4:0] n4944;
  wire [31:0] n4945;
  wire n4947;
  wire [29:0] n4948;
  wire [31:0] n4950;
  wire [27:0] n4956;
  wire [31:0] n4958;
  wire [31:0] n4959;
  wire [31:0] n4961;
  wire [2:0] n4962;
  wire n4963;
  wire [14:0] n4964;
  wire n4965;
  wire n4966;
  wire [3:0] n4969;
  wire [2:0] n4970;
  wire [31:0] n4971;
  wire n4972;
  wire [31:0] n4973;
  wire n4975;
  wire n4977;
  wire n4978;
  wire [14:0] n4979;
  wire [3:0] n4981;
  wire [2:0] n4982;
  wire [31:0] n4983;
  wire n4984;
  wire [31:0] n4985;
  wire n4986;
  wire n4987;
  wire n4988;
  wire [14:0] n4989;
  wire n4991;
  wire [3:0] n4992;
  wire [2:0] n4993;
  wire [31:0] n4994;
  wire [31:0] n4995;
  wire n4996;
  wire [31:0] n4997;
  wire n4998;
  wire n4999;
  wire n5000;
  wire [14:0] n5001;
  wire n5003;
  wire n5005;
  wire [31:0] n5006;
  wire [3:0] n5008;
  wire [2:0] n5009;
  wire [31:0] n5010;
  wire [31:0] n5011;
  wire n5014;
  wire [31:0] n5015;
  wire n5016;
  wire n5017;
  wire n5018;
  wire [14:0] n5019;
  wire n5021;
  wire [31:0] n5022;
  wire n5023;
  wire [31:0] n5024;
  wire [3:0] n5025;
  wire [2:0] n5026;
  wire [31:0] n5027;
  wire [31:0] n5028;
  wire n5030;
  wire [31:0] n5031;
  wire n5032;
  wire n5033;
  wire n5034;
  wire [14:0] n5035;
  wire n5037;
  wire [28:0] n5045;
  wire [31:0] n5046;
  wire [31:0] n5047;
  wire [31:0] n5049;
  wire [31:0] n5051;
  wire n5062;
  wire n5064;
  wire n5065;
  wire n5069;
  wire [31:0] n5075;
  wire [1:0] n5076;
  wire [1:0] n5078;
  wire [31:0] n5081;
  wire [31:0] n5083;
  wire n5086;
  wire n5089;
  wire [31:0] n5092;
  wire n5093;
  wire n5095;
  wire n5096;
  wire n5098;
  wire [31:0] n5100;
  wire n5103;
  wire [4:0] n5104;
  wire [31:0] n5105;
  wire [31:0] n5106;
  wire [31:0] n5107;
  wire n5108;
  wire n5109;
  wire n5111;
  wire [4:0] n5112;
  wire [31:0] n5113;
  wire [31:0] n5114;
  wire [31:0] n5115;
  wire n5116;
  wire n5117;
  wire n5119;
  wire [4:0] n5120;
  wire [31:0] n5121;
  wire [31:0] n5122;
  wire [31:0] n5123;
  wire n5124;
  wire n5125;
  wire [31:0] n5127;
  wire n5130;
  wire n5132;
  wire n5133;
  wire n5136;
  wire [31:0] n5139;
  wire n5140;
  wire n5142;
  wire n5143;
  wire n5145;
  wire [31:0] n5147;
  wire [30:0] n5149;
  wire [31:0] n5150;
  wire [31:0] n5151;
  wire [31:0] n5153;
  wire [31:0] n5155;
  wire [30:0] n5156;
  wire [31:0] n5157;
  wire [31:0] n5158;
  wire [30:0] n5159;
  wire [31:0] n5160;
  wire [31:0] n5162;
  wire [31:0] n5168;
  wire [27:0] n5169;
  wire [31:0] n5171;
  wire [31:0] n5173;
  wire [30:0] n5174;
  wire [31:0] n5175;
  wire [31:0] n5176;
  wire n5177;
  wire [30:0] n5178;
  wire [14:0] n5179;
  wire n5180;
  localparam [31:0] n5189 = 32'b00000000000000000000000000000000;
  wire [15:0] n5190;
  wire n5197;
  wire [1:0] n5204;
  wire [2:0] n5206;
  wire [31:0] n5207;
  wire n5209;
  wire [31:0] n5210;
  wire [3:0] n5212;
  wire [30:0] n5213;
  wire [14:0] n5214;
  wire n5215;
  localparam [31:0] n5224 = 32'b00000000000000000000000000000000;
  wire [15:0] n5225;
  wire n5232;
  wire [1:0] n5239;
  wire [2:0] n5241;
  wire [31:0] n5242;
  wire n5244;
  wire [31:0] n5245;
  wire [3:0] n5247;
  wire n5248;
  wire [31:0] n5249;
  wire [3:0] n5250;
  wire n5251;
  wire [31:0] n5252;
  wire [3:0] n5253;
  wire n5255;
  wire n5264;
  wire [31:0] n5265;
  wire [31:0] n5266;
  localparam [31:0] n5275 = 32'b00000000000000000000000000000000;
  wire [15:0] n5276;
  wire n5283;
  wire [1:0] n5290;
  wire [2:0] n5292;
  wire [31:0] n5293;
  wire [1:0] n5299;
  wire n5301;
  localparam [31:0] n5310 = 32'b00000000000000000000000000000000;
  wire [15:0] n5311;
  wire n5318;
  wire [1:0] n5325;
  wire [2:0] n5327;
  wire [31:0] n5328;
  wire [1:0] n5336;
  wire n5338;
  wire [1:0] n5344;
  wire n5346;
  wire [4:0] n5347;
  wire [31:0] n5348;
  wire n5350;
  wire [29:0] n5351;
  wire [31:0] n5353;
  wire [27:0] n5354;
  wire [31:0] n5356;
  wire [31:0] n5357;
  wire [31:0] n5359;
  wire [2:0] n5360;
  wire [3:0] n5363;
  wire [2:0] n5364;
  wire [31:0] n5365;
  wire [31:0] n5366;
  wire n5368;
  wire n5370;
  wire [3:0] n5372;
  wire [2:0] n5373;
  wire [31:0] n5374;
  wire [31:0] n5375;
  wire n5376;
  wire n5377;
  wire [3:0] n5379;
  wire [2:0] n5380;
  wire n5383;
  wire [31:0] n5384;
  wire [31:0] n5385;
  wire n5386;
  wire n5387;
  wire n5389;
  wire [31:0] n5390;
  wire [3:0] n5392;
  wire [2:0] n5393;
  wire n5395;
  wire [31:0] n5396;
  wire [31:0] n5399;
  wire n5400;
  wire n5401;
  wire n5403;
  wire n5404;
  wire n5405;
  wire [3:0] n5406;
  wire [2:0] n5407;
  wire [31:0] n5408;
  wire [31:0] n5409;
  wire n5410;
  wire [31:0] n5411;
  wire [31:0] n5413;
  wire n5414;
  wire n5415;
  wire n5417;
  wire n5419;
  wire [31:0] n5420;
  wire [3:0] n5422;
  wire [2:0] n5423;
  wire [31:0] n5424;
  wire [31:0] n5425;
  wire n5426;
  wire [31:0] n5427;
  wire [31:0] n5430;
  wire n5431;
  wire n5432;
  wire n5433;
  wire n5434;
  wire n5435;
  wire n5436;
  wire [31:0] n5437;
  wire [3:0] n5438;
  wire [2:0] n5439;
  wire [31:0] n5440;
  wire [31:0] n5441;
  wire n5442;
  wire [31:0] n5443;
  wire [31:0] n5445;
  wire n5446;
  wire n5447;
  wire n5449;
  wire n5450;
  wire [31:0] n5452;
  localparam [31:0] n5461 = 32'b00000000000000000000000000000000;
  wire [15:0] n5462;
  wire n5469;
  wire [1:0] n5476;
  wire [2:0] n5478;
  wire [31:0] n5479;
  wire [1:0] n5485;
  wire n5487;
  wire [4:0] n5488;
  wire [31:0] n5489;
  wire n5491;
  wire [29:0] n5492;
  wire [31:0] n5494;
  wire [27:0] n5500;
  wire [31:0] n5502;
  wire [31:0] n5503;
  wire [31:0] n5505;
  wire [2:0] n5506;
  wire n5507;
  wire [14:0] n5508;
  wire n5509;
  wire n5510;
  wire [3:0] n5513;
  wire [2:0] n5514;
  wire [31:0] n5515;
  wire n5516;
  wire [31:0] n5517;
  wire n5519;
  wire n5521;
  wire n5522;
  wire [14:0] n5523;
  wire [3:0] n5525;
  wire [2:0] n5526;
  wire [31:0] n5527;
  wire n5528;
  wire [31:0] n5529;
  wire n5530;
  wire n5531;
  wire n5532;
  wire [14:0] n5533;
  wire n5535;
  wire [3:0] n5536;
  wire [2:0] n5537;
  wire [31:0] n5538;
  wire [31:0] n5539;
  wire n5540;
  wire [31:0] n5541;
  wire n5542;
  wire n5543;
  wire n5544;
  wire [14:0] n5545;
  wire n5547;
  wire n5549;
  wire [31:0] n5550;
  wire [3:0] n5552;
  wire [2:0] n5553;
  wire [31:0] n5554;
  wire [31:0] n5555;
  wire n5558;
  wire [31:0] n5559;
  wire n5560;
  wire n5561;
  wire n5562;
  wire [14:0] n5563;
  wire n5565;
  wire [31:0] n5566;
  wire n5567;
  wire [31:0] n5568;
  wire [3:0] n5569;
  wire [2:0] n5570;
  wire [31:0] n5571;
  wire [31:0] n5572;
  wire n5574;
  wire [31:0] n5575;
  wire n5576;
  wire n5577;
  wire n5578;
  wire [14:0] n5579;
  wire n5581;
  wire [28:0] n5589;
  wire [31:0] n5590;
  wire [31:0] n5591;
  wire [31:0] n5593;
  wire [31:0] n5595;
  wire n5606;
  wire n5608;
  wire n5609;
  wire n5613;
  wire [31:0] n5619;
  wire [1:0] n5620;
  wire [1:0] n5622;
  wire [31:0] n5625;
  wire [31:0] n5627;
  wire n5630;
  wire n5633;
  wire [31:0] n5636;
  wire n5637;
  wire n5639;
  wire n5640;
  wire n5642;
  wire [31:0] n5644;
  wire n5647;
  wire [4:0] n5648;
  wire [31:0] n5649;
  wire [31:0] n5650;
  wire [31:0] n5651;
  wire n5652;
  wire n5653;
  wire n5655;
  wire [4:0] n5656;
  wire [31:0] n5657;
  wire [31:0] n5658;
  wire [31:0] n5659;
  wire n5660;
  wire n5661;
  wire n5663;
  wire [4:0] n5664;
  wire [31:0] n5665;
  wire [31:0] n5666;
  wire [31:0] n5667;
  wire n5668;
  wire n5669;
  wire [31:0] n5671;
  wire n5674;
  wire n5676;
  wire n5677;
  wire n5680;
  wire [31:0] n5683;
  wire n5684;
  wire n5686;
  wire n5687;
  wire n5689;
  wire [31:0] n5691;
  wire [30:0] n5693;
  wire [31:0] n5694;
  wire [31:0] n5695;
  wire [31:0] n5697;
  wire [31:0] n5699;
  wire [30:0] n5700;
  wire [31:0] n5701;
  wire [31:0] n5702;
  wire [30:0] n5703;
  wire [31:0] n5704;
  wire [31:0] n5706;
  wire [31:0] n5712;
  wire [27:0] n5713;
  wire [31:0] n5715;
  wire [31:0] n5717;
  wire [30:0] n5718;
  wire [31:0] n5719;
  wire [31:0] n5720;
  wire n5721;
  wire [30:0] n5722;
  wire [14:0] n5723;
  wire n5724;
  localparam [31:0] n5733 = 32'b00000000000000000000000000000000;
  wire [15:0] n5734;
  wire n5741;
  wire [1:0] n5748;
  wire [2:0] n5750;
  wire [31:0] n5751;
  wire n5753;
  wire [31:0] n5754;
  wire [3:0] n5756;
  wire [30:0] n5757;
  wire [14:0] n5758;
  wire n5759;
  localparam [31:0] n5768 = 32'b00000000000000000000000000000000;
  wire [15:0] n5769;
  wire n5776;
  wire [1:0] n5783;
  wire [2:0] n5785;
  wire [31:0] n5786;
  wire n5788;
  wire [31:0] n5789;
  wire [3:0] n5791;
  wire n5792;
  wire [31:0] n5793;
  wire [3:0] n5794;
  wire n5795;
  wire [31:0] n5796;
  wire [3:0] n5797;
  wire n5799;
  wire n5801;
  wire [31:0] n5802;
  wire [31:0] n5803;
  localparam [31:0] n5812 = 32'b00000000000000000000000000000000;
  wire [15:0] n5813;
  wire n5820;
  wire [1:0] n5827;
  wire [2:0] n5829;
  wire [31:0] n5830;
  wire [1:0] n5831;
  wire n5833;
  localparam [31:0] n5842 = 32'b00000000000000000000000000000000;
  wire [15:0] n5843;
  wire n5850;
  wire [1:0] n5857;
  wire [2:0] n5859;
  wire [31:0] n5860;
  wire [1:0] n5866;
  wire n5868;
  wire [1:0] n5874;
  wire n5876;
  wire [29:0] n5877;
  wire [31:0] n5879;
  wire [3:0] n5882;
  wire [31:0] n5883;
  wire n5885;
  wire [3:0] n5887;
  wire n5890;
  wire [31:0] n5891;
  wire n5892;
  wire n5894;
  wire [31:0] n5895;
  wire [3:0] n5897;
  wire n5899;
  wire [31:0] n5902;
  wire n5903;
  wire n5905;
  wire n5906;
  wire n5907;
  wire [3:0] n5908;
  wire [31:0] n5909;
  wire [31:0] n5910;
  wire n5911;
  wire [31:0] n5913;
  wire n5914;
  wire n5916;
  wire n5918;
  wire [31:0] n5919;
  wire [3:0] n5921;
  wire [31:0] n5922;
  wire [31:0] n5923;
  wire n5924;
  wire [31:0] n5927;
  wire n5928;
  wire n5929;
  wire n5930;
  wire n5931;
  wire n5932;
  wire [31:0] n5933;
  wire [3:0] n5934;
  wire [31:0] n5935;
  wire [31:0] n5936;
  wire n5937;
  wire [31:0] n5939;
  wire n5940;
  wire n5942;
  wire n5943;
  wire [31:0] n5945;
  localparam [31:0] n5954 = 32'b00000000000000000000000000000000;
  wire [15:0] n5955;
  wire n5962;
  wire [1:0] n5969;
  wire [2:0] n5971;
  wire [31:0] n5972;
  wire [29:0] n5973;
  wire [31:0] n5975;
  wire n5977;
  wire [3:0] n5979;
  wire [31:0] n5980;
  wire [31:0] n5981;
  wire n5983;
  wire n5985;
  wire n5987;
  wire [31:0] n5988;
  wire [3:0] n5990;
  wire [31:0] n5991;
  wire [31:0] n5994;
  wire n5995;
  wire n5997;
  wire [31:0] n5998;
  wire n5999;
  wire [31:0] n6000;
  wire [3:0] n6001;
  wire [31:0] n6002;
  wire [31:0] n6004;
  wire n6005;
  wire n6007;
  wire n6008;
  localparam [31:0] n6017 = 32'b00000000000000000000000000000000;
  wire [15:0] n6018;
  wire n6025;
  wire [1:0] n6032;
  wire [2:0] n6034;
  wire [31:0] n6035;
  wire [1:0] n6036;
  wire n6038;
  wire n6039;
  wire [3:0] n6042;
  wire [31:0] n6043;
  wire n6046;
  wire [1:0] n6047;
  wire n6049;
  localparam [31:0] n6058 = 32'b00000000000000000000000000000000;
  wire [15:0] n6059;
  wire n6066;
  wire [1:0] n6073;
  wire [2:0] n6075;
  wire [31:0] n6076;
  localparam [31:0] n6085 = 32'b00000000000000000000000000000000;
  wire [15:0] n6086;
  wire n6093;
  wire [1:0] n6100;
  wire [2:0] n6102;
  wire [31:0] n6103;
  wire [31:0] n6104;
  wire n6106;
  wire [31:0] n6107;
  wire [3:0] n6109;
  wire n6110;
  wire [31:0] n6111;
  wire n6112;
  wire n6114;
  wire n6115;
  wire [31:0] n6116;
  wire [3:0] n6117;
  wire n6118;
  wire n6119;
  wire n6120;
  wire n6122;
  wire n6124;
  wire [31:0] n6125;
  wire [3:0] n6127;
  wire [31:0] n6128;
  wire [31:0] n6129;
  wire n6130;
  wire n6134;
  wire [31:0] n6135;
  wire [31:0] n6136;
  wire n6137;
  wire [31:0] n6138;
  wire [3:0] n6139;
  wire [31:0] n6140;
  wire [31:0] n6141;
  wire n6142;
  wire n6145;
  wire n6146;
  wire [31:0] n6148;
  localparam [31:0] n6157 = 32'b00000000000000000000000000000000;
  wire [15:0] n6158;
  wire n6165;
  wire [1:0] n6172;
  wire [2:0] n6174;
  wire [31:0] n6175;
  wire n6177;
  wire [3:0] n6179;
  wire [31:0] n6180;
  wire [31:0] n6181;
  wire n6183;
  wire n6185;
  wire [31:0] n6186;
  wire [3:0] n6188;
  wire [31:0] n6189;
  wire [31:0] n6190;
  wire n6194;
  wire [31:0] n6195;
  wire n6196;
  wire [31:0] n6197;
  wire [3:0] n6198;
  wire [31:0] n6199;
  wire [31:0] n6200;
  wire n6203;
  wire [1:0] n6209;
  wire n6211;
  wire n6212;
  localparam [31:0] n6221 = 32'b00000000000000000000000000000000;
  wire [15:0] n6222;
  wire n6229;
  wire [1:0] n6236;
  wire [2:0] n6238;
  wire [31:0] n6239;
  wire n6240;
  wire n6241;
  wire n6242;
  wire n6244;
  localparam [31:0] n6252 = 32'b00000000000000000000000000000000;
  wire [15:0] n6253;
  wire n6259;
  wire [1:0] n6266;
  wire [2:0] n6268;
  wire [31:0] n6269;
  wire n6270;
  wire n6271;
  wire n6272;
  localparam [31:0] n6281 = 32'b00000000000000000000000000000000;
  wire [15:0] n6282;
  wire n6289;
  wire [1:0] n6296;
  wire [2:0] n6298;
  wire [31:0] n6299;
  wire [4:0] n6300;
  wire [31:0] n6302;
  wire n6309;
  wire n6311;
  wire n6312;
  wire n6315;
  wire [31:0] n6321;
  wire [30:0] n6322;
  wire [31:0] n6324;
  wire [31:0] n6326;
  wire [31:0] n6328;
  wire [31:0] n6329;
  wire [31:0] n6334;
  wire [23:0] n6335;
  wire [31:0] n6337;
  wire [23:0] n6338;
  wire [31:0] n6340;
  wire [31:0] n6341;
  wire n6342;
  wire n6343;
  wire n6344;
  wire n6345;
  wire n6346;
  wire n6348;
  wire n6349;
  wire n6350;
  wire n6351;
  wire n6352;
  wire n6353;
  wire n6354;
  wire n6355;
  wire [26:0] n6356;
  wire n6357;
  wire n6358;
  wire n6359;
  wire [27:0] n6360;
  wire [28:0] n6362;
  wire [2:0] n6363;
  wire [31:0] n6364;
  wire [3:0] n6367;
  wire [31:0] n6370;
  wire n6372;
  wire [31:0] n6373;
  wire [3:0] n6375;
  wire [31:0] n6376;
  wire [31:0] n6377;
  wire [4:0] n6378;
  wire [3:0] n6382;
  wire [3:0] n6383;
  wire [3:0] n6384;
  wire n6385;
  wire [31:0] n6387;
  wire n6389;
  wire [31:0] n6390;
  wire [3:0] n6392;
  wire [31:0] n6393;
  wire [31:0] n6394;
  wire [4:0] n6395;
  wire [3:0] n6398;
  wire [3:0] n6399;
  wire n6400;
  wire [31:0] n6402;
  wire n6404;
  wire [31:0] n6405;
  wire [3:0] n6407;
  wire [31:0] n6408;
  wire [31:0] n6409;
  wire [4:0] n6410;
  wire [3:0] n6413;
  wire [3:0] n6414;
  wire n6415;
  wire [31:0] n6417;
  wire n6419;
  wire n6420;
  localparam [31:0] n6429 = 32'b00000000000000000000000000000000;
  wire [15:0] n6430;
  wire n6437;
  wire [1:0] n6444;
  wire [2:0] n6446;
  wire [31:0] n6447;
  wire n6448;
  wire n6450;
  wire n6452;
  wire [3:0] n6454;
  wire n6455;
  wire n6456;
  wire n6460;
  wire n6462;
  wire n6464;
  wire [31:0] n6465;
  wire [3:0] n6467;
  wire n6470;
  wire n6471;
  wire n6474;
  wire n6476;
  wire [31:0] n6477;
  wire [31:0] n6478;
  wire n6479;
  wire [31:0] n6480;
  wire [3:0] n6481;
  wire n6483;
  wire n6484;
  wire n6487;
  wire [2:0] n6489;
  wire [2:0] n6493;
  wire [2:0] n6497;
  wire [2:0] n6505;
  wire [3:0] n6507;
  wire [2:0] n6510;
  wire [2:0] n6514;
  wire [2:0] n6518;
  wire [2:0] n6522;
  wire [31:0] n6528;
  wire n6530;
  wire [31:0] n6531;
  wire [31:0] n6533;
  wire [2:0] n6534;
  wire [2:0] n6536;
  wire n6538;
  wire n6540;
  wire n6542;
  wire [15:0] n6543;
  reg n6544;
  reg n6545;
  reg [31:0] n6546;
  reg [31:0] n6547;
  reg [31:0] n6548;
  reg n6549;
  reg [31:0] n6550;
  reg [255:0] n6551;
  reg [255:0] n6552;
  reg [31:0] n6553;
  reg [7:0] n6554;
  reg [23:0] n6555;
  reg [7:0] n6556;
  reg [39:0] n6557;
  reg [7:0] n6559;
  reg [2:0] n6560;
  reg n6563;
  reg [3:0] n6568;
  reg [31:0] n6569;
  reg [31:0] n6570;
  reg [4:0] n6571;
  reg [2:0] n6573;
  reg [31:0] n6574;
  reg [31:0] n6575;
  reg [31:0] n6576;
  reg n6577;
  reg [31:0] n6578;
  reg [31:0] n6579;
  wire n6581;
  wire n6582;
  wire n6583;
  reg n6584;
  wire n6585;
  wire n6586;
  wire n6587;
  reg n6588;
  wire [1:0] n6589;
  wire [1:0] n6590;
  wire [1:0] n6591;
  reg [1:0] n6592;
  wire [3:0] n6593;
  wire [3:0] n6594;
  reg [3:0] n6595;
  reg n6596;
  reg n6597;
  reg [31:0] n6598;
  reg n6599;
  reg n6600;
  reg n6601;
  reg [14:0] n6602;
  reg [31:0] n6604;
  wire [7:0] n6618;
  wire [7:0] n6619;
  wire n6621;
  wire n6622;
  wire [2:0] n6623;
  wire n6625;
  wire n6626;
  wire n6627;
  wire n6628;
  wire [2:0] n6637;
  wire n6639;
  wire n6640;
  wire n6641;
  wire n6642;
  wire n6643;
  wire n6645;
  wire n6646;
  wire n6647;
  wire n6648;
  wire n6650;
  wire n6651;
  wire n6652;
  wire n6653;
  wire n6655;
  wire n6656;
  wire n6657;
  wire n6658;
  wire n6660;
  wire n6661;
  wire n6662;
  wire n6663;
  wire n6665;
  wire n6666;
  wire n6667;
  wire n6668;
  wire n6670;
  wire n6671;
  wire n6672;
  wire n6673;
  wire n6675;
  wire n6676;
  wire n6677;
  wire n6678;
  wire n6680;
  wire n6681;
  wire n6682;
  wire [2:0] n6683;
  wire n6684;
  wire [4:0] n6686;
  wire [31:0] n6687;
  wire n6694;
  wire n6696;
  wire n6697;
  wire n6700;
  wire [31:0] n6706;
  wire [30:0] n6707;
  wire [31:0] n6709;
  wire [31:0] n6711;
  wire [31:0] n6713;
  wire [31:0] n6714;
  wire [31:0] n6719;
  wire [31:0] n6720;
  wire n6721;
  wire n6722;
  wire n6723;
  wire n6724;
  wire n6725;
  wire n6726;
  wire n6727;
  wire n6729;
  wire n6730;
  wire n6732;
  wire n6734;
  wire n6735;
  wire [2:0] n6736;
  wire n6737;
  wire [4:0] n6739;
  wire [31:0] n6740;
  wire n6747;
  wire n6749;
  wire n6750;
  wire n6753;
  wire [31:0] n6759;
  wire [30:0] n6760;
  wire [31:0] n6762;
  wire [31:0] n6764;
  wire [31:0] n6766;
  wire [31:0] n6767;
  wire [31:0] n6772;
  wire [31:0] n6773;
  wire n6774;
  wire n6775;
  wire n6776;
  wire n6777;
  wire n6778;
  wire n6779;
  wire n6780;
  wire n6782;
  wire n6783;
  wire n6785;
  wire n6787;
  wire n6788;
  wire [2:0] n6789;
  wire n6790;
  wire [4:0] n6792;
  wire [31:0] n6793;
  wire n6800;
  wire n6802;
  wire n6803;
  wire n6806;
  wire [31:0] n6812;
  wire [30:0] n6813;
  wire [31:0] n6815;
  wire [31:0] n6817;
  wire [31:0] n6819;
  wire [31:0] n6820;
  wire [31:0] n6825;
  wire [31:0] n6826;
  wire n6827;
  wire n6828;
  wire n6829;
  wire n6830;
  wire n6831;
  wire n6832;
  wire n6833;
  wire n6835;
  wire n6836;
  wire n6838;
  wire n6840;
  wire n6841;
  wire [2:0] n6842;
  wire n6843;
  wire [4:0] n6845;
  wire [31:0] n6846;
  wire n6853;
  wire n6855;
  wire n6856;
  wire n6859;
  wire [31:0] n6865;
  wire [30:0] n6866;
  wire [31:0] n6868;
  wire [31:0] n6870;
  wire [31:0] n6872;
  wire [31:0] n6873;
  wire [31:0] n6878;
  wire [31:0] n6879;
  wire n6880;
  wire n6881;
  wire n6882;
  wire n6883;
  wire n6884;
  wire n6885;
  wire n6886;
  wire n6888;
  wire n6889;
  wire n6891;
  wire n6893;
  wire n6894;
  wire [2:0] n6895;
  wire n6896;
  wire [4:0] n6898;
  wire [31:0] n6899;
  wire n6906;
  wire n6908;
  wire n6909;
  wire n6912;
  wire [31:0] n6918;
  wire [30:0] n6919;
  wire [31:0] n6921;
  wire [31:0] n6923;
  wire [31:0] n6925;
  wire [31:0] n6926;
  wire [31:0] n6931;
  wire [31:0] n6932;
  wire n6933;
  wire n6934;
  wire n6935;
  wire n6936;
  wire n6937;
  wire n6938;
  wire n6939;
  wire n6941;
  wire n6942;
  wire n6944;
  wire n6946;
  wire n6947;
  wire [2:0] n6948;
  wire n6949;
  wire [4:0] n6951;
  wire [31:0] n6952;
  wire n6959;
  wire n6961;
  wire n6962;
  wire n6965;
  wire [31:0] n6971;
  wire [30:0] n6972;
  wire [31:0] n6974;
  wire [31:0] n6976;
  wire [31:0] n6978;
  wire [31:0] n6979;
  wire [31:0] n6984;
  wire [31:0] n6985;
  wire n6986;
  wire n6987;
  wire n6988;
  wire n6989;
  wire n6990;
  wire n6991;
  wire n6992;
  wire n6994;
  wire n6995;
  wire n6997;
  wire n6999;
  wire n7000;
  wire [2:0] n7001;
  wire n7002;
  wire [4:0] n7004;
  wire [31:0] n7005;
  wire n7012;
  wire n7014;
  wire n7015;
  wire n7018;
  wire [31:0] n7024;
  wire [30:0] n7025;
  wire [31:0] n7027;
  wire [31:0] n7029;
  wire [31:0] n7031;
  wire [31:0] n7032;
  wire [31:0] n7037;
  wire [31:0] n7038;
  wire n7039;
  wire n7040;
  wire n7041;
  wire n7042;
  wire n7043;
  wire n7044;
  wire n7045;
  wire n7047;
  wire n7048;
  wire n7050;
  wire n7052;
  wire n7053;
  wire [2:0] n7054;
  wire n7055;
  wire [4:0] n7057;
  wire [31:0] n7058;
  wire n7065;
  wire n7067;
  wire n7068;
  wire n7071;
  wire [31:0] n7077;
  wire [30:0] n7078;
  wire [31:0] n7080;
  wire [31:0] n7082;
  wire [31:0] n7084;
  wire [31:0] n7085;
  wire [31:0] n7090;
  wire [31:0] n7091;
  wire n7092;
  wire n7093;
  wire n7094;
  wire n7095;
  wire n7096;
  wire n7097;
  wire n7098;
  wire n7100;
  wire n7101;
  wire n7103;
  wire n7105;
  wire [7:0] n7106;
  wire [7:0] n7107;
  wire [7:0] n7108;
  wire [7:0] n7109;
  wire [7:0] n7110;
  wire [7:0] n7111;
  wire n7112;
  wire n7114;
  wire n7115;
  wire n7117;
  wire [7:0] n7149;
  wire [255:0] n7178;
  wire [255:0] n7180;
  wire [31:0] n7182;
  wire [7:0] n7184;
  wire [23:0] n7186;
  wire [7:0] n7188;
  wire [39:0] n7190;
  wire n7263;
  wire n7284;
  wire [7:0] n7286;
  wire [7:0] n7288;
  wire [2:0] n7290;
  wire [2:0] n7292;
  wire [7:0] n7294;
  wire n7296;
  wire n7299;
  wire n7306;
  wire [7:0] n7311;
  wire [7:0] n7312;
  wire [7:0] n7313;
  wire n7315;
  wire n7318;
  wire n7321;
  wire n7322;
  wire n7324;
  wire [2:0] n7326;
  wire [2:0] n7327;
  wire [2:0] n7328;
  wire n7330;
  wire n7333;
  wire n7336;
  wire n7337;
  wire n7339;
  wire n7341;
  wire n7342;
  wire n7344;
  wire n7352;
  wire n7353;
  wire n7355;
  wire n7356;
  wire n7358;
  wire n7360;
  wire n7365;
  wire n7367;
  wire n7371;
  wire n7373;
  wire n7376;
  wire n7381;
  wire n7384;
  wire n7409;
  wire [7:0] n7411;
  wire [7:0] n7413;
  wire [2:0] n7415;
  wire [2:0] n7417;
  wire [7:0] n7419;
  wire n7421;
  wire n7424;
  wire n7431;
  wire [7:0] n7436;
  wire [7:0] n7437;
  wire [7:0] n7438;
  wire n7440;
  wire n7443;
  wire n7446;
  wire n7447;
  wire n7449;
  wire [2:0] n7451;
  wire [2:0] n7452;
  wire [2:0] n7453;
  wire n7455;
  wire n7458;
  wire n7461;
  wire n7462;
  wire n7464;
  wire n7466;
  wire n7467;
  wire n7469;
  wire n7477;
  wire n7478;
  wire n7480;
  wire n7481;
  wire n7483;
  wire n7485;
  wire n7490;
  wire n7492;
  wire n7496;
  wire n7498;
  wire n7501;
  wire n7506;
  wire n7509;
  wire n7514;
  wire n7515;
  wire n7517;
  wire n7518;
  wire n7519;
  wire n7520;
  wire n7521;
  wire n7522;
  wire n7523;
  wire n7526;
  wire n7528;
  wire n7534;
  wire n7536;
  wire n7537;
  wire n7540;
  wire n7541;
  wire n7542;
  wire [4:0] n7543;
  wire n7548;
  wire n7554;
  wire n7555;
  wire n7556;
  wire n7558;
  wire n7560;
  wire [31:0] n7602;
  reg [31:0] n7603;
  wire [31:0] n7604;
  reg [31:0] n7605;
  wire [31:0] n7606;
  reg [31:0] n7607;
  wire [31:0] n7608;
  reg [31:0] n7609;
  wire [31:0] n7610;
  reg [31:0] n7611;
  wire [31:0] n7612;
  reg [31:0] n7613;
  wire [31:0] n7614;
  reg [31:0] n7615;
  reg [31:0] n7616;
  wire n7617;
  wire [31:0] n7618;
  reg [31:0] n7619;
  reg [31:0] n7620;
  reg n7621;
  reg n7622;
  reg n7623;
  reg [31:0] n7624;
  reg n7625;
  reg [31:0] n7626;
  reg n7627;
  reg n7628;
  reg n7629;
  reg [31:0] n7630;
  reg [2:0] n7631;
  reg n7632;
  reg n7633;
  reg n7634;
  reg [255:0] n7635;
  reg [255:0] n7636;
  reg [31:0] n7637;
  reg [7:0] n7638;
  reg [23:0] n7639;
  reg [7:0] n7640;
  reg [39:0] n7641;
  wire n7643;
  wire [7:0] n7644;
  reg [7:0] n7645;
  reg [2:0] n7646;
  reg n7647;
  reg n7648;
  wire [19:0] n7649;
  reg n7650;
  reg n7651;
  reg [31:0] n7652;
  reg n7653;
  reg [3:0] n7654;
  reg [31:0] n7655;
  reg [31:0] n7656;
  reg [4:0] n7657;
  reg n7659;
  reg n7660;
  reg n7661;
  reg n7662;
  reg n7663;
  reg n7664;
  wire n7667;
  reg n7668;
  wire [31:0] n7669;
  reg [31:0] n7670;
  wire [2:0] n7671;
  reg [2:0] n7672;
  wire n7673;
  wire n7674;
  wire n7675;
  reg n7676;
  wire n7677;
  wire n7678;
  reg n7679;
  wire n7680;
  wire n7681;
  wire [31:0] n7682;
  reg [31:0] n7683;
  wire n7684;
  wire n7685;
  wire [2:0] n7686;
  reg [2:0] n7687;
  wire n7688;
  wire n7689;
  wire n7690;
  reg n7691;
  wire n7695;
  wire n7696;
  wire [31:0] n7697;
  reg [31:0] n7698;
  wire n7699;
  wire n7700;
  wire [2:0] n7701;
  reg [2:0] n7702;
  wire n7703;
  wire n7704;
  wire [4:0] n7705;
  reg [4:0] n7706;
  reg [2:0] n7707;
  reg [31:0] n7708;
  wire n7709;
  wire [31:0] n7710;
  reg [31:0] n7711;
  wire n7712;
  wire [31:0] n7713;
  reg [31:0] n7714;
  wire n7715;
  wire n7716;
  reg n7717;
  reg [31:0] n7718;
  reg [31:0] n7719;
  reg [7:0] n7721;
  wire n7722;
  wire n7723;
  reg n7724;
  wire n7725;
  wire n7726;
  reg n7727;
  wire n7728;
  wire [31:0] n7729;
  reg [31:0] n7730;
  wire n7731;
  wire n7732;
  reg n7733;
  reg n7734;
  reg n7735;
  reg [14:0] n7736;
  reg [31:0] n7738;
  reg n7739;
  reg n7740;
  reg [31:0] n7741;
  reg [31:0] n7742;
  wire [3:0] n7743;
  wire n7744;
  wire [31:0] n7745;
  wire [31:0] n7746;
  wire [29:0] n7747;
  wire [31:0] n7749;
  wire [3:0] n7750;
  wire n7751;
  wire [28:0] n7752;
  wire [31:0] n7754;
  wire [3:0] n7755;
  wire n7756;
  wire [3:0] n7757;
  wire n7758;
  wire [31:0] n7759;
  wire [31:0] n7760;
  wire [29:0] n7761;
  wire [31:0] n7763;
  wire [3:0] n7764;
  wire n7765;
  wire [3:0] n7766;
  wire n7767;
  wire [31:0] n7768;
  wire [31:0] n7769;
  wire [29:0] n7770;
  wire [31:0] n7772;
  wire [3:0] n7773;
  wire n7774;
  wire [3:0] n7775;
  wire n7776;
  wire [3:0] n7777;
  wire n7778;
  wire [30:0] n7779;
  wire [31:0] n7781;
  wire [3:0] n7782;
  wire n7783;
  wire [3:0] n7784;
  wire n7785;
  wire [31:0] n7786;
  wire [31:0] n7787;
  wire [29:0] n7788;
  wire [31:0] n7790;
  wire [3:0] n7791;
  wire n7792;
  wire [28:0] n7793;
  wire [31:0] n7795;
  wire [3:0] n7796;
  wire n7797;
  wire [3:0] n7798;
  wire n7799;
  wire [31:0] n7800;
  wire [31:0] n7801;
  wire [29:0] n7802;
  wire [31:0] n7804;
  wire [3:0] n7805;
  wire n7806;
  wire [3:0] n7807;
  wire n7808;
  wire [31:0] n7809;
  wire [31:0] n7810;
  wire [29:0] n7811;
  wire [31:0] n7813;
  wire [3:0] n7814;
  wire n7815;
  wire [3:0] n7816;
  wire n7817;
  wire [3:0] n7818;
  wire n7819;
  wire [30:0] n7820;
  wire [31:0] n7822;
  wire [3:0] n7823;
  wire n7824;
  wire [4:0] n7825;
  wire [4:0] n7826;
  wire [4:0] n7827;
  wire [4:0] n7828;
  wire n7829;
  wire n7830;
  wire n7831;
  wire n7832;
  wire n7833;
  wire n7834;
  wire n7835;
  wire n7836;
  wire n7837;
  wire n7838;
  wire n7839;
  wire n7840;
  wire n7841;
  wire n7842;
  wire n7843;
  wire n7844;
  wire n7845;
  wire n7846;
  wire [31:0] n7847;
  wire [31:0] n7848;
  wire [31:0] n7849;
  wire [31:0] n7850;
  wire [31:0] n7851;
  wire [31:0] n7852;
  wire [31:0] n7853;
  wire [31:0] n7854;
  wire [31:0] n7855;
  wire [31:0] n7856;
  wire [31:0] n7857;
  wire [31:0] n7858;
  wire [31:0] n7859;
  wire [31:0] n7860;
  wire [31:0] n7861;
  wire [31:0] n7862;
  wire [255:0] n7863;
  wire n7864;
  wire n7865;
  wire n7866;
  wire n7867;
  wire n7868;
  wire n7869;
  wire n7870;
  wire n7871;
  wire n7872;
  wire n7873;
  wire n7874;
  wire n7875;
  wire n7876;
  wire n7877;
  wire n7878;
  wire n7879;
  wire n7880;
  wire n7881;
  wire [31:0] n7882;
  wire [31:0] n7883;
  wire [31:0] n7884;
  wire [31:0] n7885;
  wire [31:0] n7886;
  wire [31:0] n7887;
  wire [31:0] n7888;
  wire [31:0] n7889;
  wire [31:0] n7890;
  wire [31:0] n7891;
  wire [31:0] n7892;
  wire [31:0] n7893;
  wire [31:0] n7894;
  wire [31:0] n7895;
  wire [31:0] n7896;
  wire [31:0] n7897;
  wire [255:0] n7898;
  wire n7899;
  wire n7900;
  wire n7901;
  wire n7902;
  wire n7903;
  wire n7904;
  wire n7905;
  wire n7906;
  wire n7907;
  wire n7908;
  wire n7909;
  wire n7910;
  wire n7911;
  wire n7912;
  wire n7913;
  wire n7914;
  wire n7915;
  wire n7916;
  wire [4:0] n7917;
  wire [4:0] n7918;
  wire [4:0] n7919;
  wire [4:0] n7920;
  wire [4:0] n7921;
  wire [4:0] n7922;
  wire [4:0] n7923;
  wire [4:0] n7924;
  wire [4:0] n7925;
  wire [4:0] n7926;
  wire [4:0] n7927;
  wire [4:0] n7928;
  wire [4:0] n7929;
  wire [4:0] n7930;
  wire [4:0] n7931;
  wire [4:0] n7932;
  wire [39:0] n7933;
  wire n7934;
  wire n7935;
  wire n7936;
  wire n7937;
  wire n7938;
  wire n7939;
  wire n7940;
  wire n7941;
  wire n7942;
  wire n7943;
  wire n7944;
  wire n7945;
  wire n7946;
  wire n7947;
  wire n7948;
  wire n7949;
  wire n7950;
  wire n7951;
  wire [3:0] n7952;
  wire [3:0] n7953;
  wire [3:0] n7954;
  wire [3:0] n7955;
  wire [3:0] n7956;
  wire [3:0] n7957;
  wire [3:0] n7958;
  wire [3:0] n7959;
  wire [3:0] n7960;
  wire [3:0] n7961;
  wire [3:0] n7962;
  wire [3:0] n7963;
  wire [3:0] n7964;
  wire [3:0] n7965;
  wire [3:0] n7966;
  wire [3:0] n7967;
  wire [31:0] n7968;
  wire n7969;
  wire n7970;
  wire n7971;
  wire n7972;
  wire n7973;
  wire n7974;
  wire n7975;
  wire n7976;
  wire n7977;
  wire n7978;
  wire n7979;
  wire n7980;
  wire n7981;
  wire n7982;
  wire n7983;
  wire n7984;
  wire n7985;
  wire n7986;
  wire [2:0] n7987;
  wire [2:0] n7988;
  wire [2:0] n7989;
  wire [2:0] n7990;
  wire [2:0] n7991;
  wire [2:0] n7992;
  wire [2:0] n7993;
  wire [2:0] n7994;
  wire [2:0] n7995;
  wire [2:0] n7996;
  wire [2:0] n7997;
  wire [2:0] n7998;
  wire [2:0] n7999;
  wire [2:0] n8000;
  wire [2:0] n8001;
  wire [2:0] n8002;
  wire [23:0] n8003;
  wire n8004;
  wire n8005;
  wire n8006;
  wire n8007;
  wire n8008;
  wire n8009;
  wire n8010;
  wire n8011;
  wire n8012;
  wire n8013;
  wire n8014;
  wire n8015;
  wire n8016;
  wire n8017;
  wire n8018;
  wire n8019;
  wire n8020;
  wire n8021;
  wire n8022;
  wire n8023;
  wire n8024;
  wire n8025;
  wire n8026;
  wire n8027;
  wire n8028;
  wire n8029;
  wire n8030;
  wire n8031;
  wire n8032;
  wire n8033;
  wire n8034;
  wire n8035;
  wire n8036;
  wire n8037;
  wire [7:0] n8038;
  wire n8039;
  wire n8040;
  wire n8041;
  wire n8042;
  wire n8043;
  wire n8044;
  wire n8045;
  wire n8046;
  wire n8047;
  wire n8048;
  wire n8049;
  wire n8050;
  wire n8051;
  wire n8052;
  wire n8053;
  wire n8054;
  wire n8055;
  wire n8056;
  wire n8057;
  wire n8058;
  wire n8059;
  wire n8060;
  wire n8061;
  wire n8062;
  wire n8063;
  wire n8064;
  wire n8065;
  wire n8066;
  wire n8067;
  wire n8068;
  wire n8069;
  wire n8070;
  wire n8071;
  wire n8072;
  wire [7:0] n8073;
  wire n8074;
  wire n8075;
  wire n8076;
  wire n8077;
  wire n8078;
  wire n8079;
  wire n8080;
  wire n8081;
  wire n8082;
  wire n8083;
  wire n8084;
  wire n8085;
  wire n8086;
  wire n8087;
  wire n8088;
  wire n8089;
  wire n8090;
  wire n8091;
  wire n8092;
  wire n8093;
  wire n8094;
  wire n8095;
  wire n8096;
  wire n8097;
  wire n8098;
  wire n8099;
  wire n8100;
  wire n8101;
  wire n8102;
  wire n8103;
  wire n8104;
  wire n8105;
  wire n8106;
  wire n8107;
  wire [7:0] n8108;
  assign reg_rdat = n427; //(module output)
  assign addr_phys = n607; //(module output)
  assign cache_inhibit = n610; //(module output)
  assign write_protect = write_protect_reg; //(module output)
  assign fault = fault_reg; //(module output)
  assign fault_status = fault_status_reg; //(module output)
  assign tc_enable = tc_en; //(module output)
  assign mem_req = n7739; //(module output)
  assign mem_we = n7740; //(module output)
  assign mem_addr = n7741; //(module output)
  assign mem_wdat = n7742; //(module output)
  assign busy = n7528; //(module output)
  assign mmu_config_err = mmu_config_error; //(module output)
  /* TG68K_PMMU_030.vhd:70:10  */
  assign tc = n7603; // (signal)
  /* TG68K_PMMU_030.vhd:71:10  */
  assign crp_h = n7605; // (signal)
  /* TG68K_PMMU_030.vhd:72:10  */
  assign crp_l = n7607; // (signal)
  /* TG68K_PMMU_030.vhd:73:10  */
  assign srp_h = n7609; // (signal)
  /* TG68K_PMMU_030.vhd:74:10  */
  assign srp_l = n7611; // (signal)
  /* TG68K_PMMU_030.vhd:75:10  */
  assign tt0 = n7613; // (signal)
  /* TG68K_PMMU_030.vhd:76:10  */
  assign tt1 = n7615; // (signal)
  /* TG68K_PMMU_030.vhd:77:10  */
  assign mmusr = n7616; // (signal)
  /* TG68K_PMMU_030.vhd:82:10  */
  assign tc_en = n459; // (signal)
  /* TG68K_PMMU_030.vhd:85:10  */
  always @*
    desc_addr_reg = n7619; // (isignal)
  initial
    desc_addr_reg = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:106:10  */
  always @*
    addr_phys_reg = n7620; // (isignal)
  initial
    addr_phys_reg = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:107:10  */
  always @*
    cache_inhibit_reg = n7621; // (isignal)
  initial
    cache_inhibit_reg = 1'b0;
  /* TG68K_PMMU_030.vhd:108:10  */
  always @*
    write_protect_reg = n7622; // (isignal)
  initial
    write_protect_reg = 1'b0;
  /* TG68K_PMMU_030.vhd:109:10  */
  always @*
    fault_reg = n7623; // (isignal)
  initial
    fault_reg = 1'b0;
  /* TG68K_PMMU_030.vhd:110:10  */
  always @*
    fault_status_reg = n7624; // (isignal)
  initial
    fault_status_reg = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:113:10  */
  always @*
    walker_fault = n7625; // (isignal)
  initial
    walker_fault = 1'b0;
  /* TG68K_PMMU_030.vhd:114:10  */
  always @*
    walker_fault_status = n7626; // (isignal)
  initial
    walker_fault_status = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:115:10  */
  always @*
    walker_fault_ack = n7627; // (isignal)
  initial
    walker_fault_ack = 1'b0;
  /* TG68K_PMMU_030.vhd:116:10  */
  always @*
    walker_fault_ack_pending = n7628; // (isignal)
  initial
    walker_fault_ack_pending = 1'b0;
  /* TG68K_PMMU_030.vhd:119:10  */
  always @*
    walker_completed_ack = n7629; // (isignal)
  initial
    walker_completed_ack = 1'b0;
  /* TG68K_PMMU_030.vhd:122:10  */
  always @*
    saved_addr_log = n7630; // (isignal)
  initial
    saved_addr_log = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:123:10  */
  always @*
    saved_fc = n7631; // (isignal)
  initial
    saved_fc = 3'b000;
  /* TG68K_PMMU_030.vhd:124:10  */
  always @*
    saved_is_insn = n7632; // (isignal)
  initial
    saved_is_insn = 1'b0;
  /* TG68K_PMMU_030.vhd:125:10  */
  always @*
    saved_rw = n7633; // (isignal)
  initial
    saved_rw = 1'b0;
  /* TG68K_PMMU_030.vhd:126:10  */
  always @*
    translation_pending = n7634; // (isignal)
  initial
    translation_pending = 1'b0;
  /* TG68K_PMMU_030.vhd:140:10  */
  assign atc_log_base = n7635; // (signal)
  /* TG68K_PMMU_030.vhd:141:10  */
  assign atc_phys_base = n7636; // (signal)
  /* TG68K_PMMU_030.vhd:142:10  */
  assign atc_attr = n7637; // (signal)
  /* TG68K_PMMU_030.vhd:143:10  */
  assign atc_valid = n7638; // (signal)
  /* TG68K_PMMU_030.vhd:144:10  */
  assign atc_fc = n7639; // (signal)
  /* TG68K_PMMU_030.vhd:145:10  */
  assign atc_is_insn = n7640; // (signal)
  /* TG68K_PMMU_030.vhd:146:10  */
  assign atc_shift = n7641; // (signal)
  /* TG68K_PMMU_030.vhd:148:10  */
  assign atc_global = n7645; // (signal)
  /* TG68K_PMMU_030.vhd:149:10  */
  always @*
    atc_rr = n7646; // (isignal)
  initial
    atc_rr = 3'b000;
  /* TG68K_PMMU_030.vhd:150:10  */
  assign walk_req = n7647; // (signal)
  /* TG68K_PMMU_030.vhd:151:10  */
  always @*
    walker_completed = n7648; // (isignal)
  initial
    walker_completed = 1'b0;
  /* TG68K_PMMU_030.vhd:157:10  */
  always @*
    tc_idx_bits = n7649; // (isignal)
  initial
    tc_idx_bits = 20'b01000010000010000000;
  /* TG68K_PMMU_030.vhd:159:10  */
  always @*
    tc_page_size = n518; // (isignal)
  initial
    tc_page_size = 4'b1100;
  /* TG68K_PMMU_030.vhd:160:10  */
  always @*
    tc_page_shift = n519; // (isignal)
  initial
    tc_page_shift = 4'b1100;
  /* TG68K_PMMU_030.vhd:161:10  */
  always @*
    tc_sre = n460; // (isignal)
  initial
    tc_sre = 1'b0;
  /* TG68K_PMMU_030.vhd:162:10  */
  always @*
    tc_fcl = n461; // (isignal)
  initial
    tc_fcl = 1'b0;
  /* TG68K_PMMU_030.vhd:165:10  */
  always @*
    mmusr_update_req = n7650; // (isignal)
  initial
    mmusr_update_req = 1'b0;
  /* TG68K_PMMU_030.vhd:166:10  */
  always @*
    mmusr_update_ack = n7651; // (isignal)
  initial
    mmusr_update_ack = 1'b0;
  /* TG68K_PMMU_030.vhd:167:10  */
  always @*
    mmusr_update_value = n7652; // (isignal)
  initial
    mmusr_update_value = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:170:10  */
  always @*
    mmu_config_error = n7653; // (isignal)
  initial
    mmu_config_error = 1'b0;
  /* TG68K_PMMU_030.vhd:177:10  */
  always @*
    wstate = n7654; // (isignal)
  initial
    wstate = 4'b0000;
  /* TG68K_PMMU_030.vhd:180:10  */
  always @*
    walk_log_base = n7655; // (isignal)
  initial
    walk_log_base = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:181:10  */
  always @*
    walk_phys_base = n7656; // (isignal)
  initial
    walk_phys_base = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:183:10  */
  always @*
    walk_page_shift = n7657; // (isignal)
  initial
    walk_page_shift = 5'b01100;
  /* TG68K_PMMU_030.vhd:187:10  */
  always @*
    ptest_update_mmusr = n7659; // (isignal)
  initial
    ptest_update_mmusr = 1'b0;
  /* TG68K_PMMU_030.vhd:188:10  */
  always @*
    pflush_clear_atc = n7660; // (isignal)
  initial
    pflush_clear_atc = 1'b0;
  /* TG68K_PMMU_030.vhd:189:10  */
  always @*
    atc_flush_req = n7661; // (isignal)
  initial
    atc_flush_req = 1'b0;
  /* TG68K_PMMU_030.vhd:192:10  */
  always @*
    ptest_req_prev = n7662; // (isignal)
  initial
    ptest_req_prev = 1'b0;
  /* TG68K_PMMU_030.vhd:193:10  */
  always @*
    pflush_req_prev = n7663; // (isignal)
  initial
    pflush_req_prev = 1'b0;
  /* TG68K_PMMU_030.vhd:194:10  */
  always @*
    pload_req_prev = n7664; // (isignal)
  initial
    pload_req_prev = 1'b0;
  /* TG68K_PMMU_030.vhd:200:10  */
  always @*
    ptest_active = n7668; // (isignal)
  initial
    ptest_active = 1'b0;
  /* TG68K_PMMU_030.vhd:201:10  */
  always @*
    ptest_addr = n7670; // (isignal)
  initial
    ptest_addr = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:202:10  */
  always @*
    ptest_fc = n7672; // (isignal)
  initial
    ptest_fc = 3'b000;
  /* TG68K_PMMU_030.vhd:203:10  */
  always @*
    ptest_rw = n7676; // (isignal)
  initial
    ptest_rw = 1'b1;
  /* TG68K_PMMU_030.vhd:206:10  */
  always @*
    pload_active = n7679; // (isignal)
  initial
    pload_active = 1'b0;
  /* TG68K_PMMU_030.vhd:207:10  */
  always @*
    pload_addr = n7683; // (isignal)
  initial
    pload_addr = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:208:10  */
  always @*
    pload_fc = n7687; // (isignal)
  initial
    pload_fc = 3'b000;
  /* TG68K_PMMU_030.vhd:209:10  */
  always @*
    pload_rw = n7691; // (isignal)
  initial
    pload_rw = 1'b1;
  /* TG68K_PMMU_030.vhd:213:10  */
  always @*
    pflush_addr = n7698; // (isignal)
  initial
    pflush_addr = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:214:10  */
  always @*
    pflush_fc = n7702; // (isignal)
  initial
    pflush_fc = 3'b000;
  /* TG68K_PMMU_030.vhd:215:10  */
  always @*
    pflush_mode = n7706; // (isignal)
  initial
    pflush_mode = 5'b00000;
  /* TG68K_PMMU_030.vhd:218:10  */
  always @*
    walk_level = n7707; // (isignal)
  initial
    walk_level = 3'b000;
  /* TG68K_PMMU_030.vhd:219:10  */
  always @*
    walk_desc = n7708; // (isignal)
  initial
    walk_desc = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:220:10  */
  always @*
    walk_desc_high = n7711; // (isignal)
  initial
    walk_desc_high = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:221:10  */
  always @*
    walk_desc_low = n7714; // (isignal)
  initial
    walk_desc_low = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:222:10  */
  always @*
    walk_desc_is_long = n7717; // (isignal)
  initial
    walk_desc_is_long = 1'b0;
  /* TG68K_PMMU_030.vhd:223:10  */
  always @*
    walk_addr = n7718; // (isignal)
  initial
    walk_addr = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:224:10  */
  always @*
    walk_vpn = n7719; // (isignal)
  initial
    walk_vpn = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:226:10  */
  always @*
    walk_attr = n7721; // (isignal)
  initial
    walk_attr = 8'b00000000;
  /* TG68K_PMMU_030.vhd:227:10  */
  always @*
    walk_global = n7724; // (isignal)
  initial
    walk_global = 1'b0;
  /* TG68K_PMMU_030.vhd:228:10  */
  always @*
    walk_supervisor = n7727; // (isignal)
  initial
    walk_supervisor = 1'b0;
  /* TG68K_PMMU_030.vhd:229:10  */
  always @*
    indirect_addr = n7730; // (isignal)
  initial
    indirect_addr = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:230:10  */
  always @*
    indirect_target_long = n7733; // (isignal)
  initial
    indirect_target_long = 1'b0;
  /* TG68K_PMMU_030.vhd:235:10  */
  always @*
    walk_limit_valid = n7734; // (isignal)
  initial
    walk_limit_valid = 1'b0;
  /* TG68K_PMMU_030.vhd:239:10  */
  always @*
    walk_limit_lu = n7735; // (isignal)
  initial
    walk_limit_lu = 1'b0;
  /* TG68K_PMMU_030.vhd:240:10  */
  always @*
    walk_limit_value = n7736; // (isignal)
  initial
    walk_limit_value = 15'b000000000000000;
  /* TG68K_PMMU_030.vhd:246:10  */
  always @*
    desc_update_data = n7738; // (isignal)
  initial
    desc_update_data = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:794:15  */
  assign n96 = ~nreset;
  /* TG68K_PMMU_030.vhd:817:7  */
  assign n99 = mmu_config_ack ? 1'b0 : mmu_config_error;
  /* TG68K_PMMU_030.vhd:830:31  */
  assign n100 = pmmu_brief[9]; // extract
  /* TG68K_PMMU_030.vhd:831:18  */
  assign n101 = ~tc_en;
  /* TG68K_PMMU_030.vhd:831:9  */
  assign n104 = n101 ? 32'b00000000000000000000000000000000 : mmusr;
  /* TG68K_PMMU_030.vhd:843:7  */
  assign n105 = mmusr_update_req ? mmusr_update_value : mmusr;
  /* TG68K_PMMU_030.vhd:843:7  */
  assign n108 = mmusr_update_req ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:823:7  */
  assign n109 = ptest_update_mmusr ? n104 : n105;
  /* TG68K_PMMU_030.vhd:823:7  */
  assign n111 = ptest_update_mmusr ? 1'b0 : n108;
  /* TG68K_PMMU_030.vhd:867:30  */
  assign n119 = reg_wdat & 32'b11111111111111111000011101110111;
  /* TG68K_PMMU_030.vhd:869:23  */
  assign n120 = ~reg_fd;
  /* TG68K_PMMU_030.vhd:869:13  */
  assign n123 = n120 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:861:11  */
  assign n125 = reg_sel == 5'b00010;
  /* TG68K_PMMU_030.vhd:880:30  */
  assign n127 = reg_wdat & 32'b11111111111111111000011101110111;
  /* TG68K_PMMU_030.vhd:882:23  */
  assign n128 = ~reg_fd;
  /* TG68K_PMMU_030.vhd:882:13  */
  assign n131 = n128 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:874:11  */
  assign n133 = reg_sel == 5'b00011;
  /* TG68K_PMMU_030.vhd:895:38  */
  assign n135 = reg_wdat & 32'b10000011111111111111111111111111;
  /* TG68K_PMMU_030.vhd:896:29  */
  assign n136 = reg_wdat[31]; // extract
  /* TG68K_PMMU_030.vhd:902:53  */
  assign n138 = reg_wdat[23:20]; // extract
  /* TG68K_PMMU_030.vhd:902:25  */
  assign n139 = {27'b0, n138};  //  uext
  /* TG68K_PMMU_030.vhd:902:15  */
  assign n140 = {1'b0, n139};  //  uext
  /* TG68K_PMMU_030.vhd:905:25  */
  assign n142 = $signed(n140) < $signed(32'b00000000000000000000000000001000);
  /* TG68K_PMMU_030.vhd:632:37  */
  assign n156 = reg_wdat[23:20]; // extract
  /* TG68K_PMMU_030.vhd:632:15  */
  assign n157 = {27'b0, n156};  //  uext
  /* TG68K_PMMU_030.vhd:632:5  */
  assign n158 = {1'b0, n157};  //  uext
  /* TG68K_PMMU_030.vhd:633:37  */
  assign n160 = reg_wdat[19:16]; // extract
  /* TG68K_PMMU_030.vhd:633:15  */
  assign n161 = {27'b0, n160};  //  uext
  /* TG68K_PMMU_030.vhd:633:5  */
  assign n162 = {1'b0, n161};  //  uext
  /* TG68K_PMMU_030.vhd:634:15  */
  assign n165 = n162 == 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:634:5  */
  assign n167 = n165 ? 32'b00000000000000000000000000000000 : n162;
  /* TG68K_PMMU_030.vhd:637:38  */
  assign n168 = reg_wdat[15:12]; // extract
  /* TG68K_PMMU_030.vhd:637:16  */
  assign n169 = {27'b0, n168};  //  uext
  /* TG68K_PMMU_030.vhd:637:5  */
  assign n170 = {1'b0, n169};  //  uext
  /* TG68K_PMMU_030.vhd:638:38  */
  assign n172 = reg_wdat[11:8]; // extract
  /* TG68K_PMMU_030.vhd:638:16  */
  assign n173 = {27'b0, n172};  //  uext
  /* TG68K_PMMU_030.vhd:638:5  */
  assign n174 = {1'b0, n173};  //  uext
  /* TG68K_PMMU_030.vhd:639:38  */
  assign n176 = reg_wdat[7:4]; // extract
  /* TG68K_PMMU_030.vhd:639:16  */
  assign n177 = {27'b0, n176};  //  uext
  /* TG68K_PMMU_030.vhd:639:5  */
  assign n178 = {1'b0, n177};  //  uext
  /* TG68K_PMMU_030.vhd:640:38  */
  assign n180 = reg_wdat[3:0]; // extract
  /* TG68K_PMMU_030.vhd:640:16  */
  assign n181 = {27'b0, n180};  //  uext
  /* TG68K_PMMU_030.vhd:640:5  */
  assign n182 = {1'b0, n181};  //  uext
  /* TG68K_PMMU_030.vhd:351:17  */
  assign n190 = $signed(n158) >= $signed(32'b00000000000000000000000000001000);
  /* TG68K_PMMU_030.vhd:351:35  */
  assign n192 = $signed(n158) <= $signed(32'b00000000000000000000000000001111);
  /* TG68K_PMMU_030.vhd:351:22  */
  assign n193 = n192 & n190;
  /* TG68K_PMMU_030.vhd:351:5  */
  assign n195 = n193 ? n158 : 32'b00000000000000000000000000001100;
  /* TG68K_PMMU_030.vhd:642:48  */
  assign n196 = n195 + n167;
  /* TG68K_PMMU_030.vhd:643:16  */
  assign n199 = n170 != 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:644:32  */
  assign n200 = n196 + n170;
  /* TG68K_PMMU_030.vhd:645:18  */
  assign n202 = n174 != 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:646:34  */
  assign n203 = n200 + n174;
  /* TG68K_PMMU_030.vhd:647:20  */
  assign n205 = n178 != 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:648:36  */
  assign n206 = n203 + n178;
  /* TG68K_PMMU_030.vhd:649:22  */
  assign n208 = n182 != 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:650:38  */
  assign n209 = n206 + n182;
  /* TG68K_PMMU_030.vhd:649:11  */
  assign n210 = n208 ? n209 : n206;
  /* TG68K_PMMU_030.vhd:647:9  */
  assign n211 = n205 ? n210 : n203;
  /* TG68K_PMMU_030.vhd:645:7  */
  assign n212 = n202 ? n211 : n200;
  /* TG68K_PMMU_030.vhd:643:5  */
  assign n213 = n199 ? n212 : n196;
  /* TG68K_PMMU_030.vhd:914:31  */
  assign n215 = n213 != 32'b00000000000000000000000000100000;
  /* TG68K_PMMU_030.vhd:914:17  */
  assign n219 = n215 ? 1'b1 : 1'b0;
  assign n220 = n135[31]; // extract
  /* TG68K_PMMU_030.vhd:914:17  */
  assign n221 = n215 ? 1'b0 : n220;
  /* TG68K_PMMU_030.vhd:905:15  */
  assign n223 = n142 ? 1'b1 : n219;
  /* TG68K_PMMU_030.vhd:905:15  */
  assign n224 = n142 ? 1'b0 : n221;
  /* TG68K_PMMU_030.vhd:898:13  */
  assign n227 = n136 ? n223 : 1'b0;
  assign n228 = n135[23]; // extract
  /* TG68K_PMMU_030.vhd:898:13  */
  assign n229 = n136 ? 1'b1 : n228;
  assign n230 = n135[31]; // extract
  /* TG68K_PMMU_030.vhd:898:13  */
  assign n231 = n136 ? n224 : n230;
  assign n233 = n135[22:0]; // extract
  assign n234 = n135[30:24]; // extract
  assign n237 = {n231, n234, n229, n233};
  /* TG68K_PMMU_030.vhd:934:23  */
  assign n238 = ~reg_fd;
  /* TG68K_PMMU_030.vhd:934:13  */
  assign n241 = n238 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:885:11  */
  assign n243 = reg_sel == 5'b10000;
  /* TG68K_PMMU_030.vhd:942:34  */
  assign n245 = reg_wdat & 32'b11111111111111110000000000000011;
  /* TG68K_PMMU_030.vhd:946:26  */
  assign n246 = reg_wdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:946:39  */
  assign n248 = n246 == 2'b00;
  /* TG68K_PMMU_030.vhd:946:15  */
  assign n251 = n248 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:956:34  */
  assign n253 = reg_wdat & 32'b11111111111111111111111111110000;
  /* TG68K_PMMU_030.vhd:939:13  */
  assign n254 = reg_part ? n245 : srp_h;
  /* TG68K_PMMU_030.vhd:939:13  */
  assign n255 = reg_part ? srp_l : n253;
  /* TG68K_PMMU_030.vhd:939:13  */
  assign n256 = reg_part ? n251 : n99;
  /* TG68K_PMMU_030.vhd:961:23  */
  assign n257 = ~reg_fd;
  /* TG68K_PMMU_030.vhd:961:13  */
  assign n260 = n257 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:937:11  */
  assign n262 = reg_sel == 5'b10010;
  /* TG68K_PMMU_030.vhd:969:34  */
  assign n264 = reg_wdat & 32'b11111111111111110000000000000011;
  /* TG68K_PMMU_030.vhd:973:26  */
  assign n265 = reg_wdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:973:39  */
  assign n267 = n265 == 2'b00;
  /* TG68K_PMMU_030.vhd:973:15  */
  assign n270 = n267 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:983:34  */
  assign n272 = reg_wdat & 32'b11111111111111111111111111110000;
  /* TG68K_PMMU_030.vhd:966:13  */
  assign n273 = reg_part ? n264 : crp_h;
  /* TG68K_PMMU_030.vhd:966:13  */
  assign n274 = reg_part ? crp_l : n272;
  /* TG68K_PMMU_030.vhd:966:13  */
  assign n275 = reg_part ? n270 : n99;
  /* TG68K_PMMU_030.vhd:989:23  */
  assign n276 = ~reg_fd;
  /* TG68K_PMMU_030.vhd:989:13  */
  assign n279 = n276 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:964:11  */
  assign n281 = reg_sel == 5'b10011;
  /* TG68K_PMMU_030.vhd:999:24  */
  assign n282 = reg_wdat[15]; // extract
  assign n284 = n109[15]; // extract
  /* TG68K_PMMU_030.vhd:999:13  */
  assign n285 = n282 ? 1'b0 : n284;
  /* TG68K_PMMU_030.vhd:1002:24  */
  assign n286 = reg_wdat[14]; // extract
  assign n288 = n109[14]; // extract
  /* TG68K_PMMU_030.vhd:1002:13  */
  assign n289 = n286 ? 1'b0 : n288;
  /* TG68K_PMMU_030.vhd:1005:24  */
  assign n290 = reg_wdat[13]; // extract
  assign n292 = n109[13]; // extract
  /* TG68K_PMMU_030.vhd:1005:13  */
  assign n293 = n290 ? 1'b0 : n292;
  /* TG68K_PMMU_030.vhd:1008:24  */
  assign n294 = reg_wdat[9]; // extract
  assign n296 = n109[9]; // extract
  /* TG68K_PMMU_030.vhd:1008:13  */
  assign n297 = n294 ? 1'b0 : n296;
  /* TG68K_PMMU_030.vhd:992:11  */
  assign n299 = reg_sel == 5'b11000;
  assign n300 = {n299, n281, n262, n243, n133, n125};
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n301 = tc;
      6'b010000: n301 = tc;
      6'b001000: n301 = tc;
      6'b000100: n301 = n237;
      6'b000010: n301 = tc;
      6'b000001: n301 = tc;
      default: n301 = tc;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n302 = crp_h;
      6'b010000: n302 = n273;
      6'b001000: n302 = crp_h;
      6'b000100: n302 = crp_h;
      6'b000010: n302 = crp_h;
      6'b000001: n302 = crp_h;
      default: n302 = crp_h;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n303 = crp_l;
      6'b010000: n303 = n274;
      6'b001000: n303 = crp_l;
      6'b000100: n303 = crp_l;
      6'b000010: n303 = crp_l;
      6'b000001: n303 = crp_l;
      default: n303 = crp_l;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n304 = srp_h;
      6'b010000: n304 = srp_h;
      6'b001000: n304 = n254;
      6'b000100: n304 = srp_h;
      6'b000010: n304 = srp_h;
      6'b000001: n304 = srp_h;
      default: n304 = srp_h;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n305 = srp_l;
      6'b010000: n305 = srp_l;
      6'b001000: n305 = n255;
      6'b000100: n305 = srp_l;
      6'b000010: n305 = srp_l;
      6'b000001: n305 = srp_l;
      default: n305 = srp_l;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n306 = tt0;
      6'b010000: n306 = tt0;
      6'b001000: n306 = tt0;
      6'b000100: n306 = tt0;
      6'b000010: n306 = tt0;
      6'b000001: n306 = n119;
      default: n306 = tt0;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n307 = tt1;
      6'b010000: n307 = tt1;
      6'b001000: n307 = tt1;
      6'b000100: n307 = tt1;
      6'b000010: n307 = n127;
      6'b000001: n307 = tt1;
      default: n307 = tt1;
    endcase
  assign n308 = n109[9]; // extract
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n309 = n297;
      6'b010000: n309 = n308;
      6'b001000: n309 = n308;
      6'b000100: n309 = n308;
      6'b000010: n309 = n308;
      6'b000001: n309 = n308;
      default: n309 = n308;
    endcase
  assign n310 = n109[13]; // extract
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n311 = n293;
      6'b010000: n311 = n310;
      6'b001000: n311 = n310;
      6'b000100: n311 = n310;
      6'b000010: n311 = n310;
      6'b000001: n311 = n310;
      default: n311 = n310;
    endcase
  assign n312 = n109[14]; // extract
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n313 = n289;
      6'b010000: n313 = n312;
      6'b001000: n313 = n312;
      6'b000100: n313 = n312;
      6'b000010: n313 = n312;
      6'b000001: n313 = n312;
      default: n313 = n312;
    endcase
  assign n314 = n109[15]; // extract
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n315 = n285;
      6'b010000: n315 = n314;
      6'b001000: n315 = n314;
      6'b000100: n315 = n314;
      6'b000010: n315 = n314;
      6'b000001: n315 = n314;
      default: n315 = n314;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n316 = n99;
      6'b010000: n316 = n275;
      6'b001000: n316 = n256;
      6'b000100: n316 = n227;
      6'b000010: n316 = n99;
      6'b000001: n316 = n99;
      default: n316 = n99;
    endcase
  /* TG68K_PMMU_030.vhd:860:9  */
  always @*
    case (n300)
      6'b100000: n318 = 1'b0;
      6'b010000: n318 = n279;
      6'b001000: n318 = n260;
      6'b000100: n318 = n241;
      6'b000010: n318 = n131;
      6'b000001: n318 = n123;
      default: n318 = 1'b0;
    endcase
  assign n337 = {n315, n313, n311};
  assign n338 = n109[9]; // extract
  /* TG68K_PMMU_030.vhd:853:7  */
  assign n339 = reg_we ? n309 : n338;
  assign n340 = n109[15:13]; // extract
  /* TG68K_PMMU_030.vhd:853:7  */
  assign n341 = reg_we ? n337 : n340;
  assign n343 = n109[8:0]; // extract
  assign n344 = n109[31:16]; // extract
  assign n345 = n109[12:10]; // extract
  /* TG68K_PMMU_030.vhd:853:7  */
  assign n346 = reg_we ? n316 : n99;
  /* TG68K_PMMU_030.vhd:853:7  */
  assign n348 = reg_we ? n318 : 1'b0;
  assign n362 = {n344, n341, n345, n339, n343};
  /* TG68K_PMMU_030.vhd:1024:57  */
  assign n426 = reg_sel == 5'b00010;
  /* TG68K_PMMU_030.vhd:1024:44  */
  assign n427 = n426 ? tt0 : n430;
  /* TG68K_PMMU_030.vhd:1025:57  */
  assign n429 = reg_sel == 5'b00011;
  /* TG68K_PMMU_030.vhd:1024:67  */
  assign n430 = n429 ? tt1 : n433;
  /* TG68K_PMMU_030.vhd:1026:57  */
  assign n432 = reg_sel == 5'b10000;
  /* TG68K_PMMU_030.vhd:1025:67  */
  assign n433 = n432 ? tc : n437;
  /* TG68K_PMMU_030.vhd:1027:57  */
  assign n435 = reg_sel == 5'b10010;
  /* TG68K_PMMU_030.vhd:1027:67  */
  assign n436 = reg_part & n435;
  /* TG68K_PMMU_030.vhd:1026:67  */
  assign n437 = n436 ? srp_h : n442;
  /* TG68K_PMMU_030.vhd:1028:57  */
  assign n439 = reg_sel == 5'b10010;
  /* TG68K_PMMU_030.vhd:1028:80  */
  assign n440 = ~reg_part;
  /* TG68K_PMMU_030.vhd:1028:67  */
  assign n441 = n440 & n439;
  /* TG68K_PMMU_030.vhd:1027:86  */
  assign n442 = n441 ? srp_l : n446;
  /* TG68K_PMMU_030.vhd:1029:57  */
  assign n444 = reg_sel == 5'b10011;
  /* TG68K_PMMU_030.vhd:1029:67  */
  assign n445 = reg_part & n444;
  /* TG68K_PMMU_030.vhd:1028:86  */
  assign n446 = n445 ? crp_h : n451;
  /* TG68K_PMMU_030.vhd:1030:57  */
  assign n448 = reg_sel == 5'b10011;
  /* TG68K_PMMU_030.vhd:1030:80  */
  assign n449 = ~reg_part;
  /* TG68K_PMMU_030.vhd:1030:67  */
  assign n450 = n449 & n448;
  /* TG68K_PMMU_030.vhd:1029:86  */
  assign n451 = n450 ? crp_l : n457;
  /* TG68K_PMMU_030.vhd:1031:30  */
  assign n452 = mmusr[15:0]; // extract
  /* TG68K_PMMU_030.vhd:1031:23  */
  assign n454 = {16'b0000000000000000, n452};
  /* TG68K_PMMU_030.vhd:1031:57  */
  assign n456 = reg_sel == 5'b11000;
  /* TG68K_PMMU_030.vhd:1030:86  */
  assign n457 = n456 ? n454 : 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:1045:14  */
  assign n459 = tc[31]; // extract
  /* TG68K_PMMU_030.vhd:1046:15  */
  assign n460 = tc[25]; // extract
  /* TG68K_PMMU_030.vhd:1047:15  */
  assign n461 = tc[24]; // extract
  /* TG68K_PMMU_030.vhd:1061:39  */
  assign n472 = tc[15:12]; // extract
  /* TG68K_PMMU_030.vhd:1061:17  */
  assign n473 = {27'b0, n472};  //  uext
  /* TG68K_PMMU_030.vhd:1062:39  */
  assign n475 = tc[11:8]; // extract
  /* TG68K_PMMU_030.vhd:1062:17  */
  assign n476 = {27'b0, n475};  //  uext
  /* TG68K_PMMU_030.vhd:1063:39  */
  assign n478 = tc[7:4]; // extract
  /* TG68K_PMMU_030.vhd:1063:17  */
  assign n479 = {27'b0, n478};  //  uext
  /* TG68K_PMMU_030.vhd:1064:39  */
  assign n481 = tc[3:0]; // extract
  /* TG68K_PMMU_030.vhd:1064:17  */
  assign n482 = {27'b0, n481};  //  uext
  /* TG68K_PMMU_030.vhd:1066:23  */
  assign n484 = n473[4:0];  // trunc
  /* TG68K_PMMU_030.vhd:1067:23  */
  assign n485 = n476[4:0];  // trunc
  /* TG68K_PMMU_030.vhd:1068:23  */
  assign n486 = n479[4:0];  // trunc
  /* TG68K_PMMU_030.vhd:1069:23  */
  assign n487 = n482[4:0];  // trunc
  /* TG68K_PMMU_030.vhd:1081:37  */
  assign n499 = tc[23:20]; // extract
  /* TG68K_PMMU_030.vhd:1081:15  */
  assign n500 = {27'b0, n499};  //  uext
  /* TG68K_PMMU_030.vhd:1081:5  */
  assign n501 = {1'b0, n500};  //  uext
  /* TG68K_PMMU_030.vhd:1084:15  */
  assign n503 = $signed(n501) < $signed(32'b00000000000000000000000000001000);
  /* TG68K_PMMU_030.vhd:1084:5  */
  assign n505 = n503 ? 32'b00000000000000000000000000001100 : n501;
  /* TG68K_PMMU_030.vhd:351:17  */
  assign n512 = $signed(n505) >= $signed(32'b00000000000000000000000000001000);
  /* TG68K_PMMU_030.vhd:351:35  */
  assign n514 = $signed(n505) <= $signed(32'b00000000000000000000000000001111);
  /* TG68K_PMMU_030.vhd:351:22  */
  assign n515 = n514 & n512;
  /* TG68K_PMMU_030.vhd:351:5  */
  assign n517 = n515 ? n505 : 32'b00000000000000000000000000001100;
  /* TG68K_PMMU_030.vhd:1093:22  */
  assign n518 = n505[3:0];  // trunc
  /* TG68K_PMMU_030.vhd:1094:22  */
  assign n519 = n517[3:0];  // trunc
  /* TG68K_PMMU_030.vhd:1134:40  */
  assign n606 = ~tc_en;
  /* TG68K_PMMU_030.vhd:1134:29  */
  assign n607 = n606 ? addr_log : addr_phys_reg;
  /* TG68K_PMMU_030.vhd:1137:35  */
  assign n609 = ~tc_en;
  /* TG68K_PMMU_030.vhd:1137:24  */
  assign n610 = n609 ? 1'b0 : cache_inhibit_reg;
  /* TG68K_PMMU_030.vhd:1145:14  */
  always @*
    n611_hit_idx = n3806; // (isignal)
  initial
    n611_hit_idx = 3'b000;
  /* TG68K_PMMU_030.vhd:1154:15  */
  assign n626 = ~nreset;
  /* TG68K_PMMU_030.vhd:1175:7  */
  assign n629 = mmusr_update_ack ? 1'b0 : mmusr_update_req;
  /* TG68K_PMMU_030.vhd:1187:25  */
  assign n630 = ~walker_fault;
  /* TG68K_PMMU_030.vhd:1187:60  */
  assign n631 = ~walker_fault_ack_pending;
  /* TG68K_PMMU_030.vhd:1187:31  */
  assign n632 = n631 & n630;
  /* TG68K_PMMU_030.vhd:1187:9  */
  assign n634 = n632 ? 1'b0 : fault_reg;
  /* TG68K_PMMU_030.vhd:1187:9  */
  assign n636 = n632 ? 32'b00000000000000000000000000000000 : fault_status_reg;
  /* TG68K_PMMU_030.vhd:1212:18  */
  assign n645 = ~tc_en;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n661 = tt0[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n663 = tt0[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n665 = tt0[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n667 = tt0[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n669 = tt0[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n671 = addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n673 = ~n661;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n676 = n673 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n683 = n673 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n685 = n673 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n687 = n673 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n688 = n671 ^ n663;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n689 = ~n665;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n690 = n688 & n689;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n692 = n690 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n695 = n676 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n698 = n676 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n699 = n692 ? n695 : n698;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n701 = n676 ? n699 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n703 = fc ^ n667;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n704 = ~n669;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n705 = n703 & n704;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n707 = n705 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n710 = n676 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n713 = n676 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n714 = n707 ? n710 : n713;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n716 = n676 ? n714 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n718 = n701 & n661;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n719 = n716 & n718;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n721 = n676 ? 1'b1 : n683;
  /* TG68K_PMMU_030.vhd:466:12  */
  assign n722 = tt0[10]; // extract
  /* TG68K_PMMU_030.vhd:467:9  */
  assign n724 = n676 ? 1'b1 : n685;
  /* TG68K_PMMU_030.vhd:469:9  */
  assign n726 = n676 ? 1'b0 : n685;
  /* TG68K_PMMU_030.vhd:466:7  */
  assign n727 = n722 ? n724 : n726;
  /* TG68K_PMMU_030.vhd:466:7  */
  assign n728 = n676 ? n727 : n685;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n729 = tt0[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n730 = ~n729;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n731 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n732 = ~rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n733 = n732 & n731;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n735 = n676 ? 1'b0 : n721;
  /* TG68K_PMMU_030.vhd:479:11  */
  assign n737 = n676 ? 1'b0 : n687;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n738 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n739 = ~n738;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n740 = rw & n739;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n742 = n747 ? 1'b0 : n721;
  /* TG68K_PMMU_030.vhd:483:11  */
  assign n744 = n676 ? 1'b0 : n687;
  /* TG68K_PMMU_030.vhd:485:11  */
  assign n746 = n676 ? 1'b0 : n687;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n747 = n676 & n740;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n748 = n740 ? n744 : n746;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n749 = n733 ? n735 : n742;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n750 = n733 ? n737 : n748;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n751 = n757 ? n749 : n721;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n752 = n676 ? n750 : n687;
  /* TG68K_PMMU_030.vhd:488:9  */
  assign n754 = n676 ? 1'b0 : n687;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n755 = n676 & n730;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n756 = n730 ? n752 : n754;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n757 = n755 & n676;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n758 = n676 ? n756 : n687;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n760 = n676 ? 1'b0 : n683;
  /* TG68K_PMMU_030.vhd:503:7  */
  assign n762 = n676 ? 1'b0 : n685;
  /* TG68K_PMMU_030.vhd:504:7  */
  assign n764 = n676 ? 1'b0 : n687;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n765 = n719 ? n751 : n760;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n766 = n719 ? n728 : n762;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n767 = n719 ? n758 : n764;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n768 = n676 ? n765 : n683;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n769 = n676 ? n766 : n685;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n770 = n676 ? n767 : n687;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n785 = tt1[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n787 = tt1[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n789 = tt1[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n791 = tt1[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n793 = tt1[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n795 = addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n797 = ~n785;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n800 = n797 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n807 = n797 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n809 = n797 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n811 = n797 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n812 = n795 ^ n787;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n813 = ~n789;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n814 = n812 & n813;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n816 = n814 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n819 = n800 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n822 = n800 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n823 = n816 ? n819 : n822;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n825 = n800 ? n823 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n827 = fc ^ n791;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n828 = ~n793;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n829 = n827 & n828;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n831 = n829 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n834 = n800 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n837 = n800 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n838 = n831 ? n834 : n837;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n840 = n800 ? n838 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n842 = n825 & n785;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n843 = n840 & n842;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n845 = n800 ? 1'b1 : n807;
  /* TG68K_PMMU_030.vhd:466:12  */
  assign n846 = tt1[10]; // extract
  /* TG68K_PMMU_030.vhd:467:9  */
  assign n848 = n800 ? 1'b1 : n809;
  /* TG68K_PMMU_030.vhd:469:9  */
  assign n850 = n800 ? 1'b0 : n809;
  /* TG68K_PMMU_030.vhd:466:7  */
  assign n851 = n846 ? n848 : n850;
  /* TG68K_PMMU_030.vhd:466:7  */
  assign n852 = n800 ? n851 : n809;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n853 = tt1[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n854 = ~n853;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n855 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n856 = ~rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n857 = n856 & n855;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n859 = n800 ? 1'b0 : n845;
  /* TG68K_PMMU_030.vhd:479:11  */
  assign n861 = n800 ? 1'b0 : n811;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n862 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n863 = ~n862;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n864 = rw & n863;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n866 = n871 ? 1'b0 : n845;
  /* TG68K_PMMU_030.vhd:483:11  */
  assign n868 = n800 ? 1'b0 : n811;
  /* TG68K_PMMU_030.vhd:485:11  */
  assign n870 = n800 ? 1'b0 : n811;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n871 = n800 & n864;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n872 = n864 ? n868 : n870;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n873 = n857 ? n859 : n866;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n874 = n857 ? n861 : n872;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n875 = n881 ? n873 : n845;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n876 = n800 ? n874 : n811;
  /* TG68K_PMMU_030.vhd:488:9  */
  assign n878 = n800 ? 1'b0 : n811;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n879 = n800 & n854;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n880 = n854 ? n876 : n878;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n881 = n879 & n800;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n882 = n800 ? n880 : n811;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n884 = n800 ? 1'b0 : n807;
  /* TG68K_PMMU_030.vhd:503:7  */
  assign n886 = n800 ? 1'b0 : n809;
  /* TG68K_PMMU_030.vhd:504:7  */
  assign n888 = n800 ? 1'b0 : n811;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n889 = n843 ? n875 : n884;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n890 = n843 ? n852 : n886;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n891 = n843 ? n882 : n888;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n892 = n800 ? n889 : n807;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n893 = n800 ? n890 : n809;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n894 = n800 ? n891 : n811;
  assign n904 = n903[31:12]; // extract
  assign n911 = n903[8:7]; // extract
  assign n914 = n903[5:3]; // extract
  assign n915 = {n904, n770, 1'b0, 1'b0, n911, 1'b1, n914, 3'b000};
  assign n925 = n924[31:12]; // extract
  assign n932 = n924[8:7]; // extract
  assign n935 = n924[5:3]; // extract
  assign n936 = {n925, n894, 1'b0, 1'b0, n932, 1'b1, n935, 3'b000};
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n937 = atc_valid[7]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n939 = atc_shift[39:35]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n940 = {27'b0, n939};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n947 = $signed(n940) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n949 = $signed(n940) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n950 = n947 | n949;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n953 = n950 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n959 = n950 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n960 = {26'b0, n939};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n962 = 32'b11111111111111111111111111111111 << n960;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n964 = n953 ? n962 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n966 = addr_log & n964;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n967 = n953 ? n966 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n972 = n953 ? n967 : n959;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n978 = atc_fc[23:21]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n979 = n978 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n980 = atc_is_insn[7]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n981 = n980 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n982 = n981 & n979;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n983 = atc_log_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n984 = n972 == n983;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n985 = n984 & n982;
  /* TG68K_PMMU_030.vhd:1288:15  */
  assign n993 = n985 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n995 = n937 ? n993 : 1'b0;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n998 = atc_valid[6]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1000 = atc_shift[34:30]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1001 = {27'b0, n1000};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1008 = $signed(n1001) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1010 = $signed(n1001) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1011 = n1008 | n1010;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1014 = n1011 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1020 = n1011 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1021 = {26'b0, n1000};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1023 = 32'b11111111111111111111111111111111 << n1021;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1025 = n1014 ? n1023 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1027 = addr_log & n1025;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1028 = n1014 ? n1027 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1033 = n1014 ? n1028 : n1020;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1039 = atc_fc[20:18]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1040 = n1039 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1041 = atc_is_insn[6]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1042 = n1041 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1043 = n1042 & n1040;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1044 = atc_log_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1045 = n1033 == n1044;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1046 = n1045 & n1043;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1053 = n1057 ? 1'b1 : n995;
  /* TG68K_PMMU_030.vhd:1288:15  */
  assign n1056 = n1046 ? 3'b001 : 3'b000;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1057 = n1046 & n998;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1059 = n998 ? n1056 : 3'b000;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1061 = atc_valid[5]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1063 = atc_shift[29:25]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1064 = {27'b0, n1063};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1071 = $signed(n1064) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1073 = $signed(n1064) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1074 = n1071 | n1073;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1077 = n1074 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1083 = n1074 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1084 = {26'b0, n1063};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1086 = 32'b11111111111111111111111111111111 << n1084;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1088 = n1077 ? n1086 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1090 = addr_log & n1088;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1091 = n1077 ? n1090 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1096 = n1077 ? n1091 : n1083;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1102 = atc_fc[17:15]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1103 = n1102 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1104 = atc_is_insn[5]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1105 = n1104 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1106 = n1105 & n1103;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1107 = atc_log_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1108 = n1096 == n1107;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1109 = n1108 & n1106;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1116 = n1119 ? 1'b1 : n1053;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1118 = n1120 ? 3'b010 : n1059;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1119 = n1109 & n1061;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1120 = n1109 & n1061;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1122 = atc_valid[4]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1124 = atc_shift[24:20]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1125 = {27'b0, n1124};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1132 = $signed(n1125) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1134 = $signed(n1125) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1135 = n1132 | n1134;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1138 = n1135 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1144 = n1135 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1145 = {26'b0, n1124};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1147 = 32'b11111111111111111111111111111111 << n1145;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1149 = n1138 ? n1147 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1151 = addr_log & n1149;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1152 = n1138 ? n1151 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1157 = n1138 ? n1152 : n1144;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1163 = atc_fc[14:12]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1164 = n1163 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1165 = atc_is_insn[4]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1166 = n1165 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1167 = n1166 & n1164;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1168 = atc_log_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1169 = n1157 == n1168;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1170 = n1169 & n1167;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1177 = n1180 ? 1'b1 : n1116;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1179 = n1181 ? 3'b011 : n1118;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1180 = n1170 & n1122;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1181 = n1170 & n1122;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1183 = atc_valid[3]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1185 = atc_shift[19:15]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1186 = {27'b0, n1185};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1193 = $signed(n1186) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1195 = $signed(n1186) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1196 = n1193 | n1195;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1199 = n1196 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1205 = n1196 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1206 = {26'b0, n1185};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1208 = 32'b11111111111111111111111111111111 << n1206;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1210 = n1199 ? n1208 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1212 = addr_log & n1210;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1213 = n1199 ? n1212 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1218 = n1199 ? n1213 : n1205;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1224 = atc_fc[11:9]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1225 = n1224 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1226 = atc_is_insn[3]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1227 = n1226 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1228 = n1227 & n1225;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1229 = atc_log_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1230 = n1218 == n1229;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1231 = n1230 & n1228;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1238 = n1241 ? 1'b1 : n1177;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1240 = n1242 ? 3'b100 : n1179;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1241 = n1231 & n1183;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1242 = n1231 & n1183;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1244 = atc_valid[2]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1246 = atc_shift[14:10]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1247 = {27'b0, n1246};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1254 = $signed(n1247) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1256 = $signed(n1247) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1257 = n1254 | n1256;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1260 = n1257 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1266 = n1257 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1267 = {26'b0, n1246};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1269 = 32'b11111111111111111111111111111111 << n1267;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1271 = n1260 ? n1269 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1273 = addr_log & n1271;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1274 = n1260 ? n1273 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1279 = n1260 ? n1274 : n1266;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1285 = atc_fc[8:6]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1286 = n1285 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1287 = atc_is_insn[2]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1288 = n1287 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1289 = n1288 & n1286;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1290 = atc_log_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1291 = n1279 == n1290;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1292 = n1291 & n1289;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1299 = n1302 ? 1'b1 : n1238;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1301 = n1303 ? 3'b101 : n1240;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1302 = n1292 & n1244;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1303 = n1292 & n1244;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1305 = atc_valid[1]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1307 = atc_shift[9:5]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1308 = {27'b0, n1307};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1315 = $signed(n1308) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1317 = $signed(n1308) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1318 = n1315 | n1317;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1321 = n1318 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1327 = n1318 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1328 = {26'b0, n1307};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1330 = 32'b11111111111111111111111111111111 << n1328;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1332 = n1321 ? n1330 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1334 = addr_log & n1332;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1335 = n1321 ? n1334 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1340 = n1321 ? n1335 : n1327;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1346 = atc_fc[5:3]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1347 = n1346 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1348 = atc_is_insn[1]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1349 = n1348 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1350 = n1349 & n1347;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1351 = atc_log_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1352 = n1340 == n1351;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1353 = n1352 & n1350;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1360 = n1363 ? 1'b1 : n1299;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1362 = n1364 ? 3'b110 : n1301;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1363 = n1353 & n1305;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1364 = n1353 & n1305;
  /* TG68K_PMMU_030.vhd:1276:25  */
  assign n1366 = atc_valid[0]; // extract
  /* TG68K_PMMU_030.vhd:1277:61  */
  assign n1368 = atc_shift[4:0]; // extract
  /* TG68K_PMMU_030.vhd:1277:52  */
  assign n1369 = {27'b0, n1368};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n1376 = $signed(n1369) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n1378 = $signed(n1369) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n1379 = n1376 | n1378;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1382 = n1379 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n1388 = n1379 ? addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n1389 = {26'b0, n1368};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n1391 = 32'b11111111111111111111111111111111 << n1389;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n1393 = n1382 ? n1391 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n1395 = addr_log & n1393;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n1396 = n1382 ? n1395 : addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n1401 = n1382 ? n1396 : n1388;
  /* TG68K_PMMU_030.vhd:1288:24  */
  assign n1407 = atc_fc[2:0]; // extract
  /* TG68K_PMMU_030.vhd:1288:28  */
  assign n1408 = n1407 == fc;
  /* TG68K_PMMU_030.vhd:1289:29  */
  assign n1409 = atc_is_insn[0]; // extract
  /* TG68K_PMMU_030.vhd:1289:33  */
  assign n1410 = n1409 == is_insn;
  /* TG68K_PMMU_030.vhd:1288:33  */
  assign n1411 = n1410 & n1408;
  /* TG68K_PMMU_030.vhd:1290:45  */
  assign n1412 = atc_log_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:1290:31  */
  assign n1413 = n1401 == n1412;
  /* TG68K_PMMU_030.vhd:1289:43  */
  assign n1414 = n1413 & n1411;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1421 = n1424 ? 1'b1 : n1360;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1423 = n1425 ? 3'b111 : n1362;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1424 = n1414 & n1366;
  /* TG68K_PMMU_030.vhd:1276:13  */
  assign n1425 = n1414 & n1366;
  /* TG68K_PMMU_030.vhd:1308:35  */
  assign n1427 = walker_fault_ack_pending & walker_fault;
  /* TG68K_PMMU_030.vhd:1311:22  */
  assign n1428 = ~rw;
  /* TG68K_PMMU_030.vhd:1311:41  */
  assign n1430 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1311:28  */
  assign n1433 = n7744 & n1428;
  /* TG68K_PMMU_030.vhd:1328:51  */
  assign n1438 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1329:71  */
  assign n1442 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1329:47  */
  assign n1445 = addr_log - n7746;
  /* TG68K_PMMU_030.vhd:1330:40  */
  assign n1446 = n7745 + n1445;
  /* TG68K_PMMU_030.vhd:1332:45  */
  assign n1448 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1336:21  */
  assign n1451 = fc[2]; // extract
  /* TG68K_PMMU_030.vhd:1336:25  */
  assign n1452 = ~n1451;
  /* TG68K_PMMU_030.vhd:1336:44  */
  assign n1454 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1336:56  */
  assign n1457 = ~n7756;
  /* TG68K_PMMU_030.vhd:1336:31  */
  assign n1458 = n1457 & n1452;
  /* TG68K_PMMU_030.vhd:1343:43  */
  assign n1461 = 3'b111 - n1423;
  assign n1471 = n1470[31:16]; // extract
  assign n1477 = n1470[12]; // extract
  assign n1484 = n1470[8:7]; // extract
  assign n1487 = n1470[5:3]; // extract
  assign n1488 = {n1471, 1'b0, 1'b0, 1'b1, n1477, n7758, 1'b0, 1'b0, n1484, 1'b0, n1487, 3'b011};
  /* TG68K_PMMU_030.vhd:1354:51  */
  assign n1490 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1355:71  */
  assign n1494 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1355:47  */
  assign n1497 = addr_log - n7760;
  /* TG68K_PMMU_030.vhd:1356:40  */
  assign n1498 = n7759 + n1497;
  /* TG68K_PMMU_030.vhd:1358:45  */
  assign n1500 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1359:45  */
  assign n1504 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1365:37  */
  assign n1507 = walker_fault_ack_pending & walker_fault;
  /* TG68K_PMMU_030.vhd:1369:53  */
  assign n1509 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1370:73  */
  assign n1513 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1370:49  */
  assign n1516 = addr_log - n7769;
  /* TG68K_PMMU_030.vhd:1371:42  */
  assign n1517 = n7768 + n1516;
  /* TG68K_PMMU_030.vhd:1382:47  */
  assign n1521 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1383:47  */
  assign n1525 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1387:45  */
  assign n1530 = 3'b111 - n1423;
  /* TG68K_PMMU_030.vhd:1388:40  */
  assign n1534 = 3'b111 - n1423;
  assign n1543 = n1542[31:12]; // extract
  assign n1549 = n1542[8:7]; // extract
  assign n1552 = n1542[5:3]; // extract
  assign n1553 = {n1543, n7778, 1'b0, n7783, n1549, 1'b0, n1552, 3'b011};
  /* TG68K_PMMU_030.vhd:1365:15  */
  assign n1554 = n1507 ? addr_phys_reg : n1517;
  /* TG68K_PMMU_030.vhd:1365:15  */
  assign n1555 = n1507 ? cache_inhibit_reg : n7774;
  /* TG68K_PMMU_030.vhd:1365:15  */
  assign n1556 = n1507 ? write_protect_reg : n7776;
  /* TG68K_PMMU_030.vhd:1365:15  */
  assign n1558 = n1507 ? n634 : 1'b0;
  /* TG68K_PMMU_030.vhd:1365:15  */
  assign n1559 = n1507 ? n636 : n1553;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1563 = n1458 ? n1498 : n1554;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1564 = n1458 ? n7765 : n1555;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1565 = n1458 ? n7767 : n1556;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1567 = n1458 ? 1'b1 : n1558;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1568 = n1458 ? n1488 : n1559;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1570 = n1458 ? 1'b1 : n629;
  /* TG68K_PMMU_030.vhd:1336:13  */
  assign n1571 = n1458 ? n1488 : mmusr_update_value;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1576 = n1433 ? n1446 : n1563;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1577 = n1433 ? n7751 : n1564;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1579 = n1433 ? 1'b1 : n1565;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1581 = n1433 ? 1'b1 : n1567;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1582 = n1433 ? 32'b00000000000000000000100000000011 : n1568;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1584 = n1433 ? 1'b1 : n1570;
  /* TG68K_PMMU_030.vhd:1311:13  */
  assign n1585 = n1433 ? 32'b00000000000000000000100000000011 : n1571;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1591 = n1427 ? addr_phys_reg : n1576;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1592 = n1427 ? cache_inhibit_reg : n1577;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1593 = n1427 ? write_protect_reg : n1579;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1594 = n1427 ? n634 : n1581;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1595 = n1427 ? n636 : n1582;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1596 = n1427 ? n629 : n1584;
  /* TG68K_PMMU_030.vhd:1308:13  */
  assign n1597 = n1427 ? mmusr_update_value : n1585;
  /* TG68K_PMMU_030.vhd:1397:24  */
  assign n1602 = ~n768;
  /* TG68K_PMMU_030.vhd:1397:42  */
  assign n1603 = ~n892;
  /* TG68K_PMMU_030.vhd:1397:30  */
  assign n1604 = n1603 & n1602;
  /* TG68K_PMMU_030.vhd:1397:72  */
  assign n1605 = ~translation_pending;
  /* TG68K_PMMU_030.vhd:1397:48  */
  assign n1606 = n1605 & n1604;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1617 = n1606 ? addr_log : saved_addr_log;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1618 = n1606 ? fc : saved_fc;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1619 = n1606 ? is_insn : saved_is_insn;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1620 = n1606 ? rw : saved_rw;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1622 = n1606 ? 1'b1 : translation_pending;
  /* TG68K_PMMU_030.vhd:1397:13  */
  assign n1624 = n1606 ? 1'b1 : walk_req;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1625 = n1421 ? n1591 : addr_phys_reg;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1626 = n1421 ? n1592 : cache_inhibit_reg;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1627 = n1421 ? n1593 : write_protect_reg;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1628 = n1421 ? n1594 : n634;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1629 = n1421 ? n1595 : n636;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1630 = n1421 ? saved_addr_log : n1617;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1631 = n1421 ? saved_fc : n1618;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1632 = n1421 ? saved_is_insn : n1619;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1633 = n1421 ? saved_rw : n1620;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1634 = n1421 ? translation_pending : n1622;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1635 = n1421 ? walk_req : n1624;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1636 = n1421 ? n1596 : n629;
  /* TG68K_PMMU_030.vhd:1305:11  */
  assign n1637 = n1421 ? n1597 : mmusr_update_value;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1642 = n892 ? addr_log : n1625;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1643 = n892 ? n893 : n1626;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1644 = n892 ? n894 : n1627;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1646 = n892 ? 1'b0 : n1628;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1647 = n892 ? n936 : n1629;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1648 = n892 ? saved_addr_log : n1630;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1649 = n892 ? saved_fc : n1631;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1650 = n892 ? saved_is_insn : n1632;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1651 = n892 ? saved_rw : n1633;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1652 = n892 ? translation_pending : n1634;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1653 = n892 ? walk_req : n1635;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1654 = n892 ? n629 : n1636;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1655 = n892 ? mmusr_update_value : n1637;
  /* TG68K_PMMU_030.vhd:1257:11  */
  assign n1659 = n892 ? 3'b000 : n1423;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1665 = n768 ? addr_log : n1642;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1666 = n768 ? n769 : n1643;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1667 = n768 ? n770 : n1644;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1669 = n768 ? 1'b0 : n1646;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1670 = n768 ? n915 : n1647;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1671 = n768 ? saved_addr_log : n1648;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1672 = n768 ? saved_fc : n1649;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1673 = n768 ? saved_is_insn : n1650;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1674 = n768 ? saved_rw : n1651;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1675 = n768 ? translation_pending : n1652;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1676 = n768 ? walk_req : n1653;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1677 = n768 ? n629 : n1654;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1678 = n768 ? mmusr_update_value : n1655;
  /* TG68K_PMMU_030.vhd:1240:11  */
  assign n1682 = n768 ? 3'b000 : n1659;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1688 = n645 ? addr_log : n1665;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1690 = n645 ? 1'b0 : n1666;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1692 = n645 ? 1'b0 : n1667;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1694 = n645 ? 1'b0 : n1669;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1696 = n645 ? 32'b00000000000000000000000000000000 : n1670;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1697 = n645 ? saved_addr_log : n1671;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1698 = n645 ? saved_fc : n1672;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1699 = n645 ? saved_is_insn : n1673;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1700 = n645 ? saved_rw : n1674;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1702 = n645 ? 1'b0 : n1675;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1703 = n645 ? walk_req : n1676;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1704 = n645 ? n629 : n1677;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1705 = n645 ? mmusr_update_value : n1678;
  /* TG68K_PMMU_030.vhd:1212:9  */
  assign n1710 = n645 ? 3'b000 : n1682;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1735 = req ? n1688 : addr_phys_reg;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1736 = req ? n1690 : cache_inhibit_reg;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1737 = req ? n1692 : write_protect_reg;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1738 = req ? n1694 : fault_reg;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1739 = req ? n1696 : fault_status_reg;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1740 = req ? n1697 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1741 = req ? n1698 : saved_fc;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1742 = req ? n1699 : saved_is_insn;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1743 = req ? n1700 : saved_rw;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1744 = req ? n1702 : translation_pending;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1745 = req ? n1703 : walk_req;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1746 = req ? n1704 : n629;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1747 = req ? n1705 : mmusr_update_value;
  /* TG68K_PMMU_030.vhd:1184:7  */
  assign n1749 = req ? n1710 : n611_hit_idx;
  /* TG68K_PMMU_030.vhd:1430:48  */
  assign n1761 = ~translation_pending;
  /* TG68K_PMMU_030.vhd:1430:24  */
  assign n1762 = n1761 & tc_en;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n1777 = tt0[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n1779 = tt0[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n1781 = tt0[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n1783 = tt0[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n1785 = tt0[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n1787 = ptest_addr[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n1789 = ~n1777;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1792 = n1789 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1799 = n1789 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1803 = n1789 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n1804 = n1787 ^ n1779;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n1805 = ~n1781;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n1806 = n1804 & n1805;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n1808 = n1806 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n1811 = n1792 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n1814 = n1792 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n1815 = n1808 ? n1811 : n1814;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n1817 = n1792 ? n1815 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n1819 = ptest_fc ^ n1783;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n1820 = ~n1785;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n1821 = n1819 & n1820;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n1823 = n1821 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n1826 = n1792 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n1829 = n1792 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n1830 = n1823 ? n1826 : n1829;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n1832 = n1792 ? n1830 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n1834 = n1817 & n1777;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n1835 = n1832 & n1834;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n1837 = n1792 ? 1'b1 : n1799;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n1845 = tt0[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n1846 = ~n1845;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n1847 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n1848 = ~ptest_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n1849 = n1848 & n1847;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n1851 = n1792 ? 1'b0 : n1837;
  /* TG68K_PMMU_030.vhd:479:11  */
  assign n1853 = n1792 ? 1'b0 : n1803;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n1854 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n1855 = ~n1854;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n1856 = ptest_rw & n1855;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1858 = n1863 ? 1'b0 : n1837;
  /* TG68K_PMMU_030.vhd:483:11  */
  assign n1860 = n1792 ? 1'b0 : n1803;
  /* TG68K_PMMU_030.vhd:485:11  */
  assign n1862 = n1792 ? 1'b0 : n1803;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1863 = n1792 & n1856;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1864 = n1856 ? n1860 : n1862;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1865 = n1849 ? n1851 : n1858;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1866 = n1849 ? n1853 : n1864;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1867 = n1873 ? n1865 : n1837;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1868 = n1792 ? n1866 : n1803;
  /* TG68K_PMMU_030.vhd:488:9  */
  assign n1870 = n1792 ? 1'b0 : n1803;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1871 = n1792 & n1846;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1872 = n1846 ? n1868 : n1870;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1873 = n1871 & n1792;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1874 = n1792 ? n1872 : n1803;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n1876 = n1792 ? 1'b0 : n1799;
  /* TG68K_PMMU_030.vhd:504:7  */
  assign n1880 = n1792 ? 1'b0 : n1803;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n1881 = n1835 ? n1867 : n1876;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n1883 = n1835 ? n1874 : n1880;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n1884 = n1792 ? n1881 : n1799;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n1886 = n1792 ? n1883 : n1803;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n1901 = tt1[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n1903 = tt1[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n1905 = tt1[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n1907 = tt1[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n1909 = tt1[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n1911 = ptest_addr[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n1913 = ~n1901;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1916 = n1913 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1923 = n1913 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n1927 = n1913 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n1928 = n1911 ^ n1903;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n1929 = ~n1905;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n1930 = n1928 & n1929;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n1932 = n1930 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n1935 = n1916 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n1938 = n1916 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n1939 = n1932 ? n1935 : n1938;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n1941 = n1916 ? n1939 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n1943 = ptest_fc ^ n1907;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n1944 = ~n1909;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n1945 = n1943 & n1944;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n1947 = n1945 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n1950 = n1916 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n1953 = n1916 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n1954 = n1947 ? n1950 : n1953;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n1956 = n1916 ? n1954 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n1958 = n1941 & n1901;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n1959 = n1956 & n1958;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n1961 = n1916 ? 1'b1 : n1923;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n1969 = tt1[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n1970 = ~n1969;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n1971 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n1972 = ~ptest_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n1973 = n1972 & n1971;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n1975 = n1916 ? 1'b0 : n1961;
  /* TG68K_PMMU_030.vhd:479:11  */
  assign n1977 = n1916 ? 1'b0 : n1927;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n1978 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n1979 = ~n1978;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n1980 = ptest_rw & n1979;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1982 = n1987 ? 1'b0 : n1961;
  /* TG68K_PMMU_030.vhd:483:11  */
  assign n1984 = n1916 ? 1'b0 : n1927;
  /* TG68K_PMMU_030.vhd:485:11  */
  assign n1986 = n1916 ? 1'b0 : n1927;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1987 = n1916 & n1980;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n1988 = n1980 ? n1984 : n1986;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1989 = n1973 ? n1975 : n1982;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1990 = n1973 ? n1977 : n1988;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1991 = n1997 ? n1989 : n1961;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n1992 = n1916 ? n1990 : n1927;
  /* TG68K_PMMU_030.vhd:488:9  */
  assign n1994 = n1916 ? 1'b0 : n1927;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1995 = n1916 & n1970;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1996 = n1970 ? n1992 : n1994;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1997 = n1995 & n1916;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n1998 = n1916 ? n1996 : n1927;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n2000 = n1916 ? 1'b0 : n1923;
  /* TG68K_PMMU_030.vhd:504:7  */
  assign n2004 = n1916 ? 1'b0 : n1927;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2005 = n1959 ? n1991 : n2000;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2007 = n1959 ? n1998 : n2004;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2008 = n1916 ? n2005 : n1923;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2010 = n1916 ? n2007 : n1927;
  assign n2018 = n2017[31:12]; // extract
  assign n2025 = n2017[8:7]; // extract
  assign n2028 = n2017[5:3]; // extract
  assign n2029 = {n2018, n1886, 1'b0, 1'b0, n2025, 1'b1, n2028, 3'b000};
  assign n2037 = n2036[31:12]; // extract
  assign n2044 = n2036[8:7]; // extract
  assign n2047 = n2036[5:3]; // extract
  assign n2048 = {n2037, n2010, 1'b0, 1'b0, n2044, 1'b1, n2047, 3'b000};
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2049 = n2008 ? n1740 : ptest_addr;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2050 = n2008 ? n1741 : ptest_fc;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2052 = n2008 ? n1742 : 1'b0;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2053 = n2008 ? n1743 : ptest_rw;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2055 = n2008 ? n1744 : 1'b1;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2057 = n2008 ? n1745 : 1'b1;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2059 = n2008 ? 1'b1 : n1746;
  /* TG68K_PMMU_030.vhd:1444:11  */
  assign n2060 = n2008 ? n2048 : n1747;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2061 = n1884 ? n1740 : n2049;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2062 = n1884 ? n1741 : n2050;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2063 = n1884 ? n1742 : n2052;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2064 = n1884 ? n1743 : n2053;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2065 = n1884 ? n1744 : n2055;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2066 = n1884 ? n1745 : n2057;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2068 = n1884 ? 1'b1 : n2059;
  /* TG68K_PMMU_030.vhd:1435:11  */
  assign n2069 = n1884 ? n2029 : n2060;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2070 = n2084 ? n2061 : n1740;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2071 = n2085 ? n2062 : n1741;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2072 = n2086 ? n2063 : n1742;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2073 = n2087 ? n2064 : n1743;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2074 = n2088 ? n2065 : n1744;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2075 = n2089 ? n2066 : n1745;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2076 = n2090 ? n2068 : n1746;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2077 = n2091 ? n2069 : n1747;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2084 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2085 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2086 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2087 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2088 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2089 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2090 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1428:7  */
  assign n2091 = n1762 & ptest_active;
  /* TG68K_PMMU_030.vhd:1470:48  */
  assign n2098 = ~translation_pending;
  /* TG68K_PMMU_030.vhd:1470:24  */
  assign n2099 = n2098 & tc_en;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n2114 = tt0[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n2116 = tt0[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n2118 = tt0[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n2120 = tt0[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n2122 = tt0[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n2124 = pload_addr[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n2126 = ~n2114;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2129 = n2126 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2136 = n2126 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n2141 = n2124 ^ n2116;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n2142 = ~n2118;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n2143 = n2141 & n2142;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n2145 = n2143 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n2148 = n2129 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n2151 = n2129 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2152 = n2145 ? n2148 : n2151;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2154 = n2129 ? n2152 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n2156 = pload_fc ^ n2120;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n2157 = ~n2122;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n2158 = n2156 & n2157;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n2160 = n2158 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n2163 = n2129 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n2166 = n2129 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2167 = n2160 ? n2163 : n2166;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2169 = n2129 ? n2167 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n2171 = n2154 & n2114;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n2172 = n2169 & n2171;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n2174 = n2129 ? 1'b1 : n2136;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n2182 = tt0[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n2183 = ~n2182;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n2184 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n2185 = ~pload_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n2186 = n2185 & n2184;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n2188 = n2129 ? 1'b0 : n2174;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n2191 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n2192 = ~n2191;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n2193 = pload_rw & n2192;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2195 = n2200 ? 1'b0 : n2174;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2200 = n2129 & n2193;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n2202 = n2186 ? n2188 : n2195;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2204 = n2210 ? n2202 : n2174;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2208 = n2129 & n2183;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2210 = n2208 & n2129;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n2213 = n2129 ? 1'b0 : n2136;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2218 = n2172 ? n2204 : n2213;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2221 = n2129 ? n2218 : n2136;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n2238 = tt1[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n2240 = tt1[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n2242 = tt1[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n2244 = tt1[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n2246 = tt1[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n2248 = pload_addr[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n2250 = ~n2238;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2253 = n2250 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2260 = n2250 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n2265 = n2248 ^ n2240;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n2266 = ~n2242;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n2267 = n2265 & n2266;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n2269 = n2267 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n2272 = n2253 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n2275 = n2253 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2276 = n2269 ? n2272 : n2275;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2278 = n2253 ? n2276 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n2280 = pload_fc ^ n2244;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n2281 = ~n2246;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n2282 = n2280 & n2281;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n2284 = n2282 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n2287 = n2253 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n2290 = n2253 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2291 = n2284 ? n2287 : n2290;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2293 = n2253 ? n2291 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n2295 = n2278 & n2238;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n2296 = n2293 & n2295;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n2298 = n2253 ? 1'b1 : n2260;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n2306 = tt1[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n2307 = ~n2306;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n2308 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n2309 = ~pload_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n2310 = n2309 & n2308;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n2312 = n2253 ? 1'b0 : n2298;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n2315 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n2316 = ~n2315;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n2317 = pload_rw & n2316;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2319 = n2324 ? 1'b0 : n2298;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2324 = n2253 & n2317;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n2326 = n2310 ? n2312 : n2319;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2328 = n2334 ? n2326 : n2298;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2332 = n2253 & n2307;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2334 = n2332 & n2253;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n2337 = n2253 ? 1'b0 : n2260;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2342 = n2296 ? n2328 : n2337;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2345 = n2253 ? n2342 : n2260;
  /* TG68K_PMMU_030.vhd:1475:22  */
  assign n2348 = ~n2221;
  /* TG68K_PMMU_030.vhd:1475:40  */
  assign n2349 = ~n2345;
  /* TG68K_PMMU_030.vhd:1475:28  */
  assign n2350 = n2349 & n2348;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2351 = atc_valid[7]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2353 = atc_shift[39:35]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2354 = {27'b0, n2353};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2361 = $signed(n2354) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2363 = $signed(n2354) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2364 = n2361 | n2363;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2367 = n2364 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2373 = n2364 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2374 = {26'b0, n2353};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2376 = 32'b11111111111111111111111111111111 << n2374;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2378 = n2367 ? n2376 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2380 = pload_addr & n2378;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2381 = n2367 ? n2380 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2386 = n2367 ? n2381 : n2373;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2387 = atc_fc[23:21]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2388 = n2387 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2389 = atc_is_insn[7]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2390 = ~n2389;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2391 = n2390 & n2388;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2392 = atc_log_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2393 = n2386 == n2392;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2394 = n2393 & n2391;
  /* TG68K_PMMU_030.vhd:1481:17  */
  assign n2397 = n2394 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2399 = n2403 ? 3'b000 : n1749;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2401 = n2351 ? n2397 : 1'b0;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2403 = n2394 & n2351;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2405 = atc_valid[6]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2407 = atc_shift[34:30]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2408 = {27'b0, n2407};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2415 = $signed(n2408) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2417 = $signed(n2408) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2418 = n2415 | n2417;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2421 = n2418 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2427 = n2418 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2428 = {26'b0, n2407};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2430 = 32'b11111111111111111111111111111111 << n2428;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2432 = n2421 ? n2430 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2434 = pload_addr & n2432;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2435 = n2421 ? n2434 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2440 = n2421 ? n2435 : n2427;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2441 = atc_fc[20:18]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2442 = n2441 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2443 = atc_is_insn[6]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2444 = ~n2443;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2445 = n2444 & n2442;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2446 = atc_log_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2447 = n2440 == n2446;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2448 = n2447 & n2445;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2450 = n2453 ? 1'b1 : n2401;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2452 = n2454 ? 3'b001 : n2399;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2453 = n2448 & n2405;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2454 = n2448 & n2405;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2456 = atc_valid[5]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2458 = atc_shift[29:25]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2459 = {27'b0, n2458};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2466 = $signed(n2459) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2468 = $signed(n2459) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2469 = n2466 | n2468;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2472 = n2469 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2478 = n2469 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2479 = {26'b0, n2458};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2481 = 32'b11111111111111111111111111111111 << n2479;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2483 = n2472 ? n2481 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2485 = pload_addr & n2483;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2486 = n2472 ? n2485 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2491 = n2472 ? n2486 : n2478;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2492 = atc_fc[17:15]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2493 = n2492 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2494 = atc_is_insn[5]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2495 = ~n2494;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2496 = n2495 & n2493;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2497 = atc_log_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2498 = n2491 == n2497;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2499 = n2498 & n2496;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2501 = n2504 ? 1'b1 : n2450;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2503 = n2505 ? 3'b010 : n2452;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2504 = n2499 & n2456;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2505 = n2499 & n2456;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2507 = atc_valid[4]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2509 = atc_shift[24:20]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2510 = {27'b0, n2509};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2517 = $signed(n2510) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2519 = $signed(n2510) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2520 = n2517 | n2519;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2523 = n2520 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2529 = n2520 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2530 = {26'b0, n2509};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2532 = 32'b11111111111111111111111111111111 << n2530;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2534 = n2523 ? n2532 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2536 = pload_addr & n2534;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2537 = n2523 ? n2536 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2542 = n2523 ? n2537 : n2529;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2543 = atc_fc[14:12]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2544 = n2543 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2545 = atc_is_insn[4]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2546 = ~n2545;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2547 = n2546 & n2544;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2548 = atc_log_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2549 = n2542 == n2548;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2550 = n2549 & n2547;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2552 = n2555 ? 1'b1 : n2501;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2554 = n2556 ? 3'b011 : n2503;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2555 = n2550 & n2507;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2556 = n2550 & n2507;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2558 = atc_valid[3]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2560 = atc_shift[19:15]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2561 = {27'b0, n2560};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2568 = $signed(n2561) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2570 = $signed(n2561) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2571 = n2568 | n2570;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2574 = n2571 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2580 = n2571 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2581 = {26'b0, n2560};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2583 = 32'b11111111111111111111111111111111 << n2581;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2585 = n2574 ? n2583 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2587 = pload_addr & n2585;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2588 = n2574 ? n2587 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2593 = n2574 ? n2588 : n2580;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2594 = atc_fc[11:9]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2595 = n2594 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2596 = atc_is_insn[3]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2597 = ~n2596;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2598 = n2597 & n2595;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2599 = atc_log_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2600 = n2593 == n2599;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2601 = n2600 & n2598;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2603 = n2606 ? 1'b1 : n2552;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2605 = n2607 ? 3'b100 : n2554;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2606 = n2601 & n2558;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2607 = n2601 & n2558;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2609 = atc_valid[2]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2611 = atc_shift[14:10]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2612 = {27'b0, n2611};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2619 = $signed(n2612) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2621 = $signed(n2612) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2622 = n2619 | n2621;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2625 = n2622 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2631 = n2622 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2632 = {26'b0, n2611};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2634 = 32'b11111111111111111111111111111111 << n2632;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2636 = n2625 ? n2634 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2638 = pload_addr & n2636;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2639 = n2625 ? n2638 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2644 = n2625 ? n2639 : n2631;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2645 = atc_fc[8:6]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2646 = n2645 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2647 = atc_is_insn[2]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2648 = ~n2647;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2649 = n2648 & n2646;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2650 = atc_log_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2651 = n2644 == n2650;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2652 = n2651 & n2649;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2654 = n2657 ? 1'b1 : n2603;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2656 = n2658 ? 3'b101 : n2605;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2657 = n2652 & n2609;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2658 = n2652 & n2609;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2660 = atc_valid[1]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2662 = atc_shift[9:5]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2663 = {27'b0, n2662};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2670 = $signed(n2663) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2672 = $signed(n2663) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2673 = n2670 | n2672;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2676 = n2673 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2682 = n2673 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2683 = {26'b0, n2662};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2685 = 32'b11111111111111111111111111111111 << n2683;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2687 = n2676 ? n2685 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2689 = pload_addr & n2687;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2690 = n2676 ? n2689 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2695 = n2676 ? n2690 : n2682;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2696 = atc_fc[5:3]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2697 = n2696 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2698 = atc_is_insn[1]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2699 = ~n2698;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2700 = n2699 & n2697;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2701 = atc_log_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2702 = n2695 == n2701;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2703 = n2702 & n2700;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2705 = n2708 ? 1'b1 : n2654;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2707 = n2709 ? 3'b110 : n2656;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2708 = n2703 & n2660;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2709 = n2703 & n2660;
  /* TG68K_PMMU_030.vhd:1479:27  */
  assign n2711 = atc_valid[0]; // extract
  /* TG68K_PMMU_030.vhd:1480:65  */
  assign n2713 = atc_shift[4:0]; // extract
  /* TG68K_PMMU_030.vhd:1480:56  */
  assign n2714 = {27'b0, n2713};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n2721 = $signed(n2714) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n2723 = $signed(n2714) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n2724 = n2721 | n2723;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2727 = n2724 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n2733 = n2724 ? pload_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n2734 = {26'b0, n2713};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n2736 = 32'b11111111111111111111111111111111 << n2734;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n2738 = n2727 ? n2736 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n2740 = pload_addr & n2738;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n2741 = n2727 ? n2740 : pload_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n2746 = n2727 ? n2741 : n2733;
  /* TG68K_PMMU_030.vhd:1481:26  */
  assign n2747 = atc_fc[2:0]; // extract
  /* TG68K_PMMU_030.vhd:1481:30  */
  assign n2748 = n2747 == pload_fc;
  /* TG68K_PMMU_030.vhd:1482:31  */
  assign n2749 = atc_is_insn[0]; // extract
  /* TG68K_PMMU_030.vhd:1482:35  */
  assign n2750 = ~n2749;
  /* TG68K_PMMU_030.vhd:1481:41  */
  assign n2751 = n2750 & n2748;
  /* TG68K_PMMU_030.vhd:1483:47  */
  assign n2752 = atc_log_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:1483:33  */
  assign n2753 = n2746 == n2752;
  /* TG68K_PMMU_030.vhd:1482:41  */
  assign n2754 = n2753 & n2751;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2756 = n2759 ? 1'b1 : n2705;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2758 = n2760 ? 3'b111 : n2707;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2759 = n2754 & n2711;
  /* TG68K_PMMU_030.vhd:1479:15  */
  assign n2760 = n2754 & n2711;
  /* TG68K_PMMU_030.vhd:1490:20  */
  assign n2762 = ~n2756;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2763 = n2796 ? pload_addr : n2070;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2764 = n2797 ? pload_fc : n2071;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2766 = n2798 ? 1'b0 : n2072;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2767 = n2799 ? pload_rw : n2073;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2769 = n2800 ? 1'b1 : n2074;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2771 = n2801 ? 1'b1 : n2075;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2772 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2773 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2774 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2775 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2776 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1475:11  */
  assign n2777 = n2762 & n2350;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2779 = n2803 ? n2758 : n1749;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2781 = n2772 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2782 = n2773 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2783 = n2774 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2784 = n2775 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2785 = n2776 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2786 = n2777 & n2099;
  /* TG68K_PMMU_030.vhd:1470:9  */
  assign n2788 = n2350 & n2099;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2796 = n2781 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2797 = n2782 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2798 = n2783 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2799 = n2784 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2800 = n2785 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2801 = n2786 & pload_active;
  /* TG68K_PMMU_030.vhd:1468:7  */
  assign n2803 = n2788 & pload_active;
  /* TG68K_PMMU_030.vhd:1513:50  */
  assign n2811 = ~walker_fault_ack;
  /* TG68K_PMMU_030.vhd:1513:29  */
  assign n2812 = n2811 & walker_fault;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n2827 = tt0[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n2829 = tt0[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n2831 = tt0[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n2833 = tt0[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n2835 = tt0[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n2837 = saved_addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n2839 = ~n2827;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2842 = n2839 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2849 = n2839 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n2854 = n2837 ^ n2829;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n2855 = ~n2831;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n2856 = n2854 & n2855;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n2858 = n2856 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n2861 = n2842 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n2864 = n2842 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2865 = n2858 ? n2861 : n2864;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2867 = n2842 ? n2865 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n2869 = saved_fc ^ n2833;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n2870 = ~n2835;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n2871 = n2869 & n2870;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n2873 = n2871 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n2876 = n2842 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n2879 = n2842 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2880 = n2873 ? n2876 : n2879;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n2882 = n2842 ? n2880 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n2884 = n2867 & n2827;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n2885 = n2882 & n2884;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n2887 = n2842 ? 1'b1 : n2849;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n2895 = tt0[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n2896 = ~n2895;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n2897 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n2898 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n2899 = n2898 & n2897;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n2901 = n2842 ? 1'b0 : n2887;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n2904 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n2905 = ~n2904;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n2906 = saved_rw & n2905;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2908 = n2913 ? 1'b0 : n2887;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n2913 = n2842 & n2906;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n2915 = n2899 ? n2901 : n2908;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2917 = n2923 ? n2915 : n2887;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2921 = n2842 & n2896;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n2923 = n2921 & n2842;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n2926 = n2842 ? 1'b0 : n2849;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2931 = n2885 ? n2917 : n2926;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n2934 = n2842 ? n2931 : n2849;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n2951 = tt1[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n2953 = tt1[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n2955 = tt1[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n2957 = tt1[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n2959 = tt1[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n2961 = saved_addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n2963 = ~n2951;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2966 = n2963 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n2973 = n2963 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n2978 = n2961 ^ n2953;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n2979 = ~n2955;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n2980 = n2978 & n2979;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n2982 = n2980 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n2985 = n2966 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n2988 = n2966 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2989 = n2982 ? n2985 : n2988;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n2991 = n2966 ? n2989 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n2993 = saved_fc ^ n2957;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n2994 = ~n2959;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n2995 = n2993 & n2994;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n2997 = n2995 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n3000 = n2966 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n3003 = n2966 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n3004 = n2997 ? n3000 : n3003;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n3006 = n2966 ? n3004 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n3008 = n2991 & n2951;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n3009 = n3006 & n3008;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n3011 = n2966 ? 1'b1 : n2973;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n3019 = tt1[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n3020 = ~n3019;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n3021 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:476:31  */
  assign n3022 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:476:24  */
  assign n3023 = n3022 & n3021;
  /* TG68K_PMMU_030.vhd:478:11  */
  assign n3025 = n2966 ? 1'b0 : n3011;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n3028 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n3029 = ~n3028;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n3030 = saved_rw & n3029;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n3032 = n3037 ? 1'b0 : n3011;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n3037 = n2966 & n3030;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n3039 = n3023 ? n3025 : n3032;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n3041 = n3047 ? n3039 : n3011;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n3045 = n2966 & n3020;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n3047 = n3045 & n2966;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n3050 = n2966 ? 1'b0 : n2973;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n3055 = n3009 ? n3041 : n3050;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n3058 = n2966 ? n3055 : n2973;
  /* TG68K_PMMU_030.vhd:1543:26  */
  assign n3061 = n2934 | n3058;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3062 = atc_valid[7]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3064 = atc_shift[39:35]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3065 = {27'b0, n3064};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3072 = $signed(n3065) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3074 = $signed(n3065) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3075 = n3072 | n3074;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3078 = n3075 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3084 = n3075 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3085 = {26'b0, n3064};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3087 = 32'b11111111111111111111111111111111 << n3085;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3089 = n3078 ? n3087 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3091 = saved_addr_log & n3089;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3092 = n3078 ? n3091 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3097 = n3078 ? n3092 : n3084;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3098 = atc_fc[23:21]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3099 = n3098 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3100 = atc_is_insn[7]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3101 = n3100 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3102 = n3101 & n3099;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3103 = atc_log_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3104 = n3097 == n3103;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3105 = n3104 & n3102;
  /* TG68K_PMMU_030.vhd:1552:15  */
  assign n3108 = n3105 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3110 = n3114 ? 3'b000 : n2779;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3112 = n3062 ? n3108 : 1'b0;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3114 = n3105 & n3062;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3116 = atc_valid[6]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3118 = atc_shift[34:30]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3119 = {27'b0, n3118};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3126 = $signed(n3119) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3128 = $signed(n3119) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3129 = n3126 | n3128;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3132 = n3129 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3138 = n3129 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3139 = {26'b0, n3118};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3141 = 32'b11111111111111111111111111111111 << n3139;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3143 = n3132 ? n3141 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3145 = saved_addr_log & n3143;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3146 = n3132 ? n3145 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3151 = n3132 ? n3146 : n3138;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3152 = atc_fc[20:18]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3153 = n3152 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3154 = atc_is_insn[6]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3155 = n3154 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3156 = n3155 & n3153;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3157 = atc_log_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3158 = n3151 == n3157;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3159 = n3158 & n3156;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3161 = n3164 ? 1'b1 : n3112;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3163 = n3165 ? 3'b001 : n3110;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3164 = n3159 & n3116;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3165 = n3159 & n3116;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3167 = atc_valid[5]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3169 = atc_shift[29:25]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3170 = {27'b0, n3169};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3177 = $signed(n3170) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3179 = $signed(n3170) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3180 = n3177 | n3179;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3183 = n3180 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3189 = n3180 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3190 = {26'b0, n3169};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3192 = 32'b11111111111111111111111111111111 << n3190;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3194 = n3183 ? n3192 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3196 = saved_addr_log & n3194;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3197 = n3183 ? n3196 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3202 = n3183 ? n3197 : n3189;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3203 = atc_fc[17:15]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3204 = n3203 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3205 = atc_is_insn[5]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3206 = n3205 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3207 = n3206 & n3204;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3208 = atc_log_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3209 = n3202 == n3208;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3210 = n3209 & n3207;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3212 = n3215 ? 1'b1 : n3161;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3214 = n3216 ? 3'b010 : n3163;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3215 = n3210 & n3167;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3216 = n3210 & n3167;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3218 = atc_valid[4]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3220 = atc_shift[24:20]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3221 = {27'b0, n3220};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3228 = $signed(n3221) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3230 = $signed(n3221) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3231 = n3228 | n3230;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3234 = n3231 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3240 = n3231 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3241 = {26'b0, n3220};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3243 = 32'b11111111111111111111111111111111 << n3241;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3245 = n3234 ? n3243 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3247 = saved_addr_log & n3245;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3248 = n3234 ? n3247 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3253 = n3234 ? n3248 : n3240;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3254 = atc_fc[14:12]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3255 = n3254 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3256 = atc_is_insn[4]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3257 = n3256 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3258 = n3257 & n3255;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3259 = atc_log_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3260 = n3253 == n3259;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3261 = n3260 & n3258;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3263 = n3266 ? 1'b1 : n3212;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3265 = n3267 ? 3'b011 : n3214;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3266 = n3261 & n3218;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3267 = n3261 & n3218;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3269 = atc_valid[3]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3271 = atc_shift[19:15]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3272 = {27'b0, n3271};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3279 = $signed(n3272) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3281 = $signed(n3272) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3282 = n3279 | n3281;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3285 = n3282 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3291 = n3282 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3292 = {26'b0, n3271};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3294 = 32'b11111111111111111111111111111111 << n3292;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3296 = n3285 ? n3294 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3298 = saved_addr_log & n3296;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3299 = n3285 ? n3298 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3304 = n3285 ? n3299 : n3291;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3305 = atc_fc[11:9]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3306 = n3305 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3307 = atc_is_insn[3]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3308 = n3307 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3309 = n3308 & n3306;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3310 = atc_log_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3311 = n3304 == n3310;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3312 = n3311 & n3309;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3314 = n3317 ? 1'b1 : n3263;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3316 = n3318 ? 3'b100 : n3265;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3317 = n3312 & n3269;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3318 = n3312 & n3269;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3320 = atc_valid[2]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3322 = atc_shift[14:10]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3323 = {27'b0, n3322};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3330 = $signed(n3323) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3332 = $signed(n3323) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3333 = n3330 | n3332;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3336 = n3333 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3342 = n3333 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3343 = {26'b0, n3322};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3345 = 32'b11111111111111111111111111111111 << n3343;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3347 = n3336 ? n3345 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3349 = saved_addr_log & n3347;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3350 = n3336 ? n3349 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3355 = n3336 ? n3350 : n3342;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3356 = atc_fc[8:6]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3357 = n3356 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3358 = atc_is_insn[2]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3359 = n3358 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3360 = n3359 & n3357;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3361 = atc_log_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3362 = n3355 == n3361;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3363 = n3362 & n3360;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3365 = n3368 ? 1'b1 : n3314;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3367 = n3369 ? 3'b101 : n3316;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3368 = n3363 & n3320;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3369 = n3363 & n3320;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3371 = atc_valid[1]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3373 = atc_shift[9:5]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3374 = {27'b0, n3373};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3381 = $signed(n3374) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3383 = $signed(n3374) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3384 = n3381 | n3383;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3387 = n3384 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3393 = n3384 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3394 = {26'b0, n3373};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3396 = 32'b11111111111111111111111111111111 << n3394;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3398 = n3387 ? n3396 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3400 = saved_addr_log & n3398;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3401 = n3387 ? n3400 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3406 = n3387 ? n3401 : n3393;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3407 = atc_fc[5:3]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3408 = n3407 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3409 = atc_is_insn[1]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3410 = n3409 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3411 = n3410 & n3408;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3412 = atc_log_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3413 = n3406 == n3412;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3414 = n3413 & n3411;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3416 = n3419 ? 1'b1 : n3365;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3418 = n3420 ? 3'b110 : n3367;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3419 = n3414 & n3371;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3420 = n3414 & n3371;
  /* TG68K_PMMU_030.vhd:1550:25  */
  assign n3422 = atc_valid[0]; // extract
  /* TG68K_PMMU_030.vhd:1551:67  */
  assign n3424 = atc_shift[4:0]; // extract
  /* TG68K_PMMU_030.vhd:1551:58  */
  assign n3425 = {27'b0, n3424};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3432 = $signed(n3425) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3434 = $signed(n3425) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3435 = n3432 | n3434;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3438 = n3435 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3444 = n3435 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3445 = {26'b0, n3424};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3447 = 32'b11111111111111111111111111111111 << n3445;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3449 = n3438 ? n3447 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3451 = saved_addr_log & n3449;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3452 = n3438 ? n3451 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3457 = n3438 ? n3452 : n3444;
  /* TG68K_PMMU_030.vhd:1552:24  */
  assign n3458 = atc_fc[2:0]; // extract
  /* TG68K_PMMU_030.vhd:1552:28  */
  assign n3459 = n3458 == saved_fc;
  /* TG68K_PMMU_030.vhd:1553:29  */
  assign n3460 = atc_is_insn[0]; // extract
  /* TG68K_PMMU_030.vhd:1553:33  */
  assign n3461 = n3460 == saved_is_insn;
  /* TG68K_PMMU_030.vhd:1552:39  */
  assign n3462 = n3461 & n3459;
  /* TG68K_PMMU_030.vhd:1554:45  */
  assign n3463 = atc_log_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:1554:31  */
  assign n3464 = n3457 == n3463;
  /* TG68K_PMMU_030.vhd:1553:49  */
  assign n3465 = n3464 & n3462;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3467 = n3470 ? 1'b1 : n3416;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3469 = n3471 ? 3'b111 : n3418;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3470 = n3465 & n3422;
  /* TG68K_PMMU_030.vhd:1550:13  */
  assign n3471 = n3465 & n3422;
  /* TG68K_PMMU_030.vhd:1574:25  */
  assign n3473 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:1574:44  */
  assign n3475 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1574:31  */
  assign n3478 = n7785 & n3473;
  /* TG68K_PMMU_030.vhd:1592:51  */
  assign n3483 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1593:77  */
  assign n3487 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1593:53  */
  assign n3490 = saved_addr_log - n7787;
  /* TG68K_PMMU_030.vhd:1594:40  */
  assign n3491 = n7786 + n3490;
  /* TG68K_PMMU_030.vhd:1596:45  */
  assign n3493 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1600:27  */
  assign n3496 = saved_fc[2]; // extract
  /* TG68K_PMMU_030.vhd:1600:31  */
  assign n3497 = ~n3496;
  /* TG68K_PMMU_030.vhd:1600:50  */
  assign n3499 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1600:62  */
  assign n3502 = ~n7797;
  /* TG68K_PMMU_030.vhd:1600:37  */
  assign n3503 = n3502 & n3497;
  /* TG68K_PMMU_030.vhd:1608:43  */
  assign n3506 = 3'b111 - n3469;
  assign n3516 = n3515[31:16]; // extract
  assign n3522 = n3515[12]; // extract
  assign n3529 = n3515[8:7]; // extract
  assign n3532 = n3515[5:3]; // extract
  assign n3533 = {n3516, 1'b0, 1'b0, 1'b1, n3522, n7799, 1'b0, 1'b0, n3529, 1'b0, n3532, 3'b011};
  /* TG68K_PMMU_030.vhd:1619:51  */
  assign n3535 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1620:77  */
  assign n3539 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1620:53  */
  assign n3542 = saved_addr_log - n7801;
  /* TG68K_PMMU_030.vhd:1621:40  */
  assign n3543 = n7800 + n3542;
  /* TG68K_PMMU_030.vhd:1623:45  */
  assign n3545 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1624:45  */
  assign n3549 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1630:51  */
  assign n3553 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1631:77  */
  assign n3557 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1631:53  */
  assign n3560 = saved_addr_log - n7810;
  /* TG68K_PMMU_030.vhd:1632:40  */
  assign n3561 = n7809 + n3560;
  /* TG68K_PMMU_030.vhd:1634:45  */
  assign n3563 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1635:45  */
  assign n3567 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1639:43  */
  assign n3572 = 3'b111 - n3469;
  /* TG68K_PMMU_030.vhd:1640:38  */
  assign n3576 = 3'b111 - n3469;
  assign n3585 = n3584[31:12]; // extract
  assign n3591 = n3584[8:7]; // extract
  assign n3594 = n3584[5:3]; // extract
  assign n3595 = {n3585, n7819, 1'b0, n7824, n3591, 1'b0, n3594, 3'b011};
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3596 = n3503 ? n3543 : n3561;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3597 = n3503 ? n7806 : n7815;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3598 = n3503 ? n7808 : n7817;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3601 = n3503 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3602 = n3503 ? n3533 : n3595;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3604 = n3503 ? 1'b1 : n2076;
  /* TG68K_PMMU_030.vhd:1600:13  */
  assign n3605 = n3503 ? n3533 : n2077;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3610 = n3478 ? n3491 : n3596;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3611 = n3478 ? n7792 : n3597;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3613 = n3478 ? 1'b1 : n3598;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3615 = n3478 ? 1'b1 : n3601;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3616 = n3478 ? 32'b00000000000000000000100000000011 : n3602;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3618 = n3478 ? 1'b1 : n3604;
  /* TG68K_PMMU_030.vhd:1574:13  */
  assign n3619 = n3478 ? 32'b00000000000000000000100000000011 : n3605;
  /* TG68K_PMMU_030.vhd:1656:41  */
  assign n3625 = ~walker_fault_ack_pending;
  /* TG68K_PMMU_030.vhd:1656:13  */
  assign n3627 = n3625 ? 1'b0 : n1738;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3628 = n3467 ? n3610 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3630 = n3467 ? n3611 : 1'b1;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3632 = n3467 ? n3613 : 1'b0;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3633 = n3467 ? n3615 : n3627;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3634 = n3467 ? n3616 : n1739;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3635 = n3467 ? n3618 : n2076;
  /* TG68K_PMMU_030.vhd:1560:11  */
  assign n3636 = n3467 ? n3619 : n2077;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3641 = n3061 ? n1735 : n3628;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3642 = n3061 ? n1736 : n3630;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3643 = n3061 ? n1737 : n3632;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3644 = n3061 ? n1738 : n3633;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3645 = n3061 ? n1739 : n3634;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3647 = n3061 ? n2769 : 1'b0;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3648 = n3061 ? n2076 : n3635;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3649 = n3061 ? n2077 : n3636;
  /* TG68K_PMMU_030.vhd:1543:9  */
  assign n3651 = n3061 ? n2779 : n3469;
  /* TG68K_PMMU_030.vhd:1670:29  */
  assign n3657 = ~walker_completed;
  /* TG68K_PMMU_030.vhd:1670:9  */
  assign n3659 = n3657 ? 1'b0 : walker_completed_ack;
  /* TG68K_PMMU_030.vhd:1673:25  */
  assign n3660 = ~walker_fault;
  /* TG68K_PMMU_030.vhd:1673:31  */
  assign n3661 = walker_fault_ack_pending & n3660;
  /* TG68K_PMMU_030.vhd:1673:9  */
  assign n3663 = n3661 ? 1'b0 : walker_fault_ack;
  /* TG68K_PMMU_030.vhd:1673:9  */
  assign n3665 = n3661 ? 1'b0 : walker_fault_ack_pending;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3666 = walker_completed ? n3641 : n1735;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3667 = walker_completed ? n3642 : n1736;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3668 = walker_completed ? n3643 : n1737;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3669 = walker_completed ? n3644 : n1738;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3670 = walker_completed ? n3645 : n1739;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3671 = walker_completed ? walker_fault_ack : n3663;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3672 = walker_completed ? walker_fault_ack_pending : n3665;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3674 = walker_completed ? 1'b1 : n3659;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3675 = walker_completed ? n3647 : n2769;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3676 = walker_completed ? n3648 : n2076;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3677 = walker_completed ? n3649 : n2077;
  /* TG68K_PMMU_030.vhd:1535:7  */
  assign n3679 = walker_completed ? n3651 : n2779;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3691 = n2812 ? saved_addr_log : n3666;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3693 = n2812 ? 1'b1 : n3667;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3695 = n2812 ? 1'b1 : n3668;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3697 = n2812 ? 1'b1 : n3669;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3698 = n2812 ? walker_fault_status : n3670;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3700 = n2812 ? 1'b1 : n3671;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3702 = n2812 ? 1'b1 : n3672;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3703 = n2812 ? walker_completed_ack : n3674;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3705 = n2812 ? 1'b0 : n3675;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3707 = n2812 ? 1'b1 : n3676;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3708 = n2812 ? walker_fault_status : n3677;
  /* TG68K_PMMU_030.vhd:1513:7  */
  assign n3710 = n2812 ? n2779 : n3679;
  /* TG68K_PMMU_030.vhd:1681:17  */
  assign n3723 = wstate != 4'b0000;
  /* TG68K_PMMU_030.vhd:1681:7  */
  assign n3725 = n3723 ? 1'b0 : n2771;
  /* TG68K_PMMU_030.vhd:1143:3  */
  assign n3804 = ~n626;
  /* TG68K_PMMU_030.vhd:1172:5  */
  assign n3805 = n3804 ? n3710 : n611_hit_idx;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk)
    n3806 <= n3805;
  initial
    n3806 = 3'b000;
  /* TG68K_PMMU_030.vhd:1701:15  */
  assign n3853 = ~nreset;
  /* TG68K_PMMU_030.vhd:1746:33  */
  assign n3919 = walker_fault_ack & walker_fault;
  /* TG68K_PMMU_030.vhd:1746:11  */
  assign n3921 = n3919 ? 1'b0 : walker_fault;
  /* TG68K_PMMU_030.vhd:1767:32  */
  assign n3930 = {1'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:1769:59  */
  assign n3932 = {28'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n3939 = $signed(n3932) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n3941 = $signed(n3932) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n3942 = n3939 | n3941;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3945 = n3942 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n3951 = n3942 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n3952 = {27'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n3954 = 32'b11111111111111111111111111111111 << n3952;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n3956 = n3945 ? n3954 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n3958 = saved_addr_log & n3956;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n3959 = n3945 ? n3958 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n3964 = n3945 ? n3959 : n3951;
  /* TG68K_PMMU_030.vhd:1776:24  */
  assign n3965 = saved_fc[2]; // extract
  /* TG68K_PMMU_030.vhd:1776:34  */
  assign n3966 = tc_sre & n3965;
  /* TG68K_PMMU_030.vhd:1777:33  */
  assign n3967 = srp_l[31:4]; // extract
  /* TG68K_PMMU_030.vhd:1777:47  */
  assign n3969 = {n3967, 4'b0000};
  /* TG68K_PMMU_030.vhd:1780:33  */
  assign n3970 = crp_l[31:4]; // extract
  /* TG68K_PMMU_030.vhd:1780:47  */
  assign n3972 = {n3970, 4'b0000};
  /* TG68K_PMMU_030.vhd:1776:13  */
  assign n3974 = n3966 ? n3969 : n3972;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3976 = walk_req ? 1'b0 : n7740;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3978 = walk_req ? 4'b0001 : wstate;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3979 = walk_req ? n3964 : walk_log_base;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3981 = walk_req ? 32'b00000000000000000000000000000000 : walk_phys_base;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3982 = walk_req ? n3930 : walk_page_shift;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3985 = walk_req ? 3'b000 : walk_level;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3986 = walk_req ? n3974 : walk_addr;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3987 = walk_req ? saved_addr_log : walk_vpn;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3991 = walk_req ? 8'b00000000 : walk_attr;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3993 = walk_req ? 1'b0 : walk_supervisor;
  /* TG68K_PMMU_030.vhd:1751:11  */
  assign n3995 = walk_req ? 1'b0 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:1740:9  */
  assign n3999 = wstate == 4'b0000;
  /* TG68K_PMMU_030.vhd:590:26  */
  assign n4007 = walk_vpn[28:0]; // extract
  /* TG68K_PMMU_030.vhd:590:20  */
  assign n4008 = {saved_fc, n4007};
  /* TG68K_PMMU_030.vhd:589:5  */
  assign n4009 = tc_fcl ? n4008 : walk_vpn;
  /* TG68K_PMMU_030.vhd:1792:87  */
  assign n4011 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:1792:117  */
  assign n4013 = {28'b0, tc_page_size};  //  uext
  /* TG68K_PMMU_030.vhd:533:14  */
  assign n4024 = $signed(n4011) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:533:27  */
  assign n4026 = $signed(n4011) > $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:533:18  */
  assign n4027 = n4024 | n4026;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n4031 = n4027 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n4037 = n4027 ? 32'b00000000000000000000000000000000 : 32'bX;
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n4038 = walk_level[1:0];  // trunc
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n4040 = 2'b11 - n4038;
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n4043 = {27'b0, n7825};  //  uext
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n4045 = n4031 ? n4043 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:538:19  */
  assign n4048 = $signed(n4045) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4051 = n4058 ? 1'b0 : n4031;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4054 = n4060 ? 32'b00000000000000000000000000000000 : n4037;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4055 = n4031 & n4048;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4057 = n4031 & n4048;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4058 = n4055 & n4031;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4060 = n4057 & n4031;
  /* TG68K_PMMU_030.vhd:553:5  */
  assign n4062 = n4051 ? n4013 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:560:14  */
  assign n4065 = $signed(n4011) < $signed(32'b00000000000000000000000000000001);
  /* TG68K_PMMU_030.vhd:560:66  */
  assign n4066 = tc_idx_bits[14:10]; // extract
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n4067 = {27'b0, n4066};  //  uext
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n4068 = n4062 + n4067;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4069 = n4071 ? n4068 : n4062;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4070 = n4051 & n4065;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4071 = n4070 & n4051;
  /* TG68K_PMMU_030.vhd:561:14  */
  assign n4073 = $signed(n4011) < $signed(32'b00000000000000000000000000000010);
  /* TG68K_PMMU_030.vhd:561:66  */
  assign n4074 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n4075 = {27'b0, n4074};  //  uext
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n4076 = n4069 + n4075;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4077 = n4079 ? n4076 : n4069;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4078 = n4051 & n4073;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4079 = n4078 & n4051;
  /* TG68K_PMMU_030.vhd:562:14  */
  assign n4081 = $signed(n4011) < $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:562:66  */
  assign n4082 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n4083 = {27'b0, n4082};  //  uext
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n4084 = n4077 + n4083;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4085 = n4087 ? n4084 : n4077;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4086 = n4051 & n4081;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4087 = n4086 & n4051;
  /* TG68K_PMMU_030.vhd:565:5  */
  assign n4089 = n4051 ? n4085 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:568:21  */
  assign n4092 = $signed(n4089) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:568:41  */
  assign n4094 = $signed(n4089) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:568:25  */
  assign n4095 = n4092 | n4094;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4098 = n4105 ? 1'b0 : n4051;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4101 = n4107 ? 32'b00000000000000000000000000000000 : n4054;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4102 = n4051 & n4095;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4104 = n4051 & n4095;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4105 = n4102 & n4051;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4107 = n4104 & n4051;
  /* TG68K_PMMU_030.vhd:573:5  */
  assign n4109 = n4098 ? n4009 : 32'bX;
  /* TG68K_PMMU_030.vhd:574:41  */
  assign n4111 = n4089[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:574:18  */
  assign n4112 = n4109 >> n4111;
  /* TG68K_PMMU_030.vhd:574:5  */
  assign n4113 = n4098 ? n4112 : n4109;
  /* TG68K_PMMU_030.vhd:575:54  */
  assign n4115 = 32'b00000000000000000000000000000001 << n4045;
  /* TG68K_PMMU_030.vhd:575:68  */
  assign n4117 = n4115 - 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:575:52  */
  assign n4118 = n4117[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:40  */
  assign n4119 = {1'b0, n4118};  //  uext
  /* TG68K_PMMU_030.vhd:575:36  */
  assign n4120 = n4113 & n4119;
  /* TG68K_PMMU_030.vhd:575:15  */
  assign n4121 = n4120[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n4122 = {1'b0, n4121};  //  uext
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n4124 = n4098 ? n4122 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:577:5  */
  assign n4130 = n4098 ? n4124 : n4101;
  /* TG68K_PMMU_030.vhd:1797:22  */
  assign n4131 = saved_fc[2]; // extract
  /* TG68K_PMMU_030.vhd:1797:32  */
  assign n4132 = tc_sre & n4131;
  /* TG68K_PMMU_030.vhd:1797:11  */
  assign n4133 = n4132 ? srp_h : crp_h;
  /* TG68K_PMMU_030.vhd:1804:29  */
  assign n4134 = n4133[31]; // extract
  /* TG68K_PMMU_030.vhd:1805:42  */
  assign n4135 = n4133[30:16]; // extract
  /* TG68K_PMMU_030.vhd:1810:28  */
  assign n4136 = n4130[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:1810:16  */
  assign n4137 = n4136[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:1810:45  */
  assign n4138 = $unsigned(n4137) < $unsigned(n4135);
  assign n4148 = n4147[31:16]; // extract
  assign n4155 = n4147[12]; // extract
  assign n4162 = n4147[8:7]; // extract
  assign n4164 = n4147[5:3]; // extract
  assign n4165 = {n4148, 1'b0, 1'b1, 1'b0, n4155, 1'b0, 1'b0, 1'b0, n4162, 1'b0, n4164, walk_level};
  /* TG68K_PMMU_030.vhd:1810:13  */
  assign n4167 = n4138 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:1810:13  */
  assign n4168 = n4138 ? n4165 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:1810:13  */
  assign n4170 = n4138 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:1830:28  */
  assign n4171 = n4130[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:1830:16  */
  assign n4172 = n4171[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:1830:45  */
  assign n4173 = $unsigned(n4172) > $unsigned(n4135);
  assign n4183 = n4182[31:16]; // extract
  assign n4190 = n4182[12]; // extract
  assign n4197 = n4182[8:7]; // extract
  assign n4199 = n4182[5:3]; // extract
  assign n4200 = {n4183, 1'b0, 1'b1, 1'b0, n4190, 1'b0, 1'b0, 1'b0, n4197, 1'b0, n4199, walk_level};
  /* TG68K_PMMU_030.vhd:1830:13  */
  assign n4202 = n4173 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:1830:13  */
  assign n4203 = n4173 ? n4200 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:1830:13  */
  assign n4205 = n4173 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:1808:11  */
  assign n4206 = n4134 ? n4167 : n4202;
  /* TG68K_PMMU_030.vhd:1808:11  */
  assign n4207 = n4134 ? n4168 : n4203;
  /* TG68K_PMMU_030.vhd:1808:11  */
  assign n4208 = n4134 ? n4170 : n4205;
  /* TG68K_PMMU_030.vhd:1850:35  */
  assign n4209 = walk_addr[31:4]; // extract
  /* TG68K_PMMU_030.vhd:1850:49  */
  assign n4211 = {n4209, 4'b0000};
  /* TG68K_PMMU_030.vhd:1851:91  */
  assign n4213 = $signed(n4130) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_PMMU_030.vhd:1851:79  */
  assign n4214 = n4213[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:1851:67  */
  assign n4215 = {1'b0, n4214};  //  uext
  /* TG68K_PMMU_030.vhd:1851:65  */
  assign n4216 = n4211 + n4215;
  /* TG68K_PMMU_030.vhd:1863:22  */
  assign n4225 = ~n7739;
  assign n4235 = n4234[31:16]; // extract
  assign n4242 = n4234[12]; // extract
  assign n4249 = n4234[8:7]; // extract
  assign n4251 = n4234[5:3]; // extract
  assign n4252 = {n4235, 1'b1, 1'b0, 1'b0, n4242, 1'b0, 1'b0, 1'b0, n4249, 1'b0, n4251, walk_level};
  /* TG68K_PMMU_030.vhd:1896:24  */
  assign n4261 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:1896:37  */
  assign n4263 = n4261 == 2'b00;
  assign n4275 = n4274[31:16]; // extract
  assign n4282 = n4274[12]; // extract
  assign n4289 = n4274[8:7]; // extract
  assign n4291 = n4274[5:3]; // extract
  assign n4292 = {n4275, 1'b0, 1'b0, 1'b0, n4282, 1'b0, 1'b1, 1'b0, n4289, 1'b0, n4291, walk_level};
  /* TG68K_PMMU_030.vhd:620:16  */
  assign n4298 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:620:29  */
  assign n4300 = n4298 == 2'b11;
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n4306 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n4308 = n4306 == 2'b01;
  /* TG68K_PMMU_030.vhd:1937:36  */
  assign n4313 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:1937:50  */
  assign n4315 = {n4313, 4'b0000};
  /* TG68K_PMMU_030.vhd:1938:40  */
  assign n4316 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:1938:40  */
  assign n4318 = n4316 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:1938:29  */
  assign n4319 = n4318[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:1924:13  */
  assign n4322 = n4308 ? 4'b1011 : 4'b0011;
  /* TG68K_PMMU_030.vhd:1924:13  */
  assign n4323 = n4308 ? walk_level : n4319;
  /* TG68K_PMMU_030.vhd:1924:13  */
  assign n4324 = n4308 ? walk_addr : n4315;
  /* TG68K_PMMU_030.vhd:1924:13  */
  assign n4326 = n4308 ? walk_limit_valid : 1'b0;
  /* TG68K_PMMU_030.vhd:1919:13  */
  assign n4328 = n4300 ? 4'b0010 : n4322;
  /* TG68K_PMMU_030.vhd:1919:13  */
  assign n4329 = n4300 ? walk_level : n4323;
  /* TG68K_PMMU_030.vhd:1919:13  */
  assign n4332 = n4300 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:1919:13  */
  assign n4333 = n4300 ? walk_addr : n4324;
  /* TG68K_PMMU_030.vhd:1919:13  */
  assign n4334 = n4300 ? walk_limit_valid : n4326;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4336 = n4349 ? 1'b1 : n4206;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4337 = n4350 ? n4292 : n4207;
  /* TG68K_PMMU_030.vhd:1896:13  */
  assign n4339 = n4263 ? 4'b1111 : n4328;
  /* TG68K_PMMU_030.vhd:1896:13  */
  assign n4340 = n4263 ? walk_level : n4329;
  /* TG68K_PMMU_030.vhd:1896:13  */
  assign n4342 = n4263 ? 1'b0 : n4332;
  /* TG68K_PMMU_030.vhd:1896:13  */
  assign n4343 = n4263 ? walk_addr : n4333;
  /* TG68K_PMMU_030.vhd:1896:13  */
  assign n4346 = n4263 ? walk_limit_valid : n4334;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4348 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4349 = n4263 & mem_ack;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4350 = n4263 & mem_ack;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4351 = mem_ack ? n4339 : n4208;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4352 = mem_ack ? n4340 : walk_level;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4353 = mem_ack ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4354 = mem_ack ? mem_rdat : walk_desc_high;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4355 = mem_ack ? n4342 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4356 = mem_ack ? n4343 : walk_addr;
  /* TG68K_PMMU_030.vhd:1883:11  */
  assign n4358 = mem_ack ? n4346 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4360 = mem_berr ? 1'b0 : n4348;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4362 = mem_berr ? 1'b1 : n4336;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4363 = mem_berr ? n4252 : n4337;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4365 = mem_berr ? 4'b1111 : n4351;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4366 = mem_berr ? walk_level : n4352;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4367 = mem_berr ? walk_desc : n4353;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4368 = mem_berr ? walk_desc_high : n4354;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4369 = mem_berr ? walk_desc_is_long : n4355;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4370 = mem_berr ? walk_addr : n4356;
  /* TG68K_PMMU_030.vhd:1867:11  */
  assign n4373 = mem_berr ? walk_limit_valid : n4358;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4375 = n4225 ? 1'b1 : n4360;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4376 = n4225 ? n4216 : n7741;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4377 = n4225 ? n4216 : desc_addr_reg;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4378 = n4225 ? n4206 : n4362;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4379 = n4225 ? n4207 : n4363;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4380 = n4225 ? n4208 : n4365;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4381 = n4225 ? walk_level : n4366;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4382 = n4225 ? walk_desc : n4367;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4383 = n4225 ? walk_desc_high : n4368;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4384 = n4225 ? walk_desc_is_long : n4369;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4385 = n4225 ? walk_addr : n4370;
  /* TG68K_PMMU_030.vhd:1863:11  */
  assign n4387 = n4225 ? walk_limit_valid : n4373;
  /* TG68K_PMMU_030.vhd:1790:9  */
  assign n4389 = wstate == 4'b0001;
  /* TG68K_PMMU_030.vhd:1948:22  */
  assign n4390 = ~n7739;
  /* TG68K_PMMU_030.vhd:1951:66  */
  assign n4392 = desc_addr_reg + 32'b00000000000000000000000000000100;
  assign n4402 = n4401[31:16]; // extract
  assign n4409 = n4401[12]; // extract
  assign n4416 = n4401[8:7]; // extract
  assign n4418 = n4401[5:3]; // extract
  assign n4419 = {n4402, 1'b1, 1'b0, 1'b0, n4409, 1'b0, 1'b0, 1'b0, n4416, 1'b0, n4418, walk_level};
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n4425 = walk_desc_high[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n4427 = n4425 == 2'b01;
  /* TG68K_PMMU_030.vhd:682:22  */
  assign n4433 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:682:36  */
  assign n4435 = {n4433, 4'b0000};
  /* TG68K_PMMU_030.vhd:1979:40  */
  assign n4436 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:1979:40  */
  assign n4438 = n4436 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:1979:29  */
  assign n4439 = n4438[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:1982:49  */
  assign n4440 = walk_desc_high[31]; // extract
  /* TG68K_PMMU_030.vhd:1983:58  */
  assign n4441 = walk_desc_high[30:16]; // extract
  /* TG68K_PMMU_030.vhd:1986:67  */
  assign n4442 = walk_desc_high[8]; // extract
  /* TG68K_PMMU_030.vhd:1986:50  */
  assign n4443 = walk_supervisor | n4442;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4446 = n4427 ? 4'b1011 : 4'b0011;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4447 = n4427 ? walk_level : n4439;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4448 = n4427 ? walk_addr : n4435;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4449 = n4427 ? walk_supervisor : n4443;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4451 = n4427 ? walk_limit_valid : 1'b1;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4452 = n4427 ? walk_limit_lu : n4440;
  /* TG68K_PMMU_030.vhd:1972:13  */
  assign n4453 = n4427 ? walk_limit_value : n4441;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4455 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4456 = mem_ack ? n4446 : wstate;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4457 = mem_ack ? n4447 : walk_level;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4458 = mem_ack ? mem_rdat : walk_desc_low;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4459 = mem_ack ? n4448 : walk_addr;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4460 = mem_ack ? n4449 : walk_supervisor;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4461 = mem_ack ? n4451 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4462 = mem_ack ? n4452 : walk_limit_lu;
  /* TG68K_PMMU_030.vhd:1964:11  */
  assign n4463 = mem_ack ? n4453 : walk_limit_value;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4465 = mem_berr ? 1'b0 : n4455;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4467 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4468 = mem_berr ? n4419 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4470 = mem_berr ? 4'b1111 : n4456;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4471 = mem_berr ? walk_level : n4457;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4472 = mem_berr ? walk_desc_low : n4458;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4473 = mem_berr ? walk_addr : n4459;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4476 = mem_berr ? walk_supervisor : n4460;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4477 = mem_berr ? walk_limit_valid : n4461;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4478 = mem_berr ? walk_limit_lu : n4462;
  /* TG68K_PMMU_030.vhd:1953:11  */
  assign n4479 = mem_berr ? walk_limit_value : n4463;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4481 = n4390 ? 1'b1 : n4465;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4482 = n4390 ? n4392 : n7741;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4483 = n4390 ? walker_fault : n4467;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4484 = n4390 ? walker_fault_status : n4468;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4485 = n4390 ? wstate : n4470;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4486 = n4390 ? walk_level : n4471;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4487 = n4390 ? walk_desc_low : n4472;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4488 = n4390 ? walk_addr : n4473;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4490 = n4390 ? walk_supervisor : n4476;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4491 = n4390 ? walk_limit_valid : n4477;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4492 = n4390 ? walk_limit_lu : n4478;
  /* TG68K_PMMU_030.vhd:1948:11  */
  assign n4493 = n4390 ? walk_limit_value : n4479;
  /* TG68K_PMMU_030.vhd:1945:9  */
  assign n4495 = wstate == 4'b0010;
  /* TG68K_PMMU_030.vhd:590:26  */
  assign n4503 = walk_vpn[28:0]; // extract
  /* TG68K_PMMU_030.vhd:590:20  */
  assign n4504 = {saved_fc, n4503};
  /* TG68K_PMMU_030.vhd:589:5  */
  assign n4505 = tc_fcl ? n4504 : walk_vpn;
  /* TG68K_PMMU_030.vhd:1994:87  */
  assign n4507 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:1994:117  */
  assign n4509 = {28'b0, tc_page_size};  //  uext
  /* TG68K_PMMU_030.vhd:533:14  */
  assign n4520 = $signed(n4507) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:533:27  */
  assign n4522 = $signed(n4507) > $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:533:18  */
  assign n4523 = n4520 | n4522;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n4527 = n4523 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n4533 = n4523 ? 32'b00000000000000000000000000000000 : 32'bX;
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n4534 = walk_level[1:0];  // trunc
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n4536 = 2'b11 - n4534;
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n4539 = {27'b0, n7826};  //  uext
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n4541 = n4527 ? n4539 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:538:19  */
  assign n4544 = $signed(n4541) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4547 = n4554 ? 1'b0 : n4527;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4550 = n4556 ? 32'b00000000000000000000000000000000 : n4533;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4551 = n4527 & n4544;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4553 = n4527 & n4544;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4554 = n4551 & n4527;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n4556 = n4553 & n4527;
  /* TG68K_PMMU_030.vhd:553:5  */
  assign n4558 = n4547 ? n4509 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:560:14  */
  assign n4561 = $signed(n4507) < $signed(32'b00000000000000000000000000000001);
  /* TG68K_PMMU_030.vhd:560:66  */
  assign n4562 = tc_idx_bits[14:10]; // extract
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n4563 = {27'b0, n4562};  //  uext
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n4564 = n4558 + n4563;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4565 = n4567 ? n4564 : n4558;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4566 = n4547 & n4561;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n4567 = n4566 & n4547;
  /* TG68K_PMMU_030.vhd:561:14  */
  assign n4569 = $signed(n4507) < $signed(32'b00000000000000000000000000000010);
  /* TG68K_PMMU_030.vhd:561:66  */
  assign n4570 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n4571 = {27'b0, n4570};  //  uext
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n4572 = n4565 + n4571;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4573 = n4575 ? n4572 : n4565;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4574 = n4547 & n4569;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n4575 = n4574 & n4547;
  /* TG68K_PMMU_030.vhd:562:14  */
  assign n4577 = $signed(n4507) < $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:562:66  */
  assign n4578 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n4579 = {27'b0, n4578};  //  uext
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n4580 = n4573 + n4579;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4581 = n4583 ? n4580 : n4573;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4582 = n4547 & n4577;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n4583 = n4582 & n4547;
  /* TG68K_PMMU_030.vhd:565:5  */
  assign n4585 = n4547 ? n4581 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:568:21  */
  assign n4588 = $signed(n4585) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:568:41  */
  assign n4590 = $signed(n4585) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:568:25  */
  assign n4591 = n4588 | n4590;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4594 = n4601 ? 1'b0 : n4547;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4597 = n4603 ? 32'b00000000000000000000000000000000 : n4550;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4598 = n4547 & n4591;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4600 = n4547 & n4591;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4601 = n4598 & n4547;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n4603 = n4600 & n4547;
  /* TG68K_PMMU_030.vhd:573:5  */
  assign n4605 = n4594 ? n4505 : 32'bX;
  /* TG68K_PMMU_030.vhd:574:41  */
  assign n4607 = n4585[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:574:18  */
  assign n4608 = n4605 >> n4607;
  /* TG68K_PMMU_030.vhd:574:5  */
  assign n4609 = n4594 ? n4608 : n4605;
  /* TG68K_PMMU_030.vhd:575:54  */
  assign n4611 = 32'b00000000000000000000000000000001 << n4541;
  /* TG68K_PMMU_030.vhd:575:68  */
  assign n4613 = n4611 - 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:575:52  */
  assign n4614 = n4613[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:40  */
  assign n4615 = {1'b0, n4614};  //  uext
  /* TG68K_PMMU_030.vhd:575:36  */
  assign n4616 = n4609 & n4615;
  /* TG68K_PMMU_030.vhd:575:15  */
  assign n4617 = n4616[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n4618 = {1'b0, n4617};  //  uext
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n4620 = n4594 ? n4618 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:577:5  */
  assign n4626 = n4594 ? n4620 : n4597;
  /* TG68K_PMMU_030.vhd:1995:35  */
  assign n4627 = walk_addr[31:4]; // extract
  /* TG68K_PMMU_030.vhd:1995:49  */
  assign n4629 = {n4627, 4'b0000};
  /* TG68K_PMMU_030.vhd:1996:91  */
  assign n4631 = $signed(n4626) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_PMMU_030.vhd:1996:79  */
  assign n4632 = n4631[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:1996:67  */
  assign n4633 = {1'b0, n4632};  //  uext
  /* TG68K_PMMU_030.vhd:1996:65  */
  assign n4634 = n4629 + n4633;
  /* TG68K_PMMU_030.vhd:1999:22  */
  assign n4635 = ~n7739;
  /* TG68K_PMMU_030.vhd:2004:32  */
  assign n4636 = n4626[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2004:20  */
  assign n4637 = n4636[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2004:49  */
  assign n4638 = $unsigned(n4637) < $unsigned(walk_limit_value);
  assign n4648 = n4647[31:16]; // extract
  assign n4655 = n4647[12]; // extract
  assign n4662 = n4647[8:7]; // extract
  assign n4664 = n4647[5:3]; // extract
  assign n4665 = {n4648, 1'b0, 1'b1, 1'b0, n4655, 1'b0, 1'b0, 1'b0, n4662, 1'b0, n4664, walk_level};
  /* TG68K_PMMU_030.vhd:2004:17  */
  assign n4667 = n4638 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2004:17  */
  assign n4668 = n4638 ? n4665 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2004:17  */
  assign n4670 = n4638 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2015:32  */
  assign n4671 = n4626[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2015:20  */
  assign n4672 = n4671[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2015:49  */
  assign n4673 = $unsigned(n4672) > $unsigned(walk_limit_value);
  assign n4683 = n4682[31:16]; // extract
  assign n4690 = n4682[12]; // extract
  assign n4697 = n4682[8:7]; // extract
  assign n4699 = n4682[5:3]; // extract
  assign n4700 = {n4683, 1'b0, 1'b1, 1'b0, n4690, 1'b0, 1'b0, 1'b0, n4697, 1'b0, n4699, walk_level};
  /* TG68K_PMMU_030.vhd:2015:17  */
  assign n4702 = n4673 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2015:17  */
  assign n4703 = n4673 ? n4700 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2015:17  */
  assign n4705 = n4673 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2002:15  */
  assign n4706 = walk_limit_lu ? n4667 : n4702;
  /* TG68K_PMMU_030.vhd:2002:15  */
  assign n4707 = walk_limit_lu ? n4668 : n4703;
  /* TG68K_PMMU_030.vhd:2002:15  */
  assign n4708 = walk_limit_lu ? n4670 : n4705;
  /* TG68K_PMMU_030.vhd:2001:13  */
  assign n4709 = walk_limit_valid ? n4706 : walker_fault;
  /* TG68K_PMMU_030.vhd:2001:13  */
  assign n4710 = walk_limit_valid ? n4707 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2001:13  */
  assign n4711 = walk_limit_valid ? n4708 : wstate;
  /* TG68K_PMMU_030.vhd:2027:23  */
  assign n4713 = wstate == 4'b0011;
  /* TG68K_PMMU_030.vhd:2027:13  */
  assign n4720 = n4713 ? 1'b1 : n7739;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4721 = n4890 ? n4634 : n7741;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4722 = n4891 ? n4634 : desc_addr_reg;
  assign n4732 = n4731[31:16]; // extract
  assign n4739 = n4731[12]; // extract
  assign n4746 = n4731[8:7]; // extract
  assign n4748 = n4731[5:3]; // extract
  assign n4749 = {n4732, 1'b1, 1'b0, 1'b0, n4739, 1'b0, 1'b0, 1'b0, n4746, 1'b0, n4748, walk_level};
  /* TG68K_PMMU_030.vhd:2060:24  */
  assign n4755 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:2060:37  */
  assign n4757 = n4755 == 2'b00;
  assign n4767 = n4766[31:16]; // extract
  assign n4774 = n4766[12]; // extract
  assign n4781 = n4766[8:7]; // extract
  assign n4783 = n4766[5:3]; // extract
  assign n4784 = {n4767, 1'b0, 1'b0, 1'b0, n4774, 1'b0, 1'b1, 1'b0, n4781, 1'b0, n4783, walk_level};
  /* TG68K_PMMU_030.vhd:620:16  */
  assign n4792 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:620:29  */
  assign n4794 = n4792 == 2'b11;
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n4800 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n4802 = n4800 == 2'b01;
  /* TG68K_PMMU_030.vhd:2096:30  */
  assign n4803 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:2096:34  */
  assign n4804 = {27'b0, n4803};  //  uext
  /* TG68K_PMMU_030.vhd:2096:34  */
  assign n4806 = n4804 == 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2100:40  */
  assign n4807 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2100:54  */
  assign n4809 = {n4807, 2'b00};
  /* TG68K_PMMU_030.vhd:2107:36  */
  assign n4810 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:2107:50  */
  assign n4812 = {n4810, 4'b0000};
  /* TG68K_PMMU_030.vhd:2108:40  */
  assign n4813 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2108:40  */
  assign n4815 = n4813 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:2108:29  */
  assign n4816 = n4815[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4819 = n4806 ? 4'b1001 : 4'b0101;
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4820 = n4806 ? walk_level : n4816;
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4821 = n4806 ? walk_addr : n4812;
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4822 = n4806 ? n4809 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4824 = n4806 ? 1'b0 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2096:13  */
  assign n4826 = n4806 ? walk_limit_valid : 1'b0;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4828 = n4802 ? 4'b1011 : n4819;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4829 = n4802 ? walk_level : n4820;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4830 = n4802 ? walk_addr : n4821;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4831 = n4802 ? indirect_addr : n4822;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4832 = n4802 ? indirect_target_long : n4824;
  /* TG68K_PMMU_030.vhd:2092:13  */
  assign n4833 = n4802 ? walk_limit_valid : n4826;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4835 = n4794 ? 4'b0100 : n4828;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4836 = n4794 ? walk_level : n4829;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4839 = n4794 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4840 = n4794 ? walk_addr : n4830;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4841 = n4794 ? indirect_addr : n4831;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4842 = n4794 ? indirect_target_long : n4832;
  /* TG68K_PMMU_030.vhd:2087:13  */
  assign n4843 = n4794 ? walk_limit_valid : n4833;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4845 = n4860 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4846 = n4861 ? n4784 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4848 = n4757 ? 4'b1111 : n4835;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4849 = n4757 ? walk_level : n4836;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4851 = n4757 ? 1'b0 : n4839;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4852 = n4757 ? walk_addr : n4840;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4855 = n4757 ? indirect_addr : n4841;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4856 = n4757 ? indirect_target_long : n4842;
  /* TG68K_PMMU_030.vhd:2060:13  */
  assign n4857 = n4757 ? walk_limit_valid : n4843;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4859 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4860 = n4757 & mem_ack;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4861 = n4757 & mem_ack;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4862 = mem_ack ? n4848 : wstate;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4863 = mem_ack ? n4849 : walk_level;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4864 = mem_ack ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4865 = mem_ack ? mem_rdat : walk_desc_high;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4866 = mem_ack ? n4851 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4867 = mem_ack ? n4852 : walk_addr;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4869 = mem_ack ? n4855 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4870 = mem_ack ? n4856 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2047:11  */
  assign n4871 = mem_ack ? n4857 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4873 = mem_berr ? 1'b0 : n4859;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4875 = mem_berr ? 1'b1 : n4845;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4876 = mem_berr ? n4749 : n4846;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4878 = mem_berr ? 4'b1111 : n4862;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4879 = mem_berr ? walk_level : n4863;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4880 = mem_berr ? walk_desc : n4864;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4881 = mem_berr ? walk_desc_high : n4865;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4882 = mem_berr ? walk_desc_is_long : n4866;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4883 = mem_berr ? walk_addr : n4867;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4886 = mem_berr ? indirect_addr : n4869;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4887 = mem_berr ? indirect_target_long : n4870;
  /* TG68K_PMMU_030.vhd:2036:11  */
  assign n4888 = mem_berr ? walk_limit_valid : n4871;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4889 = n4635 ? n4720 : n4873;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4890 = n4713 & n4635;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4891 = n4713 & n4635;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4892 = n4635 ? n4709 : n4875;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4893 = n4635 ? n4710 : n4876;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4894 = n4635 ? n4711 : n4878;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4895 = n4635 ? walk_level : n4879;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4896 = n4635 ? walk_desc : n4880;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4897 = n4635 ? walk_desc_high : n4881;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4898 = n4635 ? walk_desc_is_long : n4882;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4899 = n4635 ? walk_addr : n4883;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4901 = n4635 ? indirect_addr : n4886;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4902 = n4635 ? indirect_target_long : n4887;
  /* TG68K_PMMU_030.vhd:1999:11  */
  assign n4903 = n4635 ? walk_limit_valid : n4888;
  /* TG68K_PMMU_030.vhd:1992:9  */
  assign n4905 = wstate == 4'b0011;
  /* TG68K_PMMU_030.vhd:2117:22  */
  assign n4906 = ~n7739;
  /* TG68K_PMMU_030.vhd:2119:66  */
  assign n4908 = desc_addr_reg + 32'b00000000000000000000000000000100;
  assign n4918 = n4917[31:16]; // extract
  assign n4925 = n4917[12]; // extract
  assign n4932 = n4917[8:7]; // extract
  assign n4934 = n4917[5:3]; // extract
  assign n4935 = {n4918, 1'b1, 1'b0, 1'b0, n4925, 1'b0, 1'b0, 1'b0, n4932, 1'b0, n4934, walk_level};
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n4941 = walk_desc_high[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n4943 = n4941 == 2'b01;
  /* TG68K_PMMU_030.vhd:2142:30  */
  assign n4944 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:2142:34  */
  assign n4945 = {27'b0, n4944};  //  uext
  /* TG68K_PMMU_030.vhd:2142:34  */
  assign n4947 = n4945 == 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2146:40  */
  assign n4948 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2146:54  */
  assign n4950 = {n4948, 2'b00};
  /* TG68K_PMMU_030.vhd:682:22  */
  assign n4956 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:682:36  */
  assign n4958 = {n4956, 4'b0000};
  /* TG68K_PMMU_030.vhd:2153:40  */
  assign n4959 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2153:40  */
  assign n4961 = n4959 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:2153:29  */
  assign n4962 = n4961[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:2156:49  */
  assign n4963 = walk_desc_high[31]; // extract
  /* TG68K_PMMU_030.vhd:2157:58  */
  assign n4964 = walk_desc_high[30:16]; // extract
  /* TG68K_PMMU_030.vhd:2159:67  */
  assign n4965 = walk_desc_high[8]; // extract
  /* TG68K_PMMU_030.vhd:2159:50  */
  assign n4966 = walk_supervisor | n4965;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4969 = n4947 ? 4'b1001 : 4'b0101;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4970 = n4947 ? walk_level : n4962;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4971 = n4947 ? walk_addr : n4958;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4972 = n4947 ? walk_supervisor : n4966;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4973 = n4947 ? n4950 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4975 = n4947 ? 1'b1 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4977 = n4947 ? walk_limit_valid : 1'b1;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4978 = n4947 ? walk_limit_lu : n4963;
  /* TG68K_PMMU_030.vhd:2142:13  */
  assign n4979 = n4947 ? walk_limit_value : n4964;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4981 = n4943 ? 4'b1011 : n4969;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4982 = n4943 ? walk_level : n4970;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4983 = n4943 ? walk_addr : n4971;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4984 = n4943 ? walk_supervisor : n4972;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4985 = n4943 ? indirect_addr : n4973;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4986 = n4943 ? indirect_target_long : n4975;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4987 = n4943 ? walk_limit_valid : n4977;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4988 = n4943 ? walk_limit_lu : n4978;
  /* TG68K_PMMU_030.vhd:2138:13  */
  assign n4989 = n4943 ? walk_limit_value : n4979;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4991 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4992 = mem_ack ? n4981 : wstate;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4993 = mem_ack ? n4982 : walk_level;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4994 = mem_ack ? mem_rdat : walk_desc_low;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4995 = mem_ack ? n4983 : walk_addr;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4996 = mem_ack ? n4984 : walk_supervisor;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4997 = mem_ack ? n4985 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4998 = mem_ack ? n4986 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n4999 = mem_ack ? n4987 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n5000 = mem_ack ? n4988 : walk_limit_lu;
  /* TG68K_PMMU_030.vhd:2131:11  */
  assign n5001 = mem_ack ? n4989 : walk_limit_value;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5003 = mem_berr ? 1'b0 : n4991;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5005 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5006 = mem_berr ? n4935 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5008 = mem_berr ? 4'b1111 : n4992;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5009 = mem_berr ? walk_level : n4993;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5010 = mem_berr ? walk_desc_low : n4994;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5011 = mem_berr ? walk_addr : n4995;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5014 = mem_berr ? walk_supervisor : n4996;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5015 = mem_berr ? indirect_addr : n4997;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5016 = mem_berr ? indirect_target_long : n4998;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5017 = mem_berr ? walk_limit_valid : n4999;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5018 = mem_berr ? walk_limit_lu : n5000;
  /* TG68K_PMMU_030.vhd:2121:11  */
  assign n5019 = mem_berr ? walk_limit_value : n5001;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5021 = n4906 ? 1'b1 : n5003;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5022 = n4906 ? n4908 : n7741;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5023 = n4906 ? walker_fault : n5005;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5024 = n4906 ? walker_fault_status : n5006;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5025 = n4906 ? wstate : n5008;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5026 = n4906 ? walk_level : n5009;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5027 = n4906 ? walk_desc_low : n5010;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5028 = n4906 ? walk_addr : n5011;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5030 = n4906 ? walk_supervisor : n5014;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5031 = n4906 ? indirect_addr : n5015;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5032 = n4906 ? indirect_target_long : n5016;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5033 = n4906 ? walk_limit_valid : n5017;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5034 = n4906 ? walk_limit_lu : n5018;
  /* TG68K_PMMU_030.vhd:2117:11  */
  assign n5035 = n4906 ? walk_limit_value : n5019;
  /* TG68K_PMMU_030.vhd:2115:9  */
  assign n5037 = wstate == 4'b0100;
  /* TG68K_PMMU_030.vhd:590:26  */
  assign n5045 = walk_vpn[28:0]; // extract
  /* TG68K_PMMU_030.vhd:590:20  */
  assign n5046 = {saved_fc, n5045};
  /* TG68K_PMMU_030.vhd:589:5  */
  assign n5047 = tc_fcl ? n5046 : walk_vpn;
  /* TG68K_PMMU_030.vhd:2167:87  */
  assign n5049 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2167:117  */
  assign n5051 = {28'b0, tc_page_size};  //  uext
  /* TG68K_PMMU_030.vhd:533:14  */
  assign n5062 = $signed(n5049) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:533:27  */
  assign n5064 = $signed(n5049) > $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:533:18  */
  assign n5065 = n5062 | n5064;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n5069 = n5065 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n5075 = n5065 ? 32'b00000000000000000000000000000000 : 32'bX;
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n5076 = walk_level[1:0];  // trunc
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n5078 = 2'b11 - n5076;
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n5081 = {27'b0, n7827};  //  uext
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n5083 = n5069 ? n5081 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:538:19  */
  assign n5086 = $signed(n5083) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5089 = n5096 ? 1'b0 : n5069;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5092 = n5098 ? 32'b00000000000000000000000000000000 : n5075;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5093 = n5069 & n5086;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5095 = n5069 & n5086;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5096 = n5093 & n5069;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5098 = n5095 & n5069;
  /* TG68K_PMMU_030.vhd:553:5  */
  assign n5100 = n5089 ? n5051 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:560:14  */
  assign n5103 = $signed(n5049) < $signed(32'b00000000000000000000000000000001);
  /* TG68K_PMMU_030.vhd:560:66  */
  assign n5104 = tc_idx_bits[14:10]; // extract
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n5105 = {27'b0, n5104};  //  uext
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n5106 = n5100 + n5105;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5107 = n5109 ? n5106 : n5100;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5108 = n5089 & n5103;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5109 = n5108 & n5089;
  /* TG68K_PMMU_030.vhd:561:14  */
  assign n5111 = $signed(n5049) < $signed(32'b00000000000000000000000000000010);
  /* TG68K_PMMU_030.vhd:561:66  */
  assign n5112 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n5113 = {27'b0, n5112};  //  uext
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n5114 = n5107 + n5113;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5115 = n5117 ? n5114 : n5107;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5116 = n5089 & n5111;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5117 = n5116 & n5089;
  /* TG68K_PMMU_030.vhd:562:14  */
  assign n5119 = $signed(n5049) < $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:562:66  */
  assign n5120 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n5121 = {27'b0, n5120};  //  uext
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n5122 = n5115 + n5121;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5123 = n5125 ? n5122 : n5115;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5124 = n5089 & n5119;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5125 = n5124 & n5089;
  /* TG68K_PMMU_030.vhd:565:5  */
  assign n5127 = n5089 ? n5123 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:568:21  */
  assign n5130 = $signed(n5127) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:568:41  */
  assign n5132 = $signed(n5127) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:568:25  */
  assign n5133 = n5130 | n5132;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5136 = n5143 ? 1'b0 : n5089;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5139 = n5145 ? 32'b00000000000000000000000000000000 : n5092;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5140 = n5089 & n5133;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5142 = n5089 & n5133;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5143 = n5140 & n5089;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5145 = n5142 & n5089;
  /* TG68K_PMMU_030.vhd:573:5  */
  assign n5147 = n5136 ? n5047 : 32'bX;
  /* TG68K_PMMU_030.vhd:574:41  */
  assign n5149 = n5127[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:574:18  */
  assign n5150 = n5147 >> n5149;
  /* TG68K_PMMU_030.vhd:574:5  */
  assign n5151 = n5136 ? n5150 : n5147;
  /* TG68K_PMMU_030.vhd:575:54  */
  assign n5153 = 32'b00000000000000000000000000000001 << n5083;
  /* TG68K_PMMU_030.vhd:575:68  */
  assign n5155 = n5153 - 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:575:52  */
  assign n5156 = n5155[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:40  */
  assign n5157 = {1'b0, n5156};  //  uext
  /* TG68K_PMMU_030.vhd:575:36  */
  assign n5158 = n5151 & n5157;
  /* TG68K_PMMU_030.vhd:575:15  */
  assign n5159 = n5158[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n5160 = {1'b0, n5159};  //  uext
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n5162 = n5136 ? n5160 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:577:5  */
  assign n5168 = n5136 ? n5162 : n5139;
  /* TG68K_PMMU_030.vhd:2168:35  */
  assign n5169 = walk_addr[31:4]; // extract
  /* TG68K_PMMU_030.vhd:2168:49  */
  assign n5171 = {n5169, 4'b0000};
  /* TG68K_PMMU_030.vhd:2169:91  */
  assign n5173 = $signed(n5168) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_PMMU_030.vhd:2169:79  */
  assign n5174 = n5173[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2169:67  */
  assign n5175 = {1'b0, n5174};  //  uext
  /* TG68K_PMMU_030.vhd:2169:65  */
  assign n5176 = n5171 + n5175;
  /* TG68K_PMMU_030.vhd:2172:22  */
  assign n5177 = ~n7739;
  /* TG68K_PMMU_030.vhd:2177:32  */
  assign n5178 = n5168[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2177:20  */
  assign n5179 = n5178[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2177:49  */
  assign n5180 = $unsigned(n5179) < $unsigned(walk_limit_value);
  assign n5190 = n5189[31:16]; // extract
  assign n5197 = n5189[12]; // extract
  assign n5204 = n5189[8:7]; // extract
  assign n5206 = n5189[5:3]; // extract
  assign n5207 = {n5190, 1'b0, 1'b1, 1'b0, n5197, 1'b0, 1'b0, 1'b0, n5204, 1'b0, n5206, walk_level};
  /* TG68K_PMMU_030.vhd:2177:17  */
  assign n5209 = n5180 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2177:17  */
  assign n5210 = n5180 ? n5207 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2177:17  */
  assign n5212 = n5180 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2188:32  */
  assign n5213 = n5168[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2188:20  */
  assign n5214 = n5213[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2188:49  */
  assign n5215 = $unsigned(n5214) > $unsigned(walk_limit_value);
  assign n5225 = n5224[31:16]; // extract
  assign n5232 = n5224[12]; // extract
  assign n5239 = n5224[8:7]; // extract
  assign n5241 = n5224[5:3]; // extract
  assign n5242 = {n5225, 1'b0, 1'b1, 1'b0, n5232, 1'b0, 1'b0, 1'b0, n5239, 1'b0, n5241, walk_level};
  /* TG68K_PMMU_030.vhd:2188:17  */
  assign n5244 = n5215 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2188:17  */
  assign n5245 = n5215 ? n5242 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2188:17  */
  assign n5247 = n5215 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2175:15  */
  assign n5248 = walk_limit_lu ? n5209 : n5244;
  /* TG68K_PMMU_030.vhd:2175:15  */
  assign n5249 = walk_limit_lu ? n5210 : n5245;
  /* TG68K_PMMU_030.vhd:2175:15  */
  assign n5250 = walk_limit_lu ? n5212 : n5247;
  /* TG68K_PMMU_030.vhd:2174:13  */
  assign n5251 = walk_limit_valid ? n5248 : walker_fault;
  /* TG68K_PMMU_030.vhd:2174:13  */
  assign n5252 = walk_limit_valid ? n5249 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2174:13  */
  assign n5253 = walk_limit_valid ? n5250 : wstate;
  /* TG68K_PMMU_030.vhd:2200:23  */
  assign n5255 = wstate == 4'b0101;
  /* TG68K_PMMU_030.vhd:2200:13  */
  assign n5264 = n5255 ? 1'b1 : n7739;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5265 = n5434 ? n5176 : n7741;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5266 = n5435 ? n5176 : desc_addr_reg;
  assign n5276 = n5275[31:16]; // extract
  assign n5283 = n5275[12]; // extract
  assign n5290 = n5275[8:7]; // extract
  assign n5292 = n5275[5:3]; // extract
  assign n5293 = {n5276, 1'b1, 1'b0, 1'b0, n5283, 1'b0, 1'b0, 1'b0, n5290, 1'b0, n5292, walk_level};
  /* TG68K_PMMU_030.vhd:2240:24  */
  assign n5299 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:2240:37  */
  assign n5301 = n5299 == 2'b00;
  assign n5311 = n5310[31:16]; // extract
  assign n5318 = n5310[12]; // extract
  assign n5325 = n5310[8:7]; // extract
  assign n5327 = n5310[5:3]; // extract
  assign n5328 = {n5311, 1'b0, 1'b0, 1'b0, n5318, 1'b0, 1'b1, 1'b0, n5325, 1'b0, n5327, walk_level};
  /* TG68K_PMMU_030.vhd:620:16  */
  assign n5336 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:620:29  */
  assign n5338 = n5336 == 2'b11;
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n5344 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n5346 = n5344 == 2'b01;
  /* TG68K_PMMU_030.vhd:2276:30  */
  assign n5347 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:2276:34  */
  assign n5348 = {27'b0, n5347};  //  uext
  /* TG68K_PMMU_030.vhd:2276:34  */
  assign n5350 = n5348 == 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2280:40  */
  assign n5351 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2280:54  */
  assign n5353 = {n5351, 2'b00};
  /* TG68K_PMMU_030.vhd:2287:36  */
  assign n5354 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:2287:50  */
  assign n5356 = {n5354, 4'b0000};
  /* TG68K_PMMU_030.vhd:2288:40  */
  assign n5357 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2288:40  */
  assign n5359 = n5357 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:2288:29  */
  assign n5360 = n5359[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5363 = n5350 ? 4'b1001 : 4'b0111;
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5364 = n5350 ? walk_level : n5360;
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5365 = n5350 ? walk_addr : n5356;
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5366 = n5350 ? n5353 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5368 = n5350 ? 1'b0 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2276:13  */
  assign n5370 = n5350 ? walk_limit_valid : 1'b0;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5372 = n5346 ? 4'b1011 : n5363;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5373 = n5346 ? walk_level : n5364;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5374 = n5346 ? walk_addr : n5365;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5375 = n5346 ? indirect_addr : n5366;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5376 = n5346 ? indirect_target_long : n5368;
  /* TG68K_PMMU_030.vhd:2272:13  */
  assign n5377 = n5346 ? walk_limit_valid : n5370;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5379 = n5338 ? 4'b0110 : n5372;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5380 = n5338 ? walk_level : n5373;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5383 = n5338 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5384 = n5338 ? walk_addr : n5374;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5385 = n5338 ? indirect_addr : n5375;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5386 = n5338 ? indirect_target_long : n5376;
  /* TG68K_PMMU_030.vhd:2267:13  */
  assign n5387 = n5338 ? walk_limit_valid : n5377;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5389 = n5404 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5390 = n5405 ? n5328 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5392 = n5301 ? 4'b1111 : n5379;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5393 = n5301 ? walk_level : n5380;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5395 = n5301 ? 1'b0 : n5383;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5396 = n5301 ? walk_addr : n5384;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5399 = n5301 ? indirect_addr : n5385;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5400 = n5301 ? indirect_target_long : n5386;
  /* TG68K_PMMU_030.vhd:2240:13  */
  assign n5401 = n5301 ? walk_limit_valid : n5387;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5403 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5404 = n5301 & mem_ack;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5405 = n5301 & mem_ack;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5406 = mem_ack ? n5392 : wstate;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5407 = mem_ack ? n5393 : walk_level;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5408 = mem_ack ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5409 = mem_ack ? mem_rdat : walk_desc_high;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5410 = mem_ack ? n5395 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5411 = mem_ack ? n5396 : walk_addr;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5413 = mem_ack ? n5399 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5414 = mem_ack ? n5400 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2227:11  */
  assign n5415 = mem_ack ? n5401 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5417 = mem_berr ? 1'b0 : n5403;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5419 = mem_berr ? 1'b1 : n5389;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5420 = mem_berr ? n5293 : n5390;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5422 = mem_berr ? 4'b1111 : n5406;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5423 = mem_berr ? walk_level : n5407;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5424 = mem_berr ? walk_desc : n5408;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5425 = mem_berr ? walk_desc_high : n5409;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5426 = mem_berr ? walk_desc_is_long : n5410;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5427 = mem_berr ? walk_addr : n5411;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5430 = mem_berr ? indirect_addr : n5413;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5431 = mem_berr ? indirect_target_long : n5414;
  /* TG68K_PMMU_030.vhd:2217:11  */
  assign n5432 = mem_berr ? walk_limit_valid : n5415;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5433 = n5177 ? n5264 : n5417;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5434 = n5255 & n5177;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5435 = n5255 & n5177;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5436 = n5177 ? n5251 : n5419;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5437 = n5177 ? n5252 : n5420;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5438 = n5177 ? n5253 : n5422;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5439 = n5177 ? walk_level : n5423;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5440 = n5177 ? walk_desc : n5424;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5441 = n5177 ? walk_desc_high : n5425;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5442 = n5177 ? walk_desc_is_long : n5426;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5443 = n5177 ? walk_addr : n5427;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5445 = n5177 ? indirect_addr : n5430;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5446 = n5177 ? indirect_target_long : n5431;
  /* TG68K_PMMU_030.vhd:2172:11  */
  assign n5447 = n5177 ? walk_limit_valid : n5432;
  /* TG68K_PMMU_030.vhd:2165:9  */
  assign n5449 = wstate == 4'b0101;
  /* TG68K_PMMU_030.vhd:2297:22  */
  assign n5450 = ~n7739;
  /* TG68K_PMMU_030.vhd:2299:66  */
  assign n5452 = desc_addr_reg + 32'b00000000000000000000000000000100;
  assign n5462 = n5461[31:16]; // extract
  assign n5469 = n5461[12]; // extract
  assign n5476 = n5461[8:7]; // extract
  assign n5478 = n5461[5:3]; // extract
  assign n5479 = {n5462, 1'b1, 1'b0, 1'b0, n5469, 1'b0, 1'b0, 1'b0, n5476, 1'b0, n5478, walk_level};
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n5485 = walk_desc_high[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n5487 = n5485 == 2'b01;
  /* TG68K_PMMU_030.vhd:2322:30  */
  assign n5488 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:2322:34  */
  assign n5489 = {27'b0, n5488};  //  uext
  /* TG68K_PMMU_030.vhd:2322:34  */
  assign n5491 = n5489 == 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2326:40  */
  assign n5492 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2326:54  */
  assign n5494 = {n5492, 2'b00};
  /* TG68K_PMMU_030.vhd:682:22  */
  assign n5500 = mem_rdat[31:4]; // extract
  /* TG68K_PMMU_030.vhd:682:36  */
  assign n5502 = {n5500, 4'b0000};
  /* TG68K_PMMU_030.vhd:2333:40  */
  assign n5503 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2333:40  */
  assign n5505 = n5503 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:2333:29  */
  assign n5506 = n5505[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:2336:49  */
  assign n5507 = walk_desc_high[31]; // extract
  /* TG68K_PMMU_030.vhd:2337:58  */
  assign n5508 = walk_desc_high[30:16]; // extract
  /* TG68K_PMMU_030.vhd:2339:67  */
  assign n5509 = walk_desc_high[8]; // extract
  /* TG68K_PMMU_030.vhd:2339:50  */
  assign n5510 = walk_supervisor | n5509;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5513 = n5491 ? 4'b1001 : 4'b0111;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5514 = n5491 ? walk_level : n5506;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5515 = n5491 ? walk_addr : n5502;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5516 = n5491 ? walk_supervisor : n5510;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5517 = n5491 ? n5494 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5519 = n5491 ? 1'b1 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5521 = n5491 ? walk_limit_valid : 1'b1;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5522 = n5491 ? walk_limit_lu : n5507;
  /* TG68K_PMMU_030.vhd:2322:13  */
  assign n5523 = n5491 ? walk_limit_value : n5508;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5525 = n5487 ? 4'b1011 : n5513;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5526 = n5487 ? walk_level : n5514;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5527 = n5487 ? walk_addr : n5515;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5528 = n5487 ? walk_supervisor : n5516;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5529 = n5487 ? indirect_addr : n5517;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5530 = n5487 ? indirect_target_long : n5519;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5531 = n5487 ? walk_limit_valid : n5521;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5532 = n5487 ? walk_limit_lu : n5522;
  /* TG68K_PMMU_030.vhd:2318:13  */
  assign n5533 = n5487 ? walk_limit_value : n5523;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5535 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5536 = mem_ack ? n5525 : wstate;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5537 = mem_ack ? n5526 : walk_level;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5538 = mem_ack ? mem_rdat : walk_desc_low;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5539 = mem_ack ? n5527 : walk_addr;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5540 = mem_ack ? n5528 : walk_supervisor;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5541 = mem_ack ? n5529 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5542 = mem_ack ? n5530 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5543 = mem_ack ? n5531 : walk_limit_valid;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5544 = mem_ack ? n5532 : walk_limit_lu;
  /* TG68K_PMMU_030.vhd:2311:11  */
  assign n5545 = mem_ack ? n5533 : walk_limit_value;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5547 = mem_berr ? 1'b0 : n5535;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5549 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5550 = mem_berr ? n5479 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5552 = mem_berr ? 4'b1111 : n5536;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5553 = mem_berr ? walk_level : n5537;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5554 = mem_berr ? walk_desc_low : n5538;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5555 = mem_berr ? walk_addr : n5539;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5558 = mem_berr ? walk_supervisor : n5540;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5559 = mem_berr ? indirect_addr : n5541;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5560 = mem_berr ? indirect_target_long : n5542;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5561 = mem_berr ? walk_limit_valid : n5543;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5562 = mem_berr ? walk_limit_lu : n5544;
  /* TG68K_PMMU_030.vhd:2301:11  */
  assign n5563 = mem_berr ? walk_limit_value : n5545;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5565 = n5450 ? 1'b1 : n5547;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5566 = n5450 ? n5452 : n7741;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5567 = n5450 ? walker_fault : n5549;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5568 = n5450 ? walker_fault_status : n5550;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5569 = n5450 ? wstate : n5552;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5570 = n5450 ? walk_level : n5553;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5571 = n5450 ? walk_desc_low : n5554;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5572 = n5450 ? walk_addr : n5555;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5574 = n5450 ? walk_supervisor : n5558;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5575 = n5450 ? indirect_addr : n5559;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5576 = n5450 ? indirect_target_long : n5560;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5577 = n5450 ? walk_limit_valid : n5561;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5578 = n5450 ? walk_limit_lu : n5562;
  /* TG68K_PMMU_030.vhd:2297:11  */
  assign n5579 = n5450 ? walk_limit_value : n5563;
  /* TG68K_PMMU_030.vhd:2295:9  */
  assign n5581 = wstate == 4'b0110;
  /* TG68K_PMMU_030.vhd:590:26  */
  assign n5589 = walk_vpn[28:0]; // extract
  /* TG68K_PMMU_030.vhd:590:20  */
  assign n5590 = {saved_fc, n5589};
  /* TG68K_PMMU_030.vhd:589:5  */
  assign n5591 = tc_fcl ? n5590 : walk_vpn;
  /* TG68K_PMMU_030.vhd:2347:87  */
  assign n5593 = {29'b0, walk_level};  //  uext
  /* TG68K_PMMU_030.vhd:2347:117  */
  assign n5595 = {28'b0, tc_page_size};  //  uext
  /* TG68K_PMMU_030.vhd:533:14  */
  assign n5606 = $signed(n5593) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:533:27  */
  assign n5608 = $signed(n5593) > $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:533:18  */
  assign n5609 = n5606 | n5608;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n5613 = n5609 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:533:5  */
  assign n5619 = n5609 ? 32'b00000000000000000000000000000000 : 32'bX;
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n5620 = walk_level[1:0];  // trunc
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n5622 = 2'b11 - n5620;
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n5625 = {27'b0, n7828};  //  uext
  /* TG68K_PMMU_030.vhd:537:5  */
  assign n5627 = n5613 ? n5625 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:538:19  */
  assign n5630 = $signed(n5627) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5633 = n5640 ? 1'b0 : n5613;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5636 = n5642 ? 32'b00000000000000000000000000000000 : n5619;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5637 = n5613 & n5630;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5639 = n5613 & n5630;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5640 = n5637 & n5613;
  /* TG68K_PMMU_030.vhd:538:5  */
  assign n5642 = n5639 & n5613;
  /* TG68K_PMMU_030.vhd:553:5  */
  assign n5644 = n5633 ? n5595 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:560:14  */
  assign n5647 = $signed(n5593) < $signed(32'b00000000000000000000000000000001);
  /* TG68K_PMMU_030.vhd:560:66  */
  assign n5648 = tc_idx_bits[14:10]; // extract
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n5649 = {27'b0, n5648};  //  uext
  /* TG68K_PMMU_030.vhd:560:56  */
  assign n5650 = n5644 + n5649;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5651 = n5653 ? n5650 : n5644;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5652 = n5633 & n5647;
  /* TG68K_PMMU_030.vhd:560:5  */
  assign n5653 = n5652 & n5633;
  /* TG68K_PMMU_030.vhd:561:14  */
  assign n5655 = $signed(n5593) < $signed(32'b00000000000000000000000000000010);
  /* TG68K_PMMU_030.vhd:561:66  */
  assign n5656 = tc_idx_bits[9:5]; // extract
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n5657 = {27'b0, n5656};  //  uext
  /* TG68K_PMMU_030.vhd:561:56  */
  assign n5658 = n5651 + n5657;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5659 = n5661 ? n5658 : n5651;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5660 = n5633 & n5655;
  /* TG68K_PMMU_030.vhd:561:5  */
  assign n5661 = n5660 & n5633;
  /* TG68K_PMMU_030.vhd:562:14  */
  assign n5663 = $signed(n5593) < $signed(32'b00000000000000000000000000000011);
  /* TG68K_PMMU_030.vhd:562:66  */
  assign n5664 = tc_idx_bits[4:0]; // extract
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n5665 = {27'b0, n5664};  //  uext
  /* TG68K_PMMU_030.vhd:562:56  */
  assign n5666 = n5659 + n5665;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5667 = n5669 ? n5666 : n5659;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5668 = n5633 & n5663;
  /* TG68K_PMMU_030.vhd:562:5  */
  assign n5669 = n5668 & n5633;
  /* TG68K_PMMU_030.vhd:565:5  */
  assign n5671 = n5633 ? n5667 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:568:21  */
  assign n5674 = $signed(n5671) < $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:568:41  */
  assign n5676 = $signed(n5671) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:568:25  */
  assign n5677 = n5674 | n5676;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5680 = n5687 ? 1'b0 : n5633;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5683 = n5689 ? 32'b00000000000000000000000000000000 : n5636;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5684 = n5633 & n5677;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5686 = n5633 & n5677;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5687 = n5684 & n5633;
  /* TG68K_PMMU_030.vhd:568:5  */
  assign n5689 = n5686 & n5633;
  /* TG68K_PMMU_030.vhd:573:5  */
  assign n5691 = n5680 ? n5591 : 32'bX;
  /* TG68K_PMMU_030.vhd:574:41  */
  assign n5693 = n5671[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:574:18  */
  assign n5694 = n5691 >> n5693;
  /* TG68K_PMMU_030.vhd:574:5  */
  assign n5695 = n5680 ? n5694 : n5691;
  /* TG68K_PMMU_030.vhd:575:54  */
  assign n5697 = 32'b00000000000000000000000000000001 << n5627;
  /* TG68K_PMMU_030.vhd:575:68  */
  assign n5699 = n5697 - 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:575:52  */
  assign n5700 = n5699[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:40  */
  assign n5701 = {1'b0, n5700};  //  uext
  /* TG68K_PMMU_030.vhd:575:36  */
  assign n5702 = n5695 & n5701;
  /* TG68K_PMMU_030.vhd:575:15  */
  assign n5703 = n5702[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n5704 = {1'b0, n5703};  //  uext
  /* TG68K_PMMU_030.vhd:575:5  */
  assign n5706 = n5680 ? n5704 : 32'b10000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:577:5  */
  assign n5712 = n5680 ? n5706 : n5683;
  /* TG68K_PMMU_030.vhd:2348:35  */
  assign n5713 = walk_addr[31:4]; // extract
  /* TG68K_PMMU_030.vhd:2348:49  */
  assign n5715 = {n5713, 4'b0000};
  /* TG68K_PMMU_030.vhd:2349:91  */
  assign n5717 = $signed(n5712) * $signed(32'b00000000000000000000000000000100); // smul
  /* TG68K_PMMU_030.vhd:2349:79  */
  assign n5718 = n5717[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2349:67  */
  assign n5719 = {1'b0, n5718};  //  uext
  /* TG68K_PMMU_030.vhd:2349:65  */
  assign n5720 = n5715 + n5719;
  /* TG68K_PMMU_030.vhd:2352:22  */
  assign n5721 = ~n7739;
  /* TG68K_PMMU_030.vhd:2357:32  */
  assign n5722 = n5712[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2357:20  */
  assign n5723 = n5722[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2357:49  */
  assign n5724 = $unsigned(n5723) < $unsigned(walk_limit_value);
  assign n5734 = n5733[31:16]; // extract
  assign n5741 = n5733[12]; // extract
  assign n5748 = n5733[8:7]; // extract
  assign n5750 = n5733[5:3]; // extract
  assign n5751 = {n5734, 1'b0, 1'b1, 1'b0, n5741, 1'b0, 1'b0, 1'b0, n5748, 1'b0, n5750, walk_level};
  /* TG68K_PMMU_030.vhd:2357:17  */
  assign n5753 = n5724 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2357:17  */
  assign n5754 = n5724 ? n5751 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2357:17  */
  assign n5756 = n5724 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2368:32  */
  assign n5757 = n5712[30:0];  // trunc
  /* TG68K_PMMU_030.vhd:2368:20  */
  assign n5758 = n5757[14:0];  // trunc
  /* TG68K_PMMU_030.vhd:2368:49  */
  assign n5759 = $unsigned(n5758) > $unsigned(walk_limit_value);
  assign n5769 = n5768[31:16]; // extract
  assign n5776 = n5768[12]; // extract
  assign n5783 = n5768[8:7]; // extract
  assign n5785 = n5768[5:3]; // extract
  assign n5786 = {n5769, 1'b0, 1'b1, 1'b0, n5776, 1'b0, 1'b0, 1'b0, n5783, 1'b0, n5785, walk_level};
  /* TG68K_PMMU_030.vhd:2368:17  */
  assign n5788 = n5759 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2368:17  */
  assign n5789 = n5759 ? n5786 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2368:17  */
  assign n5791 = n5759 ? 4'b1111 : wstate;
  /* TG68K_PMMU_030.vhd:2355:15  */
  assign n5792 = walk_limit_lu ? n5753 : n5788;
  /* TG68K_PMMU_030.vhd:2355:15  */
  assign n5793 = walk_limit_lu ? n5754 : n5789;
  /* TG68K_PMMU_030.vhd:2355:15  */
  assign n5794 = walk_limit_lu ? n5756 : n5791;
  /* TG68K_PMMU_030.vhd:2354:13  */
  assign n5795 = walk_limit_valid ? n5792 : walker_fault;
  /* TG68K_PMMU_030.vhd:2354:13  */
  assign n5796 = walk_limit_valid ? n5793 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2354:13  */
  assign n5797 = walk_limit_valid ? n5794 : wstate;
  /* TG68K_PMMU_030.vhd:2380:23  */
  assign n5799 = wstate == 4'b0111;
  /* TG68K_PMMU_030.vhd:2380:13  */
  assign n5801 = n5799 ? 1'b1 : n7739;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5802 = n5930 ? n5720 : n7741;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5803 = n5931 ? n5720 : desc_addr_reg;
  assign n5813 = n5812[31:16]; // extract
  assign n5820 = n5812[12]; // extract
  assign n5827 = n5812[8:7]; // extract
  assign n5829 = n5812[5:3]; // extract
  assign n5830 = {n5813, 1'b1, 1'b0, 1'b0, n5820, 1'b0, 1'b0, 1'b0, n5827, 1'b0, n5829, walk_level};
  /* TG68K_PMMU_030.vhd:2400:24  */
  assign n5831 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:2400:37  */
  assign n5833 = n5831 == 2'b00;
  assign n5843 = n5842[31:16]; // extract
  assign n5850 = n5842[12]; // extract
  assign n5857 = n5842[8:7]; // extract
  assign n5859 = n5842[5:3]; // extract
  assign n5860 = {n5843, 1'b0, 1'b0, 1'b0, n5850, 1'b0, 1'b1, 1'b0, n5857, 1'b0, n5859, walk_level};
  /* TG68K_PMMU_030.vhd:620:16  */
  assign n5866 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:620:29  */
  assign n5868 = n5866 == 2'b11;
  /* TG68K_PMMU_030.vhd:602:16  */
  assign n5874 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:602:29  */
  assign n5876 = n5874 == 2'b01;
  /* TG68K_PMMU_030.vhd:2434:40  */
  assign n5877 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2434:54  */
  assign n5879 = {n5877, 2'b00};
  /* TG68K_PMMU_030.vhd:2425:13  */
  assign n5882 = n5876 ? 4'b1011 : 4'b1001;
  /* TG68K_PMMU_030.vhd:2425:13  */
  assign n5883 = n5876 ? indirect_addr : n5879;
  /* TG68K_PMMU_030.vhd:2425:13  */
  assign n5885 = n5876 ? indirect_target_long : 1'b0;
  /* TG68K_PMMU_030.vhd:2420:13  */
  assign n5887 = n5868 ? 4'b1000 : n5882;
  /* TG68K_PMMU_030.vhd:2420:13  */
  assign n5890 = n5868 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:2420:13  */
  assign n5891 = n5868 ? indirect_addr : n5883;
  /* TG68K_PMMU_030.vhd:2420:13  */
  assign n5892 = n5868 ? indirect_target_long : n5885;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5894 = n5906 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5895 = n5907 ? n5860 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2400:13  */
  assign n5897 = n5833 ? 4'b1111 : n5887;
  /* TG68K_PMMU_030.vhd:2400:13  */
  assign n5899 = n5833 ? 1'b0 : n5890;
  /* TG68K_PMMU_030.vhd:2400:13  */
  assign n5902 = n5833 ? indirect_addr : n5891;
  /* TG68K_PMMU_030.vhd:2400:13  */
  assign n5903 = n5833 ? indirect_target_long : n5892;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5905 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5906 = n5833 & mem_ack;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5907 = n5833 & mem_ack;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5908 = mem_ack ? n5897 : wstate;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5909 = mem_ack ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5910 = mem_ack ? mem_rdat : walk_desc_high;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5911 = mem_ack ? n5899 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5913 = mem_ack ? n5902 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2395:11  */
  assign n5914 = mem_ack ? n5903 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5916 = mem_berr ? 1'b0 : n5905;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5918 = mem_berr ? 1'b1 : n5894;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5919 = mem_berr ? n5830 : n5895;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5921 = mem_berr ? 4'b1111 : n5908;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5922 = mem_berr ? walk_desc : n5909;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5923 = mem_berr ? walk_desc_high : n5910;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5924 = mem_berr ? walk_desc_is_long : n5911;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5927 = mem_berr ? indirect_addr : n5913;
  /* TG68K_PMMU_030.vhd:2385:11  */
  assign n5928 = mem_berr ? indirect_target_long : n5914;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5929 = n5721 ? n5801 : n5916;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5930 = n5799 & n5721;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5931 = n5799 & n5721;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5932 = n5721 ? n5795 : n5918;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5933 = n5721 ? n5796 : n5919;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5934 = n5721 ? n5797 : n5921;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5935 = n5721 ? walk_desc : n5922;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5936 = n5721 ? walk_desc_high : n5923;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5937 = n5721 ? walk_desc_is_long : n5924;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5939 = n5721 ? indirect_addr : n5927;
  /* TG68K_PMMU_030.vhd:2352:11  */
  assign n5940 = n5721 ? indirect_target_long : n5928;
  /* TG68K_PMMU_030.vhd:2345:9  */
  assign n5942 = wstate == 4'b0111;
  /* TG68K_PMMU_030.vhd:2444:22  */
  assign n5943 = ~n7739;
  /* TG68K_PMMU_030.vhd:2446:66  */
  assign n5945 = desc_addr_reg + 32'b00000000000000000000000000000100;
  assign n5955 = n5954[31:16]; // extract
  assign n5962 = n5954[12]; // extract
  assign n5969 = n5954[8:7]; // extract
  assign n5971 = n5954[5:3]; // extract
  assign n5972 = {n5955, 1'b1, 1'b0, 1'b0, n5962, 1'b0, 1'b0, 1'b0, n5969, 1'b0, n5971, walk_level};
  /* TG68K_PMMU_030.vhd:2467:38  */
  assign n5973 = mem_rdat[31:2]; // extract
  /* TG68K_PMMU_030.vhd:2467:52  */
  assign n5975 = {n5973, 2'b00};
  /* TG68K_PMMU_030.vhd:2458:11  */
  assign n5977 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2458:11  */
  assign n5979 = mem_ack ? 4'b1001 : wstate;
  /* TG68K_PMMU_030.vhd:2458:11  */
  assign n5980 = mem_ack ? mem_rdat : walk_desc_low;
  /* TG68K_PMMU_030.vhd:2458:11  */
  assign n5981 = mem_ack ? n5975 : indirect_addr;
  /* TG68K_PMMU_030.vhd:2458:11  */
  assign n5983 = mem_ack ? 1'b1 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5985 = mem_berr ? 1'b0 : n5977;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5987 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5988 = mem_berr ? n5972 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5990 = mem_berr ? 4'b1111 : n5979;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5991 = mem_berr ? walk_desc_low : n5980;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5994 = mem_berr ? indirect_addr : n5981;
  /* TG68K_PMMU_030.vhd:2448:11  */
  assign n5995 = mem_berr ? indirect_target_long : n5983;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n5997 = n5943 ? 1'b1 : n5985;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n5998 = n5943 ? n5945 : n7741;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n5999 = n5943 ? walker_fault : n5987;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n6000 = n5943 ? walker_fault_status : n5988;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n6001 = n5943 ? wstate : n5990;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n6002 = n5943 ? walk_desc_low : n5991;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n6004 = n5943 ? indirect_addr : n5994;
  /* TG68K_PMMU_030.vhd:2444:11  */
  assign n6005 = n5943 ? indirect_target_long : n5995;
  /* TG68K_PMMU_030.vhd:2441:9  */
  assign n6007 = wstate == 4'b1000;
  /* TG68K_PMMU_030.vhd:2476:22  */
  assign n6008 = ~n7739;
  assign n6018 = n6017[31:16]; // extract
  assign n6025 = n6017[12]; // extract
  assign n6032 = n6017[8:7]; // extract
  assign n6034 = n6017[5:3]; // extract
  assign n6035 = {n6018, 1'b1, 1'b0, 1'b0, n6025, 1'b0, 1'b0, 1'b0, n6032, 1'b0, n6034, walk_level};
  /* TG68K_PMMU_030.vhd:2498:24  */
  assign n6036 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:2498:37  */
  assign n6038 = n6036 == 2'b01;
  /* TG68K_PMMU_030.vhd:2501:39  */
  assign n6039 = ~indirect_target_long;
  /* TG68K_PMMU_030.vhd:2501:15  */
  assign n6042 = n6039 ? 4'b1011 : 4'b1010;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6043 = n6118 ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:2501:15  */
  assign n6046 = n6039 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:2511:27  */
  assign n6047 = mem_rdat[1:0]; // extract
  /* TG68K_PMMU_030.vhd:2511:40  */
  assign n6049 = n6047 == 2'b00;
  assign n6059 = n6058[31:16]; // extract
  assign n6066 = n6058[12]; // extract
  assign n6073 = n6058[8:7]; // extract
  assign n6075 = n6058[5:3]; // extract
  assign n6076 = {n6059, 1'b0, 1'b0, 1'b0, n6066, 1'b0, 1'b1, 1'b0, n6073, 1'b0, n6075, walk_level};
  assign n6086 = n6085[31:16]; // extract
  assign n6093 = n6085[12]; // extract
  assign n6100 = n6085[8:7]; // extract
  assign n6102 = n6085[5:3]; // extract
  assign n6103 = {n6086, 1'b0, 1'b0, 1'b0, n6093, 1'b0, 1'b1, 1'b0, n6100, 1'b0, n6102, walk_level};
  /* TG68K_PMMU_030.vhd:2511:13  */
  assign n6104 = n6049 ? n6076 : n6103;
  /* TG68K_PMMU_030.vhd:2498:13  */
  assign n6106 = n6038 ? walker_fault : 1'b1;
  /* TG68K_PMMU_030.vhd:2498:13  */
  assign n6107 = n6038 ? walker_fault_status : n6104;
  /* TG68K_PMMU_030.vhd:2498:13  */
  assign n6109 = n6038 ? n6042 : 4'b1111;
  /* TG68K_PMMU_030.vhd:2498:13  */
  assign n6110 = n6039 & n6038;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6111 = n6119 ? mem_rdat : walk_desc_high;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6112 = n6120 ? n6046 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6114 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6115 = mem_ack ? n6106 : walker_fault;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6116 = mem_ack ? n6107 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6117 = mem_ack ? n6109 : wstate;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6118 = n6110 & mem_ack;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6119 = n6038 & mem_ack;
  /* TG68K_PMMU_030.vhd:2491:11  */
  assign n6120 = n6038 & mem_ack;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6122 = mem_berr ? 1'b0 : n6114;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6124 = mem_berr ? 1'b1 : n6115;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6125 = mem_berr ? n6035 : n6116;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6127 = mem_berr ? 4'b1111 : n6117;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6128 = mem_berr ? walk_desc : n6043;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6129 = mem_berr ? walk_desc_high : n6111;
  /* TG68K_PMMU_030.vhd:2481:11  */
  assign n6130 = mem_berr ? walk_desc_is_long : n6112;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6134 = n6008 ? 1'b1 : n6122;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6135 = n6008 ? indirect_addr : n7741;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6136 = n6008 ? indirect_addr : desc_addr_reg;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6137 = n6008 ? walker_fault : n6124;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6138 = n6008 ? walker_fault_status : n6125;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6139 = n6008 ? wstate : n6127;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6140 = n6008 ? walk_desc : n6128;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6141 = n6008 ? walk_desc_high : n6129;
  /* TG68K_PMMU_030.vhd:2476:11  */
  assign n6142 = n6008 ? walk_desc_is_long : n6130;
  /* TG68K_PMMU_030.vhd:2473:9  */
  assign n6145 = wstate == 4'b1001;
  /* TG68K_PMMU_030.vhd:2547:22  */
  assign n6146 = ~n7739;
  /* TG68K_PMMU_030.vhd:2549:66  */
  assign n6148 = indirect_addr + 32'b00000000000000000000000000000100;
  assign n6158 = n6157[31:16]; // extract
  assign n6165 = n6157[12]; // extract
  assign n6172 = n6157[8:7]; // extract
  assign n6174 = n6157[5:3]; // extract
  assign n6175 = {n6158, 1'b1, 1'b0, 1'b0, n6165, 1'b0, 1'b0, 1'b0, n6172, 1'b0, n6174, walk_level};
  /* TG68K_PMMU_030.vhd:2560:11  */
  assign n6177 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2560:11  */
  assign n6179 = mem_ack ? 4'b1011 : wstate;
  /* TG68K_PMMU_030.vhd:2560:11  */
  assign n6180 = mem_ack ? mem_rdat : walk_desc;
  /* TG68K_PMMU_030.vhd:2560:11  */
  assign n6181 = mem_ack ? mem_rdat : walk_desc_low;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6183 = mem_berr ? 1'b0 : n6177;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6185 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6186 = mem_berr ? n6175 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6188 = mem_berr ? 4'b1111 : n6179;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6189 = mem_berr ? walk_desc : n6180;
  /* TG68K_PMMU_030.vhd:2550:11  */
  assign n6190 = mem_berr ? walk_desc_low : n6181;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6194 = n6146 ? 1'b1 : n6183;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6195 = n6146 ? n6148 : n7741;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6196 = n6146 ? walker_fault : n6185;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6197 = n6146 ? walker_fault_status : n6186;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6198 = n6146 ? wstate : n6188;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6199 = n6146 ? walk_desc : n6189;
  /* TG68K_PMMU_030.vhd:2547:11  */
  assign n6200 = n6146 ? walk_desc_low : n6190;
  /* TG68K_PMMU_030.vhd:2544:9  */
  assign n6203 = wstate == 4'b1010;
  /* TG68K_PMMU_030.vhd:614:16  */
  assign n6209 = walk_desc[1:0]; // extract
  /* TG68K_PMMU_030.vhd:614:29  */
  assign n6211 = n6209 != 2'b00;
  /* TG68K_PMMU_030.vhd:2571:14  */
  assign n6212 = ~n6211;
  assign n6222 = n6221[31:16]; // extract
  assign n6229 = n6221[12]; // extract
  assign n6236 = n6221[8:7]; // extract
  assign n6238 = n6221[5:3]; // extract
  assign n6239 = {n6222, 1'b0, 1'b0, 1'b0, n6229, 1'b0, 1'b1, 1'b0, n6236, 1'b0, n6238, walk_level};
  /* TG68K_PMMU_030.vhd:2589:25  */
  assign n6240 = saved_fc[2]; // extract
  /* TG68K_PMMU_030.vhd:2589:29  */
  assign n6241 = ~n6240;
  /* TG68K_PMMU_030.vhd:2589:35  */
  assign n6242 = walk_supervisor & n6241;
  /* TG68K_PMMU_030.vhd:2598:46  */
  assign n6244 = walk_desc_high[2]; // extract
  assign n6253 = n6252[31:16]; // extract
  assign n6259 = n6252[12]; // extract
  assign n6266 = n6252[8:7]; // extract
  assign n6268 = n6252[5:3]; // extract
  assign n6269 = {n6253, 1'b0, 1'b0, 1'b1, n6259, n6244, 1'b0, 1'b0, n6266, 1'b0, n6268, walk_level};
  /* TG68K_PMMU_030.vhd:2605:26  */
  assign n6270 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:2605:50  */
  assign n6271 = walk_desc_high[2]; // extract
  /* TG68K_PMMU_030.vhd:2605:32  */
  assign n6272 = n6271 & n6270;
  assign n6282 = n6281[31:16]; // extract
  assign n6289 = n6281[12]; // extract
  assign n6296 = n6281[8:7]; // extract
  assign n6298 = n6281[5:3]; // extract
  assign n6299 = {n6282, 1'b0, 1'b0, 1'b0, n6289, 1'b1, 1'b0, 1'b0, n6296, 1'b0, n6298, walk_level};
  /* TG68K_PMMU_030.vhd:2624:32  */
  assign n6300 = {1'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:2626:59  */
  assign n6302 = {28'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6309 = $signed(n6302) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6311 = $signed(n6302) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6312 = n6309 | n6311;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6315 = n6312 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6321 = n6312 ? saved_addr_log : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6322 = {27'b0, tc_page_shift};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6324 = 32'b11111111111111111111111111111111 << n6322;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6326 = n6315 ? n6324 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6328 = saved_addr_log & n6326;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6329 = n6315 ? n6328 : saved_addr_log;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6334 = n6315 ? n6329 : n6321;
  /* TG68K_PMMU_030.vhd:2630:46  */
  assign n6335 = walk_desc_low[31:8]; // extract
  /* TG68K_PMMU_030.vhd:2630:60  */
  assign n6337 = {n6335, 8'b00000000};
  /* TG68K_PMMU_030.vhd:2633:47  */
  assign n6338 = walk_desc_high[31:8]; // extract
  /* TG68K_PMMU_030.vhd:2633:61  */
  assign n6340 = {n6338, 8'b00000000};
  /* TG68K_PMMU_030.vhd:2628:13  */
  assign n6341 = walk_desc_is_long ? n6337 : n6340;
  /* TG68K_PMMU_030.vhd:2637:29  */
  assign n6342 = ~walk_supervisor;
  /* TG68K_PMMU_030.vhd:2638:43  */
  assign n6343 = walk_desc_high[6]; // extract
  /* TG68K_PMMU_030.vhd:2639:43  */
  assign n6344 = walk_desc_high[4]; // extract
  /* TG68K_PMMU_030.vhd:2640:43  */
  assign n6345 = walk_desc_high[2]; // extract
  /* TG68K_PMMU_030.vhd:2644:44  */
  assign n6346 = walk_desc_high[10]; // extract
  /* TG68K_PMMU_030.vhd:2643:13  */
  assign n6348 = walk_desc_is_long ? n6346 : 1'b0;
  /* TG68K_PMMU_030.vhd:2663:30  */
  assign n6349 = walk_desc_high[3]; // extract
  /* TG68K_PMMU_030.vhd:2663:34  */
  assign n6350 = ~n6349;
  /* TG68K_PMMU_030.vhd:2663:53  */
  assign n6351 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:2663:77  */
  assign n6352 = walk_desc_high[4]; // extract
  /* TG68K_PMMU_030.vhd:2663:81  */
  assign n6353 = ~n6352;
  /* TG68K_PMMU_030.vhd:2663:59  */
  assign n6354 = n6353 & n6351;
  /* TG68K_PMMU_030.vhd:2663:40  */
  assign n6355 = n6350 | n6354;
  /* TG68K_PMMU_030.vhd:2667:49  */
  assign n6356 = walk_desc_high[31:5]; // extract
  /* TG68K_PMMU_030.vhd:2668:50  */
  assign n6357 = walk_desc_high[4]; // extract
  /* TG68K_PMMU_030.vhd:2668:58  */
  assign n6358 = ~saved_rw;
  /* TG68K_PMMU_030.vhd:2668:54  */
  assign n6359 = n6357 | n6358;
  /* TG68K_PMMU_030.vhd:2667:63  */
  assign n6360 = {n6356, n6359};
  /* TG68K_PMMU_030.vhd:2668:73  */
  assign n6362 = {n6360, 1'b1};
  /* TG68K_PMMU_030.vhd:2670:49  */
  assign n6363 = walk_desc_high[2:0]; // extract
  /* TG68K_PMMU_030.vhd:2669:39  */
  assign n6364 = {n6362, n6363};
  /* TG68K_PMMU_030.vhd:2663:13  */
  assign n6367 = n6355 ? 4'b1100 : 4'b1101;
  /* TG68K_PMMU_030.vhd:2663:13  */
  assign n6370 = n6355 ? n6364 : desc_update_data;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6372 = n6272 ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6373 = n6272 ? n6299 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6375 = n6272 ? 4'b1111 : n6367;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6376 = n6272 ? walk_log_base : n6334;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6377 = n6272 ? walk_phys_base : n6341;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6378 = n6272 ? walk_page_shift : n6300;
  assign n6382 = {n6342, n6343, n6344, n6345};
  assign n6383 = walk_attr[3:0]; // extract
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6384 = n6272 ? n6383 : n6382;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6385 = n6272 ? walk_global : n6348;
  /* TG68K_PMMU_030.vhd:2605:11  */
  assign n6387 = n6272 ? desc_update_data : n6370;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6389 = n6242 ? 1'b1 : n6372;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6390 = n6242 ? n6269 : n6373;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6392 = n6242 ? 4'b1111 : n6375;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6393 = n6242 ? walk_log_base : n6376;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6394 = n6242 ? walk_phys_base : n6377;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6395 = n6242 ? walk_page_shift : n6378;
  assign n6398 = walk_attr[3:0]; // extract
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6399 = n6242 ? n6398 : n6384;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6400 = n6242 ? walk_global : n6385;
  /* TG68K_PMMU_030.vhd:2589:11  */
  assign n6402 = n6242 ? desc_update_data : n6387;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6404 = n6212 ? 1'b1 : n6389;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6405 = n6212 ? n6239 : n6390;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6407 = n6212 ? 4'b1111 : n6392;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6408 = n6212 ? walk_log_base : n6393;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6409 = n6212 ? walk_phys_base : n6394;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6410 = n6212 ? walk_page_shift : n6395;
  assign n6413 = walk_attr[3:0]; // extract
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6414 = n6212 ? n6413 : n6399;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6415 = n6212 ? walk_global : n6400;
  /* TG68K_PMMU_030.vhd:2571:11  */
  assign n6417 = n6212 ? desc_update_data : n6402;
  /* TG68K_PMMU_030.vhd:2569:9  */
  assign n6419 = wstate == 4'b1011;
  /* TG68K_PMMU_030.vhd:2682:22  */
  assign n6420 = ~n7739;
  assign n6430 = n6429[31:16]; // extract
  assign n6437 = n6429[12]; // extract
  assign n6444 = n6429[8:7]; // extract
  assign n6446 = n6429[5:3]; // extract
  assign n6447 = {n6430, 1'b1, 1'b0, 1'b0, n6437, 1'b0, 1'b0, 1'b0, n6444, 1'b0, n6446, walk_level};
  /* TG68K_PMMU_030.vhd:2706:45  */
  assign n6448 = desc_update_data[4]; // extract
  /* TG68K_PMMU_030.vhd:2699:11  */
  assign n6450 = mem_ack ? 1'b0 : n7739;
  /* TG68K_PMMU_030.vhd:2699:11  */
  assign n6452 = mem_ack ? 1'b0 : n7740;
  /* TG68K_PMMU_030.vhd:2699:11  */
  assign n6454 = mem_ack ? 4'b1101 : wstate;
  assign n6455 = walk_attr[1]; // extract
  /* TG68K_PMMU_030.vhd:2699:11  */
  assign n6456 = mem_ack ? n6448 : n6455;
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6460 = mem_berr ? 1'b0 : n6450;
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6462 = mem_berr ? 1'b0 : n6452;
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6464 = mem_berr ? 1'b1 : walker_fault;
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6465 = mem_berr ? n6447 : walker_fault_status;
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6467 = mem_berr ? 4'b1111 : n6454;
  assign n6470 = walk_attr[1]; // extract
  /* TG68K_PMMU_030.vhd:2687:11  */
  assign n6471 = mem_berr ? n6470 : n6456;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6474 = n6420 ? 1'b1 : n6460;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6476 = n6420 ? 1'b1 : n6462;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6477 = n6420 ? desc_addr_reg : n7741;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6478 = n6420 ? desc_update_data : n7742;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6479 = n6420 ? walker_fault : n6464;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6480 = n6420 ? walker_fault_status : n6465;
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6481 = n6420 ? wstate : n6467;
  assign n6483 = walk_attr[1]; // extract
  /* TG68K_PMMU_030.vhd:2682:11  */
  assign n6484 = n6420 ? n6483 : n6471;
  /* TG68K_PMMU_030.vhd:2678:9  */
  assign n6487 = wstate == 4'b1100;
  /* TG68K_PMMU_030.vhd:2712:24  */
  assign n6489 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2713:25  */
  assign n6493 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2714:21  */
  assign n6497 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2716:20  */
  assign n6505 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2716:45  */
  assign n6507 = walk_attr[3:0]; // extract
  /* TG68K_PMMU_030.vhd:2717:18  */
  assign n6510 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2718:23  */
  assign n6514 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2719:22  */
  assign n6518 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2720:21  */
  assign n6522 = 3'b111 - atc_rr;
  /* TG68K_PMMU_030.vhd:2731:21  */
  assign n6528 = {29'b0, atc_rr};  //  uext
  /* TG68K_PMMU_030.vhd:2731:21  */
  assign n6530 = n6528 == 32'b00000000000000000000000000000111;
  /* TG68K_PMMU_030.vhd:2734:30  */
  assign n6531 = {29'b0, atc_rr};  //  uext
  /* TG68K_PMMU_030.vhd:2734:30  */
  assign n6533 = n6531 + 32'b00000000000000000000000000000001;
  /* TG68K_PMMU_030.vhd:2734:23  */
  assign n6534 = n6533[2:0];  // trunc
  /* TG68K_PMMU_030.vhd:2731:11  */
  assign n6536 = n6530 ? 3'b000 : n6534;
  /* TG68K_PMMU_030.vhd:2710:9  */
  assign n6538 = wstate == 4'b1101;
  /* TG68K_PMMU_030.vhd:2738:9  */
  assign n6540 = wstate == 4'b1110;
  /* TG68K_PMMU_030.vhd:2753:9  */
  assign n6542 = wstate == 4'b1111;
  assign n6543 = {n6542, n6540, n6538, n6487, n6419, n6203, n6145, n6007, n5942, n5581, n5449, n5037, n4905, n4495, n4389, n3999};
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6544 = n7739;
      16'b0100000000000000: n6544 = n7739;
      16'b0010000000000000: n6544 = n7739;
      16'b0001000000000000: n6544 = n6474;
      16'b0000100000000000: n6544 = n7739;
      16'b0000010000000000: n6544 = n6194;
      16'b0000001000000000: n6544 = n6134;
      16'b0000000100000000: n6544 = n5997;
      16'b0000000010000000: n6544 = n5929;
      16'b0000000001000000: n6544 = n5565;
      16'b0000000000100000: n6544 = n5433;
      16'b0000000000010000: n6544 = n5021;
      16'b0000000000001000: n6544 = n4889;
      16'b0000000000000100: n6544 = n4481;
      16'b0000000000000010: n6544 = n4375;
      16'b0000000000000001: n6544 = n7739;
      default: n6544 = n7739;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6545 = n7740;
      16'b0100000000000000: n6545 = n7740;
      16'b0010000000000000: n6545 = n7740;
      16'b0001000000000000: n6545 = n6476;
      16'b0000100000000000: n6545 = n7740;
      16'b0000010000000000: n6545 = n7740;
      16'b0000001000000000: n6545 = n7740;
      16'b0000000100000000: n6545 = n7740;
      16'b0000000010000000: n6545 = n7740;
      16'b0000000001000000: n6545 = n7740;
      16'b0000000000100000: n6545 = n7740;
      16'b0000000000010000: n6545 = n7740;
      16'b0000000000001000: n6545 = n7740;
      16'b0000000000000100: n6545 = n7740;
      16'b0000000000000010: n6545 = n7740;
      16'b0000000000000001: n6545 = n3976;
      default: n6545 = n7740;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6546 = n7741;
      16'b0100000000000000: n6546 = n7741;
      16'b0010000000000000: n6546 = n7741;
      16'b0001000000000000: n6546 = n6477;
      16'b0000100000000000: n6546 = n7741;
      16'b0000010000000000: n6546 = n6195;
      16'b0000001000000000: n6546 = n6135;
      16'b0000000100000000: n6546 = n5998;
      16'b0000000010000000: n6546 = n5802;
      16'b0000000001000000: n6546 = n5566;
      16'b0000000000100000: n6546 = n5265;
      16'b0000000000010000: n6546 = n5022;
      16'b0000000000001000: n6546 = n4721;
      16'b0000000000000100: n6546 = n4482;
      16'b0000000000000010: n6546 = n4376;
      16'b0000000000000001: n6546 = n7741;
      default: n6546 = n7741;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6547 = n7742;
      16'b0100000000000000: n6547 = n7742;
      16'b0010000000000000: n6547 = n7742;
      16'b0001000000000000: n6547 = n6478;
      16'b0000100000000000: n6547 = n7742;
      16'b0000010000000000: n6547 = n7742;
      16'b0000001000000000: n6547 = n7742;
      16'b0000000100000000: n6547 = n7742;
      16'b0000000010000000: n6547 = n7742;
      16'b0000000001000000: n6547 = n7742;
      16'b0000000000100000: n6547 = n7742;
      16'b0000000000010000: n6547 = n7742;
      16'b0000000000001000: n6547 = n7742;
      16'b0000000000000100: n6547 = n7742;
      16'b0000000000000010: n6547 = n7742;
      16'b0000000000000001: n6547 = n7742;
      default: n6547 = n7742;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6548 = desc_addr_reg;
      16'b0100000000000000: n6548 = desc_addr_reg;
      16'b0010000000000000: n6548 = desc_addr_reg;
      16'b0001000000000000: n6548 = desc_addr_reg;
      16'b0000100000000000: n6548 = desc_addr_reg;
      16'b0000010000000000: n6548 = desc_addr_reg;
      16'b0000001000000000: n6548 = n6136;
      16'b0000000100000000: n6548 = desc_addr_reg;
      16'b0000000010000000: n6548 = n5803;
      16'b0000000001000000: n6548 = desc_addr_reg;
      16'b0000000000100000: n6548 = n5266;
      16'b0000000000010000: n6548 = desc_addr_reg;
      16'b0000000000001000: n6548 = n4722;
      16'b0000000000000100: n6548 = desc_addr_reg;
      16'b0000000000000010: n6548 = n4377;
      16'b0000000000000001: n6548 = desc_addr_reg;
      default: n6548 = desc_addr_reg;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6549 = walker_fault;
      16'b0100000000000000: n6549 = walker_fault;
      16'b0010000000000000: n6549 = walker_fault;
      16'b0001000000000000: n6549 = n6479;
      16'b0000100000000000: n6549 = n6404;
      16'b0000010000000000: n6549 = n6196;
      16'b0000001000000000: n6549 = n6137;
      16'b0000000100000000: n6549 = n5999;
      16'b0000000010000000: n6549 = n5932;
      16'b0000000001000000: n6549 = n5567;
      16'b0000000000100000: n6549 = n5436;
      16'b0000000000010000: n6549 = n5023;
      16'b0000000000001000: n6549 = n4892;
      16'b0000000000000100: n6549 = n4483;
      16'b0000000000000010: n6549 = n4378;
      16'b0000000000000001: n6549 = n3921;
      default: n6549 = walker_fault;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6550 = walker_fault_status;
      16'b0100000000000000: n6550 = walker_fault_status;
      16'b0010000000000000: n6550 = walker_fault_status;
      16'b0001000000000000: n6550 = n6480;
      16'b0000100000000000: n6550 = n6405;
      16'b0000010000000000: n6550 = n6197;
      16'b0000001000000000: n6550 = n6138;
      16'b0000000100000000: n6550 = n6000;
      16'b0000000010000000: n6550 = n5933;
      16'b0000000001000000: n6550 = n5568;
      16'b0000000000100000: n6550 = n5437;
      16'b0000000000010000: n6550 = n5024;
      16'b0000000000001000: n6550 = n4893;
      16'b0000000000000100: n6550 = n4484;
      16'b0000000000000010: n6550 = n4379;
      16'b0000000000000001: n6550 = walker_fault_status;
      default: n6550 = walker_fault_status;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6551 = atc_log_base;
      16'b0100000000000000: n6551 = atc_log_base;
      16'b0010000000000000: n6551 = n7863;
      16'b0001000000000000: n6551 = atc_log_base;
      16'b0000100000000000: n6551 = atc_log_base;
      16'b0000010000000000: n6551 = atc_log_base;
      16'b0000001000000000: n6551 = atc_log_base;
      16'b0000000100000000: n6551 = atc_log_base;
      16'b0000000010000000: n6551 = atc_log_base;
      16'b0000000001000000: n6551 = atc_log_base;
      16'b0000000000100000: n6551 = atc_log_base;
      16'b0000000000010000: n6551 = atc_log_base;
      16'b0000000000001000: n6551 = atc_log_base;
      16'b0000000000000100: n6551 = atc_log_base;
      16'b0000000000000010: n6551 = atc_log_base;
      16'b0000000000000001: n6551 = atc_log_base;
      default: n6551 = atc_log_base;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6552 = atc_phys_base;
      16'b0100000000000000: n6552 = atc_phys_base;
      16'b0010000000000000: n6552 = n7898;
      16'b0001000000000000: n6552 = atc_phys_base;
      16'b0000100000000000: n6552 = atc_phys_base;
      16'b0000010000000000: n6552 = atc_phys_base;
      16'b0000001000000000: n6552 = atc_phys_base;
      16'b0000000100000000: n6552 = atc_phys_base;
      16'b0000000010000000: n6552 = atc_phys_base;
      16'b0000000001000000: n6552 = atc_phys_base;
      16'b0000000000100000: n6552 = atc_phys_base;
      16'b0000000000010000: n6552 = atc_phys_base;
      16'b0000000000001000: n6552 = atc_phys_base;
      16'b0000000000000100: n6552 = atc_phys_base;
      16'b0000000000000010: n6552 = atc_phys_base;
      16'b0000000000000001: n6552 = atc_phys_base;
      default: n6552 = atc_phys_base;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6553 = atc_attr;
      16'b0100000000000000: n6553 = atc_attr;
      16'b0010000000000000: n6553 = n7968;
      16'b0001000000000000: n6553 = atc_attr;
      16'b0000100000000000: n6553 = atc_attr;
      16'b0000010000000000: n6553 = atc_attr;
      16'b0000001000000000: n6553 = atc_attr;
      16'b0000000100000000: n6553 = atc_attr;
      16'b0000000010000000: n6553 = atc_attr;
      16'b0000000001000000: n6553 = atc_attr;
      16'b0000000000100000: n6553 = atc_attr;
      16'b0000000000010000: n6553 = atc_attr;
      16'b0000000000001000: n6553 = atc_attr;
      16'b0000000000000100: n6553 = atc_attr;
      16'b0000000000000010: n6553 = atc_attr;
      16'b0000000000000001: n6553 = atc_attr;
      default: n6553 = atc_attr;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6554 = atc_valid;
      16'b0100000000000000: n6554 = atc_valid;
      16'b0010000000000000: n6554 = n8108;
      16'b0001000000000000: n6554 = atc_valid;
      16'b0000100000000000: n6554 = atc_valid;
      16'b0000010000000000: n6554 = atc_valid;
      16'b0000001000000000: n6554 = atc_valid;
      16'b0000000100000000: n6554 = atc_valid;
      16'b0000000010000000: n6554 = atc_valid;
      16'b0000000001000000: n6554 = atc_valid;
      16'b0000000000100000: n6554 = atc_valid;
      16'b0000000000010000: n6554 = atc_valid;
      16'b0000000000001000: n6554 = atc_valid;
      16'b0000000000000100: n6554 = atc_valid;
      16'b0000000000000010: n6554 = atc_valid;
      16'b0000000000000001: n6554 = atc_valid;
      default: n6554 = atc_valid;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6555 = atc_fc;
      16'b0100000000000000: n6555 = atc_fc;
      16'b0010000000000000: n6555 = n8003;
      16'b0001000000000000: n6555 = atc_fc;
      16'b0000100000000000: n6555 = atc_fc;
      16'b0000010000000000: n6555 = atc_fc;
      16'b0000001000000000: n6555 = atc_fc;
      16'b0000000100000000: n6555 = atc_fc;
      16'b0000000010000000: n6555 = atc_fc;
      16'b0000000001000000: n6555 = atc_fc;
      16'b0000000000100000: n6555 = atc_fc;
      16'b0000000000010000: n6555 = atc_fc;
      16'b0000000000001000: n6555 = atc_fc;
      16'b0000000000000100: n6555 = atc_fc;
      16'b0000000000000010: n6555 = atc_fc;
      16'b0000000000000001: n6555 = atc_fc;
      default: n6555 = atc_fc;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6556 = atc_is_insn;
      16'b0100000000000000: n6556 = atc_is_insn;
      16'b0010000000000000: n6556 = n8038;
      16'b0001000000000000: n6556 = atc_is_insn;
      16'b0000100000000000: n6556 = atc_is_insn;
      16'b0000010000000000: n6556 = atc_is_insn;
      16'b0000001000000000: n6556 = atc_is_insn;
      16'b0000000100000000: n6556 = atc_is_insn;
      16'b0000000010000000: n6556 = atc_is_insn;
      16'b0000000001000000: n6556 = atc_is_insn;
      16'b0000000000100000: n6556 = atc_is_insn;
      16'b0000000000010000: n6556 = atc_is_insn;
      16'b0000000000001000: n6556 = atc_is_insn;
      16'b0000000000000100: n6556 = atc_is_insn;
      16'b0000000000000010: n6556 = atc_is_insn;
      16'b0000000000000001: n6556 = atc_is_insn;
      default: n6556 = atc_is_insn;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6557 = atc_shift;
      16'b0100000000000000: n6557 = atc_shift;
      16'b0010000000000000: n6557 = n7933;
      16'b0001000000000000: n6557 = atc_shift;
      16'b0000100000000000: n6557 = atc_shift;
      16'b0000010000000000: n6557 = atc_shift;
      16'b0000001000000000: n6557 = atc_shift;
      16'b0000000100000000: n6557 = atc_shift;
      16'b0000000010000000: n6557 = atc_shift;
      16'b0000000001000000: n6557 = atc_shift;
      16'b0000000000100000: n6557 = atc_shift;
      16'b0000000000010000: n6557 = atc_shift;
      16'b0000000000001000: n6557 = atc_shift;
      16'b0000000000000100: n6557 = atc_shift;
      16'b0000000000000010: n6557 = atc_shift;
      16'b0000000000000001: n6557 = atc_shift;
      default: n6557 = atc_shift;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6559 = atc_global;
      16'b0100000000000000: n6559 = atc_global;
      16'b0010000000000000: n6559 = n8073;
      16'b0001000000000000: n6559 = atc_global;
      16'b0000100000000000: n6559 = atc_global;
      16'b0000010000000000: n6559 = atc_global;
      16'b0000001000000000: n6559 = atc_global;
      16'b0000000100000000: n6559 = atc_global;
      16'b0000000010000000: n6559 = atc_global;
      16'b0000000001000000: n6559 = atc_global;
      16'b0000000000100000: n6559 = atc_global;
      16'b0000000000010000: n6559 = atc_global;
      16'b0000000000001000: n6559 = atc_global;
      16'b0000000000000100: n6559 = atc_global;
      16'b0000000000000010: n6559 = atc_global;
      16'b0000000000000001: n6559 = atc_global;
      default: n6559 = atc_global;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6560 = atc_rr;
      16'b0100000000000000: n6560 = atc_rr;
      16'b0010000000000000: n6560 = n6536;
      16'b0001000000000000: n6560 = atc_rr;
      16'b0000100000000000: n6560 = atc_rr;
      16'b0000010000000000: n6560 = atc_rr;
      16'b0000001000000000: n6560 = atc_rr;
      16'b0000000100000000: n6560 = atc_rr;
      16'b0000000010000000: n6560 = atc_rr;
      16'b0000000001000000: n6560 = atc_rr;
      16'b0000000000100000: n6560 = atc_rr;
      16'b0000000000010000: n6560 = atc_rr;
      16'b0000000000001000: n6560 = atc_rr;
      16'b0000000000000100: n6560 = atc_rr;
      16'b0000000000000010: n6560 = atc_rr;
      16'b0000000000000001: n6560 = atc_rr;
      default: n6560 = atc_rr;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6563 = 1'b1;
      16'b0100000000000000: n6563 = 1'b1;
      16'b0010000000000000: n6563 = walker_completed;
      16'b0001000000000000: n6563 = walker_completed;
      16'b0000100000000000: n6563 = walker_completed;
      16'b0000010000000000: n6563 = walker_completed;
      16'b0000001000000000: n6563 = walker_completed;
      16'b0000000100000000: n6563 = walker_completed;
      16'b0000000010000000: n6563 = walker_completed;
      16'b0000000001000000: n6563 = walker_completed;
      16'b0000000000100000: n6563 = walker_completed;
      16'b0000000000010000: n6563 = walker_completed;
      16'b0000000000001000: n6563 = walker_completed;
      16'b0000000000000100: n6563 = walker_completed;
      16'b0000000000000010: n6563 = walker_completed;
      16'b0000000000000001: n6563 = walker_completed;
      default: n6563 = walker_completed;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6568 = 4'b0000;
      16'b0100000000000000: n6568 = 4'b0000;
      16'b0010000000000000: n6568 = 4'b1110;
      16'b0001000000000000: n6568 = n6481;
      16'b0000100000000000: n6568 = n6407;
      16'b0000010000000000: n6568 = n6198;
      16'b0000001000000000: n6568 = n6139;
      16'b0000000100000000: n6568 = n6001;
      16'b0000000010000000: n6568 = n5934;
      16'b0000000001000000: n6568 = n5569;
      16'b0000000000100000: n6568 = n5438;
      16'b0000000000010000: n6568 = n5025;
      16'b0000000000001000: n6568 = n4894;
      16'b0000000000000100: n6568 = n4485;
      16'b0000000000000010: n6568 = n4380;
      16'b0000000000000001: n6568 = n3978;
      default: n6568 = 4'b0000;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6569 = walk_log_base;
      16'b0100000000000000: n6569 = walk_log_base;
      16'b0010000000000000: n6569 = walk_log_base;
      16'b0001000000000000: n6569 = walk_log_base;
      16'b0000100000000000: n6569 = n6408;
      16'b0000010000000000: n6569 = walk_log_base;
      16'b0000001000000000: n6569 = walk_log_base;
      16'b0000000100000000: n6569 = walk_log_base;
      16'b0000000010000000: n6569 = walk_log_base;
      16'b0000000001000000: n6569 = walk_log_base;
      16'b0000000000100000: n6569 = walk_log_base;
      16'b0000000000010000: n6569 = walk_log_base;
      16'b0000000000001000: n6569 = walk_log_base;
      16'b0000000000000100: n6569 = walk_log_base;
      16'b0000000000000010: n6569 = walk_log_base;
      16'b0000000000000001: n6569 = n3979;
      default: n6569 = walk_log_base;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6570 = walk_phys_base;
      16'b0100000000000000: n6570 = walk_phys_base;
      16'b0010000000000000: n6570 = walk_phys_base;
      16'b0001000000000000: n6570 = walk_phys_base;
      16'b0000100000000000: n6570 = n6409;
      16'b0000010000000000: n6570 = walk_phys_base;
      16'b0000001000000000: n6570 = walk_phys_base;
      16'b0000000100000000: n6570 = walk_phys_base;
      16'b0000000010000000: n6570 = walk_phys_base;
      16'b0000000001000000: n6570 = walk_phys_base;
      16'b0000000000100000: n6570 = walk_phys_base;
      16'b0000000000010000: n6570 = walk_phys_base;
      16'b0000000000001000: n6570 = walk_phys_base;
      16'b0000000000000100: n6570 = walk_phys_base;
      16'b0000000000000010: n6570 = walk_phys_base;
      16'b0000000000000001: n6570 = n3981;
      default: n6570 = walk_phys_base;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6571 = walk_page_shift;
      16'b0100000000000000: n6571 = walk_page_shift;
      16'b0010000000000000: n6571 = walk_page_shift;
      16'b0001000000000000: n6571 = walk_page_shift;
      16'b0000100000000000: n6571 = n6410;
      16'b0000010000000000: n6571 = walk_page_shift;
      16'b0000001000000000: n6571 = walk_page_shift;
      16'b0000000100000000: n6571 = walk_page_shift;
      16'b0000000010000000: n6571 = walk_page_shift;
      16'b0000000001000000: n6571 = walk_page_shift;
      16'b0000000000100000: n6571 = walk_page_shift;
      16'b0000000000010000: n6571 = walk_page_shift;
      16'b0000000000001000: n6571 = walk_page_shift;
      16'b0000000000000100: n6571 = walk_page_shift;
      16'b0000000000000010: n6571 = walk_page_shift;
      16'b0000000000000001: n6571 = n3982;
      default: n6571 = walk_page_shift;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6573 = walk_level;
      16'b0100000000000000: n6573 = walk_level;
      16'b0010000000000000: n6573 = walk_level;
      16'b0001000000000000: n6573 = walk_level;
      16'b0000100000000000: n6573 = walk_level;
      16'b0000010000000000: n6573 = walk_level;
      16'b0000001000000000: n6573 = walk_level;
      16'b0000000100000000: n6573 = walk_level;
      16'b0000000010000000: n6573 = walk_level;
      16'b0000000001000000: n6573 = n5570;
      16'b0000000000100000: n6573 = n5439;
      16'b0000000000010000: n6573 = n5026;
      16'b0000000000001000: n6573 = n4895;
      16'b0000000000000100: n6573 = n4486;
      16'b0000000000000010: n6573 = n4381;
      16'b0000000000000001: n6573 = n3985;
      default: n6573 = walk_level;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6574 = walk_desc;
      16'b0100000000000000: n6574 = walk_desc;
      16'b0010000000000000: n6574 = walk_desc;
      16'b0001000000000000: n6574 = walk_desc;
      16'b0000100000000000: n6574 = walk_desc;
      16'b0000010000000000: n6574 = n6199;
      16'b0000001000000000: n6574 = n6140;
      16'b0000000100000000: n6574 = walk_desc;
      16'b0000000010000000: n6574 = n5935;
      16'b0000000001000000: n6574 = walk_desc;
      16'b0000000000100000: n6574 = n5440;
      16'b0000000000010000: n6574 = walk_desc;
      16'b0000000000001000: n6574 = n4896;
      16'b0000000000000100: n6574 = walk_desc;
      16'b0000000000000010: n6574 = n4382;
      16'b0000000000000001: n6574 = walk_desc;
      default: n6574 = walk_desc;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6575 = walk_desc_high;
      16'b0100000000000000: n6575 = walk_desc_high;
      16'b0010000000000000: n6575 = walk_desc_high;
      16'b0001000000000000: n6575 = walk_desc_high;
      16'b0000100000000000: n6575 = walk_desc_high;
      16'b0000010000000000: n6575 = walk_desc_high;
      16'b0000001000000000: n6575 = n6141;
      16'b0000000100000000: n6575 = walk_desc_high;
      16'b0000000010000000: n6575 = n5936;
      16'b0000000001000000: n6575 = walk_desc_high;
      16'b0000000000100000: n6575 = n5441;
      16'b0000000000010000: n6575 = walk_desc_high;
      16'b0000000000001000: n6575 = n4897;
      16'b0000000000000100: n6575 = walk_desc_high;
      16'b0000000000000010: n6575 = n4383;
      16'b0000000000000001: n6575 = walk_desc_high;
      default: n6575 = walk_desc_high;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6576 = walk_desc_low;
      16'b0100000000000000: n6576 = walk_desc_low;
      16'b0010000000000000: n6576 = walk_desc_low;
      16'b0001000000000000: n6576 = walk_desc_low;
      16'b0000100000000000: n6576 = walk_desc_low;
      16'b0000010000000000: n6576 = n6200;
      16'b0000001000000000: n6576 = walk_desc_low;
      16'b0000000100000000: n6576 = n6002;
      16'b0000000010000000: n6576 = walk_desc_low;
      16'b0000000001000000: n6576 = n5571;
      16'b0000000000100000: n6576 = walk_desc_low;
      16'b0000000000010000: n6576 = n5027;
      16'b0000000000001000: n6576 = walk_desc_low;
      16'b0000000000000100: n6576 = n4487;
      16'b0000000000000010: n6576 = walk_desc_low;
      16'b0000000000000001: n6576 = walk_desc_low;
      default: n6576 = walk_desc_low;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6577 = walk_desc_is_long;
      16'b0100000000000000: n6577 = walk_desc_is_long;
      16'b0010000000000000: n6577 = walk_desc_is_long;
      16'b0001000000000000: n6577 = walk_desc_is_long;
      16'b0000100000000000: n6577 = walk_desc_is_long;
      16'b0000010000000000: n6577 = walk_desc_is_long;
      16'b0000001000000000: n6577 = n6142;
      16'b0000000100000000: n6577 = walk_desc_is_long;
      16'b0000000010000000: n6577 = n5937;
      16'b0000000001000000: n6577 = walk_desc_is_long;
      16'b0000000000100000: n6577 = n5442;
      16'b0000000000010000: n6577 = walk_desc_is_long;
      16'b0000000000001000: n6577 = n4898;
      16'b0000000000000100: n6577 = walk_desc_is_long;
      16'b0000000000000010: n6577 = n4384;
      16'b0000000000000001: n6577 = walk_desc_is_long;
      default: n6577 = walk_desc_is_long;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6578 = walk_addr;
      16'b0100000000000000: n6578 = walk_addr;
      16'b0010000000000000: n6578 = walk_addr;
      16'b0001000000000000: n6578 = walk_addr;
      16'b0000100000000000: n6578 = walk_addr;
      16'b0000010000000000: n6578 = walk_addr;
      16'b0000001000000000: n6578 = walk_addr;
      16'b0000000100000000: n6578 = walk_addr;
      16'b0000000010000000: n6578 = walk_addr;
      16'b0000000001000000: n6578 = n5572;
      16'b0000000000100000: n6578 = n5443;
      16'b0000000000010000: n6578 = n5028;
      16'b0000000000001000: n6578 = n4899;
      16'b0000000000000100: n6578 = n4488;
      16'b0000000000000010: n6578 = n4385;
      16'b0000000000000001: n6578 = n3986;
      default: n6578 = walk_addr;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6579 = walk_vpn;
      16'b0100000000000000: n6579 = walk_vpn;
      16'b0010000000000000: n6579 = walk_vpn;
      16'b0001000000000000: n6579 = walk_vpn;
      16'b0000100000000000: n6579 = walk_vpn;
      16'b0000010000000000: n6579 = walk_vpn;
      16'b0000001000000000: n6579 = walk_vpn;
      16'b0000000100000000: n6579 = walk_vpn;
      16'b0000000010000000: n6579 = walk_vpn;
      16'b0000000001000000: n6579 = walk_vpn;
      16'b0000000000100000: n6579 = walk_vpn;
      16'b0000000000010000: n6579 = walk_vpn;
      16'b0000000000001000: n6579 = walk_vpn;
      16'b0000000000000100: n6579 = walk_vpn;
      16'b0000000000000010: n6579 = walk_vpn;
      16'b0000000000000001: n6579 = n3987;
      default: n6579 = walk_vpn;
    endcase
  assign n6581 = n3991[0]; // extract
  assign n6582 = n6414[0]; // extract
  assign n6583 = walk_attr[0]; // extract
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6584 = n6583;
      16'b0100000000000000: n6584 = n6583;
      16'b0010000000000000: n6584 = n6583;
      16'b0001000000000000: n6584 = n6583;
      16'b0000100000000000: n6584 = n6582;
      16'b0000010000000000: n6584 = n6583;
      16'b0000001000000000: n6584 = n6583;
      16'b0000000100000000: n6584 = n6583;
      16'b0000000010000000: n6584 = n6583;
      16'b0000000001000000: n6584 = n6583;
      16'b0000000000100000: n6584 = n6583;
      16'b0000000000010000: n6584 = n6583;
      16'b0000000000001000: n6584 = n6583;
      16'b0000000000000100: n6584 = n6583;
      16'b0000000000000010: n6584 = n6583;
      16'b0000000000000001: n6584 = n6581;
      default: n6584 = n6583;
    endcase
  assign n6585 = n3991[1]; // extract
  assign n6586 = n6414[1]; // extract
  assign n6587 = walk_attr[1]; // extract
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6588 = n6587;
      16'b0100000000000000: n6588 = n6587;
      16'b0010000000000000: n6588 = n6587;
      16'b0001000000000000: n6588 = n6484;
      16'b0000100000000000: n6588 = n6586;
      16'b0000010000000000: n6588 = n6587;
      16'b0000001000000000: n6588 = n6587;
      16'b0000000100000000: n6588 = n6587;
      16'b0000000010000000: n6588 = n6587;
      16'b0000000001000000: n6588 = n6587;
      16'b0000000000100000: n6588 = n6587;
      16'b0000000000010000: n6588 = n6587;
      16'b0000000000001000: n6588 = n6587;
      16'b0000000000000100: n6588 = n6587;
      16'b0000000000000010: n6588 = n6587;
      16'b0000000000000001: n6588 = n6585;
      default: n6588 = n6587;
    endcase
  assign n6589 = n3991[3:2]; // extract
  assign n6590 = n6414[3:2]; // extract
  assign n6591 = walk_attr[3:2]; // extract
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6592 = n6591;
      16'b0100000000000000: n6592 = n6591;
      16'b0010000000000000: n6592 = n6591;
      16'b0001000000000000: n6592 = n6591;
      16'b0000100000000000: n6592 = n6590;
      16'b0000010000000000: n6592 = n6591;
      16'b0000001000000000: n6592 = n6591;
      16'b0000000100000000: n6592 = n6591;
      16'b0000000010000000: n6592 = n6591;
      16'b0000000001000000: n6592 = n6591;
      16'b0000000000100000: n6592 = n6591;
      16'b0000000000010000: n6592 = n6591;
      16'b0000000000001000: n6592 = n6591;
      16'b0000000000000100: n6592 = n6591;
      16'b0000000000000010: n6592 = n6591;
      16'b0000000000000001: n6592 = n6589;
      default: n6592 = n6591;
    endcase
  assign n6593 = n3991[7:4]; // extract
  assign n6594 = walk_attr[7:4]; // extract
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6595 = n6594;
      16'b0100000000000000: n6595 = n6594;
      16'b0010000000000000: n6595 = n6594;
      16'b0001000000000000: n6595 = n6594;
      16'b0000100000000000: n6595 = n6594;
      16'b0000010000000000: n6595 = n6594;
      16'b0000001000000000: n6595 = n6594;
      16'b0000000100000000: n6595 = n6594;
      16'b0000000010000000: n6595 = n6594;
      16'b0000000001000000: n6595 = n6594;
      16'b0000000000100000: n6595 = n6594;
      16'b0000000000010000: n6595 = n6594;
      16'b0000000000001000: n6595 = n6594;
      16'b0000000000000100: n6595 = n6594;
      16'b0000000000000010: n6595 = n6594;
      16'b0000000000000001: n6595 = n6593;
      default: n6595 = n6594;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6596 = walk_global;
      16'b0100000000000000: n6596 = walk_global;
      16'b0010000000000000: n6596 = walk_global;
      16'b0001000000000000: n6596 = walk_global;
      16'b0000100000000000: n6596 = n6415;
      16'b0000010000000000: n6596 = walk_global;
      16'b0000001000000000: n6596 = walk_global;
      16'b0000000100000000: n6596 = walk_global;
      16'b0000000010000000: n6596 = walk_global;
      16'b0000000001000000: n6596 = walk_global;
      16'b0000000000100000: n6596 = walk_global;
      16'b0000000000010000: n6596 = walk_global;
      16'b0000000000001000: n6596 = walk_global;
      16'b0000000000000100: n6596 = walk_global;
      16'b0000000000000010: n6596 = walk_global;
      16'b0000000000000001: n6596 = walk_global;
      default: n6596 = walk_global;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6597 = walk_supervisor;
      16'b0100000000000000: n6597 = walk_supervisor;
      16'b0010000000000000: n6597 = walk_supervisor;
      16'b0001000000000000: n6597 = walk_supervisor;
      16'b0000100000000000: n6597 = walk_supervisor;
      16'b0000010000000000: n6597 = walk_supervisor;
      16'b0000001000000000: n6597 = walk_supervisor;
      16'b0000000100000000: n6597 = walk_supervisor;
      16'b0000000010000000: n6597 = walk_supervisor;
      16'b0000000001000000: n6597 = n5574;
      16'b0000000000100000: n6597 = walk_supervisor;
      16'b0000000000010000: n6597 = n5030;
      16'b0000000000001000: n6597 = walk_supervisor;
      16'b0000000000000100: n6597 = n4490;
      16'b0000000000000010: n6597 = walk_supervisor;
      16'b0000000000000001: n6597 = n3993;
      default: n6597 = walk_supervisor;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6598 = indirect_addr;
      16'b0100000000000000: n6598 = indirect_addr;
      16'b0010000000000000: n6598 = indirect_addr;
      16'b0001000000000000: n6598 = indirect_addr;
      16'b0000100000000000: n6598 = indirect_addr;
      16'b0000010000000000: n6598 = indirect_addr;
      16'b0000001000000000: n6598 = indirect_addr;
      16'b0000000100000000: n6598 = n6004;
      16'b0000000010000000: n6598 = n5939;
      16'b0000000001000000: n6598 = n5575;
      16'b0000000000100000: n6598 = n5445;
      16'b0000000000010000: n6598 = n5031;
      16'b0000000000001000: n6598 = n4901;
      16'b0000000000000100: n6598 = indirect_addr;
      16'b0000000000000010: n6598 = indirect_addr;
      16'b0000000000000001: n6598 = indirect_addr;
      default: n6598 = indirect_addr;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6599 = indirect_target_long;
      16'b0100000000000000: n6599 = indirect_target_long;
      16'b0010000000000000: n6599 = indirect_target_long;
      16'b0001000000000000: n6599 = indirect_target_long;
      16'b0000100000000000: n6599 = indirect_target_long;
      16'b0000010000000000: n6599 = indirect_target_long;
      16'b0000001000000000: n6599 = indirect_target_long;
      16'b0000000100000000: n6599 = n6005;
      16'b0000000010000000: n6599 = n5940;
      16'b0000000001000000: n6599 = n5576;
      16'b0000000000100000: n6599 = n5446;
      16'b0000000000010000: n6599 = n5032;
      16'b0000000000001000: n6599 = n4902;
      16'b0000000000000100: n6599 = indirect_target_long;
      16'b0000000000000010: n6599 = indirect_target_long;
      16'b0000000000000001: n6599 = indirect_target_long;
      default: n6599 = indirect_target_long;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6600 = walk_limit_valid;
      16'b0100000000000000: n6600 = walk_limit_valid;
      16'b0010000000000000: n6600 = walk_limit_valid;
      16'b0001000000000000: n6600 = walk_limit_valid;
      16'b0000100000000000: n6600 = walk_limit_valid;
      16'b0000010000000000: n6600 = walk_limit_valid;
      16'b0000001000000000: n6600 = walk_limit_valid;
      16'b0000000100000000: n6600 = walk_limit_valid;
      16'b0000000010000000: n6600 = walk_limit_valid;
      16'b0000000001000000: n6600 = n5577;
      16'b0000000000100000: n6600 = n5447;
      16'b0000000000010000: n6600 = n5033;
      16'b0000000000001000: n6600 = n4903;
      16'b0000000000000100: n6600 = n4491;
      16'b0000000000000010: n6600 = n4387;
      16'b0000000000000001: n6600 = n3995;
      default: n6600 = walk_limit_valid;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6601 = walk_limit_lu;
      16'b0100000000000000: n6601 = walk_limit_lu;
      16'b0010000000000000: n6601 = walk_limit_lu;
      16'b0001000000000000: n6601 = walk_limit_lu;
      16'b0000100000000000: n6601 = walk_limit_lu;
      16'b0000010000000000: n6601 = walk_limit_lu;
      16'b0000001000000000: n6601 = walk_limit_lu;
      16'b0000000100000000: n6601 = walk_limit_lu;
      16'b0000000010000000: n6601 = walk_limit_lu;
      16'b0000000001000000: n6601 = n5578;
      16'b0000000000100000: n6601 = walk_limit_lu;
      16'b0000000000010000: n6601 = n5034;
      16'b0000000000001000: n6601 = walk_limit_lu;
      16'b0000000000000100: n6601 = n4492;
      16'b0000000000000010: n6601 = walk_limit_lu;
      16'b0000000000000001: n6601 = walk_limit_lu;
      default: n6601 = walk_limit_lu;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6602 = walk_limit_value;
      16'b0100000000000000: n6602 = walk_limit_value;
      16'b0010000000000000: n6602 = walk_limit_value;
      16'b0001000000000000: n6602 = walk_limit_value;
      16'b0000100000000000: n6602 = walk_limit_value;
      16'b0000010000000000: n6602 = walk_limit_value;
      16'b0000001000000000: n6602 = walk_limit_value;
      16'b0000000100000000: n6602 = walk_limit_value;
      16'b0000000010000000: n6602 = walk_limit_value;
      16'b0000000001000000: n6602 = n5579;
      16'b0000000000100000: n6602 = walk_limit_value;
      16'b0000000000010000: n6602 = n5035;
      16'b0000000000001000: n6602 = walk_limit_value;
      16'b0000000000000100: n6602 = n4493;
      16'b0000000000000010: n6602 = walk_limit_value;
      16'b0000000000000001: n6602 = walk_limit_value;
      default: n6602 = walk_limit_value;
    endcase
  /* TG68K_PMMU_030.vhd:1739:7  */
  always @*
    case (n6543)
      16'b1000000000000000: n6604 = desc_update_data;
      16'b0100000000000000: n6604 = desc_update_data;
      16'b0010000000000000: n6604 = desc_update_data;
      16'b0001000000000000: n6604 = desc_update_data;
      16'b0000100000000000: n6604 = n6417;
      16'b0000010000000000: n6604 = desc_update_data;
      16'b0000001000000000: n6604 = desc_update_data;
      16'b0000000100000000: n6604 = desc_update_data;
      16'b0000000010000000: n6604 = desc_update_data;
      16'b0000000001000000: n6604 = desc_update_data;
      16'b0000000000100000: n6604 = desc_update_data;
      16'b0000000000010000: n6604 = desc_update_data;
      16'b0000000000001000: n6604 = desc_update_data;
      16'b0000000000000100: n6604 = desc_update_data;
      16'b0000000000000010: n6604 = desc_update_data;
      16'b0000000000000001: n6604 = desc_update_data;
      default: n6604 = desc_update_data;
    endcase
  assign n6618 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  /* TG68K_PMMU_030.vhd:2766:7  */
  assign n6619 = atc_flush_req ? n6618 : n6554;
  /* TG68K_PMMU_030.vhd:2772:44  */
  assign n6621 = wstate == 4'b0000;
  /* TG68K_PMMU_030.vhd:2772:33  */
  assign n6622 = n6621 & pflush_clear_atc;
  /* TG68K_PMMU_030.vhd:2782:23  */
  assign n6623 = pflush_mode[4:2]; // extract
  /* TG68K_PMMU_030.vhd:2782:38  */
  assign n6625 = n6623 == 3'b001;
  /* TG68K_PMMU_030.vhd:2782:61  */
  assign n6626 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2782:65  */
  assign n6627 = ~n6626;
  /* TG68K_PMMU_030.vhd:2782:46  */
  assign n6628 = n6627 & n6625;
  /* TG68K_PMMU_030.vhd:2787:26  */
  assign n6637 = pflush_mode[4:2]; // extract
  /* TG68K_PMMU_030.vhd:2787:41  */
  assign n6639 = n6637 == 3'b001;
  /* TG68K_PMMU_030.vhd:2787:64  */
  assign n6640 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2787:49  */
  assign n6641 = n6640 & n6639;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6642 = atc_global[7]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6643 = ~n6642;
  assign n6645 = n6619[7]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6646 = n6643 ? 1'b0 : n6645;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6647 = atc_global[6]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6648 = ~n6647;
  assign n6650 = n6619[6]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6651 = n6648 ? 1'b0 : n6650;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6652 = atc_global[5]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6653 = ~n6652;
  assign n6655 = n6619[5]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6656 = n6653 ? 1'b0 : n6655;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6657 = atc_global[4]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6658 = ~n6657;
  assign n6660 = n6619[4]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6661 = n6658 ? 1'b0 : n6660;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6662 = atc_global[3]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6663 = ~n6662;
  assign n6665 = n6619[3]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6666 = n6663 ? 1'b0 : n6665;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6667 = atc_global[2]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6668 = ~n6667;
  assign n6670 = n6619[2]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6671 = n6668 ? 1'b0 : n6670;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6672 = atc_global[1]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6673 = ~n6672;
  assign n6675 = n6619[1]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6676 = n6673 ? 1'b0 : n6675;
  /* TG68K_PMMU_030.vhd:2791:26  */
  assign n6677 = atc_global[0]; // extract
  /* TG68K_PMMU_030.vhd:2791:30  */
  assign n6678 = ~n6677;
  assign n6680 = n6619[0]; // extract
  /* TG68K_PMMU_030.vhd:2791:13  */
  assign n6681 = n6678 ? 1'b0 : n6680;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6682 = atc_valid[7]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6683 = atc_fc[23:21]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6684 = n6683 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6686 = atc_shift[39:35]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6687 = {27'b0, n6686};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6694 = $signed(n6687) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6696 = $signed(n6687) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6697 = n6694 | n6696;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6700 = n6697 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6706 = n6697 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6707 = {26'b0, n6686};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6709 = 32'b11111111111111111111111111111111 << n6707;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6711 = n6700 ? n6709 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6713 = pflush_addr & n6711;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6714 = n6700 ? n6713 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6719 = n6700 ? n6714 : n6706;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6720 = atc_log_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6721 = n6719 == n6720;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6722 = n6721 & n6684;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6723 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6724 = ~n6723;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6725 = atc_global[7]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6726 = ~n6725;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6727 = n6724 | n6726;
  assign n6729 = n6619[7]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6730 = n6734 ? 1'b0 : n6729;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6732 = n6727 & n6722;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6734 = n6732 & n6682;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6735 = atc_valid[6]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6736 = atc_fc[20:18]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6737 = n6736 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6739 = atc_shift[34:30]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6740 = {27'b0, n6739};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6747 = $signed(n6740) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6749 = $signed(n6740) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6750 = n6747 | n6749;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6753 = n6750 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6759 = n6750 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6760 = {26'b0, n6739};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6762 = 32'b11111111111111111111111111111111 << n6760;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6764 = n6753 ? n6762 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6766 = pflush_addr & n6764;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6767 = n6753 ? n6766 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6772 = n6753 ? n6767 : n6759;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6773 = atc_log_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6774 = n6772 == n6773;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6775 = n6774 & n6737;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6776 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6777 = ~n6776;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6778 = atc_global[6]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6779 = ~n6778;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6780 = n6777 | n6779;
  assign n6782 = n6619[6]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6783 = n6787 ? 1'b0 : n6782;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6785 = n6780 & n6775;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6787 = n6785 & n6735;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6788 = atc_valid[5]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6789 = atc_fc[17:15]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6790 = n6789 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6792 = atc_shift[29:25]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6793 = {27'b0, n6792};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6800 = $signed(n6793) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6802 = $signed(n6793) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6803 = n6800 | n6802;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6806 = n6803 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6812 = n6803 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6813 = {26'b0, n6792};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6815 = 32'b11111111111111111111111111111111 << n6813;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6817 = n6806 ? n6815 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6819 = pflush_addr & n6817;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6820 = n6806 ? n6819 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6825 = n6806 ? n6820 : n6812;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6826 = atc_log_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6827 = n6825 == n6826;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6828 = n6827 & n6790;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6829 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6830 = ~n6829;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6831 = atc_global[5]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6832 = ~n6831;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6833 = n6830 | n6832;
  assign n6835 = n6619[5]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6836 = n6840 ? 1'b0 : n6835;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6838 = n6833 & n6828;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6840 = n6838 & n6788;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6841 = atc_valid[4]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6842 = atc_fc[14:12]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6843 = n6842 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6845 = atc_shift[24:20]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6846 = {27'b0, n6845};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6853 = $signed(n6846) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6855 = $signed(n6846) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6856 = n6853 | n6855;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6859 = n6856 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6865 = n6856 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6866 = {26'b0, n6845};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6868 = 32'b11111111111111111111111111111111 << n6866;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6870 = n6859 ? n6868 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6872 = pflush_addr & n6870;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6873 = n6859 ? n6872 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6878 = n6859 ? n6873 : n6865;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6879 = atc_log_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6880 = n6878 == n6879;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6881 = n6880 & n6843;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6882 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6883 = ~n6882;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6884 = atc_global[4]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6885 = ~n6884;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6886 = n6883 | n6885;
  assign n6888 = n6619[4]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6889 = n6893 ? 1'b0 : n6888;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6891 = n6886 & n6881;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6893 = n6891 & n6841;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6894 = atc_valid[3]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6895 = atc_fc[11:9]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6896 = n6895 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6898 = atc_shift[19:15]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6899 = {27'b0, n6898};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6906 = $signed(n6899) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6908 = $signed(n6899) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6909 = n6906 | n6908;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6912 = n6909 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6918 = n6909 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6919 = {26'b0, n6898};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6921 = 32'b11111111111111111111111111111111 << n6919;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6923 = n6912 ? n6921 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6925 = pflush_addr & n6923;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6926 = n6912 ? n6925 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6931 = n6912 ? n6926 : n6918;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6932 = atc_log_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6933 = n6931 == n6932;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6934 = n6933 & n6896;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6935 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6936 = ~n6935;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6937 = atc_global[3]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6938 = ~n6937;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6939 = n6936 | n6938;
  assign n6941 = n6619[3]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6942 = n6946 ? 1'b0 : n6941;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6944 = n6939 & n6934;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6946 = n6944 & n6894;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n6947 = atc_valid[2]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n6948 = atc_fc[8:6]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n6949 = n6948 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n6951 = atc_shift[14:10]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n6952 = {27'b0, n6951};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n6959 = $signed(n6952) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n6961 = $signed(n6952) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n6962 = n6959 | n6961;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6965 = n6962 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n6971 = n6962 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n6972 = {26'b0, n6951};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n6974 = 32'b11111111111111111111111111111111 << n6972;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n6976 = n6965 ? n6974 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n6978 = pflush_addr & n6976;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n6979 = n6965 ? n6978 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n6984 = n6965 ? n6979 : n6971;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n6985 = atc_log_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n6986 = n6984 == n6985;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n6987 = n6986 & n6949;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n6988 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n6989 = ~n6988;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n6990 = atc_global[2]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n6991 = ~n6990;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n6992 = n6989 | n6991;
  assign n6994 = n6619[2]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6995 = n6999 ? 1'b0 : n6994;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n6997 = n6992 & n6987;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n6999 = n6997 & n6947;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n7000 = atc_valid[1]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n7001 = atc_fc[5:3]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n7002 = n7001 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n7004 = atc_shift[9:5]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n7005 = {27'b0, n7004};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n7012 = $signed(n7005) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n7014 = $signed(n7005) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n7015 = n7012 | n7014;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n7018 = n7015 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n7024 = n7015 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n7025 = {26'b0, n7004};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n7027 = 32'b11111111111111111111111111111111 << n7025;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n7029 = n7018 ? n7027 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n7031 = pflush_addr & n7029;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n7032 = n7018 ? n7031 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n7037 = n7018 ? n7032 : n7024;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n7038 = atc_log_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n7039 = n7037 == n7038;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n7040 = n7039 & n7002;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n7041 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n7042 = ~n7041;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n7043 = atc_global[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n7044 = ~n7043;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n7045 = n7042 | n7044;
  assign n7047 = n6619[1]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n7048 = n7052 ? 1'b0 : n7047;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n7050 = n7045 & n7040;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n7052 = n7050 & n7000;
  /* TG68K_PMMU_030.vhd:2801:25  */
  assign n7053 = atc_valid[0]; // extract
  /* TG68K_PMMU_030.vhd:2803:24  */
  assign n7054 = atc_fc[2:0]; // extract
  /* TG68K_PMMU_030.vhd:2803:28  */
  assign n7055 = n7054 == pflush_fc;
  /* TG68K_PMMU_030.vhd:2803:77  */
  assign n7057 = atc_shift[4:0]; // extract
  /* TG68K_PMMU_030.vhd:2803:68  */
  assign n7058 = {27'b0, n7057};  //  uext
  /* TG68K_PMMU_030.vhd:325:14  */
  assign n7065 = $signed(n7058) <= $signed(32'b00000000000000000000000000000000);
  /* TG68K_PMMU_030.vhd:325:28  */
  assign n7067 = $signed(n7058) >= $signed(32'b00000000000000000000000000100000);
  /* TG68K_PMMU_030.vhd:325:19  */
  assign n7068 = n7065 | n7067;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n7071 = n7068 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n7077 = n7068 ? pflush_addr : 32'bX;
  /* TG68K_PMMU_030.vhd:330:57  */
  assign n7078 = {26'b0, n7057};  //  uext
  /* TG68K_PMMU_030.vhd:330:30  */
  assign n7080 = 32'b11111111111111111111111111111111 << n7078;
  /* TG68K_PMMU_030.vhd:330:5  */
  assign n7082 = n7071 ? n7080 : 32'b11111111111111111111111111111111;
  /* TG68K_PMMU_030.vhd:331:20  */
  assign n7084 = pflush_addr & n7082;
  /* TG68K_PMMU_030.vhd:331:5  */
  assign n7085 = n7071 ? n7084 : pflush_addr;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n7090 = n7071 ? n7085 : n7077;
  /* TG68K_PMMU_030.vhd:2803:96  */
  assign n7091 = atc_log_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:2803:82  */
  assign n7092 = n7090 == n7091;
  /* TG68K_PMMU_030.vhd:2803:40  */
  assign n7093 = n7092 & n7055;
  /* TG68K_PMMU_030.vhd:2805:31  */
  assign n7094 = pflush_mode[1]; // extract
  /* TG68K_PMMU_030.vhd:2805:35  */
  assign n7095 = ~n7094;
  /* TG68K_PMMU_030.vhd:2805:54  */
  assign n7096 = atc_global[0]; // extract
  /* TG68K_PMMU_030.vhd:2805:58  */
  assign n7097 = ~n7096;
  /* TG68K_PMMU_030.vhd:2805:41  */
  assign n7098 = n7095 | n7097;
  assign n7100 = n6619[0]; // extract
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n7101 = n7105 ? 1'b0 : n7100;
  /* TG68K_PMMU_030.vhd:2803:15  */
  assign n7103 = n7098 & n7093;
  /* TG68K_PMMU_030.vhd:2801:13  */
  assign n7105 = n7103 & n7053;
  assign n7106 = {n6730, n6783, n6836, n6889, n6942, n6995, n7048, n7101};
  assign n7107 = {n6646, n6651, n6656, n6661, n6666, n6671, n6676, n6681};
  /* TG68K_PMMU_030.vhd:2787:9  */
  assign n7108 = n6641 ? n7107 : n7106;
  assign n7109 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  /* TG68K_PMMU_030.vhd:2782:9  */
  assign n7110 = n6628 ? n7109 : n7108;
  /* TG68K_PMMU_030.vhd:2772:7  */
  assign n7111 = n6622 ? n7110 : n6619;
  /* TG68K_PMMU_030.vhd:2817:29  */
  assign n7112 = walker_fault_ack & walker_fault;
  /* TG68K_PMMU_030.vhd:2817:7  */
  assign n7114 = n7112 ? 1'b0 : n6549;
  /* TG68K_PMMU_030.vhd:2823:33  */
  assign n7115 = walker_completed_ack & walker_completed;
  /* TG68K_PMMU_030.vhd:2823:7  */
  assign n7117 = n7115 ? 1'b0 : n6563;
  assign n7149 = {n6595, n6592, n6588, n6584};
  assign n7178 = {32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000};
  assign n7180 = {32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000};
  assign n7182 = {4'b0000, 4'b0000, 4'b0000, 4'b0000, 4'b0000, 4'b0000, 4'b0000, 4'b0000};
  assign n7184 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  assign n7186 = {3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000, 3'b000};
  assign n7188 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  assign n7190 = {5'b01100, 5'b01100, 5'b01100, 5'b01100, 5'b01100, 5'b01100, 5'b01100, 5'b01100};
  /* TG68K_PMMU_030.vhd:2834:14  */
  assign n7263 = ~tc_en;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n7284 = tt0[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n7286 = tt0[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n7288 = tt0[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n7290 = tt0[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n7292 = tt0[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n7294 = addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n7296 = ~n7284;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7299 = n7296 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7306 = n7296 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n7311 = n7294 ^ n7286;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n7312 = ~n7288;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n7313 = n7311 & n7312;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n7315 = n7313 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n7318 = n7299 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n7321 = n7299 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n7322 = n7315 ? n7318 : n7321;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n7324 = n7299 ? n7322 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n7326 = fc ^ n7290;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n7327 = ~n7292;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n7328 = n7326 & n7327;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n7330 = n7328 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n7333 = n7299 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n7336 = n7299 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n7337 = n7330 ? n7333 : n7336;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n7339 = n7299 ? n7337 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n7341 = n7324 & n7284;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n7342 = n7339 & n7341;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n7344 = n7299 ? 1'b1 : n7306;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n7352 = tt0[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n7353 = ~n7352;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n7355 = tt0[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n7356 = ~n7355;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n7358 = 1'b1 & n7356;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7360 = n7373 ? 1'b0 : n7344;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n7365 = n7299 & n7358;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n7367 = n7365 & n7299;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7371 = n7367 & n7353;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7373 = n7371 & n7299;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n7376 = n7299 ? 1'b0 : n7306;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7381 = n7342 ? n7360 : n7376;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7384 = n7299 ? n7381 : n7306;
  /* TG68K_PMMU_030.vhd:421:21  */
  assign n7409 = tt1[15]; // extract
  /* TG68K_PMMU_030.vhd:422:21  */
  assign n7411 = tt1[31:24]; // extract
  /* TG68K_PMMU_030.vhd:423:21  */
  assign n7413 = tt1[23:16]; // extract
  /* TG68K_PMMU_030.vhd:426:21  */
  assign n7415 = tt1[6:4]; // extract
  /* TG68K_PMMU_030.vhd:427:21  */
  assign n7417 = tt1[2:0]; // extract
  /* TG68K_PMMU_030.vhd:428:23  */
  assign n7419 = addr_log[31:24]; // extract
  /* TG68K_PMMU_030.vhd:431:15  */
  assign n7421 = ~n7409;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7424 = n7421 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7431 = n7421 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:18  */
  assign n7436 = n7419 ^ n7411;
  /* TG68K_PMMU_030.vhd:443:33  */
  assign n7437 = ~n7413;
  /* TG68K_PMMU_030.vhd:443:28  */
  assign n7438 = n7436 & n7437;
  /* TG68K_PMMU_030.vhd:443:44  */
  assign n7440 = n7438 == 8'b00000000;
  /* TG68K_PMMU_030.vhd:444:7  */
  assign n7443 = n7424 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:446:7  */
  assign n7446 = n7424 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n7447 = n7440 ? n7443 : n7446;
  /* TG68K_PMMU_030.vhd:443:5  */
  assign n7449 = n7424 ? n7447 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:13  */
  assign n7451 = fc ^ n7415;
  /* TG68K_PMMU_030.vhd:455:31  */
  assign n7452 = ~n7417;
  /* TG68K_PMMU_030.vhd:455:26  */
  assign n7453 = n7451 & n7452;
  /* TG68K_PMMU_030.vhd:455:45  */
  assign n7455 = n7453 == 3'b000;
  /* TG68K_PMMU_030.vhd:456:7  */
  assign n7458 = n7424 ? 1'b1 : 1'bX;
  /* TG68K_PMMU_030.vhd:458:7  */
  assign n7461 = n7424 ? 1'b0 : 1'bX;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n7462 = n7455 ? n7458 : n7461;
  /* TG68K_PMMU_030.vhd:455:5  */
  assign n7464 = n7424 ? n7462 : 1'bX;
  /* TG68K_PMMU_030.vhd:462:21  */
  assign n7466 = n7449 & n7409;
  /* TG68K_PMMU_030.vhd:462:42  */
  assign n7467 = n7464 & n7466;
  /* TG68K_PMMU_030.vhd:463:7  */
  assign n7469 = n7424 ? 1'b1 : n7431;
  /* TG68K_PMMU_030.vhd:475:12  */
  assign n7477 = tt1[8]; // extract
  /* TG68K_PMMU_030.vhd:475:16  */
  assign n7478 = ~n7477;
  /* TG68K_PMMU_030.vhd:480:17  */
  assign n7480 = tt1[9]; // extract
  /* TG68K_PMMU_030.vhd:480:21  */
  assign n7481 = ~n7480;
  /* TG68K_PMMU_030.vhd:480:27  */
  assign n7483 = 1'b1 & n7481;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7485 = n7498 ? 1'b0 : n7469;
  /* TG68K_PMMU_030.vhd:480:9  */
  assign n7490 = n7424 & n7483;
  /* TG68K_PMMU_030.vhd:476:9  */
  assign n7492 = n7490 & n7424;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7496 = n7492 & n7478;
  /* TG68K_PMMU_030.vhd:475:7  */
  assign n7498 = n7496 & n7424;
  /* TG68K_PMMU_030.vhd:502:7  */
  assign n7501 = n7424 ? 1'b0 : n7431;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7506 = n7467 ? n7485 : n7501;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7509 = n7424 ? n7506 : n7431;
  /* TG68K_PMMU_030.vhd:2842:25  */
  assign n7514 = n7384 | n7509;
  /* TG68K_PMMU_030.vhd:2842:66  */
  assign n7515 = ~translation_pending;
  /* TG68K_PMMU_030.vhd:2842:83  */
  assign n7517 = wstate == 4'b0000;
  /* TG68K_PMMU_030.vhd:2842:72  */
  assign n7518 = n7517 & n7515;
  /* TG68K_PMMU_030.vhd:2842:109  */
  assign n7519 = ~walker_fault;
  /* TG68K_PMMU_030.vhd:2842:92  */
  assign n7520 = n7519 & n7518;
  /* TG68K_PMMU_030.vhd:2842:144  */
  assign n7521 = ~walker_fault_ack_pending;
  /* TG68K_PMMU_030.vhd:2842:115  */
  assign n7522 = n7521 & n7520;
  /* TG68K_PMMU_030.vhd:2842:42  */
  assign n7523 = n7514 | n7522;
  /* TG68K_PMMU_030.vhd:2842:7  */
  assign n7526 = n7523 ? 1'b0 : 1'b1;
  /* TG68K_PMMU_030.vhd:2834:5  */
  assign n7528 = n7263 ? 1'b0 : n7526;
  /* TG68K_PMMU_030.vhd:2853:15  */
  assign n7534 = ~nreset;
  /* TG68K_PMMU_030.vhd:2870:45  */
  assign n7536 = ~ptest_req_prev;
  /* TG68K_PMMU_030.vhd:2870:26  */
  assign n7537 = n7536 & ptest_req;
  /* TG68K_PMMU_030.vhd:2870:7  */
  assign n7540 = n7537 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:2877:47  */
  assign n7541 = ~pflush_req_prev;
  /* TG68K_PMMU_030.vhd:2877:27  */
  assign n7542 = n7541 & pflush_req;
  /* TG68K_PMMU_030.vhd:2881:34  */
  assign n7543 = pmmu_brief[12:8]; // extract
  /* TG68K_PMMU_030.vhd:2877:7  */
  assign n7548 = n7542 ? 1'b1 : 1'b0;
  /* TG68K_PMMU_030.vhd:2892:45  */
  assign n7554 = ~pload_req_prev;
  /* TG68K_PMMU_030.vhd:2892:26  */
  assign n7555 = n7554 & pload_req;
  /* TG68K_PMMU_030.vhd:2899:31  */
  assign n7556 = pmmu_brief[9]; // extract
  /* TG68K_PMMU_030.vhd:2901:7  */
  assign n7558 = pload_active ? 1'b0 : pload_active;
  /* TG68K_PMMU_030.vhd:2892:7  */
  assign n7560 = n7555 ? 1'b1 : n7558;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7602 = reg_we ? n301 : tc;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7603 <= 32'b00000000000000000000000000000000;
    else
      n7603 <= n7602;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7604 = reg_we ? n302 : crp_h;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7605 <= 32'b00000000000000000000000000000000;
    else
      n7605 <= n7604;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7606 = reg_we ? n303 : crp_l;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7607 <= 32'b00000000000000000000000000000000;
    else
      n7607 <= n7606;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7608 = reg_we ? n304 : srp_h;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7609 <= 32'b00000000000000000000000000000000;
    else
      n7609 <= n7608;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7610 = reg_we ? n305 : srp_l;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7611 <= 32'b00000000000000000000000000000000;
    else
      n7611 <= n7610;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7612 = reg_we ? n306 : tt0;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7613 <= 32'b00000000000000000000000000000000;
    else
      n7613 <= n7612;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7614 = reg_we ? n307 : tt1;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7615 <= 32'b00000000000000000000000000000000;
    else
      n7615 <= n7614;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7616 <= 32'b00000000000000000000000000000000;
    else
      n7616 <= n362;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7617 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7618 = n7617 ? n6548 : desc_addr_reg;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7619 <= n7618;
  initial
    n7619 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7620 <= 32'b00000000000000000000000000000000;
    else
      n7620 <= n3691;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7621 <= 1'b0;
    else
      n7621 <= n3693;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7622 <= 1'b0;
    else
      n7622 <= n3695;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7623 <= 1'b0;
    else
      n7623 <= n3697;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7624 <= 32'b00000000000000000000000000000000;
    else
      n7624 <= n3698;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7625 <= 1'b0;
    else
      n7625 <= n7114;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7626 <= 32'b00000000000000000000000000000000;
    else
      n7626 <= n6550;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7627 <= 1'b0;
    else
      n7627 <= n3700;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7628 <= 1'b0;
    else
      n7628 <= n3702;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7629 <= 1'b0;
    else
      n7629 <= n3703;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7630 <= 32'b00000000000000000000000000000000;
    else
      n7630 <= n2763;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7631 <= 3'b000;
    else
      n7631 <= n2764;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7632 <= 1'b0;
    else
      n7632 <= n2766;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7633 <= 1'b0;
    else
      n7633 <= n2767;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7634 <= 1'b0;
    else
      n7634 <= n3705;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7635 <= n7178;
    else
      n7635 <= n6551;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7636 <= n7180;
    else
      n7636 <= n6552;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7637 <= n7182;
    else
      n7637 <= n6553;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7638 <= n7184;
    else
      n7638 <= n7111;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7639 <= n7186;
    else
      n7639 <= n6555;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7640 <= n7188;
    else
      n7640 <= n6556;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7641 <= n7190;
    else
      n7641 <= n6557;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7643 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7644 = n7643 ? n6559 : atc_global;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7645 <= n7644;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7646 <= 3'b000;
    else
      n7646 <= n6560;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7647 <= 1'b0;
    else
      n7647 <= n3725;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7648 <= 1'b0;
    else
      n7648 <= n7117;
  /* TG68K_PMMU_030.vhd:1701:5  */
  assign n7649 = {n484, n485, n486, n487};
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7650 <= 1'b0;
    else
      n7650 <= n3707;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7651 <= 1'b0;
    else
      n7651 <= n111;
  /* TG68K_PMMU_030.vhd:1172:5  */
  always @(posedge clk or posedge n626)
    if (n626)
      n7652 <= 32'b00000000000000000000000000000000;
    else
      n7652 <= n3708;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7653 <= 1'b0;
    else
      n7653 <= n346;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7654 <= 4'b0000;
    else
      n7654 <= n6568;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7655 <= 32'b00000000000000000000000000000000;
    else
      n7655 <= n6569;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7656 <= 32'b00000000000000000000000000000000;
    else
      n7656 <= n6570;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7657 <= 5'b01100;
    else
      n7657 <= n6571;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk or posedge n7534)
    if (n7534)
      n7659 <= 1'b0;
    else
      n7659 <= n7540;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk or posedge n7534)
    if (n7534)
      n7660 <= 1'b0;
    else
      n7660 <= n7548;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7661 <= 1'b0;
    else
      n7661 <= n348;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk or posedge n7534)
    if (n7534)
      n7662 <= 1'b0;
    else
      n7662 <= ptest_req;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk or posedge n7534)
    if (n7534)
      n7663 <= 1'b0;
    else
      n7663 <= pflush_req;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk or posedge n7534)
    if (n7534)
      n7664 <= 1'b0;
    else
      n7664 <= pload_req;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7667 = ptest_update_mmusr ? 1'b1 : ptest_active;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7668 <= 1'b0;
    else
      n7668 <= n7667;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7669 = ptest_update_mmusr ? pmmu_addr : ptest_addr;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7670 <= 32'b00000000000000000000000000000000;
    else
      n7670 <= n7669;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7671 = ptest_update_mmusr ? pmmu_fc : ptest_fc;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk or posedge n96)
    if (n96)
      n7672 <= 3'b000;
    else
      n7672 <= n7671;
  /* TG68K_PMMU_030.vhd:784:3  */
  assign n7673 = ~n96;
  /* TG68K_PMMU_030.vhd:784:3  */
  assign n7674 = ptest_update_mmusr & n7673;
  /* TG68K_PMMU_030.vhd:811:5  */
  assign n7675 = n7674 ? n100 : ptest_rw;
  /* TG68K_PMMU_030.vhd:811:5  */
  always @(posedge clk)
    n7676 <= n7675;
  initial
    n7676 = 1'b1;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7677 = ~n7534;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7678 = n7677 ? n7560 : pload_active;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7679 <= n7678;
  initial
    n7679 = 1'b0;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7680 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7681 = n7555 & n7680;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7682 = n7681 ? pmmu_addr : pload_addr;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7683 <= n7682;
  initial
    n7683 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7684 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7685 = n7555 & n7684;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7686 = n7685 ? pmmu_fc : pload_fc;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7687 <= n7686;
  initial
    n7687 = 3'b000;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7688 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7689 = n7555 & n7688;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7690 = n7689 ? n7556 : pload_rw;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7691 <= n7690;
  initial
    n7691 = 1'b1;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7695 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7696 = n7542 & n7695;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7697 = n7696 ? pmmu_addr : pflush_addr;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7698 <= n7697;
  initial
    n7698 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7699 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7700 = n7542 & n7699;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7701 = n7700 ? pmmu_fc : pflush_fc;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7702 <= n7701;
  initial
    n7702 = 3'b000;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7703 = ~n7534;
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7704 = n7542 & n7703;
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7705 = n7704 ? n7543 : pflush_mode;
  /* TG68K_PMMU_030.vhd:2861:5  */
  always @(posedge clk)
    n7706 <= n7705;
  initial
    n7706 = 5'b00000;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7707 <= 3'b000;
    else
      n7707 <= n6573;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7708 <= 32'b00000000000000000000000000000000;
    else
      n7708 <= n6574;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7709 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7710 = n7709 ? n6575 : walk_desc_high;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7711 <= n7710;
  initial
    n7711 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7712 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7713 = n7712 ? n6576 : walk_desc_low;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7714 <= n7713;
  initial
    n7714 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7715 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7716 = n7715 ? n6577 : walk_desc_is_long;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7717 <= n7716;
  initial
    n7717 = 1'b0;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7718 <= 32'b00000000000000000000000000000000;
    else
      n7718 <= n6578;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7719 <= 32'b00000000000000000000000000000000;
    else
      n7719 <= n6579;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7721 <= 8'b00000000;
    else
      n7721 <= n7149;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7722 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7723 = n7722 ? n6596 : walk_global;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7724 <= n7723;
  initial
    n7724 = 1'b0;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7725 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7726 = n7725 ? n6597 : walk_supervisor;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7727 <= n7726;
  initial
    n7727 = 1'b0;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7728 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7729 = n7728 ? n6598 : indirect_addr;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7730 <= n7729;
  initial
    n7730 = 32'b00000000000000000000000000000000;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n7731 = ~n3853;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7732 = n7731 ? n6599 : indirect_target_long;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk)
    n7733 <= n7732;
  initial
    n7733 = 1'b0;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7734 <= 1'b0;
    else
      n7734 <= n6600;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7735 <= 1'b0;
    else
      n7735 <= n6601;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7736 <= 15'b000000000000000;
    else
      n7736 <= n6602;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7738 <= 32'b00000000000000000000000000000000;
    else
      n7738 <= n6604;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7739 <= 1'b0;
    else
      n7739 <= n6544;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7740 <= 1'b0;
    else
      n7740 <= n6545;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7741 <= 32'b00000000000000000000000000000000;
    else
      n7741 <= n6546;
  /* TG68K_PMMU_030.vhd:1736:5  */
  always @(posedge clk or posedge n3853)
    if (n3853)
      n7742 <= 32'b00000000000000000000000000000000;
    else
      n7742 <= n6547;
  /* TG68K_PMMU_030.vhd:1311:41  */
  assign n7743 = atc_attr[n1430 * 4 +: 4]; //(Bmux)
  assign n7744 = n7743[0]; // extract
  /* TG68K_PMMU_030.vhd:1328:51  */
  assign n7745 = atc_phys_base[n1438 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1329:71  */
  assign n7746 = atc_log_base[n1442 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1329:70  */
  assign n7747 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1328:51  */
  assign n7749 = {2'bX, n7747};
  /* TG68K_PMMU_030.vhd:1332:45  */
  assign n7750 = n7749[n1448 * 4 +: 4]; //(Bmux)
  assign n7751 = n7750[0]; // extract
  /* TG68K_PMMU_030.vhd:1332:53  */
  assign n7752 = atc_attr[31:3]; // extract
  assign n7754 = {3'bX, n7752};
  /* TG68K_PMMU_030.vhd:1336:44  */
  assign n7755 = n7754[n1454 * 4 +: 4]; //(Bmux)
  assign n7756 = n7755[0]; // extract
  /* TG68K_PMMU_030.vhd:1343:43  */
  assign n7757 = atc_attr[n1461 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1336:44  */
  assign n7758 = n7757[0]; // extract
  /* TG68K_PMMU_030.vhd:1354:51  */
  assign n7759 = atc_phys_base[n1490 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1355:71  */
  assign n7760 = atc_log_base[n1494 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1355:70  */
  assign n7761 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1354:51  */
  assign n7763 = {2'bX, n7761};
  /* TG68K_PMMU_030.vhd:1358:45  */
  assign n7764 = n7763[n1500 * 4 +: 4]; //(Bmux)
  assign n7765 = n7764[0]; // extract
  /* TG68K_PMMU_030.vhd:1359:45  */
  assign n7766 = atc_attr[n1504 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1358:45  */
  assign n7767 = n7766[0]; // extract
  /* TG68K_PMMU_030.vhd:1369:53  */
  assign n7768 = atc_phys_base[n1509 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1370:73  */
  assign n7769 = atc_log_base[n1513 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1370:72  */
  assign n7770 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1369:53  */
  assign n7772 = {2'bX, n7770};
  /* TG68K_PMMU_030.vhd:1382:47  */
  assign n7773 = n7772[n1521 * 4 +: 4]; //(Bmux)
  assign n7774 = n7773[0]; // extract
  /* TG68K_PMMU_030.vhd:1383:47  */
  assign n7775 = atc_attr[n1525 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1382:47  */
  assign n7776 = n7775[0]; // extract
  /* TG68K_PMMU_030.vhd:1387:45  */
  assign n7777 = atc_attr[n1530 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1383:47  */
  assign n7778 = n7777[0]; // extract
  /* TG68K_PMMU_030.vhd:1387:53  */
  assign n7779 = atc_attr[31:1]; // extract
  assign n7781 = {1'bX, n7779};
  /* TG68K_PMMU_030.vhd:1388:40  */
  assign n7782 = n7781[n1534 * 4 +: 4]; //(Bmux)
  assign n7783 = n7782[0]; // extract
  /* TG68K_PMMU_030.vhd:1574:44  */
  assign n7784 = atc_attr[n3475 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1388:40  */
  assign n7785 = n7784[0]; // extract
  /* TG68K_PMMU_030.vhd:1592:51  */
  assign n7786 = atc_phys_base[n3483 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1593:77  */
  assign n7787 = atc_log_base[n3487 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1593:76  */
  assign n7788 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1592:51  */
  assign n7790 = {2'bX, n7788};
  /* TG68K_PMMU_030.vhd:1596:45  */
  assign n7791 = n7790[n3493 * 4 +: 4]; //(Bmux)
  assign n7792 = n7791[0]; // extract
  /* TG68K_PMMU_030.vhd:1596:53  */
  assign n7793 = atc_attr[31:3]; // extract
  assign n7795 = {3'bX, n7793};
  /* TG68K_PMMU_030.vhd:1600:50  */
  assign n7796 = n7795[n3499 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n7797 = n7796[0]; // extract
  /* TG68K_PMMU_030.vhd:1608:43  */
  assign n7798 = atc_attr[n3506 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1600:50  */
  assign n7799 = n7798[0]; // extract
  /* TG68K_PMMU_030.vhd:1619:51  */
  assign n7800 = atc_phys_base[n3535 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1620:77  */
  assign n7801 = atc_log_base[n3539 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1620:76  */
  assign n7802 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1619:51  */
  assign n7804 = {2'bX, n7802};
  /* TG68K_PMMU_030.vhd:1623:45  */
  assign n7805 = n7804[n3545 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7806 = n7805[0]; // extract
  /* TG68K_PMMU_030.vhd:1624:45  */
  assign n7807 = atc_attr[n3549 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1623:45  */
  assign n7808 = n7807[0]; // extract
  /* TG68K_PMMU_030.vhd:1630:51  */
  assign n7809 = atc_phys_base[n3553 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1631:77  */
  assign n7810 = atc_log_base[n3557 * 32 +: 32]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1631:76  */
  assign n7811 = atc_attr[31:2]; // extract
  /* TG68K_PMMU_030.vhd:1630:51  */
  assign n7813 = {2'bX, n7811};
  /* TG68K_PMMU_030.vhd:1634:45  */
  assign n7814 = n7813[n3563 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7815 = n7814[0]; // extract
  /* TG68K_PMMU_030.vhd:1635:45  */
  assign n7816 = atc_attr[n3567 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1634:45  */
  assign n7817 = n7816[0]; // extract
  /* TG68K_PMMU_030.vhd:1639:43  */
  assign n7818 = atc_attr[n3572 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:1635:45  */
  assign n7819 = n7818[0]; // extract
  /* TG68K_PMMU_030.vhd:1639:51  */
  assign n7820 = atc_attr[31:1]; // extract
  /* TG68K_PMMU_030.vhd:2851:3  */
  assign n7822 = {1'bX, n7820};
  /* TG68K_PMMU_030.vhd:1640:38  */
  assign n7823 = n7822[n3576 * 4 +: 4]; //(Bmux)
  /* TG68K_PMMU_030.vhd:2861:5  */
  assign n7824 = n7823[0]; // extract
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n7825 = tc_idx_bits[n4040 * 5 +: 5]; //(Bmux)
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n7826 = tc_idx_bits[n4536 * 5 +: 5]; //(Bmux)
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n7827 = tc_idx_bits[n5078 * 5 +: 5]; //(Bmux)
  /* TG68K_PMMU_030.vhd:537:28  */
  assign n7828 = tc_idx_bits[n5622 * 5 +: 5]; //(Bmux)
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7829 = n6489[2]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7830 = ~n7829;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7831 = n6489[1]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7832 = ~n7831;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7833 = n7830 & n7832;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7834 = n7830 & n7831;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7835 = n7829 & n7832;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7836 = n7829 & n7831;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7837 = n6489[0]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7838 = ~n7837;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7839 = n7833 & n7838;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7840 = n7833 & n7837;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7841 = n7834 & n7838;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7842 = n7834 & n7837;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7843 = n7835 & n7838;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7844 = n7835 & n7837;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7845 = n7836 & n7838;
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7846 = n7836 & n7837;
  assign n7847 = atc_log_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7848 = n7839 ? walk_log_base : n7847;
  assign n7849 = atc_log_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7850 = n7840 ? walk_log_base : n7849;
  assign n7851 = atc_log_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7852 = n7841 ? walk_log_base : n7851;
  /* TG68K_PMMU_030.vhd:2834:5  */
  assign n7853 = atc_log_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7854 = n7842 ? walk_log_base : n7853;
  assign n7855 = atc_log_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7856 = n7843 ? walk_log_base : n7855;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7857 = atc_log_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7858 = n7844 ? walk_log_base : n7857;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7859 = atc_log_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7860 = n7845 ? walk_log_base : n7859;
  assign n7861 = atc_log_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:2712:11  */
  assign n7862 = n7846 ? walk_log_base : n7861;
  assign n7863 = {n7862, n7860, n7858, n7856, n7854, n7852, n7850, n7848};
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7864 = n6493[2]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7865 = ~n7864;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7866 = n6493[1]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7867 = ~n7866;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7868 = n7865 & n7867;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7869 = n7865 & n7866;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7870 = n7864 & n7867;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7871 = n7864 & n7866;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7872 = n6493[0]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7873 = ~n7872;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7874 = n7868 & n7873;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7875 = n7868 & n7872;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7876 = n7869 & n7873;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7877 = n7869 & n7872;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7878 = n7870 & n7873;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7879 = n7870 & n7872;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7880 = n7871 & n7873;
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7881 = n7871 & n7872;
  assign n7882 = atc_phys_base[31:0]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7883 = n7874 ? walk_phys_base : n7882;
  assign n7884 = atc_phys_base[63:32]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7885 = n7875 ? walk_phys_base : n7884;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7886 = atc_phys_base[95:64]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7887 = n7876 ? walk_phys_base : n7886;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7888 = atc_phys_base[127:96]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7889 = n7877 ? walk_phys_base : n7888;
  assign n7890 = atc_phys_base[159:128]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7891 = n7878 ? walk_phys_base : n7890;
  assign n7892 = atc_phys_base[191:160]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7893 = n7879 ? walk_phys_base : n7892;
  assign n7894 = atc_phys_base[223:192]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7895 = n7880 ? walk_phys_base : n7894;
  assign n7896 = atc_phys_base[255:224]; // extract
  /* TG68K_PMMU_030.vhd:2713:11  */
  assign n7897 = n7881 ? walk_phys_base : n7896;
  assign n7898 = {n7897, n7895, n7893, n7891, n7889, n7887, n7885, n7883};
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7899 = n6497[2]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7900 = ~n7899;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7901 = n6497[1]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7902 = ~n7901;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7903 = n7900 & n7902;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7904 = n7900 & n7901;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7905 = n7899 & n7902;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7906 = n7899 & n7901;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7907 = n6497[0]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7908 = ~n7907;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7909 = n7903 & n7908;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7910 = n7903 & n7907;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7911 = n7904 & n7908;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7912 = n7904 & n7907;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7913 = n7905 & n7908;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7914 = n7905 & n7907;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7915 = n7906 & n7908;
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7916 = n7906 & n7907;
  /* TG68K_PMMU_030.vhd:400:14  */
  assign n7917 = atc_shift[4:0]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7918 = n7909 ? walk_page_shift : n7917;
  /* TG68K_PMMU_030.vhd:391:13  */
  assign n7919 = atc_shift[9:5]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7920 = n7910 ? walk_page_shift : n7919;
  assign n7921 = atc_shift[14:10]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7922 = n7911 ? walk_page_shift : n7921;
  /* TG68K_PMMU_030.vhd:515:14  */
  assign n7923 = atc_shift[19:15]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7924 = n7912 ? walk_page_shift : n7923;
  /* TG68K_PMMU_030.vhd:514:14  */
  assign n7925 = atc_shift[24:20]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7926 = n7913 ? walk_page_shift : n7925;
  /* TG68K_PMMU_030.vhd:508:13  */
  assign n7927 = atc_shift[29:25]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7928 = n7914 ? walk_page_shift : n7927;
  assign n7929 = atc_shift[34:30]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7930 = n7915 ? walk_page_shift : n7929;
  assign n7931 = atc_shift[39:35]; // extract
  /* TG68K_PMMU_030.vhd:2714:11  */
  assign n7932 = n7916 ? walk_page_shift : n7931;
  /* TG68K_PMMU_030.vhd:462:5  */
  assign n7933 = {n7932, n7930, n7928, n7926, n7924, n7922, n7920, n7918};
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7934 = n6505[2]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7935 = ~n7934;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7936 = n6505[1]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7937 = ~n7936;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7938 = n7935 & n7937;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7939 = n7935 & n7936;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7940 = n7934 & n7937;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7941 = n7934 & n7936;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7942 = n6505[0]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7943 = ~n7942;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7944 = n7938 & n7943;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7945 = n7938 & n7942;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7946 = n7939 & n7943;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7947 = n7939 & n7942;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7948 = n7940 & n7943;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7949 = n7940 & n7942;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7950 = n7941 & n7943;
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7951 = n7941 & n7942;
  /* TG68K_PMMU_030.vhd:476:14  */
  assign n7952 = atc_attr[3:0]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7953 = n7944 ? n6507 : n7952;
  /* TG68K_PMMU_030.vhd:466:7  */
  assign n7954 = atc_attr[7:4]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7955 = n7945 ? n6507 : n7954;
  assign n7956 = atc_attr[11:8]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7957 = n7946 ? n6507 : n7956;
  assign n7958 = atc_attr[15:12]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7959 = n7947 ? n6507 : n7958;
  assign n7960 = atc_attr[19:16]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7961 = n7948 ? n6507 : n7960;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7962 = atc_attr[23:20]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7963 = n7949 ? n6507 : n7962;
  /* TG68K_PMMU_030.vhd:431:5  */
  assign n7964 = atc_attr[27:24]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7965 = n7950 ? n6507 : n7964;
  assign n7966 = atc_attr[31:28]; // extract
  /* TG68K_PMMU_030.vhd:2716:11  */
  assign n7967 = n7951 ? n6507 : n7966;
  assign n7968 = {n7967, n7965, n7963, n7961, n7959, n7957, n7955, n7953};
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7969 = n6510[2]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7970 = ~n7969;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7971 = n6510[1]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7972 = ~n7971;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7973 = n7970 & n7972;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7974 = n7970 & n7971;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7975 = n7969 & n7972;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7976 = n7969 & n7971;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7977 = n6510[0]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7978 = ~n7977;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7979 = n7973 & n7978;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7980 = n7973 & n7977;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7981 = n7974 & n7978;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7982 = n7974 & n7977;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7983 = n7975 & n7978;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7984 = n7975 & n7977;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7985 = n7976 & n7978;
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7986 = n7976 & n7977;
  /* TG68K_PMMU_030.vhd:403:14  */
  assign n7987 = atc_fc[2:0]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7988 = n7979 ? saved_fc : n7987;
  /* TG68K_PMMU_030.vhd:402:14  */
  assign n7989 = atc_fc[5:3]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7990 = n7980 ? saved_fc : n7989;
  /* TG68K_PMMU_030.vhd:401:14  */
  assign n7991 = atc_fc[8:6]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7992 = n7981 ? saved_fc : n7991;
  /* TG68K_PMMU_030.vhd:400:14  */
  assign n7993 = atc_fc[11:9]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7994 = n7982 ? saved_fc : n7993;
  /* TG68K_PMMU_030.vhd:391:13  */
  assign n7995 = atc_fc[14:12]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7996 = n7983 ? saved_fc : n7995;
  assign n7997 = atc_fc[17:15]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n7998 = n7984 ? saved_fc : n7997;
  /* TG68K_PMMU_030.vhd:515:14  */
  assign n7999 = atc_fc[20:18]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n8000 = n7985 ? saved_fc : n7999;
  /* TG68K_PMMU_030.vhd:514:14  */
  assign n8001 = atc_fc[23:21]; // extract
  /* TG68K_PMMU_030.vhd:2717:11  */
  assign n8002 = n7986 ? saved_fc : n8001;
  /* TG68K_PMMU_030.vhd:508:13  */
  assign n8003 = {n8002, n8000, n7998, n7996, n7994, n7992, n7990, n7988};
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8004 = n6514[2]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8005 = ~n8004;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8006 = n6514[1]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8007 = ~n8006;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8008 = n8005 & n8007;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8009 = n8005 & n8006;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8010 = n8004 & n8007;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8011 = n8004 & n8006;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8012 = n6514[0]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8013 = ~n8012;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8014 = n8008 & n8013;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8015 = n8008 & n8012;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8016 = n8009 & n8013;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8017 = n8009 & n8012;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8018 = n8010 & n8013;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8019 = n8010 & n8012;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8020 = n8011 & n8013;
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8021 = n8011 & n8012;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n8022 = atc_is_insn[0]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8023 = n8014 ? saved_is_insn : n8022;
  /* TG68K_PMMU_030.vhd:1691:3  */
  assign n8024 = atc_is_insn[1]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8025 = n8015 ? saved_is_insn : n8024;
  /* TG68K_PMMU_030.vhd:1736:5  */
  assign n8026 = atc_is_insn[2]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8027 = n8016 ? saved_is_insn : n8026;
  assign n8028 = atc_is_insn[3]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8029 = n8017 ? saved_is_insn : n8028;
  assign n8030 = atc_is_insn[4]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8031 = n8018 ? saved_is_insn : n8030;
  assign n8032 = atc_is_insn[5]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8033 = n8019 ? saved_is_insn : n8032;
  assign n8034 = atc_is_insn[6]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8035 = n8020 ? saved_is_insn : n8034;
  assign n8036 = atc_is_insn[7]; // extract
  /* TG68K_PMMU_030.vhd:2718:11  */
  assign n8037 = n8021 ? saved_is_insn : n8036;
  assign n8038 = {n8037, n8035, n8033, n8031, n8029, n8027, n8025, n8023};
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8039 = n6518[2]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8040 = ~n8039;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8041 = n6518[1]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8042 = ~n8041;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8043 = n8040 & n8042;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8044 = n8040 & n8041;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8045 = n8039 & n8042;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8046 = n8039 & n8041;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8047 = n6518[0]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8048 = ~n8047;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8049 = n8043 & n8048;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8050 = n8043 & n8047;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8051 = n8044 & n8048;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8052 = n8044 & n8047;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8053 = n8045 & n8048;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8054 = n8045 & n8047;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8055 = n8046 & n8048;
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8056 = n8046 & n8047;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n8057 = atc_global[0]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8058 = n8049 ? walk_global : n8057;
  assign n8059 = atc_global[1]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8060 = n8050 ? walk_global : n8059;
  /* TG68K_PMMU_030.vhd:325:5  */
  assign n8061 = atc_global[2]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8062 = n8051 ? walk_global : n8061;
  assign n8063 = atc_global[3]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8064 = n8052 ? walk_global : n8063;
  /* TG68K_PMMU_030.vhd:323:14  */
  assign n8065 = atc_global[4]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8066 = n8053 ? walk_global : n8065;
  /* TG68K_PMMU_030.vhd:322:14  */
  assign n8067 = atc_global[5]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8068 = n8054 ? walk_global : n8067;
  /* TG68K_PMMU_030.vhd:320:12  */
  assign n8069 = atc_global[6]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8070 = n8055 ? walk_global : n8069;
  assign n8071 = atc_global[7]; // extract
  /* TG68K_PMMU_030.vhd:2719:11  */
  assign n8072 = n8056 ? walk_global : n8071;
  /* TG68K_PMMU_030.vhd:333:5  */
  assign n8073 = {n8072, n8070, n8068, n8066, n8064, n8062, n8060, n8058};
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8074 = n6522[2]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8075 = ~n8074;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8076 = n6522[1]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8077 = ~n8076;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8078 = n8075 & n8077;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8079 = n8075 & n8076;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8080 = n8074 & n8077;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8081 = n8074 & n8076;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8082 = n6522[0]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8083 = ~n8082;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8084 = n8078 & n8083;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8085 = n8078 & n8082;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8086 = n8079 & n8083;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8087 = n8079 & n8082;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8088 = n8080 & n8083;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8089 = n8080 & n8082;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8090 = n8081 & n8083;
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8091 = n8081 & n8082;
  assign n8092 = atc_valid[0]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8093 = n8084 ? 1'b1 : n8092;
  assign n8094 = atc_valid[1]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8095 = n8085 ? 1'b1 : n8094;
  assign n8096 = atc_valid[2]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8097 = n8086 ? 1'b1 : n8096;
  assign n8098 = atc_valid[3]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8099 = n8087 ? 1'b1 : n8098;
  assign n8100 = atc_valid[4]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8101 = n8088 ? 1'b1 : n8100;
  assign n8102 = atc_valid[5]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8103 = n8089 ? 1'b1 : n8102;
  assign n8104 = atc_valid[6]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8105 = n8090 ? 1'b1 : n8104;
  /* TG68K_PMMU_030.vhd:320:12  */
  assign n8106 = atc_valid[7]; // extract
  /* TG68K_PMMU_030.vhd:2720:11  */
  assign n8107 = n8091 ? 1'b1 : n8106;
  /* TG68K_PMMU_030.vhd:320:12  */
  assign n8108 = {n8107, n8105, n8103, n8101, n8099, n8097, n8095, n8093};
endmodule

