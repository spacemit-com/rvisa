# Numeric Model

Numerical behavior is part of an operation's contract. Algebraic equality alone does not establish floating-point equivalence.

## Precision and rounding

An operation identifies input, product, intermediate, accumulator, and result formats. It also identifies rounding points and modes, fused or unfused behavior, and the conditions under which a target result is acceptable.

An implementation must not introduce a narrower intermediate, flush subnormals, or enable reassociation merely because a target instruction makes that convenient.

## Reductions

Batch pairing and numerical reduction order are separate properties. The former identifies which input values contribute to an output; the latter determines permitted accumulation behavior.

An ordered reduction preserves the specified sequence and initialization. A tree-permitted reduction allows the reassociation defined by its contract without reducing the required accumulation precision. A mathematical summation symbol does not, on its own, authorize reassociation.

## Special values and approximations

Each applicable operation defines its treatment of NaN, infinities, signed zero, subnormals, overflow, and exceptional conditions. Approximate functions declare their accuracy domain and error criterion.

Where a contract remains provisional, its uncertainty is recorded in [Specification Status](../status.md) and the operation definition. It must not be treated as unrestricted fast-math permission.

## Scaling and tails

Block scaling defines scale formats, decoding, grouping axes, multiplication order, and rounding before accumulation. Support for a low-precision payload format does not imply support for block scaling.

Zero-filled inactive elements are not automatically equivalent to omitting the corresponding arithmetic, particularly for strict floating-point behavior. Tail legality is established against both the numerical and memory contracts.

Target differences and equivalence conditions are documented in each profile's numerical contract. Independent reference checks must model the precision they claim to verify.

See [matrix operations](../operations/matrix/README.md) and [conformance](../conformance.md).
