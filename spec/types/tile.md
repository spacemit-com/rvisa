# Tile Types

A tile is a typed mapping from a multidimensional logical coordinate domain to element values. Its shape and layout are semantic properties; they do not require a same-shaped physical matrix register.

## Shape

A tile can describe fixed extents and valid symbolic views of scalable values. Literal tile extents are positive compile-time quantities in the current model. Runtime access bounds and active contraction extents are distinct from the full value shape.

## Register representation

**RVISA-TILE-REG-1.** A tile mapping MUST prioritize legal representations in the target profile's register classes and groups. These may include vector registers and register groups, matrix operand registers, and accumulator registers where the target provides them. The selected profile identifies the applicable classes, element-to-register coordinates, grouping, alignment, overlap, and transfer constraints.

A tile may span several registers or be partitioned into fragments that match instruction geometry. Its logical shape and grouping do not require a single physical register or simultaneous residency of every fragment. Concrete register numbers and reuse over time follow the [mapping guarantees](../../mappings/contract.md#mapping-guarantees).

Resource limits or target transfer requirements may require register reuse, spills, or staging through memory. A profile MUST state when such steps are permitted or required and preserve the logical value, numerical behavior, access bounds, and temporary-storage lifetime. A mapping that cannot satisfy these constraints must use a permitted decomposition or diagnose the unsupported case.

## Relationship to vectors

Tile semantics can express resolved vector values, capacities, and grouping relationships. This inclusion does not change explicit vector validity rules.

A vector entering a tile data position first establishes a two-dimensional value view. Element count, order, symbolic capacity, and group constraints must be preserved. Additional batch structure must be explicit.

A tile entering a vector data position is flattened in logical last-dimension-fastest order over its complete shape. The receiving operation then applies its vector type and configuration checks.

## Broadcasting and transformations

Scalar broadcasting requires a uniquely inferable destination shape. Reshape, transpose, broadcast, and representation conversion are distinct transformations with different coordinate effects.

A view is not a promise of zero physical movement. Inter-domain transfers and staging requirements belong to target mappings.

See [vectors](vector.md), [layout](../core/layout-model.md), and [tile operations](../operations/tile/README.md).
