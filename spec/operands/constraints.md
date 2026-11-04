# Operand Constraints

Operation validity is determined from the complete operand/result relationship, not by checking each argument independently.

## Shared constraints

An operation specifies compatible element types, shape equations, capacities, groups, layouts, evaluation stages, optional arguments, and defaults. Accumulation types and result shapes are checked explicitly.

Broadcasting is legal only where the data role permits it and the target shape is uniquely determined. Ambiguous inference requires additional information or a diagnostic.

## Memory and target refinements

Memory operands follow access, alignment, allocation, bounds, and aliasing requirements. Logical constraints do not establish a valid target register allocation.

A target profile may restrict supported combinations and legal representations. It specifies instruction selection conditions, register classes, group size/alignment, overlap, operand ties, immediate ranges, and any required fixed registers. These conditions constrain allocation without fixing every physical register number. A profile cannot change the core result, omit state dependencies, or relax required numerical behavior.

## Validation order

Resolve roles and defaults, infer types/shapes, check staging and common semantics, and then validate target-specific capabilities and resources. Preserve enough structure to distinguish source errors from mapping failures.

Conditions not provable statically must be represented as explicit runtime preconditions or checks where the contract requires them. Unknown information is not evidence that a constraint holds.

See [diagnostics](../core/diagnostics.md) and the [operation definition format](../operations/operation-template.md).
