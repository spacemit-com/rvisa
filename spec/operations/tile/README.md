# Tile Operations

Tile operations describe virtual instructions on multidimensional computation values. Their realizations follow the [tile register policy](../../types/tile.md#register-representation), using the vector, matrix, or accumulator register classes available in the selected profile.

## Elementwise operations

| Operation | Data and result contract |
| --- | --- |
| tzero(TileType) | Construct a zero tile of an explicit element type and complete shape |
| tcast(value,dtype) | Convert elements and preserve the complete shape |
| [tselect](selection.md#tselect) | Choose between two values per Boolean mask coordinate, preserving the complete normalized shape |
| tadd / tmul | Elementwise addition/multiplication, preserving complete shape |
| tmin / tmax | Elementwise minimum/maximum, preserving complete shape |

Types and shape relationships must agree. A scalar broadcasts only when the complete data shape is uniquely determined. Metadata and addressing operands do not participate in that broadcast. An ordinary operation retains all explicit batch axes.

These are Pure value computations. Conversion rounding, exceptional arithmetic, and min/max special values require the applicable [numerical contract](../../core/numeric-model.md). Selection does not suppress previously evaluated loads.

## Shape and layout operations

| Operation | Logical effect | Validity |
| --- | --- | --- |
| [tshape](layout-operations.md#tshape) | Preserve the element sequence and carrier locations under a new shape | Equal element counts, including provable symbolic relationships |
| [ttranspose](layout-operations.md#ttranspose) | Permute logical axes while preserving element locations | Static permutation must be a bijection over the axes |
| tbroadcast(value,shape,axes) | Replicate explicitly selected coordinates | Complete source/destination axis relationship must be unambiguous |
| [tconvert_layout](layout-operations.md#tconvert_layout) | Preserve logical coordinates and values while changing carrier placement | Static representation choice must admit a legal mapping |
| [textract](selection.md#textract) | Extract one coordinate along an axis, such as a matrix row or column, and remove that axis | Axis/index and selected carrier must be legal |
| [tinsert](selection.md#tinsert) | Form an immutable value with one slice replaced | Replacement type/subshape and index must match |

View nodes preserve element locations. A required physical change is a representation conversion or anchor realization, not an implicit consequence of reshape/permutation. Profiles identify register moves, group changes, inter-class transfers, and permitted staging using [linear-layout derivations](../../core/linear-layout.md).

textract and tinsert form the subvalue extraction/assembly pair. tselect chooses between two values per Boolean mask coordinate without removing an axis. [Programmer expressibility](../../core/tile-optimization.md#expressibility-requirement) requires compiler tile rewrites to have public operation/layout equivalents.

The detailed multi-argument broadcast/tag notation remains provisional. It must not silently choose an axis mapping. treduce_sum is also provisional: reduction axes, scalar versus tile result, retained singleton axes, accumulation order, and numerical behavior must be specified together.

## Interoperation and related operations

[Tile Types](../../types/tile.md#relationship-to-vectors) defines explicit vector-to-tile views, complete tile-to-vector flattening, and scalar normalization. [Matrix operations](../matrix/README.md) define contraction; [tile memory](../memory/tile-memory.md) defines descriptor-based access. Result categories are determined by those operations, not only by the class of their inputs.

See [layout](../../core/layout-model.md), [operands](../../operands/README.md), and [open contracts](../../status.md).
