# Numerical Mapping

The tuple is floating point, so this document is where the profile's numerical obligations and its limits are stated precisely. Two properties carry the profile: `fp16 × fp16` products are exact in `fp32`, and the accumulation order is implementation-defined but deterministic.

## Arithmetic contract

| Quantity | Contract |
| --- | --- |
| Input format | `FP16`: 1 sign, 5 exponent, 10 mantissa bits, denormals enabled, infinities supported. |
| Product | Exact in `fp32`. An `fp16 × fp16` product has at most 22 significand bits, which is at most the 24-bit `fp32` significand, so no product rounding occurs and fused versus unfused multiplication is numerically void for this tuple. |
| Intermediate | `fp32` per addition; the implementation does not reduce products separately, because the fold is seeded by the accumulator element. |
| Accumulator format | `FP32`, RNE rounding (from `Ad[acc]`), denormals enabled, tininess detected after rounding. |
| Result format | `FP32`, same contract. |
| Rounding points | One per accumulator addition. There is no rounding point between product and accumulator for this tuple. |
| Reduction grouping and order | Implementation-defined deterministic permutation of the 32 `(s,q)` terms of each instruction; instructions execute in program order, so the K chain is in increasing fragment order. |
| Special values | Any NaN input or invalid operation produces the destination datatype's canonical quiet NaN, and a signaling NaN is quieted; NaN payload preservation is not required. Invalid operations include indeterminate infinity arithmetic and zero times infinity. If the destination cannot represent a required infinity, the result saturates to the maximum finite magnitude. |
| Flags | `NV`, `DZ`, `OF`, `UF`, `NX` accrue in `amefflags`; `fflags` is untouched, and `amexsat` is unused. |
| Zero signs | Preserved by the `fp32` operations; the accumulator's initial sign matters, which is why `-0.0` cannot be initialized through the raw-zero path. |

## Equivalence domain

| Class | Statement |
| --- | --- |
| Exact equivalence | Not claimed as bit-exact against a fixed order: the two exactness facts are that every product is exact and that each addition rounds once to `fp32` RNE. |
| Specification-permitted variation | Reassociation of the 32 terms inside an instruction and of the fragment sequence, at `fp32` precision only. This is exactly RVISA's `tree` contract, so `reduce_order = tree` is satisfied. |
| Not satisfied | `reduce_order = ordered`, which requires widened FMA in increasing `k` order with one continuous accumulation. The implementation's intra-instruction permutation is fixed but need not be increasing in `k`, so an `ordered` request is diagnosed rather than silently mapped. |
| Narrower intermediates | Excluded. Nothing narrows below `fp32`, and the profile rejects a target whose accumulator datatype is not `fp32`. |
| Excluded from the domain | Non-`fp16` inputs, non-`fp32` accumulator, descriptor values with `Denorm = 0` (flush-to-zero) or `Inf = 0` (saturating infinities), `K` or `valid_k` not multiples of 32, and layouts outside the declared triple. |

The profile does not carry a tolerance. Because products are exact, any disagreement with a reference is either a coordinate error, a different association order, or a different rounding/denormal policy — all of which are meant to be visible rather than absorbed into an error budget.

## Comparison strategy

1. Compute the reference with exact product terms (`fp16` values converted exactly to `fp32` or wider) and with the association order the implementation documents for its `(s,q)` permutation. Compare bit-exactly. This is the only admissible bit-exact comparison, because the order is not fixed by the extension.
2. Alternatively, compute an interval or `fp64` reference of the exact sum and require the target result to lie within the `fp32` rounding neighbourhood of the exact sum for each output element. This accepts any permitted association while rejecting a narrower intermediate or a flush-to-zero policy; it requires an explicit statement of the neighbourhood, not a generic epsilon.
3. Reject a case whose inputs include a NaN or infinity unless the exact special-value outcome of the tuple is stated for that input, because canonical-NaN and saturation rules replace payload propagation.

The specification-level coordinate cases in [core design cases](../../../../conformance/cases/core-designs.md#matrix-pairing-and-accumulation) can be embedded in the `16 × 16` square with small exactly representable values and zero padding; `MMA-06` is the ordering case and cannot be reproduced by this profile, because `ordered` is not claimed. No case has been executed for this revision.

## Evidence

* Source claims on the fold, rounding, and flags: [sources](sources.md#claims), [provisional points](sources.md#provisional-and-unresolved-points-in-the-source).
* Coverage: rules `AME-TMMA-F16F32` and `AME-TMMA-F16F32-K0` in [conformance.yaml](conformance.yaml), both recorded as `not-run` at the numerical, compilation, and execution layers.
* Reference-model precision: exact products with `fp32` rounding per addition under a stated order, or a `fp64` interval reference. The reference's precision and its association order must be recorded with any result.

Return to the [profile overview](README.md) · [lowering rules](lowering.md).
