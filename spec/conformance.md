# Conformance

Conformance is defined against an identified RVISA revision and an explicitly declared implementation scope.

## Implementation declaration

An implementation identifies its supported virtual operations, types and operand forms, profile revisions, numerical policies, runtime assumptions, and known limitations. Support for an extension family is not a complete declaration.

A supported operation must preserve its operand/result contract, coordinate relationships, numerical behavior, memory effects, state dependencies, and required diagnostics within the declared domain.

The declaration identifies applicable [mapping guarantees](../mappings/contract.md#mapping-guarantees), including legal instruction sequences, register classes/groups, and resource policies. Tile mappings are evaluated against [RVISA-TILE-REG-1](types/tile.md#register-representation).

## Shared requirements

Verification addresses:

- Type and shape inference, grouping, and valid conversions.
- Operand roles, defaults, and evaluation stages.
- Target instruction sequence conditions, register classes/groups, alignment, overlap, operand ties, and required fixed registers.
- Tile register selection, fragmentation, live resource limits, and permitted spills or staging.
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
| IR checks | Representation invariants, effects, and conversion legality |
| Target compilation | Acceptance by a specified toolchain and target configuration |
| Instruction/register inspection | Emitted sequence, operand representation, grouping, allocation constraints, clobbers, and spill/staging policy |
| Execution | Results and behavior on the identified simulator or device |
| Performance | Measured cost under specified inputs and conditions |

These claims are independent. Compilation success does not establish the required instruction/register mapping, and a numerical result alone does not prove its register constraints. Host arithmetic may not model target rounding, and simulator execution does not establish hardware throughput.

Inspection accepts legal allocation and scheduling choices within the profile. It requires exact physical register numbers or instruction counts only when they are explicit obligations of that contract, rather than incidental properties of one compiler output.

## Case records

A case links to requirements and specifies input, preconditions, expected behavior or diagnostics, comparison policy, applicability, and provenance. Include boundary and negative cases as well as representative valid inputs.

Shared cases and reference methods are organized in [conformance/](../conformance/README.md). Current executable coverage is tracked in [Specification Status](status.md).
