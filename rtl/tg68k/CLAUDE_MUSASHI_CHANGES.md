# TG68K FPU Changes Based on Musashi Reference Implementation

This document describes the FPU implementation improvements made by comparing the TG68K VHDL
implementation with the Musashi MC68000 emulator's FPU implementation (`m68kfpu.c`).

## Summary of Changes

All changes are based on the Musashi reference implementation at `~/repos/Musashi/m68kfpu.c`.

---

## 1. FBcc/FDBcc/FScc/FTRAPcc Condition Code Evaluation (CRITICAL FIX)

### Problem
The `fpu_condition_result` signal in `TG68KdotC_Kernel.vhd` was declared but never assigned,
causing FBcc (floating-point conditional branch) and related instructions to always evaluate
to false (condition code 0).

### Solution
Added a combinational process `fpu_condition_eval` that implements all 32 MC68881/68882
condition codes based on the FPSR condition flags (N, Z, I, NaN).

### Files Modified
- **TG68KdotC_Kernel.vhd** (lines 810-886): Added `fpu_condition_eval` process
- **TG68K_FPU.vhd** (lines 459-518): Added `evaluate_fpu_condition()` function

### Condition Codes Implemented
| Code | Name | Condition |
|------|------|-----------|
| 0x00 | F/SF | False |
| 0x01 | EQ/SEQ | Z |
| 0x02 | OGT/GT | !(NaN \| Z \| N) |
| 0x03 | OGE/GE | Z \| !(NaN \| N) |
| 0x04 | OLT/LT | N & !(NaN \| Z) |
| 0x05 | OLE/LE | Z \| (N & !NaN) |
| 0x06 | OGL/GL | !NaN & !Z |
| 0x07 | OR/GLE | !NaN |
| 0x08 | UN/NGLE | NaN |
| 0x09 | UEQ/NGL | NaN \| Z |
| 0x0A | UGT/NLE | NaN \| !(N \| Z) |
| 0x0B | UGE/NLT | NaN \| Z \| !N |
| 0x0C | ULT/NGE | NaN \| (N & !Z) |
| 0x0D | ULE/NGT | NaN \| Z \| N |
| 0x0E | NE/SNE | !Z |
| 0x0F | T/ST | True |

Reference: Musashi `m68kfpu.c` TEST_CONDITION function (lines 300-360)

---

## 2. Improved Transcendental Functions

### Files Modified
- **TG68K_FPU_Transcendental.vhd**

### FSINH (Hyperbolic Sine)
- **Before**: Simplified approximation returning x for small values
- **After**: Taylor series implementation: sinh(x) = x + x³/6 + x⁵/120 + ...

### FCOSH (Hyperbolic Cosine)
- **Before**: Simplified approximation returning 1 for small values
- **After**: Taylor series implementation: cosh(x) = 1 + x²/2 + x⁴/24 + ...

### FTANH (Hyperbolic Tangent)
- **Before**: Simplified approximation with basic saturation
- **After**: Taylor series with proper saturation: tanh(x) = x - x³/3 + 2x⁵/15 - ...
- Added early saturation check for large |x| (|x| >= 8 returns ±1.0)

### FASIN (Arc Sine)
- **Before**: Returns x for small values, π/2 for larger values
- **After**: Taylor series: asin(x) = x + x³/6 + 3x⁵/40 + ...
- Added special case handling for |x| = 1 returning ±π/2

### FACOS (Arc Cosine)
- **Before**: Returns π/2 for most values
- **After**: Uses identity acos(x) = π/2 - asin(x) with full Taylor series
- Added FP_PI_2 constant for π/2 = 0x3FFFC90FDAA22168C235

---

## 3. FRESTORE NULL Frame Handling (Musashi Compatibility)

### Problem
FRESTORE on a NULL frame (format byte = 0x00) was only returning to idle state without
resetting the FPU. According to Musashi, a NULL frame should "reboot the FPU".

### Solution

#### FRESTORE NULL Reset Behavior
When FRESTORE receives a NULL frame:
1. Clear FPCR, FPSR, FPIAR to 0
2. Set all FP registers (FP0-FP7) to quiet NaN (0x7FFFC000000000000000)
3. Set `fpu_just_reset` flag

#### FSAVE After FRESTORE NULL
Per Musashi comment: "Mac IIci at 408458e6 wants an FSAVE of a just-restored NULL frame
to also be NULL"

Added `fpu_just_reset` flag that:
- Gets set when FRESTORE NULL is executed
- Gets cleared when any FPU operation starts (in FPU_DECODE state)
- Causes FSAVE to return NULL frame (4 bytes) regardless of register state

### Files Modified
- **TG68K_FPU.vhd**:
  - Line 211: Added `fpu_just_reset` signal declaration
  - Lines 976-980: Updated frame format process to check `fpu_just_reset` first
  - Lines 1234: Initialize `fpu_just_reset` on hardware reset
  - Lines 1317-1319: Clear `fpu_just_reset` on FPU_DECODE
  - Lines 3147-3162: FRESTORE NULL now resets FPU and sets flag

Reference: Musashi `m68kfpu.c` do_frestore_null() function (lines 1910-1927)

---

## Existing Implementations (No Changes Needed)

The following were reviewed and found to be correctly implemented:

### FSAVE Frame Formats
The VHDL implementation correctly supports MC68882 frame formats:
- NULL frame (0x00): 4 bytes
- IDLE frame (0x60): 60 bytes
- BUSY frame (0xD8): 216 bytes

Note: Musashi uses simpler 68881 format (0x18 = 28 bytes), but the VHDL MC68882
implementation is more comprehensive.

### FSIN, FCOS, FATAN
Already use CORDIC algorithm - production quality implementation.

### FETOX, FETOXM1 (Exponential)
Already have proper Taylor series implementations with overflow/underflow handling.

### FLOGN, FLOGNP1 (Natural Logarithm)
Already have Taylor series implementations for ln(x) and ln(x+1).

---

## Commits

1. `868c674` - complete FPU implementation with full condition codes and improved transcendentals
2. `[pending]` - fix FRESTORE NULL to properly reset FPU per Musashi reference

---

## Testing Recommendations

1. **FBcc/FDBcc Instructions**: Test all 32 condition codes with various FPSR states
2. **Transcendental Functions**: Verify accuracy for edge cases:
   - sinh(0), sinh(small), sinh(large)
   - cosh(0), cosh(1), cosh(large)
   - tanh(-10), tanh(0), tanh(10)
   - asin(-1), asin(0), asin(0.5), asin(1)
   - acos(-1), acos(0), acos(0.5), acos(1)
3. **FRESTORE NULL**: Verify FP registers are NaN and control registers are 0 after FRESTORE NULL
4. **FSAVE after FRESTORE NULL**: Verify NULL frame is returned

---

## Reference

Musashi MC68000 Emulator: https://github.com/kstenerud/Musashi
- FPU Implementation: `m68kfpu.c`
- Softfloat Library: `softfloat/softfloat.c`
