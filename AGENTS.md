# RVISA Documentation and Implementation Guidelines

## Project boundaries

Treat this repository as a virtual instruction specification project rooted in RISC-V matrix extensions and RVV. Write for architecture reviewers, compiler implementers, kernel developers, and contributors. Project documentation describes the subject directly; workspace setup history and task progress belong outside the repository.

Read README.md, CONTRIBUTING.md, spec/conventions.md, and spec/status.md before substantive changes. Preserve the Apache-2.0 text in LICENSE and applicable third-party attribution.

## Structure

Keep chapters and module documents at their established paths. Keep the root README variants consistent in scope, status, and navigation.

Shared collaboration rules belong in CONTRIBUTING.md, with assignments in MAINTAINERS.yaml. Do not add ci/, releases/, LICENSES/, or a standalone GOVERNANCE.md under the current project organization.

## Architectural position

Describe typed operations, operand roles, and constraints on register groups using notation modeled on RVV Intrinsics. Use PTX/cuTile comparisons as design positioning, with positive definitions of RVISA's own instruction and register contracts.

Keep [tile register priority](spec/types/tile.md#register-representation) and [profile mapping guarantees](mappings/contract.md#mapping-guarantees) as the primary definitions. Distinguish logical values, register classes/groups, and concrete allocation. A profile may permit multiple instruction sequences and allocations; any required fixed registers, spills, or staging policies remain explicit. Do not imply that a virtual operation always maps to one machine instruction or that all tile elements are simultaneously resident.

Tile-level compiler optimizations must have equivalent public RVISA expressions under [RVISA-TILE-EXPR-1](spec/core/tile-optimization.md#expressibility-requirement). Keep shape/permutation views location-preserving, derive conversions through linear layouts, and distinguish canonical grouping from anchor-selected layouts. Region rewriting preserves every relevant boundary, memory dependency, and numerical order.

Use textract for axis-based subvalue extraction, tinsert for immutable subvalue replacement, and tselect for Boolean elementwise selection. Keep these roles distinct in the operation reference, examples, IR descriptions, and mappings.

## Specification quality

Define the observable behavior before describing an implementation. Distinguish logical values, operand roles, memory descriptors, axis layouts, physical representations, and instruction operands.

Maintain a single primary definition for each requirement. Preserve established semantics when reorganizing prose. Do not resolve a provisional contract by implication; identify the open decision and use the RFC process.

Separate normative requirements, informative explanations, examples, and target-specific recommendations. Cite fixed source versions for concrete target claims. RISC-V or RISE reference material does not establish project affiliation or ratification.

## Implementation status

MLIR remains TBD until explicitly implemented and verified. This revision excludes source-language frontend implementations; retain the Python and C++ reference workloads in demos/. Keep those status boundaries accurate without repeating setup narratives throughout the manual. Templates and empty profile registries are not supported targets.

Report structural checks, mathematical evidence, IR validation, compilation, instruction/register inspection, execution, and performance independently. Do not invent tool commands, people, organizations, version numbers, or successful results.

## Workspace operations

Modify only the requested project scope; the existing sibling rvisa repository remains read-only. Git initialization, remote configuration, commits, and publication require a task requesting those operations.

Keep exploratory code, downloads, and logs in the enclosing workspace's temporary area. For documentation changes, verify local links and anchors, metadata syntax, terminology and status consistency, and preservation of unrelated files.
