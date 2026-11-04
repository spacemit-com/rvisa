# Terms and Abbreviations

| Term | Meaning in RVISA |
| --- | --- |
| RVISA | RISC-V virtual instruction set described by this project |
| Program | One logical execution of a kernel body |
| Kernel | A compiled computation invoked through a runtime contract |
| Scalar | A single computation value |
| Vector / vec | An ordered value with fixed or scalable capacity and defined grouping |
| Tile | A multidimensional computation value |
| Mask | Boolean conditions over a specified logical coordinate domain |
| Descriptor | Addressing metadata for memory; not the contents of that memory |
| Operand | An input to an operation, with a type, role, and evaluation stage |
| Attribute | Compile-time information in a particular IR representation |
| Effect | An observable memory, configuration, allocation, or other state interaction |
| Layout | A coordinate interpretation or physical representation, qualified by context |
| Lowering | Transformation to a more concrete representation while preserving its contract |
| Target profile | Versioned capabilities, resource constraints, and mapping requirements |
| Conformance | Satisfaction of identified requirements for a declared version and scope |
| RVV | RISC-V vector execution facilities relevant to a selected target |
| [IME](https://github.com/riscv/integrated-matrix-extension) | Integrated Matrix Extension family; precise meaning is fixed by the profile |
| [VME](https://github.com/riscv/riscv-isa-manual/pull/2997) | Vector-Matrix Extension family; precise meaning is fixed by the profile |
| [AME](https://github.com/riscv/riscv-attached-matrix-extension) | Attached Matrix Extension family; precise meaning is fixed by the profile |
| ABI | Application binary interface |
| VLEN | Target vector-register width in bits |
| SEW | Selected element width in the relevant target configuration |
| LMUL | Register-group multiplier in the relevant RVV context |
| TMA | A profile-defined tile-transfer acceleration path |

Extension names identify a family of work, not an interchangeable hardware contract. Standard and vendor definitions with similar names require separate provenance.

See [Introduction](introduction.md) and [Conventions](conventions.md).
