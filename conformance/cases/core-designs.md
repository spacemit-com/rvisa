# Core Design Conformance Cases

These are specification-level cases for the current [working draft](../../spec/status.md). They define inputs and independent expectations; they are not an executable compiler or device test suite. A runner records its exact core/profile revision and numerical policy.

Unless a case states a floating-point policy, the small numerical values below are exact representable integers used to verify coordinates and contribution counts. Target format, geometry, and instruction support must be established separately.

## Types and views

| Case | Requirement | Input and independent expectation |
| --- | --- | --- |
| TYPE-01 | [Vector modes](../../spec/types/vector.md#scalable-capacity), [vcast](../../spec/operations/vector/vcast.md) | f16 LMUL=1 and f32 LMUL=2 have capacities 16 at vlenb=32 and 32 at vlenb=64. The relationship stays symbolic between targets; conversion preserves the count. |
| TYPE-02 | [Separate fixed vectors](../../spec/types/vector.md#fixed-length-modes) | At vlenb=128, vec<f32,64,8> is invalid because each member needs 256 bytes. vec<f32,512,-1> denotes one 512-element value and retains its inferred mode; mapping support is a separate check. |
| VIEW-01 | [vshape](../../spec/operations/vector/vshape.md) | Reshape the sequence 0..11 to [3,4]; element [2,1] is 9. [5,-1], [0,12], and [-1,-1] are invalid requests. |
| VIEW-02 | [Complete flattening](../../spec/types/tile.md#relationship-to-vectors) | Transpose [[0,1,2],[3,4,5]] to [3,2]; vector flattening yields [0,3,1,4,2,5]. A subsequent ordinary vector operation returns a vector. |
| VIEW-03 | [Explicit tile entry](../../spec/types/tile.md#relationship-to-vectors) | A grouped vec passed directly as a tmma data operand is invalid even if its element count fits. An explicit rank-2 view establishes matrix axes; additional batch axes require explicit reshape. |

## Matrix pairing and accumulation

Use default matrix layouts, f16 inputs, f32 acc, M=N=1, K=2, and A batches [[1,2],[3,4]], B batches [[5,6],[7,8]]. Each output accumulator below is 1.

| Case | Requirement | Independent expectation |
| --- | --- | --- |
| MMA-01 | [Pairing](../../spec/operations/matrix/tmma.md#value-semantics), [vmadot](../../spec/operations/vector/vmadot.md) | Cross, indexed by [p,q], yields [[18,24],[40,54]] with output shape [2,2,1,1]. vmadot has the same pair relationship when packing and numerical contracts match. |
| MMA-02 | [Paired reduce](../../spec/operations/matrix/tmma.md#value-semantics) | Reduce yields 1+(1*5+2*6)+(3*7+4*8)=71, shape [1,1]. It does not sum all cross pairs or add the accumulator twice. |
| MMA-03 | [Broadcast](../../spec/operations/matrix/tmma.md#rank-and-batch-inference) | Equal batches yield [18,54], shape [2,1,1]. With only A's first batch and both B batches, results are [18,24]. Singleton axes remain in the exposed result. |
| MMA-04 | [Active K](../../spec/operations/matrix/tmma.md#numerical-order-and-tails) | With valid_k=1, reduce yields 27; with valid_k=0 it yields 1. Invalid unequal reduce batches remain invalid at valid_k=0. |
| MMA-05 | [CLayout](../../spec/operations/matrix/tmma.md#matrix-axis-interpretation) | For rank-2 A=[[1,2],[3,4]], B=[[5,6],[7,8],[9,10]], and zero acc, rowmajor output is [[17,23,29],[39,53,67]]. Colmajor exposure is [[17,39],[23,53],[29,67]], flattening to [17,39,23,53,29,67]. |
| MMA-06 | [Ordered accumulation](../../spec/operations/matrix/tmma.md#numerical-order-and-tails) | Under an explicitly selected f32 RNE/FMA policy, A=[4096,1,4096], B=[4096,1,-4096], C=0 yields 0 in increasing-k order. A permitted tree can yield 1. A host real-number sum is not the ordered oracle. |
| MMA-07 | [Validity](../../spec/operations/matrix/tmma.md#diagnostics-and-conformance) | Diagnose mixed input ranks, a rank-2 accumulator for a batched result, runtime layout, a layout enum in the reduce_order role, ambiguous scalar batch shape, and valid_k>K. |

All eight A/B/C layout combinations must preserve effective-coordinate results. Apply input-axis permutations when constructing each case; changing only an enum while keeping incompatible shapes is not an equivalence test.

## Block scaling

| Case | Requirement | Input and independent expectation |
| --- | --- | --- |
| SCALE-01 | [Scale placement](../../spec/operations/matrix/tmma-scaled.md#value-and-numerical-semantics) | For decoded A=B=[1,1,1,1], SA=[2,3], SB=[5,7], and C=1, K=4 and Ks=2 give G=2. Full result is 63; valid_k=3 gives 42; valid_k=0 gives 1. These are value tests, not a claim that a target supports G=2. |
| SCALE-02 | [Block inference](../../spec/operations/matrix/tmma-scaled.md#partial-blocks-and-k-origins) | K=64, Ks=2, valid_k=45 still gives G=32, with 32 and 13 contributing elements. A contiguous scale load for k0=32 starts at scale index 1. A nonaligned k0 needs explicit reorganization. |
| SCALE-03 | [Scale axes](../../spec/operations/matrix/tmma-scaled.md#scale-axes-and-block-inference) | For A[2,4] and Ks=2, SA[1,4] is invalid even though its element count equals SA[2,2]. Also diagnose unequal Ks, mismatched scale batch, nonintegral G, and two scalar scales with no constraint on Ks. |
| SCALE-04 | [Scale decoding](../../spec/types/element-types.md#low-precision-and-scale-vocabulary) | f8e8m0fnu codes 127 and 128 decode to 1 and 2; code 0 denotes 2^-127, not numerical zero. |
| SCALE-05 | [Scaling rounds](../../spec/operations/matrix/tmma-scaled.md#value-and-numerical-semantics) | Under an explicitly declared f16-payload/f32-scale tuple and f32 RNE/FMA policy, take a=1+2^-10, sa=1+2^-23, b=sb=1, K=Ks=1, and C=-(1+2^-10+2^-23). Separately rounded scaling gives result 0. Deferring the scaling round until after accumulation gives 2^-33 and violates the contract. Target support for this illustrative tuple is separate. |

Vary scales across rows, K blocks, and batches so an incorrect broadcast or batch association cannot pass accidentally. Cases with a skipped NaN/Inf scale verify omission rather than zero multiplication.

## Memory and transfer behavior

| Case | Requirement | Input and independent expectation |
| --- | --- | --- |
| MEM-01 | [Flat bounds](../../spec/operations/memory/vector-memory.md#flat-load) | W=4, valid=2, input [2,4], fill=-1 gives [2,4,-1,-1]. Its full sum is 4; sum after absolute value is 8. Only two elements may be read or written by the corresponding tail accesses. |
| MEM-02 | [Tile bounds](../../spec/operations/memory/tile-memory.md#tload) | View rows [[10,11,12],[20,21,22]], sizes [2,3], strides [4,1], origin [1,1], shape [2,3], other=-7 yields [[21,22,-7],[-7,-7,-7]]. The row-padding element is never mistaken for data. The corresponding store changes only coordinates [1,1] and [1,2]. |
| MEM-03 | [Snapshots and ordering](../../spec/core/transfers.md#values-and-dependencies) | Load an element containing 3, store 9 through an alias, then load again. The first value remains 3 and the second is 9. Cover scalar/vector/tile aliases and temporary storage reuse. |
| MEM-04 | [Transfer permission](../../spec/core/transfers.md#transfer-selection) | Omitted/None and true normalize to permitted; false forbids TMA for that operation. Dynamic Boolean policy, duplicate options, and integer-as-Boolean are invalid. Permission with no engine still permits a legal ordinary path. |
| MEM-05 | [Write validity](../../spec/core/memory-model.md#aliasing-and-order) | A descriptor mapping two effective written coordinates to the same address is invalid for an ordinary parallel tile store. Empty bounds cause no element access; discarded store results do not remove writes. |

Instruction inspection or a memory-access instrument is needed to prove that invalid addresses were not touched. An output-value comparison alone cannot establish that property.

## Convolution coordinates

| Case | Requirement | Input and independent expectation |
| --- | --- | --- |
| CONV-01 | [im2col coordinates](../../spec/operations/memory/im2col.md#element-semantics) | One NHWC image, H=2, W=3, C=1, rows [[1,2,3],[4,5,6]], kernel [2,2], unit stride/dilation, no padding. P=1, Q=2, M_total=2, K_total=4. The unfolded rows are [1,2,4,5] and [2,3,5,6]. |
| CONV-02 | [Bounds before decode](../../spec/operations/memory/im2col.md#element-semantics) | On CONV-01, origin [-1,3], shape [3,3], fill=-1 yields [[-1,-1,-1],[5,-1,-1],[6,-1,-1]]. Zero B, C, P, or Q produces fill without division by zero or source access. |
| CONV-03 | [Descriptor strides](../../spec/operations/memory/im2col.md#synopsis) | Equivalent logical NHWC data stored as NHWC or NCHW must unfold identically when described by their respective strides. Include asymmetric padding, dilation>1, and multiple channels; derive expectations from explicit window enumeration. |

## Configuration and mapping evidence

| Case | Requirement | Expected observation |
| --- | --- | --- |
| CFG-01 | [Configuration scope](../../spec/core/execution-model.md#configuration-scope) | A callee's configuration, a nested branch, and internal tile legalization do not alter the parent's logical configuration. Each loop iteration begins from its region-entry configuration. |
| CFG-02 | [Provisional return](../../spec/operations/control/vconfig.md#provisional-return-contract) | A full request returns W. Unqualified use of a dynamic-request return is diagnosed unless an explicitly identified variant defines it. |
| MAP-01 | [Tile policy](../../spec/types/tile.md#register-representation), [mapping guarantees](../../mappings/contract.md#mapping-guarantees) | For a selected profile, inspect instruction families, element/register correspondence, group alignment, overlap/ties, configuration, and permitted spills/staging. A result match does not replace this evidence. |

No concrete target profile is registered by these cases. Numerical checks, structural checks, IR verification, compilation, instruction/register inspection, execution, and performance remain separate evidence layers.
