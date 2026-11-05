# Operand Mapping

The profile maps [`tmma`](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`) at RVISA 0.2.0 with the operand domain declared in [profile.yaml](profile.yaml). The target instruction is `mmulacc.2d`.

## Operation correspondence

| Item | Definition |
| --- | --- |
| Source identity | `tmma(a, b, acc, ALayout, BLayout, CLayout, mode, reduce_order, valid_k)`; A/B rank 2 |
| Source operand roles | `a`, `b` input data; `acc` accumulator and result carrier; layout, mode, and reduction-order enums; `valid_k` runtime index |
| Type and coordinates | `a`: `fp16` `[M,K]`; `b`: `fp16` `[K,N]`; `acc`/result: `fp32` `[M,N]`; `M = N = 16`; `K` a positive multiple of 32; `valid_k ∈ {0} ∪ {32, 64, …}` and at most `K` |
| Target representation | `a` → `ms1` matrix register; `b` → `ms2` matrix register; `acc`/result → `acc` accumulator register; enums and `valid_k` → no target operand, they select the sequence |
| Coordinate relation | See [fragment correspondence](#fragment-correspondence) |
| Validity | See [validity and effects](#validity-and-effects) |
| Effects | Reads two matrix registers; reads and writes one accumulator register; accrues `amefflags`; no memory access; `Md`/`Ad` and `amestatus` observable |
| Evidence | `tmma` [operands and defaults](../../../../spec/operations/matrix/tmma.md#operands-and-defaults), [axis interpretation](../../../../spec/operations/matrix/tmma.md#matrix-axis-interpretation), [value semantics](../../../../spec/operations/matrix/tmma.md#value-semantics), [numerical order and tails](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails); upstream claims in [sources](sources.md#claims) |

## Fragment correspondence

One instruction contracts 32 terms: `N_sq = 2` squares of `N = 16`. Fragment index `j` covers `k ∈ [32j, 32j + 32)`, and within the fragment `k = 16s + q` with `s ∈ {0,1}` and `q ∈ [0,16)`.

| Virtual element | Target element | Relation |
| --- | --- | --- |
| `Aeff[m,k]` = `a[m,k]` | `ms1` image, K-block `s`, element `(m,q)` | `a[m, 32j + 16s + q]` |
| `Beff[n,k]` = `b[k,n]` | `ms2` image, K-block `s`, element `(q,n)` | `b[32j + 16s + q, n]` |
| `Ceff[m,n]` = `acc[m,n]` | accumulator image, element `(m,n)` | one-to-one for all 256 elements; unchanged by `j` |

The layout triple is `rowmajor`/`rowmajor`/`rowmajor`: A enters as `[M,K]` and B as `[K,N]`, exactly as the extension's `C = C + A × B` form requires. A `BLayout = colmajor` call would need the transposing form `mmulbtacc.2d`, and `mmulatacc.2d` computes the transposed-A form; neither is used by this revision, and the corresponding RVISA layout combinations are diagnosed rather than remapped.

`mode` has no target representation. For rank-2 inputs the batch prefix is empty, so `cross`, `reduce`, and `broadcast` denote the same equation; the mapping realizes all three and does not implement rank-3 pairing.

## Accumulator initialization and result placement

`acc` is a required runtime value, and the accumulator register is read as the fold seed and overwritten. Three declared paths exist:

| Case | Sequence |
| --- | --- |
| `acc` is exactly `+0.0` for every element | `asettyp` with the `FP32` descriptor, which clears the storage to raw zero |
| `acc` is any other value, including a memory image | `msettyp` on an `M` register with the `FP32` descriptor, `mls.rm` of the 1024-byte image, `mmov.a.m acc, m` |
| `acc` is produced in the accumulator domain | no initialization step; continue the chain |

The `asettyp` path is not a general zero-initialization: raw zero is `+0.0`, so a virtual accumulator containing `-0.0` must use the transfer path, otherwise the sign of a zero result can differ from the virtual operation's. This is the only place where the two paths are not equivalent.

There is no memory-to-accumulator path, so both non-trivial paths cost a register transfer. The result is read with `mmov.m.a` into an `M` register followed by `mss.rm` of the 1024-byte row-major image; that image is the RVISA `CLayout = rowmajor` value with no further permutation. If `acc` remains live after the operation, the caller must save it before the chain, because the update is destructive.

## Packing, padding, and transfers

| Topic | Mapping |
| --- | --- |
| Input packing | Two squares packed per register; the interoperability image is `pack_factor` contiguous squares in ascending slot order, each row-major |
| Image asymmetry | A's image is two `16 × 16` column blocks of the `[16,32]` matrix and is therefore not the row-major image of `[16,32]`; B's image is the row-major image of `[32,16]` |
| Padding | None; both operand registers and the accumulator are fully covered by the declared geometry |
| One-to-many | One virtual `tmma` becomes `K ÷ 32` compute instructions, plus datatype programming, accumulator initialization, and result transfer |
| Many-to-one | Several virtual operations may continue on the same accumulator register when `acc` is the previous result |
| Transfers | `mls.rm`/`mss.rm` for memory, `mmov.a.m`/`mmov.m.a` for the accumulator domain; no vector-register path exists at all |
| Element-count relations | 512 input elements per operand register, 256 accumulator elements per square |

## Validity and effects

| Constraint | Rule |
| --- | --- |
| Alignment | Memory bases of `mls.rm`/`mss.rm` naturally aligned to the element size; register alignment is not exercised because every span is one register |
| Overlap | `ms1` and `ms2` may be the same register (source snapshot makes it well defined); the accumulator is a separate register file and cannot alias an operand |
| Grouping | One register per operand, one accumulator; `N_sq = max(pack_factor) = 2` is fixed by the datatypes |
| Operand ties | `acc` is tied to its own source value; the update is destructive and explicit |
| Destructive updates | The accumulator register only |
| Fixed registers | None |
| Configuration read | `Md[ms1]`, `Md[ms2]`, `Ad[acc]`, `ameown.OWNED`, `mstatus.MS`, `amestatus.UN` |
| Configuration write | `md`/`ad` descriptors before the data movement; `ame.acquire` before the first AME instruction |
| Numerical policy | `tree` only; see [numerics](numerics.md) |

## Diagnostics

* `M ≠ 16` or `N ≠ 16`, or a result shape other than `[16,16]`.
* `K` not a positive multiple of 32, or `valid_k` not in `{0} ∪ {32, 64, …}` or greater than `K`.
* Rank-3 or mixed-rank inputs, or a `mode` applied to batched inputs.
* `ALayout`/`BLayout` combinations that would require `mmulatacc.2d` or `mmulbtacc.2d`, and `CLayout = colmajor`.
* Input element type other than `fp16`, accumulator type other than `fp32`, or a datatype descriptor with a non-RNE rounding field, `Inf = 0`, or `Denorm = 0`.
* `reduce_order = ordered`.
* `ameown.OWNED = 0` or an applicable `MS` field `Off`.
* `amestatus.UN = 1` after any AME instruction, which means the tuple is unsupported and nothing was written.
* A virtual accumulator of `-0.0` initialized through `asettyp`.
* An unsupported shape of the staging path, such as fewer than two `M` registers or no free accumulator.

Return to the [profile overview](README.md) · [register model](registers.md) · [lowering rules](lowering.md).
