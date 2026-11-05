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

## RVISA design provenance

The [design baseline](design-baseline.md) identifies the exact earlier RVISA revision, its declared specification status, and the current primary definitions. It distinguishes semantic adoption from frontend or target implementation support.

## Layout and grouping sources

- [Linear Layouts, arXiv:2505.23819v5](https://arxiv.org/html/2505.23819v5), revised 2026-03-06: binary-linear carrier maps and layout algebra.
- [Triton LinearLayout.h at f8cddb947b471d6902a39f62d0894d1e552e5e75](https://github.com/triton-lang/triton/blob/f8cddb947b471d6902a39f62d0894d1e552e5e75/include/triton/Tools/LinearLayout.h): fixed implementation reference for basis representation and composition.
- [RISC-V vector v1.0 source at 3570f998903f00352552b670f1f7b7334f0a144a](https://github.com/riscvarchive/riscv-v-spec/blob/3570f998903f00352552b670f1f7b7334f0a144a/v-spec.adoc): VLEN units, register grouping, and per-instruction group limits. This tag identifies a frozen public-review source snapshot; its introduction is not used as a claim about later ratification status.

RVISA's [linear-layout contract](core/linear-layout.md) and [tile-region rules](core/tile-optimization.md) define this project's semantics. The 8x8x8 example is a stated profile assumption, not a claim about an upstream matrix extension.

## Specification authoring references

- [RISC-V specification template](https://github.com/riscv/docs-spec-template/tree/5885bbe659fc2955b49ab213c50ee2889db5e257) for document organization and state separation.
- [RISC-V normative-rule guidance](https://github.com/riscv/docs-resources/blob/1ba53de90df827246ac771e3cb8cc3cc124b0b1c/normative-rules.md) for identifiable architectural requirements and implementation-defined behavior.
- [RISC-V ISA Manual introduction and navigation](https://github.com/riscv/riscv-isa-manual/blob/418bdc4990ae2d60a86f1e11e8d7795aa279da61/README.md).
- [RISC-V psABI terminology and scope](https://github.com/riscv-non-isa/riscv-elf-psabi-doc/blob/9b2767e2a8851709608c4e1452998ad232d6278b/introduction.adoc).
- [RISE Optimization Guide source repository](https://gitlab.com/riseproject/riscv-optimization-guide).

These references do not confer affiliation, approval, or an upstream publication state on RVISA. Their content and licenses remain those of their respective projects.
