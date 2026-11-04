# Memory Types and Descriptors

A memory reference describes where an operation may access storage. It is distinct from the computation value obtained by a load.

## Descriptors

A ranked descriptor carries, as applicable:

| Field | Meaning |
| --- | --- |
| Base | Storage address |
| Element offset | Offset from the base in element units |
| Sizes and strides | Logical bounds and affine addressing increments |
| Allocation extent | Information used to establish the accessible allocation |
| Access | Read, write, or read/write permission |
| Address space | Storage-domain classification |
| Alignment | Guaranteed byte alignment |

Address calculation and caller obligations follow the [memory model](../core/memory-model.md). Constructing a descriptor does not prove that the underlying allocation exists or that its bounds are truthful.

## Validity

The initial affine descriptor model uses nonnegative sizes and strides. Additional addressing forms require explicit contracts.

An output-intent annotation alone does not imply write-only access. Distinct descriptors may alias unless a stronger condition is declared.

Packed low-precision formats require a storage and addressing definition independent of ordinary byte-sized element arithmetic. Source-language pointer and descriptor spellings belong to the [frontends](../../frontends/README.md).
