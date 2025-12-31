/*
 68000/68010/68020/68030 compatible bus-wrapper for TG68K
 With 68030 cache support
 */

module tg68k #(
    parameter FPU_Enable = 1
) (
	input clk,
	input reset,
	input phi1,
	input phi2,
	input [1:0] cpu,

	input  dtack_n,
	output rw_n,
	output as_n,
	output uds_n,
	output lds_n,
	output [2:0] fc,
	output reset_n,

	output reg E,
	input E_div,
	output E_PosClkEn,
	output E_NegClkEn,
	output vma_n,
	input vpa_n,

	input br_n,
	output bg_n,
	input bgack_n,

	input [2:0] ipl,
	input berr,
	input [15:0] din,
	output [15:0] dout,
	output reg [31:0] addr,

	// Cache memory interface (directly to SDRAM controller)
	output cache_req,
	output [31:0] cache_addr,
	input [15:0] cache_data,
	input cache_ack,
	output cache_burst,
	output [2:0] cache_burst_len,

	// Cache status
	output cache_hit,
	output cache_miss
);

wire  [1:0] tg68_busstate;
wire        tg68_clkena = phi1 && (s_state == 7 || tg68_busstate == 2'b01);
wire [31:0] tg68_addr;
wire [15:0] tg68_din;
reg  [15:0] tg68_din_r;
wire        tg68_uds_n;
wire        tg68_lds_n;
wire        tg68_rw;
wire        skipFetch;

// Cache control signals from kernel
wire        cache_inv_req;
wire [1:0]  cache_op_scope;
wire [1:0]  cache_op_cache;
wire        cacr_ie;
wire        cacr_de;
wire        cacr_ifreeze;
wire        cacr_dfreeze;
wire        cacr_ibe;
wire        cacr_dbe;
wire        cacr_wa;
wire [31:0] cache_op_addr;

// PMMU address signals (directly from kernel for future PMMU support)
wire [31:0] pmmu_addr_log;
wire [31:0] pmmu_addr_phys;
wire        pmmu_cache_inhibit;

// 68030 mode detection - only 68030 has integrated cache and PMMU
// MC68020 uses external MC68851 PMMU (not implemented here)
wire is_68030 = (cpu == 2'b11);

// Gated PMMU signals - bypass translation for non-68030 modes
// For 68020/68010/68000: use logical address directly, no cache inhibit
wire [31:0] pmmu_addr_gated = is_68030 ? pmmu_addr_phys : tg68_addr;
wire        pmmu_cache_inhibit_gated = is_68030 & pmmu_cache_inhibit;

// Cache is enabled when CPU is 68030 and either I-cache or D-cache enabled
wire cache_enabled = is_68030 & (cacr_ie | cacr_de);

// Cache interface signals
wire [31:0] i_cache_data;
wire        i_cache_hit;
wire        i_fill_req;
wire [31:0] i_fill_addr;
wire        d_cache_hit;
wire        d_fill_req;
wire [31:0] d_fill_addr;

// Instruction cache request when fetching (busstate=00) and I-cache enabled (68030 only)
wire i_cache_req = (tg68_busstate == 2'b00) & is_68030 & cacr_ie;

// Data cache request when reading/writing (busstate=10 or 11) and D-cache enabled (68030 only)
wire d_cache_req = (tg68_busstate[1]) & is_68030 & cacr_de;

// Cache fill state machine
reg         cache_fill_active;
reg [2:0]   cache_fill_count;
reg [127:0] cache_fill_buffer;
reg         cache_fill_complete;

// Byte enables for data cache writes
wire [3:0] byte_enables = (tg68_uds_n == 1'b0 && tg68_lds_n == 1'b0) ? 4'b1111 :
                          (tg68_uds_n == 1'b0) ? 4'b1100 :
                          (tg68_lds_n == 1'b0) ? 4'b0011 : 4'b0000;

// The tg68k core doesn't reliably support mixed usage of autovector and non-autovector
// interrupts, so the TG68K kernel switched to non-autovector interrupts, and the 
// auto-vectors are provided here.
wire auto_iack = fc == 3'b111 && !vpa_n;
wire [7:0] auto_vector = {4'h1, 1'b1, addr[3:1]};
assign tg68_din = auto_iack ? {auto_vector, auto_vector} : din;

reg         uds_n_r;
reg         lds_n_r;
reg         rw_r;
reg         as_n_r;

assign      as_n = as_n_r;
assign      uds_n = uds_n_r;
assign      lds_n = lds_n_r;
assign      rw_n = rw_r;

reg   [2:0] s_state;

always @(posedge clk) begin
	if (reset) begin
		s_state <= 0;
		as_n_r <= 1;
		rw_r <= 1;
		uds_n_r <= 1;
		lds_n_r <= 1;
	end else begin
		addr <= tg68_addr;

		if (phi1) begin

			if (s_state != 4) s_state <= s_state + 1'd1;
			if (busreq_ack || bus_granted) s_state <= s_state;
			if (tg68_busstate == 2'b01) s_state <= 0;

			case (s_state)
				1: if (tg68_busstate != 2'b01) begin
					rw_r <= tg68_rw;
					if (tg68_rw) begin
						uds_n_r <= tg68_uds_n;
						lds_n_r <= tg68_lds_n;
					end
					as_n_r <= 0;
				end
				3: if (tg68_busstate != 2'b01) begin
					if (!tg68_rw) begin
						uds_n_r <= tg68_uds_n;
						lds_n_r <= tg68_lds_n;
					end
				end
				7: rw_r <= 1;
				default :;
			endcase

		end else if (phi2) begin

			if (s_state != 4 || tg68_busstate == 2'b01 || !dtack_n || xVma || berr)
				s_state <= s_state + 1'd1;
			if ((busreq_ack || bus_granted) && !busrel_ack) s_state <= s_state;
			if (tg68_busstate == 2'b01) s_state <= 0;

			case (s_state)

				6: begin
					tg68_din_r <= tg68_din;
					uds_n_r <= 1;
					lds_n_r <= 1;
					as_n_r <= 1;
				end
				default :;
			endcase

		end
	end
end

// from FX68K
// E clock and counter, VMA
reg [3:0] eCntr;
reg rVma;
reg Vpai;
assign vma_n = rVma;

// Internal stop just one cycle before E falling edge
wire xVma = ~rVma & (eCntr == 8) & en_E;

assign E_PosClkEn = (phi2 & (eCntr == 5) & en_E);
assign E_NegClkEn = (phi2 & (eCntr == 9) & en_E);

reg en_E;

always @( posedge clk) begin
	if (reset) begin
		E <= 1'b0;
		eCntr <=0;
		rVma <= 1'b1;
		en_E <= 1'b1;
	end else begin
		if (phi1) begin
			Vpai <= vpa_n;
			if (E_div) en_E <= !en_E; else en_E <= 1'b1;
		end

		if (phi2 & en_E) begin
			if (eCntr == 9)
				E <= 1'b0;
			else if (eCntr == 5)
				E <= 1'b1;

			if (eCntr == 9)
				eCntr <= 0;
			else
				eCntr <= eCntr + 1'b1;
		end

		if (phi2 & s_state != 0 & ~Vpai & (eCntr == 3) & en_E)
			rVma <= 1'b0;
		else if (phi1 & eCntr == 0 & en_E)
			rVma <= 1'b1;
	end
end

// Bus arbitration
reg bg_n_r;
assign bg_n = bg_n_r;

// process the bus request at the start of any bus cycle
// (start at only instruction fetch doesn't work well with ACSI DMA)
wire busreq_ack = !br_n /*&& tg68_busstate == 0*/ && s_state == 0;
wire busrel_ack = bus_acked && !bgack;

reg bgack, bus_granted, bus_acked, bus_acked_d;

always @(posedge clk) begin
	if (reset) begin
		bg_n_r <= 1;
		bus_granted <= 0;
		bus_acked <= 0;
	end else begin
		if (phi1) begin
			bgack <= ~bgack_n;
			bus_acked_d <= bus_acked;
		end
		if (phi2) begin
			if (busreq_ack) begin
				bg_n_r <= 0;
				bus_granted <= 1;
				bus_acked <= bgack;
			end
			if (bus_granted && bgack) bus_acked <= 1;
			if (bus_granted && bus_acked_d) bg_n_r <= 1;
			if (busrel_ack) begin
				bus_acked <= 0;
				bus_granted <= 0;
			end
		end
	end
end

TG68KdotC_Kernel #(
	.SR_Read(2),           // 0=>user, 1=>privileged, 2=>switchable with CPU(0)
	.VBR_Stackframe(2),    // 0=>no, 1=>yes/extended, 2=>switchable with CPU(0)
	.extAddr_Mode(2),      // 0=>no, 1=>yes, 2=>switchable with CPU(1)
	.MUL_Mode(2),          // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no MUL
	.DIV_Mode(2),          // 0=>16Bit, 1=>32Bit, 2=>switchable with CPU(1), 3=>no DIV
	.BitField(2),          // 0=>no, 1=>yes, 2=>switchable with CPU(1)
	.BarrelShifter(2),     // 0=>no, 1=>yes, 2=>switchable with CPU(1)
	.MUL_Hardware(1),      // 0=>no, 1=>yes
	.FPU_Enable(FPU_Enable) // 0=>no FPU, 1=>FPU enabled
) tg68k (
	.clk            ( clk           ),
	.nReset         ( ~reset        ),
	.clkena_in      ( tg68_clkena   ),
	.data_in        ( tg68_din_r    ),
	.IPL            ( ipl           ),
	.IPL_autovector ( 1'b0          ),
	.berr           ( berr          ),
	.clr_berr       ( /*tg68_clr_berr*/ ),
	.CPU            ( cpu           ), // 00->68000  01->68010  10->68020  11->68030
	.addr_out       ( tg68_addr     ),
	.data_write     ( dout          ),
	.nUDS           ( tg68_uds_n    ),
	.nLDS           ( tg68_lds_n    ),
	.nWr            ( tg68_rw       ),
	.busstate       ( tg68_busstate ), // 00-> fetch code 10->read data 11->write data 01->no memaccess
	.nResetOut      ( reset_n       ),
	.FC             ( fc            ),
	.skipFetch      ( skipFetch     ),
	// Cache control interface (68030)
	.cache_inv_req  ( cache_inv_req   ),
	.cache_op_scope ( cache_op_scope  ),
	.cache_op_cache ( cache_op_cache  ),
	.cacr_ie        ( cacr_ie         ),
	.cacr_de        ( cacr_de         ),
	.cacr_ifreeze   ( cacr_ifreeze    ),
	.cacr_dfreeze   ( cacr_dfreeze    ),
	.cacr_ibe       ( cacr_ibe        ),
	.cacr_dbe       ( cacr_dbe        ),
	.cacr_wa        ( cacr_wa         ),
	// PMMU address interface (68030)
	.pmmu_addr_log  ( pmmu_addr_log   ),
	.pmmu_addr_phys ( pmmu_addr_phys  ),
	.pmmu_cache_inhibit ( pmmu_cache_inhibit ),
	// Cache operation address (68030)
	.cache_op_addr  ( cache_op_addr   )
);

// 68030 Cache instantiation (active only in 68030 mode)
TG68K_Cache_030 cache_inst (
	.clk            ( clk             ),
	.nreset         ( ~reset & is_68030 ),  // Keep in reset when not 68030
	// Cache Control (from CACR register, gated for 68030)
	.cacr_ie        ( cacr_ie & is_68030 ),
	.cacr_de        ( cacr_de & is_68030 ),
	.cacr_ifreeze   ( cacr_ifreeze    ),
	.cacr_dfreeze   ( cacr_dfreeze    ),
	.cacr_wa        ( cacr_wa         ),
	// Cache Control Instructions (gated for 68030)
	.inv_req        ( cache_inv_req & is_68030 ),
	.cache_op_scope ( cache_op_scope  ),
	.cache_op_cache ( cache_op_cache  ),
	.cache_op_addr  ( cache_op_addr   ),
	// Instruction Cache Interface (gated for 68030 only)
	.i_addr         ( tg68_addr       ),
	.i_addr_phys    ( pmmu_addr_gated ),
	.i_req          ( i_cache_req     ),
	.i_cache_inhibit( pmmu_cache_inhibit_gated ),
	.i_data         ( i_cache_data    ),
	.i_hit          ( i_cache_hit     ),
	.i_fill_req     ( i_fill_req      ),
	.i_fill_addr    ( i_fill_addr     ),
	.i_fill_data    ( cache_fill_buffer ),
	.i_fill_valid   ( cache_fill_complete ),
	// Data Cache Interface (gated for 68030 only)
	.d_addr         ( tg68_addr       ),
	.d_addr_phys    ( pmmu_addr_gated ),
	.d_req          ( d_cache_req     ),
	.d_we           ( ~tg68_rw        ),
	.d_cache_inhibit( pmmu_cache_inhibit_gated ),
	.d_be           ( byte_enables    ),
	.d_data_in      ( {dout, dout}    ),  // Replicate 16-bit to 32-bit
	.d_data_out     ( /* unused for now */ ),
	.d_hit          ( d_cache_hit     ),
	.d_fill_req     ( d_fill_req      ),
	.d_fill_addr    ( d_fill_addr     ),
	.d_fill_data    ( cache_fill_buffer ),
	.d_fill_valid   ( cache_fill_complete )
);

// Cache hit/miss outputs
assign cache_hit = cache_enabled & ((i_cache_hit & i_cache_req) | (d_cache_hit & d_cache_req));
assign cache_miss = cache_enabled & (((~i_cache_hit) & i_cache_req) | ((~d_cache_hit) & d_cache_req));

// Cache memory interface - connect to external SDRAM controller
assign cache_req = cache_enabled & (i_fill_req | d_fill_req);
assign cache_addr = i_fill_req ? i_fill_addr : d_fill_addr;

// Burst mode control - use burst when IBE/DBE enabled in CACR
assign cache_burst = cache_enabled & ((i_fill_req & cacr_ibe) | (d_fill_req & cacr_dbe));
assign cache_burst_len = 3'b111;  // Always request 8 words (128-bit cache line)

// Cache fill process - accumulate 8 words into 128-bit cache line
// MC68030 cache lines are 16 bytes (128 bits) = 8 words of 16 bits each
always @(posedge clk) begin
	if (reset) begin
		cache_fill_active <= 1'b0;
		cache_fill_count <= 3'b000;
		cache_fill_buffer <= 128'b0;
		cache_fill_complete <= 1'b0;
	end else begin
		// Default: clear completion pulse
		cache_fill_complete <= 1'b0;

		if (cache_req && cache_ack) begin
			// Start cache fill sequence
			if (!cache_fill_active) begin
				cache_fill_active <= 1'b1;
				cache_fill_count <= 3'b000;
			end
		end

		if (cache_fill_active && cache_ack) begin
			// Accumulate 16-bit words into 128-bit cache line (8 words total)
			case (cache_fill_count)
				3'b000: cache_fill_buffer[15:0]    <= cache_data;
				3'b001: cache_fill_buffer[31:16]   <= cache_data;
				3'b010: cache_fill_buffer[47:32]   <= cache_data;
				3'b011: cache_fill_buffer[63:48]   <= cache_data;
				3'b100: cache_fill_buffer[79:64]   <= cache_data;
				3'b101: cache_fill_buffer[95:80]   <= cache_data;
				3'b110: cache_fill_buffer[111:96]  <= cache_data;
				3'b111: begin
					cache_fill_buffer[127:112] <= cache_data;
					cache_fill_active <= 1'b0;
					// Generate completion pulse AFTER last word is stored
					cache_fill_complete <= 1'b1;
				end
			endcase

			if (cache_fill_count != 3'b111) begin
				cache_fill_count <= cache_fill_count + 1'b1;
			end
		end
	end
end

endmodule
