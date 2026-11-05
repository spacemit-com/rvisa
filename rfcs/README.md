# Design Proposals

RFCs record material changes to RVISA semantics, public interfaces, target contracts, and compatibility policy. Their purpose is to preserve the problem, alternatives, review evidence, and decision.

## Proposal lifecycle

Use a unique sequential identifier and descriptive filename, such as `0001-topic.md`, with the [proposal format](template.md). Proposed states are draft, in-review, accepted, rejected, withdrawn, and superseded.

Acceptance records a design decision. Implementation and verification are tracked separately. Superseded proposals retain references to their replacements.

## Review scope

A proposal identifies effects on core rules, types/operands, MLIR, mappings, demos, and conformance. It states which components are unaffected or still TBD and explains compatibility consequences.

Editorial corrections need not create an RFC. Follow [CONTRIBUTING.md](../CONTRIBUTING.md) for review requirements.

## Proposal index

| RFC | Status | Subject |
| --- | --- | --- |
| [0001](0001-instruction-and-register-mapping-contracts.md) | draft | Virtual instruction positioning, tile register priority, and versioned mapping guarantees |
| [0002](0002-core-operation-contracts.md) | draft | Core vector/tile types, concrete operations, memory/transfer rules, and retained provisional boundaries |
| [0003](0003-programmer-expressible-tile-layouts.md) | draft | Programmer-expressible tile optimizations, linear layouts, anchors, and factored MMA |

A draft proposal records design and review scope; its presence does not establish completed approval or implementation evidence.
