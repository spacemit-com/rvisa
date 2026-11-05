# Operand Evaluation Stages

RVISA distinguishes values available during program execution from information required to define or specialize the computation.

| Stage | Examples |
| --- | --- |
| Compile time / specialization | Types, required static shape structure, matrix layout/mode enums, transfer-selection options |
| Runtime | Data values, addresses, indices, access bounds, supported active extents |
| Inference | Type, capacity, or shape information uniquely determined by surrounding constraints |

A symbolic capacity may be represented and reasoned about at compile time while its numerical value depends on the runtime target. Symbolic does not mean unconstrained.

A runtime value cannot select an operation variant that requires a compile-time enum or alter a statically required result rank. Conversely, source-language evaluation must not replace a runtime computation simply because an implementation observed a constant.

Default arguments are expanded before comparing equivalent source forms. The MLIR design determines which resolved information is represented as an operand, type, attribute, or property; those encodings do not redefine the virtual operation's staging rules. Target immediate fields and configuration operands add legality conditions recorded in the profile; they do not turn an arbitrary runtime value into a compile-time constant.

## Concrete operand stages

| Operation information | Stage | Governing definition |
| --- | --- | --- |
| Element types, LMUL, shape/rank structure | Compile time or resolved symbolic constraints | [Types](../types/README.md), [vconfig](../operations/control/vconfig.md) |
| Matrix A/B/C layouts, batch mode, reduction order | Compile-time enums in their respective domains | [tmma](../operations/matrix/tmma.md#operands-and-defaults) |
| Matrix factor-axis bindings and explicit carrier layouts | Compile-time metadata with provable symbolic constraints | [Axis-bound tmma](../operations/matrix/blocked-mma.md), [linear layouts](../core/linear-layout.md) |
| Extraction axis / extraction index | Static axis / runtime index where supported | [textract and tinsert](../operations/tile/selection.md) |
| Matrix/scale elements and accumulator | Runtime data | [tmma_scaled](../operations/matrix/tmma-scaled.md) |
| valid_k | Runtime extent, default inferred from full K | [tmma](../operations/matrix/tmma.md#numerical-order-and-tails) |
| Pointer, origin, descriptor sizes/strides | Runtime values with static rank and units | [Tile memory](../operations/memory/tile-memory.md) |
| Transfer permission and representation choice | Compile-time options | [Transfers](../core/transfers.md#transfer-selection) |
| Kernel/stride/dilation/padding for im2col | Compile-time geometry | [im2col](../operations/memory/im2col.md#synopsis) |
| Scale block length | Inferred from full data/scale shapes | [Scale inference](../operations/matrix/tmma-scaled.md#scale-axes-and-block-inference) |

## Reference-notation normalization

A source spelling may encode static information in keywords, templates, or option tags. Operand position and enum domain remain part of the virtual contract: vmadot is accumulator-first; tmma is input/input/accumulator; tmma_scaled pairs each input with its scale before the accumulator.

The [vector-memory definition](../operations/memory/vector-memory.md#signatures-and-operands) records the source-default difference between Python's f16 load and C++ pointer-derived dtype. Equivalent demos must make their resolved types agree. Source default expansion cannot repair an invalid typed-memory access.

See [execution](../core/execution-model.md) and [MLIR](../../mlir/docs/README.md).
