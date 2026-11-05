# Lowering Rules

Two rules cover the declared subset: the fragment compute rule and the zero-contraction rule. They carry the [RVISA-MAP-1](../../../contract.md#mapping-guarantees) content for this domain; operand and register detail is in [operands](operands.md) and [registers](registers.md).

## Rule VME-TMMA-I8I32

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma` (`RVISA-OP-TMMA`), RVISA 0.2.0, rank-2 A and B, signed `int8` inputs, `int32` accumulator |
| Rule identity | `VME-TMMA-I8I32` |
| Operand domain | `M = N = 32`; `K` any positive integer; `valid_k ∈ [0,K]`; `ALayout = colmajor`, `BLayout = rowmajor`, `CLayout = rowmajor`; any `mode` for rank-2 inputs; `ordered` or `tree` |
| Target instruction | `vtmms.tvv mtd, vs2, vs1` — `Zvti8i32mm`, one instruction per fragment of at most `KMAX = 4` terms |
| Register classes and groups | `vs2` and `vs1`: four row registers each, rows separated by 2 registers inside one eight-register group, base modulo 8 less than 2; `mtd`: one `TEW = 32` tile |
| Configuration | `mtype.mtwiden = 3` (`TWIDEN = 4`), `mtype.tm = 32`, `mtype.tk` per fragment, `vl = tn = 32`, `vtype.vsew = 8`, `vtype.altfmt = 1`, derived `vtype.vlmul = 0`, `vstart = 0` |
| Numerical obligation | Exact integer accumulation within the representable `int32` domain; see [numerics](numerics.md) |

### Selection preconditions

1. The target implements `Zvtbase`, `Zvt8e`, and `Zvti8i32mm`, with `TE = 32`, `VLEN = 1024`, and `KMAX = 4`.
2. The matrix unit is configured: `mtype.mtwiden ≠ 0` and `vtype.vill = 0`.
3. `msettm(32)`, `msettn(32)`, and `msettk(tk)` return exactly `32`, `32`, and `tk`; a returned value that differs indicates a target outside the pinned parameters.
4. No `vsetvli` or `vsetivli` was executed after `msetmtypei`, because those instructions clear `mtype`.
5. `mstatus.MS` (and `vsstatus.MS` when `V = 1`) is non-`Off`.
6. The two operand bases satisfy the modulo-8 rule and their rows do not collide; the accumulator tile is one of `mt0`, `mt4`, `mt8`, `mt12`.
7. The caller accepts the numerical domain restriction of [numerics](numerics.md).

### Configuration sequence

1. `msetmtypei e8[alt], w4` — writes `mtype.mtwiden = 3`, `vtype.vsew = 8`, `vtype.altfmt = 1`, sets `vl = 0`, derives `vlmul` and `vma`/`vta`. The `altfmt = 1` selection is what makes `vtmms.tvv` a signed × signed instruction; the exact token spelling of that form is provisional in the source (see [sources](sources.md#provisional-and-unresolved-points-in-the-source)).
2. `msettm rd, 32` — sets `tm` to `min(32, LMUL·EVE, ETE) = 32`. `msettm` raises *Illegal Instruction* if `mtwiden = 0`.
3. `msettn rd, 32` — sets `vl = tn = 32`.
4. `msettk rd, tk` — sets the fragment depth for the fragment about to be executed; `tk` is at most `KMAX = 4`.
5. The accumulator is initialized: `vtzero mtd` for an explicit zero, or 32 `vtle32` row transfers, or `vtmv.t.v` per row from vector registers.

Steps 2 to 4 are repeated whenever `tk` changes, which is at most once per `tmma` call: the last fragment may use a smaller depth.

### Sequence family

The block below is pseudocode, not assembly: it names steps and ordering obligations. `msettm`, `msettn`, and `msettk` take `rd` as a destination for the clamped value, which the pseudocode omits when the value is not needed.
~~~text
msetmtypei e8[alt], w4           # step 0: matrix unit + vtype, provisional spelling
msettm  rd, 32                   # step 1: tm = 32
msettn  rd, 32                   # step 2: vl = tn = 32
# initialize the accumulator tile                                    # step 3
for each fragment j with depth tk_j:                                # step 4
    msettk rd, tk_j                                                 # step 4a
    stage the tk_j A rows into the vs2 registers                     # step 4b
    stage the tk_j B rows into the vs1 registers                     # step 4c
    vtmms.tvv mtd, vs2, vs1                                          # step 4d
# read out the accumulator tile                                      # step 5
~~~

| Step | Operands and groups | Effect |
| --- | --- | --- |
| 4a | `mtype.tk` | Selects the contraction depth of the next instruction; `tk = 0` makes the instruction a no-op. |
| 4b/4c | `vs2`, `vs1` row registers | Write the row images; rows are `a[k0+t, 0:32]` and `b[k0+t, 0:32]`. |
| 4d | `mtd`, `vs2`, `vs1` | Reads `tk_j` rows of both operands, reads and writes the active `tm × tn` submatrix. |
| 5 | `mtd` | The tile holds the result; save it before any reuse of the tile. |

The family permits reordering or double-buffering the row staging and permits continuing a chain across several virtual operations that share the accumulator. It does not permit reordering the fragment sequence, replacing the instruction with a vector dot-product sequence, or reaching the same tile through a different `TEW`.

### Coordinate transformation

The K axis is split into fragments of at most four terms; inside a fragment, `k - k0` selects the row register. A and B are transposed relative to the IME register layout: the A operand is stored as `[K,M]` rows and is consumed transposed, which is exactly RVISA's `ALayout = colmajor` view. No element of `M`, `N`, or `K` is redefined by the microtile geometry.

### Boundary behavior

| Case | Behavior |
| --- | --- |
| `valid_k = 0` | Rule [VME-TMMA-I8I32-K0](#rule-vme-tmma-i8i32-k0). |
| `valid_k` not a multiple of 4 | Legal: the last fragment programs `tk = valid_k mod 4` and contracts only those terms. No padded data is created and no zero term is introduced. |
| `valid_k` a multiple of 4 | All fragments use `tk = 4`. |
| `K` not a multiple of 4 | Legal for the same reason; the fragment count is `ceil(K ÷ 4)` and the final depth is `K mod 4`. |
| `M` or `N` other than 32 | Diagnosed. |
| Zero-extent inputs | Not applicable: `M`, `N`, `K` are positive extents; `valid_k = 0` has its own rule. |
| Tail elements | `tm = tn = 32` leaves the tile tail empty; accumulator elements outside `[0,tm) × [0,tn)` are tail-agnostic and, for this geometry, non-existent. |
| Faults and restart | The compute instruction performs no memory access. It requires `vstart = 0`; `vtle32`/`vtse32` follow the vector precise-exception model and raise an address-misaligned or access-fault exception without partial completion, so a row transfer either completes or traps with no memory write. |
| Register pressure | Staging rows may reuse the operand registers freely; if two compliant operand bases cannot be provided, the case is unsupported. |
| Temporary lifetime | Row registers die at step 4d; the tile is the only loop-carried value. |

## Rule VME-TMMA-I8I32-K0

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma` with the operand domain of [VME-TMMA-I8I32](#rule-vme-tmma-i8i32) and `valid_k = 0` |
| Rule identity | `VME-TMMA-I8I32-K0` |
| Target sequence | `msettk rd, 0` followed by at most one `vtmms.tvv`, which updates no state, or no compute instruction at all |
| Register classes and groups | The `mtd` tile holding `acc`; no operand rows required |
| Configuration | The configuration sequence still runs, because the capability and state checks of the enclosing rule apply at `valid_k = 0` |
| Numerical obligation | The result is the normalized accumulator; see [`RVISA-TMMA-K-1`](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails) |

Two realizations are declared equivalent: omitting the compute instruction, or executing it with `tk = 0`, which the source defines as no computation and no state update. The second form is useful where a uniform instruction stream is preferred. Neither form relaxes the initialization requirement for `acc`.

## Diagnostics

| Condition | Diagnostic |
| --- | --- |
| `M ≠ 32`, `N ≠ 32` | Geometry outside the declared domain. |
| `valid_k` negative or greater than `K` | Active-extent violation. |
| Rank-3 or mixed-rank inputs | Batch decomposition not defined in this revision. |
| Unsupported layout enums | Layout triple outside the declared domain. |
| Mixed or unsigned input rows | No signedness operand in the virtual operation. |
| `mtwiden = 0`, or `vsetvli`/`vsetivli` after `msetmtypei` | Matrix unit unconfigured; the compute instruction would be reserved or meaningless. |
| `msettm`/`msettn`/`msettk` return values differ from the request | Target parameters differ from the pinned profile. |
| Operand base modulo 8 not less than 2, or colliding rows | Allocation constraint violation. |
| Accumulator result outside the representable `int32` domain | Numerical domain violation; see [numerics](numerics.md#equivalence-domain). |
| Non-resident accumulator tile | Resource failure; the tile must be saved first. |

## Evidence and cost

No layer beyond documentation has been executed; [conformance.yaml](conformance.yaml) records each layer as `not-run`. Future inspection obligations: the emitted compute instruction is `vtmms.tvv` with `altfmt = 1` configured; operand bases satisfy the modulo-8 rule; the number of compute instructions equals `ceil(valid_k ÷ 4)` with the final `tk` equal to `valid_k mod 4`; no `vsetvli` appears between configuration and compute; and the accumulator is initialized exactly once.

No performance claim is made. The row-separation rule means the four row registers of an operand occupy half of an eight-register window, which is a structural footprint, not a measured cost.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [numerics](numerics.md).
