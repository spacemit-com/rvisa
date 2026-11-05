# ime-main — IME int8-to-int32 Matrix Multiply-Accumulate

| Property | Value |
| --- | --- |
| Profile identifier | `ime-main` |
| Mapping revision | 1 |
| Maturity | [draft](../../../contract.md#maturity-and-evidence) |
| RVISA revision | 0.2.0 |
| Family | [IME](../../README.md) |
| Upstream source | `riscv/integrated-matrix-extension` @ `6effbcae3204e5a8a9c9d15ff53959918144870c` |

This profile maps rank-2 [tmma](../../../../spec/operations/matrix/tmma.md) with signed `int8` inputs and an `int32` accumulator onto the `Zvvi8i32mm` extension instruction `vqmmacc.vv`, using only vector registers. The accumulator tile and both input tiles are resident in the vector register file; the profile introduces no new architectural state beyond the IME fields of `vtype`.

## Supported subset

| Item | Declared domain |
| --- | --- |
| Virtual operation | [tmma](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`), rank-2 inputs |
| Element tuple | signed `int8` × signed `int8` → `int32`, no output format field |
| Microtile geometry | single geometry: `M = N = 8`, `K_eff = 16` per instruction |
| `K` | positive multiple of 16 |
| `valid_k` | `0` or a multiple of 16, at most `K` |
| Layouts | `ALayout = rowmajor`, `BLayout = colmajor`, `CLayout = rowmajor` |
| Batch modes | `cross`, `reduce`, `broadcast` — coincident, because rank-2 inputs have an empty batch prefix |
| Reduction order | `ordered` and `tree` are both legal (integer accumulation is modular; see [numerics](numerics.md)) |
| Target instruction | `vqmmacc.vv vd, vs1, vs2` (`W = 4`) |

Everything else is excluded and diagnosed; see [limitations](profile.yaml) and [lowering](lowering.md#diagnostics).

## Geometry pins

The single microtile geometry requires one implementation parameter set, recorded in [profile.yaml](profile.yaml):

| Parameter | Value | Derivation |
| --- | --- | --- |
| `VLEN` | 1024 bits | implementation parameter, pinned |
| `vtype.vsew` | 32 (accumulator and `C` element width) | element tuple |
| `vtype.lambda[2:0]` | 4 | selected tile-layout parameter |
| `vtype.vlmul` | `000`, i.e. `LMUL = 1` | integer `LMUL` in `{1,2,4,8}` |
| `W` | 4 | fixed by the mnemonic (`vqmmacc.vv`) |
| `M_tile` = `N_tile_max` | 8 | `VLEN ÷ (SEW × lambda)` |
| `K_eff` | 16 | `lambda × W × LMUL` |
| `EMUL_C` | 2 | `VLEN ÷ (SEW × lambda²)` |
| Compute `vl` | 32 | `lambda × LMUL × N_tile` with `N_tile = 8` |

The derivation of these quantities is the [upstream geometry definition](sources.md#claims); the arithmetic is repeated here only as a profile identity record.

## Documents

| Document | Content |
| --- | --- |
| [profile.yaml](profile.yaml) | Identity, parameter constraints, capabilities, limitations |
| [sources.md](sources.md) | Pinned source revision and claim provenance |
| [registers.md](registers.md) | Vector register classes/groups, fragment coordinates, residency |
| [operands.md](operands.md) | `tmma` operand correspondence per instruction |
| [lowering.md](lowering.md) | Legality conditions and the realization rule |
| [numerics.md](numerics.md) | Integer arithmetic contract and equivalence |
| [conformance.yaml](conformance.yaml) | Rule coverage and evidence state |
| [CHANGELOG.md](CHANGELOG.md) | Revision history |

## Evidence state

No assembly, compilation, instruction inspection, simulation, or device execution has been performed for this revision. The [conformance record](conformance.yaml) lists every layer separately; only the documentation checks were executed. A registered profile is not a supported target and draft maturity is not a verification result — see [mapping maturity](../../../contract.md#maturity-and-evidence).

Return to the [profile index](../README.md) or the [IME mapping guide](../../README.md).
