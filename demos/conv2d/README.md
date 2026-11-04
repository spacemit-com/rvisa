# Convolution

This workload relates convolution coordinates to matrix-oriented computation. The baseline is a dense two-dimensional convolution; grouped or other variants require separately stated contracts.

## Data contract

Specify batch/channel/spatial order, filter layout, stride, dilation, padding, output geometry, and element/accumulation types. Every output coordinate determines a set of input-channel and filter coordinates.

Padding defines the contribution outside the source bounds without authorizing an invalid load. The reduction order and numerical behavior follow the selected matrix/accumulation contract.

## Matrix representation

An explicit or implicit unfolding maps output positions and filter/channel coordinates to matrix axes. The mapping must preserve element order, padding, and contraction extent.

A materialized intermediate, descriptor-based access, and an accelerated transfer path can have different costs while implementing the same coordinate contract.

## Verification cases

Compare with an independently indexed direct convolution. Cover asymmetric padding, nonunit stride/dilation, empty output regions, boundary filters, and matrix tails.

Python/C++ source forms are TBD. See [memory operations](../../spec/operations/memory/README.md) and the [workload index](../README.md).
