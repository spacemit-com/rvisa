# Memory Operations

Memory operations connect computation values to addressed storage. Each operation defines its addressing form, access permissions, bounds, inactive-element behavior, and observable effects.

| Operation class | Contract focus |
| --- | --- |
| Scalar load/store | One addressed element and caller-provided validity |
| Vector load/store | Configuration, overload-specific extent, and fill/write behavior |
| Memory view | Descriptor construction without loading data |
| Tile load/store | Multidimensional bounds and coordinate-based access |
| Convolution access / im2col | Unfolded coordinates, source geometry, padding, and result order |

A profile identifies the load/store or transfer sequence and the register representation of each loaded or stored value. Tile transfers follow the [tile register policy](../../types/tile.md#register-representation); memory descriptors and temporary staging remain distinct from those computation values.

Flat vector-tail rules do not automatically apply to grouped or multidimensional overloads. Tile loads use defined fill for out-of-bounds coordinates; tile stores suppress writes outside their valid region.

Transfer selection, including an `allow_tma` option, does not alter values or bounds. Compiler-managed asynchronous work must satisfy the same dependency and completion contract.

Extended-store address contracts, including `vsstore` and `tsstore`, remain provisional and require explicit definitions before exposure by an implementation.

See [memory types](../../types/memory.md), [memory semantics](../../core/memory-model.md), and [open contracts](../../status.md).
