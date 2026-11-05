# Changelog

## Unreleased

- Adopt concrete vector/tile types and operation contracts from the fixed v0.1-draft design baseline, with provenance and RFC 0002.
- Define configuration, vector views/conversion, Cartesian group multiplication, matrix batch modes, block scaling, bounded memory access, compiler-managed transfers, and convolution-window loading.
- Add specification-level positive and negative conformance cases; preserve unresolved numerical, packing, extended-store, and runtime contracts explicitly.

- Define RVISA's positioning around virtual instruction syntax, register representations, and explicit mappings in versioned target profiles.
- Add an RVISA-notation source form and metadata record for each of the six reference workloads; notation is not compiled or executed in this revision.
- Register the first three target mapping profiles: `ime-main`, `vme-main`, and `ame-main`. Each pins an upstream commit, one supported element tuple, a single microtile geometry, the register classes and groups, one lowering rule family, and the numerical contract, and records every verification layer explicitly (`not-run` where no evidence exists).
- Specify tile register priority and distinguish mapping guarantees from concrete register allocation and profile maturity.
- Align compiler design, profile templates, reference workloads, and conformance evidence with the instruction/register contracts.

- Organize the specification around execution, values, layouts, memory, numerics, types, operands, and operation families.
- Establish a shared format for versioned target mappings and conformance evidence.
- Document MLIR dialect responsibilities, with implementation status TBD.
- Remove source-language frontend scaffolding from this revision while retaining Python/C++ demo requirements.
- Define reference workload requirements for vector addition, GEMM, epilogues, block scaling, convolution, and attention.
- Add specification status, terminology, references, and contribution conventions.
- License project documentation and code under Apache-2.0.

The current working draft version is recorded in [VERSION](VERSION).
