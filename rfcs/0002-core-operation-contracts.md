# RFC 0002: Core Types and Operation Contracts

## Metadata

| Field | Value |
| --- | --- |
| Status | draft |
| Specification | 0.2.0 working draft; see [VERSION](../VERSION) |
| Design source | [Fixed v0.1-draft baseline](../spec/design-baseline.md) |
| Authors | Not yet recorded |
| Reviewers | Not yet assigned |
| Affected areas | Core models, types, operands, operations, mappings, demos, conformance |
| Related proposal | [RFC 0001](0001-instruction-and-register-mapping-contracts.md) |

## Summary and motivation

Make the core vector/tile designs reviewable as concrete virtual operation contracts in the current manual. Family-level descriptions alone do not determine capacities, matrix axes, grouped pairing, scale placement, memory tails, or required diagnostics.

The proposal adopts the fixed baseline's key definitions and keeps unresolved contracts visible. MLIR representation remains TBD; frontend implementations and executable workload migration are outside this proposal.

## Design

| Area | Proposed primary text |
| --- | --- |
| Types | [Vector modes](../spec/types/vector.md), [tile interoperation](../spec/types/tile.md), [element vocabulary](../spec/types/element-types.md) |
| Operand normalization | [Stages/defaults](../spec/operands/stages.md), [constraints](../spec/operands/constraints.md) |
| Configuration and views | [vconfig](../spec/operations/control/vconfig.md), [vshape](../spec/operations/vector/vshape.md), [vcast](../spec/operations/vector/vcast.md) |
| Matrix computation | [vmadot](../spec/operations/vector/vmadot.md), [tmma](../spec/operations/matrix/tmma.md), [tmma_scaled](../spec/operations/matrix/tmma-scaled.md) |
| Memory and movement | [Vector memory](../spec/operations/memory/vector-memory.md), [tile memory](../spec/operations/memory/tile-memory.md), [transfers](../spec/core/transfers.md), [im2col](../spec/operations/memory/im2col.md) |

The design preserves explicit vector mode constraints, symbolic capacities, unique data-shape inference, complete tile flattening, separate batch and numerical policies, one-time accumulator initialization, and operation-specific memory effects. Tile register representation and profile sequence/register guarantees retain their existing primary definitions.

## Open decisions

[Specification Status](../spec/status.md#open-contracts) is the maintained inventory. In particular, the proposal does not guess dynamic vconfig return behavior, grouped packing coordinates, extended-store addresses, tile reduction results, ordinary operation numerical details, or packed FP4 ABI.

Block scaling retains explicit f32 rounding of the separately scaled inputs. The applicable accumulation rounding and format-special-value contract must be stated when numerical conformance is claimed.

## Cross-layer and compatibility impact

MLIR must retain the resolved roles, shapes, modes, numerical policies, effects, and implicit configuration dependencies. The proposal does not assign dialect encodings or add implementations.

Profiles map the operation's supported domain to instruction sequences, register classes/groups, packing, state, and resource policies. Legacy target names or example layouts do not register a supported profile.

Paired Python/C++ demos expand defaults to the same semantic operands. Existing workload documents link the adopted primary definitions; executable sources remain separately tracked.

The current draft version is preserved. This adoption is not a released 0.1.0-to-0.2.0 ABI compatibility guarantee. Any later resolution of a provisional contract requires explicit review and affected-layer updates.

## Alternatives

| Approach | Trade-off |
| --- | --- |
| Copy the earlier manual and source-language scaffolding wholesale | Duplicates primary definitions and reintroduces implementation scope excluded from this revision |
| Keep only operation-family summaries | Leaves implementers unable to distinguish critical pairing, shape, tail, and state behavior |
| Adopt concrete semantic contracts within the current organization | Makes architectural review possible while retaining explicit unresolved boundaries |

## Validation

[Core design cases](../conformance/cases/core-designs.md) supply exact coordinate/value examples, invalid combinations, numerical-order distinctions, and mapping inspection obligations. Mathematical expectations must be checked independently of a future implementation.

Documentation and formula checks do not establish MLIR verification, frontend compilation, architectural lowering, device execution, asynchronous overlap, or performance. A target claim requires the corresponding profile and evidence.

## Decision record

Draft text is present for review. Author attribution, reviewers, and architectural approval have not yet been recorded. Acceptance and implementation evidence remain separate under [CONTRIBUTING.md](../CONTRIBUTING.md).
