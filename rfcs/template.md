# RFC: Proposal Title

This is the format for a design proposal. Assign an identifier and actual authors/reviewers when opening an RFC.

## Metadata

Record the RFC identifier, status, authors, reviewers, affected maintenance areas, specification/profile versions, and links to related or superseded proposals.

## Summary

State the problem, proposed result, scope, and non-goals.

## Motivation

Describe the concrete use case and current behavior. Reference relevant requirements and explain why existing mechanisms are insufficient.

## Design

Define the affected virtual operations, types, operands, instruction sequence families, register classes/groups, effects, numerical/memory behavior, diagnostics, and interfaces. Identify tile representation policy and allocation constraints where relevant. Separate specified behavior from implementation choices and unresolved questions.

## Cross-layer impact

Describe implications for MLIR, each affected target profile, examples, conformance, and compatibility. Identify version or ABI consequences.

## Alternatives

Explain the considered approaches and their technical trade-offs.

## Validation and migration

Identify independent positive/negative evidence, required verification layers, migration steps, and limitations. Separate planned evidence from obtained results, including numerical checks and inspection of emitted instruction/register constraints.

## Decision record

Preserve material review comments, objections, rationale, disposition, and links to subsequent specification or implementation changes.
