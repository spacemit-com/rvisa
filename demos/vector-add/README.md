# Vector Addition

This workload computes elementwise addition over two one-dimensional inputs.

```text
Y[i] = X[i] + Z[i],  0 <= i < N
```

## Data contract

X, Z, and Y have compatible element types and valid storage for N elements. The reference case uses nonoverlapping input/output regions; aliasing variants require explicit access contracts.

The numerical behavior follows the selected scalar/vector addition type. N is a runtime extent and does not change scalable type capacity.

## Mapping concerns

Process the main range and tail according to actual supported vector capacity and active-length behavior. Preserve configuration dependencies and avoid accesses beyond N.

## Verification cases

Cover N=0, N=1, values around a capacity boundary, and multiple iterations. Verify both arithmetic and untouched memory outside the output range.

Python/C++ source forms are TBD. See the [workload index](../README.md), [vector types](../../spec/types/vector.md), and [memory model](../../spec/core/memory-model.md).
