# Introduction

RVISA provides a virtual instruction set for RISC-V programs that combine scalar control, vector computation, and matrix operations. Its purpose is to express computation independently of a particular matrix instruction geometry while retaining the information needed for correct target mapping.

## Audience

The specification addresses architecture designers defining target capabilities, compiler developers implementing IR and target lowering, kernel developers writing numerical workloads, and reviewers evaluating portability and conformance.

Readers are expected to understand basic RISC-V scalar/vector execution, multidimensional arrays, and compiler intermediate representations. Terms specific to this specification are defined in the [glossary](glossary.md).

## Abstraction boundaries

| Layer | Responsibility |
| --- | --- |
| Core language | Values, types, operations, control flow, effects, and observable results |
| Compiler IR | Representation of the same semantics for verification and transformation |
| Target mapping | Legal instruction sequences, register/operand layouts, configuration, and resource constraints |
| Runtime environment | Invocation, allocation, dispatch, completion, and platform integration where specified |

A logical tile is a value with coordinates and an element type. Its shape does not prescribe one physical register, a fixed array geometry, or a hardware matrix facility. Mapping that value may require partitioning, packing, transfers, and scheduling.

## Scope

The language covers scalar, vector, and tile values; their operand relationships; matrix computation; and memory/state requirements needed to combine these operations.

RVV provides a vector execution basis. [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), [AME](https://github.com/riscv/riscv-attached-matrix-extension), and vendor extensions are addressed through separately identified target profiles. Their names alone do not define a complete capability set or guarantee binary compatibility.

RVISA does not allocate RISC-V instruction encodings or replace the target ISA, platform ABI, or operating-system specification. Hardware-specific performance recommendations belong with the applicable profile, and must preserve the language's observable behavior.

## Portability

Source portability, semantic equivalence, binary compatibility, and performance portability are distinct properties. A conforming mapping preserves the declared language contract for its supported subset; its resource requirements and execution costs remain target-specific.

The [document status](status.md) distinguishes defined draft material, open contracts, and implementation work.
