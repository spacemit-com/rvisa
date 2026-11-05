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

Identify the load/add/store sequence, vector register groups, mask representation if used, and configuration effects for the selected profile. Inspect grouping and tail constraints independently of the numerical comparison.

## Verification cases

Cover N=0, N=1, values around a capacity boundary, and multiple iterations. Verify both arithmetic and untouched memory outside the output range.

The source form is described in [Source form](#source-form). See the [workload index](../README.md), [vector types](../../spec/types/vector.md), [vconfig](../../spec/operations/control/vconfig.md), and [vector memory](../../spec/operations/memory/vector-memory.md).

## Source form

[vector-add.rvisa](vector-add.rvisa) expresses the workload in RVISA notation.
The vector family in this revision defines `vzero`, `vmacc`, `vbroadcast`,
`vselect`, reductions, and memory access, but no elementwise addition, so the add
is the tile operation `tadd` on explicit rank-1 tiles. Descriptor bounds then
supply the tail contract, in place of `vconfig` and the flat valid extent.

~~~text
x_view = tview(ptr_x, sizes=[N], strides=[1])
y_view = tview(ptr_y, sizes=[N], strides=[1])

x = tload(x_view, origin=[i], shape=static<[16]>, other=0.0)
z = tload(z_view, origin=[i], shape=static<[16]>, other=0.0)
y = tadd(x, z)
tstore(y_view, origin=[i], value=y)   # writes only coordinates inside sizes
~~~

Notation only: nothing compiles or executes this file (this revision has no frontend). `demo.yaml` records the metadata.

Elementwise vector addition is the one gap this form exposes: the tile vocabulary
names `tadd`, the vector vocabulary does not name an addition, so a vector-form
add needs an RFC before a vector spelling can be written here.

Not covered: N = 0, capacity-boundary specialization, masking, `group=G` forms,
and the aliasing variant.
