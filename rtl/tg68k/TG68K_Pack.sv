package TG68K_Pack;

    typedef enum logic [7:0] {
        idle, nop, ld_nn, st_nn, ld_dAn1, ld_AnXn1, ld_AnXn2, st_dAn1, ld_AnXnbd1, ld_AnXnbd2, ld_AnXnbd3,
        ld_229_1, ld_229_2, ld_229_3, ld_229_4, st_229_1, st_229_2, st_229_3, st_229_4,
        st_AnXn1, st_AnXn2, bra1, bsr1, bsr2, nopnop, dbcc1, movem1, movem2, movem3,
        andi, pack1, pack2, pack3, op_AxAy, cmpm, link1, link2, unlink1, unlink2, int1, int2, int3, int4, rte1, rte2, rte3,
        rte4, rte5, rtd1, rtd2, trap00, trap0, trap1, trap2, trap3, cas1, cas2, cas21, cas22, cas23, cas24,
        cas25, cas26, cas27, cas28, chk20, chk21, chk22, chk23, chk24,
        trap4, trap5, trap6, movec1, movep1, movep2, movep3, movep4, movep5, rota1, bf1,
        mul1, mul2, mul_end1,  mul_end2, div1, div2, div3, div4, div_end1, div_end2
    } micro_states;

    localparam int opcMOVE         = 0;
    localparam int opcMOVEQ        = 1;
    localparam int opcMOVESR       = 2;
    localparam int opcADD          = 3;
    localparam int opcADDQ         = 4;
    localparam int opcOR           = 5;
    localparam int opcAND          = 6;
    localparam int opcEOR          = 7;
    localparam int opcCMP          = 8;
    localparam int opcROT          = 9;
    localparam int opcCPMAW        = 10;
    localparam int opcEXT          = 11;
    localparam int opcABCD         = 12;
    localparam int opcSBCD         = 13;
    localparam int opcBITS         = 14;
    localparam int opcSWAP         = 15;
    localparam int opcScc          = 16;
    localparam int andiSR          = 17;
    localparam int eoriSR          = 18;
    localparam int oriSR           = 19;
    localparam int opcMULU         = 20;
    localparam int opcDIVU         = 21;
    localparam int dispouter       = 22;
    localparam int rot_nop         = 23;
    localparam int ld_rot_cnt      = 24;
    localparam int writePC_add     = 25;
    localparam int ea_data_OP1     = 26;
    localparam int ea_data_OP2     = 27;
    localparam int use_XZFlag      = 28;
    localparam int get_bfoffset    = 29;
    localparam int save_memaddr    = 30;
    localparam int opcCHK          = 31;
    localparam int movec_rd        = 32;
    localparam int movec_wr        = 33;
    localparam int Regwrena        = 34;
    localparam int update_FC       = 35;
    localparam int linksp          = 36;
    localparam int movepl          = 37;
    localparam int update_ld       = 38;
    localparam int OP1addr         = 39;
    localparam int write_reg       = 40;
    localparam int changeMode      = 41;
    localparam int ea_build        = 42;
    localparam int trap_chk        = 43;
    localparam int store_ea_data   = 44;
    localparam int addrlong        = 45;
    localparam int postadd         = 46;
    localparam int presub          = 47;
    localparam int subidx          = 48;
    localparam int no_Flags        = 49;
    localparam int use_SP          = 50;
    localparam int to_CCR          = 51;
    localparam int to_SR           = 52;
    localparam int OP2out_one      = 53;
    localparam int OP1out_zero     = 54;
    localparam int mem_addsub      = 55;
    localparam int addsub          = 56;
    localparam int directPC        = 57;
    localparam int direct_delta    = 58;
    localparam int directSR        = 59;
    localparam int directCCR       = 60;
    localparam int exg             = 61;
    localparam int get_ea_now      = 62;
    localparam int ea_to_pc        = 63;
    localparam int hold_dwr        = 64;
    localparam int to_USP          = 65;
    localparam int from_USP        = 66;
    localparam int write_lowlong   = 67;
    localparam int write_reminder  = 68;
    localparam int movem_action    = 69;
    localparam int briefext        = 70;
    localparam int get_2ndOPC      = 71;
    localparam int mem_byte        = 72;
    localparam int longaktion      = 73;
    localparam int opcRESET        = 74;
    localparam int opcBF           = 75;
    localparam int opcBFwb         = 76;
    localparam int opcPACK         = 77;
    localparam int opcUNPACK       = 78;
    localparam int hold_ea_data    = 79;
    localparam int store_ea_packdata = 80;
    localparam int exec_BS         = 81;
    localparam int hold_OP2        = 82;
    localparam int restore_ADDR    = 83;
    localparam int alu_exec        = 84;
    localparam int alu_move        = 85;
    localparam int alu_setFlags    = 86;
    localparam int opcCHK2         = 87;
    localparam int opcEXTB         = 88;

    localparam int lastOpcBit      = 88;

endpackage
