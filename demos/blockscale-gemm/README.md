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

Record payload, scale, and accumulator operand correspondence in the target sequence, including their register classes/groups or other required operand forms. Inspect packing, alignment, transfer, and spill/staging conditions for the selected profile.

## Verification cases

Use nonuniform scales and accumulators, block-boundary tails, and zero active K. Separate coordinate checks from low-precision decoding and floating-point behavior.

The source form is described in [Source form](#source-form). See [tmma_scaled](../../spec/operations/matrix/tmma-scaled.md), [numerics](../../spec/core/numeric-model.md), and the [workload index](../README.md).

## Source form

[blockscale-gemm.rvisa](blockscale-gemm.rvisa) expresses the workload in RVISA
notation with `K = 32`, `Ks = 2`, and block length `G = K/Ks = 16`. Scale shapes
follow [RVISA-SCALE-SHAPE-1](../../spec/operations/matrix/tmma-scaled.md#scale-axes-and-block-inference):
`A [M,K]` pairs with `SA [M,Ks]`, and `B` in the colmajor view `[N,K]` pairs with
`SB [N,Ks]`.

~~~text
a = tload(a_view, origin=[0, 0], shape=static<[16, 32]>, other=0)
sa = tload(sa_view, origin=[0, 0], shape=static<[16, 2]>, other=0)   # [M, Ks]
b = tload(b_view, origin=[0, 0], shape=static<[16, 32]>, other=0)
sb = tload(sb_view, origin=[0, 0], shape=static<[16, 2]>, other=0)   # [N, Ks]
d = tmma_scaled(a, sa, b, sb, 0, ALayout=rowmajor, BLayout=colmajor,
                CLayout=rowmajor, mode=reduce, reduce_order=ordered, valid_k=32)
tstore(d_view, origin=[0, 0], value=d)
~~~

Notation only: nothing compiles or executes this file (this revision has no frontend). `demo.yaml` records the metadata.

Payload and scale formats are deliberately not chosen: `tmma_scaled` leaves them
to a profile, and this form states only shapes, axes, and the contraction. The
operation has no block-size operand; `G` follows from `K` and `Ks`.

Not covered: payload and scale formats, decoding and scale-application rounding,
partial active K, block-boundary tails, nonuniform scales, and `K` not divisible
by `Ks`.
