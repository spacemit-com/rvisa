# Target Mapping Contract

A mapping is a versioned contract between RVISA semantics and a target execution model. It defines the conditions under which a source operation can be realized and the behavior required of that realization.

## Identity and applicability

A profile identifies:

- The RVISA specification revision and covered operations.
- The upstream architecture/extension specification, fixed tag or commit, and relevant sections.
- Implementation parameters and supported type/operation combinations.
- Encoding, configuration, ABI, and toolchain dependencies where they affect correctness.
- Excluded or provisional behavior.

Architecture versions, implementation revisions, and toolchain revisions are separate identities. Unknown capability or resource values must remain unresolved until a supported mapping can be established.

## Register and operand model

Describe A, B, and accumulator/result representations independently. Record domain, element coordinates, capacity, groups, alignment, aliases, overlap restrictions, implicit operands, and destructive updates.

The mapping preserves logical elements and grouping constraints while selecting a physical representation. Register count, simultaneous residency, active shape, and per-instruction geometry are different quantities.

Configuration reads/writes, clobbers, function boundaries, staging, and inter-domain transfers belong to the mapping. They cannot be hidden behind a one-line mnemonic correspondence.

## Lowering legality

Each rule specifies its source operation, preconditions, target sequence or precise pseudocode, coordinate transforms, dependencies, and diagnostics. It addresses zero extents, tails, bounds, aliasing, temporary lifetime, faults/restart, and completion as applicable.

Native instructions are selected only when they satisfy the numerical and observable-state contract. A decomposition must preserve the same requirements and respect explicit capability/fallback policy.

Optimization advice is informative and qualified by profile conditions. Instruction counts or logical geometry do not constitute a performance measurement.

## Profile documents

| Document | Content |
| --- | --- |
| `profile.yaml` | Identity, dependencies, capabilities, and resource parameters |
| `sources.md` | Fixed references and claim provenance |
| `registers.md` | Register domains and state/transfer model |
| `operands.md` | Operation-specific source-to-target operand correspondence |
| `lowering.md` | Legality conditions and realization rules |
| `numerics.md` | Precision, rounding, reduction, and equivalence |
| `conformance.yaml` | Requirement coverage and verification evidence |
| `CHANGELOG.md` | Revisions, compatibility, and migration |

The [profile document format](templates/profile/README.md) supplies the authoring form. Metadata schemas are tracked in [schemas/](../schemas/README.md).

## Maturity and evidence

| Maturity | Meaning |
| --- | --- |
| draft | Mapping under development with explicit open issues |
| reviewed | Specified scope examined by reviewers; evidence remains separately identified |
| stable | Published mapping contract with fixed sources, complete declared scope, and supporting evidence |
| deprecated | Retained for compatibility/history with a documented replacement or limitation |

These are RVISA mapping states, not upstream ratification labels. A template is an authoring form rather than a maturity state of a registered profile.

Stable status requires source/dependency identification, complete register/operand/numerical/state contracts for the declared subset, independent positive and negative cases, at least one compilation and execution path, and cross-organization review. Simulator evidence supports its stated execution scope; it does not establish device performance.

Record documentation checks, mathematical checks, IR legality, compilation, simulator execution, device execution, and performance independently. Each result identifies versions, configuration, inputs, method, outcome, and limitations.

## Revision policy

A changed upstream contract or target dependency requires impact analysis and a new profile revision where applicable. Preserve previous sources and evidence. Revalidate affected register, operand, numerical, state, and ABI rules.

Contributions follow [CONTRIBUTING.md](../CONTRIBUTING.md).
