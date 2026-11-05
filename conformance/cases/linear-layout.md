# Linear-Layout and Tile-Optimization Cases

These specification-level cases validate [tile carriers](../../spec/types/tile.md), [linear-layout derivation](../../spec/core/linear-layout.md), and [programmer-expressible optimization](../../spec/core/tile-optimization.md). They are requirements and independent expectations, not reports of compiler or device execution.

## Capacity and views

| Case | Inputs and required expectation |
| --- | --- |
| CAP-01 | tile<f16,[128]> contains 256 logical bytes. VLEN=1024/256/128 bits gives canonical carriers m2 / m8 / (m8,m8), respectively. No instruction uses m16. |
| CAP-02 | With VLEN=128 and f16, a [3,5] tile has 15 elements and a canonical m2 carrier of 16 slots. Its [15] reshape retains the same 15 locations; padding is not read, stored, or accumulated. |
| CAP-03 | At VLEN=1024, [32,32] f16 has 2048 bytes: two m8 groups or sixteen blocked m1 fragments. The f32 accumulator has 4096 bytes: four m8 groups or sixteen blocked m2 fragments. These counts are not simultaneous-residency guarantees. |
| CAP-04 | For a profile's explicit legal LMUL set, select the smallest covering group for a fitting value and a legal fragment tuple for oversized values. Reject an unsupported dtype/group combination instead of inventing an encoding. |
| VIEW-04 | Reshape [32,32] to [4,8,4,8] and permute (0,2,1,3). Every input element remains at its original carrier location. Reverse the permutation and reshape to recover both values and locations. |
| VIEW-05 | In the preceding view, original coordinate [20,13] becomes [2,1,4,5]. Its original flat carrier index is 653; a newly packed blocked carrier would use 613. A view alone must not move the value from 653 to 613. |
| VIEW-06 | Reject reshape element-count mismatch, a repeated permutation axis, and an unproved symbolic shape relation. A non-power-of-two view uses exact coordinate arithmetic rather than an assumed global GF(2) matrix. |

## Basis maps, selection, and assembly

| Case | Inputs and required expectation |
| --- | --- |
| LAYOUT-01 | Enumerate all (f,e) in [16]x[64] using the [example basis](../../spec/operations/matrix/blocked-mma.md#deriving-the-input-layout). The XOR-derived coordinates equal u=8*(f//4)+e//8 and k=8*(f%4)+e%8, covering [32,32] exactly once. |
| LAYOUT-02 | The inverse is f=4*(u//8)+k//8, e=8*(u%8)+k%8. Verify both round trips and the source-to-destination conversion relation for all 1024 coordinates. |
| LAYOUT-03 | Replace one independent basis image with zero. The resulting nonreplicating map loses coverage and cannot be accepted or inverted merely because domain/codomain sizes match. |
| SEL-01 | On X[3,5] containing 0..14, textract(axis=0,index=1) yields [5,6,7,8,9]; textract(axis=1,index=2) yields [2,7,12]. Packed row/column carriers may have different movement sequences. |
| SEL-02 | Insert [100,101,102] into column 2 of X. Only flat coordinates 2,7,12 change; the original X remains unchanged. A wrong subshape or out-of-range selector is invalid. |
| SEL-03 | Selecting from a rank-1 tile yields a scalar. Repeated selection from [4,4,8,8] yields an [8,8] tile. textract does not mean Boolean tselect or a new addressed load. |

## Blocked contraction

Use A[m,k]=(m+2*k)%7-3, B[n,k]=(3*n-k)%5-2, and C[m,n]=m-n, for M=N=K=32. These small integer values are exactly representable in the stated f16/f32 computation.

| Case | Inputs and required expectation |
| --- | --- |
| BLOCK-01 | Compare direct matrix multiplication with the axis-bound [4,4,8,8] computation and the explicit textract/tinsert fragment loop. All 1024 outputs agree. Full K performs 64 micro-operations, with C incorporated once per output. |
| BLOCK-02 | Repeat for valid_k in {0,1,7,8,9,23,31,32}. Each block uses clamp(valid_k-8*ko,0,8), preserving the flattened K prefix. valid_k=0 returns the normalized accumulator. |
| BLOCK-03 | Under f32 RNE/FMA, use nonzero A terms at k=7,8,9 equal to [4096,1,4096], B terms [4096,1,-4096], and zero C. Continuous increasing-K accumulation yields 0. Resetting partial accumulators per K block and then adding their sums yields 1 and is invalid for ordered. |
| BLOCK-04 | Diagnose duplicated/missing bound axes, unequal corresponding factor extents, wrong C factorization, explicit layout enums mixed with axes, or an unsupported mode. Unannotated rank-4 inputs remain invalid in the compact tmma form. |

BLOCK-03 requires a numerical oracle that models the stated rounding, not an unrestricted host sum. Native instruction legality is additional evidence.

## Memory boundaries and regions

| Case | Inputs and required expectation |
| --- | --- |
| REGION-01 | Compare canonical and blocked loads/stores using descriptor sizes [30,29], strides [80,2], offset 3, origin [-1,3], and logical shape [32,32]. Both visit the same 780 valid element addresses with the same coordinate/value association; other coordinates use fill or suppress stores. |
| REGION-02 | Pin a load to a linear carrier and require blocked MMA inputs. The compiler retains the explicit constraint and expresses a conversion; it must not silently replace the pinned layout. |
| REGION-03 | Give one loaded tile two users with incompatible layout requirements. Account for both users, retain conversions, or use a legal separate realization. Rewriting one use cannot invalidate the other. |
| REGION-04 | Let an output store alias a later-needed input element. Streaming that input load after the store changes the earlier load's snapshot and is invalid without retained data or another proof. Closed tile dataflow does not imply noalias. |
| REGION-05 | A tile argument/return, unmodeled call, or inconsistent loop/branch layout is an additional boundary. Do not label the region load/store-closed without accounting for it. |
| REGION-06 | A graph with no incoming tile value can start with a zero/constant constructor. A graph with no outgoing tile value does not automatically permit deletion of effectful memory operations. |
| EXPR-01 | For each claimed tile rewrite, reconstruct a public RVISA expression with explicit layout, view, conversion, selection/assembly, and contraction order. A private backend-only primitive or inaccessible layout parameter fails the expressibility requirement. |

Compare memory address/value traces and required dependency order, not necessarily the order of independent accesses. Instruction selection, register allocation, asynchronous execution, and performance require their own profile-specific evidence.

See [core design cases](core-designs.md), [conformance requirements](../../spec/conformance.md), and [RFC 0003](../../rfcs/0003-programmer-expressible-tile-layouts.md).
