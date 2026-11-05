# Design Baseline and Traceability

This informative chapter records the provenance of core designs carried into the current working draft. The definitions in this manual are self-contained; implementation and conformance must use their stated revision and status.

## Source identity

| Property | Source |
| --- | --- |
| Project | [rvisa design repository](https://gitlab.dc.com:8443/ai/Arch/rvisa) |
| Revision | `24bdf942ea4b4d7bfc793b0e573e658c70870959` |
| Declared specification version | `v0.1-draft`, as recorded in its README and operation catalogue |
| Release identity | No 0.1.0 tag was present in the inspected checkout |
| Current specification | Working draft identified by [VERSION](../VERSION) |
| Proposal | [RFC 0002](../rfcs/0002-core-operation-contracts.md) |

Source status and current status are distinct. The earlier design supplies semantic definitions and reference notation; its examples do not establish an installed SDK, compiled implementation, or target execution result.

## Definition correspondence

| Source at the fixed revision | Primary definitions in this manual |
| --- | --- |
| [Data model](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/data-model.md), [core](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/core.md) | [Values/effects](core/value-model.md), [execution](core/execution-model.md), [memory](core/memory-model.md), [operand rules](operands/README.md) |
| [Vector types](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/vector-types.md) | [Four vector modes](types/vector.md), [vcast](operations/vector/vcast.md) |
| [Tile model](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/tile.md) | [Tile values and interoperation](types/tile.md), [vshape](operations/vector/vshape.md), [tile transformations](operations/tile/README.md) |
| [Vector operations](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/rvv.md) | [vconfig](operations/control/vconfig.md), [vector memory](operations/memory/vector-memory.md), [vmadot](operations/vector/vmadot.md), [vector vocabulary](operations/vector/README.md) |
| [tmma](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/tmma.md) | [Matrix axes, batch pairing, accumulator, order, and active K](operations/matrix/tmma.md) |
| [tmma_scaled](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/tmma-scaled.md) | [Block scaling](operations/matrix/tmma-scaled.md), [element vocabulary](types/element-types.md) |
| [Transfers](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/transfers.md) | [Transfer policy and lifetime](core/transfers.md), [tile memory](operations/memory/tile-memory.md) |
| [im2col](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/blob/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/im2col.md) | [Convolution-window access](operations/memory/im2col.md) |
| [Operation entries](https://gitlab.dc.com:8443/ai/Arch/rvisa/-/tree/24bdf942ea4b4d7bfc793b0e573e658c70870959/spec/operations) | [Scalar vocabulary](operations/scalar/README.md), [extended-store boundaries](operations/memory/extended-stores.md), per-operation constraints |

This correspondence records design provenance rather than a dependency on a sibling checkout. The prose is organized around the present specification's types, operands, effects, and operation entries. The [register priority](types/tile.md#register-representation) and [versioned mapping guarantees](../mappings/contract.md#mapping-guarantees) govern target realization.

## Subsequent layout design

[RFC 0003](../rfcs/0003-programmer-expressible-tile-layouts.md) refines the current draft with rank-1 through rank-N carrier rules, location-preserving views, explicit tile optimization, anchor regions, and factored matrix-axis binding. These additions are current RVISA design proposals; they are not attributed to the earlier source snapshot. The compact matrix form and existing numerical/memory obligations remain in force.

## Preserved boundaries

The adoption retains unresolved semantics as provisional: dynamic configuration returns, fractional-LMUL/mask notation, grouped carrier bridges and packing, extended stores, reduction/approximation details, low-precision storage/conversions, and ABI/runtime contracts. The complete inventory is maintained in [Specification Status](status.md).

Source-language decorators, compiler-specific function markers, runtime launch APIs, compatibility aliases, and frontend implementation scaffolding are not required by the adopted virtual operation definitions. Python/C++ examples may illustrate the same resolved operand roles and defaults under [Conventions](conventions.md).

Semantic acceptance requires the [core design cases](../conformance/cases/core-designs.md) and the review process. A source formula, illustrative example, or registered operation name alone does not establish a valid instruction/register mapping.
