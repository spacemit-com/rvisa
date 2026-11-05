# Register and State Model

## Register classes and groups

Inventory each architectural register class used by the profile. Distinguish computation operands, accumulators, predicates, configuration state, and memory staging resources.

| Property | Required description |
| --- | --- |
| Identity and role | Architectural class/domain, supported operand roles, and source revision |
| Capacity | Register width or geometry parameters, element interpretation, and supported types |
| Group constraints | Register count relationships, alignment, contiguity, and valid grouping combinations |
| Operand constraints | Overlap, aliases, operand ties, destructive updates, and any required fixed registers |
| Access | Instructions that produce, consume, or transfer values in the class |

Class/group constraints define legal allocations. State which concrete register choices are left to the implementation and which are fixed by the architecture. An example allocation is identified as an example rather than an additional profile requirement.

## Coordinate representation

Give the [linear-layout](../../../spec/core/linear-layout.md) basis/domain description and the mapping from a logical element to its fragment, register class/group, element slot, or accumulator coordinate. State coverage, replication, active extents, and physical padding. Distinguish logical groups from architectural register groups and from the registers simultaneously live in one generated sequence.

Tile mappings follow [RVISA-TILE-REG-1](../../../spec/types/tile.md#register-representation). Explain the selected register representation and fragment geometry for each supported type/shape domain.

Distinguish canonical linear grouping from anchor-selected fragment grouping. Record minimum legal covering LMUL, decomposition above the maximum group size, dtype-dependent accumulator capacity, and symbolic VLEN conditions. Shape-only views preserve element locations; physical retile steps require a conversion or proven boundary folding.

## Resource and temporary-storage policy

Specify simultaneous register demand, reuse across fragments, and the conditions under which spills or memory staging are permitted or required. Record temporary footprint, alignment, ownership, lifetime, numerical preservation, and transfer instructions. Identify the diagnostic or permitted decomposition when no legal realization exists.

## State and transfers

Identify configuration dependencies, implicit operands, clobbers, calls, context-management assumptions, and transfers between classes or domains. State when values become available and when registers or temporary storage may be reused.

Operation-specific use is defined in [operand mappings](operands.md) and [lowering rules](lowering.md). Every architectural or implementation parameter references its [source](sources.md).
