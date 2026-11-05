# Convolution

This workload relates convolution coordinates to matrix-oriented computation. The baseline is dense forward two-dimensional cross-correlation, with no filter reversal; grouped or other variants require separately stated contracts.

## Data contract

Specify batch/channel/spatial order, filter layout, stride, dilation, padding, output geometry, and element/accumulation types. Every output coordinate determines a set of input-channel and filter coordinates.

Padding defines the contribution outside the source bounds without authorizing an invalid load. The reduction order and numerical behavior follow the selected matrix/accumulation contract.

## Matrix representation

[im2col](../../spec/operations/memory/im2col.md) defines the NHWC logical view, B/P/Q output-position order, and R/S/C contraction order. Physical strides may describe a different storage order. Its result supplies a matrix input to [tmma](../../spec/operations/matrix/tmma.md); image batch is folded into M, not a matrix batch to reduce.

A materialized intermediate, descriptor-based access, and an accelerated transfer path can have different costs while implementing the same coordinate contract.

## Mapping concerns

Identify the virtual load/unfold/compute operations, their target instruction sequences, and the register groups carrying input, weight, and accumulator fragments. Account for register reuse and any materialized intermediate or staging storage permitted by the profile.

## Verification cases

Compare with an independently indexed direct convolution. Cover asymmetric padding, nonunit stride/dilation, empty output regions, boundary filters, and matrix tails.

The source form is described in [Source form](#source-form). See [memory operations](../../spec/operations/memory/README.md) and the [workload index](../README.md).

## Source form

[conv2d.rvisa](conv2d.rvisa) expresses the workload in RVISA notation as
`im2col` plus `tmma`, with the image batch folded into `M` and the filter held as
`[K_total, R*S*C]` in the `BLayout.colmajor` view.

~~~text
x_view = tview(ptr_x, sizes=[B, H, W, C], strides=[H * W * C, W * C, C, 1])
w_view = tview(ptr_w, sizes=[K_total, R * S * C], strides=[R * S * C, 1])
y_view = tview(ptr_y, sizes=[M_total, K_total], strides=[K_total, 1])

a = im2col(x_view, origin=[m0, 0], shape=static<[16, 16]>,
           kernel=static<[R, S]>, stride=static<[SH, SW]>,
           dilation=static<[DH, DW]>, padding=static<[PT, PB, PL, PR]>, other=0)
b = tload(w_view, origin=[n0, 0], shape=static<[16, 16]>, other=0)
d = tmma(a, b, 0, ALayout=rowmajor, BLayout=colmajor, CLayout=rowmajor,
         mode=reduce, reduce_order=ordered, valid_k=16)
tstore(y_view, origin=[m0, n0], value=d)
~~~

Notation only: nothing compiles or executes this file (this revision has no frontend). `demo.yaml` records the metadata.

The descriptor is the logical NHWC view; a different physical storage order is
expressed only through `strides`, and `im2col` does not move or transpose memory.

Not covered: grouped and depthwise variants, filter reversal, asymmetric padding,
nonunit stride or dilation, empty output regions, matrix tails, and materialized
versus accelerated unfold paths.
