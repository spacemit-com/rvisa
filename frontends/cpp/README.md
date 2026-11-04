# C++ Frontend

**Implementation status: TBD.**

The C++ frontend defines the user-facing language binding, target compilation boundary, and call interface for RVISA computation. It is distinct from the C++ classes used to implement the MLIR dialect.

[Binding design](docs/README.md) covers the source subset, types, operations, templates, control flow, and ABI boundaries.

| Path | Responsibility |
| --- | --- |
| `docs/` | Language binding and compilation model |
| `include/` | Public frontend declarations |
| `lib/` | Frontend/compiler integration |
| `test/` | Syntax, diagnostics, semantic correspondence, and integration checks |

The compiler integration and dependency versions are under design. The binding follows the [shared frontend requirements](../README.md).
