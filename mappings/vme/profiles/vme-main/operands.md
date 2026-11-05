# Operand Mapping

The profile maps [`tmma`](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`) at RVISA 0.2.0 with the operand domain declared in [profile.yaml](profile.yaml). The target instruction is `vtmms.tvv` with `vtype.altfmt = 1`.

## Operation correspondence

| Item | Definition |
| --- | --- |
| Source identity | `tmma(a, b, acc, ALayout, BLayout, CLayout, mode, reduce_order, valid_k)`; A/B rank 2 |
| Source operand roles | `a` and `b` input data; `acc` accumulator and result carrier; `ALayout`/`BLayout`/`CLayout`, `mode`, `reduce_order` compile-time enums; `valid_k` runtime index |
| Type and coordinates | `a`: signed `int8` `[K,M]` exposed by `ALayout = colmajor`; `b`: signed `int8` `[K,N]` exposed by `BLayout = rowmajor`; `acc`/result: `int32` `[M,N]`; `M = N = 32`; `K` any positive integer; `valid_k ∈ [0,K]` |
| Target representation | `a` → `vs2` operand groups (four row registers per fragment); `b` → `vs1` operand groups; `acc`/result → the `mtd` tile in matrix tile state; enums and `valid_k` → no target operand, they select the sequence and the `mtype`/`vl` values |
| Coordinate relation | See [fragment correspondence](#fragment-correspondence) |
| Validity | See [validity and effects](#validity-and-effects) |
| Effects | Reads both operand groups; reads and writes one tile's active submatrix; no memory access; `tm`, `tn`, `tk`, `vtype`, and `vl` are consumed, not modified |
| Evidence | `tmma` [operands and defaults](../../../../spec/operations/matrix/tmma.md#operands-and-defaults), [axis interpretation](../../../../spec/operations/matrix/tmma.md#matrix-axis-interpretation), [value semantics](../../../../spec/operations/matrix/tmma.md#value-semantics), [numerical order and tails](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails); upstream claims in [sources](sources.md#claims) |

The operand order of the target instruction is not the operand order of the virtual operation: `vs2` is the A matrix and `vs1` is the B matrix, while `tmma` lists `a` before `b`. A profile that swapped the two would compute the transposed product and is not a legal realization.

## Fragment correspondence

The contraction is split into fragments of `tk ≤ 4` terms. For fragment `j` with fragment origin `k0 = 4j` and depth `tk`, the target rows are `k - k0 ∈ [0, tk)`.

| Virtual element | Target element | Relation |
| --- | --- | --- |
| `Aeff[m,k]` = `a[k,m]` | `vs2` row register `baseA + 2·(k - k0)`, element position `m` | `a[k0 + t, m]` for local `t ∈ [0,tk)` |
| `Beff[n,k]` = `b[k,n]` | `vs1` row register `baseB + 2·(k - k0)`, element position `n` | `b[k0 + t, n]` for local `t ∈ [0,tk)` |
| `Ceff[m,n]` = `acc[m,n]` | tile `mtd`, row `m`, column `n` | one-to-one for all 1024 active elements; unchanged by `j` |

The A operand is the `[K,M]` matrix that `ALayout = colmajor` exposes, and the B operand is the `[K,N]` matrix that `BLayout = rowmajor` exposes. This is the transpose relationship the source states as `C[tm,tn] += A[tk,tm]^T × B[tk,tn]`: the instruction consumes the transposed A operand, and RVISA's `colmajor` A view is exactly that transposition. `CLayout = rowmajor` matches the tile's row/column addressing.

`mode` has no target representation. Rank-2 inputs have an empty batch prefix, so `cross`, `reduce`, and `broadcast` all denote `D[m,n] = C[m,n] + sum(k < valid_k, a[k,m]·b[k,n])`; the mapping realizes all three and does not implement rank-3 pairing.

## Accumulator initialization and result placement

The accumulator lives in tile state and is updated in place by every fragment instruction, so the result is the same storage as `acc`. Initialization has three declared paths:

| Case | Sequence |
| --- | --- |
| `acc` is an explicit zero | `vtzero mtd` — one instruction, no memory access |
| `acc` is a runtime value in memory | 32 `vtle32` instructions, one row tile subset each, with `vl = tn = 32` |
| `acc` is a value produced in vector registers | `vtmv.t.v` per row from the producing vector registers |

A nonzero accumulator must not be approximated by `vtzero`: `RVISA-TMMA-PAIR-1` requires each output to be initialized from `C` exactly once. The mapping never omits the initialization and never adds the accumulator twice. If the virtual program keeps `acc` live after the operation, the caller must save the tile rows before the chain.

The result is read out with 32 `vtse32` instructions, or moved to vector registers with `vtmv.v.t`, in increasing column order within each row.

## Packing, padding, and transfers

| Topic | Mapping |
| --- | --- |
| Input packing | One `int8` per element position (byte); no sub-word packing, because `SEW = 8` and the value layout is the row-register layout of a vector load at element width 8 |
| Padding | A row register holds `EVE = 128` element positions with `tm` or `tn` active; positions beyond the active extent are unused and never contribute |
| One-to-many | One virtual `tmma` becomes `ceil(K ÷ 4)` target instructions, plus the accumulator initialization and result transfer |
| Many-to-one | A further virtual operation may continue on the same tile if its `acc` is the previous result; that is the natural K accumulation across separate operations |
| Transfers | `vtle32`/`vtse32` for memory, `vtmv.v.t`/`vtmv.t.v` for the vector domain; no other inter-domain path is used |
| Element-count relations | `a` contributes `M × K` elements, `b` `N × K`, the result `M × N = 1024`; a tile holds exactly the declared output |

## Validity and effects

| Constraint | Rule |
| --- | --- |
| Alignment | Vector operand bases: multiple of `LMUL = 1` and, modulo 8, less than `8/KMAX = 2`. Memory bases of `vtle32`/`vtse32`: naturally aligned to the 4-byte element. |
| Overlap | A and B may share one eight-register window (even versus odd offsets) but must not occupy the same offsets; the tile operand has no alias with the vector file. |
| Grouping | Four row registers per operand inside one eight-register group; the accumulator is exactly one `TEW = 32` tile. |
| Operand ties | `acc` and the result are the same tile; the update is destructive and explicit. |
| Destructive updates | The tile only. |
| Fixed registers | None. The tile number is an encoded operand, not a fixed register. |
| Configuration read | `mtype.mtwiden`, `mtype.tm`, `mtype.tk`, `vl` (as `tn`), `vtype.vsew`, `vtype.altfmt`, `vtype.vlmul`. |
| Configuration write | `msetmtypei` and the `mset*` family, before the first compute instruction. |
| Numerical policy | Exact integer accumulation with the domain restriction of [numerics](numerics.md). |

## Diagnostics

* `M ≠ 32` or `N ≠ 32` — outside the single declared geometry; a larger output needs several tiles, which this revision does not define.
* `K` not a positive integer, `valid_k > K`, or a negative `valid_k`.
* Rank-3 or mixed-rank inputs, or a `mode` applied to batched inputs.
* Layout enums other than `colmajor`/`rowmajor`/`rowmajor`, an enum from another domain, or a runtime value in an enum role.
* Accumulator element type other than `int32`, or a result shape other than `[32,32]`.
* Input element type other than signed `int8`, including the mixed-sign and unsigned rows of the extension.
* `msetmtypei` not executed, `mtwiden = 0`, or a `vsetvli`/`vsetivli` after it.
* Operand bases that violate the modulo-8 rule, overlap in the same offsets, or a matrix-unit configuration whose `vlmul` is not `LMUL = 1`.
* `msettm`/`msettn`/`msettk` results that differ from the requested `tm`/`tn`/`tk`, which indicates a target whose `TE`, `KMAX`, or `EVE` differs from the pinned parameters.
* An accumulator result outside the representable `int32` domain (see [numerics](numerics.md#equivalence-domain)).

Return to the [profile overview](README.md) · [register model](registers.md) · [lowering rules](lowering.md).
