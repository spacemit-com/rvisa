# Numerical Mapping

Define the numerical behavior of each mapped operation and its relationship to the RVISA requirement.

## Arithmetic contract

Record input, product, intermediate, accumulator, and result formats; rounding modes and points; fused/unfused behavior; reduction grouping/order; special values; flags; and scaling semantics when relevant.

## Equivalence domain

Identify the exact input/configuration domain for which the target satisfies the source contract. Separate exact equivalence, specification-permitted variation, and approximation guarantees.

A narrowing intermediate or reordered reduction requires explicit justification. Unsupported cases need a legal decomposition or rejection; they cannot be included through an unspecified tolerance.

## Evidence

Reference fixed [sources](sources.md) and independent cases in the [conformance record](conformance.yaml). Record the reference model's precision and limits as well as the implementation's behavior.
