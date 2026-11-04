# Value and State Model

RVISA distinguishes computation values, memory descriptors, and compile-time information.

| Category | Meaning |
| --- | --- |
| Scalar | One computation element |
| Vector | Ordered elements with defined capacity and grouping |
| Tile | A multidimensional computation value with a target representation that prioritizes registers |
| Mask | Boolean conditions over a logical coordinate domain |
| Memory descriptor | Addressing information used to access storage |

## Values and rebinding

Computation values are immutable in the semantic model. Assigning a source variable binds it to another value; a store changes memory through an explicit effect. Loading a value creates a logical snapshot that does not change when the source memory is subsequently written.

An implementation may reuse physical storage if it preserves this value behavior. A value's identity does not fix physical register numbers or prohibit reuse over time. The selected profile's register classes, grouping, overlap, and fixed-register requirements still constrain allocation.

Tile representations follow the [register priority policy](../types/tile.md#register-representation). Logical value semantics remain defined when a permitted mapping partitions a tile, spills a fragment, or stages data through memory.

## Views and representation

A value view changes coordinate interpretation without reading external memory. Reshaping preserves element count and logical order; transposition changes the correspondence between axes. Representation conversion preserves logical coordinates while changing where elements are held.

A memory view is a descriptor, not a loaded value. Constructing a descriptor does not establish that the described allocation is valid.

Tile values can express vector values and their grouping constraints. This relationship does not erase vector type checks or imply arbitrary implicit conversions at function boundaries.

## Effects and state

Operation contracts identify the following semantic properties:

| Property | Meaning |
| --- | --- |
| Pure | Computes from values, metadata, and declared state dependencies without external memory access |
| Read / Write | Observes or changes addressed storage |
| Allocate | Creates storage with ownership and lifetime obligations |
| Config | Reads or updates logical configuration, as stated by the operation |
| TargetState | Depends on or changes architectural state identified by a profile |
| Synchronize | Establishes an explicitly specified ordering or completion relation |
| Control | Introduces control-flow structure |

These are semantic classifications, not an implemented MLIR effect interface. Pure computation may depend on configuration or require internal register transfers and private storage. A memory-packing overload has its own Read/Write effects; it cannot inherit the purity of a value-packing overload.

Logical configuration dependencies remain visible to verification and transformation even if the virtual operation has no explicit configuration operand.

Calls and mixed scalar/vector/tile regions participate in the same effect analysis. A physical asynchronous transfer is an implementation detail unless the operation contract exposes its completion state.

See [types](../types/README.md), [layout](layout-model.md), and [memory](memory-model.md).
