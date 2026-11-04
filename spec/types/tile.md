# Tile Types

A tile is a typed mapping from a multidimensional logical coordinate domain to element values. Its shape and layout are semantic properties; they do not require a same-shaped physical matrix register.

## Shape and representation

A tile can describe fixed extents and valid symbolic views of scalable values. Literal tile extents are positive compile-time quantities in the current model. Runtime access bounds and active contraction extents are distinct from the full value shape.

An implementation may distribute a tile over vector fragments, matrix storage, or a combination of domains. Representation changes preserve the logical value, coordinate relationships, numerical behavior, and access obligations.

## Relationship to vectors

Tile semantics can express resolved vector values, capacities, and grouping relationships. This inclusion does not change explicit vector validity rules.

A vector entering a tile data position first establishes a two-dimensional value view. Element count, order, symbolic capacity, and group constraints must be preserved. Additional batch structure must be explicit.

A tile entering a vector data position is flattened in logical last-dimension-fastest order over its complete shape. The receiving operation then applies its vector type and configuration checks.

## Broadcasting and transformations

Scalar broadcasting requires a uniquely inferable destination shape. Reshape, transpose, broadcast, and representation conversion are distinct transformations with different coordinate effects.

A view is not a promise of zero physical movement. Inter-domain transfers and staging requirements belong to target mappings.

See [vectors](vector.md), [layout](../core/layout-model.md), and [tile operations](../operations/tile/README.md).
