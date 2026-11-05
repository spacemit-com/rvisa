# RVV Mappings

RVV mappings define vector instruction sequences and register-group representations for RVISA operations, including tiles carried in vector registers.

## Mapping requirements

A mapping preserves symbolic capacity, logical coordinates, explicit vector grouping, active extents, numerical order, and configuration scope. It identifies legal element-width/grouping combinations, operand overlap and mask constraints, and the resource requirements used during partitioning. Tile realizations apply the [register priority policy](../../spec/types/tile.md#register-representation), with documented conditions for fragment reuse and spills.

The [canonical linear tile carrier](../../spec/types/tile.md#canonical-linear-carrier) chooses the smallest legal covering group, or consecutive logical fragments when a value exceeds one group. Anchors may retile those fragments using [linear-layout relations](../../spec/core/linear-layout.md). Register-group legality is checked per instruction operand; aggregate capacity does not create an architectural m16.

Fragment tails must not contribute extra logical elements or valid stores. Internal vector configuration must preserve source-visible state when vector and tile operations are mixed.

A vector sequence is acceptable only when it satisfies the source contract and target capability requirements. Calling it a baseline path does not waive numerical or memory obligations.

Concrete RVV mappings are under development. They follow the [shared mapping contract](../contract.md).
