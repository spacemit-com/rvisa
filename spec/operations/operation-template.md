# Operation Definition Format

Individual operation entries use the following sections. This document is an authoring template.

## Identity

Record the operation name, stable identifier, family, document status, applicable specification version, and references to superseded definitions.

## Synopsis

State the virtual instruction's computation in one paragraph and provide its typed signature. Distinguish explicit operands, implicit state dependencies, results, and effects. Python/C++ notation examples refer to the same signature without asserting an implemented frontend.

## Operands and results

| Property | Required description |
| --- | --- |
| Role | Data, accumulator, address, descriptor, mask, configuration, or metadata |
| Type and shape | Accepted types, dimensions, capacities, grouping, and coordinate relationships |
| Stage | Runtime, compile-time/specialization, or inferred |
| Units | Explicit units for offsets, strides, sizes, and alignment |
| Defaults | Optional operands, default expansion, and inference requirements |

## Validity and inference

Define the constraints that determine legal combinations. Include ambiguous inference, shape mismatches, invalid enum values, resource-dependent validity, and relevant diagnostics.

## Semantics

Give a precise value, coordinate, or address definition. Specify initialization, contribution counts, bounds, inactive elements, ordering, and exceptional cases. Assign stable identifiers to requirements used by other components.

## Numerical behavior

Identify input/intermediate/accumulator/result formats, rounding points, reduction order, special values, and permitted variation. Mark unresolved numerical contracts explicitly.

## Effects and state

List memory and configuration interactions, allocation/lifetime obligations, calls, and synchronization. Distinguish logical behavior from internally scheduled asynchronous work.

## IR and target mappings

Reference the MLIR representation and relevant Python/C++ demos. Identify applicable profile identities/revisions and their mapping rules without redefining the core semantics.

| Mapping property | Required reference or description |
| --- | --- |
| Instruction correspondence | Legal target sequence or parameterized sequence family and selection conditions |
| Operand representation | Register classes/groups, element coordinates, immediates, and implicit state |
| Allocation constraints | Group size/alignment, overlap, operand ties, and any required fixed registers |
| Tile realization | Register representation, fragment geometry, and permitted reuse, spills, or staging |
| Numerical and state legality | Accumulation/rounding, active regions, configuration, clobbers, and completion |

Record many-to-one and one-to-many correspondence where relevant. The [mapping guarantees](../../mappings/contract.md#mapping-guarantees) allow implementation choices within the declared rules.

## Conformance and examples

Associate positive and negative cases with requirements. State numerical comparison policy and required evidence. Include instruction/register inspection obligations separately from value comparisons. Label illustrative examples and keep them consistent with the primary definition.

Return to the [operation reference](README.md).
