# Block-Scaled GEMM

This workload associates input scales with groups of elements along the contraction dimension.

For a positive block size G dividing K, a mathematical reference uses:

```text
A:  [M, K]       SA: [M, K/G]
B:  [N, K]       SB: [N, K/G]
q(k) = floor(k/G)
D[m,n] = C[m,n]
         + sum_k (A[m,k] * SA[m,q(k)]) * (B[n,k] * SB[n,q(k)])
```

## Numerical contract

Specify payload and scale formats, decoding, scale application, intermediate precision, accumulation order, and output conversion. The formula expresses scale association; implementation rounding follows the operation's numerical contract.

Scaling applies to the inputs, not the initial accumulator. A partial active K range retains the scale-block interpretation of the full value shape.

## Mapping concerns

A target's payload support does not imply native block scaling. Validate scale representation, block size, packing, and numerical equivalence before choosing a native or decomposed path.

## Verification cases

Use nonuniform scales and accumulators, block-boundary tails, and zero active K. Separate coordinate checks from low-precision decoding and floating-point behavior.

Python/C++ source forms are TBD. See [matrix operations](../../spec/operations/matrix/README.md), [numerics](../../spec/core/numeric-model.md), and the [workload index](../README.md).
