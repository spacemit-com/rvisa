# Conformance

Conformance is defined against an identified RVISA revision and an explicitly declared implementation scope.

## Implementation declaration

An implementation identifies its supported types, operations, language features, profiles, numerical policies, runtime assumptions, and known limitations. Support for an extension family is not a complete declaration.

A supported operation must preserve its operand/result contract, coordinate relationships, numerical behavior, memory effects, state dependencies, and required diagnostics within the declared domain.

## Shared requirements

Verification addresses:

- Type and shape inference, grouping, and valid conversions.
- Operand roles, defaults, and evaluation stages.
- Logical coordinates, layout transformations, and batch relationships.
- Bounds, aliasing, inactive elements, and temporary-storage lifetime.
- Precision, reduction order, special values, and approximation guarantees.
- Configuration, calls, and target-state preservation.
- Invalid input and unsupported capability handling.

A target profile may narrow the supported domain; it cannot redefine an accepted operation's semantics.

## Evidence layers

| Layer | What it establishes |
| --- | --- |
| Documentation and metadata | Structural consistency and traceability |
| Independent formulas/coordinates | The stated mathematical or indexing properties |
| Frontend checks | Accepted/rejected source behavior and semantic normalization |
| IR checks | Representation invariants, effects, and conversion legality |
| Target compilation | Acceptance by a specified toolchain and target configuration |
| Execution | Results and behavior on the identified simulator or device |
| Performance | Measured cost under specified inputs and conditions |

These claims are independent. In particular, host arithmetic may not model target rounding, and simulator execution does not establish hardware throughput.

## Case records

A case links to requirements and specifies input, preconditions, expected behavior or diagnostics, comparison policy, applicability, and provenance. Include boundary and negative cases as well as representative valid inputs.

Shared cases and reference methods are organized in [conformance/](../conformance/README.md). Current executable coverage is tracked in [Specification Status](status.md).
