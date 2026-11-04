# References

References provide architectural context and documentation guidance. A concrete target profile must identify the exact specification revision and sections it implements; a moving repository URL is not sufficient evidence.

| Reference | Scope |
| --- | --- |
| [RISC-V Instruction Set Manual](https://github.com/riscv/riscv-isa-manual) | Scalar/vector ISA and architectural memory behavior |
| [RISC-V ELF psABI](https://github.com/riscv-non-isa/riscv-elf-psabi-doc) | Calling conventions, binary interfaces, and toolchain boundaries |
| [Standard IME](https://github.com/riscv/integrated-matrix-extension) | Integrated matrix extension source material |
| [VME specification work](https://github.com/riscv/riscv-isa-manual/pull/2997) | Vector-matrix specification material; profile status is recorded separately |
| [Official AME](https://github.com/riscv/riscv-attached-matrix-extension) | Attached matrix extension source material |
| [RVV Intrinsics specification](https://github.com/riscv-non-isa/riscv-rvv-intrinsic-doc/blob/main/doc/rvv-intrinsic-spec.adoc) | Reference for typed instruction notation, grouping constraints, and the compiler's role in scheduling and allocation |
| [NVIDIA PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/) | Virtual ISA reference for RVISA's design positioning |
| [NVIDIA cuTile](https://docs.nvidia.com/cuda/cutile-python/) | Tile programming model reference for RVISA's design positioning |
| [MLIR documentation](https://mlir.llvm.org/docs/) | Dialects, types, operations, interfaces, and conversion infrastructure |
| [RISE RISC-V Optimization Guide](https://riscv-optimization-guide.riseproject.dev/) | Implementation-neutral guidance and explicitly qualified implementation-specific recommendations |

## Specification authoring references

- [RISC-V specification template](https://github.com/riscv/docs-spec-template/tree/5885bbe659fc2955b49ab213c50ee2889db5e257) for document organization and state separation.
- [RISC-V normative-rule guidance](https://github.com/riscv/docs-resources/blob/1ba53de90df827246ac771e3cb8cc3cc124b0b1c/normative-rules.md) for identifiable architectural requirements and implementation-defined behavior.
- [RISC-V ISA Manual introduction and navigation](https://github.com/riscv/riscv-isa-manual/blob/418bdc4990ae2d60a86f1e11e8d7795aa279da61/README.md).
- [RISC-V psABI terminology and scope](https://github.com/riscv-non-isa/riscv-elf-psabi-doc/blob/9b2767e2a8851709608c4e1452998ad232d6278b/introduction.adoc).
- [RISE Optimization Guide source repository](https://gitlab.com/riseproject/riscv-optimization-guide).

These references do not confer affiliation, approval, or an upstream publication state on RVISA. Their content and licenses remain those of their respective projects.
