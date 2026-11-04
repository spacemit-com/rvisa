# RVISA MLIR Dialect

**Implementation status: TBD.**

The RVISA dialect provides the compiler representation of RVISA types, operations, effects, and control flow. Its semantics are defined by the [language specification](../spec/README.md).

## Design

[Dialect design](docs/README.md) covers type/operation representation, verification, interfaces, transformations, and conversion boundaries. The design must retain symbolic capacity, logical coordinates, numerical policy, and state dependencies.

Target conversion implements a versioned [mapping contract](../mappings/contract.md). The existence of a target instruction is not sufficient to justify a conversion.

## Source organization

| Path | Responsibility |
| --- | --- |
| `include/rvisa/` | Public dialect definitions, ODS, and interfaces |
| `lib/` | Verification, transformations, and conversion implementation |
| `tools/` | Dialect development drivers |
| `test/` | Parsing/printing, diagnostics, interfaces, and conversion tests |

The LLVM/MLIR dependency revision and build interface will be specified with the implementation. User-facing C++ language bindings are maintained separately in the [C++ frontend](../frontends/cpp/README.md).
