# Layout Model

RVISA separates logical coordinates, physical carriers, and memory addresses. Its layout optimization is derived from [linear layouts](linear-layout.md), with every tile-level transformation expressible by the programmer.

| Relationship | Meaning |
| --- | --- |
| Logical shape | Coordinates of a rank-1 through rank-N value |
| Matrix-axis interpretation | Which coordinates represent M, N, and K, including explicit factor axes |
| Memory layout | The address associated with a logical coordinate through a descriptor |
| Representation layout | The fragment, register group, and element slot holding that coordinate |
| Concrete allocation | Physical registers and reuse times satisfying the representation constraints |

A matrix-axis choice does not request a memory transpose. A reshape does not change physical placement. Concrete allocation does not redefine the logical value.

## Views and representation conversion

A [reshape](../operations/tile/layout-operations.md#tshape) preserves the complete last-dimension-fastest element sequence and all carrier locations. A [permutation](../operations/tile/layout-operations.md#ttranspose) relabels logical axes while preserving each element's location. Their layout descriptions change by coordinate composition, with no data-moving operation at the view node.

A [representation conversion](../operations/tile/layout-operations.md#tconvert_layout) preserves coordinates and values but selects a different carrier. It may require actual movement. An anchor can absorb that movement only under the [region and boundary rules](tile-optimization.md).

This distinction applies to 1D through ND tiles. A shape such as [4,4,8,8] alone does not prove that each trailing 8x8 block is contiguous in registers.

## Vector and tile interoperability

The [tile type rules](../types/tile.md#relationship-to-vectors) define explicit vector-to-tile entry and complete tile-to-vector flattening. Existing vector capacity/group checks remain in force. Physical layout does not replace the tile's current logical flattening order.

## Inference and programmer control

Load/store, MMA, and row/column extraction can constrain carrier layout. Their candidates are propagated through views and compatible computations using the [linear-layout algebra](linear-layout.md). Conflicts require explicit conversions or diagnostics.

[RVISA-TILE-EXPR-1](tile-optimization.md#expressibility-requirement) requires an equivalent public RVISA expression for compiler tile optimizations. Explicit layout constraints remain binding; auto choices are resolved and made inspectable.

## Target realization

Tile representations follow [RVISA-TILE-REG-1](../types/tile.md#register-representation). Logical fragment inventory, simultaneous register residency, instruction count, and exact allocation are different quantities. Padding must not become a logical contribution or an unintended access.

Profiles identify supported carrier maps, operation anchors, group alignment/overlap, cross-class transfers, and any permitted spill/staging policy. A mapping proof includes coordinate equivalence and numerical, memory, state, and lifetime legality.

See [blocked MMA](../operations/matrix/blocked-mma.md), [mapping requirements](../../mappings/contract.md), and [conformance cases](../../conformance/cases/linear-layout.md).
