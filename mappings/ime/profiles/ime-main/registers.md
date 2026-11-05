# Registers and State

All state used by this profile is architectural vector state. IME introduces no register file of its own: A, B, and C fragments are vector register groups, and the tile geometry is decoded from `vtype` and `vl`. The register representation follows [RVISA-TILE-REG-1](../../../../spec/types/tile.md#register-representation); this document selects one representation for the declared subset and records its group, alignment, and overlap constraints.

## Register file domain

| Property | Description |
| --- | --- |
| Identity and role | RISC-V vector register file, registers `v0`-`v31`. Holds input fragments A and B and the accumulator tile C. Source revision `6effbcae3204e5a8a9c9d15ff53959918144870c`. |
| Capacity | 32 registers of `VLEN = 1024` bits (128 bytes) each. One `SEW = 32`-bit storage position per 32 bits of a register; `VLEN ÷ SEW = 32` positions per register. |
| Element interpretation | C elements: `int32`. A and B elements: `int8`, four packed per `SEW`-bit position (`W = 4`), element `f` at bits `[8f+7 : 8f]` of the group. |
| Group constraints | C occupies `EMUL_C = 2` consecutive registers with a base index that is a multiple of 2. A and B each occupy one register (`LMUL = 1`); any base index is legal because `LMUL = 1`. No group may extend past `v31`. |
| Operand constraints | The profile requires the C group to be disjoint from the A and B groups of the same instruction (see [operand constraints](#operand-constraints)). `vd` is read and written by the same instruction; A and B are read only. No fixed register number is required by the architecture or by this profile. |
| Access | `vqmmacc.vv` reads both input groups and reads then writes the accumulator group. Ordinary vector loads and stores at element widths 8 and 32, and the tile load/store instructions, can also address these registers but their use is outside the declared subset (see [state and transfers](#state-and-transfers)). |

Concrete register numbers are an allocation decision of the compiler within these constraints; the ranges below are stated in group-relative terms so that an example allocation cannot be mistaken for a profile requirement.

## Coordinate representation

`M_tile = N_tile_max = 8`, `K_eff = 16`, and `EMUL_C = 2`. All three fragment classes hold exactly one microtile; a larger logical `M`, `N`, or `K` is expressed by several fragments, and this revision declares only the single-fragment geometry `M = 8`, `N = 8`.

### A fragment (`vs1`)

| Property | Description |
| --- | --- |
| Logical coordinates | `Aeff[m,k]` with `m ∈ [0,8)`, `k ∈ [0,16)` inside the fragment. |
| Element order | Row-major with contiguous K: flat narrow index `f = 16·m + k` in `[0,128)`. |
| Storage position | `SEW` position `f ÷ 4`, lane `f mod 4`, register `base + 0`. Element `f` occupies bits `[8f+7 : 8f]` of the group, matching a vector load at `EEW = 8`. |
| Coverage | Complete: 128 packed elements fill the single register exactly. No padding. |
| Active extent | The multiply-accumulate instruction reads all `M_tile` rows regardless of `vl`; the K extent of a fragment is fixed at `K_eff = 16`. |

### B fragment (`vs2`)

| Property | Description |
| --- | --- |
| Logical coordinates | `Beff[n,k]` with `n ∈ [0,8)`, `k ∈ [0,16)`; the same register contents are the column-major view `B_tile^T[k,n]`, which is what the instruction consumes. |
| Element order | Row-major over `[N,K_eff]` with contiguous K: flat narrow index `f = 16·n + k`. |
| Storage position | As for A: `SEW` position `f ÷ 4`, lane `f mod 4`, register `base + 0`. |
| Coverage | Complete: 128 packed elements fill the single register exactly. |
| Active extent | Only columns `j < N_tile = 8` of the `B_tile^T` view contribute, and `vl` selects `N_tile`; the declared geometry has `N_tile = N_tile_max = 8`, so no column is inactive. |

### C accumulator tile (`vd`)

| Property | Description |
| --- | --- |
| Logical coordinates | `Ceff[m,n]` with `m,n ∈ [0,8)`; the result uses the same coordinates. |
| Element order | Row-major over the physical tile `M_tile × N_tile_max`; element position `p = 8·m + n` in `[0,64)`. |
| Storage position | Register `base + (p ÷ 32)`, `SEW` position `p mod 32`; `base` is a multiple of `EMUL_C = 2`. |
| Coverage | Complete for the declared geometry: `N_tile = N_tile_max`, so the C tile tail is empty. |
| Active extent | Active elements are those with column index `n < N_tile`. The tail is defined by the column index, not by a one-dimensional `element_index >= VL`; see the C tile tail policy in [sources](sources.md#claims). |

Logical groups, architectural register groups, and simultaneously live registers are distinct quantities here: one logical `tmma` fragment is one architectural group per operand, and the three groups are live together during a chain step.

## Operand constraints

* **Disjointness.** The profile requires `vd`'s two registers to be disjoint from the A register and the B register of the same instruction. The pinned instruction description states no source-snapshot rule, so a source/destination overlap cannot be shown to preserve the pre-instruction inputs. This is a profile constraint, not an upstream claim.
* **Alignment.** `vd` must be a multiple of `EMUL_C = 2`; `vs1` and `vs2` must be aligned for `LMUL = 1`, which imposes no constraint beyond `0 ≤ index ≤ 31`. A violation of `vd` alignment raises *Illegal Instruction* in the target instruction and is diagnosed by the mapping.
* **Aliasing within an operand.** A and B may name the same register (for example a symmetric `A_tile = B_tile` computation); the instruction reads both before writing `vd`, and the disjointness rule covers only the destination.
* **Destructive update.** `vd` is both the accumulator source and the result. If the virtual `acc` value remains live after the operation, the mapping must materialize a copy before the chain; the copy is an ordinary vector register move and is not part of the declared instruction sequence family.
* **Fixed registers.** None required. `v0` is not special for a `vm = 1` encoding, and no mask register is involved.

## Resource and temporary-storage policy

| Quantity | Value |
| --- | --- |
| Registers per chain step | 4 (`A` 1, `B` 1, `C` 2) |
| Registers with double-buffered inputs | 6 |
| Accumulator residency | `C` stays live across the whole K chain; it is the loop-carried value. |
| Input residency | An A/B pair may be released after the step that reads it; the next fragment may reuse the same registers. |
| Maximum fragments resident | Not a profile quantity: the declared geometry needs one A, one B, and one C group at a time. |

This revision declares no spill or memory-staging sequence for A, B, or C. Fragments must remain register-resident for the duration of a rule application. If the surrounding allocation cannot satisfy the four-register demand plus library state, the mapping reports the case as unsupported rather than emitting an undeclared sequence. Fragment staging through memory is a tile memory operation and is outside the declared subset; a future revision may define it, and the availability of the order-preserving tile load is recorded in [sources](sources.md#documents-read).

## State and transfers

| State | Effect |
| --- | --- |
| `vtype.vsew = 32` | Selects the C element width and, through `W = 4`, the packed input width. |
| `vtype.lambda[2:0] = 011` | Selects `lambda = 4` and therefore `M_tile`, `K_eff`, and `EMUL_C`. Selecting `lambda` requires `vsetvl` with a complete `vtype` value; `vsetvli`/`vsetivli` never write the IME fields. |
| `vtype.vlmul = 000` | `LMUL = 1`. Fractional `LMUL` is reserved and is an illegal-instruction condition for the extension. |
| `vtype.bs`, `vtype.altfmt` | Ignored for the ordinary integer row; written to zero by this profile's configuration sequence. |
| `vtype.altfmt_A = 0`, `vtype.altfmt_B = 0` | Signed interpretation of both inputs. Any other value is outside the declared subset. |
| `vl = 32` | Selects `N_tile = 8`; `vl` must be a multiple of `lambda × LMUL = 4`. |
| `vstart` | Must be 0 at entry; the instruction cannot be interrupted and resumed and raises *Illegal Instruction* otherwise. |
| `mstatus.VS` | Must be non-`Off`; the extension does not define an `Off` behavior of its own. |

`lambda` selection is WARL-constrained: a nonzero request may be clamped to a smaller supported value, and a configuration change may re-select it. The profile therefore requires the sequence to read `vtype` back and to diagnose the case where `lambda[2:0] ≠ 011` instead of assuming the request took effect. `LMUL` alone does not disturb `lambda`; a change of `SEW` may.

Values become available when the producing fragment write completes; a fragment may be reused after the last instruction that reads it. Function boundaries, caller-save behaviour, and the treatment of the `EMUL_C = 2` accumulator group by a calling convention are not defined by the pinned IME text (`psABI` support is stated as unavailable for the `m16` accumulator types) and are not defined by this profile.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [lowering rules](lowering.md).
