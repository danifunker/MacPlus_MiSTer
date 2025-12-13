//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
// Copyright (c) 2009-2020 Tobias Gubener
// Patches by MikeJ, Till Harbaum, Rok Krajnk, ...
// Subdesign fAMpIGA by TobiFlex
// VHDL to Verilog conversion
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

module TG68KdotC_Kernel #(
    parameter SR_Read        = 2,    // 0=>user, 1=>privileged, 2=>switchable with CPU(0)
    parameter VBR_Stackframe = 2,    // 0=>no, 1=>yes/extended, 2=>switchable with CPU(0)
    parameter extAddr_Mode   = 2,    // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter MUL_Mode       = 2,    // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no MUL
    parameter DIV_Mode       = 2,    // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no DIV
    parameter BitField       = 2,    // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter BarrelShifter  = 1,    // 0=>no, 1=>yes, 2=>switchable with CPU(1)
    parameter MUL_Hardware   = 1     // 0=>no, 1=>yes
)(
    input             clk,
    input             nReset,
    input             clkena_in,
    input      [15:0] data_in,
    input       [2:0] IPL,
    input             IPL_autovector,
    input             berr,
    input       [1:0] CPU,
    output reg [31:0] addr_out,
    output reg [15:0] data_write,
    output            nWr,
    output            nUDS,
    output            nLDS,
    output      [1:0] busstate,
    output            longword,
    output            nResetOut,
    output reg  [2:0] FC,
    output            clr_berr,
    // for debug
    output            skipFetch,
    output     [31:0] regin_out,
    output      [3:0] CACR_out,
    output     [31:0] VBR_out
);

`include "TG68K_Pack.vh"

//-----------------------------------------------------------------------------
// Internal signals
//-----------------------------------------------------------------------------
reg         use_VBR_Stackframe;
reg   [3:0] syncReset;
reg         Reset;
wire        clkena_lw;
reg  [31:0] TG68_PC;
reg  [31:0] tmp_TG68_PC;
reg  [31:0] TG68_PC_add;
reg  [31:0] PC_dataa;
reg  [31:0] PC_datab;
reg  [31:0] memaddr;
reg   [1:0] state;
reg   [1:0] datatype;
reg   [1:0] set_datatype;
reg   [1:0] exe_datatype;
reg   [1:0] setstate;
reg         setaddrvalue;
reg         addrvalue;

reg  [15:0] opcode;
reg  [15:0] exe_opcode;
reg  [15:0] sndOPC;

reg  [31:0] exe_pc;
reg  [31:0] last_opc_pc;
reg  [15:0] last_opc_read;
reg  [31:0] registerin;
reg  [31:0] reg_QA;
reg  [31:0] reg_QB;
reg         Wwrena, Lwrena;
reg         Bwrena;
reg         Regwrena_now;
reg   [3:0] rf_dest_addr;
reg   [3:0] rf_source_addr;
reg   [3:0] rf_source_addrd;

reg  [31:0] regin;
reg  [31:0] regfile [0:15];
integer     RDindex_A;
integer     RDindex_B;
reg         WR_AReg;

reg  [31:0] addr;
reg  [31:0] memaddr_reg;
reg  [31:0] memaddr_delta;
reg  [31:0] memaddr_delta_rega;
reg  [31:0] memaddr_delta_regb;
reg         use_base;

reg  [31:0] ea_data;
reg  [31:0] OP1out;
reg  [31:0] OP2out;
reg  [15:0] OP1outbrief;
wire [31:0] OP1in;
wire [31:0] ALUout;
reg  [31:0] data_write_tmp;
reg  [31:0] data_write_muxin;
reg  [47:0] data_write_mux;
reg         nextpass;
reg         setnextpass;
reg         setdispbyte;
reg         setdisp;
reg         regdirectsource;
wire [31:0] addsub_q;
reg  [31:0] briefdata;
wire  [2:0] c_out;

reg  [31:0] mem_address;
reg  [31:0] memaddr_a;

reg         TG68_PC_brw;
reg         TG68_PC_word;
reg         getbrief;
reg  [15:0] brief;
reg         data_is_source;
reg         store_in_tmp;
reg         write_back;
reg         exec_write_back;
reg         setstackaddr;
reg         writePC;
reg         writePCbig;
reg         set_writePCbig;
reg         writePCnext;
reg         setopcode;
reg         decodeOPC;
reg         execOPC;
wire        execOPC_ALU;
reg         setexecOPC;
reg         endOPC;
reg         setendOPC;
wire  [7:0] Flags;
reg   [7:0] FlagsSR;
reg   [7:0] SRin;
reg         exec_DIRECT;
reg         exec_tas;
reg         set_exec_tas;

reg         exe_condition;
reg         ea_only;
reg         source_areg;
reg         source_lowbits;
reg         source_LDRLbits;
reg         source_LDRMbits;
reg         source_2ndHbits;
reg         source_2ndMbits;
reg         source_2ndLbits;
reg         dest_areg;
reg         dest_LDRareg;
reg         dest_LDRHbits;
reg         dest_LDRLbits;
reg         dest_2ndHbits;
reg         dest_2ndLbits;
reg         dest_hbits;
reg   [1:0] rot_bits;
reg   [1:0] set_rot_bits;
reg   [5:0] rot_cnt;
reg   [5:0] set_rot_cnt;
reg         movem_actiond;
reg   [3:0] movem_regaddr;
reg   [3:0] movem_mux;
reg         movem_presub;
reg         movem_run;
reg  [31:0] ea_calc_b;
reg         set_direct_data;
reg         use_direct_data;
reg         direct_data;

wire        set_V_Flag;
reg         set_vectoraddr;
reg         writeSR;
reg         trap_berr;
reg         trap_illegal;
reg         trap_addr_error;
reg         trap_priv;
reg         trap_trace;
reg         trap_1010;
reg         trap_1111;
reg         trap_trap;
reg         trap_trapv;
reg         trap_interrupt;
reg         trapmake;
reg         trapd;
reg   [7:0] trap_SR;
reg         make_trace;
reg         make_berr;
reg         useStackframe2;

reg         set_stop;
reg         stop;
reg  [31:0] trap_vector;
reg  [31:0] trap_vector_vbr;
reg  [31:0] USP;

reg   [2:0] IPL_nr;
reg   [2:0] rIPL_nr;
reg   [7:0] IPL_vec;
reg         interrupt;
reg         setinterrupt;
reg         SVmode;
reg         preSVmode;
reg         Suppress_Base;
reg         set_Suppress_Base;
reg         set_Z_error;
reg         Z_error;
reg         ea_build_now;
reg         build_logical;
reg         build_bcd;

reg  [31:0] data_read;
reg   [7:0] bf_ext_in;
wire  [7:0] bf_ext_out;
reg         long_start;
wire        long_start_alu;
reg         non_aligned;
reg         check_aligned;
reg         long_done;
reg   [5:0] memmask;
reg   [5:0] set_memmask;
reg   [3:0] memread;
reg   [5:0] wbmemmask;
reg   [5:0] memmaskmux;
reg         oddout;
reg         set_oddout;
reg         PCbase;
reg         set_PCbase;

reg  [31:0] last_data_read;
reg  [31:0] last_data_in;

reg   [5:0] bf_offset;
reg   [5:0] bf_width;
reg   [5:0] bf_bhits;
reg   [5:0] bf_shift;
reg   [5:0] alu_width;
reg   [5:0] alu_bf_shift;
reg   [5:0] bf_loffset;
reg  [31:0] bf_full_offset;
reg  [31:0] alu_bf_ffo_offset;
reg   [5:0] alu_bf_loffset;

reg  [31:0] movec_data;
reg  [31:0] VBR;
reg   [3:0] CACR;
reg   [2:0] DFC;
reg   [2:0] SFC;

reg  [88:0] set;
reg  [88:0] set_exec;
reg  [88:0] exec;

reg   [6:0] micro_state;
reg   [6:0] next_micro_state;

// Instantiate ALU
TG68K_ALU #(
    .MUL_Mode(MUL_Mode),
    .MUL_Hardware(MUL_Hardware),
    .DIV_Mode(DIV_Mode),
    .BarrelShifter(BarrelShifter)
) ALU (
    .clk(clk),
    .Reset(Reset),
    .clkena_lw(clkena_lw),
    .CPU(CPU),
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

assign OP1in = ALUout;

// AMR - let the parent module know this is a longword access
assign longword = ~memmaskmux[3];

assign long_start_alu = ~memmask[1];
assign execOPC_ALU = execOPC | exec[alu_exec];

always @(*) begin
    non_aligned = 1'b0;
    if (memmaskmux[5:4] == 2'b01 || memmaskmux[5:4] == 2'b10)
        non_aligned = 1'b1;
end

//-----------------------------------------------------------------------------
// Bus control
//-----------------------------------------------------------------------------
assign regin_out = regin;

assign nWr = (state == 2'b11) ? 1'b0 : 1'b1;
assign busstate = state;
assign nResetOut = exec[opcRESET] ? 1'b0 : 1'b1;

// does shift for byte access. note active low me
// should produce address error on 68000
always @(*) begin
    if (addr[0])
        memmaskmux = memmask;
    else
        memmaskmux = {memmask[4:0], 1'b1};
end

assign nUDS = memmaskmux[5];
assign nLDS = memmaskmux[4];
assign clkena_lw = (clkena_in && memmaskmux[3]) ? 1'b1 : 1'b0;
assign clr_berr = (setopcode && trap_berr) ? 1'b1 : 1'b0;

// Reset synchronizer
always @(posedge clk or negedge nReset) begin
    if (!nReset) begin
        syncReset <= 4'b0000;
        Reset <= 1'b1;
    end else begin
        if (clkena_in) begin
            syncReset <= {syncReset[2:0], 1'b1};
            Reset <= ~syncReset[3];
        end
    end
end

always @(posedge clk) begin
    if (VBR_Stackframe == 1 || (CPU[0] && VBR_Stackframe == 2))
        use_VBR_Stackframe <= 1'b1;
    else
        use_VBR_Stackframe <= 1'b0;
end

// Data read logic
always @(*) begin
    if (!memmaskmux[4])
        data_read = {last_data_in[15:0], data_in};
    else
        data_read = {last_data_in[23:0], data_in[15:8]};

    if (memread[0] || (memread[1:0] == 2'b10 && memmaskmux[4]))
        data_read[31:16] = {16{data_read[15]}};
end

always @(posedge clk) begin
    if (clkena_lw && state == 2'b10) begin
        if (!memmaskmux[4])
            bf_ext_in <= last_data_in[23:16];
        else
            bf_ext_in <= last_data_in[31:24];
    end

    if (Reset)
        last_data_read <= 32'b0;
    else if (clkena_in) begin
        if (state == 2'b00 || exec[update_ld]) begin
            last_data_read <= data_read;
            if (!state[1] && !memmask[1])
                last_data_read[31:16] <= last_opc_read;
            else if (!state[1] || memread[1])
                last_data_read[31:16] <= {16{data_in[15]}};
        end
        last_data_in <= {last_data_in[15:0], data_in};
    end

    long_start <= ~memmask[1];
    long_done <= ~memread[1];
end

// Data write logic
always @(*) begin
    if (exec[write_reg])
        data_write_muxin = reg_QB;
    else
        data_write_muxin = data_write_tmp;

    if (BitField == 0) begin
        if (oddout == addr[0])
            data_write_mux = {8'bx, 8'bx, data_write_muxin};
        else
            data_write_mux = {8'bx, data_write_muxin, 8'bx};
    end else begin
        if (oddout == addr[0])
            data_write_mux = {8'bx, bf_ext_out, data_write_muxin};
        else
            data_write_mux = {bf_ext_out, data_write_muxin, 8'bx};
    end

    if (!memmaskmux[1])
        data_write = data_write_mux[47:32];
    else if (!memmaskmux[3])
        data_write = data_write_mux[31:16];
    else begin
        // a single byte shows up on both bus halves
        if (memmaskmux[5:4] == 2'b10)
            data_write = {data_write_mux[7:0], data_write_mux[7:0]};
        else if (memmaskmux[5:4] == 2'b01)
            data_write = {data_write_mux[15:8], data_write_mux[15:8]};
        else
            data_write = data_write_mux[15:0];
    end

    if (exec[mem_byte])  // movep
        data_write = {data_write_tmp[15:8], data_write_tmp[15:8]};
end

//-----------------------------------------------------------------------------
// Register file
//-----------------------------------------------------------------------------
always @(*) begin
    reg_QA = regfile[RDindex_A];
    reg_QB = regfile[RDindex_B];
end

always @(posedge clk) begin
    if (clkena_lw) begin
        rf_source_addrd <= rf_source_addr;
        WR_AReg <= rf_dest_addr[3];
        RDindex_A <= rf_dest_addr;
        RDindex_B <= rf_source_addr;
        if (Wwrena)
            regfile[RDindex_A] <= regin;
        if (exec[to_USP])
            USP <= reg_QA;
    end
end

//-----------------------------------------------------------------------------
// Write Reg
//-----------------------------------------------------------------------------
always @(*) begin
    regin = ALUout;
    if (exec[save_memaddr])
        regin = memaddr;
    else if (exec[get_ea_now] && ea_only)
        regin = memaddr_a;
    else if (exec[from_USP])
        regin = USP;
    else if (exec[movec_rd])
        regin = movec_data;

    if (Bwrena)
        regin[15:8] = reg_QA[15:8];
    if (!Lwrena)
        regin[31:16] = reg_QA[31:16];

    Bwrena = 1'b0;
    Wwrena = 1'b0;
    Lwrena = 1'b0;
    if (exec[presub] || exec[postadd] || exec[changeMode]) begin
        Wwrena = 1'b1;
        Lwrena = 1'b1;
    end else if (Regwrena_now)
        Wwrena = 1'b1;
    else if (exec[Regwrena]) begin
        Wwrena = 1'b1;
        case (exe_datatype)
            2'b00: Bwrena = 1'b1;  // BYTE
            2'b01: begin  // WORD
                if (WR_AReg || movem_actiond)
                    Lwrena = 1'b1;
            end
            default: Lwrena = 1'b1;  // LONG
        endcase
    end
end

//-----------------------------------------------------------------------------
// Set dest regaddr
//-----------------------------------------------------------------------------
always @(*) begin
    if (exec[movem_action])
        rf_dest_addr = rf_source_addrd;
    else if (set[briefext])
        rf_dest_addr = brief[15:12];
    else if (set[get_bfoffset])
        rf_dest_addr = {1'b0, sndOPC[8:6]};
    else if (dest_2ndHbits)
        rf_dest_addr = {dest_LDRareg, sndOPC[14:12]};
    else if (dest_LDRHbits)
        rf_dest_addr = last_data_read[15:12];
    else if (dest_LDRLbits)
        rf_dest_addr = {1'b0, last_data_read[2:0]};
    else if (dest_2ndLbits)
        rf_dest_addr = {1'b0, sndOPC[2:0]};
    else if (setstackaddr)
        rf_dest_addr = 4'b1111;
    else if (dest_hbits)
        rf_dest_addr = {dest_areg, opcode[11:9]};
    else begin
        if (opcode[5:3] == 3'b000 || data_is_source)
            rf_dest_addr = {dest_areg, opcode[2:0]};
        else
            rf_dest_addr = {1'b1, opcode[2:0]};
    end
end

//-----------------------------------------------------------------------------
// Set source regaddr
//-----------------------------------------------------------------------------
always @(*) begin
    if (exec[movem_action] || set[movem_action]) begin
        if (movem_presub)
            rf_source_addr = movem_regaddr ^ 4'b1111;
        else
            rf_source_addr = movem_regaddr;
    end else if (source_2ndLbits)
        rf_source_addr = {1'b0, sndOPC[2:0]};
    else if (source_2ndHbits)
        rf_source_addr = {1'b0, sndOPC[14:12]};
    else if (source_2ndMbits)
        rf_source_addr = {1'b0, sndOPC[8:6]};
    else if (source_LDRLbits)
        rf_source_addr = {1'b0, last_data_read[2:0]};
    else if (source_LDRMbits)
        rf_source_addr = {1'b0, last_data_read[8:6]};
    else if (source_lowbits)
        rf_source_addr = {source_areg, opcode[2:0]};
    else if (exec[linksp])
        rf_source_addr = 4'b1111;
    else
        rf_source_addr = {source_areg, opcode[11:9]};
end

//-----------------------------------------------------------------------------
// Set OP1out
//-----------------------------------------------------------------------------
always @(*) begin
    OP1out = reg_QA;
    if (exec[OP1out_zero])
        OP1out = 32'b0;
    else if (exec[ea_data_OP1] && store_in_tmp)
        OP1out = ea_data;
    else if (exec[movem_action] || !memmaskmux[3] || exec[OP1addr])
        OP1out = addr;
end

//-----------------------------------------------------------------------------
// Set OP2out
//-----------------------------------------------------------------------------
always @(*) begin
    OP2out[15:0] = reg_QB[15:0];
    OP2out[31:16] = {16{OP2out[15]}};

    if (exec[OP2out_one])
        OP2out[15:0] = 16'hFFFF;
    else if (use_direct_data || (exec[exg] && execOPC) || exec[get_bfoffset])
        OP2out = data_write_tmp;
    else if ((!exec[ea_data_OP1] && store_in_tmp) || exec[ea_data_OP2])
        OP2out = ea_data;
    else if (exec[opcMOVEQ]) begin
        OP2out[7:0] = exe_opcode[7:0];
        OP2out[15:8] = {8{exe_opcode[7]}};
    end else if (exec[opcADDQ]) begin
        OP2out[2:0] = exe_opcode[11:9];
        if (exe_opcode[11:9] == 3'b000)
            OP2out[3] = 1'b1;
        else
            OP2out[3] = 1'b0;
        OP2out[15:4] = 12'b0;
    end else if (exe_datatype == 2'b10 && !exec[opcEXT])
        OP2out[31:16] = reg_QB[31:16];

    if (exec[opcEXTB])
        OP2out[31:8] = {24{OP2out[7]}};
end

//-----------------------------------------------------------------------------
// Handle EA_data, data_write
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (Reset) begin
        store_in_tmp <= 1'b0;
        direct_data <= 1'b0;
        use_direct_data <= 1'b0;
        Z_error <= 1'b0;
        writePCnext <= 1'b0;
    end else if (clkena_lw) begin
        useStackframe2 <= 1'b0;
        direct_data <= 1'b0;

        if (exec[hold_OP2])
            use_direct_data <= 1'b1;

        if (set_direct_data) begin
            direct_data <= 1'b1;
            use_direct_data <= 1'b1;
        end else if (endOPC || set[ea_data_OP2])
            use_direct_data <= 1'b0;

        exec_DIRECT <= set_exec[opcMOVE];

        if (endOPC) begin
            store_in_tmp <= 1'b0;
            Z_error <= 1'b0;
            writePCnext <= 1'b0;
        end else begin
            if (set_Z_error)
                Z_error <= 1'b1;
            if (set_exec[opcMOVE] && state == 2'b11)
                use_direct_data <= 1'b1;
            if (state == 2'b10 || exec[store_ea_packdata])
                store_in_tmp <= 1'b1;
            if (direct_data && state == 2'b00)
                store_in_tmp <= 1'b1;
        end

        if (state == 2'b10 && !exec[hold_ea_data])
            ea_data <= data_read;
        else if (exec[get_2ndOPC])
            ea_data <= addr;
        else if (exec[store_ea_data] || (direct_data && state == 2'b00))
            ea_data <= last_data_read;

        if (writePC)
            data_write_tmp <= TG68_PC;
        else if (exec[writePC_add])
            data_write_tmp <= TG68_PC_add;
        else if (micro_state == trap00) begin
            data_write_tmp <= exe_pc;
            useStackframe2 <= 1'b1;
            writePCnext <= trap_trap | trap_trapv | exec[trap_chk] | Z_error;
        end else if (micro_state == trap0) begin
            if (useStackframe2)
                data_write_tmp[15:0] <= {4'b0010, trap_vector[11:0]};
            else begin
                data_write_tmp[15:0] <= {4'b0000, trap_vector[11:0]};
                writePCnext <= trap_trap | trap_trapv | exec[trap_chk] | Z_error;
            end
        end else if (exec[hold_dwr])
            data_write_tmp <= data_write_tmp;
        else if (exec[exg])
            data_write_tmp <= OP1out;
        else if (exec[get_ea_now] && ea_only)
            data_write_tmp <= addr;
        else if (execOPC)
            data_write_tmp <= ALUout;
        else if (exec_DIRECT && state == 2'b10) begin
            data_write_tmp <= data_read;
            if (exec[movepl])
                data_write_tmp[31:8] <= data_write_tmp[23:0];
        end else if (exec[movepl])
            data_write_tmp[15:0] <= reg_QB[31:16];
        else if (direct_data)
            data_write_tmp <= last_data_read;
        else if (writeSR)
            data_write_tmp[15:0] <= {trap_SR[7:0], Flags[7:0]};
        else
            data_write_tmp <= OP2out;
    end
end

//-----------------------------------------------------------------------------
// Brief
//-----------------------------------------------------------------------------
always @(*) begin
    if (brief[11])
        OP1outbrief = OP1out[31:16];
    else
        OP1outbrief = {16{OP1out[15]}};

    briefdata = {OP1outbrief, OP1out[15:0]};

    if (extAddr_Mode == 1 || (CPU[1] && extAddr_Mode == 2)) begin
        case (brief[10:9])
            2'b00: briefdata = {OP1outbrief, OP1out[15:0]};
            2'b01: briefdata = {OP1outbrief[14:0], OP1out[15:0], 1'b0};
            2'b10: briefdata = {OP1outbrief[13:0], OP1out[15:0], 2'b00};
            2'b11: briefdata = {OP1outbrief[12:0], OP1out[15:0], 3'b000};
        endcase
    end
end

//-----------------------------------------------------------------------------
// MEM_IO - Address generation and trap vectors
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (clkena_lw) begin
        trap_vector[31:10] <= 22'b0;
        if (trap_berr)
            trap_vector[9:0] <= 10'h008;
        if (trap_addr_error)
            trap_vector[9:0] <= 10'h00C;
        if (trap_illegal)
            trap_vector[9:0] <= 10'h010;
        if (set_Z_error)
            trap_vector[9:0] <= 10'h014;
        if (exec[trap_chk])
            trap_vector[9:0] <= 10'h018;
        if (trap_trapv)
            trap_vector[9:0] <= 10'h01C;
        if (trap_priv)
            trap_vector[9:0] <= 10'h020;
        if (trap_trace)
            trap_vector[9:0] <= 10'h024;
        if (trap_1010)
            trap_vector[9:0] <= 10'h028;
        if (trap_1111)
            trap_vector[9:0] <= 10'h02C;
        if (trap_trap)
            trap_vector[9:0] <= {4'b0010, opcode[3:0], 2'b00};
        if (trap_interrupt || set_vectoraddr)
            trap_vector[9:0] <= {IPL_vec, 2'b00};
    end
end

always @(*) begin
    if (use_VBR_Stackframe)
        trap_vector_vbr = trap_vector + VBR;
    else
        trap_vector_vbr = trap_vector;
end

always @(*) begin
    memaddr_a[4:0] = 5'b00000;
    memaddr_a[7:5] = {3{memaddr_a[4]}};
    memaddr_a[15:8] = {8{memaddr_a[7]}};
    memaddr_a[31:16] = {16{memaddr_a[15]}};

    if (setdisp) begin
        if (exec[briefext])
            memaddr_a = briefdata + memaddr_delta;
        else if (setdispbyte)
            memaddr_a[7:0] = last_data_read[7:0];
        else
            memaddr_a = last_data_read;
    end else if (set[presub]) begin
        if (set[longaktion])
            memaddr_a[4:0] = 5'b11100;
        else if (datatype == 2'b00 && !set[use_SP])
            memaddr_a[4:0] = 5'b11111;
        else
            memaddr_a[4:0] = 5'b11110;
    end else if (interrupt)
        memaddr_a[4:0] = {1'b1, rIPL_nr, 1'b0};
end

always @(posedge clk) begin
    if (clkena_in) begin
        if (exec[get_2ndOPC] || (state == 2'b10 && memread[0]))
            tmp_TG68_PC <= addr;

        use_base <= 1'b0;
        memaddr_delta_regb <= 32'b0;

        if (!memmaskmux[3] || exec[mem_addsub])
            memaddr_delta_rega <= addsub_q;
        else if (set[restore_ADDR])
            memaddr_delta_rega <= tmp_TG68_PC;
        else if (exec[direct_delta])
            memaddr_delta_rega <= data_read;
        else if (exec[ea_to_pc] && setstate == 2'b00)
            memaddr_delta_rega <= addr;
        else if (set[addrlong])
            memaddr_delta_rega <= last_data_read;
        else if (setstate == 2'b00)
            memaddr_delta_rega <= TG68_PC_add;
        else if (exec[dispouter]) begin
            memaddr_delta_rega <= ea_data;
            memaddr_delta_regb <= memaddr_a;
        end else if (set_vectoraddr)
            memaddr_delta_rega <= trap_vector_vbr;
        else begin
            memaddr_delta_rega <= memaddr_a;
            if (!interrupt && !Suppress_Base)
                use_base <= 1'b1;
        end

        // only used for movem address update
        if ((memread[0] && state[1]) || !movem_presub)
            memaddr <= addr;
    end
end

always @(*) begin
    memaddr_delta = memaddr_delta_rega + memaddr_delta_regb;
    addr = memaddr_reg + memaddr_delta;
    addr_out = memaddr_reg + memaddr_delta;

    if (!use_base)
        memaddr_reg = 32'b0;
    else
        memaddr_reg = reg_QA;
end

//-----------------------------------------------------------------------------
// PC Calc + fetch opcode
//-----------------------------------------------------------------------------
always @(*) begin
    PC_dataa = TG68_PC;
    if (TG68_PC_brw)
        PC_dataa = tmp_TG68_PC;

    PC_datab[2:0] = 3'b0;
    PC_datab[3] = PC_datab[2];
    PC_datab[7:4] = {4{PC_datab[3]}};
    PC_datab[15:8] = {8{PC_datab[7]}};
    PC_datab[31:16] = {16{PC_datab[15]}};

    if (interrupt)
        PC_datab[2:1] = 2'b11;

    if (exec[writePC_add]) begin
        if (writePCbig) begin
            PC_datab[3] = 1'b1;
            PC_datab[1] = 1'b1;
        end else
            PC_datab[2] = 1'b1;
        if ((!use_VBR_Stackframe && (trap_trap || trap_trapv || exec[trap_chk] || Z_error)) || writePCnext)
            PC_datab[1] = 1'b1;
    end else if (state == 2'b00)
        PC_datab[1] = 1'b1;

    if (TG68_PC_brw) begin
        if (TG68_PC_word)
            PC_datab = last_data_read;
        else
            PC_datab[7:0] = opcode[7:0];
    end

    TG68_PC_add = PC_dataa + PC_datab;

    setopcode = 1'b0;
    setendOPC = 1'b0;
    setinterrupt = 1'b0;
    if (setstate == 2'b00 && next_micro_state == idle && !setnextpass &&
        (!exec_write_back || state == 2'b11) && set_rot_cnt == 6'b000001 && !set_exec[opcCHK]) begin
        setendOPC = 1'b1;
        if (FlagsSR[2:0] < IPL_nr || IPL_nr == 3'b111 || make_trace || make_berr)
            setinterrupt = 1'b1;
        else if (!stop)
            setopcode = 1'b1;
    end

    setexecOPC = 1'b0;
    if (setstate == 2'b00 && next_micro_state == idle && !set_direct_data &&
        (!exec_write_back || (state == 2'b10 && !addrvalue)))
        setexecOPC = 1'b1;

    IPL_nr = ~IPL;
end

// skipFetch logic
reg skipFetch_r;
assign skipFetch = skipFetch_r;

// Main state machine
always @(posedge clk) begin
    if (Reset) begin
        state <= 2'b01;
        addrvalue <= 1'b0;
        opcode <= 16'h2E79;  // move $0,a7
        trap_interrupt <= 1'b0;
        interrupt <= 1'b0;
        last_opc_read <= 16'h4EF9;  // jmp nn.l
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
        if (clkena_in) begin
            memmask <= {memmask[3:0], 2'b11};
            memread <= {memread[1:0], memmaskmux[5:4]};

            if (exec[directPC])
                TG68_PC <= data_read;
            else if (exec[ea_to_pc])
                TG68_PC <= addr;
            else if ((state == 2'b00 || TG68_PC_brw) && !stop)
                TG68_PC <= TG68_PC_add;
        end

        if (clkena_lw) begin
            interrupt <= setinterrupt;
            decodeOPC <= setopcode;
            endOPC <= setendOPC;
            execOPC <= setexecOPC;

            exe_datatype <= set_datatype;
            exe_opcode <= opcode;

            if (!trap_berr)
                make_berr <= berr | make_berr;
            else
                make_berr <= 1'b0;

            stop <= set_stop | (stop & ~setinterrupt);

            if (setinterrupt) begin
                trap_interrupt <= 1'b0;
                trap_trace <= 1'b0;
                make_berr <= 1'b0;
                trap_berr <= 1'b0;
                if (make_trace)
                    trap_trace <= 1'b1;
                else if (make_berr)
                    trap_berr <= 1'b1;
                else begin
                    rIPL_nr <= IPL_nr;
                    IPL_vec <= {5'b00011, IPL_nr};
                    trap_interrupt <= 1'b1;
                end
            end

            if (micro_state == trap0 && !IPL_autovector)
                IPL_vec <= last_data_read[7:0];

            if (state == 2'b00) begin
                last_opc_read <= data_read[15:0];
                last_opc_pc <= TG68_PC;
            end

            if (setopcode) begin
                trap_interrupt <= 1'b0;
                trap_trace <= 1'b0;
                TG68_PC_word <= 1'b0;
                trap_berr <= 1'b0;
            end else if (opcode[7:0] == 8'h00 || opcode[7:0] == 8'hFF || data_is_source)
                TG68_PC_word <= 1'b1;

            if (exec[get_bfoffset]) begin
                alu_width <= bf_width;
                alu_bf_shift <= bf_shift;
                alu_bf_loffset <= bf_loffset;
                alu_bf_ffo_offset <= bf_full_offset + bf_width + 1;
            end

            memread <= 4'b1111;
            FC[1] <= ~setstate[1] | (PCbase & ~setstate[0]);
            FC[0] <= setstate[1] & (~PCbase | setstate[0]);
            if (interrupt)
                FC[1:0] <= 2'b11;

            if (state == 2'b11)
                exec_write_back <= 1'b0;
            else if (setstate == 2'b10 && !setaddrvalue && write_back)
                exec_write_back <= 1'b1;

            if ((state == 2'b10 && !addrvalue && write_back && setstate != 2'b10) ||
                set_rot_cnt != 6'b000001 || (stop && !interrupt) || set_exec[opcCHK]) begin
                state <= 2'b01;
                memmask <= 6'b111111;
                addrvalue <= 1'b0;
            end else if (execOPC && exec_write_back) begin
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
                end else if (exec[get_bfoffset]) begin
                    memmask <= set_memmask;
                    wbmemmask <= set_memmask;
                    oddout <= set_oddout;
                end else if (set[longaktion]) begin
                    memmask <= 6'b100001;
                    wbmemmask <= 6'b100001;
                    oddout <= 1'b0;
                end else if (set_datatype == 2'b00 && setstate[1]) begin
                    memmask <= 6'b101111;
                    wbmemmask <= 6'b101111;
                    if (set[mem_byte])
                        oddout <= 1'b0;
                    else
                        oddout <= 1'b1;
                end else begin
                    memmask <= 6'b100111;
                    wbmemmask <= 6'b100111;
                    oddout <= 1'b0;
                end
            end

            if (decodeOPC) begin
                rot_bits <= set_rot_bits;
                writePCbig <= 1'b0;
            end else
                writePCbig <= set_writePCbig | writePCbig;

            if (decodeOPC || exec[ld_rot_cnt] || rot_cnt != 6'b000001)
                rot_cnt <= set_rot_cnt;

            if (set_Suppress_Base)
                Suppress_Base <= 1'b1;
            else if (setstate[1] || (ea_only && set[get_ea_now]))
                Suppress_Base <= 1'b0;

            if (getbrief) begin
                if (state[1])
                    brief <= last_opc_read[15:0];
                else
                    brief <= data_read[15:0];
            end

            if (setopcode && !berr) begin
                if (state == 2'b00) begin
                    opcode <= data_read[15:0];
                    exe_pc <= TG68_PC;
                end else begin
                    opcode <= last_opc_read[15:0];
                    exe_pc <= last_opc_pc;
                end
                nextpass <= 1'b0;
            end else if (setinterrupt || setopcode) begin
                opcode <= 16'h4E71;  // nop
                nextpass <= 1'b0;
            end else begin
                if (setnextpass || regdirectsource)
                    nextpass <= 1'b1;
            end

            if (decodeOPC || interrupt)
                trap_SR <= FlagsSR;
        end
    end
end

// PCbase logic
always @(posedge clk) begin
    if (Reset)
        PCbase <= 1'b1;
    else if (clkena_lw) begin
        PCbase <= set_PCbase | PCbase;
        if (setexecOPC || (state[1] && !movem_run))
            PCbase <= 1'b0;
    end
end

// exec logic
always @(posedge clk) begin
    if (clkena_lw) begin
        exec <= set;
        exec[alu_move] <= set[opcMOVE] | set[alu_move];
        exec[alu_setFlags] <= set[opcADD] | set[alu_setFlags];
        exec_tas <= 1'b0;
        exec[subidx] <= set[presub] | set[subidx];
        if (setexecOPC) begin
            exec <= set_exec | set;
            exec[alu_move] <= set_exec[opcMOVE] | set[opcMOVE] | set[alu_move];
            exec[alu_setFlags] <= set_exec[opcADD] | set[opcADD] | set[alu_setFlags];
            exec_tas <= set_exec_tas;
        end
        exec[get_2ndOPC] <= set[get_2ndOPC] | setopcode;
    end
end

//-----------------------------------------------------------------------------
// Bitfield Parameters
//-----------------------------------------------------------------------------
always @(*) begin
    if (sndOPC[11])
        bf_offset = {1'b0, reg_QA[4:0]};
    else
        bf_offset = {1'b0, sndOPC[10:6]};

    if (sndOPC[11])
        bf_full_offset = reg_QA;
    else begin
        bf_full_offset = 32'b0;
        bf_full_offset[4:0] = sndOPC[10:6];
    end

    bf_width[5] = 1'b0;
    if (sndOPC[5])
        bf_width[4:0] = reg_QB[4:0] - 1;
    else
        bf_width[4:0] = sndOPC[4:0] - 1;

    bf_bhits = bf_width + bf_offset;
    set_oddout = ~bf_bhits[3];

    // bf_loffset is used for the shifted_bitmask
    if (opcode[10:8] == 3'b111)  // INS
        bf_loffset = 32 - bf_shift;
    else
        bf_loffset = bf_shift;
    bf_loffset[5] = 1'b0;

    if (opcode[4:3] == 2'b00) begin
        if (opcode[10:8] == 3'b111)  // INS
            bf_shift = bf_bhits + 1;
        else
            bf_shift = 31 - bf_bhits;
        bf_shift[5] = 1'b0;
    end else begin
        if (opcode[10:8] == 3'b111) begin  // INS
            bf_shift = 6'b011001 + {3'b000, bf_bhits[2:0]};
            bf_shift[5] = 1'b0;
        end else
            bf_shift = {3'b000, 3'b111 - bf_bhits[2:0]};
        bf_offset[4:3] = 2'b00;
    end

    case (bf_bhits[5:3])
        3'b000: set_memmask = 6'b101111;
        3'b001: set_memmask = 6'b100111;
        3'b010: set_memmask = 6'b100011;
        3'b011: set_memmask = 6'b100001;
        default: set_memmask = 6'b100000;
    endcase

    if (setstate == 2'b00)
        set_memmask = 6'b100111;
end

//-----------------------------------------------------------------------------
// SR op
//-----------------------------------------------------------------------------
always @(*) begin
    if (exec[andiSR])
        SRin = FlagsSR & last_data_read[15:8];
    else if (exec[eoriSR])
        SRin = FlagsSR ^ last_data_read[15:8];
    else if (exec[oriSR])
        SRin = FlagsSR | last_data_read[15:8];
    else
        SRin = OP2out[15:8];
end

always @(posedge clk) begin
    if (Reset) begin
        FC[2] <= 1'b1;
        SVmode <= 1'b1;
        preSVmode <= 1'b1;
        FlagsSR <= 8'b00100111;
        make_trace <= 1'b0;
    end else if (clkena_lw) begin
        if (setopcode) begin
            make_trace <= FlagsSR[7];
            if (set[changeMode])
                SVmode <= ~SVmode;
            else
                SVmode <= preSVmode;
        end

        if (trap_berr || trap_illegal || trap_addr_error || trap_priv || trap_1010 || trap_1111) begin
            make_trace <= 1'b0;
            FlagsSR[7] <= 1'b0;
        end

        if (set[changeMode]) begin
            preSVmode <= ~preSVmode;
            FlagsSR[5] <= ~preSVmode;
            FC[2] <= ~preSVmode;
        end

        if (micro_state == trap3)
            FlagsSR[7] <= 1'b0;

        if (trap_trace && state == 2'b10)
            make_trace <= 1'b0;

        if (exec[directSR] || set_stop)
            FlagsSR <= data_read[15:8];

        if (interrupt && trap_interrupt)
            FlagsSR[2:0] <= rIPL_nr;

        if (exec[to_SR]) begin
            FlagsSR <= SRin;
            FC[2] <= SRin[5];
        end else if (exec[update_FC])
            FC[2] <= FlagsSR[5];

        if (interrupt)
            FC[2] <= 1'b1;

        if (!CPU[1]) begin
            FlagsSR[4] <= 1'b0;
            FlagsSR[6] <= 1'b0;
        end
        FlagsSR[3] <= 1'b0;
    end
end

//-----------------------------------------------------------------------------
// Conditions
//-----------------------------------------------------------------------------
always @(*) begin
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
        4'hA: exe_condition = ~Flags[3];
        4'hB: exe_condition = Flags[3];
        4'hC: exe_condition = (Flags[3] & Flags[1]) | (~Flags[3] & ~Flags[1]);
        4'hD: exe_condition = (Flags[3] & ~Flags[1]) | (~Flags[3] & Flags[1]);
        4'hE: exe_condition = (Flags[3] & Flags[1] & ~Flags[2]) | (~Flags[3] & ~Flags[1] & ~Flags[2]);
        4'hF: exe_condition = (Flags[3] & ~Flags[1]) | (~Flags[3] & Flags[1]) | Flags[2];
    endcase
end

//-----------------------------------------------------------------------------
// Movem
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (clkena_lw) begin
        movem_actiond <= exec[movem_action];
        if (decodeOPC)
            sndOPC <= data_read[15:0];
        else if (exec[movem_action] || set[movem_action]) begin
            case (movem_regaddr)
                4'b0000: sndOPC[0]  <= 1'b0;
                4'b0001: sndOPC[1]  <= 1'b0;
                4'b0010: sndOPC[2]  <= 1'b0;
                4'b0011: sndOPC[3]  <= 1'b0;
                4'b0100: sndOPC[4]  <= 1'b0;
                4'b0101: sndOPC[5]  <= 1'b0;
                4'b0110: sndOPC[6]  <= 1'b0;
                4'b0111: sndOPC[7]  <= 1'b0;
                4'b1000: sndOPC[8]  <= 1'b0;
                4'b1001: sndOPC[9]  <= 1'b0;
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

always @(*) begin
    movem_regaddr = 4'b0000;
    movem_run = 1'b1;
    if (sndOPC[3:0] == 4'b0000) begin
        if (sndOPC[7:4] == 4'b0000) begin
            movem_regaddr[3] = 1'b1;
            if (sndOPC[11:8] == 4'b0000) begin
                if (sndOPC[15:12] == 4'b0000)
                    movem_run = 1'b0;
                movem_regaddr[2] = 1'b1;
                movem_mux = sndOPC[15:12];
            end else
                movem_mux = sndOPC[11:8];
        end else begin
            movem_mux = sndOPC[7:4];
            movem_regaddr[2] = 1'b1;
        end
    end else
        movem_mux = sndOPC[3:0];

    if (movem_mux[1:0] == 2'b00) begin
        movem_regaddr[1] = 1'b1;
        if (!movem_mux[2])
            movem_regaddr[0] = 1'b1;
    end else begin
        if (!movem_mux[0])
            movem_regaddr[0] = 1'b1;
    end
end

//-----------------------------------------------------------------------------
// MOVEC
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (Reset) begin
        VBR <= 32'b0;
        CACR <= 4'b0;
    end else if (clkena_lw && exec[movec_wr]) begin
        case (brief[11:0])
            12'h000: SFC <= reg_QA[2:0];
            12'h001: DFC <= reg_QA[2:0];
            12'h002: CACR <= reg_QA[3:0];
            12'h801: VBR <= reg_QA;
            default: ;
        endcase
    end
end

always @(*) begin
    movec_data = 32'b0;
    case (brief[11:0])
        12'h000: movec_data = {29'b0, SFC};
        12'h001: movec_data = {29'b0, DFC};
        12'h002: movec_data = {28'b0, CACR & 4'b0011};
        12'h801: movec_data = VBR;
        default: ;
    endcase
end

assign CACR_out = CACR;
assign VBR_out = VBR;

//-----------------------------------------------------------------------------
// Microcode state machine (partial - the full decode is very large)
// Note: This is a simplified version. The full decoder would need all
// the opcode cases converted.
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    if (Reset)
        micro_state <= ld_nn;
    else if (clkena_lw) begin
        trapd <= trapmake;
        micro_state <= next_micro_state;
    end
end

// The opcode decoder is extremely large. In a complete conversion,
// all the CASE statements from the VHDL would be converted here.
// For brevity, this shows the structure - the full implementation
// would include all instruction decoding.

// Default signal values (this would be in the main decode always block)
always @(*) begin
    // Initialize all control signals to default values
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
    skipFetch_r = make_berr;
    set_writePCbig = 1'b0;
    set_Suppress_Base = 1'b0;
    set_PCbase = 1'b0;

    if (rot_cnt != 6'b000001)
        set_rot_cnt = rot_cnt - 1;

    set_datatype = datatype;
    set = 89'b0;
    set_exec = 89'b0;
    set[update_ld] = 1'b0;

    // Datatype from opcode
    case (opcode[7:6])
        2'b00: datatype = 2'b00;  // Byte
        2'b01: datatype = 2'b01;  // Word
        default: datatype = 2'b10; // Long
    endcase

    if (execOPC && exec_write_back)
        set[restore_ADDR] = 1'b1;

    // Trap handling
    if (interrupt && trap_berr) begin
        next_micro_state = trap0;
        if (!preSVmode)
            set[changeMode] = 1'b1;
        setstate = 2'b01;
    end

    if (trapmake && !trapd) begin
        if (CPU[1] && (trap_trapv || set_Z_error || exec[trap_chk]))
            next_micro_state = trap00;
        else
            next_micro_state = trap0;
        if (!use_VBR_Stackframe)
            set[writePC_add] = 1'b1;
        if (!preSVmode)
            set[changeMode] = 1'b1;
        setstate = 2'b01;
    end

    if (micro_state == int1 || (interrupt && trap_trace)) begin
        if (trap_trace && CPU[1])
            next_micro_state = trap00;
        else
            next_micro_state = trap0;
        if (!preSVmode)
            set[changeMode] = 1'b1;
        setstate = 2'b01;
    end

    if (micro_state == int1 || (interrupt && trap_trace)) begin
        if (!preSVmode)
            set[changeMode] = 1'b1;
        setstate = 2'b01;
    end

    if (setexecOPC && FlagsSR[5] != preSVmode)
        set[changeMode] = 1'b1;

    if (interrupt && trap_interrupt) begin
        next_micro_state = int1;
        set[update_ld] = 1'b1;
        setstate = 2'b10;
    end

    if (set[changeMode]) begin
        set[to_USP] = 1'b1;
        set[from_USP] = 1'b1;
        setstackaddr = 1'b1;
    end

    if (!ea_only && set[get_ea_now])
        setstate = 2'b10;

    if (setstate[1] && set_datatype[1])
        set[longaktion] = 1'b1;

    //-------------------------------------------------------------------------
    // Opcode decoder
    //-------------------------------------------------------------------------
    case (opcode[15:12])
    // 0000 --------------------------------------------------------------------
    4'b0000: begin
        if (opcode[8] && opcode[5:3] == 3'b001) begin  // MOVEP
            datatype = 2'b00;  // Byte
            set[use_SP] = 1'b1;  // addr+2
            set[no_Flags] = 1'b1;
            if (!opcode[7]) begin  // to register
                set_exec[Regwrena] = 1'b1;
                set_exec[opcMOVE] = 1'b1;
                set[movepl] = 1'b1;
            end
            if (decodeOPC) begin
                if (opcode[6])
                    set[movepl] = 1'b1;
                if (!opcode[7])
                    set_direct_data = 1'b1;  // to register
                next_micro_state = movep1;
            end
            if (setexecOPC)
                dest_hbits = 1'b1;
        end else begin
            if (opcode[8] || opcode[11:9] == 3'b100) begin  // Bits
                if (opcode[5:3] != 3'b001 &&  // ea An illegal mode
                    (opcode[8:3] != 6'b000111 || !opcode[2]) &&  // BTST bit number static illegal modes
                    (opcode[8:2] != 7'b1001111 || opcode[1:0] == 2'b00) &&  // BTST bit number dynamic illegal modes
                    (opcode[7:6] == 2'b00 || opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin  // BCHG, BCLR, BSET illegal modes
                    set_exec[opcBITS] = 1'b1;
                    set_exec[ea_data_OP1] = 1'b1;
                    if (opcode[7:6] != 2'b00) begin
                        if (opcode[5:4] == 2'b00)
                            set_exec[Regwrena] = 1'b1;
                        write_back = 1'b1;
                    end
                    if (opcode[5:4] == 2'b00)
                        datatype = 2'b10;  // Long
                    else
                        datatype = 2'b00;  // Byte
                    if (!opcode[8]) begin
                        if (decodeOPC) begin
                            next_micro_state = nop;
                            set[get_2ndOPC] = 1'b1;
                            set[ea_build] = 1'b1;
                        end
                    end else
                        ea_build_now = 1'b1;
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end else if (opcode[8:6] == 3'b011) begin  // CAS/CAS2/CMP2/CHK2
                if (CPU[1]) begin
                    if (opcode[11]) begin  // CAS/CAS2
                        if ((opcode[10:9] != 2'b00 &&
                            opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) ||
                            (opcode[10] && opcode[5:0] == 6'b111100)) begin  // CAS2
                            case (opcode[10:9])
                                2'b01: datatype = 2'b00;  // Byte
                                2'b10: datatype = 2'b01;  // Word
                                default: datatype = 2'b10;  // Long
                            endcase
                            if (opcode[10] && opcode[5:0] == 6'b111100) begin  // CAS2
                                if (decodeOPC) begin
                                    set[get_2ndOPC] = 1'b1;
                                    next_micro_state = cas21;
                                end
                            end else begin  // CAS
                                if (decodeOPC) begin
                                    next_micro_state = nop;
                                    set[get_2ndOPC] = 1'b1;
                                    set[ea_build] = 1'b1;
                                end
                                if (micro_state == idle && nextpass) begin
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
                    end else begin  // CMP2/CHK2
                        if (opcode[10:9] != 2'b11 &&
                            opcode[5:4] != 2'b00 && opcode[5:3] != 3'b011 &&
                            opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin
                            set[trap_chk] = 1'b1;
                            datatype = opcode[10:9];
                            if (decodeOPC) begin
                                next_micro_state = nop;
                                set[get_2ndOPC] = 1'b1;
                                set[ea_build] = 1'b1;
                            end
                            if (set[get_ea_now]) begin
                                set[mem_addsub] = 1'b1;
                                set[OP1addr] = 1'b1;
                            end
                            if (micro_state == idle && nextpass) begin
                                setstate = 2'b10;
                                set[hold_OP2] = 1'b1;
                                if (exe_datatype != 2'b00)
                                    check_aligned = 1'b1;
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
            end else if (opcode[11:9] == 3'b111) begin  // MOVES not in 68000
                if (CPU[0] && opcode[7:6] != 2'b11 && opcode[5:4] != 2'b00 &&
                    (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                    if (SVmode) begin
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
            end else begin  // andi, ...xxxi
                if (opcode[7:6] != 2'b11 && opcode[5:3] != 3'b001) begin  // ea An illegal mode
                    if (opcode[11:9] == 3'b000)  // ORI
                        if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && !opcode[7]))
                            set_exec[opcOR] = 1'b1;
                        else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    if (opcode[11:9] == 3'b001)  // ANDI
                        if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && !opcode[7]))
                            set_exec[opcAND] = 1'b1;
                        else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    if (opcode[11:9] == 3'b010 || opcode[11:9] == 3'b011)  // SUBI, ADDI
                        if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)
                            set_exec[opcADD] = 1'b1;
                        else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    if (opcode[11:9] == 3'b101)  // EORI
                        if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00 || (opcode[2:0] == 3'b100 && !opcode[7]))
                            set_exec[opcEOR] = 1'b1;
                        else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    if (opcode[11:9] == 3'b110)  // CMPI
                        if (opcode[5:3] != 3'b111 || !opcode[2])
                            set_exec[opcCMP] = 1'b1;
                        else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    if (set_exec[opcOR] || set_exec[opcAND] || set_exec[opcADD] ||
                        set_exec[opcEOR] || set_exec[opcCMP]) begin
                        if (!opcode[7] && opcode[5:0] == 6'b111100 &&
                            (set_exec[opcAND] || set_exec[opcOR] || set_exec[opcEOR])) begin  // SR
                            if (decodeOPC && !SVmode && opcode[6]) begin  // SR
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end else begin
                                set[no_Flags] = 1'b1;
                                if (decodeOPC) begin
                                    if (opcode[6])
                                        set[to_SR] = 1'b1;
                                    set[to_CCR] = 1'b1;
                                    set[andiSR] = set_exec[opcAND];
                                    set[eoriSR] = set_exec[opcEOR];
                                    set[oriSR] = set_exec[opcOR];
                                    setstate = 2'b01;
                                    next_micro_state = nopnop;
                                end
                            end
                        end else if (!opcode[7] || opcode[5:0] != 6'b111100 ||
                                     !(set_exec[opcAND] || set_exec[opcOR] || set_exec[opcEOR])) begin
                            if (decodeOPC) begin
                                next_micro_state = andi;
                                set[get_2ndOPC] = 1'b1;
                                set[ea_build] = 1'b1;
                                set_direct_data = 1'b1;
                                if (datatype == 2'b10)
                                    set[longaktion] = 1'b1;
                            end
                            if (opcode[5:4] != 2'b00)
                                set_exec[ea_data_OP1] = 1'b1;
                            if (opcode[11:9] != 3'b110) begin  // not CMPI
                                if (opcode[5:4] == 2'b00)
                                    set_exec[Regwrena] = 1'b1;
                                write_back = 1'b1;
                            end
                            if (opcode[10:9] == 2'b10)  // CMPI, SUBI
                                set[addsub] = 1'b1;
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

    // 0001, 0010, 0011 - MOVE.B, MOVE.L, MOVE.W
    4'b0001, 4'b0010, 4'b0011: begin
        if ((opcode[11:10] == 2'b00 || opcode[8:6] != 3'b111) &&  // illegal dest ea
            (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) &&  // illegal src ea
            (opcode[13] || (opcode[8:6] != 3'b001 && opcode[5:3] != 3'b001))) begin  // byte src/movea
            set_exec[opcMOVE] = 1'b1;
            ea_build_now = 1'b1;
            if (opcode[8:6] == 3'b001)
                set[no_Flags] = 1'b1;
            if (opcode[5:4] == 2'b00) begin  // Dn, An
                if (opcode[8:7] == 2'b00)
                    set_exec[Regwrena] = 1'b1;
            end
            case (opcode[13:12])
                2'b01: datatype = 2'b00;  // Byte
                2'b10: datatype = 2'b10;  // Long
                default: datatype = 2'b01;  // Word
            endcase
            source_lowbits = 1'b1;  // Dn, An
            if (opcode[3])
                source_areg = 1'b1;
            if (nextpass || opcode[5:4] == 2'b00) begin
                dest_hbits = 1'b1;
                if (opcode[8:6] != 3'b000)
                    dest_areg = 1'b1;
            end
            if (micro_state == idle && (nextpass || (opcode[5:4] == 2'b00 && decodeOPC))) begin
                case (opcode[8:6])  // destination
                    3'b000, 3'b001:  // Dn, An
                        set_exec[Regwrena] = 1'b1;
                    3'b010, 3'b011, 3'b100: begin  // (An), (An)+, -(An)
                        if (opcode[6]) begin  // (An)+
                            set[postadd] = 1'b1;
                            if (opcode[11:9] == 3'b111)
                                set[use_SP] = 1'b1;
                        end
                        if (opcode[8]) begin  // -(An)
                            set[presub] = 1'b1;
                            if (opcode[11:9] == 3'b111)
                                set[use_SP] = 1'b1;
                        end
                        setstate = 2'b11;
                        next_micro_state = nop;
                        if (!nextpass)
                            set[write_reg] = 1'b1;
                    end
                    3'b101:  // (d16,An)
                        next_micro_state = st_dAn1;
                    3'b110: begin  // (d8,An,Xn)
                        next_micro_state = st_AnXn1;
                        getbrief = 1'b1;
                    end
                    3'b111: begin
                        case (opcode[11:9])
                            3'b000:  // (xxxx).w
                                next_micro_state = st_nn;
                            3'b001: begin  // (xxxx).l
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

    // 0100 - Miscellaneous (LEA, CHK, EXT, MOVEM, TST, TAS, JMP, JSR, etc.)
    4'b0100: begin
        if (opcode[8]) begin  // LEA, EXTB.L, CHK
            if (opcode[6]) begin  // LEA, EXTB.L
                if (opcode[11:9] == 3'b100 && opcode[5:3] == 3'b000) begin  // EXTB.L
                    if (opcode[7] && CPU[1]) begin
                        source_lowbits = 1'b1;
                        set_exec[opcEXT] = 1'b1;
                        set_exec[opcEXTB] = 1'b1;
                        set_exec[opcMOVE] = 1'b1;
                        set_exec[Regwrena] = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin  // LEA
                    if (opcode[7] &&
                        (opcode[5] || opcode[4:3] == 2'b10) &&
                        opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin
                        source_lowbits = 1'b1;
                        source_areg = 1'b1;
                        ea_only = 1'b1;
                        set_exec[Regwrena] = 1'b1;
                        set_exec[opcMOVE] = 1'b1;
                        set[no_Flags] = 1'b1;
                        if (opcode[5:3] == 3'b010) begin  // LEA (Am),An
                            dest_areg = 1'b1;
                            dest_hbits = 1'b1;
                        end else
                            ea_build_now = 1'b1;
                        if (set[get_ea_now]) begin
                            setstate = 2'b01;
                            set_direct_data = 1'b1;
                        end
                        if (setexecOPC) begin
                            dest_areg = 1'b1;
                            dest_hbits = 1'b1;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
            end else begin  // CHK
                if (opcode[5:3] != 3'b001 &&
                    (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
                    if (opcode[7]) begin
                        datatype = 2'b01;  // Word
                        set[trap_chk] = 1'b1;
                        if ((~c_out[1] || OP1out[15] || OP2out[15]) && exec[opcCHK])
                            trapmake = 1'b1;
                    end else if (CPU[1]) begin  // CHK long for 68020
                        datatype = 2'b10;  // Long
                        set[trap_chk] = 1'b1;
                        if ((~c_out[2] || OP1out[31] || OP2out[31]) && exec[opcCHK])
                            trapmake = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                    if (opcode[7] || CPU[1]) begin
                        if ((nextpass || opcode[5:4] == 2'b00) && !exec[opcCHK] && micro_state == idle)
                            set_exec[opcCHK] = 1'b1;
                        ea_build_now = 1'b1;
                        set[addsub] = 1'b1;
                        if (setexecOPC) begin
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
                3'b000: begin  // NEGX, MOVE from SR
                    if (opcode[5:3] != 3'b001 &&
                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                        if (opcode[7:6] == 2'b11) begin  // MOVE from SR
                            if (SR_Read == 0 || (!CPU[0] && SR_Read == 2) || SVmode) begin
                                ea_build_now = 1'b1;
                                set_exec[opcMOVESR] = 1'b1;
                                datatype = 2'b01;
                                write_back = 1'b1;
                                if (CPU[0] && state == 2'b10 && !addrvalue)
                                    skipFetch_r = 1'b1;
                                if (opcode[5:4] == 2'b00)
                                    set_exec[Regwrena] = 1'b1;
                            end else begin
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin  // NEGX
                            ea_build_now = 1'b1;
                            set_exec[use_XZFlag] = 1'b1;
                            write_back = 1'b1;
                            set_exec[opcADD] = 1'b1;
                            set[addsub] = 1'b1;
                            source_lowbits = 1'b1;
                            if (opcode[5:4] == 2'b00)
                                set_exec[Regwrena] = 1'b1;
                            if (setexecOPC)
                                set[OP1out_zero] = 1'b1;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
                3'b001: begin  // CLR, MOVE from CCR
                    if (opcode[5:3] != 3'b001 &&
                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                        if (opcode[7:6] == 2'b11) begin  // MOVE from CCR (68010+)
                            if (SR_Read == 1 || (CPU[0] && SR_Read == 2)) begin
                                ea_build_now = 1'b1;
                                set_exec[opcMOVESR] = 1'b1;
                                datatype = 2'b01;
                                write_back = 1'b1;
                                if (opcode[5:4] == 2'b00)
                                    set_exec[Regwrena] = 1'b1;
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin  // CLR
                            ea_build_now = 1'b1;
                            write_back = 1'b1;
                            set_exec[opcAND] = 1'b1;
                            if (CPU[0] && state == 2'b10 && !addrvalue)
                                skipFetch_r = 1'b1;
                            if (setexecOPC)
                                set[OP1out_zero] = 1'b1;
                            if (opcode[5:4] == 2'b00)
                                set_exec[Regwrena] = 1'b1;
                        end
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
                3'b010: begin  // NEG, MOVE to CCR
                    if (opcode[7:6] == 2'b11) begin  // MOVE to CCR
                        if (opcode[5:3] != 3'b001 &&
                            (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
                            ea_build_now = 1'b1;
                            datatype = 2'b01;
                            source_lowbits = 1'b1;
                            if ((decodeOPC && opcode[5:4] == 2'b00) || (state == 2'b10 && !addrvalue) || direct_data)
                                set[to_CCR] = 1'b1;
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin  // NEG
                        if (opcode[5:3] != 3'b001 &&
                            (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                            ea_build_now = 1'b1;
                            write_back = 1'b1;
                            set_exec[opcADD] = 1'b1;
                            set[addsub] = 1'b1;
                            source_lowbits = 1'b1;
                            if (opcode[5:4] == 2'b00)
                                set_exec[Regwrena] = 1'b1;
                            if (setexecOPC)
                                set[OP1out_zero] = 1'b1;
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end
                3'b011: begin  // NOT, MOVE to SR
                    if (opcode[7:6] == 2'b11) begin  // MOVE to SR
                        if (opcode[5:3] != 3'b001 &&
                            (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
                            if (SVmode) begin
                                ea_build_now = 1'b1;
                                datatype = 2'b01;
                                source_lowbits = 1'b1;
                                if ((decodeOPC && opcode[5:4] == 2'b00) || (state == 2'b10 && !addrvalue) || direct_data) begin
                                    set[to_SR] = 1'b1;
                                    set[to_CCR] = 1'b1;
                                end
                                if (exec[to_SR] || (decodeOPC && opcode[5:4] == 2'b00) || (state == 2'b10 && !addrvalue) || direct_data)
                                    setstate = 2'b01;
                            end else begin
                                trap_priv = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin  // NOT
                        if (opcode[5:3] != 3'b001 &&
                            (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                            ea_build_now = 1'b1;
                            write_back = 1'b1;
                            set_exec[opcEOR] = 1'b1;
                            set_exec[ea_data_OP1] = 1'b1;
                            if (opcode[5:3] == 3'b000)
                                set_exec[Regwrena] = 1'b1;
                            if (setexecOPC)
                                set[OP2out_one] = 1'b1;
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end
                3'b100, 3'b110: begin  // EXT, MOVEM, MUL.L, DIV.L, NBCD, PEA, SWAP, LINK.L
                    if (opcode[7]) begin  // EXT, MOVEM
                        if (opcode[5:3] == 3'b000 && !opcode[10]) begin  // EXT
                            source_lowbits = 1'b1;
                            set_exec[opcEXT] = 1'b1;
                            set_exec[opcMOVE] = 1'b1;
                            set_exec[Regwrena] = 1'b1;
                            if (!opcode[6]) begin
                                datatype = 2'b01;  // WORD
                                set_exec[opcEXTB] = 1'b1;
                            end
                        end else begin  // MOVEM
                            if ((opcode[10] || ((opcode[5] || opcode[4:3] == 2'b10) &&
                                 (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))) &&
                                (!opcode[10] || (opcode[5:4] != 2'b00 &&
                                 opcode[5:3] != 3'b100 &&
                                 opcode[5:2] != 4'b1111))) begin
                                ea_only = 1'b1;
                                set[no_Flags] = 1'b1;
                                if (!opcode[6])
                                    datatype = 2'b01;  // Word transfer
                                if ((opcode[5:3] == 3'b100 || opcode[5:3] == 3'b011) && state == 2'b01) begin
                                    set_exec[save_memaddr] = 1'b1;
                                    set_exec[Regwrena] = 1'b1;
                                end
                                if (opcode[5:3] == 3'b100) begin  // -(An)
                                    movem_presub = 1'b1;
                                    set[subidx] = 1'b1;
                                end
                                if (state == 2'b10 && !addrvalue) begin
                                    set[Regwrena] = 1'b1;
                                    set[opcMOVE] = 1'b1;
                                end
                                if (decodeOPC) begin
                                    set[get_2ndOPC] = 1'b1;
                                    if (opcode[5:3] == 3'b010 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100)
                                        next_micro_state = movem1;
                                    else begin
                                        next_micro_state = nop;
                                        set[ea_build] = 1'b1;
                                    end
                                end
                                if (set[get_ea_now]) begin
                                    if (movem_run) begin
                                        set[movem_action] = 1'b1;
                                        if (!opcode[10]) begin
                                            setstate = 2'b11;
                                            set[write_reg] = 1'b1;
                                        end else
                                            setstate = 2'b10;
                                        next_micro_state = movem2;
                                        set[mem_addsub] = 1'b1;
                                    end else
                                        setstate = 2'b01;
                                end
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end
                    end else begin  // MUL.L, DIV.L, NBCD, PEA, SWAP, LINK.L
                        if (opcode[10]) begin  // MUL.L, DIV.L (68020)
                            if (opcode[8:7] == 2'b00 && opcode[5:3] != 3'b001 &&
                                (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) &&
                                MUL_Hardware == 1 && !opcode[6] &&
                                (MUL_Mode == 1 || (CPU[1] && MUL_Mode == 2))) begin
                                // FPGA Multiplier for long
                                if (decodeOPC) begin
                                    next_micro_state = nop;
                                    set[get_2ndOPC] = 1'b1;
                                    set[ea_build] = 1'b1;
                                end
                                if ((micro_state == idle && nextpass) || (opcode[5:4] == 2'b00 && exec[ea_build])) begin
                                    dest_2ndHbits = 1'b1;
                                    datatype = 2'b10;
                                    set[opcMULU] = 1'b1;
                                    set[write_lowlong] = 1'b1;
                                    if (sndOPC[10]) begin
                                        setstate = 2'b01;
                                        next_micro_state = mul_end2;
                                    end
                                    set[Regwrena] = 1'b1;
                                end
                                source_lowbits = 1'b1;
                                datatype = 2'b10;
                            end else if (opcode[8:7] == 2'b00 && opcode[5:3] != 3'b001 &&
                                         (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) &&
                                         ((opcode[6] && (DIV_Mode == 1 || (CPU[1] && DIV_Mode == 2))) ||
                                          (!opcode[6] && (MUL_Mode == 1 || (CPU[1] && MUL_Mode == 2))))) begin
                                // No FPGA Multiplier
                                if (decodeOPC) begin
                                    next_micro_state = nop;
                                    set[get_2ndOPC] = 1'b1;
                                    set[ea_build] = 1'b1;
                                end
                                if ((micro_state == idle && nextpass) || (opcode[5:4] == 2'b00 && exec[ea_build])) begin
                                    setstate = 2'b01;
                                    dest_2ndHbits = 1'b1;
                                    source_2ndLbits = 1'b1;
                                    if (opcode[6])
                                        next_micro_state = div1;
                                    else begin
                                        next_micro_state = mul1;
                                        set[ld_rot_cnt] = 1'b1;
                                    end
                                end
                                source_lowbits = 1'b1;
                                if (nextpass || (opcode[5:4] == 2'b00 && decodeOPC))
                                    dest_hbits = 1'b1;
                                datatype = 2'b10;
                            end else begin
                                trap_illegal = 1'b1;
                                trapmake = 1'b1;
                            end
                        end else begin  // PEA, SWAP, LINK.L, NBCD
                            if (opcode[6]) begin
                                datatype = 2'b10;
                                if (opcode[5:3] == 3'b000) begin  // SWAP
                                    set_exec[opcSWAP] = 1'b1;
                                    set_exec[Regwrena] = 1'b1;
                                end else if (opcode[5:3] == 3'b001) begin  // BKPT
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end else begin  // PEA
                                    if ((opcode[5] || opcode[4:3] == 2'b10) &&
                                        opcode[5:3] != 3'b100 &&
                                        opcode[5:2] != 4'b1111) begin
                                        ea_only = 1'b1;
                                        ea_build_now = 1'b1;
                                        if (nextpass && micro_state == idle) begin
                                            set[presub] = 1'b1;
                                            setstackaddr = 1'b1;
                                            setstate = 2'b11;
                                            next_micro_state = nop;
                                        end
                                        if (set[get_ea_now])
                                            setstate = 2'b01;
                                    end else begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end
                            end else begin
                                if (opcode[5:3] == 3'b001) begin  // LINK.L
                                    datatype = 2'b10;
                                    set_exec[opcADD] = 1'b1;
                                    set_exec[Regwrena] = 1'b1;
                                    set[no_Flags] = 1'b1;
                                    if (decodeOPC) begin
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
                                end else begin  // NBCD
                                    if (opcode[5:3] != 3'b001 &&
                                        (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                                        ea_build_now = 1'b1;
                                        set_exec[use_XZFlag] = 1'b1;
                                        write_back = 1'b1;
                                        set_exec[opcADD] = 1'b1;
                                        set_exec[opcSBCD] = 1'b1;
                                        set[addsub] = 1'b1;
                                        source_lowbits = 1'b1;
                                        if (opcode[5:4] == 2'b00)
                                            set_exec[Regwrena] = 1'b1;
                                        if (setexecOPC)
                                            set[OP1out_zero] = 1'b1;
                                    end else begin
                                        trap_illegal = 1'b1;
                                        trapmake = 1'b1;
                                    end
                                end
                            end
                        end
                    end
                end
                3'b101: begin  // TST, TAS
                    if (opcode[7:3] == 5'b11111 && opcode[2:1] != 2'b00) begin  // 0x4AFC illegal
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end else begin
                        if ((opcode[7:6] != 2'b11 ||
                             (opcode[5:3] != 3'b001 &&
                              (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))) &&
                            ((opcode[7:6] != 2'b00 || opcode[5:3] != 3'b001) &&
                             (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00))) begin
                            ea_build_now = 1'b1;
                            if (setexecOPC) begin
                                source_lowbits = 1'b1;
                                if (opcode[3])
                                    source_areg = 1'b1;
                            end
                            set_exec[opcMOVE] = 1'b1;
                            if (opcode[7:6] == 2'b11) begin  // TAS
                                set_exec_tas = 1'b1;
                                write_back = 1'b1;
                                datatype = 2'b00;  // Byte
                                if (opcode[5:4] == 2'b00)
                                    set_exec[Regwrena] = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end
                end
                3'b111: begin  // 4EXX group (JMP, JSR, TRAP, LINK, UNLK, RTS, RTE, etc.)
                    if (opcode[7]) begin  // JSR, JMP
                        if ((opcode[5] || opcode[4:3] == 2'b10) &&
                            opcode[5:3] != 3'b100 && opcode[5:2] != 4'b1111) begin
                            datatype = 2'b10;
                            ea_only = 1'b1;
                            ea_build_now = 1'b1;
                            if (exec[ea_to_pc])
                                next_micro_state = nop;
                            if (nextpass && micro_state == idle && !opcode[6]) begin  // JSR
                                set[presub] = 1'b1;
                                setstackaddr = 1'b1;
                                setstate = 2'b11;
                                next_micro_state = nopnop;
                            end
                            if (micro_state == ld_AnXn1 && !brief[8])  // JMP/JSR n(Ax,Dn)
                                skipFetch_r = 1'b1;
                            if (state == 2'b00)
                                writePC = 1'b1;
                            set[hold_dwr] = 1'b1;
                            if (set[get_ea_now]) begin
                                if (!exec[longaktion] || long_done)
                                    skipFetch_r = 1'b1;
                                setstate = 2'b01;
                                set[ea_to_pc] = 1'b1;
                            end
                        end else begin
                            trap_illegal = 1'b1;
                            trapmake = 1'b1;
                        end
                    end else begin
                        case (opcode[6:0])
                            7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011,
                            7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111,
                            7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011,
                            7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111: begin  // TRAP
                                trap_trap = 1'b1;
                                trapmake = 1'b1;
                            end
                            7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011,
                            7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: begin  // LINK word
                                datatype = 2'b10;
                                set_exec[opcADD] = 1'b1;
                                set_exec[Regwrena] = 1'b1;
                                set[no_Flags] = 1'b1;
                                if (decodeOPC) begin
                                    next_micro_state = link1;
                                    set[presub] = 1'b1;
                                    setstackaddr = 1'b1;
                                    set[mem_addsub] = 1'b1;
                                    source_lowbits = 1'b1;
                                    source_areg = 1'b1;
                                    set[store_ea_data] = 1'b1;
                                end
                            end
                            7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011,
                            7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111: begin  // UNLK
                                datatype = 2'b10;
                                set_exec[Regwrena] = 1'b1;
                                set_exec[opcMOVE] = 1'b1;
                                set[no_Flags] = 1'b1;
                                if (decodeOPC) begin
                                    setstate = 2'b01;
                                    next_micro_state = unlink1;
                                    set[opcMOVE] = 1'b1;
                                    set[Regwrena] = 1'b1;
                                    setstackaddr = 1'b1;
                                    source_lowbits = 1'b1;
                                    source_areg = 1'b1;
                                end
                            end
                            7'b1100000, 7'b1100001, 7'b1100010, 7'b1100011,
                            7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111: begin  // MOVE An,USP
                                if (SVmode) begin
                                    set[to_USP] = 1'b1;
                                    source_lowbits = 1'b1;
                                    source_areg = 1'b1;
                                    datatype = 2'b10;
                                end else begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011,
                            7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111: begin  // MOVE USP,An
                                if (SVmode) begin
                                    set[from_USP] = 1'b1;
                                    datatype = 2'b10;
                                    set_exec[Regwrena] = 1'b1;
                                end else begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            7'b1110000: begin  // RESET
                                if (!SVmode) begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end else begin
                                    set[opcRESET] = 1'b1;
                                    if (decodeOPC) begin
                                        set[ld_rot_cnt] = 1'b1;
                                        set_rot_cnt = 6'b000000;
                                    end
                                end
                            end
                            7'b1110001: begin  // NOP
                                // Do nothing
                            end
                            7'b1110010: begin  // STOP
                                if (!SVmode) begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end else begin
                                    if (decodeOPC) begin
                                        setnextpass = 1'b1;
                                        set_stop = 1'b1;
                                    end
                                    if (stop)
                                        skipFetch_r = 1'b1;
                                end
                            end
                            7'b1110011, 7'b1110111: begin  // RTE, RTR
                                if (SVmode || opcode[2]) begin
                                    if (decodeOPC) begin
                                        setstate = 2'b10;
                                        set[postadd] = 1'b1;
                                        setstackaddr = 1'b1;
                                        if (opcode[2])
                                            set[directCCR] = 1'b1;
                                        else
                                            set[directSR] = 1'b1;
                                        next_micro_state = rte1;
                                    end
                                end else begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            7'b1110100: begin  // RTD
                                datatype = 2'b10;
                                if (decodeOPC) begin
                                    setstate = 2'b10;
                                    set[postadd] = 1'b1;
                                    setstackaddr = 1'b1;
                                    set[direct_delta] = 1'b1;
                                    set[directPC] = 1'b1;
                                    set_direct_data = 1'b1;
                                    next_micro_state = rtd1;
                                end
                            end
                            7'b1110101: begin  // RTS
                                datatype = 2'b10;
                                if (decodeOPC) begin
                                    setstate = 2'b10;
                                    set[postadd] = 1'b1;
                                    setstackaddr = 1'b1;
                                    set[direct_delta] = 1'b1;
                                    set[directPC] = 1'b1;
                                    next_micro_state = nopnop;
                                end
                            end
                            7'b1110110: begin  // TRAPV
                                if (decodeOPC)
                                    setstate = 2'b01;
                                if (Flags[1] && state == 2'b01) begin
                                    trap_trapv = 1'b1;
                                    trapmake = 1'b1;
                                end
                            end
                            7'b1111010, 7'b1111011: begin  // MOVEC
                                if (CPU == 2'b00) begin
                                    trap_illegal = 1'b1;
                                    trapmake = 1'b1;
                                end else if (!SVmode) begin
                                    trap_priv = 1'b1;
                                    trapmake = 1'b1;
                                end else begin
                                    datatype = 2'b10;
                                    if (last_data_read[11:0] == 12'h800) begin
                                        set[from_USP] = 1'b1;
                                        if (opcode[0])
                                            set[to_USP] = 1'b1;
                                    end
                                    if (!opcode[0])
                                        set_exec[movec_rd] = 1'b1;
                                    else
                                        set_exec[movec_wr] = 1'b1;
                                    if (decodeOPC) begin
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

    // 0101 - ADDQ/SUBQ/Scc/DBcc
    4'b0101: begin
        if (opcode[7:6] == 2'b11) begin  // DBcc, Scc, TRAPcc
            if (opcode[5:3] == 3'b001) begin  // DBcc
                if (decodeOPC) begin
                    next_micro_state = dbcc1;
                    set[OP2out_one] = 1'b1;
                    data_is_source = 1'b1;
                end
            end else if (opcode[5:3] == 3'b111 && (opcode[2:1] == 2'b01 || opcode[2:0] == 3'b100)) begin  // TRAPcc
                if (CPU[1]) begin
                    if (opcode[2:1] == 2'b01) begin
                        if (decodeOPC) begin
                            if (opcode[0])  // long
                                set[longaktion] = 1'b1;
                            next_micro_state = nop;
                        end
                    end else begin
                        if (decodeOPC)
                            setstate = 2'b01;
                    end
                    if (exe_condition && !decodeOPC) begin
                        trap_trapv = 1'b1;
                        trapmake = 1'b1;
                    end
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end else if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00) begin  // Scc
                datatype = 2'b00;  // Byte
                ea_build_now = 1'b1;
                write_back = 1'b1;
                set_exec[opcScc] = 1'b1;
                if (CPU[0] && state == 2'b10 && !addrvalue)
                    skipFetch_r = 1'b1;
                if (opcode[5:4] == 2'b00)
                    set_exec[Regwrena] = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end else begin  // ADDQ, SUBQ
            if (opcode[7:3] != 5'b00001 &&
                (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                ea_build_now = 1'b1;
                if (opcode[5:3] == 3'b001)
                    set[no_Flags] = 1'b1;
                if (opcode[8])
                    set[addsub] = 1'b1;
                write_back = 1'b1;
                set_exec[opcADDQ] = 1'b1;
                set_exec[opcADD] = 1'b1;
                set_exec[ea_data_OP1] = 1'b1;
                if (opcode[5:4] == 2'b00)
                    set_exec[Regwrena] = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end
    end

    // 0110 - Bcc/BSR/BRA
    4'b0110: begin
        datatype = 2'b10;
        if (micro_state == idle) begin
            if (opcode[11:8] == 4'b0001) begin  // BSR
                set[presub] = 1'b1;
                setstackaddr = 1'b1;
                if (opcode[7:0] == 8'hFF) begin
                    next_micro_state = bsr2;
                    set[longaktion] = 1'b1;
                end else if (opcode[7:0] == 8'h00) begin
                    next_micro_state = bsr2;
                end else begin
                    next_micro_state = bsr1;
                    setstate = 2'b11;
                    writePC = 1'b1;
                end
            end else begin  // BRA, Bcc
                if (opcode[7:0] == 8'hFF) begin
                    next_micro_state = bra1;
                    set[longaktion] = 1'b1;
                end else if (opcode[7:0] == 8'h00) begin
                    next_micro_state = bra1;
                end else begin
                    setstate = 2'b01;
                    next_micro_state = bra1;
                end
            end
        end
    end

    // 0111 - MOVEQ
    4'b0111: begin
        if (!opcode[8]) begin
            datatype = 2'b10;  // Long
            set_exec[Regwrena] = 1'b1;
            set_exec[opcMOVEQ] = 1'b1;
            set_exec[opcMOVE] = 1'b1;
            dest_hbits = 1'b1;
        end else begin
            trap_illegal = 1'b1;
            trapmake = 1'b1;
        end
    end

    // 1000 - OR/DIV/SBCD/PACK/UNPK
    4'b1000: begin
        if (opcode[7:6] == 2'b11) begin  // DIVU, DIVS
            if (DIV_Mode != 3 &&
                opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
                if (opcode[5:4] == 2'b00)  // Dn, An
                    regdirectsource = 1'b1;
                if ((micro_state == idle && nextpass) || (opcode[5:4] == 2'b00 && decodeOPC)) begin
                    setstate = 2'b01;
                    next_micro_state = div1;
                end
                ea_build_now = 1'b1;
                if (!Z_error && !set_V_Flag)
                    set_exec[Regwrena] = 1'b1;
                source_lowbits = 1'b1;
                if (nextpass || (opcode[5:4] == 2'b00 && decodeOPC))
                    dest_hbits = 1'b1;
                datatype = 2'b01;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end else if (opcode[8] && opcode[5:4] == 2'b00) begin  // SBCD, PACK, UNPK
            if (opcode[7:6] == 2'b00) begin  // SBCD
                build_bcd = 1'b1;
                set_exec[opcADD] = 1'b1;
                set_exec[opcSBCD] = 1'b1;
                set[addsub] = 1'b1;
            end else if (opcode[7:6] == 2'b01 || opcode[7:6] == 2'b10) begin  // PACK, UNPK
                set_exec[ea_data_OP1] = 1'b1;
                set[no_Flags] = 1'b1;
                source_lowbits = 1'b1;
                if (opcode[7:6] == 2'b01) begin  // PACK
                    set_exec[opcPACK] = 1'b1;
                    datatype = 2'b01;  // Word
                end else begin  // UNPK
                    set_exec[opcUNPACK] = 1'b1;
                    datatype = 2'b00;  // Byte
                end
                if (!opcode[3]) begin
                    if (opcode[7:6] == 2'b01)
                        set_datatype = 2'b00;  // Byte
                    else
                        set_datatype = 2'b01;  // Word
                    set_exec[Regwrena] = 1'b1;
                    dest_hbits = 1'b1;
                    if (decodeOPC) begin
                        next_micro_state = nop;
                        set[store_ea_packdata] = 1'b1;
                        set[store_ea_data] = 1'b1;
                    end
                end else begin  // PACK -(Ax),-(Ay)
                    write_back = 1'b1;
                    if (decodeOPC) begin
                        next_micro_state = pack1;
                        set_direct_data = 1'b1;
                    end
                end
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end else begin  // OR
            if (opcode[7:6] != 2'b11 &&
                (((!opcode[8] && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) ||
                  (opcode[8] && opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))))) begin
                set_exec[opcOR] = 1'b1;
                build_logical = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end
    end

    // 1001 - SUB/SUBX
    4'b1001: begin
        if (opcode[8:3] != 6'b000001 &&  // byte src address reg direct
            ((((!opcode[8] || opcode[7:6] == 2'b11) && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) ||
              (opcode[8] && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))))) begin
            set_exec[opcADD] = 1'b1;
            ea_build_now = 1'b1;
            set[addsub] = 1'b1;  // SUB
            if (opcode[7:6] == 2'b11) begin  // SUBA
                if (!opcode[8])  // SUBA.W
                    datatype = 2'b01;  // Word
                set_exec[Regwrena] = 1'b1;
                source_lowbits = 1'b1;
                if (opcode[3])
                    source_areg = 1'b1;
                set[no_Flags] = 1'b1;
                if (setexecOPC) begin
                    dest_areg = 1'b1;
                    dest_hbits = 1'b1;
                end
            end else begin
                if (opcode[8] && opcode[5:4] == 2'b00)  // SUBX
                    build_bcd = 1'b1;
                else  // SUB
                    build_logical = 1'b1;
            end
        end else begin
            trap_illegal = 1'b1;
            trapmake = 1'b1;
        end
    end

    // 1010 - Line A trap
    4'b1010: begin
        trap_1010 = 1'b1;
        trapmake = 1'b1;
    end

    // 1011 - CMP/EOR/CMPM/CMPA
    4'b1011: begin
        if (opcode[7:6] == 2'b11) begin  // CMPA
            if (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00) begin
                ea_build_now = 1'b1;
                if (!opcode[8]) begin  // CMPA.W
                    datatype = 2'b01;  // Word
                    set_exec[opcCPMAW] = 1'b1;
                end
                set_exec[opcCMP] = 1'b1;
                if (setexecOPC) begin
                    source_lowbits = 1'b1;
                    if (opcode[3])
                        source_areg = 1'b1;
                    dest_areg = 1'b1;
                    dest_hbits = 1'b1;
                end
                set[addsub] = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end else begin  // CMPM, EOR, CMP
            if (opcode[8]) begin
                if (opcode[5:3] == 3'b001) begin  // CMPM
                    ea_build_now = 1'b1;
                    set_exec[opcCMP] = 1'b1;
                    if (decodeOPC) begin
                        if (opcode[2:0] == 3'b111)
                            set[use_SP] = 1'b1;
                        setstate = 2'b10;
                        set[update_ld] = 1'b1;
                        set[postadd] = 1'b1;
                        next_micro_state = cmpm;
                    end
                    set_exec[ea_data_OP1] = 1'b1;
                    set[addsub] = 1'b1;
                end else begin  // EOR
                    if (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00) begin
                        ea_build_now = 1'b1;
                        build_logical = 1'b1;
                        set_exec[opcEOR] = 1'b1;
                    end else begin
                        trap_illegal = 1'b1;
                        trapmake = 1'b1;
                    end
                end
            end else begin  // CMP
                if (opcode[8:3] != 6'b000001 &&
                    (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
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

    // 1100 - AND/MUL/ABCD/EXG
    4'b1100: begin
        if (opcode[7:6] == 2'b11) begin  // MULU, MULS
            if (MUL_Mode != 3 &&
                opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) begin
                if (opcode[5:4] == 2'b00)
                    regdirectsource = 1'b1;
                if ((micro_state == idle && nextpass) || (opcode[5:4] == 2'b00 && decodeOPC)) begin
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
                if (nextpass || (opcode[5:4] == 2'b00 && decodeOPC))
                    dest_hbits = 1'b1;
                datatype = 2'b01;
                if (setexecOPC)
                    datatype = 2'b10;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end else if (opcode[8] && opcode[5:4] == 2'b00) begin  // ABCD, EXG
            if (opcode[7:6] == 2'b00) begin  // ABCD
                build_bcd = 1'b1;
                set_exec[opcADD] = 1'b1;
                set_exec[opcABCD] = 1'b1;
            end else begin  // EXG
                if (opcode[7:4] == 4'b0100 || opcode[7:3] == 5'b10001) begin
                    datatype = 2'b10;
                    set[Regwrena] = 1'b1;
                    set[exg] = 1'b1;
                    set[alu_move] = 1'b1;
                    if (opcode[6] && opcode[3]) begin
                        dest_areg = 1'b1;
                        source_areg = 1'b1;
                    end
                    if (decodeOPC)
                        setstate = 2'b01;
                    else
                        dest_hbits = 1'b1;
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end
        end else begin  // AND
            if (opcode[7:6] != 2'b11 &&
                ((!opcode[8] && opcode[5:3] != 3'b001 && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) ||
                 (opcode[8] && opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)))) begin
                set_exec[opcAND] = 1'b1;
                build_logical = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end
    end

    // 1101 - ADD/ADDX
    4'b1101: begin
        if (opcode[8:3] != 6'b000001 &&  // byte src address reg direct
            ((((!opcode[8] || opcode[7:6] == 2'b11) && (opcode[5:2] != 4'b1111 || opcode[1:0] == 2'b00)) ||
              (opcode[8] && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00))))) begin
            set_exec[opcADD] = 1'b1;
            ea_build_now = 1'b1;
            // No set[addsub] for ADD
            if (opcode[7:6] == 2'b11) begin  // ADDA
                if (!opcode[8])  // ADDA.W
                    datatype = 2'b01;
                set_exec[Regwrena] = 1'b1;
                source_lowbits = 1'b1;
                if (opcode[3])
                    source_areg = 1'b1;
                set[no_Flags] = 1'b1;
                if (setexecOPC) begin
                    dest_areg = 1'b1;
                    dest_hbits = 1'b1;
                end
            end else begin
                if (opcode[8] && opcode[5:4] == 2'b00)  // ADDX
                    build_bcd = 1'b1;
                else  // ADD
                    build_logical = 1'b1;
            end
        end else begin
            trap_illegal = 1'b1;
            trapmake = 1'b1;
        end
    end

    // 1110 - Shifts/Rotates/Bitfields
    4'b1110: begin
        if (opcode[7:6] == 2'b11) begin
            if (!opcode[11]) begin  // Memory shift/rotate
                if (opcode[5:4] != 2'b00 && (opcode[5:3] != 3'b111 || opcode[2:1] == 2'b00)) begin
                    if (BarrelShifter == 0)
                        set_exec[opcROT] = 1'b1;
                    else
                        set_exec[exec_BS] = 1'b1;
                    ea_build_now = 1'b1;
                    datatype = 2'b01;
                    set_rot_bits = opcode[10:9];
                    set_exec[ea_data_OP1] = 1'b1;
                    write_back = 1'b1;
                end else begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end
            end else begin  // Bitfield instructions
                if (BitField == 0 || (!CPU[1] && BitField == 2) ||
                    ((opcode[10:9] == 2'b11 || opcode[10:8] == 3'b010 || opcode[10:8] == 3'b100) &&
                     (opcode[5:3] == 3'b001 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100 ||
                      (opcode[5:3] == 3'b111 && opcode[2:1] != 2'b00))) ||
                    ((opcode[10:9] == 2'b00 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101) &&
                     (opcode[5:3] == 3'b001 || opcode[5:3] == 3'b011 || opcode[5:3] == 3'b100 ||
                      opcode[5:2] == 4'b1111))) begin
                    trap_illegal = 1'b1;
                    trapmake = 1'b1;
                end else begin
                    if (decodeOPC) begin
                        next_micro_state = nop;
                        set[get_2ndOPC] = 1'b1;
                        set[ea_build] = 1'b1;
                    end
                    set_exec[opcBF] = 1'b1;
                    if (opcode[10] || !opcode[8])
                        set_exec[opcBFwb] = 1'b1;
                    if (opcode[10:8] == 3'b111)  // BFINS
                        set_exec[ea_data_OP1] = 1'b1;
                    if (opcode[10:8] == 3'b010 || opcode[10:8] == 3'b100 ||
                        opcode[10:8] == 3'b110 || opcode[10:8] == 3'b111)
                        write_back = 1'b1;
                    ea_only = 1'b1;
                    if (opcode[10:8] == 3'b001 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101)
                        set_exec[Regwrena] = 1'b1;
                    if (opcode[4:3] == 2'b00) begin
                        if (opcode[10:8] != 3'b000)
                            set_exec[Regwrena] = 1'b1;
                        if (exec[ea_build]) begin
                            dest_2ndHbits = 1'b1;
                            source_2ndLbits = 1'b1;
                            set[get_bfoffset] = 1'b1;
                            setstate = 2'b01;
                        end
                    end
                    if (set[get_ea_now])
                        setstate = 2'b01;
                    if (exec[get_ea_now]) begin
                        dest_2ndHbits = 1'b1;
                        source_2ndLbits = 1'b1;
                        set[get_bfoffset] = 1'b1;
                        setstate = 2'b01;
                        set[mem_addsub] = 1'b1;
                        next_micro_state = bf1;
                    end
                    if (setexecOPC) begin
                        if (opcode[10:8] == 3'b111)  // BFINS
                            source_2ndHbits = 1'b1;
                        else
                            source_lowbits = 1'b1;
                        if (opcode[10:8] == 3'b001 || opcode[10:8] == 3'b011 || opcode[10:8] == 3'b101)
                            dest_2ndHbits = 1'b1;
                    end
                end
            end
        end else begin  // Register shift/rotate
            data_is_source = 1'b1;
            if (BarrelShifter == 0 || (!CPU[1] && BarrelShifter == 2)) begin
                set_exec[opcROT] = 1'b1;
                set_rot_bits = opcode[4:3];
                set_exec[Regwrena] = 1'b1;
                if (decodeOPC) begin
                    if (opcode[5]) begin
                        next_micro_state = rota1;
                        set[ld_rot_cnt] = 1'b1;
                        setstate = 2'b01;
                    end else begin
                        set_rot_cnt[2:0] = opcode[11:9];
                        if (opcode[11:9] == 3'b000)
                            set_rot_cnt[3] = 1'b1;
                        else
                            set_rot_cnt[3] = 1'b0;
                    end
                end
            end else begin
                set_exec[exec_BS] = 1'b1;
                set_rot_bits = opcode[4:3];
                set_exec[Regwrena] = 1'b1;
            end
        end
    end

    // 1111 - Line F trap / Coprocessor
    4'b1111: begin
        trap_1111 = 1'b1;
        trapmake = 1'b1;
    end

    default: begin
        trap_illegal = 1'b1;
        trapmake = 1'b1;
    end
    endcase

    //-------------------------------------------------------------------------
    // build_logical helper (used for AND, OR, EOR, CMP)
    //-------------------------------------------------------------------------
    if (build_logical) begin
        ea_build_now = 1'b1;
        if (!set_exec[opcCMP] && (!opcode[8] || opcode[5:4] == 2'b00))
            set_exec[Regwrena] = 1'b1;
        if (opcode[8]) begin
            write_back = 1'b1;
            set_exec[ea_data_OP1] = 1'b1;
        end else begin
            source_lowbits = 1'b1;
            if (opcode[3])  // use for cmp
                source_areg = 1'b1;
            if (setexecOPC)
                dest_hbits = 1'b1;
        end
    end

    //-------------------------------------------------------------------------
    // build_bcd helper (used for ABCD, SBCD)
    //-------------------------------------------------------------------------
    if (build_bcd) begin
        set_exec[use_XZFlag] = 1'b1;
        set_exec[ea_data_OP1] = 1'b1;
        write_back = 1'b1;
        source_lowbits = 1'b1;
        if (opcode[3]) begin
            if (decodeOPC) begin
                if (opcode[2:0] == 3'b111)
                    set[use_SP] = 1'b1;
                setstate = 2'b10;
                set[update_ld] = 1'b1;
                set[presub] = 1'b1;
                next_micro_state = op_AxAy;
                dest_areg = 1'b1;
            end
        end else begin
            dest_hbits = 1'b1;
            set_exec[Regwrena] = 1'b1;
        end
    end

    //-------------------------------------------------------------------------
    // Z_error handling (div by zero)
    //-------------------------------------------------------------------------
    if (set_Z_error) begin
        trapmake = 1'b1;
        if (!trapd)
            writePC = 1'b1;
    end

    // Microcode state execution
    case (micro_state)
        ld_nn: begin
            set[get_ea_now] = 1'b1;
            setnextpass = 1'b1;
            set[addrlong] = 1'b1;
        end

        st_nn: begin
            setstate = 2'b11;
            set[addrlong] = 1'b1;
            next_micro_state = nop;
        end

        ld_dAn1: begin
            set[get_ea_now] = 1'b1;
            setdisp = 1'b1;
            setnextpass = 1'b1;
        end

        ld_AnXn1: begin
            if (!brief[8] || extAddr_Mode == 0 || (!CPU[1] && extAddr_Mode == 2)) begin
                setdisp = 1'b1;
                setdispbyte = 1'b1;
                setstate = 2'b01;
                set[briefext] = 1'b1;
                next_micro_state = ld_AnXn2;
            end else begin
                if (brief[7])
                    set_Suppress_Base = 1'b1;
                else if (exec[dispouter])
                    set[dispouter] = 1'b1;
                if (!brief[5])
                    setstate = 2'b01;
                else begin
                    if (brief[4])
                        set[longaktion] = 1'b1;
                end
                next_micro_state = ld_229_1;
            end
        end

        ld_AnXn2: begin
            set[get_ea_now] = 1'b1;
            setdisp = 1'b1;
            setnextpass = 1'b1;
        end

        nopnop: next_micro_state = nop;

        nop: ;  // Do nothing

        trap0: begin
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            if (use_VBR_Stackframe) begin
                set[writePC_add] = 1'b1;
                datatype = 2'b01;
                next_micro_state = trap1;
            end else begin
                if (trap_interrupt || trap_trace || trap_berr)
                    writePC = 1'b1;
                datatype = 2'b10;
                next_micro_state = trap2;
            end
        end

        trap1: begin
            if (trap_interrupt || trap_trace)
                writePC = 1'b1;
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b10;
            next_micro_state = trap2;
        end

        trap2: begin
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b01;
            writeSR = 1'b1;
            if (trap_berr)
                next_micro_state = trap4;
            else
                next_micro_state = trap3;
        end

        trap3: begin
            set_vectoraddr = 1'b1;
            datatype = 2'b10;
            set[direct_delta] = 1'b1;
            set[directPC] = 1'b1;
            setstate = 2'b10;
            next_micro_state = nopnop;
        end

        trap00: begin  // TRAP format #2
            next_micro_state = trap0;
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b10;
        end

        trap4: begin
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b01;
            writeSR = 1'b1;
            next_micro_state = trap5;
        end

        trap5: begin
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b10;
            writeSR = 1'b1;
            next_micro_state = trap6;
        end

        trap6: begin
            set[presub] = 1'b1;
            setstackaddr = 1'b1;
            setstate = 2'b11;
            datatype = 2'b01;
            writeSR = 1'b1;
            next_micro_state = trap3;
        end

        st_dAn1: begin
            setstate = 2'b11;
            setdisp = 1'b1;
            next_micro_state = nop;
        end

        st_AnXn1: begin
            if (!brief[8] || extAddr_Mode == 0 || (!CPU[1] && extAddr_Mode == 2)) begin
                setdisp = 1'b1;
                setdispbyte = 1'b1;
                setstate = 2'b01;
                set[briefext] = 1'b1;
                next_micro_state = st_AnXn2;
            end else begin
                if (brief[7])
                    set_Suppress_Base = 1'b1;
                if (!brief[5])
                    setstate = 2'b01;
                else begin
                    if (brief[4])
                        set[longaktion] = 1'b1;
                end
                next_micro_state = st_229_1;
            end
        end

        st_AnXn2: begin
            setstate = 2'b11;
            setdisp = 1'b1;
            set[hold_dwr] = 1'b1;
            next_micro_state = nop;
        end

        ld_229_1: begin
            if (brief[5])
                setdisp = 1'b1;
            if (!brief[6] && !brief[2]) begin
                set[briefext] = 1'b1;
                setstate = 2'b01;
                if (brief[1:0] == 2'b00)
                    next_micro_state = ld_AnXn2;
                else
                    next_micro_state = ld_229_2;
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
            setdisp = 1'b1;
            setstate = 2'b10;
            setaddrvalue = 1'b1;
            set[longaktion] = 1'b1;
            next_micro_state = ld_229_3;
        end

        ld_229_3: begin
            set_Suppress_Base = 1'b1;
            set[dispouter] = 1'b1;
            if (!brief[1])
                setstate = 2'b01;
            else begin
                if (brief[0])
                    set[longaktion] = 1'b1;
            end
            next_micro_state = ld_229_4;
        end

        ld_229_4: begin
            if (brief[1])
                setdisp = 1'b1;
            if (!brief[6] && brief[2]) begin
                set[briefext] = 1'b1;
                setstate = 2'b01;
                next_micro_state = ld_AnXn2;
            end else begin
                set[get_ea_now] = 1'b1;
                setnextpass = 1'b1;
            end
        end

        st_229_1: begin
            if (brief[5])
                setdisp = 1'b1;
            if (!brief[6] && !brief[2]) begin
                set[briefext] = 1'b1;
                setstate = 2'b01;
                if (brief[1:0] == 2'b00)
                    next_micro_state = st_AnXn2;
                else
                    next_micro_state = st_229_2;
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
            setdisp = 1'b1;
            set[hold_dwr] = 1'b1;
            setstate = 2'b10;
            set[longaktion] = 1'b1;
            next_micro_state = st_229_3;
        end

        st_229_3: begin
            set[hold_dwr] = 1'b1;
            set_Suppress_Base = 1'b1;
            set[dispouter] = 1'b1;
            if (!brief[1])
                setstate = 2'b01;
            else begin
                if (brief[0])
                    set[longaktion] = 1'b1;
            end
            next_micro_state = st_229_4;
        end

        st_229_4: begin
            set[hold_dwr] = 1'b1;
            if (brief[1])
                setdisp = 1'b1;
            if (!brief[6] && brief[2]) begin
                set[briefext] = 1'b1;
                setstate = 2'b01;
                next_micro_state = st_AnXn2;
            end else begin
                setstate = 2'b11;
                next_micro_state = nop;
            end
        end

        bra1: begin
            if (exe_condition) begin
                TG68_PC_brw = 1'b1;
                next_micro_state = nop;
                if (!long_start)
                    skipFetch_r = 1'b1;
            end
        end

        bsr1: begin
            TG68_PC_brw = 1'b1;
            next_micro_state = nop;
        end

        bsr2: begin
            if (!long_start) begin
                TG68_PC_brw = 1'b1;
                skipFetch_r = 1'b1;
            end
            set[longaktion] = 1'b1;
            writePC = 1'b1;
            setstate = 2'b11;
            next_micro_state = nopnop;
            setstackaddr = 1'b1;
        end

        dbcc1: begin
            if (!exe_condition) begin
                Regwrena_now = 1'b1;
                if (c_out[1]) begin
                    skipFetch_r = 1'b1;
                    next_micro_state = nop;
                    TG68_PC_brw = 1'b1;
                end
            end
        end

        movem1: begin
            if (last_data_read[15:0] != 16'h0000) begin
                setstate = 2'b01;
                if (opcode[5:3] == 3'b100) begin
                    set[mem_addsub] = 1'b1;
                    if (CPU[1])
                        set[Regwrena] = 1'b1;
                end
                next_micro_state = movem2;
            end
        end

        movem2: begin
            if (!movem_run)
                setstate = 2'b01;
            else begin
                set[movem_action] = 1'b1;
                set[mem_addsub] = 1'b1;
                next_micro_state = movem2;
                if (!opcode[10]) begin
                    setstate = 2'b11;
                    set[write_reg] = 1'b1;
                end else
                    setstate = 2'b10;
            end
        end

        andi: begin
            if (opcode[5:4] != 2'b00)
                setnextpass = 1'b1;
        end

        op_AxAy: begin
            if (opcode[11:9] == 3'b111)
                set[use_SP] = 1'b1;
            set_direct_data = 1'b1;
            set[presub] = 1'b1;
            dest_hbits = 1'b1;
            dest_areg = 1'b1;
            setstate = 2'b10;
        end

        cmpm: begin
            if (opcode[11:9] == 3'b111)
                set[use_SP] = 1'b1;
            set_direct_data = 1'b1;
            set[postadd] = 1'b1;
            dest_hbits = 1'b1;
            dest_areg = 1'b1;
            setstate = 2'b10;
        end

        link1: begin
            setstate = 2'b11;
            source_areg = 1'b1;
            set[opcMOVE] = 1'b1;
            set[Regwrena] = 1'b1;
            next_micro_state = link2;
        end

        link2: begin
            setstackaddr = 1'b1;
            set[ea_data_OP2] = 1'b1;
        end

        unlink1: begin
            setstate = 2'b10;
            setstackaddr = 1'b1;
            set[postadd] = 1'b1;
            next_micro_state = unlink2;
        end

        unlink2: begin
            set[ea_data_OP2] = 1'b1;
        end

        pack1: begin
            if (opcode[2:0] == 3'b111)
                set[use_SP] = 1'b1;
            set[hold_ea_data] = 1'b1;
            set[update_ld] = 1'b1;
            setstate = 2'b10;
            set[presub] = 1'b1;
            next_micro_state = pack2;
            dest_areg = 1'b1;
        end

        pack2: begin
            if (opcode[11:9] == 3'b111)
                set[use_SP] = 1'b1;
            set[hold_ea_data] = 1'b1;
            set_direct_data = 1'b1;
            if (opcode[7:6] == 2'b01)
                datatype = 2'b00;
            else
                datatype = 2'b01;
            set[presub] = 1'b1;
            dest_hbits = 1'b1;
            dest_areg = 1'b1;
            setstate = 2'b10;
            next_micro_state = pack3;
        end

        pack3: begin
            skipFetch_r = 1'b1;
        end

        rte1: begin
            datatype = 2'b10;
            setstate = 2'b10;
            set[postadd] = 1'b1;
            setstackaddr = 1'b1;
            set[directPC] = 1'b1;
            if (!use_VBR_Stackframe || opcode[2]) begin
                set[update_FC] = 1'b1;
                set[direct_delta] = 1'b1;
            end
            next_micro_state = rte2;
        end

        rte2: begin
            datatype = 2'b01;
            set[update_FC] = 1'b1;
            if (use_VBR_Stackframe && !opcode[2]) begin
                setstate = 2'b10;
                set[postadd] = 1'b1;
                setstackaddr = 1'b1;
                next_micro_state = rte3;
            end else
                next_micro_state = nop;
        end

        rte3: begin
            setstate = 2'b01;
            next_micro_state = rte4;
        end

        rte4: begin
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

        rte5: begin
            next_micro_state = nop;
        end

        rtd1: begin
            next_micro_state = rtd2;
        end

        rtd2: begin
            setstackaddr = 1'b1;
            set[Regwrena] = 1'b1;
        end

        movec1: begin
            set[briefext] = 1'b1;
            set_writePCbig = 1'b1;
            if ((brief[11:0] == 12'h000 || brief[11:0] == 12'h001 || brief[11:0] == 12'h800 || brief[11:0] == 12'h801) ||
                (CPU[1] && (brief[11:0] == 12'h002 || brief[11:0] == 12'h802 || brief[11:0] == 12'h803 || brief[11:0] == 12'h804))) begin
                if (!opcode[0])
                    set[Regwrena] = 1'b1;
            end else begin
                trap_illegal = 1'b1;
                trapmake = 1'b1;
            end
        end

        movep1: begin
            setdisp = 1'b1;
            set[mem_addsub] = 1'b1;
            set[mem_byte] = 1'b1;
            set[OP1addr] = 1'b1;
            if (opcode[6])
                set[movepl] = 1'b1;
            if (!opcode[7])
                setstate = 2'b10;
            else
                setstate = 2'b11;
            next_micro_state = movep2;
        end

        movep2: begin
            if (opcode[6]) begin
                set[mem_addsub] = 1'b1;
                set[OP1addr] = 1'b1;
            end
            if (!opcode[7])
                setstate = 2'b10;
            else
                setstate = 2'b11;
            next_micro_state = movep3;
        end

        movep3: begin
            if (opcode[6]) begin
                set[mem_addsub] = 1'b1;
                set[OP1addr] = 1'b1;
                set[mem_byte] = 1'b1;
                if (!opcode[7])
                    setstate = 2'b10;
                else
                    setstate = 2'b11;
                next_micro_state = movep4;
            end else
                datatype = 2'b01;
        end

        movep4: begin
            if (!opcode[7])
                setstate = 2'b10;
            else
                setstate = 2'b11;
            next_micro_state = movep5;
        end

        movep5: begin
            datatype = 2'b10;
        end

        chk20: begin
            set[ea_data_OP1] = 1'b1;
            set[addsub] = 1'b1;
            set[alu_exec] = 1'b1;
            set[alu_setFlags] = 1'b1;
            setstate = 2'b01;
            next_micro_state = chk21;
        end

        chk21: begin
            dest_2ndHbits = 1'b1;
            if (sndOPC[15]) begin
                set_datatype = 2'b10;
                dest_LDRareg = 1'b1;
                if (opcode[10:9] == 2'b00)
                    set[opcEXTB] = 1'b1;
            end
            set[addsub] = 1'b1;
            set[alu_exec] = 1'b1;
            set[alu_setFlags] = 1'b1;
            setstate = 2'b01;
            next_micro_state = chk22;
        end

        chk22: begin
            dest_2ndHbits = 1'b1;
            set[ea_data_OP2] = 1'b1;
            if (sndOPC[15]) begin
                set_datatype = 2'b10;
                dest_LDRareg = 1'b1;
            end
            set[addsub] = 1'b1;
            set[alu_exec] = 1'b1;
            set[opcCHK2] = 1'b1;
            set[opcEXTB] = exec[opcEXTB];
            if (sndOPC[11]) begin
                setstate = 2'b01;
                next_micro_state = chk23;
            end
        end

        chk23: begin
            setstate = 2'b01;
            next_micro_state = chk24;
        end

        chk24: begin
            if (Flags[0])
                trapmake = 1'b1;
        end

        cas1: begin
            setstate = 2'b01;
            next_micro_state = cas2;
        end

        cas2: begin
            source_2ndMbits = 1'b1;
            if (Flags[2]) begin
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
            if (Flags[2])
                set[alu_setFlags] = 1'b1;
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
            if (Flags[2]) begin
                source_2ndMbits = 1'b1;
                set[write_reg] = 1'b1;
                dest_2ndHbits = 1'b1;
                dest_LDRareg = sndOPC[15];
                setstate = 2'b11;
                set[get_ea_now] = 1'b1;
                next_micro_state = cas27;
            end else begin
                set[hold_dwr] = 1'b1;
                set[hold_OP2] = 1'b1;
                dest_LDRLbits = 1'b1;
                set[alu_move] = 1'b1;
                set[Regwrena] = 1'b1;
                set[ea_data_OP2] = 1'b1;
                next_micro_state = cas28;
            end
        end

        cas27: begin
            source_LDRMbits = 1'b1;
            set[write_reg] = 1'b1;
            dest_LDRHbits = 1'b1;
            setstate = 2'b11;
            set[get_ea_now] = 1'b1;
            next_micro_state = nopnop;
        end

        cas28: begin
            dest_2ndLbits = 1'b1;
            set[alu_move] = 1'b1;
            set[Regwrena] = 1'b1;
        end

        mul1: begin
            if (opcode[15] || MUL_Mode == 0)
                set_rot_cnt = 6'b001110;
            else
                set_rot_cnt = 6'b011110;
            setstate = 2'b01;
            next_micro_state = mul2;
        end

        mul2: begin
            setstate = 2'b01;
            if (rot_cnt == 6'b000001)
                next_micro_state = mul_end1;
            else
                next_micro_state = mul2;
        end

        mul_end1: begin
            if (!opcode[15])
                set[hold_OP2] = 1'b1;
            datatype = 2'b10;
            set[opcMULU] = 1'b1;
            if (!opcode[15] && (MUL_Mode == 1 || MUL_Mode == 2)) begin
                dest_2ndHbits = 1'b1;
                set[write_lowlong] = 1'b1;
                if (sndOPC[10]) begin
                    setstate = 2'b01;
                    next_micro_state = mul_end2;
                end
                set[Regwrena] = 1'b1;
            end
            datatype = 2'b10;
        end

        mul_end2: begin
            dest_2ndLbits = 1'b1;
            set[write_reminder] = 1'b1;
            set[Regwrena] = 1'b1;
            set[opcMULU] = 1'b1;
        end

        div1: begin
            setstate = 2'b01;
            next_micro_state = div2;
        end

        div2: begin
            if ((OP2out[31:16] == 16'h0000 || opcode[15] || DIV_Mode == 0) && OP2out[15:0] == 16'h0000)
                set_Z_error = 1'b1;
            else
                next_micro_state = div3;
            set[ld_rot_cnt] = 1'b1;
            setstate = 2'b01;
        end

        div3: begin
            if (opcode[15] || DIV_Mode == 0)
                set_rot_cnt = 6'b001101;
            else
                set_rot_cnt = 6'b011101;
            setstate = 2'b01;
            next_micro_state = div4;
        end

        div4: begin
            setstate = 2'b01;
            if (rot_cnt == 6'b000001)
                next_micro_state = div_end1;
            else
                next_micro_state = div4;
        end

        div_end1: begin
            if (!Z_error && !set_V_Flag)
                set[Regwrena] = 1'b1;
            if (!opcode[15] && (DIV_Mode == 1 || DIV_Mode == 2)) begin
                dest_2ndLbits = 1'b1;
                set[write_reminder] = 1'b1;
                next_micro_state = div_end2;
                setstate = 2'b01;
            end
            set[opcDIVU] = 1'b1;
            datatype = 2'b10;
        end

        div_end2: begin
            if (exec[Regwrena])
                set[Regwrena] = 1'b1;
            else
                set[no_Flags] = 1'b1;
            dest_2ndHbits = 1'b1;
            set[opcDIVU] = 1'b1;
        end

        rota1: begin
            if (OP2out[5:0] != 6'b000000)
                set_rot_cnt = OP2out[5:0];
            else
                set_exec[rot_nop] = 1'b1;
        end

        bf1: begin
            setstate = 2'b10;
        end

        int1: begin
            // Handled at start of process
        end

        default: ;
    endcase
end

endmodule
