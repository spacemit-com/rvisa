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

The primary operation is [tmma](../../spec/operations/matrix/tmma.md), with [tview/tload/tstore](../../spec/operations/memory/tile-memory.md) for memory. Python/C++ source forms are TBD. See the [workload index](../README.md).
