# ame-main — AME FP16-to-FP32 Matrix Multiply-Accumulate

| Property | Value |
| --- | --- |
| Profile identifier | `ame-main` |
| Mapping revision | 1 |
| Maturity | [draft](../../../contract.md#maturity-and-evidence) |
| RVISA revision | 0.2.0 |
| Family | [AME](../../README.md) |
| Upstream source | `riscv/riscv-attached-matrix-extension` @ `8d27acdcee7a189aad4e2907412e0c40a9d4b9e2` (tag `v0.6`) |

This profile maps rank-2 [tmma](../../../../spec/operations/matrix/tmma.md) with `fp16` inputs and an `fp32` accumulator onto the AME instruction `mmulacc.2d`. Both operands are independent matrix registers, and the accumulator is an accumulator register; neither lives in the vector register file, and the profile therefore also carries the ownership, datatype-descriptor, and transfer obligations of that separate state.

## Supported subset

| Item | Declared domain |
| --- | --- |
| Virtual operation | [tmma](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`), rank-2 inputs |
| Element tuple | `fp16` × `fp16` → `fp32` |
| Microtile geometry | single geometry: `M = N = 16` (`AME_NELEM = 256`), contraction depth 32 per instruction |
| `K` | positive multiple of 32 |
| `valid_k` | `0` or a multiple of 32, at most `K` |
| Layouts | `ALayout = rowmajor`, `BLayout = rowmajor`, `CLayout = rowmajor` |
| Batch modes | `cross`, `reduce`, `broadcast` — coincident, because rank-2 inputs have an empty batch prefix |
| Reduction order | `tree` only; the accumulator fold order is implementation-defined and deterministic |
| Target instruction | `mmulacc.2d acc, ms1, ms2` |

The extension's own equation is `C = C + A × B` over `N × N` logical squares, so the logical A operand is `[M,K]` and the logical B operand is `[K,N]`: B is *not* transposed, which distinguishes this profile's layout triple from the IME profile's.

## Geometry pins

| Parameter | Value | Derivation |
| --- | --- | --- |
| `AME_UNIT_DATATYPE_SIZE` | 32 bits | implementation parameter, pinned |
| `AME_NELEM` | 256 | `N²` with `N = sqrt(AME_NELEM) = 16`; must be a power of four |
| `AME_NUM_M_REGS` | 16 or 32 | any implemented value; the subset needs two operand registers and one staging register |
| `AME_NUM_ACC_REGS` | at least 1 | the subset needs one accumulator |
| `AME_MATRIX_REGISTER_SIZE` | 8192 bits (1 KiB) | `AME_NELEM × AME_UNIT_DATATYPE_SIZE` |
| Input datatype | `FP16`, rounding field RNE, `Inf = 1`, `Denorm = 1` | standard datatype encoding |
| Accumulator datatype | `FP32`, rounding field RNE, `Inf = 1`, `Denorm = 1` | standard datatype encoding |
| Input `pack_factor` | 2 | `AME_UNIT_DATATYPE_SIZE ÷ sizeof(FP16)` |
| `N_sq` per multiply | 2 | `max(pack_factor)` over the tensor operands |
| Contraction depth per instruction | 32 | `N_sq × N` |
| Operand register span | 1 register each | `N_sq ÷ pack_factor` |

A fragment is one instruction: a `16 × 32` A operand, a `32 × 16` B operand, and the `16 × 16` accumulator square.

## Documents

| Document | Content |
| --- | --- |
| [profile.yaml](profile.yaml) | Identity, parameter constraints, capabilities, limitations |
| [sources.md](sources.md) | Pinned source revision and claim provenance |
| [registers.md](registers.md) | `M`/`Md`, `Acc`/`Ad`, CSRs, coordinates, ownership, residency |
| [operands.md](operands.md) | `tmma` operand correspondence per instruction |
| [lowering.md](lowering.md) | Legality conditions and realization rules |
| [numerics.md](numerics.md) | Floating-point contract, precision, and equivalence |
| [conformance.yaml](conformance.yaml) | Rule coverage and evidence state |
| [CHANGELOG.md](CHANGELOG.md) | Revision history |

## Evidence state

No assembly, compilation, instruction inspection, simulation, or device execution has been performed for this revision; the [conformance record](conformance.yaml) lists each layer separately and only the documentation checks were executed.

Return to the [profile index](../README.md) or the [AME mapping guide](../../README.md).
