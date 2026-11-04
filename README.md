# RVISA Specification

[English](README.md) | [Chinese](README_CN.md)

RVISA is a virtual instruction set for RISC-V scalar, vector, and matrix computation. It defines a common programming model for expressing computation and mapping it to RVV and matrix extensions, including [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), and [AME](https://github.com/riscv/riscv-attached-matrix-extension).

This repository contains the RVISA language specification, target mapping contracts, MLIR design documents, and reference workloads. It is intended for architecture designers, compiler implementers, kernel developers, and specification contributors.

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
| [Operations](spec/operations/README.md) | Operation families and definition format |
| [Target mappings](mappings/README.md) | Versioned register, operand, and lowering contracts |
| [Conformance](spec/conformance.md) | Requirements and evidence for implementation claims |

The core specification defines observable behavior. The MLIR dialect represents that behavior in compiler IR; target profiles define the conditions under which it can be implemented on a particular architecture.

## Project status

The specification is a **working draft**. Its scope and outstanding decisions are recorded in [Specification Status](spec/status.md), and its version is recorded in [VERSION](VERSION).

| Component | Status |
| --- | --- |
| Core specification and operation reference | In development |
| Target mapping contracts | In development; concrete profiles are not yet registered |
| [MLIR dialect](mlir/README.md) | TBD |
| [Reference workloads](demos/README.md) | Documented workloads; source implementations TBD |

Python and C++ demos remain part of the reference workloads. Source-language frontend implementations are outside the scope of this revision.

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
