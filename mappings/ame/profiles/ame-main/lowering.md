# Lowering Rules

Two rules cover the declared subset: the fragment compute rule and the zero-contraction rule. They carry the [RVISA-MAP-1](../../../contract.md#mapping-guarantees) content for this domain. Operand detail is in [operands](operands.md); register and ownership state is in [registers](registers.md).

## Rule AME-TMMA-F16F32

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma` (`RVISA-OP-TMMA`), RVISA 0.2.0, rank-2 A and B, `fp16` inputs, `fp32` accumulator |
| Rule identity | `AME-TMMA-F16F32` |
| Operand domain | `M = N = 16`, `K` a positive multiple of 32, `valid_k` a multiple of 32 at most `K`; `ALayout = rowmajor`, `BLayout = rowmajor`, `CLayout = rowmajor`; any `mode` for rank-2 inputs; `reduce_order = tree` |
| Target instruction | `mmulacc.2d acc, ms1, ms2` — one instruction per 32-term fragment |
| Register classes and groups | `ms1`, `ms2`: one matrix register each; `acc`: one accumulator register |
| Configuration | `Md[ms1] = Md[ms2] = FP16`, `Ad[acc] = FP32`, both with RNE rounding; backend ownership held; `mstatus.MS` non-`Off` |
| Numerical obligation | Exact `fp16` products accumulated in `fp32` in an implementation-defined deterministic order; see [numerics](numerics.md) |

### Selection preconditions

1. The implementation reports `AME_UNIT_DATATYPE_SIZE = 32` and `AME_NELEM = 256` (`amenlen` 16, `ameudsz` 32) and implements the exact `mmulacc.2d` × (`FP16`, `FP16`, `FP32`) tuple.
2. The backend is enabled and owned: every applicable `MS` field is non-`Off` and `ameown.OWNED = 1`.
3. The descriptor writes are accepted: `amestatus.UN` stays 0 after `msettyp` and `asettyp`.
4. `M = N = 16`, `K` a multiple of 32, and `valid_k` in `{0} ∪ {32, 64, …}`.
5. `reduce_order = tree`; the caller does not require `ordered`.
6. The memory images supplied to `mls.rm` have the block layout of [operands](operands.md#fragment-correspondence) and bases aligned to the element size.

### Configuration and ownership sequence

1. `ame.acquire rd, rs1` with the acquisition descriptor in `rs1`. The profile does not define descriptor values; the source defines the descriptor and the acquisition result, and this revision requires only that acquisition succeeds.
2. Verify ownership through `ameown` (`OWNED = 1`).
3. `msettyp m0, <FP16 descriptor>` and `msettyp m1, <FP16 descriptor>`. Both clear their register, so they precede all data movement.
4. `asettyp acc0, <FP32 descriptor>`. This also clears the accumulator to raw zero, which is the `+0.0` initialization path only.

### Sequence family

The block below is pseudocode, not assembly: it names steps and ordering obligations, and leaves the register numbers and the datatype-descriptor values to the allocation and to the descriptor encoding.
~~~text
ame.acquire rd, rs1                       # step 0, ownership
# verify ameown.OWNED == 1                # step 0a
msettyp m0, FP16                          # step 1, clears m0
msettyp m1, FP16                          # step 1, clears m1
asettyp acc0, FP32                        # step 2, clears acc0 to +0.0
# optional: load a nonzero accumulator through m2 and mmov.a.m   # step 2b
for each fragment j:                                               # step 3
    mls.rm m0, a_image_j                                           # step 3a
    mls.rm m1, b_image_j                                           # step 3b
    mmulacc.2d acc0, m0, m1                                        # step 3c
    # check amestatus.UN == 0                                      # step 3d
mmov.m.a m0, acc0                                                  # step 4
mss.rm m0, c_image                                                 # step 4a
ame.release                                                        # step 5
~~~

| Step | Operands and groups | Effect |
| --- | --- | --- |
| 1 | `m0`, `m1`; `Md` | Programs the input datatype and destroys previous register content |
| 2 | `acc0`; `Ad` | Programs the accumulator datatype and clears the storage |
| 2b | `m2` or a free register; `Acc` | Moves a runtime accumulator into the accumulator domain; requires a matching `FP32` descriptor on the staging register |
| 3a/3b | `m0`, `m1` | Loads one square image each (1024 bytes), base aligned to 2 bytes |
| 3c | `acc0`, `m0`, `m1` | Reads both operands, reads and writes the accumulator, advances the contraction by 32 terms |
| 3d | `amestatus.UN` | Detects an unsupported tuple, which otherwise writes nothing and raises no exception |
| 4/4a | `m0`, `acc0` | Moves the result square to a matrix register and stores the row-major 1024-byte image, base aligned to 4 bytes |
| 5 | backend | Releases ownership after draining earlier operations; a release by a non-owner is a no-op that preserves the status fields |

The family permits loading all fragments in advance when registers are available, using distinct registers per fragment, and reusing `m0` for the result store. It does not permit skipping the datatype programming, assuming that an unsupported tuple succeeded, reordering the fragment sequence, or replacing the instruction with elementwise operations: the fold contract is specific to the instruction.

### Coordinate transformation

The K axis is split into 32-term fragments, and each fragment into two 16-term squares. A enters as `[M,K]` row-major blocks, B as `[K,N]` row-major. No element of `M`, `N`, or `K` is redefined by the geometry, and the result image needs no permutation beyond the row-major square order.

### Boundary behavior

| Case | Behavior |
| --- | --- |
| `valid_k = 0` | Rule [AME-TMMA-F16F32-K0](#rule-ame-tmma-f16f32-k0); no compute instruction is required. |
| `valid_k` a multiple of 32 below `K` | Emit only the first `valid_k ÷ 32` fragments; the remaining operand images are not loaded, and no zero-filled image is created. |
| `valid_k` not a multiple of 32 | Diagnosed. `mmulacc.2d` has no per-instruction contraction-length operand, so a partial fragment cannot be expressed; and substituting zeros for the excluded elements can change a NaN/Inf or signed-zero result. |
| `K` not a multiple of 32 | Diagnosed for the same reason. |
| `M` or `N` other than 16 | Diagnosed. |
| Zero-extent inputs | Not applicable: `M`, `N`, `K` are positive extents; `valid_k = 0` has its own rule. |
| Faults and restart | Register-only instructions commit atomically and leave all destinations unchanged on a synchronous exception. `mls.rm`/`mss.rm` raise an address-misaligned exception before any access and permit no partial completion on a memory fault, so a transfer either completes or is re-executed from the start. |
| Floating-point exceptions | Results are data, not traps: `NV`, `OF`, `UF`, `NX`, and `DZ` accrue in `amefflags` and are observable target state. |
| Register pressure | Without a free staging register the accumulator can still be stored by reusing an operand register after the last compute; if that is also impossible the case is unsupported. |
| Temporary lifetime | Operand registers die at step 3c; the accumulator is the only loop-carried value and must be saved before reuse. |

## Rule AME-TMMA-F16F32-K0

| Property | Definition |
| --- | --- |
| Virtual operation | `tmma` with the operand domain of [AME-TMMA-F16F32](#rule-ame-tmma-f16f32) and `valid_k = 0` |
| Rule identity | `AME-TMMA-F16F32-K0` |
| Target sequence | Empty compute sequence: the accumulator is initialized as required and no `mmulacc.2d` is executed |
| Register classes and groups | The accumulator register holding `acc`; operand registers are not required |
| Configuration | The datatype, ownership, and capability checks of the enclosing rule still apply |
| Numerical obligation | The result is the normalized accumulator; see [`RVISA-TMMA-K-1`](../../../../spec/operations/matrix/tmma.md#numerical-order-and-tails) |

The empty compute sequence is legal because the contribution set is empty and the result is the incoming accumulator in the declared representation. The accumulator must still be initialized from the virtual `acc` value, and a scalar-zero accumulator takes the `asettyp` path only when the virtual value is `+0.0`.

## Diagnostics

| Condition | Diagnostic |
| --- | --- |
| `M ≠ 16`, `N ≠ 16`, non-multiple `K` or `valid_k`, `valid_k > K` | Geometry or extent outside the declared domain. |
| Rank-3 or mixed-rank inputs | Batch decomposition not defined in this revision. |
| `ALayout`/`BLayout` requiring a transposing form, or `CLayout = colmajor` | Layout combination outside the declared domain. |
| Non-`fp16` inputs or non-`fp32` accumulator | Type contract violation. |
| Descriptor with `Inf = 0`, `Denorm = 0`, or non-RNE rounding | Numerical contract violation. |
| `reduce_order = ordered` | Only `tree` is claimed. |
| `ameown.OWNED = 0`, `MS` field `Off` | State-access violation; the target raises *Illegal Instruction*. |
| `amestatus.UN = 1` | Tuple unsupported; no destination was written. |
| Virtual accumulator `-0.0` through the `asettyp` path | Initialization path mismatch. |
| Missing staging register or accumulator | Resource failure. |

## Evidence and cost

No layer beyond documentation has been executed; [conformance.yaml](conformance.yaml) records each layer as `not-run`. Future inspection obligations: exactly one `mmulacc.2d` per 32-term fragment; one-register operand spans with no `Md` dependency on other registers; `Md`/`Ad` programmed before data movement; ownership verified before the first instruction; `amestatus.UN` read after the first compute; and the emitted image layout matching the block asymmetry of [operands](operands.md#packing-padding-and-transfers).

No performance claim is made. The transfer instruction count (one load per operand per fragment plus two instructions for the result) is structural and unmeasured.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [numerics](numerics.md).
