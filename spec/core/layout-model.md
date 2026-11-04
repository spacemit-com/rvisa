# Layout Model

A layout description must identify which relationship it describes.

| Relationship | Meaning |
| --- | --- |
| Logical shape | The coordinates belonging to a value |
| Matrix-axis interpretation | Which exposed axes play the mathematical M, N, and K roles |
| Memory layout | The address associated with a logical coordinate |
| Representation layout | The register, lane, fragment, or storage location holding an element |

These relationships can vary independently. A column-major matrix-axis interpretation does not, by itself, request a memory transpose or determine a register arrangement.

## Coordinate preservation

A nonreplicating representation must cover each logical element exactly once. An operation that replicates values, such as a broadcast, identifies that replication explicitly.

A reshape preserves logical flattening order. A transpose permutes axes. A representation conversion preserves logical coordinates and element values. The latter may require physical movement even when it is a logical value transformation.

The default logical flattening order visits the last dimension fastest. All leading dimensions participate, including explicit batch dimensions.

## Vector and tile interoperability

A vector used in a tile data position must establish an explicit two-dimensional value view. The view preserves element count, symbolic capacity, and relevant group boundaries. Scalar broadcasting requires a uniquely determined destination shape.

A tile used in a vector data position is interpreted through its complete logical flattening order, then checked against the vector operation's type and configuration requirements. Physical storage layout cannot replace that logical order.

## Target realization

A logical tile may be distributed across multiple registers or executed in fragments. Fragment padding is not part of the value and must not contribute to computation or valid writes.

Profiles document coordinate mappings, alignment, grouping, replication, and transfers. Register count, simultaneous residency, and instruction count are separate properties.

See [vector types](../types/vector.md), [tile types](../types/tile.md), and [mapping requirements](../../mappings/contract.md).
