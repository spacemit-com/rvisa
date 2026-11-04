# tmma — Tile Matrix Multiply-Accumulate

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-TMMA |
| Status | Working draft |
| Result | Tile with the accumulator element type and inferred output shape |
| Effects | Pure; target realization may use configuration and architectural state |

## Synopsis

`tmma` contracts the K axes of two input tiles and incorporates an explicit accumulator. Matrix-axis interpretation, batch pairing, and numerical order are independent choices.

~~~text
tmma(a: tile<TA,SA>, b: tile<TB,SB>, acc: tile<TC,SC>,
     ALayout = ALayout.rowmajor,
     BLayout = BLayout.colmajor,
     CLayout = CLayout.rowmajor,
     mode = TMmaMode.reduce,
     reduce_order = ReduceOrder.ordered,
     valid_k = K) -> tile<TC,SC>
~~~

The tile notation describes normalized operands. An explicit two-dimensional vector view or a scalar with a uniquely inferable complete shape can occupy a tile data position under the [interoperability rules](../../types/tile.md#relationship-to-vectors).

## Operands and defaults

| Operand | Role | Stage and constraint |
| --- | --- | --- |
| a, b | Input data | Runtime values; matrix geometry must be resolved |
| acc | Accumulator | Required runtime value; complete output shape and accumulation dtype |
| ALayout | A matrix-axis interpretation | Compile-time ALayout enum; rowmajor or colmajor |
| BLayout | B matrix-axis interpretation | Compile-time BLayout enum; rowmajor or colmajor |
| CLayout | Accumulator/result axis interpretation | Compile-time CLayout enum; rowmajor or colmajor |
| mode | Batch pairing | Compile-time TMmaMode enum; cross, reduce, or broadcast |
| reduce_order | Numerical order | Compile-time ReduceOrder enum; ordered or tree |
| valid_k | Active contraction extent | Runtime index in [0,K]; defaults to full K |

An enum from a different domain, an arbitrary integer/string, or a runtime mode is invalid. The accumulator is never implicitly loaded from output memory. A scalar zero is an explicit accumulator value, not an omitted operand.

The baseline input formats are f16 and bf16 with f32 accumulation and result. Supported input-format tuples and additional combinations require an explicit numerical and profile contract.

## Matrix-axis interpretation

**RVISA-TMMA-AXES-1.** Layout enums MUST interpret only the last two logical axes as follows. P denotes the appropriate batch prefix.

| Operand and layout | Exposed shape | Effective element |
| --- | --- | --- |
| A rowmajor | P+[M,K] | Aeff[...,m,k] = A[...,m,k] |
| A colmajor | P+[K,M] | Aeff[...,m,k] = A[...,k,m] |
| B rowmajor | P+[K,N] | Beff[...,n,k] = B[...,k,n] |
| B colmajor | P+[N,K] | Beff[...,n,k] = B[...,n,k] |
| C rowmajor | P+[M,N] | Ceff[...,m,n] = C[...,m,n] |
| C colmajor | P+[N,M] | Ceff[...,m,n] = C[...,n,m] |

The result uses CLayout in the same way as acc. Layout enums do not permute batch axes, transpose memory, or repair an incompatible operand shape. For example, contiguous rows of B[N,K] already match the default BLayout; a second transpose is not implied.

M, N, and K are positive logical extents. Symbolic views require the same relations to hold across the declared target range.

## Rank and batch inference

Normalized A and B must both have rank 2 or both have rank 3. Mixed ranks require an explicit reshape, such as [M,K] to [1,M,K]. Arbitrary additional input batch dimensions are not part of this contract.

With rank-2 A and B, every mode has an empty output batch prefix. With rank-3 inputs, the following rules apply before CLayout selects the last two axes:

| Mode | Input batch condition | Output batch prefix |
| --- | --- | --- |
| cross | Positive B0 and B1 | [B0,B1] |
| reduce | B0 = B1 = B | Empty |
| broadcast | B0 = B1, or B0 = 1, or B1 = 1 | [max(B0,B1)] |

Explicit singleton axes are retained in cross and broadcast output shapes. Thus rank-3 singleton inputs produce [1,1,M,N] in cross mode and [1,M,N] in broadcast mode under the default CLayout.

A tile accumulator must exactly match the complete output shape and dtype. A rank-2 accumulator does not implicitly broadcast over output batch axes; use an explicit broadcast. A scalar accumulator broadcasts only when the complete shape is uniquely determined.

Scalar A/B operands likewise require a unique complete input shape. For example, known B[B,N,K] and C[M,N] in reduce mode can constrain a scalar A. Broadcast mode may leave a missing input's batch ambiguous between 1 and B. Knowing only an all-scalar call's output M/N does not determine K.

## Value semantics

Let V = valid_k and use the effective coordinates above.

~~~text
rank 2:
D[m,n] = C[m,n] + sum(k=0..V-1, Aeff[m,k] * Beff[n,k])

cross:
D[p,q,m,n] = C[p,q,m,n]
            + sum(k=0..V-1, Aeff[p,m,k] * Beff[q,n,k])

reduce:
D[m,n] = C[m,n]
         + sum(b=0..B-1, sum(k=0..V-1, Aeff[b,m,k] * Beff[b,n,k]))

broadcast:
ai(b) = 0 if B0 == 1 else b
bi(b) = 0 if B1 == 1 else b
D[b,m,n] = C[b,m,n]
           + sum(k=0..V-1, Aeff[ai(b),m,k] * Beff[bi(b),n,k])
~~~

**RVISA-TMMA-PAIR-1.** An implementation MUST preserve the selected pairing and initialize each output from C exactly once. Paired-batch reduce is not the sum of all cross pairs, and it does not add C once per batch.

Scalar data normalization does not reduce the number of contributions. In reduce mode, scalar A/B still participate in B*V products per output.

## Numerical order and tails

**RVISA-TMMA-ORDER-1.** Under ordered, each output starts from its accumulator and performs widened FMA in increasing k order. For reduce with rank-3 inputs, the order is increasing b and then increasing k, with one continuous accumulation. Tree permits reassociation over those contributing terms within the declared accumulation precision; it does not change the batch pairing or authorize narrower intermediates.

The ordinary operation fixes widening, fusion, accumulation precision, and ordering. A complete numerical contract must additionally specify rounding and special-value behavior; unresolved details are tracked in [Specification Status](../../status.md). The word ordered alone does not settle them.

**RVISA-TMMA-K-1.** Only k < V contributes. At V=0 the result is the normalized accumulator, but types, layouts, ranks, batch conditions, and target capability checks still apply. V is shared by all input pairings.

V does not mask earlier loads. Zero-filled K tails are not automatically equivalent to omitted operations, including for signed zero, infinities, and NaNs.

## IR and target mappings

Preserve layout enums, complete batch structure, active K, the accumulator role, and numerical policy through IR construction and legalization. The profile records A/B/accumulator register classes and groups, element packing, overlap/ties, configuration, and legal instruction sequences.

The [vmadot](../vector/vmadot.md) cross-group relation may implement matching cross cases when layouts and numerics agree. Reduce and broadcast require their own pairing-preserving decomposition. A native matrix instruction is usable only when its accumulation behavior and active region satisfy the contract.

Tile fragmentation and vector-register realization follow [RVISA-TILE-REG-1](../../types/tile.md#register-representation); a target instruction's microtile geometry does not redefine M/N/K.

## Diagnostics and conformance

Diagnose K mismatch, unsupported input rank, unresolved scalar shape, invalid batch pairing, accumulator shape/dtype mismatch, invalid enum domain/stage, out-of-range V, and an unsupported numerical or resource contract.

[Core design cases](../../../conformance/cases/core-designs.md#matrix-pairing-and-accumulation) cover nonzero accumulators, all batch modes, singleton axes, CLayout, and zero/partial K. [GEMM](../../../demos/gemm/README.md) and [GEMM epilogues](../../../demos/gemm-epilogue/README.md) use this operation; executable implementations remain separately tracked.
