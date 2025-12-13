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
`define idle 7'd0
`define nop 7'd1
`define ld_nn 7'd2
`define st_nn 7'd3
`define ld_dAn1 7'd4
`define ld_AnXn1 7'd5
`define ld_AnXn2 7'd6
`define st_dAn1 7'd7
`define ld_AnXnbd1 7'd8
`define ld_AnXnbd2 7'd9
`define ld_AnXnbd3 7'd10
`define ld_229_1 7'd11
`define ld_229_2 7'd12
`define ld_229_3 7'd13
`define ld_229_4 7'd14
`define st_229_1 7'd15
`define st_229_2 7'd16
`define st_229_3 7'd17
`define st_229_4 7'd18
`define st_AnXn1 7'd19
`define st_AnXn2 7'd20
`define bra1 7'd21
`define bsr1 7'd22
`define bsr2 7'd23
`define nopnop 7'd24
`define dbcc1 7'd25
`define movem1 7'd26
`define movem2 7'd27
`define movem3 7'd28
`define andi 7'd29
`define pack1 7'd30
`define pack2 7'd31
`define pack3 7'd32
`define op_AxAy 7'd33
`define cmpm 7'd34
`define link1 7'd35
`define link2 7'd36
`define unlink1 7'd37
`define unlink2 7'd38
`define int1 7'd39
`define int2 7'd40
`define int3 7'd41
`define int4 7'd42
`define rte1 7'd43
`define rte2 7'd44
`define rte3 7'd45
`define rte4 7'd46
`define rte5 7'd47
`define rtd1 7'd48
`define rtd2 7'd49
`define trap00 7'd50
`define trap0 7'd51
`define trap1 7'd52
`define trap2 7'd53
`define trap3 7'd54
`define cas1 7'd55
`define cas2 7'd56
`define cas21 7'd57
`define cas22 7'd58
`define cas23 7'd59
`define cas24 7'd60
`define cas25 7'd61
`define cas26 7'd62
`define cas27 7'd63
`define cas28 7'd64
`define chk20 7'd65
`define chk21 7'd66
`define chk22 7'd67
`define chk23 7'd68
`define chk24 7'd69
`define trap4 7'd70
`define trap5 7'd71
`define trap6 7'd72
`define movec1 7'd73
`define movep1 7'd74
`define movep2 7'd75
`define movep3 7'd76
`define movep4 7'd77
`define movep5 7'd78
`define rota1 7'd79
`define bf1 7'd80
`define mul1 7'd81
`define mul2 7'd82
`define mul_end1 7'd83
`define mul_end2 7'd84
`define div1 7'd85
`define div2 7'd86
`define div3 7'd87
`define div4 7'd88
`define div_end1 7'd89
`define div_end2 7'd90

// Operation constants
`define opcMOVE 0
`define opcMOVEQ 1
`define opcMOVESR 2
`define opcADD 3
`define opcADDQ 4
`define opcOR 5
`define opcAND 6
`define opcEOR 7
`define opcCMP 8
`define opcROT 9
`define opcCPMAW 10
`define opcEXT 11
`define opcABCD 12
`define opcSBCD 13
`define opcBITS 14
`define opcSWAP 15
`define opcScc 16
`define andiSR 17
`define eoriSR 18
`define oriSR 19
`define opcMULU 20
`define opcDIVU 21
`define dispouter 22
`define rot_nop 23
`define ld_rot_cnt 24
`define writePC_add 25
`define ea_data_OP1 26
`define ea_data_OP2 27
`define use_XZFlag 28
`define get_bfoffset 29
`define save_memaddr 30
`define opcCHK 31
`define movec_rd 32
`define movec_wr 33
`define Regwrena 34
`define update_FC 35
`define linksp 36
`define movepl 37
`define update_ld 38
`define OP1addr 39
`define write_reg 40
`define changeMode 41
`define ea_build 42
`define trap_chk 43
`define store_ea_data 44
`define addrlong 45
`define postadd 46
`define presub 47
`define subidx 48
`define no_Flags 49
`define use_SP 50
`define to_CCR 51
`define to_SR 52
`define OP2out_one 53
`define OP1out_zero 54
`define mem_addsub 55
`define addsub 56
`define directPC 57
`define direct_delta 58
`define directSR 59
`define directCCR 60
`define exg 61
`define get_ea_now 62
`define ea_to_pc 63
`define hold_dwr 64
`define to_USP 65
`define from_USP 66
`define write_lowlong 67
`define write_reminder 68
`define movem_action 69
`define briefext 70
`define get_2ndOPC 71
`define mem_byte 72
`define longaktion 73
`define opcRESET 74
`define opcBF 75
`define opcBFwb 76
`define opcPACK 77
`define opcUNPACK 78
`define hold_ea_data 79
`define store_ea_packdata 80
`define exec_BS 81
`define hold_OP2 82
`define restore_ADDR 83
`define alu_exec 84
`define alu_move 85
`define alu_setFlags 86
`define opcCHK2 87
`define opcEXTB 88

`define lastOpcBit 88

`endif // TG68K_PACK_VH
