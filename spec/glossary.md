# Terms and Abbreviations

| Term | Meaning in RVISA |
| --- | --- |
| RVISA | RISC-V Virtual ISA; the virtual instruction specification described by this project |
| Virtual operation | Typed RVISA operation with defined operands, effects, and semantics; a profile identifies its legal target realization |
| Program | One logical execution of a kernel body |
| Kernel | A compiled computation invoked through a runtime contract |
| Scalar | A single computation value |
| Vector / vec | An ordered value with fixed or scalable capacity and defined grouping |
| Tile | A rank-1 through rank-N computation value whose target representation prioritizes registers |
| Mask | Boolean conditions over a specified logical coordinate domain |
| Descriptor | Addressing metadata for memory; not the contents of that memory |
| Operand | An input to an operation, with a type, role, and evaluation stage |
| Attribute | Compile-time information in a particular IR representation |
| Effect | An observable memory, configuration, allocation, or other state interaction |
| Layout | A coordinate interpretation or physical representation, qualified by context |
| Linear layout | Basis-described carrier-to-coordinate map, composed with exact views and validity domains |
| Carrier | Register-class/group, fragment, and element-slot representation of a value |
| View | Coordinate reinterpretation that preserves every element's carrier location |
| Anchor operation | Operation imposing or selecting representation constraints, such as load/store, MMA, or textract |
| Closed tile region | Tile graph with loads or no tile inputs and stores or no tile outputs, subject to complete boundary/effect accounting |
| Lowering | Transformation to a more concrete representation while preserving its contract |
| Target profile | Versioned instruction mappings, register constraints, capabilities, and supported domain |
| Register class | A target-defined category of architectural registers with stated operand and access rules |
| Register group | Registers used together under a target's size, alignment, overlap, and operand constraints |
| Register allocation | Assignment of concrete physical registers and reuse over time within the profile's constraints |
| Mapping guarantee | A profile revision's declared correspondence between RVISA operations, legal target sequences, and operand/register constraints |
| Mapping stability | Preservation of that declared contract within a profile revision; distinct from the profile maturity state `stable` |
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
