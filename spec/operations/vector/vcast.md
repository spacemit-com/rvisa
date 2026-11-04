# vcast — Vector Element Conversion

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-VCAST |
| Status | Working draft; conversion-specific numerical policies require explicit coverage |
| Result | Vector of the destination element type |
| Effects | Pure |

## Synopsis

~~~text
vcast(value: vector<T>, dtype: static<element_type U>) -> vector<U>
~~~

A tile data argument first undergoes the complete flattening defined in [Tile Types](../../types/tile.md#relationship-to-vectors). The result remains a vector.

## Type and coordinate rules

**RVISA-VCAST-1.** Conversion MUST preserve element correspondence and the source mode's logical element count. The mode-specific rules are:

| Source mode | Result constraint |
| --- | --- |
| Scalable, LMUL L | L' = L * sizeof(U) / sizeof(T), with a legal resulting LMUL and element width |
| Fixed length, inferred representation | Preserve D and the inferred-representation mode |
| Separate fixed vectors | Preserve D and G; recheck each member's capacity using U |
| Context inferred | Resolve the source mode before applying these rules |

A scalable f16 value at LMUL=1 therefore requires LMUL=2 when converted to f32 with the same elements. An unavailable result grouping is diagnosed; conversion does not truncate elements or silently select a different vector mode.

The byte-size formula applies to byte-addressable data formats. Mask and packed sub-byte conversions require their own contracts.

## Numerical behavior

This operation performs numerical conversion, not bit reinterpretation. The applicable conversion contract must define rounding, overflow, saturation if any, subnormal behavior, and special values. Type compatibility alone does not establish those rules, especially for narrowing and low-precision formats.

A physical register width cannot authorize an implicit cast. Memory element types are checked separately by load/store operations.

## Mapping and conformance

The profile identifies conversion instructions or decompositions, source/result register classes and groups, overlap restrictions, and any required configuration changes. Preserve logical lane identity even when source and destination register groups differ.

Check widening and narrowing, unsupported LMUL, fixed-mode preservation, separate-member overflow, and tile flattening. Numerical tests must state a conversion policy independently of the shape checks.
