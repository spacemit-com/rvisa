# GEMM with Epilogue

This workload performs matrix multiply-accumulate followed by a bias and an elementwise activation.

```text
P[m,n] = C[m,n] + sum_k A[m,k] * B[n,k]
Y[m,n] = activation(P[m,n] + bias[n])
```

## Semantic contract

The epilogue is applied after accumulation over the complete K range. Bias is applied once per output element. The activation and any approximation policy must be specified for the selected variant.

Input/output layouts and types follow the associated GEMM contract. Conversions between accumulation and output formats have explicit rounding behavior.

## Mapping concerns

Preserve the output coordinate order when moving between matrix and vector execution domains. Account for accumulator transfers, staging storage, layout conversion, and configuration restoration.

Identify the matrix accumulator representation, the vector register groups used by the epilogue, and the instructions that transfer between them. Inspect register overlap, conversion, and preservation constraints separately from the final numerical result.

## Verification cases

Check bias contribution count, negative/positive activation inputs, numerical extremes in the declared domain, and partial output tiles. Compare fused and decomposed realizations under the same permitted numerical behavior.

Python/C++ source forms are TBD. See [GEMM](../gemm/README.md), [vshape](../../spec/operations/vector/vshape.md), [tile/vector interoperation](../../spec/types/tile.md#relationship-to-vectors), and the [workload index](../README.md).
