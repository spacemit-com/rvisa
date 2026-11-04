# Type System

RVISA types describe computation values and the element, shape, capacity, and grouping constraints used by virtual instructions. Target profiles connect those constraints to register classes and legal register groups; concrete physical register allocation is an implementation responsibility.

| Type category | Definition |
| --- | --- |
| [Element types](element-types.md) | Numerical vocabulary, storage boundaries, and format capabilities |
| [Scalar](scalar.md) | One typed computation element |
| [Vector](vector.md) | Fixed or scalable ordered elements with explicit grouping semantics |
| [Tile](tile.md) | Multidimensional computation values whose mappings prioritize target registers |
| [Mask](mask.md) | Boolean conditions over value coordinates |
| [Memory](memory.md) | Pointer and descriptor information |

Type inference must produce a consistent result before the relevant operation or call is legalized. Symbolic capacity can remain symbolic; unresolved semantics cannot be replaced with a guessed target constant.

The [operand model](../operands/README.md) specifies how these types are used, and the [numeric model](../core/numeric-model.md) constrains conversions and arithmetic. The [mapping guarantees](../../mappings/contract.md#mapping-guarantees) distinguish type/grouping requirements from the registers selected for a particular instruction sequence.
