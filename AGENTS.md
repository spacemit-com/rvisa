# RVISA Documentation and Implementation Guidelines

## Project boundaries

Treat this repository as a specification project. Write for architecture reviewers, compiler implementers, kernel developers, and contributors. Project documentation describes the subject directly; workspace setup history and task progress belong outside the repository.

Read README.md, CONTRIBUTING.md, spec/conventions.md, and spec/status.md before substantive changes. Preserve the Apache-2.0 text in LICENSE and applicable third-party attribution.

## Structure

Keep chapters and module documents at their established paths. Keep the root README variants consistent in scope, status, and navigation.

Shared collaboration rules belong in CONTRIBUTING.md, with assignments in MAINTAINERS.yaml. Do not add ci/, releases/, LICENSES/, or a standalone GOVERNANCE.md under the current project organization.

## Specification quality

Define the observable behavior before describing an implementation. Distinguish logical values, operand roles, memory descriptors, axis layouts, physical representations, and instruction operands.

Maintain a single primary definition for each requirement. Preserve established semantics when reorganizing prose. Do not resolve a provisional contract by implication; identify the open decision and use the RFC process.

Separate normative requirements, informative explanations, examples, and target-specific recommendations. Cite fixed source versions for concrete target claims. RISC-V or RISE reference material does not establish project affiliation or ratification.

## Implementation status

MLIR remains TBD until explicitly implemented and verified. This revision excludes source-language frontend implementations; retain the Python and C++ reference workloads in demos/. Keep those status boundaries accurate without repeating setup narratives throughout the manual. Templates and empty profile registries are not supported targets.

Report structural checks, mathematical evidence, IR validation, compilation, execution, and performance independently. Do not invent tool commands, people, organizations, version numbers, or successful results.

## Workspace operations

Modify only the requested project scope; the existing sibling rvisa repository remains read-only. Git initialization, remote configuration, commits, and publication require a task requesting those operations.

Keep exploratory code, downloads, and logs in the enclosing workspace's temporary area. For documentation changes, verify local links and anchors, metadata syntax, terminology and status consistency, and preservation of unrelated files.
