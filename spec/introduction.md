# Introduction

RVISA (RISC-V Virtual ISA) specifies virtual instruction syntax rooted in the instructions, operands, and register organization of RISC-V matrix extensions and RVV. Typed scalar, vector, and tile operations retain the information needed to define legal target instruction sequences and register groups.

## Design position

RVISA targets an abstraction level slightly above [NVIDIA PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/) and below [NVIDIA cuTile](https://docs.nvidia.com/cuda/cutile-python/). This comparison describes the project's intended level of abstraction. Its technical contract is defined by operation semantics, operand roles, and explicit target mappings.

Notation modeled on [RVV Intrinsics](https://github.com/riscv-non-isa/riscv-rvv-intrinsic-doc) keeps types and grouping constraints visible while leaving scheduling and physical register allocation to implementations within the selected profile's rules. The notation does not prescribe a C API, Python package, or a particular compiler interface.

## Audience

The specification addresses architecture designers defining target capabilities, compiler developers implementing IR and target lowering, kernel developers writing numerical workloads, and reviewers evaluating portability and conformance.

Readers are expected to understand RISC-V scalar/vector execution, matrix instruction operands, register groups, and compiler intermediate representations. Terms specific to this specification are defined in the [glossary](glossary.md).

## Abstraction boundaries

| Layer | Responsibility |
| --- | --- |
| Virtual instruction specification | Types, operations, operand roles, logical grouping, effects, and observable results |
| Target profile | Versioned instruction sequences, register classes/groups, operand layouts, configuration, and resource constraints |
| Compiler IR and implementation | Representation, verification, transformations, scheduling, and allocation within the specified constraints |
| Runtime environment | Invocation, allocation, dispatch, completion, and platform integration where specified |

A tile retains a logical coordinate domain and element type while its [representation prioritizes registers](types/tile.md#register-representation). Register classes and grouping come from the selected profile. A tile may span registers or execute in fragments; its logical shape does not fix physical register numbers or require a matrix register of the same shape.

## Scope

The specification covers scalar, vector, and tile operations; their type and operand relationships; and the numerical, memory, configuration, and state requirements needed for legal instruction mappings.

RVV provides a vector execution basis. [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), [AME](https://github.com/riscv/riscv-attached-matrix-extension), and vendor extensions are addressed through separately identified target profiles. Their names alone do not define a complete capability set or guarantee binary compatibility.

RVISA does not allocate RISC-V instruction encodings or replace the target ISA, platform ABI, or operating-system specification. Hardware-specific performance recommendations belong with the applicable profile and preserve the specified observable behavior.

## Mapping and portability

The [mapping guarantees](../mappings/contract.md#mapping-guarantees) establish the correspondence between operations, legal instruction sequences, operand representations, and register constraints within a profile revision. They permit documented decompositions and implementation choices without silently changing that contract.

Notation portability, semantic equivalence, binary compatibility, and performance portability are distinct properties. A conforming mapping preserves the declared RVISA contract for its supported subset; resource requirements and execution costs remain target-specific.

The [document status](status.md) distinguishes defined draft material, open contracts, and implementation work.
