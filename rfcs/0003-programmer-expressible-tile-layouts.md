# RFC 0003: Programmer-Expressible Tile Layouts

## Metadata

| Field | Value |
| --- | --- |
| Status | draft |
| Specification | 0.2.0 working draft; see [VERSION](../VERSION) |
| Authors | Not yet recorded |
| Reviewers | Not yet assigned |
| Affected areas | Core layout, tile types/operations, matrix operations, mappings, MLIR design, demos, conformance |
| Related proposals | [RFC 0001](0001-instruction-and-register-mapping-contracts.md), [RFC 0002](0002-core-operation-contracts.md) |

## Problem and proposed result

Tile types and numerical equations do not by themselves give programmers access to the layout decisions made during legalization. A compiler-only blocked representation also obscures whether a reshape caused movement, which matrix axes were reduced, and whether a load/store rewrite preserved memory semantics.

Require every tile-level optimization to have an equivalent public RVISA expression. Represent rank-1 through rank-N tiles through a common carrier model, derive layouts algebraically, and make anchor constraints and region boundaries explicit.

## Design

| Primary definition | Scope |
| --- | --- |
| [Tile types](../spec/types/tile.md) | Rank, logical bytes, canonical linear grouping, and legal oversized fragments |
| [Linear layouts](../spec/core/linear-layout.md) | Basis maps, coordinate composition, validity domains, conversion, and address composition |
| [Tile optimization](../spec/core/tile-optimization.md) | Programmer expressibility, anchors, closed regions, and boundary folding |
| [Layout operations](../spec/operations/tile/layout-operations.md) | Location-preserving shape/permutation and explicit representation conversion |
| [Extraction, insertion, and selection](../spec/operations/tile/selection.md) | textract for row/column subvalues, tinsert for immutable assembly, and tselect for Boolean value choice |
| [Axis-bound MMA](../spec/operations/matrix/blocked-mma.md) | Factored M/N/K binding, the 32x32 example, and a manual loop equivalent |

The default linear carrier chooses a legal minimum covering group or a sequence of legal fragments. Aggregate capacity above m8 does not create an RVV instruction operand. Anchors may choose other layouts for auto values; programmer-specified layouts remain constraints.

The 32x32 example uses [4,8,4,8] and [4,4,8,8] coordinate views. Its physical input representation changes from two f16m8 groups to sixteen f16m1 fragments at VLEN=1024 bits, only through a derived conversion or boundary rewrite. The f32 accumulator instead uses m2 per 8x8 fragment.

The explicit axes form extends tmma without reinterpreting the existing rank-3 batch modes. K factors define a lexicographic flattened contraction order. textract/tinsert provide an independent public expansion using the original rank-2 tmma. tselect retains its separate Boolean elementwise role.

## Alternatives

| Approach | Assessment |
| --- | --- |
| Make every multidimensional reshape imply a new contiguous layout | Conflates coordinates with physical movement and hides conversions from the programmer |
| Keep tile packing and blocked MMA entirely in private backend IR | Cannot satisfy programmer expressibility or expose complete mapping evidence |
| Preserve views and use explicit layouts, factor axes, and anchor-derived conversions | Gives the programmer and compiler the same tile-level vocabulary |
| Express blocking only through fragment loops | Remains a valid explicit expansion; axis binding additionally records the contraction as one reviewable operation |

## Compatibility and cross-layer effects

This proposal strengthens the earlier view wording: reshape/permutation themselves preserve locations. Movement belongs to a conversion or an anchor realization. Existing numerical, memory, alias, state, and temporary-lifetime rules remain binding.

The compact tmma interface retains its defaults and rank/batch behavior. The new axes form is explicit and does not infer batch roles from shape. Its extension to scaled-MMA factor axes remains a separate design decision.

MLIR must preserve maps, explicit constraints, axis binding, and region boundaries, and must be able to reconstruct the public tile expression. Concrete dialect encodings and frontend implementations remain outside this revision.

Profiles record basis/domain descriptions, actual instruction operand groups, numerical legality, and resource scheduling. Template completion does not register a target. The 8x8x8 geometry does not establish support by a named matrix extension.

## Validation

[Layout cases](../conformance/cases/linear-layout.md) cover capacity, exact view identity, basis/inverse maps, row/column selection, immutable assembly, explicit/inferred contraction equivalence, K tails, aliasing, and conflicting users.

Coordinate and finite-value checks are independent of target execution. Native lowering additionally requires instruction/register, configuration, memory, and numerical evidence. No asynchronous overlap or performance result follows from a layout proof.

## Open implementation details

Concrete source-language spelling, dialect encoding, optimization cost models, target-specific anchor capabilities, and executable reconstruction tools remain implementation work. Non-power-of-two and scalable domains require exact predicates/views and legal profile instantiation; they cannot be guessed from a power-of-two example.

## Decision record

This proposal records draft requirements and review scope. Cross-organization reviewers and acceptance have not been recorded. Implementation support remains separate under [CONTRIBUTING.md](../CONTRIBUTING.md).
