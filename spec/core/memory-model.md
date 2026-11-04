# Memory Model

Memory operations access storage through pointers or descriptors. Computation values and addressing metadata are distinct.

## Addressing and access

For a byte-addressable element type T, an affine descriptor uses:

```text
element_offset = offset + sum(index[d] * stride[d])
byte_address   = base + sizeof(T) * element_offset
```

Offsets and strides are measured in elements unless a contract specifies otherwise; alignment is measured in bytes. Sub-byte storage formats require an explicit packing contract and cannot use a fractional byte size in this equation.

The caller is responsible for truthful allocation information, permitted access, valid alignment, and address arithmetic that does not overflow. A bare pointer does not imply bounds or noalias.

## Bounds and active regions

Each memory operation defines its own bounds behavior. Scalar access requires a valid addressed element. Vector access follows its selected configuration and overload contract. Tile loads and stores use explicit multidimensional bounds, with load fill and write suppression defined by the operation.

A value selection cannot undo an earlier invalid access. A matrix contraction's effective K extent does not retroactively mask the loads that produced its inputs.

Fill values belong to the loaded logical value. They are not an implicit predicate on subsequent arithmetic or reduction.

## Aliasing and order

Absent an explicit noalias contract, different arguments may refer to overlapping storage. Transformations preserve read-after-write, write-after-read, and write-after-write dependencies across all operation families and calls.

Writable addresses within one parallel block write must not conflict unless the operation explicitly defines conflict resolution. Merely discarding a store's result does not remove its write effect.

## Transfers and visibility

A transfer-selection option permits a target path without changing the operation's values, bounds, or numerical behavior. An `allow_tma` permission does not require a transfer engine or guarantee overlap.

The compiler manages readiness, waits, temporary-storage lifetime, and reuse for internally scheduled transfers. Completion follows the [execution model](execution-model.md). Cross-program atomics, volatile/MMIO access, and host-stream synchronization need their own contracts and are not inferred from ordinary loads or stores.

See [memory types](../types/memory.md) and [memory operations](../operations/memory/README.md).
