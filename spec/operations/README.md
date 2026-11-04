# Operation Reference

Operations define observable computation, memory access, control, and state behavior. Each definition has a primary location, a stable identity, and a complete relationship between its operands and results.

| Family | Scope |
| --- | --- |
| [Scalar](scalar/README.md) | Scalar arithmetic, comparisons, conversion, and selection |
| [Vector](vector/README.md) | Vector computation, reductions, grouping, and vector matrix primitives |
| [Tile](tile/README.md) | Multidimensional elementwise computation and value transformations |
| [Matrix](matrix/README.md) | Matrix multiply-accumulate, batch relationships, and block scaling |
| [Memory](memory/README.md) | Loads, stores, descriptors, and structured accesses |
| [Control and configuration](control/README.md) | Control flow, calls, and configuration scope |

The family chapters describe the working semantic organization. Detailed per-operation signatures and coverage are being completed; see [Specification Status](../status.md). An operation's presence in the vocabulary does not identify a native instruction on every target.

Use the [definition format](operation-template.md) for individual entries. Common rules reside in the [core models](../core/README.md), [types](../types/README.md), and [operand definitions](../operands/README.md). IR descriptions and demos reference those entries.
