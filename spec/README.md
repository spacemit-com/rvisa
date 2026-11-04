# RVISA Specification

**Document state: working draft.** See [Specification Status](status.md) for coverage and open decisions.

RVISA defines the observable behavior of scalar, vector, and tile programs and the contracts required to map them to RISC-V targets. This manual separates language semantics from source-language bindings, IR representation, and target implementation choices.

## Part I: Architecture and programming model

| Chapter | Subject |
| --- | --- |
| [Introduction](introduction.md) | Purpose, audience, scope, and abstraction boundaries |
| [Conventions](conventions.md) | Normative language, notation, and document organization |
| [Terminology](glossary.md) | Shared architectural and compiler vocabulary |
| [Execution model](core/execution-model.md) | Programs, control flow, calls, and configuration scope |
| [Value model](core/value-model.md) | Values, views, descriptors, and state |
| [Layout model](core/layout-model.md) | Logical coordinates, matrix axes, and physical representation |
| [Memory model](core/memory-model.md) | Addressing, bounds, aliasing, ordering, and transfer completion |
| [Numeric model](core/numeric-model.md) | Precision, rounding, reductions, and special values |
| [Diagnostics](core/diagnostics.md) | Invalid programs and unsupported configurations |

## Part II: Types, operands, and operations

- [Type system](types/README.md)
- [Operand definitions](operands/README.md)
- [Operation reference](operations/README.md)
- [Conformance requirements](conformance.md)

## Part III: Bindings and target realization

- [Python and C++ frontends](../frontends/README.md)
- [MLIR representation](../mlir/README.md)
- [Target mappings](../mappings/README.md)
- [Reference workloads](../demos/README.md)
- [Conformance cases and methods](../conformance/README.md)

## Supporting material

[References](references.md) identify related specifications and guides. [RFCs](../rfcs/README.md) record proposals and decisions. Contributions follow [CONTRIBUTING.md](../CONTRIBUTING.md).

Requirements in this working draft are subject to review. Examples and mapping guidance do not silently extend or override the language contract.
