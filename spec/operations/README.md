# Operation Reference

RVISA operations define virtual instruction semantics for computation, memory access, control, and state behavior. Each definition has a primary location, a stable identity, and a complete relationship between its operands and results.

| Family | Scope |
| --- | --- |
| [Scalar](scalar/README.md) | Scalar arithmetic, comparisons, conversion, and selection |
| [Vector](vector/README.md) | Vector computation, reductions, grouping, and vector matrix primitives |
| [Tile](tile/README.md) | Multidimensional elementwise computation and value transformations |
| [Matrix](matrix/README.md) | Matrix multiply-accumulate, batch relationships, and block scaling |
| [Memory](memory/README.md) | Loads, stores, descriptors, and structured accesses |
| [Control and configuration](control/README.md) | Control flow, calls, and configuration scope |

The key entries below provide virtual signatures, operand stages, defaults, validity, semantics, effects, mapping obligations, and conformance cases.

| Contract | Primary entry |
| --- | --- |
| Configuration | [vconfig](control/vconfig.md) |
| Vector views and conversion | [vshape](vector/vshape.md), [vcast](vector/vcast.md) |
| Vector-group contraction | [vmadot](vector/vmadot.md) |
| Matrix and scaled contraction | [tmma](matrix/tmma.md), [tmma_scaled](matrix/tmma-scaled.md) |
| Flat vector access | [vload / vstore](memory/vector-memory.md) |
| Descriptors and tile access | [tview / tload / tstore](memory/tile-memory.md) |
| Convolution-window access | [im2col](memory/im2col.md) |
| Unresolved extended stores | [vsstore / tsstore](memory/extended-stores.md) |

The family pages identify additional scalar/vector/tile vocabulary and its remaining numerical or interface boundaries; see [Specification Status](../status.md).

Each operation is connected to target instruction sequences and register constraints through a versioned profile. An operation's presence in the vocabulary does not identify a native instruction on every target.

Use the [definition format](operation-template.md) for individual entries. Common rules reside in the [core models](../core/README.md), [types](../types/README.md), and [operand definitions](../operands/README.md). IR descriptions and demos reference those entries.
