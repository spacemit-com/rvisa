# Lowering Rules

Two rules cover the declared subset: the compute rule and the zero-contraction rule. Each satisfies [RVISA-MAP-1](../../../contract.md#mapping-guarantees) for its operand domain: legal sequence family, selection preconditions, register classes and groups, operand correspondence, configuration effects, and numerical obligations. Operand-level detail is in [operands](operands.md); the register model is in [registers](registers.md).

## Rule IME-TMMA-I8I32

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma` (`RVISA-OP-TMMA`), RVISA 0.2.0, rank-2 A and B, signed `int8` inputs, `int32` accumulator |
| Rule identity | `IME-TMMA-I8I32` |
| Operand domain | `M = 8`, `N = 8`, `K` a positive multiple of 16, `valid_k` a multiple of 16 at most `K`; `ALayout` rowmajor, `BLayout` colmajor, `CLayout` rowmajor; any `mode` for rank-2 inputs; `ordered` or `tree` |
| Target instruction | `vqmmacc.vv vd, vs1, vs2` — `Zvvi8i32mm`, `W = 4`, one instruction per K fragment |
| Register classes and groups | `vd`: 2-register group (`EMUL_C = 2`, base a multiple of 2); `vs1`, `vs2`: one register each (`LMUL = 1`) |
| Configuration | `vtype.vsew = 32`, `vtype.vlmul = 0` (`LMUL = 1`), `vtype.lambda[2:0] = 011` (`lambda = 4`), `vtype.altfmt_A = 0`, `vtype.altfmt_B = 0`, `vtype.bs = 0`; `vl = 32`; `vstart = 0` |
| Numerical obligation | Exact product, modular `int32` accumulation; see [numerics](numerics.md) |

### Selection preconditions

1. The target declares `Zvvi8i32mm` (which requires `Zve32x` and, in this profile, the pinned `VLEN`/`lambda` parameter set).
2. The vector configuration names `SEW = 32` for the accumulator element width and `lambda = 4`, and `lambda` reads back as 4 after configuration.
3. `vl = 32 = lambda × LMUL × N_tile` with `N_tile = 8`; `vl` is a multiple of `lambda × LMUL = 4`.
4. The accumulator group is disjoint from both input registers; all four registers are available.
5. `valid_k` and `K` satisfy the declared domain; `K` is a multiple of `K_eff = 16`.
6. The caller accepts the modular `int32` accumulation contract.

If any precondition fails, the mapping does not select this rule: see [diagnostics](#diagnostics).

### Configuration sequence

`vsetvl` writes a complete `vtype`, which is the only architectural mechanism that sets the IME fields:

1. Write `vsetvl` with `rd` discarded, `rs1 = 32` (AVL) and `rs2` encoding `vill = 0`, `lambda[2:0] = 011`, `bs = 0`, `altfmt_A = 0`, `altfmt_B = 0`, `altfmt = 0`, `vma = 0`, `vta = 0`, `vsew = 010`, `vlmul = 000`. This writes both `vtype` and `vl`.
2. Read `vtype` back. If `lambda[2:0] ≠ 011`, the target does not support this geometry and the rule is not applicable; the value may have been WARL-clamped.
3. Input fragment materialization stores A and B fragments into their registers with the coordinate relation of [operands](operands.md#fragment-correspondence); accumulator materialization stores the row-major 64-element image into the C group.

`vsetvli` and `vsetivli` are usable only if they preserve the selected `lambda`; because they cannot write the IME fields and may re-select `lambda` after a `SEW` change, the profile requires the read-back check after any such instruction as well.

### Sequence family

For a `K` fragment count `n = K ÷ 16`, the legal realization is the following family. The K-chain order is fixed; the register numbers are allocation choices. The block is pseudocode, not assembly: it names steps and shows the ordering obligations, not an assembler syntax.

~~~text
vsetvl                  rd=x0, avl=32, vtype=(lambda=4, vsew=32, vlmul=1)   # step 0
# read back vtype; require lambda == 4                                      # step 0a
# materialize acc[8][8] int32 into the C group (2 registers)                 # step 0b
for j in 0 .. n-1:                                                          # step 1
    materialize A fragment j (a[0:8, 16j:16j+16]) into vs1                  # step 1a
    materialize B fragment j (b[0:8, 16j:16j+16]) into vs2                  # step 1b
    vqmmacc.vv vd, vs1, vs2                                                 # step 2
# result occupies the C group; copy out if acc must remain observable        # step 3
~~~

| Step | Operands and groups | Effect |
| --- | --- | --- |
| 1a | `vs1` register | Writes the packed A fragment; must not overlap the C group. |
| 1b | `vs2` register | Writes the packed B fragment; may reuse the register of a previous `vs2` or alias `vs1`. |
| 2 | `vd` group, `vs1`, `vs2` | Reads both input registers, reads and writes the accumulator group, advances the K chain by `K_eff = 16`. |
| 3 | `vd` group | The result is the final accumulator image; the group remains live until the value's last use. |

The sequence family permits the fragment materialization of steps 1a and 1b to be reordered, double-buffered, or fused with the producing code as long as each `vqmmacc.vv` reads the fragment for its own `j` and the C group is not written between steps. It does not permit reordering the `j` sequence, changing the number of steps, or replacing a step with an equivalent-looking vector dot-product sequence: the numerical and grouping contract is specific to the declared instruction.

### Coordinate transformation

The transformation is a fragment selection only: the virtual K axis is split into `n` fragments of 16, and each fragment is placed with K contiguous inside a register, as stated in [operands](operands.md#fragment-correspondence). `M`, `N`, and `K` are not redefined by the instruction's microtile geometry; the instruction consumes exactly one fragment of the declared geometry.

### Boundary behavior

| Case | Behavior |
| --- | --- |
| `valid_k = 0` | Rule [IME-TMMA-I8I32-K0](#rule-ime-tmma-i8i32-k0): the result is the normalized accumulator. Types, layouts, ranks, batch conditions, and capability checks still apply. |
| `valid_k` a multiple of 16 but less than `K` | Emit only the first `valid_k ÷ 16` steps; the remaining input fragments are neither materialized nor read. Skipped fragments are not replaced by zero data. |
| `valid_k` not a multiple of 16 | Diagnosed. The declared instruction contracts a whole fragment, and a zero-filled fragment is not equivalent to an omitted contribution (signed zero, infinities, and NaNs are irrelevant for integers, but the profile does not accept the substitution because the excluded elements are not known to be zero). |
| `K` not a multiple of 16 | Diagnosed; no padded fragment is emitted. |
| `M` or `N` other than 8 | Diagnosed; the single microtile geometry is a fragment, not a scalable bound. |
| Zero-extent inputs | Not applicable: `M`, `N`, and `K` are positive extents, and `valid_k = 0` is covered by the dedicated rule. |
| Faults and restart | The instruction performs no memory access, so it cannot fault on data. It requires `vstart = 0` and cannot be interrupted and resumed; asynchronous interrupts are taken between instructions, which preserves the declared chain order. |
| Register pressure | If the four registers cannot be kept resident, the case is reported unsupported rather than spilled; this revision declares no staging sequence ([registers](registers.md#resource-and-temporary-storage-policy)). |
| Temporary lifetime | There is no temporary: input fragments die at step 2, and the accumulator group is the only loop-carried value. |

## Rule IME-TMMA-I8I32-K0

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma`, same operand domain as [IME-TMMA-I8I32](#rule-ime-tmma-i8i32), with `valid_k = 0` |
| Rule identity | `IME-TMMA-I8I32-K0` |
| Target sequence | Empty: no `vqmmacc.vv` instruction is emitted |
| Register classes and groups | The `vd` group holding `acc`; no input fragment is required |
| Configuration | None required by the sequence itself; the validity checks of the enclosing rule still apply |
| Numerical obligation | The result is the normalized accumulator; see [`RVISA-TMMA-K-1`](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails) |

The empty sequence is legal because the virtual operation's contribution set is empty and the result is the incoming accumulator value, which is already in the declared representation. It does not establish that an empty sequence is ever equivalent for `valid_k > 0`, and it does not relax the diagnostic requirements for an invalid rank, layout, or batch combination at `valid_k = 0`.

## Diagnostics

| Condition | Diagnostic |
| --- | --- |
| `M ≠ 8`, `N ≠ 8`, non-multiple `K` or `valid_k`, `valid_k > K` | Geometry outside the declared domain; no sequence. |
| Rank-3 inputs or mixed rank | Batch decomposition not defined in this revision. |
| Unsupported layout or `CLayout` enum | Layout triple outside the declared domain. |
| Unsigned input selection (`altfmt_A`/`altfmt_B` = 1 in the required configuration) | No signedness operand in the virtual operation. |
| `lambda` read-back ≠ 4, or the target geometry unsupported | Selection precondition 2 fails; the target does not implement this profile. |
| `vl ≠ 32` or not a multiple of 4 | Configuration violation; the target would raise *Illegal Instruction*. |
| Accumulator group overlapping an input register | Allocation constraint violation. |
| Non-resident fragments | Resource failure; no staging in this revision. |
| Accumulator or input element type or shape mismatch | Type contract violation. |

## Evidence and cost

The declared sequence family has no compilation, instruction-inspection, simulation, or device evidence; the [conformance record](conformance.yaml) lists each layer with outcome `not-run`. Inspection obligations for a future run are: the emitted instruction is `vqmmacc.vv`; `vd` is a 2-register group aligned to 2 and disjoint from `vs1`/`vs2`; the configuration writes `lambda = 4` through `vsetvl` and reads it back; and the number of emitted instructions equals `valid_k ÷ 16`.

No performance claim is made. Instruction count, register footprint, and the K-chain length are structural facts, not measurements, and the extension document's compute-intensity discussion is informative upstream text that this profile does not adopt as a target guarantee.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [numerics](numerics.md).
