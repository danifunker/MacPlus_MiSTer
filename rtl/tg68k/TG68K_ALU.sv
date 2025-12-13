
module TG68K_ALU #(
    parameter int MUL_Mode      = 2, // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no MUL
    parameter int MUL_Hardware  = 1, // 0=>no, 1=>yes
    parameter int DIV_Mode      = 2, // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no DIV
    parameter int BarrelShifter = 1  // 0=>no, 1=>yes, 2=>switchable with CPU(1)
) (
    input  logic        clk,
    input  logic        Reset,
    input  logic        clkena_lw,
    input  logic [1:0]  CPU, // 00->68000 01->68010 11->68020(only some parts - yet)
    input  logic        execOPC,
    input  logic        decodeOPC,
    input  logic        exe_condition,
    input  logic        exec_tas,
    input  logic        long_start,
    input  logic        non_aligned,
    input  logic        check_aligned,
    input  logic        movem_presub,
    input  logic        set_stop,
    input  logic        Z_error,
    input  logic [1:0]  rot_bits,
    input  logic [TG68K_Pack::lastOpcBit:0] exec,
    input  logic [31:0] OP1out,
    input  logic [31:0] OP2out,
    input  logic [31:0] reg_QA,
    input  logic [31:0] reg_QB,
    input  logic [15:0] opcode,
    input  logic [15:0] exe_opcode,
    input  logic [1:0]  exe_datatype,
    input  logic [15:0] sndOPC,
    input  logic [15:0] last_data_read,
    input  logic [15:0] data_read,
    input  logic [7:0]  FlagsSR,
    input  TG68K_Pack::micro_states micro_state,
    input  logic [7:0]  bf_ext_in,
    output logic [7:0]  bf_ext_out,
    input  logic [5:0]  bf_shift,
    input  logic [5:0]  bf_width,
    input  logic [31:0] bf_ffo_offset,
    input  logic [4:0]  bf_loffset,

    output logic        set_V_Flag,
    output logic [7:0]  Flags,
    output logic [2:0]  c_out,
    output logic [31:0] addsub_q,
    output logic [31:0] ALUout
);

    import TG68K_Pack::*;

    logic [31:0] OP1in;
    logic [31:0] addsub_a;
    logic [31:0] addsub_b;
    logic [33:0] notaddsub_b;
    logic [33:0] add_result;
    logic [2:0]  addsub_ofl;
    logic        opaddsub;
    logic [3:0]  c_in;
    logic [2:0]  flag_z;
    logic [3:0]  set_Flags; // NZVC
    logic [7:0]  CCRin;
    logic [3:0]  last_Flags1; // NZVC

    // BCD
    logic [9:0]  bcd_pur;
    logic        halve_carry;
    logic        Vflag_a;
    logic        bcd_a_carry;
    logic [8:0]  bcd_a;
    logic [127:0] result_mulu;
    logic [63:0] result_div;
    logic [31:0] result_div_pre;
    logic        set_mV_Flag;
    logic        V_Flag;

    logic        rot_rot;
    logic        rot_lsb;
    logic        rot_msb;
    logic        rot_X;
    logic        rot_C;
    logic [31:0] rot_out;
    logic        asl_VFlag;
    logic [1:0]  bit_bits;
    logic [4:0]  bit_number;
    logic [31:0] bits_out;
    logic        one_bit_in;
    logic        bchg;
    logic        bset;

    logic        mulu_sign;
    logic [16:0] mulu_signext;
    logic        muls_msb;
    logic [63:0] mulu_reg;
    logic        FAsign;
    logic [31:0] faktorA;
    logic [31:0] faktorB;

    logic [63:0] div_reg;
    logic [63:0] div_quot;
    logic        div_ovl;
    logic        div_neg;
    logic        div_bit;
    logic [32:0] div_sub;
    logic [32:0] div_over;
    logic        nozero;
    logic        div_qsign;
    logic [63:0] dividend;
    logic        divs;
    logic        signedOP;
    logic        OP1_sign;
    logic        OP2_sign;
    logic [15:0] OP2outext;

    logic [5:0]  in_offset;
    logic [31:0] datareg;
    logic [31:0] insert;
    logic [31:0] bf_datareg;
    logic [39:0] result;
    logic [39:0] result_tmp;
    logic [31:0] unshifted_bitmask;
    logic [39:0] bf_set1;
    logic [39:0] inmux0;
    logic [39:0] inmux1;
    logic [39:0] inmux2;
    logic [31:0] inmux3;
    logic [39:0] shifted_bitmask;
    logic [37:0] bitmaskmux0;
    logic [35:0] bitmaskmux1;
    logic [31:0] bitmaskmux2;
    logic [31:0] bitmaskmux3;
    logic [31:0] bf_set2;
    logic [39:0] shift;
    logic [5:0]  bf_firstbit;
    logic [3:0]  mux;
    logic [4:0]  bitnr;
    logic [31:0] mask;
    logic        mask_not_zero;
    logic        bf_bset;
    logic        bf_NFlag;
    logic        bf_bchg;
    logic        bf_ins;
    logic        bf_exts;
    logic        bf_fffo;
    logic        bf_d32;
    logic        bf_s32;
    logic [4:0]  index;

    logic [33:0] hot_msb;
    logic [32:0] vector;
    logic [65:0] result_bs;
    logic [5:0]  bit_nr;
    logic [5:0]  bit_msb;
    logic [5:0]  bs_shift;
    logic [5:0]  bs_shift_mod;
    logic [32:0] asl_over;
    logic [32:0] asl_over_xor;
    logic [32:0] asr_sign;
    logic        msb;
    logic [5:0]  ring;
    logic [31:0] ALU;
    logic [31:0] BSout;
    logic        bs_V;
    logic        bs_C;
    logic        bs_X;


    // Set OP1in
    always_comb begin
        OP1in = addsub_q;
        if (exec[opcABCD] == 1'b1 || exec[opcSBCD] == 1'b1) begin
            OP1in[7:0] = bcd_a[7:0];
        end else if (exec[opcMULU] == 1'b1 && MUL_Mode != 3) begin
            if (MUL_Hardware == 0) begin
                if (exec[write_lowlong] == 1'b1 && (MUL_Mode == 1 || MUL_Mode == 2)) begin
                    OP1in = result_mulu[31:0];
                end else begin
                    OP1in = result_mulu[63:32];
                end
            end else begin
                if (exec[write_lowlong] == 1'b1) begin
                    OP1in = result_mulu[31:0];
                end else begin
                    OP1in = mulu_reg[31:0];
                end
            end
        end else if (exec[opcDIVU] == 1'b1 && DIV_Mode != 3) begin
            if (exe_opcode[15] == 1'b1 || DIV_Mode == 0) begin
                OP1in = {result_div[47:32], result_div[15:0]}; // word
            end else begin // 64bit
                if (exec[write_reminder] == 1'b1) begin
                    OP1in = result_div[63:32];
                end else begin
                    OP1in = result_div[31:0];
                end
            end
        end else if (exec[opcOR] == 1'b1) begin
            OP1in = OP2out | OP1out;
        end else if (exec[opcAND] == 1'b1) begin
            OP1in = OP2out & OP1out;
        end else if (exec[opcScc] == 1'b1) begin
            OP1in[7:0] = {8{exe_condition}};
        end else if (exec[opcEOR] == 1'b1) begin
            OP1in = OP2out ^ OP1out;
        end else if (exec[alu_move] == 1'b1) begin
            OP1in = OP2out;
        end else if (exec[opcROT] == 1'b1) begin
            OP1in = rot_out;
        end else if (exec[exec_BS] == 1'b1) begin
            OP1in = BSout;
        end else if (exec[opcSWAP] == 1'b1) begin
            OP1in = {OP1out[15:0], OP1out[31:16]};
        end else if (exec[opcBITS] == 1'b1) begin
            OP1in = bits_out;
        end else if (exec[opcBF] == 1'b1) begin
            OP1in = bf_datareg;
        end else if (exec[opcMOVESR] == 1'b1) begin
            OP1in[7:0] = Flags;
            if (exe_opcode[9] == 1'b1) begin
                OP1in[15:8] = 8'b00000000;
            end else begin
                OP1in[15:8] = FlagsSR;
            end
        end else if (exec[opcPACK] == 1'b1) begin
            OP1in[7:0] = {addsub_q[11:8], addsub_q[3:0]};
        end

        ALUout = OP1in;
        ALUout[7] = OP1in[7] | exec_tas;
        if (exec[opcBFwb] == 1'b1) begin
            ALUout = result[31:0];
            if (bf_fffo == 1'b1) begin
                ALUout = bf_ffo_offset - {26'b0, bf_firstbit};
            end
        end
    end

    // addsub
    always_comb begin
        addsub_a = OP1out;
        if (exec[get_bfoffset] == 1'b1) begin
            if (sndOPC[11] == 1'b1) begin
                addsub_a = {OP1out[31], OP1out[31], OP1out[31], OP1out[31:3]};
            end else begin
                addsub_a = {30'b0, sndOPC[10:9]};
            end
        end

        if (exec[subidx] == 1'b1) begin
            opaddsub = 1'b1;
        end else begin
            opaddsub = 1'b0;
        end

        c_in[0] = 1'b0;
        addsub_b = OP2out;
        if (exec[opcUNPACK] == 1'b1) begin
            addsub_b[15:0] = {4'b0000, OP2out[7:4], 4'b0000, OP2out[3:0]};
        end else if (execOPC == 1'b0 && exec[OP2out_one] == 1'b0 && exec[get_bfoffset] == 1'b0) begin
            if (long_start == 1'b0 && exe_datatype == 2'b00 && exec[use_SP] == 1'b0) begin
                addsub_b = 32'd1;
            end else if (long_start == 1'b0 && exe_datatype == 2'b10 && (exec[presub] || exec[postadd] || movem_presub) == 1'b1) begin
                if (exec[movem_action] == 1'b1) begin
                    addsub_b = 32'd6;
                end else begin
                    addsub_b = 32'd4;
                end
            end else begin
                addsub_b = 32'd2;
            end
        end else begin
            if ((exec[use_XZFlag] == 1'b1 && Flags[4] == 1'b1) || exec[opcCHK] == 1'b1) begin
                c_in[0] = 1'b1;
            end
            opaddsub = exec[addsub];
        end

        // patch for un-aligned movem
        if (exec[movem_action] == 1'b1 || check_aligned == 1'b1) begin
            if (movem_presub == 1'b0) begin // up
                if (non_aligned == 1'b1 && long_start == 1'b0) begin // hold
                    addsub_b = 32'b0;
                end
            end else begin
                if (non_aligned == 1'b1 && long_start == 1'b0) begin
                    if (exe_datatype == 2'b10) begin
                        addsub_b = 32'd8;
                    end else begin
                        addsub_b = 32'd4;
                    end
                end
            end
        end

        if (opaddsub == 1'b0 || long_start == 1'b1) begin // ADD
            notaddsub_b = {1'b0, addsub_b, c_in[0]};
        end else begin // SUB
            notaddsub_b = ~{1'b0, addsub_b, c_in[0]};
        end
        add_result = {1'b0, addsub_a, notaddsub_b[0]} + notaddsub_b;
        c_in[1] = add_result[9] ^ addsub_a[8] ^ addsub_b[8];
        c_in[2] = add_result[17] ^ addsub_a[16] ^ addsub_b[16];
        c_in[3] = add_result[33];
        addsub_q = add_result[32:1];
        addsub_ofl[0] = (c_in[1] ^ add_result[8] ^ addsub_a[7] ^ addsub_b[7]);   // V Byte
        addsub_ofl[1] = (c_in[2] ^ add_result[16] ^ addsub_a[15] ^ addsub_b[15]); // V Word
        addsub_ofl[2] = (c_in[3] ^ add_result[32] ^ addsub_a[31] ^ addsub_b[31]); // V Long
        c_out = c_in[3:1];
    end

    // ALU and BCD_ARITH
    always_comb begin
        logic [8:0] bcd_kor_v;
        logic [8:0] bcd_a_v;

        bcd_pur = {c_in[1], add_result[8:0]};
        halve_carry = OP1out[4] ^ OP2out[4] ^ bcd_pur[5];

        bcd_kor_v = 9'b0;
        if (halve_carry) bcd_kor_v[3:0] = 4'b0110;
        if (bcd_pur[9])  bcd_kor_v[7:4] = 4'b0110;

        // Default assignments to avoid latches
        Vflag_a = 1'b0;
        bcd_a = 9'b0;
        bcd_a_carry = 1'b0;

        if (exec[opcABCD] == 1'b1) begin
            bcd_a_v = bcd_pur[9:1] + bcd_kor_v;
            Vflag_a = ~bcd_pur[8] & bcd_a_v[7];
            bcd_a = bcd_a_v;
            // The VHDL code has additional logic here for +6/+60 adjustment on bcd_kor which affects nothing else in this cycle.
            // bcd_a is already assigned.
        end else if (exec[opcSBCD] == 1'b1) begin // SBCD
            bcd_a_v = bcd_pur[9:1] - bcd_kor_v;
            Vflag_a = bcd_pur[8] & ~bcd_a_v[7];
            bcd_a = bcd_a_v;
        end else begin
            // Hold value if not BCD op?
            // VHDL implies this process calculates bcd_a for BCD ops.
            // bcd_a is not used outside this process except as output? No, it's not in port list.
            // It is used inside to calculate Vflag_a and bcd_a_carry.
            // VHDL process sensitivity implies combinatorial.
            // So if not ABCD/SBCD, values are don't care or default.
        end

        if (CPU[1] == 1'b1) begin // 68020
            Vflag_a = 1'b0;
        end
        bcd_a_carry = bcd_pur[9] | bcd_a[8];
    end

    // Bits Process
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            bchg <= 1'b0;
            bset <= 1'b0;
            case (opcode[7:6])
                2'b01: bchg <= 1'b1; // bchg
                2'b11: bset <= 1'b1; // bset
                default: ;
            endcase
        end
    end

    always_comb begin
        if (exe_opcode[8] == 1'b0) begin
            if (exe_opcode[5:4] == 2'b00) begin
                bit_number = sndOPC[4:0];
            end else begin
                bit_number = {2'b00, sndOPC[2:0]};
            end
        end else begin
            if (exe_opcode[5:4] == 2'b00) begin
                bit_number = reg_QB[4:0];
            end else begin
                bit_number = {2'b00, reg_QB[2:0]};
            end
        end

        one_bit_in = OP1out[bit_number];
        bits_out = OP1out;
        bits_out[bit_number] = (bchg & ~one_bit_in) | bset;
    end

    // Bit Field Process
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            bf_bset <= 1'b0;
            bf_bchg <= 1'b0;
            bf_ins  <= 1'b0;
            bf_exts <= 1'b0;
            bf_fffo <= 1'b0;
            bf_d32  <= 1'b0;
            bf_s32  <= 1'b0;

            if (opcode[5:4] == 2'b00) begin
                bf_s32 <= 1'b1;
            end
            case (opcode[10:8])
                3'b010: bf_bchg <= 1'b1; // BFCHG
                3'b011: bf_exts <= 1'b1; // BFEXTS
                3'b101: bf_fffo <= 1'b1; // BFFFO
                3'b110: bf_bset <= 1'b1; // BFSET
                3'b111: begin
                    bf_ins <= 1'b1;      // BFINS
                    bf_s32 <= 1'b1;
                end
                default: ;
            endcase

            if (opcode[4:3] == 2'b00) begin
                bf_d32 <= 1'b1;
            end
            bf_ext_out <= result[39:32];
        end
    end

    always_comb begin
        if (bf_ins == 1'b1) begin
            datareg = reg_QB;
        end else begin
            datareg = bf_set2;
        end

        unshifted_bitmask = 32'b0;
        for (int j = 0; j < 32; j++) begin
            if (j > bf_width[4:0]) begin
               datareg[j] = 1'b0;
               unshifted_bitmask[j] = 1'b1;
            end
        end

        bf_NFlag = datareg[bf_width];

        if (bf_exts == 1'b1 && bf_NFlag == 1'b1) begin
            bf_datareg = datareg | unshifted_bitmask;
        end else begin
            bf_datareg = datareg;
        end

        // Shift bitmask
        if (bf_loffset[4] == 1'b1) bitmaskmux3 = {unshifted_bitmask[15:0], unshifted_bitmask[31:16]};
        else                       bitmaskmux3 = unshifted_bitmask;

        if (bf_loffset[3] == 1'b1) bitmaskmux2 = {bitmaskmux3[23:0], bitmaskmux3[31:24]};
        else                       bitmaskmux2 = bitmaskmux3;

        if (bf_loffset[2] == 1'b1) begin
            bitmaskmux1 = {bitmaskmux2, 4'b1111};
            if (bf_d32 == 1'b1) bitmaskmux1[3:0] = bitmaskmux2[31:28];
        end else begin
            bitmaskmux1 = {4'b1111, bitmaskmux2};
        end

        if (bf_loffset[1] == 1'b1) begin
            bitmaskmux0 = {bitmaskmux1, 2'b11};
            if (bf_d32 == 1'b1) bitmaskmux0[1:0] = bitmaskmux1[31:30];
        end else begin
            bitmaskmux0 = {2'b11, bitmaskmux1};
        end

        if (bf_loffset[0] == 1'b1) begin
            shifted_bitmask = {1'b1, bitmaskmux0, 1'b1};
            if (bf_d32 == 1'b1) shifted_bitmask[0] = bitmaskmux0[31];
        end else begin
            shifted_bitmask = {2'b11, bitmaskmux0};
        end

        // Shift for ins
        shift = {bf_ext_in, OP2out};
        if (bf_s32 == 1'b1) shift[39:32] = OP2out[7:0];

        if (bf_shift[0] == 1'b1) inmux0 = {shift[0], shift[39:1]};
        else                     inmux0 = shift;

        if (bf_shift[1] == 1'b1) inmux1 = {inmux0[1:0], inmux0[39:2]};
        else                     inmux1 = inmux0;

        if (bf_shift[2] == 1'b1) inmux2 = {inmux1[3:0], inmux1[39:4]};
        else                     inmux2 = inmux1;

        if (bf_shift[3] == 1'b1) inmux3 = {inmux2[7:0], inmux2[31:8]}; // lower 32
        else                     inmux3 = inmux2[31:0];

        if (bf_shift[4] == 1'b1) bf_set2 = {inmux3[15:0], inmux3[31:16]};
        else                     bf_set2 = inmux3;

        if (bf_ins == 1'b1) begin
            result[31:0] = bf_set2;
            result[39:32] = bf_set2[7:0];
        end else if (bf_bchg == 1'b1) begin
            result[31:0] = ~OP2out;
            result[39:32] = ~bf_ext_in;
        end else begin
            result = 40'b0;
        end
        if (bf_bset == 1'b1) result = {40{1'b1}};

        if (bf_ins == 1'b1) result_tmp = {bf_ext_in, OP1out};
        else                result_tmp = {bf_ext_in, OP2out};

        for (int k = 0; k < 40; k++) begin
            if (shifted_bitmask[k] == 1'b1) result[k] = result_tmp[k];
        end

        // BFFFO
        mask = datareg;
        bf_firstbit = {1'b0, bitnr} + mask_not_zero;
        bitnr = 5'b11111;
        mask_not_zero = 1'b1;

        if (mask[31:28] == 4'b0000) begin
            if (mask[27:24] == 4'b0000) begin
                if (mask[23:20] == 4'b0000) begin
                    if (mask[19:16] == 4'b0000) begin
                        bitnr[4] = 1'b0;
                        if (mask[15:12] == 4'b0000) begin
                            if (mask[11:8] == 4'b0000) begin
                                bitnr[3] = 1'b0;
                                if (mask[7:4] == 4'b0000) begin
                                    bitnr[2] = 1'b0;
                                    mux = mask[3:0];
                                end else begin
                                    mux = mask[7:4];
                                end
                            end else begin
                                mux = mask[11:8];
                                bitnr[2] = 1'b0;
                            end
                        end else begin
                            mux = mask[15:12];
                        end
                    end else begin
                        mux = mask[19:16];
                        bitnr[3] = 1'b0;
                        bitnr[2] = 1'b0;
                    end
                end else begin
                    mux = mask[23:20];
                    bitnr[3] = 1'b0;
                end
            end else begin
                mux = mask[27:24];
                bitnr[2] = 1'b0;
            end
        end else begin
            mux = mask[31:28];
        end

        if (mux[3:2] == 2'b00) begin
            bitnr[1] = 1'b0;
            if (mux[1] == 1'b0) begin
                bitnr[0] = 1'b0;
                if (mux[0] == 1'b0) mask_not_zero = 1'b0;
            end
        end else begin
            if (mux[3] == 1'b0) bitnr[0] = 1'b0;
        end
    end

    // Rotation
    always_comb begin
        case (exe_opcode[7:6])
            2'b00: rot_rot = OP1out[7];   // Byte
            2'b01, 2'b11: rot_rot = OP1out[15]; // Word
            2'b10: rot_rot = OP1out[31];  // Long
            default: rot_rot = 1'b0;
        endcase

        case (rot_bits)
            2'b00: begin // ASL, ASR
                rot_lsb = 1'b0;
                rot_msb = rot_rot;
            end
            2'b01: begin // LSL, LSR
                rot_lsb = 1'b0;
                rot_msb = 1'b0;
            end
            2'b10: begin // ROXL, ROXR
                rot_lsb = Flags[4];
                rot_msb = Flags[4];
            end
            2'b11: begin // ROL, ROR
                rot_lsb = rot_rot;
                rot_msb = OP1out[0];
            end
            default: begin
                 rot_lsb = 1'b0;
                 rot_msb = 1'b0;
            end
        endcase

        if (exec[rot_nop] == 1'b1) begin
            rot_out = OP1out;
            rot_X = Flags[4];
            if (rot_bits == 2'b10) rot_C = Flags[4]; // ROXL, ROXR
            else                   rot_C = 1'b0;
        end else begin
            if (exe_opcode[8] == 1'b1) begin // left
                rot_out = {OP1out[30:0], rot_lsb};
                rot_X = rot_rot;
                rot_C = rot_rot;
            end else begin // right
                rot_X = OP1out[0];
                rot_C = OP1out[0];
                rot_out = {rot_msb, OP1out[31:1]};
                case (exe_opcode[7:6])
                    2'b00: rot_out[7] = rot_msb; // Byte
                    2'b01, 2'b11: rot_out[15] = rot_msb; // Word
                    default: ;
                endcase
            end
            if (BarrelShifter != 0) begin
                rot_out = BSout;
            end
        end
    end

    // Barrel Shifter
    always_comb begin
        ring = 6'b100000;
        if (rot_bits == 2'b10) begin // ROX L/R
            case (exe_opcode[7:6])
                2'b00: ring = 6'b001001; // Byte
                2'b01, 2'b11: ring = 6'b010001; // Word
                2'b10: ring = 6'b100001; // Long
                default: ;
            endcase
        end else begin
            case (exe_opcode[7:6])
                2'b00: ring = 6'b001000; // Byte
                2'b01, 2'b11: ring = 6'b010000; // Word
                2'b10: ring = 6'b100000; // Long
                default: ;
            endcase
        end

        if (exe_opcode[7:6] == 2'b11 || exec[exec_BS] == 1'b0) begin
            bs_shift = 6'b000001;
        end else if (exe_opcode[5] == 1'b1) begin
            bs_shift = OP2out[5:0];
        end else begin
            bs_shift[2:0] = exe_opcode[11:9];
            if (exe_opcode[11:9] == 3'b000) bs_shift[5:3] = 3'b001;
            else                            bs_shift[5:3] = 3'b000;
        end

        // Calc V-Flag by ASL
        bit_msb = 6'b000000;
        hot_msb = 34'b0;
        if (bs_shift < ring) begin
            bit_msb = ring - bs_shift;
        end
        hot_msb[bit_msb] = 1'b1;

        asl_over_xor = ({1'b0, vector[30:0]} ^ {1'b0, vector[31:1]}) & {33{msb}};
        case (exe_opcode[7:6])
            2'b00: asl_over_xor[8] = 1'b0; // Byte
            2'b01, 2'b11: asl_over_xor[16] = 1'b0; // Word
            default: ;
        endcase
        asl_over = asl_over_xor - {1'b0, hot_msb[31:0]};
        bs_V = 1'b0;
        if (rot_bits == 2'b00 && exe_opcode[8] == 1'b1) begin // ASL
            bs_V = ~asl_over[32];
        end

        bs_X = bs_C;
        if (exe_opcode[8] == 1'b0) begin // right shift
            bs_C = result_bs[31];
        end else begin // left shift
            case (exe_opcode[7:6])
                2'b00: bs_C = result_bs[8]; // Byte
                2'b01, 2'b11: bs_C = result_bs[16]; // Word
                2'b10: bs_C = result_bs[32]; // Long
                default: ;
            endcase
        end

        ALU = 32'bx;
        if (rot_bits == 2'b11) begin // RO L/R
            bs_X = Flags[4];
            case (exe_opcode[7:6])
                2'b00: begin // Byte
                    ALU[7:0] = result_bs[7:0] | result_bs[15:8];
                    bs_C = ALU[7];
                end
                2'b01, 2'b11: begin // Word
                    ALU[15:0] = result_bs[15:0] | result_bs[31:16];
                    bs_C = ALU[15];
                end
                2'b10: begin // Long
                    ALU = result_bs[31:0] | result_bs[63:32];
                    bs_C = ALU[31];
                end
                default: ;
            endcase
            if (exe_opcode[8] == 1'b1) bs_C = ALU[0]; // left shift
        end else if (rot_bits == 2'b10) begin // ROX L/R
            case (exe_opcode[7:6])
                2'b00: begin // Byte
                    ALU[7:0] = result_bs[7:0] | result_bs[16:9];
                    bs_C = result_bs[8] | result_bs[17];
                end
                2'b01, 2'b11: begin // Word
                    ALU[15:0] = result_bs[15:0] | result_bs[32:17];
                    bs_C = result_bs[16] | result_bs[33];
                end
                2'b10: begin // Long
                    ALU = result_bs[31:0] | result_bs[64:33];
                    bs_C = result_bs[32] | result_bs[65];
                end
                default: ;
            endcase
        end else begin
            if (exe_opcode[8] == 1'b0) ALU = result_bs[63:32]; // right shift
            else                       ALU = result_bs[31:0];  // left shift
        end

        if (bs_shift == 6'b000000) begin
            if (rot_bits == 2'b10) bs_C = Flags[4]; // ROX L/R
            else                   bs_C = 1'b0;
            bs_X = Flags[4];
            bs_V = 1'b0;
        end

        // calc shift count mod
        case (ring)
            6'b001001: begin
                if (bs_shift == 63) bs_shift_mod = 6'b000000;
                else if (bs_shift > 53) bs_shift_mod = bs_shift - 6'd54;
                else if (bs_shift > 44) bs_shift_mod = bs_shift - 6'd45;
                else if (bs_shift > 35) bs_shift_mod = bs_shift - 6'd36;
                else if (bs_shift > 26) bs_shift_mod = bs_shift - 6'd27;
                else if (bs_shift > 17) bs_shift_mod = bs_shift - 6'd18;
                else if (bs_shift > 8)  bs_shift_mod = bs_shift - 6'd9;
                else                    bs_shift_mod = bs_shift;
            end
            6'b010001: begin
                if (bs_shift > 50) bs_shift_mod = bs_shift - 6'd51;
                else if (bs_shift > 33) bs_shift_mod = bs_shift - 6'd34;
                else if (bs_shift > 16) bs_shift_mod = bs_shift - 6'd17;
                else                    bs_shift_mod = bs_shift;
            end
            6'b100001: begin
                if (bs_shift > 32) bs_shift_mod = bs_shift - 6'd33;
                else               bs_shift_mod = bs_shift;
            end
            6'b001000: bs_shift_mod = {3'b000, bs_shift[2:0]};
            6'b010000: bs_shift_mod = {2'b00, bs_shift[3:0]};
            6'b100000: bs_shift_mod = {1'b0, bs_shift[4:0]};
            default: bs_shift_mod = 6'b0;
        endcase

        bit_nr = bs_shift_mod;
        if (exe_opcode[8] == 1'b0) bit_nr = ring - bs_shift_mod; // right shift

        if (rot_bits[1] == 1'b0) begin // only shift
            if (exe_opcode[8] == 1'b0) bit_nr = 6'd32 - bs_shift_mod; // right shift

            if (bs_shift == ring) begin
                if (exe_opcode[8] == 1'b0) bit_nr = 6'd32 - ring;
                else                       bit_nr = ring;
            end
            if (bs_shift > ring) begin
                if (exe_opcode[8] == 1'b0) begin // right shift
                    bit_nr = 6'b000000;
                    bs_C = 1'b0;
                end else begin
                    bit_nr = ring + 6'd1;
                end
            end
        end

        // Calc ASR sign
        BSout = ALU;
        asr_sign = 33'b0;

        asr_sign[0] = 1'b0;
        for (int k=0; k<32; k++) begin
            asr_sign[k+1] = asr_sign[k] | hot_msb[k];
        end

        if (rot_bits == 2'b00 && exe_opcode[8] == 1'b0 && msb == 1'b1) begin // ASR
             BSout = ALU | asr_sign[32:1];
             if (bs_shift > ring) bs_C = 1'b1;
        end

        vector[32:0] = {1'b0, OP1out};
        case (exe_opcode[7:6])
            2'b00: begin // Byte
                msb = OP1out[7];
                vector[31:8] = 24'b0;
                BSout[31:8] = 24'b0;
                if (rot_bits == 2'b10) vector[8] = Flags[4]; // ROX
            end
            2'b01, 2'b11: begin // Word
                msb = OP1out[15];
                vector[31:16] = 16'b0;
                BSout[31:16] = 16'b0;
                if (rot_bits == 2'b10) vector[16] = Flags[4]; // ROX
            end
            2'b10: begin // Long
                msb = OP1out[31];
                if (rot_bits == 2'b10) vector[32] = Flags[4]; // ROX
            end
            default: msb = 1'b0;
        endcase

        // result_bs <= std_logic_vector(unsigned('0'&X"00000000"&vector) sll to_integer(unsigned(bit_nr(5 downto 0))));
        result_bs = {1'b0, 32'b0, vector} << bit_nr;
    end

    // CCR op and Flags
    always_comb begin
        if (exec[andiSR] == 1'b1) begin
            CCRin = Flags & last_data_read[7:0];
        end else if (exec[eoriSR] == 1'b1) begin
            CCRin = Flags ^ last_data_read[7:0];
        end else if (exec[oriSR] == 1'b1) begin
            CCRin = Flags | last_data_read[7:0];
        end else begin
            CCRin = OP2out[7:0];
        end

        flag_z = 3'b000;
        if (exec[use_XZFlag] == 1'b1 && Flags[2] == 1'b0) begin
            flag_z = 3'b000;
        end else if (OP1in[7:0] == 8'b0) begin
            flag_z[0] = 1'b1;
            if (OP1in[15:8] == 8'b0) begin
                flag_z[1] = 1'b1;
                if (OP1in[31:16] == 16'b0) begin
                    flag_z[2] = 1'b1;
                end
            end
        end

        if (exe_datatype == 2'b00) begin // Byte
            set_Flags = {OP1in[7], flag_z[0], addsub_ofl[0], c_out[0]};
            if (exec[opcABCD] == 1'b1 || exec[opcSBCD] == 1'b1) begin
                set_Flags[0] = bcd_a_carry;
                set_Flags[1] = Vflag_a;
            end
        end else if (exe_datatype == 2'b10 || exec[opcCPMAW] == 1'b1) begin // Long
            set_Flags = {OP1in[31], flag_z[2], addsub_ofl[2], c_out[2]};
        end else begin // Word
            set_Flags = {OP1in[15], flag_z[1], addsub_ofl[1], c_out[1]};
        end
    end

    // Flag update
    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            Flags <= 8'b00000000;
        end else if (clkena_lw == 1'b1) begin
            if (exec[directSR] == 1'b1 || set_stop == 1'b1) begin
                Flags <= data_read[7:0];
            end
            if (exec[directCCR] == 1'b1) begin
                Flags <= data_read[7:0];
            end

            if (exec[opcROT] == 1'b1 && decodeOPC == 1'b0) begin
                asl_VFlag <= (set_Flags[3] ^ rot_rot) | asl_VFlag;
            end else begin
                asl_VFlag <= 1'b0;
            end

            if (exec[to_CCR] == 1'b1) begin
                Flags <= CCRin;
            end else if (Z_error == 1'b1) begin
                if (micro_state == trap0) begin
                    // Undocumented behavior
                    if (exe_opcode[8] == 1'b0) begin
                        Flags[3:0] <= {1'b0, ~reg_QA[31], 2'b00};
                    end else begin
                        Flags[3:0] <= 4'b0100;
                    end
                end
            end else if (exec[no_Flags] == 1'b0) begin
                last_Flags1 <= Flags[3:0];
                if (exec[opcADD] == 1'b1) begin
                    Flags[4] <= set_Flags[0];
                end else if (exec[opcROT] == 1'b1 && rot_bits != 2'b11 && exec[rot_nop] == 1'b0) begin
                    Flags[4] <= rot_X;
                end else if (exec[exec_BS] == 1'b1) begin
                    Flags[4] <= bs_X;
                end

                if (exec[opcCMP] == 1'b1 || exec[alu_setFlags] == 1'b1) begin
                    Flags[3:0] <= set_Flags;
                end else if (exec[opcDIVU] == 1'b1 && DIV_Mode != 3) begin
                    if (V_Flag == 1'b1) begin
                        Flags[3:0] <= 4'b1010;
                    end else if (exe_opcode[15] == 1'b1 || DIV_Mode == 0) begin
                        Flags[3:0] <= {OP1in[15], flag_z[1], 2'b00};
                    end else begin
                        Flags[3:0] <= {OP1in[31], flag_z[2], 2'b00};
                    end
                end else if (exec[write_reminder] == 1'b1 && MUL_Mode != 3) begin
                    Flags[3] <= set_Flags[3];
                    Flags[2] <= set_Flags[2] & Flags[2];
                    Flags[1] <= 1'b0;
                    Flags[0] <= 1'b0;
                end else if (exec[write_lowlong] == 1'b1 && (MUL_Mode == 1 || MUL_Mode == 2)) begin
                    Flags[3] <= set_Flags[3];
                    Flags[2] <= set_Flags[2];
                    Flags[1] <= set_mV_Flag;
                    Flags[0] <= 1'b0;
                end else if (exec[opcOR] == 1'b1 || exec[opcAND] == 1'b1 || exec[opcEOR] == 1'b1 || exec[opcMOVE] == 1'b1 || exec[opcMOVEQ] == 1'b1 || exec[opcSWAP] == 1'b1 || exec[opcBF] == 1'b1 || (exec[opcMULU] == 1'b1 && MUL_Mode != 3)) begin
                    Flags[1:0] <= 2'b00;
                    Flags[3:2] <= set_Flags[3:2];
                    if (exec[opcBF] == 1'b1) Flags[3] <= bf_NFlag;
                end else if (exec[opcROT] == 1'b1) begin
                    Flags[3:2] <= set_Flags[3:2];
                    Flags[0] <= rot_C;
                    if (rot_bits == 2'b00 && ((set_Flags[3] ^ rot_rot) | asl_VFlag) == 1'b1) begin
                        Flags[1] <= 1'b1;
                    end else begin
                        Flags[1] <= 1'b0;
                    end
                end else if (exec[exec_BS] == 1'b1) begin
                    Flags[3:2] <= set_Flags[3:2];
                    Flags[0] <= bs_C;
                    Flags[1] <= bs_V;
                end else if (exec[opcBITS] == 1'b1) begin
                    Flags[2] <= ~one_bit_in;
                end else if (exec[opcCHK2] == 1'b1) begin
                    if (last_Flags1[0] == 1'b0) begin // unsigned
                        Flags[0] <= Flags[0] | (~set_Flags[0] & ~set_Flags[2]);
                    end else begin // signed
                        Flags[0] <= (Flags[0] ^ set_Flags[0]) & ~Flags[2] & ~set_Flags[2];
                    end
                    Flags[1] <= 1'b0;
                    Flags[2] <= Flags[2] | set_Flags[2];
                    Flags[3] <= ~last_Flags1[0];
                end else if (exec[opcCHK] == 1'b1) begin
                    if (exe_datatype == 2'b01) Flags[3] <= OP1out[15];
                    else                       Flags[3] <= OP1out[31];

                    if (OP1out[15:0] == 16'b0 && (exe_datatype == 2'b01 || OP1out[31:16] == 16'b0)) begin
                        Flags[2] <= 1'b1;
                    end else begin
                        Flags[2] <= 1'b0;
                    end
                    Flags[1] <= 1'b0;
                    Flags[0] <= 1'b0;
                end
            end
            Flags[7:5] <= 3'b000;
        end
    end

    // MULU/MULS
    always_comb begin
        muls_msb = 1'b0;
        mulu_sign = 1'b0;
        set_mV_Flag = 1'b0;
        result_mulu = 128'b0;
        faktorA = 32'b0;
        faktorB = 32'b0;

        if (MUL_Hardware == 1) begin
            if (MUL_Mode == 0) begin // 16 Bit
                if (signedOP == 1'b1 && reg_QA[15] == 1'b1) faktorA = 32'hFFFFFFFF;
                else                                        faktorA = 32'h00000000;

                if (signedOP == 1'b1 && OP2out[15] == 1'b1) faktorB = 32'hFFFFFFFF;
                else                                        faktorB = 32'h00000000;

                result_mulu[63:0] = $signed({faktorA[15:0], reg_QA[15:0]}) * $signed({faktorB[15:0], OP2out[15:0]});
            end else begin
                if (exe_opcode[15] == 1'b1) begin // 16 Bit
                     if (signedOP == 1'b1 && reg_QA[15] == 1'b1) faktorA = 32'hFFFFFFFF;
                     else                                        faktorA = 32'h00000000;

                     if (signedOP == 1'b1 && OP2out[15] == 1'b1) faktorB = 32'hFFFFFFFF;
                     else                                        faktorB = 32'h00000000;

                     result_mulu[127:0] = $signed({faktorA[31:16], faktorA[31:0], reg_QA[15:0]}) * $signed({faktorB[31:16], faktorB[31:0], OP2out[15:0]});
                end else begin
                    faktorA[15:0] = reg_QA[31:16];
                    faktorB[15:0] = OP2out[31:16];
                    if (signedOP == 1'b1 && reg_QA[31] == 1'b1) faktorA[31:16] = 16'hFFFF;
                    else                                        faktorA[31:16] = 16'h0000;

                    if (signedOP == 1'b1 && OP2out[31] == 1'b1) faktorB[31:16] = 16'hFFFF;
                    else                                        faktorB[31:16] = 16'h0000;

                    result_mulu = $signed({faktorA[31:16], faktorA[31:0], reg_QA[15:0]}) * $signed({faktorB[31:16], faktorB[31:0], OP2out[15:0]});
                end
            end
        end else begin // MUL_Hardware == 0 (Serial Multiplier)
            if ((signedOP == 1'b1 && faktorB[31] == 1'b1) || FAsign == 1'b1) begin
                muls_msb = mulu_reg[63];
            end else begin
                muls_msb = 1'b0;
            end

            if (signedOP == 1'b1 && faktorB[31] == 1'b1) begin
                mulu_sign = 1'b1;
            end else begin
                mulu_sign = 1'b0;
            end

            if (MUL_Mode == 0) begin // 16 Bit
                result_mulu[63:32] = {muls_msb, mulu_reg[63:33]};
                result_mulu[15:0] = {1'bx, mulu_reg[15:1]};
                if (mulu_reg[0] == 1'b1) begin
                    if (FAsign == 1'b1) begin
                        result_mulu[63:47] = {muls_msb, mulu_reg[63:48]} - {mulu_sign, faktorB[31:16]};
                    end else begin
                        result_mulu[63:47] = {muls_msb, mulu_reg[63:48]} + {mulu_sign, faktorB[31:16]};
                    end
                end
            end else begin // 32 Bit
                result_mulu[63:0] = {muls_msb, mulu_reg[63:1]};
                if (mulu_reg[0] == 1'b1) begin
                    if (FAsign == 1'b1) begin
                        result_mulu[63:31] = {muls_msb, mulu_reg[63:32]} - {mulu_sign, faktorB};
                    end else begin
                        result_mulu[63:31] = {muls_msb, mulu_reg[63:32]} + {mulu_sign, faktorB};
                    end
                end
            end

            if (exe_opcode[15] == 1'b1 || MUL_Mode == 0) begin
                faktorB[31:16] = OP2out[15:0];
                faktorB[15:0] = 16'b0;
            end else begin
                faktorB = OP2out;
            end
        end

        if ((result_mulu[63:32] == 32'h00000000 && (signedOP == 1'b0 || result_mulu[31] == 1'b0)) ||
            (result_mulu[63:32] == 32'hFFFFFFFF && signedOP == 1'b1 && result_mulu[31] == 1'b1)) begin
            set_mV_Flag = 1'b0;
        end else begin
            set_mV_Flag = 1'b1;
        end
    end

    // Mulu Reg
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            if (MUL_Hardware == 0) begin
                if (micro_state == mul1) begin
                    mulu_reg[63:32] <= 32'b0;
                    if (divs == 1'b1 && ((exe_opcode[15] == 1'b1 && reg_QA[15] == 1'b1) || (exe_opcode[15] == 1'b0 && reg_QA[31] == 1'b1))) begin // MULS Neg faktor
                        FAsign <= 1'b1;
                        mulu_reg[31:0] <= -reg_QA;
                    end else begin
                        FAsign <= 1'b0;
                        mulu_reg[31:0] <= reg_QA;
                    end
                end else if (exec[opcMULU] == 1'b0) begin
                    mulu_reg <= result_mulu[63:0];
                end
            end else begin
                mulu_reg[31:0] <= result_mulu[63:32];
            end
        end
    end

    // DIVU/DIVS
    always_comb begin
        divs = (opcode[15] & opcode[8]) | (~opcode[15] & sndOPC[11]);
        dividend[15:0] = 16'b0;
        dividend[63:32] = {32{divs & reg_QA[31]}};
        if (exe_opcode[15] == 1'b1 || DIV_Mode == 0) begin // DIV.W
            dividend[47:16] = reg_QA;
            div_qsign = result_div_pre[15];
        end else begin // DIV.l
            dividend[31:0] = reg_QA;
            if (exe_opcode[14] == 1'b1 && sndOPC[10] == 1'b1) begin
                dividend[63:32] = reg_QB;
            end
            div_qsign = result_div_pre[31];
        end

        if (signedOP == 1'b1 || opcode[15] == 1'b0) begin
            OP2outext = OP2out[31:16];
        end else begin
            OP2outext = 16'b0;
        end

        if (signedOP == 1'b1 && OP2out[31] == 1'b1) begin
            div_sub = div_reg[63:31] + {1'b1, OP2out[31:0]};
        end else begin
            div_sub = div_reg[63:31] - {1'b0, OP2outext, OP2out[15:0]};
        end

        if (DIV_Mode == 0) begin
            div_bit = div_sub[16];
        end else begin
            div_bit = div_sub[32];
        end

        if (div_bit == 1'b1) begin
            div_quot[63:32] = div_reg[62:31];
        end else begin
            div_quot[63:32] = div_sub[31:0];
        end
        div_quot[31:0] = {div_reg[30:0], ~div_bit};

        if (div_neg == 1'b1) begin
            result_div_pre = -div_quot[31:0];
        end else begin
            result_div_pre = div_quot[31:0];
        end

        if ((((nozero == 1'b1 || div_bit == 1'b0) && signedOP == 1'b1 && (OP2out[31] ^ OP1_sign ^ div_qsign) == 1'b1) ||
             (signedOP == 1'b0 && div_over[32] == 1'b0)) && DIV_Mode != 3) begin
            set_V_Flag = 1'b1;
        end else begin
            set_V_Flag = 1'b0;
        end
    end

    // DIV Reg
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            if (micro_state != div_end2) begin
                V_Flag <= set_V_Flag;
            end
            signedOP <= divs;
            if (micro_state == div1) begin
                nozero <= 1'b0;
                if (divs == 1'b1 && dividend[63] == 1'b1) begin // Neg dividend
                    OP1_sign <= 1'b1;
                    div_reg <= -dividend;
                end else begin
                    OP1_sign <= 1'b0;
                    div_reg <= dividend;
                end
            end else begin
                div_reg <= div_quot;
                nozero <= ~div_bit | nozero;
            end

            if (micro_state == div2) begin
                div_neg <= signedOP & (OP2out[31] ^ OP1_sign);
                if (DIV_Mode == 0) begin
                    div_over[32:16] <= {1'b0, div_reg[47:32]} - {1'b0, OP2out[15:0]};
                end else begin
                    div_over <= {1'b0, div_reg[63:32]} - {1'b0, OP2outext, OP2out[15:0]};
                end
            end

            if (exec[write_reminder] == 1'b0) begin
                result_div[31:0] <= result_div_pre;
                if (OP1_sign == 1'b1) begin
                    result_div[63:32] <= -div_quot[63:32];
                end else begin
                    result_div[63:32] <= div_quot[63:32];
                end
            end
        end
    end

endmodule
