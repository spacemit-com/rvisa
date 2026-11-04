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

Python/C++ source forms are TBD. See [memory operations](../../spec/operations/memory/README.md) and the [workload index](../README.md).
