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

## Core operation contracts

Profile authors begin with [vmadot](../spec/operations/vector/vmadot.md), [tmma](../spec/operations/matrix/tmma.md), and [tmma_scaled](../spec/operations/matrix/tmma-scaled.md) for input pairing, accumulator placement, scale axes, and numerics. [Vector configuration](../spec/operations/control/vconfig.md) and [transfers](../spec/core/transfers.md) define state and lifetime obligations. The [core design cases](../conformance/cases/core-designs.md) identify semantic distinctions a mapping must preserve before instruction/register evidence is added.

## Profiles

Concrete profiles are registered under `<family>/profiles/<profile-id>/`. One [IME](https://github.com/riscv/integrated-matrix-extension), one [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), and one [AME](https://github.com/riscv/riscv-attached-matrix-extension) profile are registered, all at `draft` maturity: [ime-main](ime/profiles/README.md), [vme-main](vme/profiles/README.md), and [ame-main](ame/profiles/README.md). Each covers a single integer or floating-point matrix multiply-accumulate tuple with a fixed microtile geometry, and each records its own open issues.

The [mapping contract](contract.md) defines required content. The [profile format](templates/profile/README.md) provides a reusable document structure. A profile states its supported subset and retains a source and evidence history across revisions.

Standard and vendor profiles remain distinct even when their names or instruction forms are similar. Numerical equivalence and legal resource use are prerequisites for lowering; performance is assessed separately.
