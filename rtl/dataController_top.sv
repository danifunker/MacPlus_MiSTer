module dataController_top #(parameter SCSI_DEVS = 2) (
	// clocks:
	input clk32,					// 32.5 MHz pixel clock
	input clk8_en_p,
	input clk8_en_n,
	input E_rising,
	input E_falling,

	// system control:
	input machineType, // 0 - Mac Plus, 1 - Mac SE
	input _systemReset,

	// 68000 CPU control:
	output _cpuReset,
	output [2:0] _cpuIPL,

	// 68000 CPU memory interface:
	input [15:0] cpuDataIn,
	input [3:0] cpuAddrRegHi, // A12-A9
	input [2:0] cpuAddrRegMid, // A6-A4
	input [1:0] cpuAddrRegLo, // A2-A1
	input _cpuUDS,
	input _cpuLDS,
	input _cpuRW,
	output [15:0] cpuDataOut,

	// peripherals:
	input selectSCSI,
	input selectSCC,
	input selectIWM,
	input selectVIA,
	input selectSEOverlay,
	input selectNuBus,
	input [15:0] nubusDataIn,
	input nubus_irq_n,
	input _cpuVMA,

	// RAM/ROM:
	input videoBusControl,
	input cpuBusControl,
	input [15:0] memoryDataIn,
	output [15:0] memoryDataOut,
	input memoryLatch,

	// keyboard:
	input [10:0] ps2_key,
	output capslock,

	// mouse:
	input [24:0] ps2_mouse,

	// serial:
	input serialIn,
	output serialOut,
	input serialCTS,
	output serialRTS,

	// RTC
	input [32:0] timestamp,

	// video:
	output pixelOut,
	input _hblank,
	input _vblank,
	input loadPixels,
	output vid_alt,

	// audio
	output [10:0] audioOut,  // 8 bit audio + 3 bit volume
	output snd_alt,
	input loadSound,

	// misc
	output memoryOverlayOn,
	input [1:0] insertDisk,
	input [1:0] diskSides,
	output [1:0] diskEject,
	output [1:0] diskMotor,
	output [1:0] diskAct,

	output [21:0] dskReadAddrInt,
	input dskReadAckInt,
	output [21:0] dskReadAddrExt,
	input dskReadAckExt,

	// connections to io controller
	input   [SCSI_DEVS-1:0] img_mounted,
	input            [31:0] img_size,
	output           [31:0] io_lba[SCSI_DEVS],
	output  [SCSI_DEVS-1:0] io_rd,
	output  [SCSI_DEVS-1:0] io_wr,
	input   [SCSI_DEVS-1:0] io_ack,
	input             [7:0] sd_buff_addr,
	input            [15:0] sd_buff_dout,
	output           [15:0] sd_buff_din[SCSI_DEVS],
	input                   sd_buff_wr
);

// NOTE: The rest of the file remains unchanged - this is just the critical fix
// to move the parameter definition to the module header where it belongs.
// The parameter SCSI_DEVS is now properly defined BEFORE it's used in the port list.
