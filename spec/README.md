# RISC-V Virtual ISA Specification

**Document state: working draft.** See [Specification Status](status.md) for coverage and open decisions.

RVISA defines virtual instruction syntax, typed operations, operand roles, and register grouping constraints rooted in RISC-V matrix extensions and RVV. This manual specifies their observable behavior and the versioned contracts that map them to target instruction sequences and register representations.

## Part I: Architecture and programming model

| Chapter | Subject |
| --- | --- |
| [Introduction](introduction.md) | Purpose, audience, scope, and abstraction boundaries |
| [Conventions](conventions.md) | Normative language, notation, and document organization |
| [Terminology](glossary.md) | Shared architectural and compiler vocabulary |
| [Execution model](core/execution-model.md) | Programs, control flow, calls, and configuration scope |
| [Value model](core/value-model.md) | Values, views, descriptors, and state |
| [Layout model](core/layout-model.md) | Logical coordinates, matrix axes, and physical representation |
| [Linear layouts](core/linear-layout.md) | Basis maps, carrier-preserving views, and representation conversions |
| [Tile optimization](core/tile-optimization.md) | Explicit programmer forms, anchors, and closed tile regions |
| [Memory model](core/memory-model.md) | Addressing, bounds, aliasing, ordering, and transfer completion |
| [Compiler-managed transfers](core/transfers.md) | Transfer permission, readiness, waits, and temporary-storage lifetime |
| [Numeric model](core/numeric-model.md) | Precision, rounding, reductions, and special values |
| [Diagnostics](core/diagnostics.md) | Invalid programs and unsupported configurations |

## Part II: Types, operands, and operations

- [Type system](types/README.md)
- [Operand definitions](operands/README.md)
- [Operation reference](operations/README.md)
- [Conformance requirements](conformance.md)

## Part III: Compiler representation and target realization

- [MLIR representation](../mlir/README.md)
- [Target mappings](../mappings/README.md) and [mapping guarantees](../mappings/contract.md#mapping-guarantees)
- [Reference workloads](../demos/README.md)
- [Conformance cases and methods](../conformance/README.md)

## Supporting material

[Design baseline](design-baseline.md) records the fixed source revision and definition correspondence for the adopted core designs. [References](references.md) identify related specifications and guides. [RFCs](../rfcs/README.md) record proposals and decisions. Contributions follow [CONTRIBUTING.md](../CONTRIBUTING.md).

Requirements in this working draft are subject to review. Examples and mapping guidance do not silently extend or override the language contract.
