# Value and State Model

RVISA distinguishes computation values, memory descriptors, and compile-time information.

| Category | Meaning |
| --- | --- |
| Scalar | One computation element |
| Vector | Ordered elements with defined capacity and grouping |
| Tile | A multidimensional mapping from logical coordinates to elements |
| Mask | Boolean conditions over a logical coordinate domain |
| Memory descriptor | Addressing information used to access storage |

## Values and rebinding

Computation values are immutable in the semantic model. Assigning a source variable binds it to another value; a store changes memory through an explicit effect. Loading a value creates a logical snapshot that does not change when the source memory is subsequently written.

An implementation may reuse physical storage if it preserves this value behavior. Logical value identity is not a physical register allocation requirement.

## Views and representation

A value view changes coordinate interpretation without reading external memory. Reshaping preserves element count and logical order; transposition changes the correspondence between axes. Representation conversion preserves logical coordinates while changing where elements are held.

A memory view is a descriptor, not a loaded value. Constructing a descriptor does not establish that the described allocation is valid.

Tile values can express vector values and their grouping constraints. This relationship does not erase vector type checks or imply arbitrary implicit conversions at function boundaries.

## Effects and state

Operation contracts identify reads, writes, allocation, configuration, target-state interactions, and synchronization. Logical configuration dependencies remain visible to verification and transformation even if the source API does not pass a configuration object.

Calls and mixed scalar/vector/tile regions participate in the same effect analysis. A physical asynchronous transfer is an implementation detail unless the language contract exposes its completion state.

See [types](../types/README.md), [layout](layout-model.md), and [memory](memory-model.md).
