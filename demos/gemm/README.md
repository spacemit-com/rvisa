# Matrix Multiply-Accumulate

This workload uses the default RVISA matrix-axis interpretation:

```text
A: [M, K]
B: [N, K]
C, D: [M, N]
D[m,n] = C[m,n] + sum_k A[m,k] * B[n,k]
```

B exposes N/K coordinates even though its mathematical role is the right-hand matrix. An overwrite variant supplies a zero initial accumulator.

## Data and numerical contract

Specify input/accumulator/output types, physical strides, bounds, alignment, aliasing, and the reduction policy. Initialize each output accumulator once across the full K range.

Matrix-axis layout, memory layout, and target representation are separate choices. The mathematical expression does not authorize a different floating-point reduction sequence.

## Mapping concerns

Select legal microtiles, prepare operand layouts, retain the accumulator across K partitions, and handle M/N/K boundaries. Include configuration transitions and any register-domain transfers.

Record the instruction sequence and separate register classes/groups for A, B, and the accumulator/result. Check coordinate packing, overlap, live accumulator requirements, and the conditions for fragmentation, spills, or staging under the selected profile.

## Verification cases

Cover rectangular shapes, nontrivial strides, initial accumulators, zero extents, and partial tiles. Compare against an independent computation using the declared numerical policy.

The primary operation is [tmma](../../spec/operations/matrix/tmma.md), with [tview/tload/tstore](../../spec/operations/memory/tile-memory.md) for memory. The implemented source form is described in [Source form](#source-form). See the [workload index](../README.md).

## Source form

`gemm.rvisa` expresses this workload in RVISA notation: one 16x16x16 tile, one
`tmma`, an explicit zero accumulator. It is a specification-level source form, not
a program: this revision contains no frontend, so nothing compiles or executes it,
and it states no target instruction, register class or group, configuration
effect, or transfer.

~~~text
a_view = tview(ptr_a, sizes=[16, 16], strides=[16, 1])   # A: ptr<f16>, [M,K]
b_view = tview(ptr_b, sizes=[16, 16], strides=[16, 1])   # B: ptr<f16>, [N,K]
d_view = tview(ptr_d, sizes=[16, 16], strides=[16, 1])   # D: ptr<f32>, [M,N]

a = tload(a_view, origin=[0, 0], shape=static<[16, 16]>, other=0)
b = tload(b_view, origin=[0, 0], shape=static<[16, 16]>, other=0)

d = tmma(a, b, 0,
         ALayout=rowmajor, BLayout=colmajor, CLayout=rowmajor,
         mode=reduce, reduce_order=ordered, valid_k=16)

tstore(d_view, origin=[0, 0], value=d)
~~~

What each line fixes:

- `tview`/`tload`: the two input descriptors, the runtime origin, the compile-time
  tile shape, and the required fill value for coordinates outside the descriptor
  ([RVISA-TLOAD-BOUNDS-1](../../spec/operations/memory/tile-memory.md#tload)).
- `tmma`: operand positions are input, input, accumulator. A is exposed as `[M,K]`
  and B as `[N,K]` under `BLayout.colmajor`, so no second transpose is implied.
  The accumulator is an explicit runtime zero, never a read of output memory.
- `tstore`: the shape is inferred from the complete value, and writes obey
  [RVISA-TSTORE-BOUNDS-1](../../spec/operations/memory/tile-memory.md#tstore).

Element types are `f16` for A and B and `f32` for the accumulator and result, the
baseline combination in [Element types](../../spec/types/element-types.md). The
zero accumulator selects the overwrite variant of the workload. `reduce_order`
is stated as `ordered` because the surface notation must name it; no numerical
policy beyond that is chosen here, and the open items under "Matrix numerics" in
[status](../../spec/status.md) stay open.

### Verification

Structural only: the file is present, every operation name and operand role
matches its synopsis, and the links in this section resolve. No execution,
compilation, instruction inspection, simulator run, or performance measurement is
recorded, because this revision has no frontend.

### Not covered

- `valid_k` tails, several tiles, several K blocks, non-unit strides, nonzero
  origins, batch axes, and a nonzero initial accumulator.
- `bf16` inputs, mixed formats, and low-precision or block-scaled tuples.
- [tmma_scaled](../../spec/operations/matrix/tmma-scaled.md), epilogues, and bias.
- Any register representation, transfer, or configuration realization; mapping
  begins with a registered profile.
