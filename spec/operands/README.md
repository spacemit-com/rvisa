# Operand Definitions

An operand combines a semantic role, type, coordinate relationship, and evaluation stage. Its source-language spelling and physical target encoding are separate representations.

- [Roles](roles.md) distinguish data, accumulators, addresses, and metadata.
- [Stages](stages.md) distinguish runtime values, compile-time parameters, and inferred information.
- [Constraints](constraints.md) define relationships among operands and results.

Each operation specializes these common rules. A source API argument may become multiple IR or machine operands; a target instruction may use implicit configuration not exposed as a source argument.

See the [operation reference](../operations/README.md) and [target mapping contract](../../mappings/contract.md).
