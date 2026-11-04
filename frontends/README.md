# Source-Language Frontends

**Implementation status: Python TBD; C++ TBD.**

The frontends expose RVISA semantics through Python and C++ source forms. Each binding defines its supported syntax, type spelling, default arguments, specialization rules, and diagnostics.

- [Python frontend](python/README.md)
- [C++ frontend](cpp/README.md)

## Shared semantic requirements

After defaults and source-specific syntax are normalized, equivalent features must preserve the same types, shapes, coordinates, numerical policy, effects, and control flow. A frontend may expose a documented subset; its coverage is explicit.

Runtime control flow is compiled as runtime behavior. Compile-time arguments remain subject to the [operand-stage rules](../spec/operands/stages.md). Unsupported source constructs require a diagnostic.

The frontends share the [language specification](../spec/README.md) and connect to the [compiler representation](../mlir/README.md). Their implementation mechanisms are selected independently of user-facing semantics.

Paired [reference workloads](../demos/README.md) provide common inputs and behavioral expectations for review.
