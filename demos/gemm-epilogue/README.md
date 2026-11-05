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

The source form is described in [Source form](#source-form). See [GEMM](../gemm/README.md), [vshape](../../spec/operations/vector/vshape.md), [tile/vector interoperation](../../spec/types/tile.md#relationship-to-vectors), and the [workload index](../README.md).

## Source form

[gemm-epilogue.rvisa](gemm-epilogue.rvisa) expresses the workload in RVISA
notation: one 16x16x16 contraction, a bias row broadcast across M, and a ReLU.
The activation is fixed to ReLU because `tmax` with a zero tile is the only
epilogue whose operation and numerical requirement are both defined here; any
other activation needs its own variant contract.

~~~text
p = tmma(a, b, 0, ALayout=rowmajor, BLayout=colmajor, CLayout=rowmajor,
         mode=reduce, reduce_order=ordered, valid_k=16)
bias = tload(bias_view, origin=[0, 0], shape=static<[1, 16]>, other=0)
q = tadd(p, tbroadcast(bias, static<[16, 16]>, axes=[1]))   # bias[n] across m
y = tmax(q, tzero(tile<f32, [16, 16]>))                     # ReLU
tstore(y_view, origin=[0, 0], value=y)
~~~

Notation only: nothing compiles or executes this file (this revision has no frontend). `demo.yaml` records the metadata.

The multi-argument broadcast notation is provisional in the tile vocabulary
(`axes` names the retained source axis, 1 for `n`); this form shows one
unambiguous reading rather than settling that notation.

Not covered: other activations, fused versus decomposed epilogue realizations,
partial output tiles, numerical extremes, and conversion rounding between the
accumulator and the output format.
