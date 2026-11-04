# Tile Types

A tile is a typed mapping from a multidimensional logical coordinate domain to element values. Its shape and layout are semantic properties; they do not require a same-shaped physical matrix register.

## Shape

A tile can describe fixed extents and valid symbolic views of scalable values. The conceptual notation is `tile<T, Shape, Layout>`. Literal tile extents are positive compile-time quantities and need not be powers of two. Runtime access bounds and active contraction extents are distinct from the full value shape.

## Register representation

**RVISA-TILE-REG-1.** A tile mapping MUST prioritize legal representations in the target profile's register classes and groups. These may include vector registers and register groups, matrix operand registers, and accumulator registers where the target provides them. The selected profile identifies the applicable classes, element-to-register coordinates, grouping, alignment, overlap, and transfer constraints.

A tile may span several registers or be partitioned into fragments that match instruction geometry. Its logical shape and grouping do not require a single physical register or simultaneous residency of every fragment. Concrete register numbers and reuse over time follow the [mapping guarantees](../../mappings/contract.md#mapping-guarantees).

Resource limits or target transfer requirements may require register reuse, spills, or staging through memory. A profile MUST state when such steps are permitted or required and preserve the logical value, numerical behavior, access bounds, and temporary-storage lifetime. A mapping that cannot satisfy these constraints must use a permitted decomposition or diagnose the unsupported case.

## Relationship to vectors

Tile semantics can express resolved vector values, capacities, and grouping relationships:

| Resolved vector mode | Expressible tile coordinates and preserved constraints |
| --- | --- |
| Scalable | [C(T,L)], retaining the symbolic capacity and LMUL relationship |
| Fixed, inferred representation | [D], retaining the fixed element count |
| Separate fixed vectors | [G,D], retaining member boundaries and each member's capacity condition |
| Context inferred | Resolve the mode first, then use its corresponding coordinates |

This inclusion does not establish C++ inheritance, convert arbitrary function signatures, or infer matrix/batch axes. It does not make an invalid explicit vector type legal.

**RVISA-TILE-VIEW-1.** A vector entering a tile data position MUST first establish an explicit rank-2 [vshape](../operations/vector/vshape.md) view. Element count, order, symbolic capacity, and group constraints are preserved. A positive G does not bypass this requirement. Additional batch structure requires an explicit tile reshape.

**RVISA-TILE-FLAT-1.** A tile entering a vector data position MUST be flattened over its complete current logical shape in last-dimension-fastest order:

~~~text
[R,C]:        q = r*C + c
[B,M,N]:      q = (b*M + m)*N + n
[B0,B1,M,N]:  q = ((b0*B1 + b1)*M + m)*N + n
~~~

A fixed shape produces the logical type `vec<T, product(shape), -1>`, not a separate fixed vector for each row or batch. A symbolic shape preserves a provable legal scalable relationship; otherwise the implementation requires a supported symbolic view or diagnoses the unsupported case. It must not invent an LMUL.

Flattening follows coordinates after any transpose and the exposed output shape selected by a matrix operation's CLayout. Physical bytes and memory strides do not determine this order. Ordinary elementwise vector operations return vectors; vector reductions return scalars. Neither automatically restores the input tile shape. Re-entry into a tile data position requires an explicit view again.

The receiving vector operation also applies its type, numerical, and configuration checks.

## Broadcasting and transformations

Scalar broadcasting requires a uniquely inferable destination shape. Reshape, transpose, broadcast, and representation conversion are distinct transformations with different coordinate effects.

The absence of dedicated matrix registers alone does not invalidate a tile. Within a profile's supported operation and numerical domain, vector-register fragments can implement the same tile contract. Actual resource or capability failures still require a permitted decomposition or diagnostic. Tile axes are not limited to one vector register; explicit vector member-capacity restrictions remain in force.

A view is not a promise of zero physical movement. Inter-domain transfers and staging requirements belong to target mappings.

See [vectors](vector.md), [layout](../core/layout-model.md), and [tile operations](../operations/tile/README.md).
