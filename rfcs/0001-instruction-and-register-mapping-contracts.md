# RFC 0001: Instruction and Register Mapping Contracts

## Metadata

| Field | Value |
| --- | --- |
| Status | draft |
| Specification baseline | 0.2.0 working draft; see [VERSION](../VERSION) |
| Authors | Not yet recorded |
| Reviewers | Not yet assigned |
| Affected areas | Specification, target mappings, MLIR design, demos, and conformance |

## Summary

Describe RVISA as a virtual instruction specification rooted in RISC-V matrix extensions and RVV. Its notation expresses typed operations, operand roles, and grouping constraints. Target profiles connect those operations to legal instruction sequences and register classes/groups.

The primary proposed requirements are [RVISA-TILE-REG-1](../spec/types/tile.md#register-representation), which prioritizes register representations for tiles, and [RVISA-MAP-1](../mappings/contract.md#mapping-guarantees), which defines profile-specific mapping guarantees.

## Motivation

Logical shapes and numerical equations describe what a computation means. Architecture and compiler implementers also need to know which instructions and register resources may realize it, under which operand, configuration, and numerical constraints.

An unqualified promise of a stable mapping leaves instruction multiplicity, register classes, grouping, and allocator choices ambiguous. Similarly, a logical tile shape alone does not identify its carrier, fragment geometry, or simultaneous resource requirements.

## Design

### Position and notation

Use [RVV Intrinsics](https://github.com/riscv-non-isa/riscv-rvv-intrinsic-doc/blob/main/doc/rvv-intrinsic-spec.adoc) as a reference for typed instruction notation and visible operand/grouping constraints. [NVIDIA PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/) and [NVIDIA cuTile](https://docs.nvidia.com/cuda/cutile-python/) provide reference points for the intended abstraction level, slightly above PTX and below cuTile. RVISA's own operation and mapping contracts provide the technical definition.

### Tile representations

Apply the tile register policy to the classes available in the selected profile. A tile can occupy several registers or execute as fragments. Register reuse, spills, or staging follow explicit resource and transfer policies while preserving coordinates, numerical behavior, bounds, and lifetime.

Logical value identity remains independent of concrete physical register numbers. Class/group constraints and any architecture-required fixed registers remain binding.

### Mapping guarantees

Identify each profile and revision, supported operand domain, legal instruction sequence families, and operand/register constraints. Permit multiple legal realizations and declared decompositions. An empty sequence is possible only under explicitly satisfied semantic and representation conditions.

Mapping stability concerns preservation of that declared contract within a revision. It is separate from the maturity state `stable`, which requires the review and evidence defined by the mapping contract.

## Cross-layer impact

- Core models and types connect logical values to register representation requirements while preserving existing coordinate and numerical rules.
- Operation entries and profile documents identify instructions, register classes/groups, operand correspondence, allocation constraints, and state effects.
- MLIR design preserves those constraints through transformations and target conversion without equating every SSA value with a fixed physical register.
- Python/C++ demos retain paired semantic contracts and record target realization details when a concrete profile is used.
- Conformance distinguishes mathematical/numerical results, target compilation, instruction/register inspection, execution, and performance evidence.

## Alternatives

| Approach | Assessment |
| --- | --- |
| Require one virtual operation per machine instruction and fixed physical registers | Prevents necessary decompositions, register reuse, and variation in target geometry |
| Specify logical results without instruction/register correspondence | Leaves the architecture-facing contract incomplete and makes resource constraints difficult to review |
| Define profile-scoped sequence and register constraints | Retains explicit hardware correspondence while allowing documented implementation choices |

## Validation and compatibility

Validation obligations include positive and negative cases for instruction selection, type/shape domains, register grouping/alignment, overlap, accumulator roles, fixed-register restrictions, and resource boundaries. Cases exercise permitted fragmentation, spills/staging, numerical order, bounds, configuration transitions, and rejected mappings.

Inspect generated instructions and register constraints against the profile and fixed architectural sources. Use independent numerical expectations for results; neither evidence layer substitutes for the other. Exact physical register numbers and instruction counts are checked only when the contract requires them.

The proposal preserves operation signatures, vector modes, mathematical definitions, numerical defaults, and logical coordinate rules. It makes register selection and mapping evidence obligations explicit. Changes to a concrete profile's guarantees require revision and compatibility analysis. Concrete profiles and executable validation retain their declared development status.

## Decision record

This proposal is a draft. Author attribution, reviewers, and architectural approval have not yet been recorded. No compiler, device, or performance result is claimed by this document. Working-draft requirements remain subject to review under [CONTRIBUTING.md](../CONTRIBUTING.md).
