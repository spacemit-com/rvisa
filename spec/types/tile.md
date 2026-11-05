# Tile Types

A tile is a typed value of rank 1 through rank N, written `tile<T, Shape, Layout>`. Shape describes logical coordinates; Layout describes their carrier relationship under the [linear-layout model](../core/linear-layout.md). Neither requires a same-shaped matrix register.

## Shape

A tile can describe fixed extents and valid symbolic views of scalable values. Literal extents are positive compile-time integers and need not be powers of two. Rank zero is represented by a scalar. Runtime access bounds and active contraction extents are distinct from the full value shape.

For byte-addressable T and shape [x0,...,xN-1]:

~~~text
element_count = product(Shape)
logical_bytes = element_count * sizeof(T)
~~~

**RVISA-TILE-SHAPE-1.** An N-dimensional shape MUST be interpretable as a view of the same element sequence as a one-dimensional tile of length product(Shape). Changing shape alone preserves every element's carrier location. Shape does not choose new register groups, transpose physical data, or imply a microtile layout.

For example, [32,32], [4,8,4,8], and [1024] are reshape views of the same 1024-element sequence. An explicit axis permutation changes coordinate interpretation; an anchor-specific blocked representation is a separate layout decision.

## Canonical linear carrier

**RVISA-TILE-LINEAR-1.** The canonical linear representation places a one-dimensional tile's elements consecutively within an ordered tuple of legal register groups. For an RVV representation, let SEW=8*sizeof(T), vlenb=VLEN/8, and capacity(L)=L*VLEN/SEW.

If one supported group can cover the value, select the smallest legal LMUL L with capacity(L) >= element_count. Legality includes element width and the selected profile's fractional-LMUL support. Surplus carrier slots are padding, not additional logical elements.

If no single legal group can cover the value, partition its linear sequence into consecutive fragments. The canonical decomposition uses maximal legal groups for full fragments and the smallest legal covering group for the remaining fragment. Each group obeys architectural alignment and overlap rules. Separate fragments need not have consecutive physical register numbers.

For 128 f16 elements, logical_bytes=256:

| VLEN, in bits | Required capacity relative to one register | Canonical legal carrier |
| --- | --- | --- |
| 1024 | 2 | One f16m2 group |
| 256 | 8 | One f16m8 group |
| 128 | 16 | Two f16m8 groups, each holding 64 elements |

Here f16m16 is only shorthand for aggregate capacity. It is not an architectural RVV type or a legal single-instruction register group. [RVV grouping constraints](https://github.com/riscvarchive/riscv-v-spec/blob/3570f998903f00352552b670f1f7b7334f0a144a/v-spec.adoc) bound each individual group; other register classes have their own profile rules.

The same canonical carrier applies to a 2D or higher-rank reshape with the same element sequence. Anchors may infer a different representation for auto layout, or the programmer may specify one explicitly. Minimum covering LMUL describes the canonical linear choice, not a requirement that every optimized tile retain one maximal group.

Symbolic capacity remains parameterized by the target. Packed FP4 and masks require their separate storage/representation rules; a fractional byte sizeof is not used.

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

Reshape and permutation themselves preserve carrier locations. A consumer requiring a different carrier uses an explicit or compiler-reified representation conversion, possibly folded into an anchor. Inter-domain transfers and staging remain governed by target mappings.

See [vectors](vector.md), [layout](../core/layout-model.md), and [tile operations](../operations/tile/README.md).
