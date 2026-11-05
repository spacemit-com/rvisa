# vme-main — Zvt int8-to-int32 Matrix Multiply-Accumulate

| Property | Value |
| --- | --- |
| Profile identifier | `vme-main` |
| Mapping revision | 1 |
| Maturity | [draft](../../../contract.md#maturity-and-evidence) |
| RVISA revision | 0.2.0 |
| Family | [VME](../../README.md) |
| Upstream source | `riscv/riscv-isa-manual`, branch `zvt`, `src/unpriv/zvt.adoc` @ `98b0e96fb240a0b6a54bf814fc2f6a139a409e10` |

This profile maps rank-2 [tmma](../../../../spec/operations/matrix/tmma.md) with signed `int8` inputs and an `int32` accumulator onto the `Zvti8i32mm` extension instruction `vtmms.tvv`. Inputs come from vector register groups; the accumulator is the new square matrix tile state, which is a separate architectural register domain from the vector registers.

## Supported subset

| Item | Declared domain |
| --- | --- |
| Virtual operation | [tmma](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`), rank-2 inputs |
| Element tuple | signed `int8` × signed `int8` → `int32` (`SEW = 8`, `TWIDEN = 4`, `TEW = 32`) |
| Microtile geometry | single geometry: `M = N = 32`, contraction depth `tk ≤ KMAX = 4` per instruction |
| `K` | any positive integer |
| `valid_k` | any value in `[0,K]` — a partial final fragment programs `tk = valid_k mod 4` |
| Layouts | `ALayout = colmajor`, `BLayout = rowmajor`, `CLayout = rowmajor` |
| Batch modes | `cross`, `reduce`, `broadcast` — coincident, because rank-2 inputs have an empty batch prefix |
| Reduction order | `ordered` and `tree` are bit-identical (integer accumulation) |
| Target instruction | `vtmms.tvv mtd, vs2, vs1` with `vtype.altfmt = 1` |

The axis correspondence differs from the IME profile: this extension computes `C[m,n] += Σ A[k,m]·B[k,n]`, so the logical A operand is the `[K,M]` matrix that RVISA names `ALayout = colmajor` and the logical B operand is the `[K,N]` matrix that RVISA names `BLayout = rowmajor`.

## Geometry pins

| Parameter | Value | Derivation |
| --- | --- | --- |
| `VLEN` | 1024 bits | implementation parameter, pinned |
| `SEW` | 8 | multiplicand width; set through `msetmtypei` |
| `TWIDEN` | 4 | accumulator width multiplier; `TEW = SEW × TWIDEN = 32` |
| `TE` | 32 | implementation parameter, must satisfy `VLEN/4 ≥ TE ≥ 4` and be a power of two |
| `ETE` | 32 | `TEW < 64 ? TE : TE/2` |
| `EVE` | 128 | `VLEN ÷ SEW` |
| `KMAX` | 4 | fixed by the extension for `SEW = 8`, `TWIDEN = 4` |
| `vtype.vlmul` | `000`, i.e. `LMUL = 1` | `log2(min(8/KMAX, 8/TWIDEN, ceil(ETE/EVE)))` selected by `msetmtypei` |
| `tm` | 32 | `msettm(32)` clamps to `min(32, LMUL·EVE, ETE) = 32` |
| `tn` | 32 | `msettn(32)` clamps to `min(32, LMUL·EVE, ETE) = 32` |

With `TE = 32` a `TEW = 32` tile is `32 × 32` elements (4 KiB), and the whole tile is covered by `tm = tn = 32`, so the tile tail is empty for the declared geometry.

## Documents

| Document | Content |
| --- | --- |
| [profile.yaml](profile.yaml) | Identity, parameter constraints, capabilities, limitations |
| [sources.md](sources.md) | Pinned source revision and claim provenance |
| [registers.md](registers.md) | Vector input groups, matrix tile state, coordinates, residency |
| [operands.md](operands.md) | `tmma` operand correspondence per instruction |
| [lowering.md](lowering.md) | Legality conditions and realization rules |
| [numerics.md](numerics.md) | Integer arithmetic contract and equivalence |
| [conformance.yaml](conformance.yaml) | Rule coverage and evidence state |
| [CHANGELOG.md](CHANGELOG.md) | Revision history |

## Evidence state

No assembly, compilation, instruction inspection, simulation, or device execution has been performed for this revision; the [conformance record](conformance.yaml) lists each layer separately and only the documentation checks were executed.

Return to the [profile index](../README.md) or the [VME mapping guide](../../README.md).
