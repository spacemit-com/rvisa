# Mapping Revision History

## ame-main revision 1 — initial profile

| Property | Value |
| --- | --- |
| Profile | `ame-main`, mapping revision 1, status `draft` |
| RVISA revision | 0.2.0 |
| Upstream source | `riscv/riscv-attached-matrix-extension` @ `8d27acdcee7a189aad4e2907412e0c40a9d4b9e2` (tag `v0.6`), accessed 2026-11-05 |

### Scope established

* Declared subset: rank-2 `tmma` with `fp16` inputs and an `fp32` accumulator, realized by `mmulacc.2d`.
* Single geometry: `AME_UNIT_DATATYPE_SIZE = 32`, `AME_NELEM = 256` (`N = 16`), two packed input squares per register, contraction depth 32 per instruction, `K` a positive multiple of 32.
* Axis correspondence: `ALayout`/`BLayout`/`CLayout` all `rowmajor`, because the instruction computes `C = C + A × B` with `A` as `[M,K]` and `B` as `[K,N]`.
* Register model: one matrix register per operand, one accumulator register, datatype descriptors `FP16`/`FP32` with RNE rounding and denormals enabled, ownership through `ame.acquire`, and no memory-to-accumulator path.
* Numerical contract: exact `fp16` products with `fp32` RNE accumulation in an implementation-defined deterministic order; `reduce_order = tree` only.
* Transfer model: interoperability images through `mls.rm`/`mss.rm`, with the block-column layout of A distinct from the row-major layout of B.

### Deliberate omissions and unresolved items

* `reduce_order = ordered` is diagnosed: the extension does not promise increasing-`k` accumulation with widened FMA.
* Partial contraction fragments are diagnosed because the instruction has no contraction-length operand and zero substitution is not equivalent.
* Rank-3 batch pairing, multi-square outputs, and transposing forms (`mmulatacc.2d`, `mmulbtacc.2d`) are excluded.
* The `fp16 → fp32` tuple is a profile precondition, since AME leaves datatype and operation/datatype support to the implementation; detecting an unsupported tuple requires an `amestatus.UN` read.
* The `-0.0` accumulator case is excluded from the raw-zero initialization path.
* The general operand base-alignment derivation is not stated in the pinned revision; the profile avoids it with one-register spans.

### Compatibility

First revision; no migration path. A later revision that changes the parameter set, the datatype tuples, the layout triple, the reduction-order claim, the initialization paths, or the transfer images changes the mapping contract and requires a new `mapping_revision` under the [revision policy](../../../contract.md#revision-policy).

### Verification state

Documentation checks passed; IR legality, compilation, instruction inspection, numerical evaluation, simulator execution, device execution, and performance are recorded as `not-run` in [conformance.yaml](conformance.yaml).
