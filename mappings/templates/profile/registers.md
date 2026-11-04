# Register and State Model

## Register domains

For each domain, define architectural identifiers, capacity parameters, element interpretation, grouping, alignment, accessibility, and aliasing. Distinguish operand storage, accumulators, configuration, and temporary staging resources.

## Coordinate representation

Give the mapping from a logical element to its group, register, lane, or accumulator coordinate. State coverage, replication, active extents, and physical padding.

Separate physical capacity from active shape and simultaneous residency. Explain spills and temporary-storage lifetime where they affect legality.

## State and transfers

Identify configuration dependencies, implicit operands, clobbers, calls, context-management assumptions, and transfers between domains. State when values become available and when storage may be reused.

Operation-specific use is defined in [operand mappings](operands.md) and [lowering rules](lowering.md). Every architectural or implementation parameter references its [source](sources.md).
