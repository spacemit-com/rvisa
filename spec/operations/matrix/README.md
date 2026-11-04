# Matrix Operations

Matrix operations combine logical contraction, batch pairing, accumulation, and numerical policy. The selected profile defines legal instruction sequences and the register classes/groups for data inputs and accumulators after these relationships are established.

## Multiply-accumulate

The working `tmma(a, b, acc)` model uses independent A/B/C axis-layout choices. Its default exposed operands are `A[M,K]`, `B[N,K]`, and `C[M,N]`, corresponding to:

```text
D[m,n] = C[m,n] + sum_k A[m,k] * B[n,k]
```

This is a mathematical relation. The numerical contract additionally determines the sequence and precision of the accumulation. The accumulator is supplied explicitly and initialized once for each output.

Matrix-axis interpretation, memory strides, and physical representation layout remain distinct.

## Batch relationships

For inputs with explicit batch dimensions:

| Mode | Pairing | Output batch structure |
| --- | --- | --- |
| cross | Every A batch with every B batch | Both input batch axes |
| reduce | Equal-index input batches accumulated together | Batch axis reduced |
| broadcast | Matched batches, with a singleton side reused | One output batch axis |

The default mode is reduce. It must not be implemented by summing all cross-mode pairings. Explicit batch axes are not silently removed.

## Numerical order and active K

The default `ordered` policy preserves the defined accumulation sequence: increasing K for cross/broadcast, and increasing paired batch followed by K for reduce. A `tree` policy permits only the reassociation allowed by the numerical contract.

`valid_k` satisfies `0 <= valid_k <= K` and restricts contributions within the defined contraction extent. At zero it preserves the normalized accumulator, while shape and type validity still apply. It does not suppress prior memory accesses.

## Block scaling

`tmma_scaled(a, a_scale, b, b_scale, acc)` adds scale operands associated with blocks along K. Its definition must specify scale axes, format decoding, block size, application order, intermediate rounding, and partial-block behavior.

Target support for FP8 or another payload type does not establish support for this scaled operation. A native path must satisfy both data and scale semantics.

## Instruction and register correspondence

A profile maps A, B, and accumulator/result roles independently, recording coordinate packing, register classes/groups, alignment, overlap, and any destructive updates. Tile shapes may span several architectural instruction shapes; the sequence preserves the specified batch pairing, initialization, active K, and numerical order.

Fragmentation, accumulator reuse, register-domain transfers, and any spills or staging follow the [mapping contract](../../../mappings/contract.md). Instruction/register inspection and numerical execution provide separate evidence for that mapping.

See [numerics](../../core/numeric-model.md), [operand roles](../../operands/roles.md), and [target mappings](../../../mappings/README.md).
