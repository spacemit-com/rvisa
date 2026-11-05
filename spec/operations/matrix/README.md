# Matrix Operations

Matrix operations combine logical contraction, batch pairing, accumulation, and numerical policy. The selected profile defines legal instruction sequences and the register classes/groups for data inputs and accumulators after those relationships are established.

| Operation | Primary definition |
| --- | --- |
| [tmma](tmma.md) | Matrix axes, rank-2/rank-3 inputs, cross/reduce/broadcast pairing, accumulator initialization, numerical order, and active K |
| [Axis-bound tmma](blocked-mma.md) | Explicit M/N/K factors, 32x32 blocking, linear-layout derivation, and a manual fragment-loop equivalent |
| [tmma_scaled](tmma-scaled.md) | Per-input K-block scales, scale axes, decoding and f32 scaling, partial blocks, and format capabilities |
| [vmadot](../vector/vmadot.md) | Related vector-domain primitive with Cartesian group pairing and an accumulator-first signature |

The default tmma interpretation exposes A[M,K], B[N,K], and C[M,N]. Matrix-axis interpretation, memory strides, and physical representation layout remain distinct. Batch mode chooses contributing pairs; reduce_order constrains their numerical accumulation.

## Instruction and register correspondence

A profile maps A, B, and accumulator/result roles independently, recording coordinate packing, register classes/groups, alignment, overlap, and any destructive updates. Tile shapes may span several architectural instruction shapes; the sequence preserves the specified batch pairing, initialization, active K, and numerical order.

Fragmentation, accumulator reuse, register-domain transfers, and any spills or staging follow the [mapping contract](../../../mappings/contract.md). Instruction/register inspection and numerical execution provide separate evidence for that mapping.

See [numerics](../../core/numeric-model.md), [operand roles](../../operands/roles.md), and [core design cases](../../../conformance/cases/core-designs.md).
