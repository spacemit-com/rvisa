# RISC-V Virtual ISA

[English](README.md) | [Chinese](README_CN.md)

RVISA (RISC-V Virtual ISA) defines virtual instruction syntax for RISC-V scalar, vector, and matrix computation. Its design starts from the instructions, operands, and register organization of RISC-V matrix extensions, including [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), and [AME](https://github.com/riscv/riscv-attached-matrix-extension), together with RVV.

RVISA targets an abstraction level slightly above [NVIDIA PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/) and below [NVIDIA cuTile](https://docs.nvidia.com/cuda/cutile-python/). Rooted in RISC-V matrix extensions, it uses notation modeled on [RVV Intrinsics](https://github.com/riscv-non-isa/riscv-rvv-intrinsic-doc) to express typed operations, operand roles, and constraints on register groups. Versioned target profiles define explicit mappings to target instruction sequences and register classes and groups.

[Tile mappings](spec/types/tile.md#register-representation) prioritize target registers: vector registers and register groups, matrix operand registers, and accumulator registers where available. A tile can span multiple registers or be partitioned to match instruction geometry. The [mapping guarantees](mappings/contract.md#mapping-guarantees) define the legal sequences, grouping, allocation constraints, and transfers for each profile; they allow implementation choices within those constraints.

Every optimization of an RVISA tile computation must be [expressible by the programmer](spec/core/tile-optimization.md#expressibility-requirement). Tiles range from 1D to ND; reshape and axis permutation preserve element locations, while explicit conversions and load/store/MMA/textract anchors determine physical layout. [Linear layouts](spec/core/linear-layout.md) derive these mappings, including [blocked matrix computation](spec/operations/matrix/blocked-mma.md).

This repository contains the RVISA instruction syntax, type and operand definitions, target mapping contracts, MLIR design documents, and reference workloads. It is intended for architecture designers, compiler implementers, kernel developers, and specification contributors.

## Matrix extension repositories

| Extension | Upstream repository | RVISA mapping documentation |
| --- | --- | --- |
| Integrated Matrix Extension ([IME](https://github.com/riscv/integrated-matrix-extension)) | [riscv/integrated-matrix-extension](https://github.com/riscv/integrated-matrix-extension) | [Mapping requirements](mappings/ime/README.md) |
| Vector-Matrix Extension ([VME](https://github.com/riscv/riscv-isa-manual/pull/2997)) | [riscv/riscv-vme](https://github.com/riscv/riscv-vme) | [Mapping requirements](mappings/vme/README.md) |
| Attached Matrix Extension ([AME](https://github.com/riscv/riscv-attached-matrix-extension)) | [riscv/riscv-attached-matrix-extension](https://github.com/riscv/riscv-attached-matrix-extension) | [Mapping requirements](mappings/ame/README.md) |

The vector-matrix specification is available through the [Zvt proposal in the RISC-V ISA Manual](https://github.com/riscv/riscv-isa-manual/pull/2997). Each [mapping profile](mappings/README.md) identifies its exact upstream revision, register and operand requirements, and verification evidence.

## Specification

The [RVISA Specification](spec/README.md) is the reading entry point.

| Part | Contents |
| --- | --- |
| [Introduction and terminology](spec/introduction.md) | Scope, abstraction boundaries, and terminology |
| [Core models](spec/core/README.md) | Execution, values, layouts, memory, numerics, and diagnostics |
| [Types](spec/types/README.md) | Scalar, vector, tile, mask, and memory types |
| [Operands](spec/operands/README.md) | Operand roles, evaluation stages, and constraints |
| [Operations](spec/operations/README.md) | Virtual signatures, semantics, defaults, and diagnostics |
| [Target mappings](mappings/README.md) | Versioned register, operand, and lowering contracts |
| [Conformance](spec/conformance.md) | Requirements and evidence for implementation claims |

The core specification defines observable behavior. The MLIR dialect represents that behavior in compiler IR; target profiles define the conditions under which it can be implemented on a particular architecture.

The draft defines [vector/tile types](spec/types/vector.md), [matrix and block-scaled operations](spec/operations/matrix/README.md), [memory and convolution access](spec/operations/memory/README.md), and [compiler-managed transfers](spec/core/transfers.md). Their [design baseline](spec/design-baseline.md) records provenance, while [core design cases](conformance/cases/core-designs.md) provide independently checkable expectations.

## Project status

The specification is a **working draft**. Its scope and outstanding decisions are recorded in [Specification Status](spec/status.md), and its version is recorded in [VERSION](VERSION).

| Component | Status |
| --- | --- |
| Core specification and operation reference | Key contracts defined in the working draft; open decisions tracked separately |
| Target mapping contracts | Draft profiles registered; target conformance not established |
| [MLIR dialect](mlir/README.md) | TBD |
| [Reference workloads](demos/README.md) | Documented workloads, each with an RVISA-notation source form |

A workload's source form is RVISA notation (`<name>.rvisa`); a host Python or C++ form may accompany it. Source-language frontend implementations are outside the scope of this revision, so notation is not compiled or executed.

Document status and implementation support are tracked separately. Changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## Repository organization

- [spec/](spec/README.md): specification chapters and references.
- [mappings/](mappings/README.md): standard and vendor target profiles.
- [mlir/](mlir/README.md): compiler representation and dialect design.
- [demos/](demos/README.md) and [conformance/](conformance/README.md): reference workloads and shared verification requirements.
- [rfcs/](rfcs/README.md): design proposals and decision records.
- [schemas/](schemas/README.md), [tools/](tools/README.md), and [tests/](tests/README.md): metadata and repository maintenance.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for editorial conventions, change proposals, and review requirements. Maintenance areas are listed in [MAINTAINERS.yaml](MAINTAINERS.yaml). Contributors follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

Project documentation and code are licensed under the [Apache License, Version 2.0](LICENSE), unless otherwise stated. Third-party material retains its applicable terms and attribution.
