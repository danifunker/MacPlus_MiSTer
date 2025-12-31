# TG68K CPU Mode Reference

This document describes the CPU mode encoding and features for the TG68K processor core.

## CPU Mode Encoding

The `CPU` port is a 2-bit signal that selects the processor mode:

| Value | Processor | Description |
|-------|-----------|-------------|
| `00`  | MC68000   | Basic 68000 processor |
| `01`  | MC68010   | 68010 with VBR, loop mode |
| `10`  | MC68020   | 68020 with 32-bit features, NO PMMU |
| `11`  | MC68030   | 68030 with PMMU and cache |

## Bit Meanings

- **cpu(0)** - Bit 0: Enables 68010+ features
- **cpu(1)** - Bit 1: Enables 68020/030 features

The bits work together:
- `cpu(0)='1'` alone (mode `01`) = 68010 features only
- `cpu(1)='1'` alone (mode `10`) = 68020 features (but NOT 68010 loop mode)
- Both bits set (mode `11`) = All features including PMMU

## Features by Mode

### MC68000 (cpu=00)

Basic features:
- 16-bit multiply/divide (MULS, MULU, DIVS, DIVU)
- Standard addressing modes
- User/Supervisor modes
- Autovector and non-autovector interrupts

### MC68010 (cpu=01)

Adds to 68000:
- **VBR** (Vector Base Register) - relocatable exception vector table
- **SFC/DFC** registers - Source/Destination Function Codes
- **MOVEC** instruction - move to/from control registers
- **MOVES** instruction - move to/from address space
- **MOVE from CCR** instruction
- Extended stack frames for bus/address errors
- Loop mode (implicit single-instruction loops)
- MOVE from SR requires supervisor mode

### MC68020 (cpu=10)

Adds to 68010 (except loop mode):
- **32-bit multiply** (MULS.L, MULU.L)
- **32-bit divide** (DIVS.L, DIVU.L, DIVSL.L, DIVUL.L)
- **Bitfield instructions** (BFCHG, BFCLR, BFEXTS, BFEXTU, BFFFO, BFINS, BFSET, BFTST)
- **Extended addressing modes** (scaled index, memory indirect)
- **EXTB.L** instruction (sign-extend byte to long)
- **TRAPcc** instructions (conditional trap)
- **CHK2/CMP2** with long operands
- **PACK/UNPK** instructions (BCD conversion)
- **RTD** instruction (return and deallocate)
- **CAS/CAS2** instructions (compare and swap)
- **Barrel shifter** for fast rotations
- **MSP/ISP** separate stack pointers
- **CACR/CAAR** cache control registers
- **cpSAVE/cpRESTORE** coprocessor interface
- Coprocessor Interface Registers (CIR) for external FPU

Does NOT include:
- PMMU instructions (PMOVE, PFLUSH, PTEST, PLOAD)
- Built-in MMU translation

### MC68030 (cpu=11)

Adds to 68020:
- **Built-in PMMU** with:
  - PMOVE instruction (move to/from MMU registers)
  - PFLUSH instruction (flush ATC entries)
  - PTEST instruction (test MMU translation)
  - PLOAD instruction (load ATC entry)
- **MMU Registers**:
  - TC (Translation Control)
  - TT0, TT1 (Transparent Translation)
  - CRP, SRP (Root Pointer)
  - MMUSR (MMU Status)
- **On-chip caches** (instruction and data)
- Full address translation with page tables

## Control Register Availability

| Register | 68000 | 68010 | 68020 | 68030 |
|----------|-------|-------|-------|-------|
| SFC      | -     | Yes   | Yes   | Yes   |
| DFC      | -     | Yes   | Yes   | Yes   |
| USP      | -     | Yes   | Yes   | Yes   |
| VBR      | -     | Yes   | Yes   | Yes   |
| CACR     | -     | -     | Yes   | Yes   |
| CAAR     | -     | -     | Yes   | Yes   |
| MSP      | -     | -     | Yes   | Yes   |
| ISP      | -     | -     | Yes   | Yes   |
| TC       | -     | -     | -     | Yes   |
| TT0/TT1  | -     | -     | -     | Yes   |
| CRP/SRP  | -     | -     | -     | Yes   |
| MMUSR    | -     | -     | -     | Yes   |

## FPU Support

The FPU is controlled separately via the `FPU_Enable` generic/parameter:
- `FPU_Enable=0` - No FPU, F-line instructions trap
- `FPU_Enable=1` - MC68881/68882 compatible FPU

FPU is available with any CPU mode (68000, 68010, 68020, 68030).

For 68020 mode, the FPU communicates via Coprocessor Interface Registers (CIR) in CPU space (FC=7). This is the hardware-accurate method used by real 68020+68881 systems and detected by pre-1992 Mac ROMs.

## Historical Notes

### Minimig/AGA Heritage

The TG68K core originated from the Minimig project which used `cpu="10"` for 68030 emulation. This project updated the encoding to properly distinguish 68020 (no PMMU) from 68030 (with PMMU).

### Mac II Emulation

The Macintosh II shipped with a 68020 processor. Using `cpu=2'b10` (68020 mode) is historically accurate. The Mac II could optionally have:
- External 68851 PMMU (rare)
- External 68881/68882 FPU

## Code Patterns

### Checking for 68010+ features
```vhdl
IF cpu(0)='1' OR cpu(1)='1' THEN
    -- 68010, 68020, or 68030
END IF;
```

### Checking for 68020+ features
```vhdl
IF cpu(1)='1' THEN
    -- 68020 or 68030
END IF;
```

### Checking for 68030 with PMMU
```vhdl
IF cpu="11" THEN
    -- 68030 only
END IF;
```

## Files Reference

- `TG68KdotC_Kernel.vhd` - Main CPU kernel with feature checks
- `TG68K.vhd` - VHDL wrapper with bus interface
- `tg68k.v` - Verilog wrapper for MiSTer integration
- `TG68K_PMMU_030.vhd` - PMMU implementation (68030 only)
- `TG68K_FPU.vhd` - FPU implementation (all modes with FPU_Enable=1)
