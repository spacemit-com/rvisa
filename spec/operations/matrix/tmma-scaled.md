# tmma_scaled — Block-Scaled Tile Matrix Multiply-Accumulate

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-TMMA-SCALED |
| Status | Working draft |
| Result | f32 tile with the output shape defined by tmma |
| Effects | Pure |

## Synopsis

Each data input is paired with a scale tile. Scaling applies to input elements before contraction, with explicit f32 rounding points.

~~~text
tmma_scaled(a, a_scale, b, b_scale, acc,
            ALayout = ALayout.rowmajor,
            BLayout = BLayout.colmajor,
            CLayout = CLayout.rowmajor,
            mode = TMmaMode.reduce,
            reduce_order = ReduceOrder.ordered,
            valid_k = K) -> tile<f32, output_shape>
~~~

All five data operands are required. Layout, rank, batch, accumulator normalization, defaults, active K, and enum staging follow the compact form of [tmma](tmma.md). The [axis-bound extension](blocked-mma.md) does not implicitly define scale-factor axes for this operation. Scale values may be runtime data; their types, shapes, and blocking relationship must be statically resolvable. There is no independent block-size operand and no transfer-policy operand on this pure computation.

## Scale axes and block inference

**RVISA-SCALE-SHAPE-1.** Each scale MUST preserve every non-K axis of its associated data input, replacing only K with Ks:

| Data role and layout | Data shape | Scale shape |
| --- | --- | --- |
| A rowmajor | PA+[M,K] | PA+[M,Ks] |
| A colmajor | PA+[K,M] | PA+[Ks,M] |
| B colmajor | PB+[N,K] | PB+[N,Ks] |
| B rowmajor | PB+[K,N] | PB+[Ks,N] |

PA and PB are independently empty or a single batch axis. Scale follows its input's layout and batch; CLayout does not transpose scales. A matching total element count does not excuse incorrect scale axes.

The inputs share K and the scales share Ks, with K>0, Ks>0, and K divisible by Ks. Define G=K/Ks. Scale coordinate g covers local k in [g*G,(g+1)*G). G is a mathematical K-block length, distinct from vector groups, LMUL, and matrix batches.

Symbolic inputs require proof of these relations and of the supported G over the declared vector-length range. This contract does not implicitly introduce shared row scales, two-dimensional scale blocks, or different G on A and B.

## Normalization and batching

Scale tiles must exactly match their associated non-K and batch axes. Cross pairs A[p]/SA[p] with B[q]/SB[q]; reduce pairs equal batch indices; broadcast reuses an input together with its scales when that input has a singleton batch.

A scalar scale can broadcast if its complete shape is uniquely inferable from its input and the other scale's Ks. If both scales are scalar and no explicit scale shape fixes Ks, the operation is ambiguous. G must not be guessed as 1, 16, or 32.

An explicit broadcast can construct a required scale tile. There is no implicit row or batch broadcast of a tile scale. Accumulator shape and dtype follow tmma, with f32 as the baseline here.

## Value and numerical semantics

In effective coordinates, g(k)=k//G. The mathematical input values are:

~~~text
Areal[...,m,k] = decode(Aeff[...,m,k]) * decode(SAeff[...,m,g(k)])
Breal[...,n,k] = decode(Beff[...,n,k]) * decode(SBeff[...,n,g(k)])
~~~

Use these values in tmma's selected pairing. Scales are multiplicative dequantization factors. They do not scale acc or the final output, and they are not inverted. Zero points, amax updates, and result requantization are not implicit.

**RVISA-SCALE-NUM-1.** The baseline strict numerical sequence MUST:

1. Decode each contributing payload and scale to f32 under its format contract.
2. Multiply each payload by its corresponding scale and round that product to f32 using round-to-nearest, ties-to-even.
3. Accumulate the two scaled operands with f32 FMA under the declared order and accumulation-rounding contract.

Do not round the scaled operands back to FP8, FP4, f16, or bf16. The applicable numerical contract must identify FMA rounding and format-special-value behavior. The declared format decoding and f32 operations determine NaNs, infinities, subnormals, and signed zero; flushing subnormals is not implicitly enabled. NaN payload preservation is not required.

Ordered uses the same k or b-then-k sequence as tmma. Tree relaxes accumulation association only; it preserves scale decoding, the separate scaling-rounding points, and f32 precision. An unscaled dot product followed by multiplication by a block scale is not automatically equivalent.

## Partial blocks and K origins

**RVISA-SCALE-K-1.** G MUST be derived from full K and Ks, not valid_k. Only k < valid_k is scaled and accumulated. A partial last block is legal; valid_k=0 returns normalized acc after validity checks. A skipped contribution must not be replaced with multiplication by zero when its scale could be NaN or infinity.

For example, K=64, Ks=2, valid_k=45 gives G=32 and contributions from 32 elements in the first block and 13 in the second.

When ordinary contiguous loads start at a global k0, their local block zero must cover the first local data block. This requires k0 divisible by G and a scale start at k0/G. A nonaligned origin needs explicit data/scale reorganization; no hidden scale-offset parameter is defined.

Prior data and scale loads retain their full memory effects. Their fill values must be representable in the relevant format; [exponent-encoded scales](../../types/element-types.md#low-precision-and-scale-vocabulary) cannot use numerical zero as a generic fill.

## Capabilities and register mapping

A profile records the tuple (A dtype, SA dtype, B dtype, SB dtype, G, accumulator dtype), geometry, modes, active-K restrictions, numerical behavior, and data/scale register correspondence. Payload-format support alone does not establish support for this operation.

A legal realization may use native scaled instructions or a declared sequence that decodes, scales, and accumulates in vector registers. Both obey the [tile register policy](../../types/tile.md#register-representation) and [mapping guarantees](../../../mappings/contract.md#mapping-guarantees). Packing or scale swizzling required by hardware must preserve the logical scale axes.

FP4 memory packing and complete format conversion contracts require explicit definitions; the element vocabulary does not create a pointer ABI.

## Diagnostics and conformance

Diagnose mismatched scale rank, non-K axes or batch, unequal Ks, nonintegral G, ambiguous scalar scales, mismatched K, invalid active K, and unsupported format/block/numerical combinations.

Cases use varying scales across rows, blocks, and batches, a nonzero accumulator, all layout combinations and batch modes, singleton inputs, partial blocks, and valid_k=0. Separate exact coordinate checks from decoding and floating-point rounding tests. See [core design cases](../../../conformance/cases/core-designs.md#block-scaling) and the [blockscale workload](../../../demos/blockscale-gemm/README.md).
