# Vector Memory Operations

The flat forms of `vload` and `vstore` use the full capacity and valid extent established by [vconfig](../control/vconfig.md). This chapter does not extend those bounds to grouped, ranked, or two-dimensional overloads.

## Signatures and operands

~~~text
vload(ptr: ptr<T>, idx: index, dtype: static<T>, fill: T = typed_zero)
    -> vector<T>
vstore(ptr: ptr<T>, idx: index, value: vector<T>) -> void
~~~

These are normalized virtual signatures. Their implicit dependency is the governing logical configuration.

| Operand | Stage and role |
| --- | --- |
| ptr | Runtime address with the required read or write permission |
| idx | Runtime offset in elements |
| dtype | Compile-time element type, consistent with the addressed memory |
| fill | Scalar data value of the load element type |
| value | Runtime vector data; a tile first undergoes complete logical flattening |

The reference Python spelling of vload defaults dtype to f16, fill to 0.0, and group to None. The C++ notation derives dtype from the typed pointer. After default expansion, element types must agree: loading f32 data requires explicit dtype=f32 in the Python notation and an f32 pointer in C++. A type mismatch is diagnosed; a load does not implicitly cast or reinterpret storage.

## Flat load

Operation identifier: RVISA-OP-VLOAD.

**RVISA-VLOAD-1.** For capacity W and valid extent V, with 0 <= V <= W:

~~~text
result[j] = ptr[idx+j]    if 0 <= j < V
            fill        if V <= j < W
~~~

Only the first V element addresses are accessed. A full configuration has V=W; the caller supplies a sufficiently large readable allocation. A zero valid extent performs no element reads and returns a full-capacity fill value.

The loaded result is an immutable snapshot. Fill coordinates are ordinary value elements and participate in later arithmetic and reductions. The valid memory extent is not a hidden arithmetic mask.

## Flat store

Operation identifier: RVISA-OP-VSTORE.

**RVISA-VSTORE-1.** For the matching configured value domain, write value[j] to ptr[idx+j] for 0 <= j < V, and perform no write for j >= V. The operation has no result value and retains its Write effect.

Value and storage element types must match. A tile input is flattened over its complete logical shape under [RVISA-TILE-FLAT-1](../../types/tile.md#relationship-to-vectors); flattening does not excuse a configuration/capacity mismatch.

## Other overloads and open boundaries

| Form in the design vocabulary | Required additional contract |
| --- | --- |
| Tuple indices | Ranked descriptor or scratch layout, per-axis addressing and bounds |
| group=G | Logical group coordinates, carrier type bridge, layout, and per-group valid region |
| shape=(R,C) store | Two-dimensional addresses, row bounds, and relation to the value |
| Memory packing inputs | Storage ownership, element mapping, alignment, and effects |

These forms must not inherit a guessed two-dimensional mask from the flat tail rule. A bare pointer carries no automatic shape or bounds. Public grouped/packed bridges remain provisional where those requirements are not defined.

## Effects, mapping, and conformance

vload is Read with a configuration dependency; vstore is Write with a configuration dependency. Both participate in alias analysis with scalar and tile memory operations. Valid addressed elements satisfy the [memory model](../../core/memory-model.md), including allocation, access, alignment, and overflow obligations.

Profiles specify memory instruction sequences, masks/tail handling, register groups, and configuration changes. Inactive addresses must not be touched even if a target offers a wider access. Validate full, partial, and zero extents, nonzero fill, mixed-width lane correspondence, dtype mismatch, and stores whose result is unused. See [core design cases](../../../conformance/cases/core-designs.md#memory-and-transfer-behavior).
