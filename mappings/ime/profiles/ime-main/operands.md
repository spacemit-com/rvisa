# Operand Mapping

The profile maps one virtual operation, [`tmma`](../../../../spec/operations/matrix/tmma.md) (`RVISA-OP-TMMA`) at RVISA 0.2.0, with the operand domain declared in [profile.yaml](profile.yaml). Operand positions and enum domains are the virtual operation's; this document supplies only the target correspondence.

## Operation correspondence

| Item | Definition |
| --- | --- |
| Source identity | `tmma(a, b, acc, ALayout, BLayout, CLayout, mode, reduce_order, valid_k)`; A/B rank 2 |
| Source operand roles | `a` input data, `b` input data, `acc` accumulator and result carrier; `ALayout`/`BLayout`/`CLayout` compile-time enums; `mode` compile-time enum; `reduce_order` compile-time enum; `valid_k` runtime index |
| Type and coordinates | `a`: `int8` `[M,K]`; `b`: `int8` `[N,K]`; `acc`/result: `int32` `[M,N]`; `M = N = 8`; `K` a multiple of 16; `valid_k ∈ [0,K]` |
| Target representation | `a` → `vs1` register (one per K fragment); `b` → `vs2` register (one per K fragment); `acc`/result → `vd` register group of `EMUL_C = 2`; enums and `valid_k` → no target operand, they select the sequence |
| Coordinate relation | Per fragment `j` with `k0 = 16j`, see [fragment correspondence](#fragment-correspondence) |
| Validity | See [validity and effects](#validity-and-effects) |
| Effects | Reads two input groups; reads and writes the accumulator group; no flags, no memory access; configuration state (`vtype`, `vl`) is consumed but not modified |
| Evidence | `tmma` [operands and defaults](../../../../spec/operations/matrix/tmma.md#operands-and-defaults), [axis interpretation](../../../../spec/operations/matrix/tmma.md#matrix-axis-interpretation), [value semantics](../../../../spec/operations/matrix/tmma.md#value-semantics), [numerical order and tails](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails); upstream claims in [sources](sources.md#claims) |

## Fragment correspondence

For fragment index `j ∈ [0, K ÷ 16)` with fragment origin `k0 = 16·j`:

| Virtual element | Target element | Relation |
| --- | --- | --- |
| `Aeff[m,k]` = `a[m,k]` (`ALayout = rowmajor`) | `vs1` register, flat narrow index `16·m + (k - k0)` | `a[m, k0 + t]` for local `t ∈ [0,16)` |
| `Beff[n,k]` = `b[n,k]` (`BLayout = colmajor`, exposed shape `[N,K]`) | `vs2` register, flat narrow index `16·n + (k - k0)` | `b[n, k0 + t]`; the same contents are the `B_tile^T[k,n]` view the instruction consumes |
| `Ceff[m,n]` = `acc[m,n]` (`CLayout = rowmajor`) | `vd` group, element position `8·m + n` | one-to-one for all 64 elements; unchanged by `j` |

The three layout enums are not target operands: the register layout of the instruction fixes the triple, and the mapping selects the operation's default `ALayout = rowmajor`, `BLayout = colmajor` and its default `CLayout = rowmajor`. Any other enum value describes a different effective-coordinate equation and is diagnosed rather than silently reinterpreted.

`mode` does not appear in the target representation. For rank-2 inputs the operation's batch prefix is empty, so `cross`, `reduce`, and `broadcast` all denote `D[m,n] = C[m,n] + sum(k < valid_k, a[m,k]·b[n,k])`. The mapping therefore realizes all three, and it does not implement rank-3 batch pairing.

## Accumulator initialization and result placement

`acc` is a required runtime value and is placed in the `vd` group before the first chain step, using the row-major 64-element image of [registers](registers.md#c-accumulator-tile-vd). Two cases matter:

* A nonzero, memory-derived accumulator is loaded into the group as an ordinary `int32` vector value of two registers. Loading is not part of the declared instruction sequence family; it is the caller's fragment materialization and must produce the image stated above.
* A scalar zero accumulator is still an explicit value: the group must be initialized, for example with a vector move of zero into both registers. The mapping never treats an omitted accumulator as zero.

The result replaces `acc` in the same group; RVISA does not require the result to be a distinct value, and the destructive update is the natural realization. If the virtual program keeps `acc` live after the operation, the mapping must copy it before the chain.

## Packing, padding, and transfers

| Topic | Mapping |
| --- | --- |
| Input packing | Four `int8` elements per `SEW`-bit slot, lane order matching a vector load at `EEW = 8`. This is the instruction's own storage format, not an extra conversion step. |
| Padding | None. A fragment's 128 packed input elements and 64 accumulator elements are fully covered by the declared geometry. |
| One-to-many | One virtual `tmma` becomes `K ÷ 16` target instructions; each element of the result is produced by exactly one chained accumulator sequence. |
| Many-to-one | Several virtual operations may share one accumulator group when their `acc` operand is the previous result; each still owns its own chain. |
| Transfers | No transfer instruction is in the declared subset. Moving fragments to or from memory, or reinterpreting them in another layout, is outside this revision. |
| Element-count relations | `a` contributes `M × K` elements, `b` `N × K`, the result `M × N`; no operand element count is reinterpreted as a register count. |

## Validity and effects

| Constraint | Rule |
| --- | --- |
| Alignment | `vd` base a multiple of `EMUL_C = 2`; input registers unconstrained beyond the register-file bound (`LMUL = 1`). |
| Overlap | `vd` group disjoint from the `vs1` and `vs2` registers of the same instruction; inputs may alias each other. |
| Grouping | Exactly one 2-register group for C and one register per input fragment; the C group does not change with K, and the input groups do not grow along N. |
| Operand ties | None. `acc` and the result are tied to `vd` by the destructive update, which the profile states explicitly rather than leaving implicit. |
| Destructive updates | `vd` only. |
| Fixed registers | None. |
| Configuration read | `vtype` (`vsew`, `lambda`, `vlmul`, `altfmt_A`, `altfmt_B`) and `vl`; an `altfmt_A` or `altfmt_B` value of 1 selects an unsigned operand table row and is rejected. |
| Configuration write | None by the compute instruction. The enclosing sequence writes `vtype` and `vl` as described in [lowering](lowering.md#rule-ime-tmma-i8i32). |
| Numerical policy | Modular `int32` accumulation; see [numerics](numerics.md). |

## Diagnostics

The mapping rejects, with a diagnostic rather than a silent choice:

* `M ≠ 8` or `N ≠ 8` — outside the single declared microtile geometry.
* `K` not a positive multiple of 16, or `valid_k` not in `{0} ∪ {16, 32, …}` and at most `K`.
* `valid_k > K`.
* Rank-3 or mixed-rank inputs, and any `mode` applied to batched inputs.
* `ALayout`, `BLayout`, or `CLayout` values other than the declared triple, and any enum in the wrong role or a runtime value where an enum is required.
* Accumulator or result element type other than `int32`, or an accumulator shape other than `[8,8]`.
* Input element type other than signed `int8`.
* An allocation that overlaps the accumulator group with an input group, or that cannot keep the four registers resident.
* A target configuration in which `vtype.lambda[2:0]` does not read back as 4, or in which `vl` is not 32.

Return to the [profile overview](README.md) · [register model](registers.md) · [lowering rules](lowering.md).
