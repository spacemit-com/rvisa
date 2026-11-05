# Axis-Bound and Blocked Matrix Multiply-Accumulate

This working-draft form of tmma exposes factored matrix axes so a programmer can write the same blocked computation as a compiler legalization. It is an explicit extension of [tmma](tmma.md), not an inference that every rank-4 input is an ordinary batched matrix.

## Explicit matrix-axis binding

~~~text
tmma(a, b, acc, axes = matrix_axis_binding,
     mode = TMmaMode.reduce,
     reduce_order = ReduceOrder.ordered,
     valid_k = K) -> tile
~~~

The static binding supplies ordered axis lists:

| Binding field | Coordinate role |
| --- | --- |
| a_m, a_k | A's factored M and K coordinates |
| b_n, b_k | B's factored N and K coordinates |
| c_m, c_n | Accumulator/result's factored M and N coordinates |

Each pair partitions all axes of its operand exactly once. All lists are nonempty. Corresponding factor extents match in order: a_m with c_m, b_n with c_n, and a_k with b_k. M, N, and K are the products of their factor extents.

Axes within a list run from most significant to least significant in the flattened matrix coordinate. The binding is complete enough to distinguish output coordinates from contraction coordinates; matching total element counts are insufficient.

The axes form does not default ALayout/BLayout/CLayout; explicitly supplying those enums together with axes is invalid. The compact form without axes retains its existing enum defaults and rank/batch rules. In the axes form mode must be reduce: the explicitly bound K factors are contracted. Additional independent batch axes or cross/broadcast modes are not implicitly introduced.

**RVISA-TMMA-FACTORS-1.** After assembling factor tuples for m, n, and k, the axes form MUST compute the ordinary effective-coordinate relation D[m,n]=C[m,n]+sum_k A[m,k]*B[n,k]. The accumulator is incorporated once. ordered follows increasing flattened k, and valid_k bounds that full K coordinate.

Dtype, FMA, rounding-policy, numerical capability, and register constraints remain those of tmma. This chapter adds no reassociation permission. The scaled operation needs a separate explicit binding for scale factors; this extension does not silently generalize tmma_scaled's scale axes.

## 32x32 example with an 8x8x8 execution unit

Assume f16 A/B, f32 accumulation, and a profile with a legal M/N/K=8/8/8 matrix realization. The geometry is an example profile assumption, not a property assigned to any extension family.

Use the default effective input shapes A[M,K]=[32,32] and B[N,K]=[32,32]. The complete view path is:

~~~text
A [32,32] -> tshape [4,8,4,8] -> ttranspose(0,2,1,3) -> [4,4,8,8]
B [32,32] -> tshape [4,8,4,8] -> ttranspose(0,2,1,3) -> [4,4,8,8]

A axes: [mo,ko,mi,ki]
B axes: [no,ko,ni,ki]
C axes: [mo,no,mi,ni]

D [4,4,8,8] -> ttranspose(0,2,1,3) -> tshape [32,32]
~~~

The binding is:

~~~text
axes = {
  a_m: (0,2), a_k: (1,3),
  b_n: (0,2), b_k: (1,3),
  c_m: (0,2), c_n: (1,3)
}
~~~

**RVISA-MMA-BLOCK-1.** In this example:

~~~text
A4[mo,ko,mi,ki] = A[8*mo+mi, 8*ko+ki]
B4[no,ko,ni,ki] = B[8*no+ni, 8*ko+ki]

D4[mo,no,mi,ni] = C4[mo,no,mi,ni]
    + sum(ko=0..3, sum(ki=0..7,
        A4[mo,ko,mi,ki] * B4[no,ko,ni,ki]))
~~~

Only terms with 8*ko+ki < valid_k contribute. The outer K factor is reduced, while mo and no are independent output axes. There are 4*4*4=64 full 8x8x8 micro-operations for full K, with four successive updates of each of the sixteen output microtiles.

For ordered, execute ko then ki in increasing order and carry the same accumulator between K blocks. An instruction whose internal 8-term reduction violates that order needs a legal decomposition or diagnostic.

## Carrier change and capacity accounting

The view chain alone retains the original carrier. The MMA anchor selects a representation where each trailing [8,8] microtile has the required register layout; conversion to that representation is separately derivable and expressible.

At VLEN=1024 bits:

| Value | Logical bytes | Canonical linear carrier | Blocked fragment inventory |
| --- | --- | --- | --- |
| A or B, [32,32] f16 | 2048 | Two f16m8 groups; aggregate capacity informally m16 | 4*4 fragments, each f16m1 |
| C or D, [32,32] f32 | 4096 | Four f32m8 groups; aggregate capacity informally m32 | 4*4 fragments, each f32m2 |

The sixteen input m1 fragments contain the same bytes as the original two m8 groups. This changes grouping and element placement, not logical size. The f16m1 description does not apply to f32 accumulators.

These are inventories over the whole value, not simultaneous register allocations. A/B/C inventories together exceed the ordinary RVV register file if all are kept live; a legal schedule, register reuse, permitted staging, or another declared register class is required. No spill-free execution is implied.

## Deriving the input layout

For either input, write the first matrix axis as u and the contraction axis as k. Let f=4*uo+ko identify a microtile and e=8*ui+ki identify an element within it.

~~~text
u = 8*(f//4) + e//8
k = 8*(f%4)  + e%8

original_flat_index = 32*u + k
blocked_carrier_index = 64*f + e
~~~

A binary-linear basis for the map (f,e)->(u,k) is:

| Input bit | Logical coordinate image (u,k) |
| --- | --- |
| e bit 0, 1, 2 | (0,1), (0,2), (0,4) |
| e bit 3, 4, 5 | (1,0), (2,0), (4,0) |
| f bit 0, 1 | (0,8), (0,16) |
| f bit 2, 3 | (8,0), (16,0) |

XOR of the selected basis images recovers all 1024 logical coordinates exactly once. Use u=m for A and u=n for B. The C map substitutes n for k; its physical register/element decomposition additionally reflects f32 width.

The load address for carrier (f,e) is the original descriptor address at (u,k), with original bounds and fill. It is not necessarily one unit-stride vector load: an 8x8 block in a row-major 32-column matrix spans eight row segments. The profile must provide a legal memory sequence.

## Explicit programmer form

The following specification pseudocode states the same choices a compiler may infer. L_A, L_B, and L_C are the blocked carrier maps above expressed in the operands' original 2D coordinates; each includes the appropriate dtype/register-group information.

~~~text
a = tload(Aview, (0,0), (32,32), other=zero_f16, layout=L_A)
b = tload(Bview, (0,0), (32,32), other=zero_f16, layout=L_B)
c = tload(Cview, (0,0), (32,32), other=zero_f32, layout=L_C)

a4 = ttranspose(tshape(a, (4,8,4,8)), (0,2,1,3))
b4 = ttranspose(tshape(b, (4,8,4,8)), (0,2,1,3))
c4 = ttranspose(tshape(c, (4,8,4,8)), (0,2,1,3))

d4 = tmma(a4, b4, c4, axes=axes, mode=TMmaMode.reduce,
          reduce_order=ReduceOrder.ordered, valid_k=V)
d = tshape(ttranspose(d4, (0,2,1,3)), (32,32))
tstore(Dview, (0,0), d)
~~~

An overwrite variant replaces the C load with an explicitly typed zero accumulator. A preexisting value with an incompatible pinned carrier uses tconvert_layout; shape/permutation cannot stand in for it.

The same contraction can be written using the original rank-2 tmma and public selection/assembly:

~~~text
out = c4
for mo in range(4):
  for no in range(4):
    acc8 = textract(textract(c4, axis=0, index=mo), axis=0, index=no)
    for ko in range(4):
      v = max(0, min(8, V - 8*ko))
      a8 = textract(textract(a4, axis=0, index=mo), axis=0, index=ko)
      b8 = textract(textract(b4, axis=0, index=no), axis=0, index=ko)
      acc8 = tmma(a8, b8, acc8, valid_k=v,
                  reduce_order=ReduceOrder.ordered)
    row = textract(out, axis=0, index=mo)
    row = tinsert(row, acc8, axis=0, index=no)
    out = tinsert(out, row, axis=0, index=mo)
~~~

The source values remain immutable. This loop fixes contraction order, not incidental physical register numbers. A compiler may fuse boundary access with fragment computation only after proving the [region constraints](../../core/tile-optimization.md#what-boundary-folding-preserves).

## Diagnostics and conformance

Diagnose missing/duplicated axes, mismatched corresponding factors, wrong accumulator shape, mixed axes/enums, unsupported modes, invalid V, or an unimplementable carrier/numerical requirement. The axes form is explicit; unannotated rank-4 inputs remain outside the compact form's contract.

Check all coordinates, inverse views, factor reduction, accumulator preservation, partial/zero K, actual register capacities, and memory-address correspondence. See [layout cases](../../../conformance/cases/linear-layout.md).
