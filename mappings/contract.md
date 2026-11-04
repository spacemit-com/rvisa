# Target Mapping Contract

A mapping is a versioned contract from RVISA operations to target instruction sequences and register representations. It specifies the supported operand domain, legality conditions, and observable behavior of each realization.

## Identity and applicability

A profile identifies:

- The RVISA specification revision and covered operations.
- The upstream architecture/extension specification, fixed tag or commit, and relevant sections.
- Implementation parameters and supported type/operation combinations.
- Encoding, configuration, ABI, and toolchain dependencies where they affect correctness.
- Excluded or provisional behavior.

Architecture versions, implementation revisions, and toolchain revisions are separate identities. Unknown capability or resource values must remain unresolved until a supported mapping can be established.

## Mapping guarantees

**RVISA-MAP-1.** For each supported operation and operand domain, a profile MUST identify the legal target instruction sequence or sequence family, selection preconditions, register classes and groups, operand correspondence, configuration effects, and numerical obligations. A precise parameterized rule may represent several legal realizations.

Mapping stability means that this declared contract is preserved within the identified profile revision. Changes to legal sequences, grouping requirements, resource policies, or observable behavior require the revision analysis below. Mapping stability is distinct from the evidence-based profile maturity state `stable`.

A virtual operation may lower to several target instructions; several operations may share or fuse a legal sequence where their contracts permit it. A rule may specify an empty sequence when its semantics and representation constraints require no emitted instructions; a logical view alone does not establish that condition. Exact instruction counts, physical register numbers, scheduling, and spills may vary within the declared rules. Any fixed-register requirement imposed by the target remains binding and is recorded explicitly.

## Register and operand model

Describe A, B, and accumulator/result representations independently. Record architectural register class, element coordinates, capacity, groups, alignment, aliases, overlap restrictions, implicit operands, destructive updates, and any required fixed registers. Distinguish those architectural constraints from the concrete allocation chosen by a compiler.

The mapping preserves logical elements and grouping constraints while selecting a physical representation. Register count, simultaneous residency, active shape, and per-instruction geometry are different quantities.

Tile representations follow [RVISA-TILE-REG-1](../spec/types/tile.md#register-representation). For each supported domain, explain the choice of register classes/groups, fragment geometry, simultaneous resource requirements, and conditions for reuse, spilling, or memory staging.

Configuration reads/writes, clobbers, function boundaries, temporary lifetime, and inter-domain transfers belong to the mapping. They cannot be hidden behind a one-line mnemonic correspondence.

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

Record documentation checks, mathematical checks, IR legality, target compilation, instruction/register inspection, simulator execution, device execution, and performance independently. Inspection checks the declared sequence family, operand roles, grouping, overlap, clobbers, and spill/staging conditions. Exact physical register numbers are checked only where required by the target contract. Each result identifies versions, configuration, inputs, method, outcome, and limitations.

## Revision policy

A changed upstream contract or target dependency requires impact analysis and a new profile revision where applicable. Preserve previous sources and evidence. Revalidate affected register, operand, numerical, state, and ABI rules.

Contributions follow [CONTRIBUTING.md](../CONTRIBUTING.md).
