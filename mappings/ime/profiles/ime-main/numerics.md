# Numerical Mapping

The declared tuple is an integer tuple, so its numerical contract is complete: there is no rounding, no special value, and no flag update. The open matrix-numerics contract in [Specification Status](../../../../spec/status.md#open-contracts) concerns floating-point rounding and special values and does not affect this profile.

## Arithmetic contract

| Quantity | Contract |
| --- | --- |
| Input format | Signed two's-complement `int8`, range `[-128, 127]`. `altfmt_A = altfmt_B = 0`. |
| Product | Exact: each `int8 × int8` product is representable in signed 16 bits, so no product rounding exists. |
| Intermediate | Exact integer partial sums inside one instruction; no intermediate narrowing is observable. |
| Accumulator | Signed `int32`, seeded once from the incoming `acc` element and updated once per contributing product. |
| Result | Signed `int32`, written over the accumulator element. |
| Rounding mode | None; every intermediate is integral. `frm`, `fcsr`, and `fflags` are neither read nor written. |
| Reduction order | Sign-irrelevant: the instruction reduces modulo `2^SEW = 2^32`, and modular addition is associative and commutative, so `ordered` and `tree` produce the same bits. |
| Reduction grouping | Not observable: per-fragment grouping, per-instruction grouping, and the K-chain order all denote the same residue class. |
| Fused/unfused | Not applicable: no rounding point exists between product and accumulation. |
| Special values | None. There is no NaN, infinity, or signed zero in the tuple, so the `RVISA-TMMA-ORDER-1` special-value questions do not arise. |
| Overflow behavior | Defined by the source: results wrap modulo `2^32`. An implementation that saturates or traps would violate the contract. |
| Flags | The pinned text defines no flag update for the ordinary integer path, and none for a fixed-point saturation flag; see the integer-accumulation wording in [sources](sources.md#provisional-and-unresolved-points-in-the-source). |

The contract is exactly the source's modular accumulation statement: all intermediate results are reduced modulo `2^SEW`, so the final value is uniquely defined "regardless of the accumulation order or grouping factor".

## Equivalence domain

| Class | Statement |
| --- | --- |
| Exact equivalence | All input values in the declared tuple, including inputs whose exact sum exceeds the `int32` range. The target result equals the residue of the exact integer sum modulo `2^32`, interpreted as `int32`. |
| Specification-permitted variation | Reassociation only, and only because it cannot change the residue. The profile accepts both `reduce_order` values for the same reason and requires identical bits from both. |
| Approximation | None. No tolerance is admitted. |
| Excluded from the domain | Any tuple with an unsigned operand, any non-`int32` accumulator, any layout triple other than the declared one, and any `valid_k` that is not a multiple of 16. These are rejected rather than computed within a tolerance. |

Fragment boundaries and register packing preserve the numerical order of contributions: the packed `int8` layout is the source's standard element ordering, and each chain step adds exactly one fragment's 16 contributions. A fragment ordering error would therefore be a coordinate error, detected by the coordinate cases, not a rounding difference.

The profile does not require narrowing intermediates: there are none, because input widening is exact.

## Comparison strategy

An independent check must not reuse the target's accumulation order as its own oracle in a way that hides a coordinate error. The recommended reference model is:

1. Compute the exact integer sum with unbounded precision from the effective coordinates of [`tmma` value semantics](../../../../spec/operations/matrix/tmma.md#value-semantics), using `valid_k` as the contraction bound only.
2. Reduce the sum modulo `2^32` and interpret the residue as a signed `int32` value.
3. Compare bit-exactly with the target result. No epsilon comparison applies to an integer tuple.

The specification-level coordinate cases in [core design cases](../../../../conformance/cases/core-designs.md#matrix-pairing-and-accumulation) can be embedded as fragments of the declared geometry (`M = N = 8`, `K` a multiple of 16) by placing the case values in the top-left submatrix and leaving the rest zero; the `MMA-06` case is a floating-point order case and is not applicable to this tuple. No such embedding has been executed for this revision.

## Evidence

* Source claims: integer accumulation, packing order, and the encoding-map row in [sources](sources.md#claims).
* Coverage: rule `IME-TMMA-I8I32` and rule `IME-TMMA-I8I32-K0` in [conformance.yaml](conformance.yaml); both are recorded as `not-run` at the numerical, compilation, and execution layers.
* Reference-model precision: unbounded integers with a final modulo reduction; this is strictly more precise than the target and is therefore a valid oracle for an exact tuple.

Return to the [profile overview](README.md) · [lowering rules](lowering.md).
