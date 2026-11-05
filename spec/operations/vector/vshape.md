# vshape — Vector Value View

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-VSHAPE |
| Status | Working draft |
| Result | A vector-origin value view |
| Effects | Pure |

## Synopsis and operands

~~~text
vshape(value: vector<T>, shape: static<extents>) -> vector_view<T, shape>
~~~

The shape is compile-time metadata and may contain one inferred axis written -1. Every other extent is positive. Zero extents, multiple inferred axes, and an unresolved element-count relationship are invalid.

**RVISA-VSHAPE-1.** A view MUST preserve the complete element sequence and element count of its input. For a two-dimensional view:

~~~text
R * C = numel(value)
view[r,c] = linear(value)[r*C + c]
~~~

For separate fixed vectors, linear(value)[g*D+i] denotes member g, element i. For scalable vectors, numel is the full symbolic capacity, not the current valid memory extent or hardware vl.

## Inference

An inferred extent is numel divided by the product of all specified extents. The relationship must be integral and valid over the profile's entire declared vector-length range. A result valid only for the compiler host's vector length does not establish scalable validity.

Informative examples:

| Input and request | Result |
| --- | --- |
| Fixed 12 elements, shape=(3,4) | Legal, with last-axis-fastest order |
| Fixed 12 elements, shape=(5,-1) | Invalid: nonintegral inferred extent |
| Scalable capacity C, shape=(1,-1) | Shape [1,C] |
| Scalable capacity C, shape=(3,-1) | Requires proof that 3 divides C for every supported vector length |

A view does not cast elements, transpose them, insert padding, discard inactive elements, or create a memory descriptor.

## Overload identity and interoperability

A view derived from a vector retains its vector origin and grouping metadata. A continuing vector computation uses vector overloads. In a tile data position, an explicit rank-2 view supplies the required matrix-shaped value; additional batch structure is established with an explicit tile reshape.

A positive vector group count alone does not make that vector an implicit matrix or batch operand. Complete tile-to-vector flattening and the resulting value categories are defined in [Tile Types](../../types/tile.md#relationship-to-vectors).

## Mapping and conformance

The view preserves the source elements' carrier locations and composes their coordinate map. A consumer requiring another carrier needs a separately represented conversion or legal anchor rewrite. The profile preserves the original vector mode, order, and group constraints; see the [layout view rule](../../core/linear-layout.md#views-and-physical-movement).

Test element-count mismatch, multiple inferred axes, symbolic divisibility, grouped linear order, and vector-origin overload preservation. Check views after a tile transpose against the tile's current logical shape rather than its earlier memory layout.
