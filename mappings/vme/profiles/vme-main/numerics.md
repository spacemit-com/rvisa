# Numerical Mapping

The tuple is integer, so there is no rounding, no special value, and no flag update. The open matrix-numerics contract in [Specification Status](../../../../spec/status.md#open-contracts) concerns floating-point behavior and does not apply. One genuine gap does affect this profile: the pinned source does not state what happens when the integer accumulator overflows.

## Arithmetic contract

| Quantity | Contract |
| --- | --- |
| Input format | Signed two's-complement `int8`, one element per byte. |
| Product | Exact: an `int8 × int8` product is representable in signed 16 bits. No product rounding exists. |
| Intermediate | Exact integer partial sums inside one instruction. |
| Accumulator | Signed `int32`, seeded once from `acc` and updated once per contributing product. |
| Result | Signed `int32`, written over the accumulator element. |
| Rounding mode | None. The source's floating-point rounding rules in the same section apply to the `.tvv` floating-point mnemonics only. `frm`, `fcsr`, and `fflags` are neither read nor written. |
| Reduction order | For results inside the representable range, integer addition is associative and commutative, so `ordered` and `tree` produce identical bits. The source's `tk`-deep dot product does not define a visible grouping. |
| Fused/unfused | Not applicable: no rounding point exists between product and accumulation. |
| Special values | None. No NaN, infinity, signed zero, subnormal, or zero point exists in the tuple. |
| Saturation | The section that defines the floating-point behavior states that the fixed-point saturation flag is not updated by matrix arithmetic, which is evidence that the integer path does not signal saturation; it does not define the value produced on overflow. |
| Flags | No flag defined for ordinary integer accumulation. |

## Equivalence domain

| Class | Statement |
| --- | --- |
| Exact equivalence | Every input whose exact accumulated result lies in `[-2^31, 2^31 - 1]`. The target equals the exact integer sum. |
| Specification-permitted variation | Reassociation only, and only because it cannot change an exact integer sum. Both `reduce_order` values are accepted with the same required bits. |
| Unresolved region | Inputs whose exact result exceeds the `int32` range. The pinned source defines neither wrap-around, saturation, nor an exception for the integer rows, and this profile does not supply a rule by analogy with another extension. Such a case is **unsupported** by this revision rather than computed within a convention. |
| Approximation | None. No tolerance is admitted. |
| Excluded from the domain | Unsigned or mixed-sign operands, a non-`int32` accumulator, a layout triple other than the declared one, and `M`/`N` other than 32. |

The domain boundary is a property of the data, not of the shapes: a conforming program must ensure that no final element exceeds the representable range. Because the accumulator is `int32` and each fragment adds at most four products of magnitude at most `2^14`, a program can bound the risk by its choice of `K` and input magnitudes, which is why the restriction is stated as a numerical domain rather than as a shape constraint.

Register and tile boundaries do not affect the numerical result: a row register holds exactly the `tm` or `tn` active elements with no padding contribution, and each fragment adds exactly `tk` products per output element. A boundary error would be a coordinate error, detected by the coordinate cases.

## Comparison strategy

1. Compute the exact integer sum from the effective coordinates of [`tmma` value semantics](../../../../spec/operations/matrix/tmma.md#value-semantics), using `valid_k` as the contraction bound.
2. Reject the case if any exact result lies outside the representable `int32` domain, rather than comparing an implementation-defined overflow.
3. Compare bit-exactly with the target result.

The specification-level coordinate cases in [core design cases](../../../../conformance/cases/core-designs.md#matrix-pairing-and-accumulation) can be embedded as `32 × 32` tiles by placing case values in the leading submatrix and zero elsewhere, with `K` padded by zero-valued rows: for an integer tuple, adding a zero product is exact and the identity element is unambiguous. `MMA-06` is a floating-point ordering case and is not applicable. No case has been executed for this revision.

## Evidence

* Source claims on the integer path and on the absence of a saturation flag: [sources](sources.md#claims), [provisional points](sources.md#provisional-and-unresolved-points-in-the-source).
* Coverage: rules `VME-TMMA-I8I32` and `VME-TMMA-I8I32-K0` in [conformance.yaml](conformance.yaml), both recorded as `not-run` at the numerical, compilation, and execution layers.
* Reference-model precision: unbounded integers with an explicit representability check; strictly more precise than the target and therefore a valid oracle inside the declared domain.

Return to the [profile overview](README.md) · [lowering rules](lowering.md).
