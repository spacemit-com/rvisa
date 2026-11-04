# Operand Evaluation Stages

RVISA distinguishes values available during program execution from information required to define or specialize the computation.

| Stage | Examples |
| --- | --- |
| Compile time / specialization | Types, required static shape structure, matrix layout/mode enums, transfer-selection options |
| Runtime | Data values, addresses, indices, access bounds, supported active extents |
| Inference | Type, capacity, or shape information uniquely determined by surrounding constraints |

A symbolic capacity may be represented and reasoned about at compile time while its numerical value depends on the runtime target. Symbolic does not mean unconstrained.

A runtime value cannot select an operation variant that requires a compile-time enum or alter a statically required result rank. Conversely, source-language evaluation must not replace a runtime computation simply because an implementation observed a constant.

Default arguments are expanded before comparing equivalent source forms. The MLIR design determines which resolved information is represented as an operand, type, attribute, or property; those encodings do not redefine the virtual operation's staging rules. Target immediate fields and configuration operands add legality conditions recorded in the profile; they do not turn an arbitrary runtime value into a compile-time constant.

See [execution](../core/execution-model.md) and [MLIR](../../mlir/docs/README.md).
