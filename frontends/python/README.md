# Python Frontend

**Implementation status: TBD.**

The Python frontend defines a source-language binding for RVISA kernels, types, and operations. It distinguishes host-side invocation and specialization from execution of the compiled program.

[Binding design](docs/README.md) covers the source subset, annotations, operation spelling, control flow, and diagnostics.

| Path | Responsibility |
| --- | --- |
| `docs/` | Language binding and compilation model |
| `src/` | Frontend implementation |
| `tests/` | Syntax, diagnostics, semantic correspondence, and integration checks |

The public package interface and compilation mechanism are under design. Their definitions must preserve the [shared frontend requirements](../README.md).
