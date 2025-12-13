
module TG68KdotC_Kernel #(
    parameter int SR_Read        = 2, // 0=>user, 1=>privileged, 2=>switchable with CPU(0)
    parameter int VBR_Stackframe = 2, // 0=>no, 1=>yes/extended, 2=>switchable with CPU(0)
    parameter int extAddr_Mode   = 2, // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter int MUL_Mode       = 2, // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no MUL
    parameter int DIV_Mode       = 2, // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no DIV
    parameter int BitField       = 2, // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter int BarrelShifter  = 1, // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter int MUL_Hardware   = 1  // 0=>no, 1=>yes
) (
    input  logic        clk,
    input  logic        nReset,      // low active
    input  logic        clkena_in,
    input  logic [15:0] data_in,
    input  logic [2:0]  IPL,
    input  logic        IPL_autovector,
    input  logic        berr,
    input  logic [1:0]  CPU,         // 00->68000 01->68010 11->68020
    output logic [31:0] addr_out,
    output logic [15:0] data_write,
    output logic        nWr,
    output logic        nUDS,
    output logic        nLDS,
    output logic [1:0]  busstate,    // 00-> fetch code 10->read data 11->write data 01->no memaccess
    output logic        longword,
    output logic        nResetOut,
    output logic [2:0]  FC,
    output logic        clr_berr,
    // for debug
    output logic        skipFetch,
    output logic [31:0] regin_out,
    output logic [3:0]  CACR_out,
    output logic [31:0] VBR_out
);

    import TG68K_Pack::*;

    logic        use_VBR_Stackframe;
    logic [3:0]  syncReset;
    logic        Reset;
    logic        clkena_lw;
    logic [31:0] TG68_PC;
    logic [31:0] tmp_TG68_PC;
    logic [31:0] TG68_PC_add;
    logic [31:0] PC_dataa;
    logic [31:0] PC_datab;
    logic [31:0] memaddr;
    logic [1:0]  state;
    logic [1:0]  datatype;
    logic [1:0]  set_datatype;
    logic [1:0]  exe_datatype;
    logic [1:0]  setstate;
    logic        setaddrvalue;
    logic        addrvalue;

    logic [15:0] opcode;
    logic [15:0] exe_opcode;
    logic [15:0] sndOPC;

    logic [31:0] exe_pc;
    logic [31:0] last_opc_pc;
    logic [15:0] last_opc_read;
    logic [31:0] registerin;
    logic [31:0] reg_QA;
    logic [31:0] reg_QB;
    logic        Wwrena, Lwrena;
    logic        Bwrena;
    logic        Regwrena_now;
    logic [3:0]  rf_dest_addr;
    logic [3:0]  rf_source_addr;
    logic [3:0]  rf_source_addrd;

    logic [31:0] regin;
    logic [31:0] regfile [0:15];
    int          RDindex_A;
    int          RDindex_B;
    logic        WR_AReg;

    logic [31:0] addr;
    logic [31:0] memaddr_reg;
    logic [31:0] memaddr_delta;
    logic [31:0] memaddr_delta_rega;
    logic [31:0] memaddr_delta_regb;
    logic        use_base;

    logic [31:0] ea_data;
    logic [31:0] OP1out;
    logic [31:0] OP2out;
    logic [15:0] OP1outbrief;
    logic [31:0] OP1in;
    logic [31:0] ALUout;
    logic [31:0] data_write_tmp;
    logic [31:0] data_write_muxin;
    logic [47:0] data_write_mux;
    logic        nextpass;
    logic        setnextpass;
    logic        setdispbyte;
    logic        setdisp;
    logic        regdirectsource;
    logic [31:0] addsub_q;
    logic [31:0] briefdata;
    logic [2:0]  c_out;

    logic [31:0] mem_address;
    logic [31:0] memaddr_a;

    logic        TG68_PC_brw;
    logic        TG68_PC_word;
    logic        getbrief;
    logic [15:0] brief;
    logic        data_is_source;
    logic        store_in_tmp;
    logic        write_back;
    logic        exec_write_back;
    logic        setstackaddr;
    logic        writePC;
    logic        writePCbig;
    logic        set_writePCbig;
    logic        writePCnext;
    logic        setopcode;
    logic        decodeOPC;
    logic        execOPC;
    logic        execOPC_ALU;
    logic        setexecOPC;
    logic        endOPC;
    logic        setendOPC;
    logic [7:0]  Flags;
    logic [7:0]  FlagsSR;
    logic [7:0]  SRin;
    logic        exec_DIRECT;
    logic        exec_tas;
    logic        set_exec_tas;

    logic        exe_condition;
    logic        ea_only;
    logic        source_areg;
    logic        source_lowbits;
    logic        source_LDRLbits;
    logic        source_LDRMbits;
    logic        source_2ndHbits;
    logic        source_2ndMbits;
    logic        source_2ndLbits;
    logic        dest_areg;
    logic        dest_LDRareg;
    logic        dest_LDRHbits;
    logic        dest_LDRLbits;
    logic        dest_2ndHbits;
    logic        dest_2ndLbits;
    logic        dest_hbits;
    logic [1:0]  rot_bits;
    logic [1:0]  set_rot_bits;
    logic [5:0]  rot_cnt;
    logic [5:0]  set_rot_cnt;
    logic        movem_actiond;
    logic [3:0]  movem_regaddr;
    logic [3:0]  movem_mux;
    logic        movem_presub;
    logic        movem_run;
    logic [31:0] ea_calc_b;
    logic        set_direct_data;
    logic        use_direct_data;
    logic        direct_data;

    logic        set_V_Flag;
    logic        set_vectoraddr;
    logic        writeSR;
    logic        trap_berr;
    logic        trap_illegal;
    logic        trap_addr_error;
    logic        trap_priv;
    logic        trap_trace;
    logic        trap_1010;
    logic        trap_1111;
    logic        trap_trap;
    logic        trap_trapv;
    logic        trap_interrupt;
    logic        trapmake;
    logic        trapd;
    logic [7:0]  trap_SR;
    logic        make_trace;
    logic        make_berr;
    logic        useStackframe2;

    logic        set_stop;
    logic        stop;
    logic [31:0] trap_vector;
    logic [31:0] trap_vector_vbr;
    logic [31:0] USP;

    logic [2:0]  IPL_nr;
    logic [2:0]  rIPL_nr;
    logic [7:0]  IPL_vec;
    logic        interrupt;
    logic        setinterrupt;
    logic        SVmode;
    logic        preSVmode;
    logic        Suppress_Base;
    logic        set_Suppress_Base;
    logic        set_Z_error;
    logic        Z_error;
    logic        ea_build_now;
    logic        build_logical;
    logic        build_bcd;

    logic [31:0] data_read;
    logic [7:0]  bf_ext_in;
    logic [7:0]  bf_ext_out;
    logic        long_start;
    logic        long_start_alu;
    logic        non_aligned;
    logic        check_aligned;
    logic        long_done;
    logic [5:0]  memmask;
    logic [5:0]  set_memmask;
    logic [3:0]  memread;
    logic [5:0]  wbmemmask;
    logic [5:0]  memmaskmux;
    logic        oddout;
    logic        set_oddout;
    logic        PCbase;
    logic        set_PCbase;

    logic [31:0] last_data_read;
    logic [31:0] last_data_in;

    logic [5:0]  bf_offset;
    logic [5:0]  bf_width;
    logic [5:0]  bf_bhits;
    logic [5:0]  bf_shift;
    logic [5:0]  alu_width;
    logic [5:0]  alu_bf_shift;
    logic [5:0]  bf_loffset;
    logic [31:0] bf_full_offset;
    logic [31:0] alu_bf_ffo_offset;
    logic [5:0]  alu_bf_loffset;

    logic [31:0] movec_data;
    logic [31:0] VBR;
    logic [3:0]  CACR;
    logic [2:0]  DFC;
    logic [2:0]  SFC;

    logic [TG68K_Pack::lastOpcBit:0] set;
    logic [TG68K_Pack::lastOpcBit:0] set_exec;
    logic [TG68K_Pack::lastOpcBit:0] exec;

    TG68K_Pack::micro_states micro_state;
    TG68K_Pack::micro_states next_micro_state;

    TG68K_ALU #(
        .MUL_Mode(MUL_Mode),
        .MUL_Hardware(MUL_Hardware),
        .DIV_Mode(DIV_Mode),
        .BarrelShifter(BarrelShifter)
    ) ALU (
        .clk(clk),
        .Reset(Reset),
        .CPU(CPU),
        .clkena_lw(clkena_lw),
        .execOPC(execOPC_ALU),
        .decodeOPC(decodeOPC),
        .exe_condition(exe_condition),
        .exec_tas(exec_tas),
        .long_start(long_start_alu),
        .non_aligned(non_aligned),
        .check_aligned(check_aligned),
        .movem_presub(movem_presub),
        .set_stop(set_stop),
        .Z_error(Z_error),
        .rot_bits(rot_bits),
        .exec(exec),
        .OP1out(OP1out),
        .OP2out(OP2out),
        .reg_QA(reg_QA),
        .reg_QB(reg_QB),
        .opcode(opcode),
        .exe_opcode(exe_opcode),
        .exe_datatype(exe_datatype),
        .sndOPC(sndOPC),
        .last_data_read(last_data_read[15:0]),
        .data_read(data_read[15:0]),
        .FlagsSR(FlagsSR),
        .micro_state(micro_state),
        .bf_ext_in(bf_ext_in),
        .bf_ext_out(bf_ext_out),
        .bf_shift(alu_bf_shift),
        .bf_width(alu_width),
        .bf_ffo_offset(alu_bf_ffo_offset),
        .bf_loffset(alu_bf_loffset[4:0]),
        .set_V_Flag(set_V_Flag),
        .Flags(Flags),
        .c_out(c_out),
        .addsub_q(addsub_q),
        .ALUout(ALUout)
    );

    assign longword = ~memmaskmux[3];
    assign long_start_alu = ~memmaskmux[3];
    assign execOPC_ALU = execOPC | exec[alu_exec];

    always_comb begin
        non_aligned = 1'b0;
        if (memmaskmux[5:4] == 2'b01 || memmaskmux[5:4] == 2'b10) begin
            non_aligned = 1'b1;
        end
    end

    // Bus control
    assign regin_out = regin;
    assign nWr = (state == 2'b11) ? 1'b0 : 1'b1;
    assign busstate = state;
    assign nResetOut = (exec[opcRESET] == 1'b1) ? 1'b0 : 1'b1;

    assign memmaskmux = (addr[0] == 1'b1) ? memmask : {memmask[4:0], 1'b1};
    assign nUDS = memmaskmux[5];
    assign nLDS = memmaskmux[4];
    assign clkena_lw = (clkena_in == 1'b1 && memmaskmux[3] == 1'b1) ? 1'b1 : 1'b0;
    assign clr_berr = (setopcode == 1'b1 && trap_berr == 1'b1) ? 1'b1 : 1'b0;

    always_ff @(posedge clk or negedge nReset) begin
        if (nReset == 1'b0) begin
            syncReset <= 4'b0000;
            Reset <= 1'b1;
        end else if (clkena_in == 1'b1) begin
            syncReset <= {syncReset[2:0], 1'b1};
            Reset <= ~syncReset[3];
        end
    end

    always_ff @(posedge clk) begin
        if (VBR_Stackframe == 1 || (CPU[0] == 1'b1 && VBR_Stackframe == 2)) begin
            use_VBR_Stackframe <= 1'b1;
        end else begin
            use_VBR_Stackframe <= 1'b0;
        end
    end

    always_comb begin
        if (memmaskmux[4] == 1'b0) begin
            data_read = {last_data_in[15:0], data_in};
        end else begin
            data_read = {last_data_in[23:0], data_in[15:8]};
        end
        if (memread[0] == 1'b1 || (memread[1:0] == 2'b10 && memmaskmux[4] == 1'b1)) begin
            data_read[31:16] = {16{data_read[15]}};
        end

        long_start = ~memmask[1];
        long_done = ~memread[1];
    end

    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1 && state == 2'b10) begin
            if (memmaskmux[4] == 1'b0) begin
                bf_ext_in <= last_data_in[23:16];
            end else begin
                bf_ext_in <= last_data_in[31:24];
            end
        end
        if (Reset == 1'b1) begin
            last_data_read <= 32'b0;
        end else if (clkena_in == 1'b1) begin
            if (state == 2'b00 || exec[update_ld] == 1'b1) begin
                last_data_read <= data_read;
                if (state[1] == 1'b0 && memmask[1] == 1'b0) begin
                    last_data_read[31:16] <= last_opc_read;
                end else if (state[1] == 1'b0 || memread[1] == 1'b1) begin
                    last_data_read[31:16] <= {16{data_in[15]}};
                end
            end
            last_data_in <= {last_data_in[15:0], data_in[15:0]};
        end
    end

    always_comb begin
        if (exec[write_reg] == 1'b1) begin
            data_write_muxin = reg_QB;
        end else begin
            data_write_muxin = data_write_tmp;
        end

        if (BitField == 0) begin
            if (oddout == addr[0]) begin
                data_write_mux = {8'bx, 8'bx, data_write_muxin};
            end else begin
                data_write_mux = {8'bx, data_write_muxin, 8'bx};
            end
        end else begin
            if (oddout == addr[0]) begin
                data_write_mux = {8'bx, bf_ext_out, data_write_muxin};
            end else begin
                data_write_mux = {bf_ext_out, data_write_muxin, 8'bx};
            end
        end

        if (memmaskmux[1] == 1'b0) begin
            data_write = data_write_mux[47:32];
        end else if (memmaskmux[3] == 1'b0) begin
            data_write = data_write_mux[31:16];
        end else begin
            // a single byte shows up on both bus halves
            if (memmaskmux[5:4] == 2'b10) begin
                data_write = {data_write_mux[7:0], data_write_mux[7:0]};
            end else if (memmaskmux[5:4] == 2'b01) begin
                data_write = {data_write_mux[15:8], data_write_mux[15:8]};
            end else begin
                data_write = data_write_mux[15:0];
            end
        end
        if (exec[mem_byte] == 1'b1) begin // movep
            data_write[7:0] = data_write_tmp[15:8];
        end
    end

    // Registerfile
    // Initialize regfile to 0 to prevent X issues
    initial begin
        for (int k = 0; k < 16; k++) regfile[k] = 32'b0;
    end

    always_comb begin
        reg_QA = regfile[RDindex_A];
        reg_QB = regfile[RDindex_B];
    end

    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            rf_source_addrd <= rf_source_addr;
            WR_AReg <= rf_dest_addr[3];
            RDindex_A <= rf_dest_addr[3:0];
            RDindex_B <= rf_source_addr[3:0];
            if (Wwrena == 1'b1) begin
                regfile[RDindex_A] <= regin;
            end
            if (exec[to_USP] == 1'b1) begin
                USP <= reg_QA;
            end
        end
    end

    // Write Reg
    always_comb begin
        regin = ALUout;
        if (exec[save_memaddr] == 1'b1) begin
            regin = memaddr;
        end else if (exec[get_ea_now] == 1'b1 && ea_only == 1'b1) begin
            regin = memaddr_a;
        end else if (exec[from_USP] == 1'b1) begin
            regin = USP;
        end else if (exec[movec_rd] == 1'b1) begin
            regin = movec_data;
        end

        if (Bwrena == 1'b1) begin
            regin[15:8] = reg_QA[15:8];
        end
        if (Lwrena == 1'b0) begin
            regin[31:16] = reg_QA[31:16];
        end

        Bwrena = 1'b0;
        Wwrena = 1'b0;
        Lwrena = 1'b0;
        if (exec[presub] == 1'b1 || exec[postadd] == 1'b1 || exec[changeMode] == 1'b1) begin // -(An)+
            Wwrena = 1'b1;
            Lwrena = 1'b1;
        end else if (Regwrena_now == 1'b1) begin // dbcc
            Wwrena = 1'b1;
        end else if (exec[Regwrena] == 1'b1) begin // read (mem)
            Wwrena = 1'b1;
            case (exe_datatype)
                2'b00: begin // BYTE
                    Bwrena = 1'b1;
                end
                2'b01: begin // WORD
                    if (WR_AReg == 1'b1 || movem_actiond == 1'b1) begin
                        Lwrena = 1'b1;
                    end
                end
                default: begin // LONG
                    Lwrena = 1'b1;
                end
            endcase
        end
    end

    // set dest regaddr
    always_comb begin
        if (exec[movem_action] == 1'b1) begin
            rf_dest_addr = rf_source_addrd;
        end else if (set[briefext] == 1'b1) begin
            rf_dest_addr = brief[15:12];
        end else if (set[get_bfoffset] == 1'b1) begin
            rf_dest_addr = {1'b0, sndOPC[8:6]};
        end else if (dest_2ndHbits == 1'b1) begin
            rf_dest_addr = {dest_LDRareg, sndOPC[14:12]};
        end else if (dest_LDRHbits == 1'b1) begin
            rf_dest_addr = last_data_read[15:12];
        end else if (dest_LDRLbits == 1'b1) begin
            rf_dest_addr = {1'b0, last_data_read[2:0]};
        end else if (dest_2ndLbits == 1'b1) begin
            rf_dest_addr = {1'b0, sndOPC[2:0]};
        end else if (setstackaddr == 1'b1) begin
            rf_dest_addr = 4'b1111;
        end else if (dest_hbits == 1'b1) begin
            rf_dest_addr = {dest_areg, opcode[11:9]};
        end else begin
            if (opcode[5:3] == 3'b000 || data_is_source == 1'b1) begin
                rf_dest_addr = {dest_areg, opcode[2:0]};
            end else begin
                rf_dest_addr = {1'b1, opcode[2:0]};
            end
        end
    end

    // set source regaddr
    always_comb begin
        if (exec[movem_action] == 1'b1 || set[movem_action] == 1'b1) begin
            if (movem_presub == 1'b1) begin
                rf_source_addr = movem_regaddr ^ 4'b1111;
            end else begin
                rf_source_addr = movem_regaddr;
            end
        end else if (source_2ndLbits == 1'b1) begin
            rf_source_addr = {1'b0, sndOPC[2:0]};
        end else if (source_2ndHbits == 1'b1) begin
            rf_source_addr = {1'b0, sndOPC[14:12]};
        end else if (source_2ndMbits == 1'b1) begin
            rf_source_addr = {1'b0, sndOPC[8:6]};
        end else if (source_LDRLbits == 1'b1) begin
            rf_source_addr = {1'b0, last_data_read[2:0]};
        end else if (source_LDRMbits == 1'b1) begin
            rf_source_addr = {1'b0, last_data_read[8:6]};
        end else if (source_lowbits == 1'b1) begin
            rf_source_addr = {source_areg, opcode[2:0]};
        end else if (exec[linksp] == 1'b1) begin
            rf_source_addr = 4'b1111;
        end else begin
            rf_source_addr = {source_areg, opcode[11:9]};
        end
    end

    // set OP1out
    always_comb begin
        OP1out = reg_QA;
        if (exec[OP1out_zero] == 1'b1) begin
            OP1out = 32'b0;
        end else if (exec[ea_data_OP1] == 1'b1 && store_in_tmp == 1'b1) begin
            OP1out = ea_data;
        end else if (exec[movem_action] == 1'b1 || memmaskmux[3] == 1'b0 || exec[OP1addr] == 1'b1) begin
            OP1out = addr;
        end
    end

    // set OP2out
    always_comb begin
        OP2out[15:0] = reg_QB[15:0];
        OP2out[31:16] = {16{OP2out[15]}};
        if (exec[OP2out_one] == 1'b1) begin
            OP2out[15:0] = 16'hFFFF;
        end else if (use_direct_data == 1'b1 || (exec[exg] == 1'b1 && execOPC == 1'b1) || exec[get_bfoffset] == 1'b1) begin
            OP2out = data_write_tmp;
        end else if ((exec[ea_data_OP1] == 1'b0 && store_in_tmp == 1'b1) || exec[ea_data_OP2] == 1'b1) begin
            OP2out = ea_data;
        end else if (exec[opcMOVEQ] == 1'b1) begin
            OP2out[7:0] = exe_opcode[7:0];
            OP2out[15:8] = {8{exe_opcode[7]}};
        end else if (exec[opcADDQ] == 1'b1) begin
            OP2out[2:0] = exe_opcode[11:9];
            if (exe_opcode[11:9] == 3'b000) begin
                OP2out[3] = 1'b1;
            end else begin
                OP2out[3] = 1'b0;
            end
            OP2out[15:4] = 12'b0;
        end else if (exe_datatype == 2'b10 && exec[opcEXT] == 1'b0) begin
            OP2out[31:16] = reg_QB[31:16];
        end

        if (exec[opcEXTB] == 1'b1) begin
            OP2out[31:8] = {24{OP2out[7]}};
        end
    end

    // handle EA_data, data_write
    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            store_in_tmp <= 1'b0;
            direct_data <= 1'b0;
            use_direct_data <= 1'b0;
            Z_error <= 1'b0;
            writePCnext <= 1'b0;
        end else if (clkena_lw == 1'b1) begin
            useStackframe2 <= 1'b0;
            direct_data <= 1'b0;
            if (exec[hold_OP2] == 1'b1) begin
                use_direct_data <= 1'b1;
            end
            if (set_direct_data == 1'b1) begin
                direct_data <= 1'b1;
                use_direct_data <= 1'b1;
            end else if (endOPC == 1'b1 || set[ea_data_OP2] == 1'b1) begin
                use_direct_data <= 1'b0;
            end
            exec_DIRECT <= set_exec[opcMOVE];

            if (endOPC == 1'b1) begin
                store_in_tmp <= 1'b0;
                Z_error <= 1'b0;
                writePCnext <= 1'b0;
            end else begin
                if (set_Z_error == 1'b1) begin
                    Z_error <= 1'b1;
                end
                if (set_exec[opcMOVE] == 1'b1 && state == 2'b11) begin
                    use_direct_data <= 1'b1;
                end
                if (state == 2'b10 || exec[store_ea_packdata] == 1'b1) begin
                    store_in_tmp <= 1'b1;
                end
                if (direct_data == 1'b1 && state == 2'b00) begin
                    store_in_tmp <= 1'b1;
                end
            end

            if (state == 2'b10 && exec[hold_ea_data] == 1'b0) begin
                ea_data <= data_read;
            end else if (exec[get_2ndOPC] == 1'b1) begin
                ea_data <= addr;
            end else if (exec[store_ea_data] == 1'b1 || (direct_data == 1'b1 && state == 2'b00)) begin
                ea_data <= last_data_read;
            end

            if (writePC == 1'b1) begin
                data_write_tmp <= TG68_PC;
            end else if (exec[writePC_add] == 1'b1) begin
                data_write_tmp <= TG68_PC_add;
            end else if (micro_state == trap00) begin
                data_write_tmp <= exe_pc; // TH
                useStackframe2 <= 1'b1;
                writePCnext <= trap_trap | trap_trapv | exec[trap_chk] | Z_error;
            end else if (micro_state == trap0) begin
                if (useStackframe2 == 1'b1) begin
                    // stack frame format #2
                    data_write_tmp[15:0] <= {4'b0010, trap_vector[11:0]}; // TH
                end else begin
                    data_write_tmp[15:0] <= {4'b0000, trap_vector[11:0]};
                    writePCnext <= trap_trap | trap_trapv | exec[trap_chk] | Z_error;
                end
            end else if (exec[hold_dwr] == 1'b1) begin
                data_write_tmp <= data_write_tmp;
            end else if (exec[exg] == 1'b1) begin
                data_write_tmp <= OP1out;
            end else if (exec[get_ea_now] == 1'b1 && ea_only == 1'b1) begin // pea
                data_write_tmp <= addr;
            end else if (execOPC == 1'b1) begin
                data_write_tmp <= ALUout;
            end else if (exec_DIRECT == 1'b1 && state == 2'b10) begin
                data_write_tmp <= data_read;
                if (exec[movepl] == 1'b1) begin
                    data_write_tmp[31:8] <= data_write_tmp[23:0];
                end
            end else if (exec[movepl] == 1'b1) begin
                data_write_tmp[15:0] <= reg_QB[31:16];
            end else if (direct_data == 1'b1) begin
                data_write_tmp <= last_data_read;
            end else if (writeSR == 1'b1) begin
                data_write_tmp[15:0] <= {trap_SR[7:0], Flags[7:0]};
            end else begin
                data_write_tmp <= OP2out;
            end
        end
    end

    // brief
    always_comb begin
        if (brief[11] == 1'b1) begin
            OP1outbrief = OP1out[31:16];
        end else begin
            OP1outbrief = {16{OP1out[15]}};
        end
        briefdata = {OP1outbrief, OP1out[15:0]};
        if (extAddr_Mode == 1 || (CPU[1] == 1'b1 && extAddr_Mode == 2)) begin
            case (brief[10:9])
                2'b00: briefdata = {OP1outbrief, OP1out[15:0]};
                2'b01: briefdata = {OP1outbrief[14:0], OP1out[15:0], 1'b0};
                2'b10: briefdata = {OP1outbrief[13:0], OP1out[15:0], 2'b00};
                2'b11: briefdata = {OP1outbrief[12:0], OP1out[15:0], 3'b000};
                default: ;
            endcase
        end
    end

    // MEM_IO
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            trap_vector[31:10] <= 22'b0;
            if (trap_berr == 1'b1)       trap_vector[9:0] <= {2'b00, 8'h08};
            if (trap_addr_error == 1'b1) trap_vector[9:0] <= {2'b00, 8'h0C};
            if (trap_illegal == 1'b1)    trap_vector[9:0] <= {2'b00, 8'h10};
            if (set_Z_error == 1'b1)     trap_vector[9:0] <= {2'b00, 8'h14};
            if (exec[trap_chk] == 1'b1)  trap_vector[9:0] <= {2'b00, 8'h18};
            if (trap_trapv == 1'b1)      trap_vector[9:0] <= {2'b00, 8'h1C};
            if (trap_priv == 1'b1)       trap_vector[9:0] <= {2'b00, 8'h20};
            if (trap_trace == 1'b1)      trap_vector[9:0] <= {2'b00, 8'h24};
            if (trap_1010 == 1'b1)       trap_vector[9:0] <= {2'b00, 8'h28};
            if (trap_1111 == 1'b1)       trap_vector[9:0] <= {2'b00, 8'h2C};
            if (trap_trap == 1'b1)       trap_vector[9:0] <= {4'b0010, opcode[3:0], 2'b00};
            if (trap_interrupt == 1'b1 || set_vectoraddr == 1'b1) trap_vector[9:0] <= {IPL_vec, 2'b00}; // TH
        end
    end

    assign trap_vector_vbr = (use_VBR_Stackframe == 1'b1) ? (trap_vector + VBR) : trap_vector;

    always_comb begin
        memaddr_a = 32'b0;
        if (setdisp == 1'b1) begin
            if (exec[briefext] == 1'b1) begin
                memaddr_a = briefdata + memaddr_delta;
            end else if (setdispbyte == 1'b1) begin
                memaddr_a = {{24{last_data_read[7]}}, last_data_read[7:0]};
            end else begin
                memaddr_a = {{16{last_data_read[15]}}, last_data_read[15:0]};
            end
        end else if (set[presub] == 1'b1) begin
            if (set[longaktion] == 1'b1) begin
                memaddr_a = -32'd4; // -4
            end else if (datatype == 2'b00 && set[use_SP] == 1'b0) begin
                memaddr_a = -32'd1; // -1
            end else begin
                memaddr_a = -32'd2; // -2
            end
        end else if (interrupt == 1'b1) begin
            memaddr_a = {27'b0, 1'b1, rIPL_nr, 1'b0};
        end
    end

    always_ff @(posedge clk) begin
        if (clkena_in == 1'b1) begin
            if (exec[get_2ndOPC] == 1'b1 || (state == 2'b10 && memread[0] == 1'b1)) begin
                tmp_TG68_PC <= addr;
            end
            use_base <= 1'b0;
            memaddr_delta_regb <= 32'b0;
            if (memmaskmux[3] == 1'b0 || exec[mem_addsub] == 1'b1) begin
                memaddr_delta_rega <= addsub_q;
            end else if (set[restore_ADDR] == 1'b1) begin
                memaddr_delta_rega <= tmp_TG68_PC;
            end else if (exec[direct_delta] == 1'b1) begin
                memaddr_delta_rega <= data_read;
            end else if (exec[ea_to_pc] == 1'b1 && setstate == 2'b00) begin
                memaddr_delta_rega <= addr;
            end else if (set[addrlong] == 1'b1) begin
                memaddr_delta_rega <= last_data_read;
            end else if (setstate == 2'b00) begin
                memaddr_delta_rega <= TG68_PC_add;
            end else if (exec[dispouter] == 1'b1) begin
                memaddr_delta_rega <= ea_data;
                memaddr_delta_regb <= memaddr_a;
            end else if (set_vectoraddr == 1'b1) begin
                memaddr_delta_rega <= trap_vector_vbr;
            end else begin
                memaddr_delta_rega <= memaddr_a;
                if (interrupt == 1'b0 && Suppress_Base == 1'b0) begin
                    use_base <= 1'b1;
                end
            end

            // fix for unaligned movem mikej
            if ((memread[0] == 1'b1 && state[1] == 1'b1) || movem_presub == 1'b0) begin
                memaddr <= addr;
            end
        end
    end

    assign memaddr_delta = memaddr_delta_rega + memaddr_delta_regb;
    assign addr = memaddr_reg + memaddr_delta;
    assign addr_out = memaddr_reg + memaddr_delta;

    assign memaddr_reg = (use_base == 1'b0) ? 32'b0 : reg_QA;

    // PC Calc + fetch opcode
    always_comb begin
        PC_dataa = TG68_PC;
        if (TG68_PC_brw == 1'b1) begin
            PC_dataa = tmp_TG68_PC;
        end

        PC_datab[2:0] = 3'b0;
        PC_datab[3] = PC_datab[2];
        PC_datab[7:4] = {4{PC_datab[3]}};
        PC_datab[15:8] = {8{PC_datab[7]}};
        PC_datab[31:16] = {16{PC_datab[15]}};
        if (interrupt == 1'b1) begin
            PC_datab[2:1] = 2'b11;
        end
        if (exec[writePC_add] == 1'b1) begin
            if (writePCbig == 1'b1) begin
                PC_datab[3] = 1'b1;
                PC_datab[1] = 1'b1;
            end else begin
                PC_datab[2] = 1'b1;
            end
            if ((use_VBR_Stackframe == 1'b0 && (trap_trap == 1'b1 || trap_trapv == 1'b1 || exec[trap_chk] == 1'b1 || Z_error == 1'b1)) || writePCnext == 1'b1) begin
                PC_datab[1] = 1'b1;
            end
        end else if (state == 2'b00) begin
            PC_datab[1] = 1'b1;
        end

        if (TG68_PC_brw == 1'b1) begin
            if (TG68_PC_word == 1'b1) begin
                PC_datab = last_data_read;
            end else begin
                PC_datab[7:0] = opcode[7:0];
            end
        end

        TG68_PC_add = PC_dataa + PC_datab;

        setopcode = 1'b0;
        setendOPC = 1'b0;
        setinterrupt = 1'b0;
        if (setstate == 2'b00 && next_micro_state == idle && setnextpass == 1'b0 && (exec_write_back == 1'b0 || state == 2'b11) && set_rot_cnt == 6'b000001 && set_exec[opcCHK] == 1'b0) begin
            setendOPC = 1'b1;
            if (FlagsSR[2:0] < IPL_nr || IPL_nr == 3'b111 || make_trace == 1'b1 || make_berr == 1'b1) begin
                setinterrupt = 1'b1;
            end else if (stop == 1'b0) begin
                setopcode = 1'b1;
            end
        end

        setexecOPC = 1'b0;
        if (setstate == 2'b00 && next_micro_state == idle && set_direct_data == 1'b0 && (exec_write_back == 1'b0 || (state == 2'b10 && addrvalue == 1'b0))) begin
            setexecOPC = 1'b1;
        end

        IPL_nr = ~IPL;
    end

    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            state <= 2'b01;
            addrvalue <= 1'b0;
            opcode <= 16'h2E79; // move $0,a7
            trap_interrupt <= 1'b0;
            interrupt <= 1'b0;
            last_opc_read <= 16'h4EF9; // jmp nn.l
            TG68_PC <= 32'h00000004;
            decodeOPC <= 1'b0;
            endOPC <= 1'b0;
            TG68_PC_word <= 1'b0;
            execOPC <= 1'b0;
            stop <= 1'b0;
            rot_cnt <= 6'b000001;
            trap_trace <= 1'b0;
            trap_berr <= 1'b0;
            writePCbig <= 1'b0;
            Suppress_Base <= 1'b0;
            make_berr <= 1'b0;
            memmask <= 6'b111111;
            exec_write_back <= 1'b0;
        end else begin
            if (clkena_in == 1'b1) begin
                memmask <= {memmask[3:0], 2'b11};
                memread <= {memread[1:0], memmaskmux[5:4]};
                if (exec[directPC] == 1'b1) begin
                    TG68_PC <= data_read;
                end else if (exec[ea_to_pc] == 1'b1) begin
                    TG68_PC <= addr;
                end else if ((state == 2'b00 || TG68_PC_brw == 1'b1) && stop == 1'b0) begin
                    TG68_PC <= TG68_PC_add;
                end
            end

            if (clkena_lw == 1'b1) begin
                interrupt <= setinterrupt;
                decodeOPC <= setopcode;
                endOPC <= setendOPC;
                execOPC <= setexecOPC;
                exe_datatype <= set_datatype;
                exe_opcode <= opcode;

                if (trap_berr == 1'b0) begin
                    make_berr <= (berr | make_berr);
                end else begin
                    make_berr <= 1'b0;
                end

                stop <= set_stop | (stop & ~setinterrupt);
                if (setinterrupt == 1'b1) begin
                    trap_interrupt <= 1'b0;
                    trap_trace <= 1'b0;
                    make_berr <= 1'b0;
                    trap_berr <= 1'b0;
                    if (make_trace == 1'b1) begin
                        trap_trace <= 1'b1;
                    end else if (make_berr == 1'b1) begin
                        trap_berr <= 1'b1;
                    end else begin
                        rIPL_nr <= IPL_nr;
                        IPL_vec <= {5'b00011, IPL_nr};
                        trap_interrupt <= 1'b1;
                    end
                end

                if (micro_state == trap0 && IPL_autovector == 1'b0) begin
                    IPL_vec <= last_data_read[7:0]; // TH
                end

                if (state == 2'b00) begin
                    last_opc_read <= data_read[15:0];
                    last_opc_pc <= TG68_PC; // TH
                end

                if (setopcode == 1'b1) begin
                    trap_interrupt <= 1'b0;
                    trap_trace <= 1'b0;
                    TG68_PC_word <= 1'b0;
                    trap_berr <= 1'b0;
                end else if (opcode[7:0] == 8'b00000000 || opcode[7:0] == 8'b11111111 || data_is_source == 1'b1) begin
                    TG68_PC_word <= 1'b1;
                end

                if (exec[get_bfoffset] == 1'b1) begin
                    alu_width <= bf_width;
                    alu_bf_shift <= bf_shift;
                    alu_bf_loffset <= bf_loffset;
                    alu_bf_ffo_offset <= bf_full_offset + {26'b0, bf_width} + 1;
                end

                memread <= 4'b1111;
                FC[1] <= ~setstate[1] | (PCbase & ~setstate[0]);
                FC[0] <= setstate[1] & (~PCbase | setstate[0]);
                if (interrupt == 1'b1) begin
                    FC[1:0] <= 2'b11;
                end

                if (state == 2'b11) begin
                    exec_write_back <= 1'b0;
                end else if (setstate == 2'b10 && setaddrvalue == 1'b0 && write_back == 1'b1) begin
                    exec_write_back <= 1'b1;
                end

                if ((state == 2'b10 && addrvalue == 1'b0 && write_back == 1'b1 && setstate != 2'b10) || set_rot_cnt != 6'b000001 || (stop == 1'b1 && interrupt == 1'b0) || set_exec[opcCHK] == 1'b1) begin
                    state <= 2'b01;
                    memmask <= 6'b111111;
                    addrvalue <= 1'b0;
                end else if (execOPC == 1'b1 && exec_write_back == 1'b1) begin
                    state <= 2'b11;
                    FC[1:0] <= 2'b01;
                    memmask <= wbmemmask;
                    addrvalue <= 1'b0;
                end else begin
                    state <= setstate;
                    addrvalue <= setaddrvalue;
                    if (setstate == 2'b01) begin
                        memmask <= 6'b111111;
                        wbmemmask <= 6'b111111;
                    end else if (exec[get_bfoffset] == 1'b1) begin
                        memmask <= set_memmask;
                        wbmemmask <= set_memmask;
                        oddout <= set_oddout;
                    end else if (set[longaktion] == 1'b1) begin
                        memmask <= 6'b100001;
                        wbmemmask <= 6'b100001;
                        oddout <= 1'b0;
                    end else if (set_datatype == 2'b00 && setstate[1] == 1'b1) begin
                        memmask <= 6'b101111;
                        wbmemmask <= 6'b101111;
                        if (set[mem_byte] == 1'b1) begin
                            oddout <= 1'b0;
                        end else begin
                            oddout <= 1'b1;
                        end
                    end else begin
                        memmask <= 6'b100111;
                        wbmemmask <= 6'b100111;
                        oddout <= 1'b0;
                    end
                end

                if (decodeOPC == 1'b1) begin
                    rot_bits <= set_rot_bits;
                    writePCbig <= 1'b0;
                end else begin
                    writePCbig <= set_writePCbig | writePCbig;
                end
                if (decodeOPC == 1'b1 || exec[ld_rot_cnt] == 1'b1 || rot_cnt != 6'b000001) begin
                    rot_cnt <= set_rot_cnt;
                end

                if (set_Suppress_Base == 1'b1) begin
                    Suppress_Base <= 1'b1;
                end else if (setstate[1] == 1'b1 || (ea_only == 1'b1 && set[get_ea_now] == 1'b1)) begin
                    Suppress_Base <= 1'b0;
                end

                if (getbrief == 1'b1) begin
                    if (state[1] == 1'b1) begin
                        brief <= last_opc_read[15:0];
                    end else begin
                        brief <= data_read[15:0];
                    end
                end

                if (setopcode == 1'b1 && berr == 1'b0) begin
                    if (state == 2'b00) begin
                        opcode <= data_read[15:0];
                        exe_pc <= TG68_PC; // TH
                    end else begin
                        opcode <= last_opc_read[15:0];
                        exe_pc <= last_opc_pc; // TH
                    end
                    nextpass <= 1'b0;
                end else if (setinterrupt == 1'b1 || setopcode == 1'b1) begin
                    opcode <= 16'h4E71; // nop
                    nextpass <= 1'b0;
                end else begin
                    if (setnextpass == 1'b1 || regdirectsource == 1'b1) begin
                        nextpass <= 1'b1;
                    end
                end

                if (decodeOPC == 1'b1 || interrupt == 1'b1) begin
                    trap_SR <= FlagsSR;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            PCbase <= 1'b1;
        end else if (clkena_lw == 1'b1) begin
            PCbase <= set_PCbase | PCbase;
            if (setexecOPC == 1'b1 || (state[1] == 1'b1 && movem_run == 1'b0)) begin
                PCbase <= 1'b0;
            end
        end

        if (clkena_lw == 1'b1) begin
            exec <= set;
            exec[alu_move] <= set[opcMOVE] | set[alu_move];
            exec[alu_setFlags] <= set[opcADD] | set[alu_setFlags];
            exec_tas <= 1'b0;
            exec[subidx] <= set[presub] | set[subidx];
            if (setexecOPC == 1'b1) begin
                exec <= set_exec | set;
                exec[alu_move] <= set_exec[opcMOVE] | set[opcMOVE] | set[alu_move];
                exec[alu_setFlags] <= set_exec[opcADD] | set[opcADD] | set[alu_setFlags];
                exec_tas <= set_exec_tas;
            end
            exec[get_2ndOPC] <= set[get_2ndOPC] | setopcode;
        end
    end

    // Prepare Bitfield Parameters
    always_comb begin
        if (sndOPC[11] == 1'b1) begin
            bf_offset = {1'b0, reg_QA[4:0]};
        end else begin
            bf_offset = {1'b0, sndOPC[10:6]};
        end
        if (sndOPC[11] == 1'b1) begin
            bf_full_offset = reg_QA;
        end else begin
            bf_full_offset = {27'b0, sndOPC[10:6]};
        end

        bf_width[5] = 1'b0;
        if (sndOPC[5] == 1'b1) begin
            bf_width[4:0] = reg_QB[4:0] - 5'd1;
        end else begin
            bf_width[4:0] = sndOPC[4:0] - 5'd1;
        end

        bf_bhits = bf_width + bf_offset;
        set_oddout = ~bf_bhits[3];

        if (opcode[10:8] == 3'b111) begin // INS
            bf_loffset = 6'd32 - bf_shift;
        end else begin
            bf_loffset = bf_shift;
        end
        bf_loffset[5] = 1'b0;

        if (opcode[4:3] == 2'b00) begin
            if (opcode[10:8] == 3'b111) begin // INS
                bf_shift = bf_bhits + 6'd1;
            end else begin
                bf_shift = 6'd31 - bf_bhits;
            end
            bf_shift[5] = 1'b0;
        end else begin
            if (opcode[10:8] == 3'b111) begin // INS
                bf_shift = 6'b011001 + {3'b000, bf_bhits[2:0]};
                bf_shift[5] = 1'b0;
            end else begin
                bf_shift = {3'b000, (3'd7 - bf_bhits[2:0])}; // 111 is 7
            end
            bf_offset[4:3] = 2'b00;
        end

        case (bf_bhits[5:3])
            3'b000: set_memmask = 6'b101111;
            3'b001: set_memmask = 6'b100111;
            3'b010: set_memmask = 6'b100011;
            3'b011: set_memmask = 6'b100001;
            default: set_memmask = 6'b100000;
        endcase
        if (setstate == 2'b00) begin
            set_memmask = 6'b100111;
        end
    end

    // SR op
    always_comb begin
        if (exec[andiSR] == 1'b1) begin
            SRin = FlagsSR & last_data_read[15:8];
        end else if (exec[eoriSR] == 1'b1) begin
            SRin = FlagsSR ^ last_data_read[15:8];
        end else if (exec[oriSR] == 1'b1) begin
            SRin = FlagsSR | last_data_read[15:8];
        end else begin
            SRin = OP2out[15:8];
        end
    end

    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            FC[2] <= 1'b1;
            SVmode <= 1'b1;
            preSVmode <= 1'b1;
            FlagsSR <= 8'b00100111;
            make_trace <= 1'b0;
        end else if (clkena_lw == 1'b1) begin
            if (setopcode == 1'b1) begin
                make_trace <= FlagsSR[7];
                if (set[changeMode] == 1'b1) begin
                    SVmode <= ~SVmode;
                end else begin
                    SVmode <= preSVmode;
                end
            end
            if (trap_berr == 1'b1 || trap_illegal == 1'b1 || trap_addr_error == 1'b1 || trap_priv == 1'b1 || trap_1010 == 1'b1 || trap_1111 == 1'b1) begin
                make_trace <= 1'b0;
                FlagsSR[7] <= 1'b0;
            end
            if (set[changeMode] == 1'b1) begin
                preSVmode <= ~preSVmode;
                FlagsSR[5] <= ~preSVmode;
                FC[2] <= ~preSVmode;
            end
            if (micro_state == trap3) begin
                FlagsSR[7] <= 1'b0;
            end
            if (trap_trace == 1'b1 && state == 2'b10) begin
                make_trace <= 1'b0;
            end
            if (exec[directSR] == 1'b1 || set_stop == 1'b1) begin
                FlagsSR <= data_read[15:8];
            end
            if (interrupt == 1'b1 && trap_interrupt == 1'b1) begin
                FlagsSR[2:0] <= rIPL_nr;
            end
            if (exec[to_SR] == 1'b1) begin
                FlagsSR <= SRin;
                FC[2] <= SRin[5];
            end else if (exec[update_FC] == 1'b1) begin
                FC[2] <= FlagsSR[5];
            end
            if (interrupt == 1'b1) begin
                FC[2] <= 1'b1;
            end
            if (CPU[1] == 1'b0) begin
                FlagsSR[4] <= 1'b0;
                FlagsSR[6] <= 1'b0;
            end
            FlagsSR[3] <= 1'b0;
        end
    end

    // Decode Opcode
    // This is a very large combinatorial block.
    // I need to be careful about inferred latches if not all paths assign outputs.
    // In VHDL 'signals' retain values, 'variables' do not unless assigned.
    // Here outputs like set, set_exec, etc. are wires driven by this block.
    // They must be assigned default values at the top.

    always_comb begin
        TG68_PC_brw = 1'b0;
        setstate = 2'b00;
        setaddrvalue = 1'b0;
        Regwrena_now = 1'b0;
        movem_presub = 1'b0;
        setnextpass = 1'b0;
        regdirectsource = 1'b0;
        setdisp = 1'b0;
        setdispbyte = 1'b0;
        getbrief = 1'b0;
        dest_LDRareg = 1'b0;
        dest_areg = 1'b0;
        source_areg = 1'b0;
        data_is_source = 1'b0;
        write_back = 1'b0;
        setstackaddr = 1'b0;
        writePC = 1'b0;
        ea_build_now = 1'b0;
        set_rot_bits = opcode[4:3];
        set_rot_cnt = 6'b000001;
        dest_hbits = 1'b0;
        source_lowbits = 1'b0;
        source_LDRLbits = 1'b0;
        source_LDRMbits = 1'b0;
        source_2ndHbits = 1'b0;
        source_2ndMbits = 1'b0;
        source_2ndLbits = 1'b0;
        dest_LDRHbits = 1'b0;
        dest_LDRLbits = 1'b0;
        dest_2ndHbits = 1'b0;
        dest_2ndLbits = 1'b0;
        ea_only = 1'b0;
        set_direct_data = 1'b0;
        set_exec_tas = 1'b0;
        trap_illegal = 1'b0;
        trap_addr_error = 1'b0;
        trap_priv = 1'b0;
        trap_1010 = 1'b0;
        trap_1111 = 1'b0;
        trap_trap = 1'b0;
        trap_trapv = 1'b0;
        trapmake = 1'b0;
        set_vectoraddr = 1'b0;
        writeSR = 1'b0;
        set_stop = 1'b0;
        set_Z_error = 1'b0;
        check_aligned = 1'b0;

        next_micro_state = idle;
        build_logical = 1'b0;
        build_bcd = 1'b0;
        skipFetch = make_berr;
        set_writePCbig = 1'b0;
        set_Suppress_Base = 1'b0;
        set_PCbase = 1'b0;

        // Defaults for set and set_exec
        set = '0;
        set_exec = '0;

        if (rot_cnt != 6'b000001) begin
            set_rot_cnt = rot_cnt - 6'd1;
        end

        // Sourcepass - Determine default datatype from opcode
        case (opcode[7:6])
            2'b00: datatype = 2'b00; // Byte
            2'b01: datatype = 2'b01; // Word
            default: datatype = 2'b10; // Long
        endcase

        // set_datatype will be assigned at the end to capture any overrides

        if (execOPC == 1'b1 && exec_write_back == 1'b1) begin
            set[restore_ADDR] = 1'b1;
        end

        if (interrupt == 1'b1 && trap_berr == 1'b1) begin
            next_micro_state = trap0;
            if (preSVmode == 1'b0) begin
                set[changeMode] = 1'b1;
            end
            setstate = 2'b01;
        end
        if (trapmake == 1'b1 && trapd == 1'b0) begin
            if (CPU[1] == 1'b1 && (trap_trapv == 1'b1 || set_Z_error == 1'b1 || exec[trap_chk] == 1'b1)) begin
                next_micro_state = trap00;
            end else begin
                next_micro_state = trap0;
            end
            if (use_VBR_Stackframe == 1'b0) begin
                set[writePC_add] = 1'b1;
            end
            if (preSVmode == 1'b0) begin
                set[changeMode] = 1'b1;
            end
            setstate = 2'b01;
        end

        if (micro_state == int1 || (interrupt == 1'b1 && trap_trace == 1'b1)) begin
            if (trap_trace == 1'b1 && CPU[1] == 1'b1) begin
                next_micro_state = trap00;
            end else begin
                next_micro_state = trap0;
            end
            if (preSVmode == 1'b0) begin
                set[changeMode] = 1'b1;
            end
            setstate = 2'b01;
        end

        if (setexecOPC == 1'b1 && FlagsSR[5] != preSVmode) begin
            set[changeMode] = 1'b1;
        end

        if (interrupt == 1'b1 && trap_interrupt == 1'b1) begin
            next_micro_state = int1;
            set[update_ld] = 1'b1;
            setstate = 2'b10;
        end

        if (set[changeMode] == 1'b1) begin
            set[to_USP] = 1'b1;
            set[from_USP] = 1'b1;
            setstackaddr = 1'b1;
        end

        if (ea_only == 1'b0 && set[get_ea_now] == 1'b1) begin
            setstate = 2'b10;
        end

        if (setstate[1] == 1'b1 && set_datatype[1] == 1'b1) begin
            set[longaktion] = 1'b1;
        end

        if ((ea_build_now == 1'b1 && decodeOPC == 1'b1) || exec[ea_build] == 1'b1) begin
            case (opcode[5:3]) // source
                3'b010, 3'b011, 3'b100: begin // -(An)+
                    set[get_ea_now] = 1'b1;
                    setnextpass = 1'b1;
                    if (opcode[3] == 1'b1) begin // (An)+
                        set[postadd] = 1'b1;
                        if (opcode[2:0] == 3'b111) begin
                            set[use_SP] = 1'b1;
                        end
                    end
                    if (opcode[5] == 1'b1) begin // -(An)
                        set[presub] = 1'b1;
                        if (opcode[2:0] == 3'b111) begin
                            set[use_SP] = 1'b1;
                        end
                    end
                end
                3'b101: begin // (d16,An)
                    next_micro_state = ld_dAn1;
                end
                3'b110: begin // (d8,An,Xn)
                    next_micro_state = ld_AnXn1;
                    getbrief = 1'b1;
                end
                3'b111: begin
                    case (opcode[2:0])
                        3'b000: begin // (xxxx).w
                            next_micro_state = ld_nn;
                        end
                        3'b001: begin // (xxxx).l
                            set[longaktion] = 1'b1;
                            next_micro_state = ld_nn;
                        end
                        3'b010: begin // (d16,PC)
                            next_micro_state = ld_dAn1;
                            set[dispouter] = 1'b1;
                            set_Suppress_Base = 1'b1;
                            set_PCbase = 1'b1;
                        end
                        3'b011: begin // (d8,PC,Xn)
                            next_micro_state = ld_AnXn1;
                            getbrief = 1'b1;
                            set[dispouter] = 1'b1;
                            set_Suppress_Base = 1'b1;
                            set_PCbase = 1'b1;
                        end
                        3'b100: begin // #data
                            setnextpass = 1'b1;
                            set_direct_data = 1'b1;
                            if (datatype == 2'b10) begin
                                set[longaktion] = 1'b1;
                            end
                        end
                        default: ;
                    endcase
                end
                default: ;
            endcase
        end

        // prepare opcode
        case (opcode[15:12])
            // 0000 ----------------------------------------------------------------------------
            4'b0000: begin
                if (opcode[8] == 1'b1 && opcode[5:3] == 3'b001) begin // movep
                    datatype = 2'b00; // Byte
                    set[use_SP] = 1'b1; // addr+2
                    set[no_Flags] = 1'b1;
                    if (opcode[7] == 1'b0) begin // to register
                        set_exec[Regwrena] = 1'b1;
                        set_exec[opcMOVE] = 1'b1;
                        set[movepl] = 1'b1;
                    end
                    if (decodeOPC == 1'b1) begin
                        if (opcode[6] == 1'b1) begin
                            set[movepl] = 1'b1;
                        end
                        if (opcode[7] == 1'b0) begin
                            set_direct_data = 1'b1; // to register
                        end
                        next_micro_state = movep1;
                    end
                    if (setexecOPC == 1'b1) begin
                        dest_hbits = 1'b1;
                    end
                end else begin
                    if (opcode[8] == 1'b1 || opcode[11:9] == 3'b100) begin // Bits
                        if (opcode[5:3] != 3'b001 && // ea An illegal mode
                            (opcode[8:3] != 6'b000111 || opcode[2] == 1'b0) && // BTST bit number static illegal modes
                            (opcode[8:2] != 7'b1001111 || opcode[1:0] == 2'b00) && // BTST bit number dynamic illegal modes
                            (opcode[7:6] == 2'b00 || opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // BCHG, BCLR, BSET illegal modes

                            set_exec[opcBITS] = 1'b1;
                            set_exec[ea_data_OP1] = 1'b1;
                            if (opcode[7:6] != 2'b00) begin
                                if (opcode[5:4] == 2'b00) begin
                                    set_exec[Regwrena] = 1'b1;
                                end
                                write_back = 1'b1;
                            end
                            if (opcode[5:4] == 2'b00) begin
                                datatype = 2'b10; // Long
                            end else begin
                                datatype = 2'b00; // Byte
                            end
                            if (opcode[8] == 1'b0) begin
                                if (decodeOPC == 1'b1) begin
                                    next_micro_state = nop;
                                    set[get_2ndOPC] = 1'b1;
                                    set[ea_build] = 1'b1;
                                end
                            end else begin
                                ea_build_now = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else if (opcode[8:6] == 3'b011) begin // CAS/CAS2/CMP2/CHK2
                        if (CPU[1] == 1'b1) begin
                            if (opcode[11] == 1'b1) begin // CAS/CAS2
                                if ((opcode[10:9] != 2'b00 && // CAS illegal size
                                     opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) || // ea illegal modes
                                    (opcode[10] == 1'b1 && opcode[5:0] == 6'b111100)) begin // CAS2

                                    case (opcode[10:9])
                                        2'b01: datatype = 2'b00; // Byte
                                        2'b10: datatype = 2'b01; // Word
                                        default: datatype = 2'b10; // Long
                                    endcase

                                    if (opcode[10] == 1'b1 && opcode[5:0] == 6'b111100) begin // CAS2
                                        if (decodeOPC == 1'b1) begin
                                            set[get_2ndOPC] = 1'b1;
                                            next_micro_state = cas21;
                                        end
                                    end else begin // CAS
                                        if (decodeOPC == 1'b1) begin
                                            next_micro_state = nop;
                                            set[get_2ndOPC] = 1'b1;
                                            set[ea_build] = 1'b1;
                                        end
                                        if (micro_state == idle && nextpass == 1'b1) begin
                                            source_2ndLbits = 1'b1;
                                            set[ea_data_OP1] = 1'b1;
                                            set[addsub] = 1'b1;
                                            set[alu_exec] = 1'b1;
                                            set[alu_setFlags] = 1'b1;
                                            setstate = 2'b01;
                                            next_micro_state = cas1;
                                        end
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin // CMP2/CHK2
                                if (opcode[10:9] != 2'b11 && // illegal size
                                    opcode[5:4] != 2'b00 && opcode[5:3] != 3'b011 && opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin // ea illegal modes

                                    set[trap_chk] = 1'b1;
                                    datatype = opcode[10:9];
                                    if (decodeOPC == 1'b1) begin
                                        next_micro_state = nop;
                                        set[get_2ndOPC] = 1'b1;
                                        set[ea_build] = 1'b1;
                                    end
                                    if (set[get_ea_now] == 1'b1) begin
                                        set[mem_addsub] = 1'b1;
                                        set[OP1addr] = 1'b1;
                                    end
                                    if (micro_state == idle && nextpass == 1'b1) begin
                                        setstate = 2'b10;
                                        set[hold_OP2] = 1'b1;
                                        if (exe_datatype != 2'b00) begin
                                            check_aligned = 1'b1;
                                        end
                                        next_micro_state = chk20;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else if (opcode[11:9] == 3'b111) begin // MOVES not in 68000
                        if (CPU[0] == 1'b1 && opcode[7:6] != 2'b11 && opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                            if (SVmode == 1'b1) begin
                                // TODO: implement MOVES
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end else begin
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin // andi, ...xxxi
                        if (opcode[7:6] != 2'b11 && opcode[5:3] != 3'b001) begin // ea An illegal mode
                            if (opcode[11:9] == 3'b000) begin // ORI
                                if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && opcode[7] == 1'b0)) begin
                                    set_exec[opcOR] = 1'b1;
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            if (opcode[11:9] == 3'b001) begin // ANDI
                                if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && opcode[7] == 1'b0)) begin
                                    set_exec[opcAND] = 1'b1;
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            if (opcode[11:9] == 3'b010 || opcode[11:9] == 3'b011) begin // SUBI, ADDI
                                if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00) begin
                                    set_exec[opcADD] = 1'b1;
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            if (opcode[11:9] == 3'b101) begin // EORI
                                if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && opcode[7] == 1'b0)) begin
                                    set_exec[opcEOR] = 1'b1;
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            if (opcode[11:9] == 3'b110) begin // CMPI
                                if (opcode[5:3] != 3'b111 || opcode[2] == 1'b0) begin
                                    set_exec[opcCMP] = 1'b1;
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end

                            if ((set_exec[opcOR] | set_exec[opcAND] | set_exec[opcADD] | set_exec[opcEOR] | set_exec[opcCMP]) == 1'b1) begin
                                if (opcode[7] == 1'b0 && opcode[5:0] == 6'b111100 && (set_exec[opcAND] | set_exec[opcOR] | set_exec[opcEOR]) == 1'b1) begin // SR
                                    if (decodeOPC == 1'b1 && SVmode == 1'b0 && opcode[6] == 1'b1) begin // SR
                                        trap_priv = 1'b1;
                                        trapmake = 1'b1;
                                    end else begin
                                        set[no_Flags] = 1'b1;
                                        if (decodeOPC == 1'b1) begin
                                            if (opcode[6] == 1'b1) begin
                                                set[to_SR] = 1'b1;
                                            end
                                            set[to_CCR] = 1'b1;
                                            set[andiSR] = set_exec[opcAND];
                                            set[eoriSR] = set_exec[opcEOR];
                                            set[oriSR] = set_exec[opcOR];
                                            setstate = 2'b01;
                                            next_micro_state = nopnop;
                                        end
                                    end
                                end else if (opcode[7] == 1'b0 || opcode[5:0] != 6'b111100 || (set_exec[opcAND] | set_exec[opcOR] | set_exec[opcEOR]) == 1'b0) begin
                                    if (decodeOPC == 1'b1) begin
                                        next_micro_state = andi;
                                        set[get_2ndOPC] = 1'b1;
                                        set[ea_build] = 1'b1;
                                        set_direct_data = 1'b1;
                                        if (datatype == 2'b10) begin
                                            set[longaktion] = 1'b1;
                                        end
                                    end
                                    if (opcode[5:4] != 2'b00) begin
                                        set_exec[ea_data_OP1] = 1'b1;
                                    end
                                    if (opcode[11:9] != 3'b110) begin // CMPI
                                        if (opcode[5:4] == 2'b00) begin
                                            set_exec[Regwrena] = 1'b1;
                                        end
                                        write_back = 1'b1;
                                    end
                                    if (opcode[10:9] == 2'b10) begin // CMPI, SUBI
                                        set[addsub] = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end
            end

            // 0001, 0010, 0011 -----------------------------------------------------------------
            4'b0001, 4'b0010, 4'b0011: begin // move.b, move.l, move.w
                if (((opcode[11:10] == 2'b00 || opcode[8:6] != 3'b111) && // illegal dest ea
                     (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) && // illegal src ea
                     (opcode[13] == 1'b1 || (opcode[8:6] != 3'b001 && opcode[5:3] != 3'b001)))) begin // byte src address reg direct, byte movea

                    set_exec[opcMOVE] = 1'b1;
                    ea_build_now = 1'b1;
                    if (opcode[8:6] == 3'b001) begin
                        set[no_Flags] = 1'b1;
                    end
                    if (opcode[5:4] == 2'b00) begin // Dn, An
                        if (opcode[8:7] == 2'b00) begin
                            set_exec[Regwrena] = 1'b1;
                        end
                    end
                    case (opcode[13:12])
                        2'b01: datatype = 2'b00; // Byte
                        2'b10: datatype = 2'b10; // Long
                        default: datatype = 2'b01; // Word
                    endcase
                    source_lowbits = 1'b1; // Dn=> An=>
                    if (opcode[3] == 1'b1) begin
                        source_areg = 1'b1;
                    end

                    if (nextpass == 1'b1 || opcode[5:4] == 2'b00) begin
                        dest_hbits = 1'b1;
                        if (opcode[8:6] != 3'b000) begin
                            dest_areg = 1'b1;
                        end
                    end

                    if (micro_state == idle && (nextpass == 1'b1 || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1))) begin
                        case (opcode[8:6]) // destination
                            3'b000, 3'b001: begin // Dn,An
                                set_exec[Regwrena] = 1'b1;
                            end
                            3'b010, 3'b011, 3'b100: begin // destination -(an)+
                                if (opcode[6] == 1'b1) begin // (An)+
                                    set[postadd] = 1'b1;
                                    if (opcode[11:9] == 3'b111) begin
                                        set[use_SP] = 1'b1;
                                    end
                                end
                                if (opcode[8] == 1'b1) begin // -(An)
                                    set[presub] = 1'b1;
                                    if (opcode[11:9] == 3'b111) begin
                                        set[use_SP] = 1'b1;
                                    end
                                end
                                setstate = 2'b11;
                                next_micro_state = nop;
                                if (nextpass == 1'b0) begin
                                    set[write_reg] = 1'b1;
                                end
                            end
                            3'b101: begin // (d16,An)
                                next_micro_state = st_dAn1;
                            end
                            3'b110: begin // (d8,An,Xn)
                                next_micro_state = st_AnXn1;
                                getbrief = 1'b1;
                            end
                            3'b111: begin
                                case (opcode[11:9])
                                    3'b000: begin // (xxxx).w
                                        next_micro_state = st_nn;
                                    end
                                    3'b001: begin // (xxxx).l
                                        set[longaktion] = 1'b1;
                                        next_micro_state = st_nn;
                                    end
                                    default: ;
                                endcase
                            end
                            default: ;
                        endcase
                    end
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end

            // 0100 ----------------------------------------------------------------------------
            4'b0100: begin // rts_group
                if (opcode[8] == 1'b1) begin // lea, extb.l, chk
                    if (opcode[6] == 1'b1) begin // lea, extb.l
                        if (opcode[11:9] == 3'b100 && opcode[5:3] == 3'b000) begin // extb.l
                            if (opcode[7] == 1'b1 && CPU[1] == 1'b1) begin
                                source_lowbits = 1'b1;
                                set_exec[opcEXT] = 1'b1;
                                set_exec[opcEXTB] = 1'b1;
                                set_exec[opcMOVE] = 1'b1;
                                set_exec[Regwrena] = 1'b1;
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            if (opcode[7] == 1'b1 && (opcode[5] == 1'b1 || opcode[4:3] == 2'b10) &&
                                opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin // ea illegal opcodes
                                source_lowbits = 1'b1;
                                source_areg = 1'b1;
                                ea_only = 1'b1;
                                set_exec[Regwrena] = 1'b1;
                                set_exec[opcMOVE] = 1'b1;
                                set[no_Flags] = 1'b1;
                                if (opcode[5:3] == 3'b010) begin // lea (Am),An
                                    dest_areg = 1'b1;
                                    dest_hbits = 1'b1;
                                end else begin
                                    ea_build_now = 1'b1;
                                end
                                if (set[get_ea_now] == 1'b1) begin
                                    setstate = 2'b01;
                                    set_direct_data = 1'b1;
                                end
                                if (setexecOPC == 1'b1) begin
                                    dest_areg = 1'b1;
                                    dest_hbits = 1'b1;
                                end
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                    end else begin // chk
                        if (opcode[5:3] != 3'b001 && // ea An illegal mode
                            (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // ea illegal modes
                            if (opcode[7] == 1'b1) begin
                                datatype = 2'b01; // Word
                                set[trap_chk] = 1'b1;
                                if ((c_out[1] == 1'b0 || OP1out[15] == 1'b1 || OP2out[15] == 1'b1) && exec[opcCHK] == 1'b1) begin
                                    trapmake = 1'b1;
                                end
                            end else if (CPU[1] == 1'b1) begin // chk long for 68020
                                datatype = 2'b10; // Long
                                set[trap_chk] = 1'b1;
                                if ((c_out[2] == 1'b0 || OP1out[31] == 1'b1 || OP2out[31] == 1'b1) && exec[opcCHK] == 1'b1) begin
                                    trapmake = 1'b1;
                                end
                            end else begin
                                trap_illegal = 1'b1; // chk long for 68020
                                trapmake = 1'b1;
                            end
                            if (opcode[7] == 1'b1 || CPU[1] == 1'b1) begin
                                if ((nextpass == 1'b1 || opcode[5:4] == 2'b00) && exec[opcCHK] == 1'b0 && micro_state == idle) begin
                                    set_exec[opcCHK] = 1'b1;
                                end
                                ea_build_now = 1'b1;
                                set[addsub] = 1'b1;
                                if (setexecOPC == 1'b1) begin
                                    dest_hbits = 1'b1;
                                    source_lowbits = 1'b1;
                                end
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end else begin
                    case (opcode[11:9])
                        3'b000: begin
                            if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                                if (opcode[7:6] == 2'b11) begin // move from SR
                                    if (SR_Read == 0 || (CPU[0] == 1'b0 && SR_Read == 2) || SVmode == 1'b1) begin
                                        ea_build_now = 1'b1;
                                        set_exec[opcMOVESR] = 1'b1;
                                        datatype = 2'b01;
                                        write_back = 1'b1;
                                        if (CPU[0] == 1'b1 && state == 2'b10 && addrvalue == 1'b0) begin
                                            skipFetch = 1'b1;
                                        end
                                        if (opcode[5:4] == 2'b00) begin
                                            set_exec[Regwrena] = 1'b1;
                                        end
                                    end else begin
                                        trap_priv = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end else begin // negx
                                    ea_build_now = 1'b1;
                                    set_exec[use_XZFlag] = 1'b1;
                                    write_back = 1'b1;
                                    set_exec[opcADD] = 1'b1;
                                    set[addsub] = 1'b1;
                                    source_lowbits = 1'b1;
                                    if (opcode[5:4] == 2'b00) begin
                                        set_exec[Regwrena] = 1'b1;
                                    end
                                    if (setexecOPC == 1'b1) begin
                                        set[OP1out_zero] = 1'b1;
                                    end
                                end
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                        3'b001: begin
                            if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                                if (opcode[7:6] == 2'b11) begin // move from CCR 68010
                                    if (SR_Read == 1 || (CPU[0] == 1'b1 && SR_Read == 2)) begin
                                        ea_build_now = 1'b1;
                                        set_exec[opcMOVESR] = 1'b1;
                                        datatype = 2'b01;
                                        write_back = 1'b1;
                                        if (opcode[5:4] == 2'b00) begin
                                            set_exec[Regwrena] = 1'b1;
                                        end
                                    end else begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end else begin // clr
                                    ea_build_now = 1'b1;
                                    write_back = 1'b1;
                                    set_exec[opcAND] = 1'b1;
                                    if (CPU[0] == 1'b1 && state == 2'b10 && addrvalue == 1'b0) begin
                                        skipFetch = 1'b1;
                                    end
                                    if (setexecOPC == 1'b1) begin
                                        set[OP1out_zero] = 1'b1;
                                    end
                                    if (opcode[5:4] == 2'b00) begin
                                        set_exec[Regwrena] = 1'b1;
                                    end
                                end
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                        3'b010: begin
                            if (opcode[7:6] == 2'b11) begin // move to CCR
                                if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                    (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // ea illegal modes
                                    ea_build_now = 1'b1;
                                    datatype = 2'b01;
                                    source_lowbits = 1'b1;
                                    if ((decodeOPC == 1'b1 && opcode[5:4] == 2'b00) || (state == 2'b10 && addrvalue == 1'b0) || direct_data == 1'b1) begin
                                        set[to_CCR] = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin // neg
                                if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                    (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                                    ea_build_now = 1'b1;
                                    write_back = 1'b1;
                                    set_exec[opcADD] = 1'b1;
                                    set[addsub] = 1'b1;
                                    source_lowbits = 1'b1;
                                    if (opcode[5:4] == 2'b00) begin
                                        set_exec[Regwrena] = 1'b1;
                                    end
                                    if (setexecOPC == 1'b1) begin
                                        set[OP1out_zero] = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                        end
                        3'b011: begin // not, move toSR
                            if (opcode[7:6] == 2'b11) begin // move to SR
                                if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                    (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // ea illegal modes
                                    if (SVmode == 1'b1) begin
                                        ea_build_now = 1'b1;
                                        datatype = 2'b01;
                                        source_lowbits = 1'b1;
                                        if ((decodeOPC == 1'b1 && opcode[5:4] == 2'b00) || (state == 2'b10 && addrvalue == 1'b0) || direct_data == 1'b1) begin
                                            set[to_SR] = 1'b1;
                                            set[to_CCR] = 1'b1;
                                        end
                                        if (exec[to_SR] == 1'b1 || (decodeOPC == 1'b1 && opcode[5:4] == 2'b00) || (state == 2'b10 && addrvalue == 1'b0) || direct_data == 1'b1) begin
                                            setstate = 2'b01;
                                        end
                                    end else begin
                                        trap_priv = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin // not
                                if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                    (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                                    ea_build_now = 1'b1;
                                    write_back = 1'b1;
                                    set_exec[opcEOR] = 1'b1;
                                    set_exec[ea_data_OP1] = 1'b1;
                                    if (opcode[5:3] == 3'b000) begin
                                        set_exec[Regwrena] = 1'b1;
                                    end
                                    if (setexecOPC == 1'b1) begin
                                        set[OP2out_one] = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                        end
                        3'b100, 3'b110: begin
                            if (opcode[7] == 1'b1) begin // movem, ext
                                if (opcode[5:3] == 3'b000 && opcode[10] == 1'b0) begin // ext
                                    source_lowbits = 1'b1;
                                    set_exec[opcEXT] = 1'b1;
                                    set_exec[opcMOVE] = 1'b1;
                                    set_exec[Regwrena] = 1'b1;
                                    if (opcode[6] == 1'b0) begin
                                        datatype = 2'b01; // WORD
                                        set_exec[opcEXTB] = 1'b1;
                                    end
                                end else begin // movem
                                    if ((opcode[10] == 1'b1 || ((opcode[5] == 1'b1 || opcode[4:3] == 2'b10) &&
                                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))) &&
                                        (opcode[10] == 1'b0 || (opcode[5:4] != 2'b00 &&
                                        opcode[5:3] != 3'b100 &&
                                        opcode[5:2] != 4'b1111))) begin // ea illegal modes

                                        ea_only = 1'b1;
                                        set[no_Flags] = 1'b1;
                                        if (opcode[6] == 1'b0) begin
                                            datatype = 2'b01; // Word transfer
                                        end
                                        if ((opcode[5:3] == 3'b100 || opcode[5:3] == 3'b011) && state == 2'b01) begin // -(An), (An)+
                                            set_exec[save_memaddr] = 1'b1;
                                            set_exec[Regwrena] = 1'b1;
                                        end
                                        if (opcode[5:3] == 3'b100) begin // -(An)
                                            movem_presub = 1'b1;
                                            set[subidx] = 1'b1;
                                        end
                                        if (state == 2'b10 && addrvalue == 1'b0) begin
                                            set[Regwrena] = 1'b1;
                                            set[opcMOVE] = 1'b1;
                                        end
                                        if (decodeOPC == 1'b1) begin
                                            set[get_2ndOPC] = 1'b1;
                                            if (opcode[5:3] == 3'b010 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100) begin
                                                next_micro_state = movem1;
                                            end else begin
                                                next_micro_state = nop;
                                                set[ea_build] = 1'b1;
                                            end
                                        end
                                        if (set[get_ea_now] == 1'b1) begin
                                            if (movem_run == 1'b1) begin
                                                set[movem_action] = 1'b1;
                                                if (opcode[10] == 1'b0) begin
                                                    setstate = 2'b11;
                                                    set[write_reg] = 1'b1;
                                                end else begin
                                                    setstate = 2'b10;
                                                end
                                                next_micro_state = movem2;
                                                set[mem_addsub] = 1'b1;
                                            end else begin
                                                setstate = 2'b01;
                                            end
                                        end
                                    end else begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end
                            end else begin
                                if (opcode[10] == 1'b1) begin // MUL.L, DIV.L 68020
                                    // FPGA Multiplier for long
                                    if (opcode[8:7] == 2'b00 && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) && // ea An illegal mode
                                        MUL_Hardware == 1 && (opcode[6] == 1'b0 && (MUL_Mode == 1 || (CPU[1] == 1'b1 && MUL_Mode == 2)))) begin

                                        if (decodeOPC == 1'b1) begin
                                            next_micro_state = nop;
                                            set[get_2ndOPC] = 1'b1;
                                            set[ea_build] = 1'b1;
                                        end
                                        if ((micro_state == idle && nextpass == 1'b1) || (opcode[5:4] == 2'b00 && exec[ea_build] == 1'b1)) begin
                                            dest_2ndHbits = 1'b1;
                                            datatype = 2'b10;
                                            set[opcMULU] = 1'b1;
                                            set[write_lowlong] = 1'b1;
                                            if (sndOPC[10] == 1'b1) begin
                                                setstate = 2'b01;
                                                next_micro_state = mul_end2;
                                            end
                                            set[Regwrena] = 1'b1;
                                        end
                                        source_lowbits = 1'b1;
                                        datatype = 2'b10;

                                    // no FPGA Multiplier
                                    end else if (opcode[8:7] == 2'b00 && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) && // ea An illegal mode
                                        ((opcode[6] == 1'b1 && (DIV_Mode == 1 || (CPU[1] == 1'b1 && DIV_Mode == 2))) ||
                                        (opcode[6] == 1'b0 && (MUL_Mode == 1 || (CPU[1] == 1'b1 && MUL_Mode == 2))))) begin

                                        if (decodeOPC == 1'b1) begin
                                            next_micro_state = nop;
                                            set[get_2ndOPC] = 1'b1;
                                            set[ea_build] = 1'b1;
                                        end
                                        if ((micro_state == idle && nextpass == 1'b1) || (opcode[5:4] == 2'b00 && exec[ea_build] == 1'b1)) begin
                                            setstate = 2'b01;
                                            dest_2ndHbits = 1'b1;
                                            source_2ndLbits = 1'b1;
                                            if (opcode[6] == 1'b1) begin
                                                next_micro_state = div1;
                                            end else begin
                                                next_micro_state = mul1;
                                                set[ld_rot_cnt] = 1'b1;
                                            end
                                        end
                                        source_lowbits = 1'b1;
                                        if (nextpass == 1'b1 || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1)) begin
                                            dest_hbits = 1'b1;
                                        end
                                        datatype = 2'b10;
                                    end else begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end else begin // pea, swap
                                    if (opcode[6] == 1'b1) begin
                                        datatype = 2'b10;
                                        if (opcode[5:3] == 3'b000) begin // swap
                                            set_exec[opcSWAP] = 1'b1;
                                            set_exec[Regwrena] = 1'b1;
                                        end else if (opcode[5:3] == 3'b001) begin // bkpt
                                            trap_illegal = 1'b1;
                                            trapmake = 1'b1;
                                        end else begin // pea
                                            if ((opcode[5] == 1'b1 || opcode[4:3] == 2'b10) &&
                                                opcode[5:3] != 3'b100 &&
                                                opcode[5:2] != 4'b1111) begin // ea illegal modes
                                                ea_only = 1'b1;
                                                ea_build_now = 1'b1;
                                                if (nextpass == 1'b1 && micro_state == idle) begin
                                                    set[presub] = 1'b1;
                                                    setstackaddr = 1'b1;
                                                    setstate = 2'b11;
                                                    next_micro_state = nop;
                                                end
                                                if (set[get_ea_now] == 1'b1) begin
                                                    setstate = 2'b01;
                                                end
                                            end else begin
                                                trap_illegal = 1'b1;
                                                trapmake = 1'b1;
                                            end
                                        end
                                    end else begin
                                        if (opcode[5:3] == 3'b001) begin // link.l
                                            datatype = 2'b10;
                                            set_exec[opcADD] = 1'b1; // for displacement
                                            set_exec[Regwrena] = 1'b1;
                                            set[no_Flags] = 1'b1;
                                            if (decodeOPC == 1'b1) begin
                                                set[linksp] = 1'b1;
                                                set[longaktion] = 1'b1;
                                                next_micro_state = link1;
                                                set[presub] = 1'b1;
                                                setstackaddr = 1'b1;
                                                set[mem_addsub] = 1'b1;
                                                source_lowbits = 1'b1;
                                                source_areg = 1'b1;
                                                set[store_ea_data] = 1'b1;
                                            end
                                        end else begin // nbcd
                                            if (opcode[5:3] != 3'b001 && // ea An illegal mode
                                                (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                                                ea_build_now = 1'b1;
                                                set_exec[use_XZFlag] = 1'b1;
                                                write_back = 1'b1;
                                                set_exec[opcADD] = 1'b1;
                                                set_exec[opcSBCD] = 1'b1;
                                                set[addsub] = 1'b1;
                                                source_lowbits = 1'b1;
                                                if (opcode[5:4] == 2'b00) begin
                                                    set_exec[Regwrena] = 1'b1;
                                                end
                                                if (setexecOPC == 1'b1) begin
                                                    set[OP1out_zero] = 1'b1;
                                                end
                                            end else begin
                                                trap_illegal = 1'b1;
                                                trapmake = 1'b1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        // 0x4AXX
                        3'b101: begin // tst, tas 4aFC - illegal
                            if (opcode[7:3] == 5'b11111 && opcode[2:1] != 2'b00) begin // 0x4AFC illegal -- 0x4AFB BKP Sinclair QL
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end else begin
                                if ((opcode[7:6] != 2'b11 || // tas
                                    (opcode[5:3] != 3'b001 && // ea An illegal mode
                                    (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))) && // ea illegal modes
                                    ((opcode[7:6] != 2'b00 || (opcode[5:3] != 3'b001)) &&
                                    (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00))) begin

                                    ea_build_now = 1'b1;
                                    if (setexecOPC == 1'b1) begin
                                        source_lowbits = 1'b1;
                                        if (opcode[3] == 1'b1) begin // MC68020...
                                            source_areg = 1'b1;
                                        end
                                    end
                                    set_exec[opcMOVE] = 1'b1;
                                    if (opcode[7:6] == 2'b11) begin // tas
                                        set_exec_tas = 1'b1;
                                        write_back = 1'b1;
                                        datatype = 2'b00; // Byte
                                        if (opcode[5:4] == 2'b00) begin
                                            set_exec[Regwrena] = 1'b1;
                                        end
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                        end
                        3'b111: begin // 4EXX
                            if (opcode[7] == 1'b1) begin // jsr, jmp
                                if ((opcode[5] == 1'b1 || opcode[4:3] == 2'b10) &&
                                    opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin // ea illegal modes

                                    datatype = 2'b10;
                                    ea_only = 1'b1;
                                    ea_build_now = 1'b1;
                                    if (exec[ea_to_pc] == 1'b1) begin
                                        next_micro_state = nop;
                                    end
                                    if (nextpass == 1'b1 && micro_state == idle && opcode[6] == 1'b0) begin
                                        set[presub] = 1'b1;
                                        setstackaddr = 1'b1;
                                        setstate = 2'b11;
                                        next_micro_state = nopnop;
                                    end

                                    if (micro_state == ld_AnXn1 && brief[8] == 1'b0) begin // JMP/JSR n(Ax,Dn)
                                        skipFetch = 1'b1;
                                    end
                                    if (state == 2'b00) begin
                                        writePC = 1'b1;
                                    end
                                    set[hold_dwr] = 1'b1;
                                    if (set[get_ea_now] == 1'b1) begin // jsr
                                        if (exec[longaktion] == 1'b0 || long_done == 1'b1) begin
                                            skipFetch = 1'b1;
                                        end
                                        setstate = 2'b01;
                                        set[ea_to_pc] = 1'b1;
                                    end
                                end else begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin
                                case (opcode[6:0])
                                    7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011, 7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111,
                                    7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011, 7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111: begin // trap
                                        trap_trap = 1'b1;
                                        trapmake = 1'b1;
                                    end

                                    7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011, 7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: begin // link word
                                        datatype = 2'b10;
                                        set_exec[opcADD] = 1'b1; // for displacement
                                        set_exec[Regwrena] = 1'b1;
                                        set[no_Flags] = 1'b1;
                                        if (decodeOPC == 1'b1) begin
                                            next_micro_state = link1;
                                            set[presub] = 1'b1;
                                            setstackaddr = 1'b1;
                                            set[mem_addsub] = 1'b1;
                                            source_lowbits = 1'b1;
                                            source_areg = 1'b1;
                                            set[store_ea_data] = 1'b1;
                                        end
                                    end

                                    7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011, 7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111: begin // unlink
                                        datatype = 2'b10;
                                        set_exec[Regwrena] = 1'b1;
                                        set_exec[opcMOVE] = 1'b1;
                                        set[no_Flags] = 1'b1;
                                        if (decodeOPC == 1'b1) begin
                                            setstate = 2'b01;
                                            next_micro_state = unlink1;
                                            set[opcMOVE] = 1'b1;
                                            set[Regwrena] = 1'b1;
                                            setstackaddr = 1'b1;
                                            source_lowbits = 1'b1;
                                            source_areg = 1'b1;
                                        end
                                    end

                                    7'b1100000, 7'b1100001, 7'b1100010, 7'b1100011, 7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111: begin // move An,USP
                                        if (SVmode == 1'b1) begin
                                            // set[no_Flags] = 1'b1;
                                            set[to_USP] = 1'b1;
                                            source_lowbits = 1'b1;
                                            source_areg = 1'b1;
                                            datatype = 2'b10;
                                        end else begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end
                                    end

                                    7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011, 7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111: begin // move USP,An
                                        if (SVmode == 1'b1) begin
                                            // set[no_Flags] = 1'b1;
                                            set[from_USP] = 1'b1;
                                            datatype = 2'b10;
                                            set_exec[Regwrena] = 1'b1;
                                        end else begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end
                                    end

                                    7'b1110000: begin // reset
                                        if (SVmode == 1'b0) begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end else begin
                                            set[opcRESET] = 1'b1;
                                            if (decodeOPC == 1'b1) begin
                                                set[ld_rot_cnt] = 1'b1;
                                                set_rot_cnt = 6'b000000;
                                            end
                                        end
                                    end

                                    7'b1110001: begin // nop
                                    end

                                    7'b1110010: begin // stop
                                        if (SVmode == 1'b0) begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end else begin
                                            if (decodeOPC == 1'b1) begin
                                                setnextpass = 1'b1;
                                                set_stop = 1'b1;
                                            end
                                            if (stop == 1'b1) begin
                                                skipFetch = 1'b1;
                                            end
                                        end
                                    end

                                    7'b1110011, 7'b1110111: begin // rte/rtr
                                        if (SVmode == 1'b1 || opcode[2] == 1'b1) begin
                                            if (decodeOPC == 1'b1) begin
                                                setstate = 2'b10;
                                                set[postadd] = 1'b1;
                                                setstackaddr = 1'b1;
                                                if (opcode[2] == 1'b1) begin
                                                    set[directCCR] = 1'b1;
                                                end else begin
                                                    set[directSR] = 1'b1;
                                                end
                                                next_micro_state = rte1;
                                            end
                                        end else begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end
                                    end

                                    7'b1110100: begin // rtd
                                        datatype = 2'b10;
                                        if (decodeOPC == 1'b1) begin
                                            setstate = 2'b10;
                                            set[postadd] = 1'b1;
                                            setstackaddr = 1'b1;
                                            set[direct_delta] = 1'b1;
                                            set[directPC] = 1'b1;
                                            set_direct_data = 1'b1;
                                            next_micro_state = rtd1;
                                        end
                                    end

                                    7'b1110101: begin // rts
                                        datatype = 2'b10;
                                        if (decodeOPC == 1'b1) begin
                                            setstate = 2'b10;
                                            set[postadd] = 1'b1;
                                            setstackaddr = 1'b1;
                                            set[direct_delta] = 1'b1;
                                            set[directPC] = 1'b1;
                                            next_micro_state = nopnop;
                                        end
                                    end

                                    7'b1110110: begin // trapv
                                        if (decodeOPC == 1'b1) begin
                                            setstate = 2'b01;
                                        end
                                        if (Flags[1] == 1'b1 && state == 2'b01) begin
                                            trap_trapv = 1'b1;
                                            trapmake = 1'b1;
                                        end
                                    end

                                    7'b1111010, 7'b1111011: begin // movec
                                        if (CPU == 2'b00) begin
                                            trap_illegal = 1'b1;
                                            trapmake = 1'b1;
                                        end else if (SVmode == 1'b0) begin
                                            trap_priv = 1'b1;
                                            trapmake = 1'b1;
                                        end else begin
                                            datatype = 2'b10; // Long
                                            if (last_data_read[11:0] == 12'h800) begin
                                                set[from_USP] = 1'b1;
                                                if (opcode[0] == 1'b1) begin
                                                    set[to_USP] = 1'b1;
                                                end
                                            end
                                            if (opcode[0] == 1'b0) begin
                                                set_exec[movec_rd] = 1'b1;
                                            end else begin
                                                set_exec[movec_wr] = 1'b1;
                                            end
                                            if (decodeOPC == 1'b1) begin
                                                next_micro_state = movec1;
                                                getbrief = 1'b1;
                                            end
                                        end
                                    end

                                    default: begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                endcase
                            end
                        end
                        default: ;
                    endcase
                end
            end

            // 0101 ----------------------------------------------------------------------------
            4'b0101: begin // subq, addq
                if (opcode[7:6] == 2'b11) begin // dbcc
                    if (opcode[5:3] == 3'b001) begin // dbcc
                        if (decodeOPC == 1'b1) begin
                            next_micro_state = dbcc1;
                            set[OP2out_one] = 1'b1;
                            data_is_source = 1'b1;
                        end
                    end else if (opcode[5:3] == 3'b111 && (opcode[2:1] == 2'b01 || opcode[2:0] == 3'b100)) begin // trapcc
                        if (CPU[1] == 1'b1) begin // only 68020+
                            if (opcode[2:1] == 2'b01) begin
                                if (decodeOPC == 1'b1) begin
                                    if (opcode[0] == 1'b1) begin // long
                                        set[longaktion] = 1'b1;
                                    end
                                    next_micro_state = nop;
                                end
                            end else begin
                                if (decodeOPC == 1'b1) begin
                                    setstate = 2'b01;
                                end
                            end
                            if (exe_condition == 1'b1 && decodeOPC == 1'b0) begin
                                trap_trapv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00) begin // Scc
                        datatype = 2'b00; // Byte
                        ea_build_now = 1'b1;
                        write_back = 1'b1;
                        set_exec[opcScc] = 1'b1;
                        if (CPU[0] == 1'b1 && state == 2'b10 && addrvalue == 1'b0) begin
                            skipFetch = 1'b1;
                        end
                        if (opcode[5:4] == 2'b00) begin
                            set_exec[Regwrena] = 1'b1;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin // addq, subq
                    if (opcode[7:3] != 5'b00001 &&
                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes

                        ea_build_now = 1'b1;
                        if (opcode[5:3] == 3'b001) begin
                            set[no_Flags] = 1'b1;
                        end
                        if (opcode[8] == 1'b1) begin
                            set[addsub] = 1'b1;
                        end
                        write_back = 1'b1;
                        set_exec[opcADDQ] = 1'b1;
                        set_exec[opcADD] = 1'b1;
                        set_exec[ea_data_OP1] = 1'b1;
                        if (opcode[5:4] == 2'b00) begin
                            set_exec[Regwrena] = 1'b1;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
            end

            // 0110 ----------------------------------------------------------------------------
            4'b0110: begin // bra,bsr,bcc
                datatype = 2'b10;

                if (micro_state == idle) begin
                    if (opcode[11:8] == 4'b0001) begin // bsr
                        set[presub] = 1'b1;
                        setstackaddr = 1'b1;
                        if (opcode[7:0] == 8'b11111111) begin
                            next_micro_state = bsr2;
                            set[longaktion] = 1'b1;
                        end else if (opcode[7:0] == 8'b00000000) begin
                            next_micro_state = bsr2;
                        end else begin
                            next_micro_state = bsr1;
                            setstate = 2'b11;
                            writePC = 1'b1;
                        end
                    end else begin // bra
                        if (opcode[7:0] == 8'b11111111) begin
                            next_micro_state = bra1;
                            set[longaktion] = 1'b1;
                        end else if (opcode[7:0] == 8'b00000000) begin
                            next_micro_state = bra1;
                        end else begin
                            setstate = 2'b01;
                            next_micro_state = bra1;
                        end
                    end
                end
            end

            // 0111 ----------------------------------------------------------------------------
            4'b0111: begin // moveq
                if (opcode[8] == 1'b0) begin
                    datatype = 2'b10; // Long
                    set_exec[Regwrena] = 1'b1;
                    set_exec[opcMOVEQ] = 1'b1;
                    set_exec[opcMOVE] = 1'b1;
                    dest_hbits = 1'b1;
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end

            // 1000 ----------------------------------------------------------------------------
            4'b1000: begin // or
                if (opcode[7:6] == 2'b11) begin // divu, divs
                    if (DIV_Mode != 3 &&
                        opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // ea illegal modes

                        if (opcode[5:4] == 2'b00) begin // Dn, An
                            regdirectsource = 1'b1;
                        end
                        if ((micro_state == idle && nextpass == 1'b1) || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1)) begin
                            setstate = 2'b01;
                            next_micro_state = div1;
                        end
                        ea_build_now = 1'b1;
                        if (Z_error == 1'b0 && set_V_Flag == 1'b0) begin
                            set_exec[Regwrena] = 1'b1;
                        end
                        source_lowbits = 1'b1;
                        if (nextpass == 1'b1 || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1)) begin
                            dest_hbits = 1'b1;
                        end
                        datatype = 2'b01;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else if (opcode[8] == 1'b1 && opcode[5:4] == 2'b00) begin // sbcd, pack , unpack
                    if (opcode[7:6] == 2'b00) begin // sbcd
                        build_bcd = 1'b1;
                        set_exec[opcADD] = 1'b1;
                        set_exec[opcSBCD] = 1'b1;
                        set[addsub] = 1'b1;
                    end else if (opcode[7:6] == 2'b01 || opcode[7:6] == 2'b10) begin // pack , unpack
                        set_exec[ea_data_OP1] = 1'b1;
                        set[no_Flags] = 1'b1;
                        source_lowbits = 1'b1;
                        if (opcode[7:6] == 2'b01) begin // pack
                            set_exec[opcPACK] = 1'b1;
                            datatype = 2'b01; // Word
                        end else begin // unpk
                            set_exec[opcUNPACK] = 1'b1;
                            datatype = 2'b00; // Byte
                        end
                        if (opcode[3] == 1'b0) begin
                            if (opcode[7:6] == 2'b01) begin // pack
                                set_datatype = 2'b00; // Byte
                            end else begin // unpk
                                set_datatype = 2'b01; // Word
                            end
                            set_exec[Regwrena] = 1'b1;
                            dest_hbits = 1'b1;
                            if (decodeOPC == 1'b1) begin
                                next_micro_state = nop;
                                // set_direct_data = 1'b1;
                                set[store_ea_packdata] = 1'b1;
                                set[store_ea_data] = 1'b1;
                            end
                        end else begin // pack -(Ax),-(Ay)
                            write_back = 1'b1;
                            if (decodeOPC == 1'b1) begin
                                next_micro_state = pack1;
                                set_direct_data = 1'b1;
                            end
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin // or
                    if (opcode[7:6] != 2'b11 && // illegal opmode
                        ((opcode[8] == 1'b0 && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) || // illegal src ea
                        (opcode[8] == 1'b1 && opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)))) begin // illegal dst ea

                        set_exec[opcOR] = 1'b1;
                        build_logical = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
            end

            // 1001, 1101 -----------------------------------------------------------------------
            4'b1001, 4'b1101: begin // sub, add
                if (opcode[8:3] != 6'b000001 && // byte src address reg direct
                    (((opcode[8] == 1'b0 || opcode[7:6] == 2'b11) && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) || // illegal src ea
                    (opcode[8] == 1'b1 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)))) begin // illegal dst ea

                    set_exec[opcADD] = 1'b1;
                    ea_build_now = 1'b1;
                    if (opcode[14] == 1'b0) begin
                        set[addsub] = 1'b1;
                    end
                    if (opcode[7:6] == 2'b11) begin // adda, suba
                        if (opcode[8] == 1'b0) begin // adda.w, suba.w
                            datatype = 2'b01; // Word
                        end
                        set_exec[Regwrena] = 1'b1;
                        source_lowbits = 1'b1;
                        if (opcode[3] == 1'b1) begin
                            source_areg = 1'b1;
                        end
                        set[no_Flags] = 1'b1;
                        if (setexecOPC == 1'b1) begin
                            dest_areg = 1'b1;
                            dest_hbits = 1'b1;
                        end
                    end else begin
                        if (opcode[8] == 1'b1 && opcode[5:4] == 2'b00) begin // addx, subx
                            build_bcd = 1'b1;
                        end else begin // sub, add
                            build_logical = 1'b1;
                        end
                    end
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end

            // 1010 ----------------------------------------------------------------------------
            4'b1010: begin // Trap 1010
                trap_1010 = 1'b1;
                trapmake = 1'b1;
            end

            // 1011 ----------------------------------------------------------------------------
            4'b1011: begin // eor, cmp
                if (opcode[7:6] == 2'b11) begin // CMPA
                    if (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) begin // illegal src ea
                        ea_build_now = 1'b1;
                        if (opcode[8] == 1'b0) begin // cmpa.w
                            datatype = 2'b01; // Word
                            set_exec[opcCPMAW] = 1'b1;
                        end
                        set_exec[opcCMP] = 1'b1;
                        if (setexecOPC == 1'b1) begin
                            source_lowbits = 1'b1;
                            if (opcode[3] == 1'b1) begin
                                source_areg = 1'b1;
                            end
                            dest_areg = 1'b1;
                            dest_hbits = 1'b1;
                        end
                        set[addsub] = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin // cmpm, eor, cmp
                    if (opcode[8] == 1'b1) begin
                        if (opcode[5:3] == 3'b001) begin // cmpm
                            ea_build_now = 1'b1;
                            set_exec[opcCMP] = 1'b1;
                            if (decodeOPC == 1'b1) begin
                                if (opcode[2:0] == 3'b111) begin
                                    set[use_SP] = 1'b1;
                                end
                                setstate = 2'b10;
                                set[update_ld] = 1'b1;
                                set[postadd] = 1'b1;
                                next_micro_state = cmpm;
                            end
                            set_exec[ea_data_OP1] = 1'b1;
                            set[addsub] = 1'b1;
                        end else begin // EOR
                            if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00) begin // illegal dst ea
                                ea_build_now = 1'b1;
                                build_logical = 1'b1;
                                set_exec[opcEOR] = 1'b1;
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                    end else begin // CMP
                        if (opcode[8:3] != 6'b000001 && // byte src address reg direct
                            (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // illegal src ea
                            ea_build_now = 1'b1;
                            build_logical = 1'b1;
                            set_exec[opcCMP] = 1'b1;
                            set[addsub] = 1'b1;
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end
            end

            // 1100 ----------------------------------------------------------------------------
            4'b1100: begin // and, exg
                if (opcode[7:6] == 2'b11) begin // mulu, muls
                    if (MUL_Mode != 3 &&
                        opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin // ea illegal modes

                        if (opcode[5:4] == 2'b00) begin // Dn, An
                            regdirectsource = 1'b1;
                        end
                        if ((micro_state == idle && nextpass == 1'b1) || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1)) begin
                            if (MUL_Hardware == 0) begin
                                setstate = 2'b01;
                                set[ld_rot_cnt] = 1'b1;
                                next_micro_state = mul1;
                            end else begin
                                set_exec[write_lowlong] = 1'b1;
                                set_exec[opcMULU] = 1'b1;
                            end
                        end
                        ea_build_now = 1'b1;
                        set_exec[Regwrena] = 1'b1;
                        source_lowbits = 1'b1;
                        if (nextpass == 1'b1 || (opcode[5:4] == 2'b00 && decodeOPC == 1'b1)) begin
                            dest_hbits = 1'b1;
                        end
                        datatype = 2'b01;
                        if (setexecOPC == 1'b1) begin
                            datatype = 2'b10;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else if (opcode[8] == 1'b1 && opcode[5:4] == 2'b00) begin // exg, abcd
                    if (opcode[7:6] == 2'b00) begin // abcd
                        build_bcd = 1'b1;
                        set_exec[opcADD] = 1'b1;
                        set_exec[opcABCD] = 1'b1;
                    end else begin // exg
                        if (opcode[7:4] == 4'b0100 || opcode[7:3] == 5'b10001) begin
                            datatype = 2'b10;
                            set[Regwrena] = 1'b1;
                            set[exg] = 1'b1;
                            set[alu_move] = 1'b1;
                            if (opcode[6] == 1'b1 && opcode[3] == 1'b1) begin
                                dest_areg = 1'b1;
                                source_areg = 1'b1;
                            end
                            if (decodeOPC == 1'b1) begin
                                setstate = 2'b01;
                            end else begin
                                dest_hbits = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end else begin // and
                    if (opcode[7:6] != 2'b11 && // illegal opmode
                        ((opcode[8] == 1'b0 && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) || // illegal src ea
                        (opcode[8] == 1'b1 && opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)))) begin // illegal dst ea

                        set_exec[opcAND] = 1'b1;
                        build_logical = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
            end

            // 1110 ----------------------------------------------------------------------------
            4'b1110: begin // rotation / bitfield
                if (opcode[7:6] == 2'b11) begin
                    if (opcode[11] == 1'b0) begin
                        if (opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes
                            if (BarrelShifter == 0) begin
                                set_exec[opcROT] = 1'b1;
                            end else begin
                                set_exec[exec_BS] = 1'b1;
                            end
                            ea_build_now = 1'b1;
                            datatype = 2'b01;
                            set_rot_bits = opcode[10:9];
                            set_exec[ea_data_OP1] = 1'b1;
                            write_back = 1'b1;
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin // bitfield
                        if (BitField == 0 || (CPU[1] == 1'b0 && BitField == 2) ||
                            ((opcode[10:9] == 2'b11 || opcode[10:8] == 3'b010 || opcode[10:8] == 3'b100) &&
                            (opcode[5:3] == 3'b001 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100 || (opcode[5:3] == 3'b111 && opcode[2:1] != 2'b00))) ||
                            ((opcode[10:9] == 2'b00 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101) &&
                            (opcode[5:3] == 3'b001 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100 || opcode[5:2] == 4'b1111))) begin

                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end else begin
                            if (decodeOPC == 1'b1) begin
                                next_micro_state = nop;
                                set[get_2ndOPC] = 1'b1;
                                set[ea_build] = 1'b1;
                            end
                            set_exec[opcBF] = 1'b1;
                            // 000-bftst, 001-bfextu, 010-bfchg, 011-bfexts, 100-bfclr, 101-bfff0, 110-bfset, 111-bfins
                            if (opcode[10] == 1'b1 || opcode[8] == 1'b0) begin
                                set_exec[opcBFwb] = 1'b1; // '1' for tst,chg,clr,ffo,set,ins    --'0' for extu,exts
                            end
                            if (opcode[10:8] == 3'b111) begin // BFINS
                                set_exec[ea_data_OP1] = 1'b1;
                            end
                            if (opcode[10:8] == 3'b010 || opcode[10:8] == 3'b100 || opcode[10:8] == 3'b110 || opcode[10:8] == 3'b111) begin
                                write_back = 1'b1;
                            end
                            ea_only = 1'b1;
                            if (opcode[10:8] == 3'b001 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101) begin
                                set_exec[Regwrena] = 1'b1;
                            end
                            if (opcode[4:3] == 2'b00) begin
                                if (opcode[10:8] != 3'b000) begin
                                    set_exec[Regwrena] = 1'b1;
                                end
                                if (exec[ea_build] == 1'b1) begin
                                    dest_2ndHbits = 1'b1;
                                    source_2ndLbits = 1'b1;
                                    set[get_bfoffset] = 1'b1;
                                    setstate = 2'b01;
                                end
                            end
                            if (set[get_ea_now] == 1'b1) begin
                                setstate = 2'b01;
                            end
                            if (exec[get_ea_now] == 1'b1) begin
                                dest_2ndHbits = 1'b1;
                                source_2ndLbits = 1'b1;
                                set[get_bfoffset] = 1'b1;
                                setstate = 2'b01;
                                set[mem_addsub] = 1'b1;
                                next_micro_state = bf1;
                            end
                            if (setexecOPC == 1'b1) begin
                                if (opcode[10:8] == 3'b111) begin // BFINS
                                    source_2ndHbits = 1'b1;
                                end else begin
                                    source_lowbits = 1'b1;
                                end
                                if (opcode[10:8] == 3'b001 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101) begin // BFEXT, BFFFO
                                    dest_2ndHbits = 1'b1;
                                end
                            end
                        end
                    end
                end else begin
                    data_is_source = 1'b1;
                    if (BarrelShifter == 0 || (CPU[1] == 1'b0 && BarrelShifter == 2)) begin
                        set_exec[opcROT] = 1'b1;
                        set_rot_bits = opcode[4:3];
                        set_exec[Regwrena] = 1'b1;
                        if (decodeOPC == 1'b1) begin
                            if (opcode[5] == 1'b1) begin
                                next_micro_state = rota1;
                                set[ld_rot_cnt] = 1'b1;
                                setstate = 2'b01;
                            end else begin
                                set_rot_cnt[2:0] = opcode[11:9];
                                if (opcode[11:9] == 3'b000) begin
                                    set_rot_cnt[3] = 1'b1;
                                end else begin
                                    set_rot_cnt[3] = 1'b0;
                                end
                            end
                        end
                    end else begin
                        set_exec[exec_BS] = 1'b1;
                        set_rot_bits = opcode[4:3];
                        set_exec[Regwrena] = 1'b1;
                    end
                end
            end

            // 1111 ----------------------------------------------------------------------------
            4'b1111: begin
                if (CPU[1] == 1'b1 && opcode[8:6] == 3'b100) begin // cpSAVE
                    if (opcode[5:4] != 2'b00 && opcode[5:3] != 3'b011 &&
                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin // ea illegal modes

                        if (opcode[11:9] != 3'b000) begin
                            if (SVmode == 1'b1) begin
                                if (opcode[5] == 1'b0 && opcode[5:4] != 2'b01) begin
                                    // never reached according to cputest?!
                                    // cpSAVE not implemented
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end else begin
                                    trap_1111 = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            if (SVmode == 1'b1) begin
                                trap_1111 = 1'b1;
                                trapmake = 1'b1;
                            end else begin
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                    end else begin
                        trap_1111 = 1'b1;
                        trapmake = 1'b1;
                    end
                end else if (CPU[1] == 1'b1 && opcode[8:6] == 3'b101) begin // cpRESTORE
                    if (opcode[5:4] != 2'b00 && opcode[5:3] != 3'b100 &&
                        (opcode[5:3] != 3'b111 || (opcode[2:1] != 2'b11 &&
                        opcode[2:0] != 3'b101))) begin // ea illegal modes

                        if (opcode[5:1] != 5'b11110) begin
                            if (opcode[11:9] == 3'b001 || opcode[11:9] == 3'b010) begin
                                if (SVmode == 1'b1) begin
                                    if (opcode[5:3] == 3'b101) begin
                                        // cpRESTORE not implemented
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end else begin
                                        trap_1111 = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end else begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end else begin
                                if (SVmode == 1'b1) begin
                                    trap_1111 = 1'b1;
                                    trapmake = 1'b1;
                                end else begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                        end else begin
                            trap_1111 = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin
                        trap_1111 = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin
                    trap_1111 = 1'b1;
                    trapmake = 1'b1;
                end
            end

            default: begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        endcase

        // use for AND, OR, EOR, CMP
        if (build_logical == 1'b1) begin
            ea_build_now = 1'b1;
            if (set_exec[opcCMP] == 1'b0 && (opcode[8] == 1'b0 || opcode[5:4] == 2'b00)) begin
                set_exec[Regwrena] = 1'b1;
            end
            if (opcode[8] == 1'b1) begin
                write_back = 1'b1;
                set_exec[ea_data_OP1] = 1'b1;
            end else begin
                source_lowbits = 1'b1;
                if (opcode[3] == 1'b1) begin // use for cmp
                    source_areg = 1'b1;
                end
                if (setexecOPC == 1'b1) begin
                    dest_hbits = 1'b1;
                end
            end
        end

        // use for ABCD, SBCD
        if (build_bcd == 1'b1) begin
            set_exec[use_XZFlag] = 1'b1;
            set_exec[ea_data_OP1] = 1'b1;
            write_back = 1'b1;
            source_lowbits = 1'b1;
            if (opcode[3] == 1'b1) begin
                if (decodeOPC == 1'b1) begin
                    if (opcode[2:0] == 3'b111) begin
                        set[use_SP] = 1'b1;
                    end
                    setstate = 2'b10;
                    set[update_ld] = 1'b1;
                    set[presub] = 1'b1;
                    next_micro_state = op_AxAy;
                    dest_areg = 1'b1; // ???
                end
            end else begin
                dest_hbits = 1'b1;
                set_exec[Regwrena] = 1'b1;
            end
        end

        if (set_Z_error == 1'b1) begin // divu by zero
            trapmake = 1'b1; // important for USP
            if (trapd == 1'b0) begin
                writePC = 1'b1;
            end
        end

        // Microcode state machine
        case (micro_state)
            ld_nn: begin // (nnnn).w/l=>
                set[get_ea_now] = 1'b1;
                setnextpass = 1'b1;
                set[addrlong] = 1'b1;
            end
            st_nn: begin // =>(nnnn).w/l
                setstate = 2'b11;
                set[addrlong] = 1'b1;
                next_micro_state = nop;
            end
            ld_dAn1: begin // d(An)=>, --d(PC)=>
                set[get_ea_now] = 1'b1;
                setdisp = 1'b1; // word
                setnextpass = 1'b1;
            end
            ld_AnXn1: begin // d(An,Xn)=>, --d(PC,Xn)=>
                if (brief[8] == 1'b0 || extAddr_Mode == 0 || (CPU[1] == 1'b0 && extAddr_Mode == 2)) begin
                    setdisp = 1'b1; // byte
                    setdispbyte = 1'b1;
                    setstate = 2'b01;
                    set[briefext] = 1'b1;
                    next_micro_state = ld_AnXn2;
                end else begin
                    if (brief[7] == 1'b1) begin // suppress Base
                        set_Suppress_Base = 1'b1;
                    end else if (exec[dispouter] == 1'b1) begin
                        set[dispouter] = 1'b1;
                    end
                    if (brief[5] == 1'b0) begin // NULL Base Displacement
                        setstate = 2'b01;
                    end else begin // WORD Base Displacement
                        if (brief[4] == 1'b1) begin
                            set[longaktion] = 1'b1; // LONG Base Displacement
                        end
                    end
                    next_micro_state = ld_229_1;
                end
            end
            ld_AnXn2: begin
                set[get_ea_now] = 1'b1;
                setdisp = 1'b1; // brief
                setnextpass = 1'b1;
            end
            ld_229_1: begin // (bd,An,Xn)=>, --(bd,PC,Xn)=>
                if (brief[5] == 1'b1) begin // Base Displacement
                    setdisp = 1'b1; // add last_data_read
                end
                if (brief[6] == 1'b0 && brief[2] == 1'b0) begin // Preindex or Index
                    set[briefext] = 1'b1;
                    setstate = 2'b01;
                    if (brief[1:0] == 2'b00) begin
                        next_micro_state = ld_AnXn2;
                    end else begin
                        next_micro_state = ld_229_2;
                    end
                end else begin
                    if (brief[1:0] == 2'b00) begin
                        set[get_ea_now] = 1'b1;
                        setnextpass = 1'b1;
                    end else begin
                        setstate = 2'b10;
                        setaddrvalue = 1'b1;
                        set[longaktion] = 1'b1;
                        next_micro_state = ld_229_3;
                    end
                end
            end
            ld_229_2: begin
                setdisp = 1'b1; // add Index
                setstate = 2'b10;
                setaddrvalue = 1'b1;
                set[longaktion] = 1'b1;
                next_micro_state = ld_229_3;
            end
            ld_229_3: begin
                set_Suppress_Base = 1'b1;
                set[dispouter] = 1'b1;
                if (brief[1] == 1'b0) begin // NULL Outer Displacement
                    setstate = 2'b01;
                end else begin // WORD Outer Displacement
                    if (brief[0] == 1'b1) begin
                        set[longaktion] = 1'b1; // LONG Outer Displacement
                    end
                end
                next_micro_state = ld_229_4;
            end
            ld_229_4: begin
                if (brief[1] == 1'b1) begin // Outer Displacement
                    setdisp = 1'b1; // add last_data_read
                end
                if (brief[6] == 1'b0 && brief[2] == 1'b1) begin // Postindex
                    set[briefext] = 1'b1;
                    setstate = 2'b01;
                    next_micro_state = ld_AnXn2;
                end else begin
                    set[get_ea_now] = 1'b1;
                    setnextpass = 1'b1;
                end
            end
            st_dAn1: begin // =>d(An)
                setstate = 2'b11;
                setdisp = 1'b1; // word
                next_micro_state = nop;
            end
            st_AnXn1: begin // =>d(An,Xn)
                if (brief[8] == 1'b0 || extAddr_Mode == 0 || (CPU[1] == 1'b0 && extAddr_Mode == 2)) begin
                    setdisp = 1'b1; // byte
                    setdispbyte = 1'b1;
                    setstate = 2'b01;
                    set[briefext] = 1'b1;
                    next_micro_state = st_AnXn2;
                end else begin
                    if (brief[7] == 1'b1) begin // suppress Base
                        set_Suppress_Base = 1'b1;
                    end
                    if (brief[5] == 1'b0) begin // NULL Base Displacement
                        setstate = 2'b01;
                    end else begin // WORD Base Displacement
                        if (brief[4] == 1'b1) begin
                            set[longaktion] = 1'b1; // LONG Base Displacement
                        end
                    end
                    next_micro_state = st_229_1;
                end
            end
            st_AnXn2: begin
                setstate = 2'b11;
                setdisp = 1'b1; // brief
                set[hold_dwr] = 1'b1;
                next_micro_state = nop;
            end
            st_229_1: begin
                if (brief[5] == 1'b1) begin // Base Displacement
                    setdisp = 1'b1; // add last_data_read
                end
                if (brief[6] == 1'b0 && brief[2] == 1'b0) begin // Preindex or Index
                    set[briefext] = 1'b1;
                    setstate = 2'b01;
                    if (brief[1:0] == 2'b00) begin
                        next_micro_state = st_AnXn2;
                    end else begin
                        next_micro_state = st_229_2;
                    end
                end else begin
                    if (brief[1:0] == 2'b00) begin
                        setstate = 2'b11;
                        next_micro_state = nop;
                    end else begin
                        set[hold_dwr] = 1'b1;
                        setstate = 2'b10;
                        set[longaktion] = 1'b1;
                        next_micro_state = st_229_3;
                    end
                end
            end
            st_229_2: begin
                setdisp = 1'b1; // add Index
                set[hold_dwr] = 1'b1;
                setstate = 2'b10;
                set[longaktion] = 1'b1;
                next_micro_state = st_229_3;
            end
            st_229_3: begin
                set[hold_dwr] = 1'b1;
                set_Suppress_Base = 1'b1;
                set[dispouter] = 1'b1;
                if (brief[1] == 1'b0) begin // NULL Outer Displacement
                    setstate = 2'b01;
                end else begin // WORD Outer Displacement
                    if (brief[0] == 1'b1) begin
                        set[longaktion] = 1'b1; // LONG Outer Displacement
                    end
                end
                next_micro_state = st_229_4;
            end
            st_229_4: begin
                set[hold_dwr] = 1'b1;
                if (brief[1] == 1'b1) begin // Outer Displacement
                    setdisp = 1'b1; // add last_data_read
                end
                if (brief[6] == 1'b0 && brief[2] == 1'b1) begin // Postindex
                    set[briefext] = 1'b1;
                    setstate = 2'b01;
                    next_micro_state = st_AnXn2;
                end else begin
                    setstate = 2'b11;
                    next_micro_state = nop;
                end
            end
            bra1: begin // bra
                if (exe_condition == 1'b1) begin
                    TG68_PC_brw = 1'b1; // pc+0000
                    next_micro_state = nop;
                    skipFetch = 1'b1;
                end
            end
            bsr1: begin // bsr short
                TG68_PC_brw = 1'b1;
                next_micro_state = nop;
            end
            bsr2: begin // bsr
                if (long_start == 1'b0) begin
                    TG68_PC_brw = 1'b1;
                end
                skipFetch = 1'b1;
                set[longaktion] = 1'b1;
                writePC = 1'b1;
                setstate = 2'b11;
                next_micro_state = nopnop;
                setstackaddr = 1'b1;
            end
            nopnop: begin
                next_micro_state = nop;
            end
            dbcc1: begin // dbcc
                if (exe_condition == 1'b0) begin
                    Regwrena_now = 1'b1;
                    if (c_out[1] == 1'b1) begin
                        skipFetch = 1'b1;
                        next_micro_state = nop;
                        TG68_PC_brw = 1'b1;
                    end
                end
            end
            chk20: begin // if C is set -> signed compare
                set[ea_data_OP1] = 1'b1;
                set[addsub] = 1'b1;
                set[alu_exec] = 1'b1;
                set[alu_setFlags] = 1'b1;
                setstate = 2'b01;
                next_micro_state = chk21;
            end
            chk21: begin // check lower bound
                dest_2ndHbits = 1'b1;
                if (sndOPC[15] == 1'b1) begin
                    set_datatype = 2'b10; // long
                    dest_LDRareg = 1'b1;
                    if (opcode[10:9] == 2'b00) begin
                        set[opcEXTB] = 1'b1;
                    end
                end
                set[addsub] = 1'b1;
                set[alu_exec] = 1'b1;
                set[alu_setFlags] = 1'b1;
                setstate = 2'b01;
                next_micro_state = chk22;
            end
            chk22: begin // check upper bound
                dest_2ndHbits = 1'b1;
                set[ea_data_OP2] = 1'b1;
                if (sndOPC[15] == 1'b1) begin
                    set_datatype = 2'b10; // long
                    dest_LDRareg = 1'b1;
                end
                set[addsub] = 1'b1;
                set[alu_exec] = 1'b1;
                set[opcCHK2] = 1'b1;
                set[opcEXTB] = exec[opcEXTB];
                if (sndOPC[11] == 1'b1) begin
                    setstate = 2'b01;
                    next_micro_state = chk23;
                end
            end
            chk23: begin
                setstate = 2'b01;
                next_micro_state = chk24;
            end
            chk24: begin
                if (Flags[0] == 1'b1) begin
                    trapmake = 1'b1;
                end
            end
            cas1: begin
                setstate = 2'b01;
                next_micro_state = cas2;
            end
            cas2: begin
                source_2ndMbits = 1'b1;
                if (Flags[2] == 1'b1) begin
                    setstate = 2'b11;
                    set[write_reg] = 1'b1;
                    set[restore_ADDR] = 1'b1;
                    next_micro_state = nop;
                end else begin
                    set[Regwrena] = 1'b1;
                    set[ea_data_OP2] = 1'b1;
                    dest_2ndLbits = 1'b1;
                    set[alu_move] = 1'b1;
                end
            end
            cas21: begin
                dest_2ndHbits = 1'b1;
                dest_LDRareg = sndOPC[15];
                set[get_ea_now] = 1'b1;
                next_micro_state = cas22;
            end
            cas22: begin
                setstate = 2'b01;
                source_2ndLbits = 1'b1;
                set[ea_data_OP1] = 1'b1;
                set[addsub] = 1'b1;
                set[alu_exec] = 1'b1;
                set[alu_setFlags] = 1'b1;
                next_micro_state = cas23;
            end
            cas23: begin
                dest_LDRHbits = 1'b1;
                set[get_ea_now] = 1'b1;
                next_micro_state = cas24;
            end
            cas24: begin
                if (Flags[2] == 1'b1) begin
                    set[alu_setFlags] = 1'b1;
                end
                setstate = 2'b01;
                set[hold_dwr] = 1'b1;
                source_LDRLbits = 1'b1;
                set[ea_data_OP1] = 1'b1;
                set[addsub] = 1'b1;
                set[alu_exec] = 1'b1;
                next_micro_state = cas25;
            end
            cas25: begin
                setstate = 2'b01;
                set[hold_dwr] = 1'b1;
                next_micro_state = cas26;
            end
            cas26: begin
                if (Flags[2] == 1'b1) begin // write Update 1 to Destination 1
                    source_2ndMbits = 1'b1;
                    set[write_reg] = 1'b1;
                    dest_2ndHbits = 1'b1;
                    dest_LDRareg = sndOPC[15];
                    setstate = 2'b11;
                    set[get_ea_now] = 1'b1;
                    next_micro_state = cas27;
                end else begin // write Destination 2 to Compare 2 first
                    set[hold_dwr] = 1'b1;
                    set[hold_OP2] = 1'b1;
                    dest_LDRLbits = 1'b1;
                    set[alu_move] = 1'b1;
                    set[Regwrena] = 1'b1;
                    set[ea_data_OP2] = 1'b1;
                    next_micro_state = cas28;
                end
            end
            cas27: begin // write Update 2 to Destination 2
                source_LDRMbits = 1'b1;
                set[write_reg] = 1'b1;
                dest_LDRHbits = 1'b1;
                setstate = 2'b11;
                set[get_ea_now] = 1'b1;
                next_micro_state = nopnop;
            end
            cas28: begin // write Destination 1 to Compare 1 second
                dest_2ndLbits = 1'b1;
                set[alu_move] = 1'b1;
                set[Regwrena] = 1'b1;
            end
            movem1: begin // movem
                if (last_data_read[15:0] != 16'h0000) begin
                    setstate = 2'b01;
                    if (opcode[5:3] == 3'b100) begin
                        set[mem_addsub] = 1'b1;
                        if (CPU[1] == 1'b1) begin
                            set[Regwrena] = 1'b1; // tg
                        end
                    end
                    next_micro_state = movem2;
                end
            end
            movem2: begin // movem
                if (movem_run == 1'b0) begin
                    setstate = 2'b01;
                end else begin
                    set[movem_action] = 1'b1;
                    set[mem_addsub] = 1'b1;
                    next_micro_state = movem2;
                    if (opcode[10] == 1'b0) begin
                        setstate = 2'b11;
                        set[write_reg] = 1'b1;
                    end else begin
                        setstate = 2'b10;
                    end
                end
            end
            andi: begin // andi
                if (opcode[5:4] != 2'b00) begin
                    setnextpass = 1'b1;
                end
            end
            pack1: begin // pack -(Ax),-(Ay)
                if (opcode[2:0] == 3'b111) begin
                    set[use_SP] = 1'b1;
                end
                set[hold_ea_data] = 1'b1;
                set[update_ld] = 1'b1;
                setstate = 2'b10;
                set[presub] = 1'b1;
                next_micro_state = pack2;
                dest_areg = 1'b1;
            end
            pack2: begin
                if (opcode[11:9] == 3'b111) begin
                    set[use_SP] = 1'b1;
                end
                set[hold_ea_data] = 1'b1;
                set_direct_data = 1'b1;
                if (opcode[7:6] == 2'b01) begin // pack
                    datatype = 2'b00; // Byte
                end else begin // unpk
                    datatype = 2'b01; // Word
                end
                set[presub] = 1'b1;
                dest_hbits = 1'b1;
                dest_areg = 1'b1;
                setstate = 2'b10;
                next_micro_state = pack3;
            end
            pack3: begin
                skipFetch = 1'b1;
            end
            op_AxAy: begin // op -(Ax),-(Ay)
                if (opcode[11:9] == 3'b111) begin
                    set[use_SP] = 1'b1;
                end
                set_direct_data = 1'b1;
                set[presub] = 1'b1;
                dest_hbits = 1'b1;
                dest_areg = 1'b1;
                setstate = 2'b10;
            end
            cmpm: begin // cmpm (Ay)+,(Ax)+
                if (opcode[11:9] == 3'b111) begin
                    set[use_SP] = 1'b1;
                end
                set_direct_data = 1'b1;
                set[postadd] = 1'b1;
                dest_hbits = 1'b1;
                dest_areg = 1'b1;
                setstate = 2'b10;
            end
            link1: begin // link
                setstate = 2'b11;
                source_areg = 1'b1;
                set[opcMOVE] = 1'b1;
                set[Regwrena] = 1'b1;
                next_micro_state = link2;
            end
            link2: begin // link
                setstackaddr = 1'b1;
                set[ea_data_OP2] = 1'b1;
            end
            unlink1: begin // unlink
                setstate = 2'b10;
                setstackaddr = 1'b1;
                set[postadd] = 1'b1;
                next_micro_state = unlink2;
            end
            unlink2: begin // unlink
                set[ea_data_OP2] = 1'b1;
            end
            trap00: begin // TRAP format #2
                next_micro_state = trap0;
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b10;
            end
            trap0: begin // TRAP
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                if (use_VBR_Stackframe == 1'b1) begin // 68010
                    set[writePC_add] = 1'b1;
                    datatype = 2'b01;
                    next_micro_state = trap1;
                end else begin
                    if (trap_interrupt == 1'b1 || trap_trace == 1'b1 || trap_berr == 1'b1) begin
                        writePC = 1'b1;
                    end
                    datatype = 2'b10;
                    next_micro_state = trap2;
                end
            end
            trap1: begin // TRAP
                if (trap_interrupt == 1'b1 || trap_trace == 1'b1) begin
                    writePC = 1'b1;
                end
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b10;
                next_micro_state = trap2;
            end
            trap2: begin // TRAP
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b01;
                writeSR = 1'b1;
                if (trap_berr == 1'b1) begin
                    next_micro_state = trap4;
                end else begin
                    next_micro_state = trap3;
                end
            end
            trap3: begin // TRAP
                set_vectoraddr = 1'b1;
                datatype = 2'b10;
                set[direct_delta] = 1'b1;
                set[directPC] = 1'b1;
                setstate = 2'b10;
                next_micro_state = nopnop;
            end
            trap4: begin // TRAP
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b01;
                writeSR = 1'b1;
                next_micro_state = trap5;
            end
            trap5: begin // TRAP
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b10;
                writeSR = 1'b1;
                next_micro_state = trap6;
            end
            trap6: begin // TRAP
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                setstate = 2'b11;
                datatype = 2'b01;
                writeSR = 1'b1;
                next_micro_state = trap3;
            end
            rte1: begin // RTE
                datatype = 2'b10;
                setstate = 2'b10;
                set[postadd] = 1'b1;
                setstackaddr = 1'b1;
                set[directPC] = 1'b1;
                if (use_VBR_Stackframe == 1'b0 || opcode[2] == 1'b1) begin // opcode[2]=1 => RTR
                    set[update_FC] = 1'b1;
                    set[direct_delta] = 1'b1;
                end
                next_micro_state = rte2;
            end
            rte2: begin // RTE
                datatype = 2'b01;
                set[update_FC] = 1'b1;
                if (use_VBR_Stackframe == 1'b1 && opcode[2] == 1'b0) begin
                    setstate = 2'b10;
                    set[postadd] = 1'b1;
                    setstackaddr = 1'b1;
                    next_micro_state = rte3;
                end else begin
                    next_micro_state = nop;
                end
            end
            rte3: begin // RTE
                setstate = 2'b01;
                next_micro_state = rte4;
            end
            rte4: begin // RTE
                if (last_data_in[15:12] == 4'b0010) begin
                    setstate = 2'b10;
                    datatype = 2'b10;
                    set[postadd] = 1'b1;
                    setstackaddr = 1'b1;
                    next_micro_state = rte5;
                end else begin
                    datatype = 2'b01;
                    next_micro_state = nop;
                end
            end
            rte5: begin // RTE
                next_micro_state = nop;
            end
            rtd1: begin // RTD
                next_micro_state = rtd2;
            end
            rtd2: begin // RTD
                setstackaddr = 1'b1;
                set[Regwrena] = 1'b1;
            end
            movec1: begin // MOVEC
                set[briefext] = 1'b1;
                set_writePCbig = 1'b1;
                if ((brief[11:0] == 12'h000 || brief[11:0] == 12'h001 || brief[11:0] == 12'h800 || brief[11:0] == 12'h801) ||
                    (CPU[1] == 1'b1 && (brief[11:0] == 12'h002 || brief[11:0] == 12'h802 || brief[11:0] == 12'h803 || brief[11:0] == 12'h804))) begin
                    if (opcode[0] == 1'b0) begin
                        set[Regwrena] = 1'b1;
                    end
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end
            movep1: begin // MOVEP d(An)
                setdisp = 1'b1;
                set[mem_addsub] = 1'b1;
                set[mem_byte] = 1'b1;
                set[OP1addr] = 1'b1;
                if (opcode[6] == 1'b1) begin
                    set[movepl] = 1'b1;
                end
                if (opcode[7] == 1'b0) begin
                    setstate = 2'b10;
                end else begin
                    setstate = 2'b11;
                end
                next_micro_state = movep2;
            end
            movep2: begin
                if (opcode[6] == 1'b1) begin
                    set[mem_addsub] = 1'b1;
                    set[OP1addr] = 1'b1;
                end
                if (opcode[7] == 1'b0) begin
                    setstate = 2'b10;
                end else begin
                    setstate = 2'b11;
                end
                next_micro_state = movep3;
            end
            movep3: begin
                if (opcode[6] == 1'b1) begin
                    set[mem_addsub] = 1'b1;
                    set[OP1addr] = 1'b1;
                    set[mem_byte] = 1'b1;
                    if (opcode[7] == 1'b0) begin
                        setstate = 2'b10;
                    end else begin
                        setstate = 2'b11;
                    end
                    next_micro_state = movep4;
                end else begin
                    datatype = 2'b01; // Word
                end
            end
            movep4: begin
                if (opcode[7] == 1'b0) begin
                    setstate = 2'b10;
                end else begin
                    setstate = 2'b11;
                end
                next_micro_state = movep5;
            end
            movep5: begin
                datatype = 2'b10; // Long
            end
            mul1: begin // mulu
                if (opcode[15] == 1'b1 || MUL_Mode == 0) begin
                    set_rot_cnt = 6'b001110;
                end else begin
                    set_rot_cnt = 6'b011110;
                end
                setstate = 2'b01;
                next_micro_state = mul2;
            end
            mul2: begin // mulu
                setstate = 2'b01;
                if (rot_cnt == 6'b00001) begin
                    next_micro_state = mul_end1;
                end else begin
                    next_micro_state = mul2;
                end
            end
            mul_end1: begin // mulu
                if (opcode[15] == 1'b0) begin
                    set[hold_OP2] = 1'b1;
                end
                datatype = 2'b10;
                set[opcMULU] = 1'b1;
                if (opcode[15] == 1'b0 && (MUL_Mode == 1 || MUL_Mode == 2)) begin
                    dest_2ndHbits = 1'b1;
                    set[write_lowlong] = 1'b1;
                    if (sndOPC[10] == 1'b1) begin
                        setstate = 2'b01;
                        next_micro_state = mul_end2;
                    end
                    set[Regwrena] = 1'b1;
                end
                datatype = 2'b10;
            end
            mul_end2: begin // divu
                dest_2ndLbits = 1'b1;
                set[write_reminder] = 1'b1;
                set[Regwrena] = 1'b1;
                set[opcMULU] = 1'b1;
            end
            div1: begin // divu
                setstate = 2'b01;
                next_micro_state = div2;
            end
            div2: begin // divu
                if ((OP2out[31:16] == 16'h0000 || opcode[15] == 1'b1 || DIV_Mode == 0) && OP2out[15:0] == 16'h0000) begin // div zero
                    set_Z_error = 1'b1;
                end else begin
                    next_micro_state = div3;
                end
                set[ld_rot_cnt] = 1'b1;
                setstate = 2'b01;
            end
            div3: begin // divu
                if (opcode[15] == 1'b1 || DIV_Mode == 0) begin
                    set_rot_cnt = 6'b001101;
                end else begin
                    set_rot_cnt = 6'b011101;
                end
                setstate = 2'b01;
                next_micro_state = div4;
            end
            div4: begin // divu
                setstate = 2'b01;
                if (rot_cnt == 6'b00001) begin
                    next_micro_state = div_end1;
                end else begin
                    next_micro_state = div4;
                end
            end
            div_end1: begin // divu
                if (Z_error == 1'b0 && set_V_Flag == 1'b0) begin
                    set[Regwrena] = 1'b1;
                end
                if (opcode[15] == 1'b0 && (DIV_Mode == 1 || DIV_Mode == 2)) begin
                    dest_2ndLbits = 1'b1;
                    set[write_reminder] = 1'b1;
                    next_micro_state = div_end2;
                    setstate = 2'b01;
                end
                set[opcDIVU] = 1'b1;
                datatype = 2'b10;
            end
            div_end2: begin // divu
                if (exec[Regwrena] == 1'b1) begin
                    set[Regwrena] = 1'b1;
                end else begin
                    set[no_Flags] = 1'b1;
                end
                dest_2ndHbits = 1'b1;
                set[opcDIVU] = 1'b1;
            end
            rota1: begin
                if (OP2out[5:0] != 6'b000000) begin
                    set_rot_cnt = OP2out[5:0];
                end else begin
                    set_exec[rot_nop] = 1'b1;
                end
            end
            bf1: begin
                setstate = 2'b10;
            end
            default: ;
        endcase

        // Final assignment to set_datatype
        set_datatype = datatype;
    end

    // MOVEC
    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            VBR <= 32'b0;
            CACR <= 4'b0;
        end else if (clkena_lw == 1'b1 && exec[movec_wr] == 1'b1) begin
            case (brief[11:0])
                12'h000: SFC <= reg_QA[2:0]; // SFC -- 68010+
                12'h001: DFC <= reg_QA[2:0]; // DFC -- 68010+
                12'h002: CACR <= reg_QA[3:0]; // 68020+
                12'h800: ; // USP -- 68010+
                12'h801: VBR <= reg_QA; // 68010+
                12'h802: ; // CAAR -- 68020+
                12'h803: ; // MSP -- 68020+
                12'h804: ; // isP -- 68020+
                default: ;
            endcase
        end
    end

    always_comb begin
        movec_data = 32'b0;
        case (brief[11:0])
            12'h000: movec_data = {29'b0, SFC};
            12'h001: movec_data = {29'b0, DFC};
            12'h002: movec_data = {28'b0, (CACR & 4'b0011)};
            12'h801: movec_data = VBR;
            default: ;
        endcase
    end

    assign CACR_out = CACR;
    assign VBR_out = VBR;

    // execute microcode
    always_ff @(posedge clk) begin
        if (Reset == 1'b1) begin
            micro_state <= ld_nn;
        end else if (clkena_lw == 1'b1) begin
            trapd <= trapmake;
            micro_state <= next_micro_state;
        end
    end

    // Conditions
    always_comb begin
        case (exe_opcode[11:8])
            4'h0: exe_condition = 1'b1;
            4'h1: exe_condition = 1'b0;
            4'h2: exe_condition = ~Flags[0] & ~Flags[2];
            4'h3: exe_condition = Flags[0] | Flags[2];
            4'h4: exe_condition = ~Flags[0];
            4'h5: exe_condition = Flags[0];
            4'h6: exe_condition = ~Flags[2];
            4'h7: exe_condition = Flags[2];
            4'h8: exe_condition = ~Flags[1];
            4'h9: exe_condition = Flags[1];
            4'ha: exe_condition = ~Flags[3];
            4'hb: exe_condition = Flags[3];
            4'hc: exe_condition = (Flags[3] & Flags[1]) | (~Flags[3] & ~Flags[1]);
            4'hd: exe_condition = (Flags[3] & ~Flags[1]) | (~Flags[3] & Flags[1]);
            4'he: exe_condition = (Flags[3] & Flags[1] & ~Flags[2]) | (~Flags[3] & ~Flags[1] & ~Flags[2]);
            4'hf: exe_condition = (Flags[3] & ~Flags[1]) | (~Flags[3] & Flags[1]) | Flags[2];
            default: exe_condition = 1'b0;
        endcase
    end

    // Movem
    always_ff @(posedge clk) begin
        if (clkena_lw == 1'b1) begin
            movem_actiond <= exec[movem_action];
            if (decodeOPC == 1'b1) begin
                sndOPC <= data_read[15:0];
            end else if (exec[movem_action] == 1'b1 || set[movem_action] == 1'b1) begin
                case (movem_regaddr)
                    4'b0000: sndOPC[0] <= 1'b0;
                    4'b0001: sndOPC[1] <= 1'b0;
                    4'b0010: sndOPC[2] <= 1'b0;
                    4'b0011: sndOPC[3] <= 1'b0;
                    4'b0100: sndOPC[4] <= 1'b0;
                    4'b0101: sndOPC[5] <= 1'b0;
                    4'b0110: sndOPC[6] <= 1'b0;
                    4'b0111: sndOPC[7] <= 1'b0;
                    4'b1000: sndOPC[8] <= 1'b0;
                    4'b1001: sndOPC[9] <= 1'b0;
                    4'b1010: sndOPC[10] <= 1'b0;
                    4'b1011: sndOPC[11] <= 1'b0;
                    4'b1100: sndOPC[12] <= 1'b0;
                    4'b1101: sndOPC[13] <= 1'b0;
                    4'b1110: sndOPC[14] <= 1'b0;
                    4'b1111: sndOPC[15] <= 1'b0;
                endcase
            end
        end
    end

    always_comb begin
        movem_regaddr = 4'b0000;
        movem_run = 1'b1;
        if (sndOPC[3:0] == 4'b0000) begin
            if (sndOPC[7:4] == 4'b0000) begin
                movem_regaddr[3] = 1'b1;
                if (sndOPC[11:8] == 4'b0000) begin
                    if (sndOPC[15:12] == 4'b0000) begin
                        movem_run = 1'b0;
                    end
                    movem_regaddr[2] = 1'b1;
                    movem_mux = sndOPC[15:12];
                end else begin
                    movem_mux = sndOPC[11:8];
                end
            end else begin
                movem_mux = sndOPC[7:4];
                movem_regaddr[2] = 1'b1;
            end
        end else begin
            movem_mux = sndOPC[3:0];
        end

        if (movem_mux[1:0] == 2'b00) begin
            movem_regaddr[1] = 1'b1;
            if (movem_mux[2] == 1'b0) begin
                movem_regaddr[0] = 1'b1;
            end
        end else begin
            if (movem_mux[0] == 1'b0) begin
                movem_regaddr[0] = 1'b1;
            end
        end
    end

endmodule
