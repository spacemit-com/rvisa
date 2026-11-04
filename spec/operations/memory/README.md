# Memory Operations

Memory operations connect computation values to addressed storage. Each operation defines its addressing form, access permissions, bounds, inactive-element behavior, and observable effects.

| Operation | Primary definition |
| --- | --- |
| load / store | Scalar element access below |
| [vload / vstore](vector-memory.md) | Flat configuration-dependent access, fill, and active writes |
| [tview](tile-memory.md#tview) | Descriptor construction |
| [tload](tile-memory.md#tload) | Coordinate-based reads and per-element fill |
| [tstore](tile-memory.md#tstore) | Coordinate-based writes and bounds suppression |
| [im2col](im2col.md) | Convolution-window access and unfolded matrix order |
| [vsstore / tsstore](extended-stores.md) | Provisional address contracts |

## Scalar access

`load(ptr,idx) -> T` reads one element of the pointer's declared element type. `store(ptr,idx,value:T) -> void` writes one such element. idx is an element offset; these operations introduce no implicit bounds or fill. Their effects are Read and Write, respectively.

The caller supplies valid storage, permission, alignment, and nonoverflowing addresses under the [memory model](../../core/memory-model.md). A dtype mismatch is not an implicit cast or bit reinterpretation. Vector/tile data use their own store operations.

## Mapping and transfer requirements

A profile identifies memory instruction sequences and the register representation of each loaded or stored value. Tile transfers follow the [tile register policy](../../types/tile.md#register-representation); descriptors and temporary staging remain distinct from computation values.

Flat vector-tail rules do not automatically apply to grouped or multidimensional overloads. Transfer selection does not alter values or bounds. Readiness, alias ordering, waits, and buffer reuse follow [Compiler-Managed Transfers](../../core/transfers.md).

See [memory types](../../types/memory.md) and [core design cases](../../../conformance/cases/core-designs.md).
