//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//                                                                          
// Copyright (c) 2009-2020 Tobias Gubener                                   
// Patches by MikeJ, Till Harbaum, Rok Krajnk, ...                          
// Subdesign fAMpIGA by TobiFlex                                            
//                                                                          
// This source file is free software: you can redistribute it and/or modify 
// it under the terms of the GNU Lesser General Public License as published 
// by the Free Software Foundation, either version 3 of the License, or     
// (at your option) any later version.                                      
//                                                                          
// This source file is distributed in the hope that it will be useful,      
// but WITHOUT ANY WARRANTY; without even the implied warranty of           
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            
// GNU General Public License for more details.                             
//                                                                          
// You should have received a copy of the GNU General Public License        
// along with this program.  If not, see <http://www.gnu.org/licenses/>.    
//                                                                          
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

`ifndef TG68K_PACK_VH
`define TG68K_PACK_VH

// Micro states enumeration
localparam [6:0] 
    idle = 0,
    nop = 1,
    ld_nn = 2,
    st_nn = 3,
    ld_dAn1 = 4,
    ld_AnXn1 = 5,
    ld_AnXn2 = 6,
    st_dAn1 = 7,
    ld_AnXnbd1 = 8,
    ld_AnXnbd2 = 9,
    ld_AnXnbd3 = 10,
    ld_229_1 = 11,
    ld_229_2 = 12,
    ld_229_3 = 13,
    ld_229_4 = 14,
    st_229_1 = 15,
    st_229_2 = 16,
    st_229_3 = 17,
    st_229_4 = 18,
    st_AnXn1 = 19,
    st_AnXn2 = 20,
    bra1 = 21,
    bsr1 = 22,
    bsr2 = 23,
    nopnop = 24,
    dbcc1 = 25,
    movem1 = 26,
    movem2 = 27,
    movem3 = 28,
    andi = 29,
    pack1 = 30,
    pack2 = 31,
    pack3 = 32,
    op_AxAy = 33,
    cmpm = 34,
    link1 = 35,
    link2 = 36,
    unlink1 = 37,
    unlink2 = 38,
    int1 = 39,
    int2 = 40,
    int3 = 41,
    int4 = 42,
    rte1 = 43,
    rte2 = 44,
    rte3 = 45,
    rte4 = 46,
    rte5 = 47,
    rtd1 = 48,
    rtd2 = 49,
    trap00 = 50,
    trap0 = 51,
    trap1 = 52,
    trap2 = 53,
    trap3 = 54,
    cas1 = 55,
    cas2 = 56,
    cas21 = 57,
    cas22 = 58,
    cas23 = 59,
    cas24 = 60,
    cas25 = 61,
    cas26 = 62,
    cas27 = 63,
    cas28 = 64,
    chk20 = 65,
    chk21 = 66,
    chk22 = 67,
    chk23 = 68,
    chk24 = 69,
    trap4 = 70,
    trap5 = 71,
    trap6 = 72,
    movec1 = 73,
    movep1 = 74,
    movep2 = 75,
    movep3 = 76,
    movep4 = 77,
    movep5 = 78,
    rota1 = 79,
    bf1 = 80,
    mul1 = 81,
    mul2 = 82,
    mul_end1 = 83,
    mul_end2 = 84,
    div1 = 85,
    div2 = 86,
    div3 = 87,
    div4 = 88,
    div_end1 = 89,
    div_end2 = 90;

// Operation constants
localparam opcMOVE = 0;
localparam opcMOVEQ = 1;
localparam opcMOVESR = 2;
localparam opcADD = 3;
localparam opcADDQ = 4;
localparam opcOR = 5;
localparam opcAND = 6;
localparam opcEOR = 7;
localparam opcCMP = 8;
localparam opcROT = 9;
localparam opcCPMAW = 10;
localparam opcEXT = 11;
localparam opcABCD = 12;
localparam opcSBCD = 13;
localparam opcBITS = 14;
localparam opcSWAP = 15;
localparam opcScc = 16;
localparam andiSR = 17;
localparam eoriSR = 18;
localparam oriSR = 19;
localparam opcMULU = 20;
localparam opcDIVU = 21;
localparam dispouter = 22;
localparam rot_nop = 23;
localparam ld_rot_cnt = 24;
localparam writePC_add = 25;
localparam ea_data_OP1 = 26;
localparam ea_data_OP2 = 27;
localparam use_XZFlag = 28;
localparam get_bfoffset = 29;
localparam save_memaddr = 30;
localparam opcCHK = 31;
localparam movec_rd = 32;
localparam movec_wr = 33;
localparam Regwrena = 34;
localparam update_FC = 35;
localparam linksp = 36;
localparam movepl = 37;
localparam update_ld = 38;
localparam OP1addr = 39;
localparam write_reg = 40;
localparam changeMode = 41;
localparam ea_build = 42;
localparam trap_chk = 43;
localparam store_ea_data = 44;
localparam addrlong = 45;
localparam postadd = 46;
localparam presub = 47;
localparam subidx = 48;
localparam no_Flags = 49;
localparam use_SP = 50;
localparam to_CCR = 51;
localparam to_SR = 52;
localparam OP2out_one = 53;
localparam OP1out_zero = 54;
localparam mem_addsub = 55;
localparam addsub = 56;
localparam directPC = 57;
localparam direct_delta = 58;
localparam directSR = 59;
localparam directCCR = 60;
localparam exg = 61;
localparam get_ea_now = 62;
localparam ea_to_pc = 63;
localparam hold_dwr = 64;
localparam to_USP = 65;
localparam from_USP = 66;
localparam write_lowlong = 67;
localparam write_reminder = 68;
localparam movem_action = 69;
localparam briefext = 70;
localparam get_2ndOPC = 71;
localparam mem_byte = 72;
localparam longaktion = 73;
localparam opcRESET = 74;
localparam opcBF = 75;
localparam opcBFwb = 76;
localparam opcPACK = 77;
localparam opcUNPACK = 78;
localparam hold_ea_data = 79;
localparam store_ea_packdata = 80;
localparam exec_BS = 81;
localparam hold_OP2 = 82;
localparam restore_ADDR = 83;
localparam alu_exec = 84;
localparam alu_move = 85;
localparam alu_setFlags = 86;
localparam opcCHK2 = 87;
localparam opcEXTB = 88;

localparam lastOpcBit = 88;

`endif // TG68K_PACK_VH
