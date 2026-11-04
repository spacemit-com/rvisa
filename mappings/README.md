# Target Mappings

A target mapping defines how RVISA virtual operations are realized by instruction sequences and register classes/groups in a specific architecture and implementation profile. It connects typed values and operand roles to configuration state, memory accesses, and numerical behavior.

The [mapping guarantees](contract.md#mapping-guarantees) are scoped to a profile revision. They describe legal realizations and allocation constraints, while the separate maturity states describe review and verification evidence.

## Mapping families

| Family | Primary mapping concerns |
| --- | --- |
| [IME](https://github.com/riscv/integrated-matrix-extension) · [Mapping guide](ime/README.md) | Vector-register representations, matrix grouping, packing, and configuration |
| [VME](https://github.com/riscv/riscv-isa-manual/pull/2997) · [Mapping guide](vme/README.md) | Vector inputs, matrix accumulator state, and transfers between domains |
| [AME](https://github.com/riscv/riscv-attached-matrix-extension) · [Mapping guide](ame/README.md) | Independent matrix state, operand/accumulator storage, and system interfaces |
| [RVV](rvv/README.md) | Vector representations and semantics-preserving decompositions |
| [Vendor extensions](vendors/README.md) | Independently identified extension and implementation contracts |

The family descriptions identify areas of study. Exact behavior is defined by a versioned profile, not inferred from a family name.

## Profiles

Concrete profiles are registered under `<family>/profiles/<profile-id>/`. No [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), or [AME](https://github.com/riscv/riscv-attached-matrix-extension) profile has yet been registered.

The [mapping contract](contract.md) defines required content. The [profile format](templates/profile/README.md) provides a reusable document structure. A profile states its supported subset and retains a source and evidence history across revisions.

Standard and vendor profiles remain distinct even when their names or instruction forms are similar. Numerical equivalence and legal resource use are prerequisites for lowering; performance is assessed separately.
