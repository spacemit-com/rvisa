# RVISA MLIR Dialect

**Implementation status: TBD.**

The RVISA dialect is intended to represent virtual instructions, types, operand roles, register representation constraints, effects, and control flow. Its semantics are defined by the [virtual instruction specification](../spec/README.md).

## Design

[Dialect design](docs/README.md) covers type/operation representation, verification, interfaces, transformations, and conversion boundaries. The design must retain symbolic capacity, logical coordinates, numerical policy, state dependencies, and the selected profile's register class/group constraints.

Target conversion implements a versioned [mapping contract](../mappings/contract.md). Conversion preserves the profile's instruction and register guarantees and the [tile register policy](../spec/types/tile.md#register-representation). Physical register assignment is performed at the appropriate lowering stage; an RVISA SSA value does not by itself fix that assignment.

## Source organization

| Path | Responsibility |
| --- | --- |
| `include/rvisa/` | Public dialect definitions, ODS, and interfaces |
| `lib/` | Verification, transformations, and conversion implementation |
| `tools/` | Dialect development drivers |
| `test/` | Parsing/printing, diagnostics, interfaces, and conversion tests |

The LLVM/MLIR dependency revision and build interface will be specified with the implementation.
