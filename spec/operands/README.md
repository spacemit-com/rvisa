# Operand Definitions

An operand combines a semantic role, type, coordinate relationship, and evaluation stage. Its notation and physical target encoding are separate representations connected by the selected profile.

- [Roles](roles.md) distinguish data, accumulators, addresses, and metadata.
- [Stages](stages.md) distinguish runtime values, compile-time parameters, and inferred information.
- [Constraints](constraints.md) define relationships among operands and results.

Each virtual operation specializes these common rules. One RVISA operand may become multiple IR or machine operands, and a target instruction may use implicit configuration not exposed as a source argument. The mapping records register classes/groups, immediate restrictions, operand ties, and any fixed-register requirements.

See the [operation reference](../operations/README.md) and [target mapping contract](../../mappings/contract.md).
