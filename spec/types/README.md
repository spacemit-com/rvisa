# Type System

RVISA types describe logical values and constraints required to interpret operations. They do not directly allocate physical registers.

| Type category | Definition |
| --- | --- |
| [Scalar](scalar.md) | One typed computation element |
| [Vector](vector.md) | Fixed or scalable ordered elements with explicit grouping semantics |
| [Tile](tile.md) | Multidimensional computation values |
| [Mask](mask.md) | Boolean conditions over value coordinates |
| [Memory](memory.md) | Pointer and descriptor information |

Type inference must produce a consistent result before the relevant operation or call is legalized. Symbolic capacity can remain symbolic; unresolved semantics cannot be replaced with a guessed target constant.

The [operand model](../operands/README.md) specifies how these types are used, and the [numeric model](../core/numeric-model.md) constrains conversions and arithmetic.
