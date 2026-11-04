# Memory Types and Descriptors

A memory reference describes where an operation may access storage. It is distinct from the computation value obtained by a load. Loaded tile values follow the [tile register representation policy](tile.md#register-representation); constructing a descriptor does not load or allocate those values.

## Descriptors

A ranked descriptor carries, as applicable:

| Field | Meaning |
| --- | --- |
| Base | Storage address |
| Element offset | Offset from the base in element units |
| Sizes and strides | Logical bounds and affine addressing increments |
| Allocation extent | Accessible allocation extent in bytes |
| Access | Read, write, or read/write permission |
| Address space | Storage-domain classification |
| Alignment | Guaranteed byte alignment |

Address calculation and caller obligations follow the [memory model](../core/memory-model.md). Constructing a descriptor does not prove that the underlying allocation exists or that its bounds are truthful.

## Validity

The initial affine descriptor model uses nonnegative sizes and strides. Rank is compile-time structure; sizes and strides may be runtime values and must contain exactly one entry per axis. Zero sizes are valid empty access bounds. Read, write, and read/write access are distinct permissions. A generic address space does not by itself identify on-chip scratch storage. Additional addressing forms require explicit contracts.

An output-intent annotation alone does not imply write-only access. Distinct descriptors may alias unless a stronger condition is declared.

[tview](../operations/memory/tile-memory.md#tview) constructs a descriptor; tile load/store operations consume it with independently specified origins and shapes.

Packed low-precision formats require a storage and addressing definition independent of ordinary byte-sized element arithmetic. Source-language pointer and descriptor spellings do not alter these descriptor semantics.
