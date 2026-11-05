# Tile Descriptors, Loads, and Stores

These operations distinguish an address descriptor from an immutable computation tile. All three definitions are working drafts.

## tview

**Operation identifier: RVISA-OP-TVIEW.** Effect: Pure descriptor construction.

~~~text
tview(base: ptr<T>, sizes: index[R], strides: index[R])
    -> descriptor<T,R,Access>
~~~

R is compile-time structure. Sizes and strides may be runtime values and contain R entries in element units. The constructor records the applicable [descriptor fields](../../types/memory.md#descriptors), including base/offset, access, address space, allocation information, and byte alignment; their source spelling is separate from their semantic role.

Sizes and strides are nonnegative in this model. Zero sizes are valid bounds. Construction neither reads nor allocates the described elements and does not prove the truth of allocation or lifetime information. Different bases/descriptors may alias.

The primary [address formula](../../core/memory-model.md#addressing-and-access) applies at the consuming memory operation. A hardware transfer descriptor is an implementation representation, not an additional public operand.

## tload

**Operation identifier: RVISA-OP-TLOAD.** Effect: Read. Result: ordinary tile.

~~~text
tload(view: readable_descriptor<T,R>,
      origin: index[R], shape: static<ShapeR>, other: tile_data<T,ShapeR>,
      layout = auto, allow_tma = permitted) -> tile<T,ShapeR,Layout>
~~~

Origin contains runtime element coordinates, not tile indices. Shape contains positive compile-time extents; descriptor, origin, and result ranks match. The fill operand other is required and is normalized from a scalar, a matching tile, or an explicit rank-2 vector view where appropriate. Its dtype must match T.

**RVISA-TLOAD-BOUNDS-1.** For every local result coordinate i, form x=origin+i. If every axis satisfies 0 <= x[d] < sizes[d], read view[x]; otherwise return other[i] without accessing that element's source address. This includes negative origins, partially outside tiles, empty source bounds, and tiles entirely outside the descriptor.

The returned value observes memory according to program ordering. Later stores cannot alter that logical snapshot. The layout option concerns result representation and does not change coordinates or memory strides. An explicit layout constrains the result carrier; auto allows [anchor inference](../../core/tile-optimization.md#anchors). A load may directly construct a blocked carrier from the original logical addresses.

## tstore

**Operation identifier: RVISA-OP-TSTORE.** Effect: Write. Result: void.

~~~text
tstore(view: writable_descriptor<T,R>, origin: index[R],
       value: tile_data<T,ShapeR>, shape: optional_static<ShapeR>,
       allow_tma = permitted) -> void
~~~

Shape is inferred from a tile value's complete shape. A scalar write requires an explicit or otherwise uniquely inferred region; it does not fill an entire allocation by default. A shape supplied with a nonscalar value must match it and cannot request truncation or arbitrary reshape.

**RVISA-TSTORE-BOUNDS-1.** For each local coordinate i of the normalized value, write value[i] to view[origin+i] only if all descriptor bounds hold. Out-of-bounds coordinates cause no writes.

Rank-3 and rank-4 values retain their complete batch structure. There is no implicit flattening at this tile data position. A rank-2 vector view cannot silently acquire batch dimensions.

Value and memory dtype, rank, access, and shape constraints must agree. Effective write addresses within the operation must not overlap unless a separately specified conflict-resolution operation is used.

## Transfer policy and mapping

The load and store are layout anchors. [Boundary folding](../../core/tile-optimization.md#what-boundary-folding-preserves) may change their target sequences to produce/consume an inferred carrier, while preserving original addresses, bounds, fill, aliases, and completion. A store's source layout determines its value-to-address correspondence; no caller-memory transpose is implicit.

Both memory operations use the compile-time permission defined in [Transfers](../../core/transfers.md#transfer-selection). Default/None and true permit a TMA path; false forbids that path for this operation. Neither operation returns an event or pending tile.

The [tile register policy](../../types/tile.md#register-representation) governs loaded/stored computation values. A profile identifies load/store sequences, register classes/groups, element coordinates, and permitted staging. Transfer geometry or hardware fill restrictions cannot weaken the bounds or other-value contract.

## Conformance

Check negative and fully outside origins, zero source sizes, arbitrary representable fill, non-unit strides, complete batch shapes, scalar shape ambiguity, dtype/rank mismatch, read/write permissions, and conflicting write addresses. Use coordinate formulas to obtain expectations independently of a target transfer engine. See [core design cases](../../../conformance/cases/core-designs.md#memory-and-transfer-behavior).
