# Contributing to RVISA

Contributions include specification corrections, architectural proposals, target mappings, compiler representation, examples, and conformance work. Discuss changes in terms of observable behavior and their effect on implementers.

## Preparing a change

Identify the affected chapter, operation, or profile. State the problem, the intended result, and any compatibility consequences. Keep unrelated editorial and semantic changes separate.

Editorial corrections can be reviewed directly. Changes to semantics, public interfaces, target contracts, or compatibility require a proposal following the [RFC process](rfcs/README.md).

A semantic proposal should address:

- Types, operands, results, and evaluation stages.
- Coordinate, memory, numerical, and state behavior.
- Invalid cases and required diagnostics.
- IR and target mapping implications.
- Independent verification and migration where applicable.

## Writing specification text

Follow the [specification conventions](spec/conventions.md). Define behavior directly, with precise conditions and units. Separate requirements from rationale, examples, optimization advice, and unresolved proposals.

Keep one primary definition for each rule. Cross-reference that definition from IR descriptions, mappings, examples, and verification cases. Use stable rule identifiers where a requirement is referenced across components.

Examples must identify their assumptions and numerical policy. A target-specific optimization must state the profile conditions on which it depends. Imported material requires attribution and an applicable license.

## Review

Reviewers examine semantic correctness, implementability, consistency, compatibility, and evidence. Architectural elegance alone does not establish a valid lowering; a successful build alone does not establish conformance.

Editorial changes are reviewed by an affected-area maintainer. Core semantics, public interfaces, and stable mappings should receive independent review from at least two qualified maintainers from different organizations. The author does not approve their own change.

Record material objections, alternatives, and the resulting decision. For disagreement across areas, request review from the other affected maintainers and preserve the rationale in the proposal.

## Maintenance

[MAINTAINERS.yaml](MAINTAINERS.yaml) identifies maintenance areas, contributors, and organization affiliations. Assignments are recorded explicitly; area entries currently have no appointed maintainers.

Changes spanning the specification, dialect, mappings, and examples must account for each affected layer. An unimplemented component may be marked TBD; an existing contract must not be silently left inconsistent.

## Validation

Documentation review includes links, anchors, terminology, equations, examples, metadata, and consistency between the root READMEs. Check that every referenced artifact exists and that its status is accurate.

Semantic verification uses independent positive and negative cases. Record documentation checks, mathematical checks, IR checks, target compilation, execution, and performance separately, with versions and limitations.

Module-specific tests live with their implementation. Shared obligations are maintained in [conformance/](conformance/README.md); repository tooling is described in [tools/](tools/README.md). Tool and build commands are documented when an executable entry point is available.

## Compatibility and licensing

The [specification status](spec/status.md) identifies the current development state. Record substantive changes in [CHANGELOG.md](CHANGELOG.md); target profiles maintain their own revision histories and source dependencies.

Documentation and code use the [Apache License, Version 2.0](LICENSE), unless otherwise stated. Contributions intentionally submitted for inclusion follow Section 5 of that license. Preserve applicable third-party terms, attribution, and exceptions. New project-owned source headers use `SPDX-License-Identifier: Apache-2.0`.
