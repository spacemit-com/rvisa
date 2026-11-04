# RVV Mappings

RVV mappings provide vector representations and decomposition paths for RVISA operations, including logical tiles that are not held in dedicated matrix registers.

## Mapping requirements

A mapping preserves symbolic capacity, logical coordinates, explicit vector grouping, active extents, numerical order, and configuration scope. It identifies legal element-width/grouping combinations and the resource constraints used during partitioning.

Fragment tails must not contribute extra logical elements or valid stores. Internal vector configuration must preserve source-visible state when vector and tile operations are mixed.

A vector sequence is acceptable only when it satisfies the source contract and target capability requirements. Calling it a baseline path does not waive numerical or memory obligations.

Concrete RVV mappings are under development. They follow the [shared mapping contract](../contract.md).
