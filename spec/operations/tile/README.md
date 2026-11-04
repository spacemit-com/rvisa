# Tile Operations

Tile operations describe virtual instructions on multidimensional computation values. Their realizations follow the [tile register policy](../../types/tile.md#register-representation), using the vector, matrix, or accumulator register classes available in the selected profile.

## Elementwise operations

Operands must satisfy type and shape relationships. A scalar may broadcast only where the destination data shape is uniquely determined. Metadata and addressing operands are checked according to their own roles.

## Shape and layout operations

| Operation concept | Logical effect |
| --- | --- |
| Reshape | Change shape while preserving element count and flattening order |
| Transpose | Permute logical axes |
| Broadcast | Replicate specified coordinates |
| Representation conversion | Preserve logical coordinates and values while changing their physical placement |

These transformations must not be conflated. A value view does not guarantee that the corresponding physical transformation is free. Profiles identify the required register permutations, group changes, inter-class transfers, or permitted staging sequences.

## Interoperation

Vector inputs establish an explicit two-dimensional value view before use in tile data positions. A tile passed to a vector data position is interpreted in complete logical flattening order, then checked against the receiving vector contract.

See [tile types](../../types/tile.md), [layout](../../core/layout-model.md), and the [operation index](../README.md).
