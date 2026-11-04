# Tile Operations

Tile operations describe virtual instructions on multidimensional computation values. Their realizations follow the [tile register policy](../../types/tile.md#register-representation), using the vector, matrix, or accumulator register classes available in the selected profile.

## Elementwise operations

| Operation | Data and result contract |
| --- | --- |
| tzero(TileType) | Construct a zero tile of an explicit element type and complete shape |
| tcast(value,dtype) | Convert elements and preserve the complete shape |
| tselect(mask,a,b) | Select per logical coordinate after compatible shape/dtype normalization |
| tadd / tmul | Elementwise addition/multiplication, preserving complete shape |
| tmin / tmax | Elementwise minimum/maximum, preserving complete shape |

Types and shape relationships must agree. A scalar broadcasts only when the complete data shape is uniquely determined. Metadata and addressing operands do not participate in that broadcast. An ordinary operation retains all explicit batch axes.

These are Pure value computations. Conversion rounding, exceptional arithmetic, and min/max special values require the applicable [numerical contract](../../core/numeric-model.md). Selection does not suppress previously evaluated loads.

## Shape and layout operations

| Operation | Logical effect | Validity |
| --- | --- | --- |
| tshape(value,shape) | Preserve the last-axis-fastest element sequence under a new shape | Equal element counts, including provable symbolic relationships |
| ttranspose(value,perm) | Permute logical axes | Static permutation must be a bijection over the axes |
| tbroadcast(value,shape,axes) | Replicate explicitly selected coordinates | Complete source/destination axis relationship must be unambiguous |
| tconvert_layout(value,layout) | Preserve logical coordinates and element values while changing representation | Static representation choice must admit a legal mapping |

These transformations must not be conflated. A view does not guarantee zero physical movement. Profiles identify register permutations, group changes, inter-class transfers, and permitted staging.

The detailed multi-argument broadcast/tag notation remains provisional. It must not silently choose an axis mapping. treduce_sum is also provisional: reduction axes, scalar versus tile result, retained singleton axes, accumulation order, and numerical behavior must be specified together.

## Interoperation and related operations

[Tile Types](../../types/tile.md#relationship-to-vectors) defines explicit vector-to-tile views, complete tile-to-vector flattening, and scalar normalization. [Matrix operations](../matrix/README.md) define contraction; [tile memory](../memory/tile-memory.md) defines descriptor-based access. Result categories are determined by those operations, not only by the class of their inputs.

See [layout](../../core/layout-model.md), [operands](../../operands/README.md), and [open contracts](../../status.md).
