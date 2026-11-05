# Tile Shape, Permutation, and Representation Conversion

These working-draft operations separate logical views from physical movement. Their signatures use [specification metanotation](../../conventions.md#signature-metanotation).

## tshape

Operation identifier: RVISA-OP-TSHAPE. Effect: Pure view.

~~~text
tshape(value: tile<T,S,L>, shape: static<S2>) -> tile<T,S2,view_layout(L)>
~~~

The ranks are at least one, extents are positive, and product(S)=product(S2). Symbolic relationships must be proved over the applicable target range.

**RVISA-TSHAPE-1.** For each output coordinate j, let q=flatten(S2,j) and i=unflatten(S,q). The result at j is value[i], held at the same carrier location. The operation MUST NOT itself retile, copy, change dtype, add padding elements, or choose a new LMUL.

A [x0,x1] tile is therefore a reshape of [x0*x1] with the same carrier, and the rule extends to any rank. The output layout description composes the new coordinate view with the inherited carrier map.

## ttranspose

Operation identifier: RVISA-OP-TTRANSPOSE. Effect: Pure view. The term permute denotes this operation in layout derivations.

~~~text
ttranspose(value: tile<T,S,L>, perm: static<axis_permutation>)
    -> tile<T,permuted_shape,permuted_view_layout(L)>
~~~

perm is a bijection on [0,rank). Output dimension j has size S[perm[j]]. For an output coordinate y, its input coordinate x satisfies x[perm[j]]=y[j].

**RVISA-TPERMUTE-1.** Axis permutation MUST preserve the carrier location of each element. It changes logical coordinate interpretation, not the physical element sequence.

For example, [4,8,4,8] with perm=(0,2,1,3) becomes [4,4,8,8]. The new shape does not by itself place an 8x8 block in one register group. An MMA anchor may require a different layout, leading to a separate conversion or boundary rewrite.

## tconvert_layout

Operation identifier: RVISA-OP-TCONVERT-LAYOUT. Effect: Pure value computation, with implementation movement as required.

~~~text
tconvert_layout(value: tile<T,S,L1>, layout: static<L2>) -> tile<T,S,L2>
~~~

**RVISA-TCONVERT-1.** The result MUST have the same dtype, shape, and value at every logical coordinate as the input, while satisfying L2. The [source-to-destination layout relation](../../core/linear-layout.md#views-and-physical-movement) determines the required movement.

The explicit layout describes carrier coordinates, fragment/register-group requirements, validity, and any parameterization. It is a binding constraint at this result, not merely an optimization hint. A representation-equivalent conversion may require no instruction. Other conversions may use register shuffles, moves, cross-class transfers, or permitted private staging.

The compiler may fold a conversion into a producing load, consuming store, or other compatible anchor when the [region proof](../../core/tile-optimization.md#propagation-and-boundary-folding) preserves all contracts. The equivalent explicit RVISA expression remains available.

## Validity and diagnostics

Diagnose element-count mismatch, zero/invalid extent, nonbijective permutation, unproved symbolic relationships, malformed/noncovering carrier maps, unsupported group widths, conflicting fixed layouts, and conversions without a legal resource/numerical/memory realization.

View purity does not make an entire view-consumer chain free. Any required movement belongs to a representation conversion or the anchor's chosen realization and must be accounted for there.

## Mapping and conformance

Check that reshape/permutation preserve element-to-carrier identity, even when logical flattening changes. Check conversion coordinate preservation separately from data movement. Compare explicit conversions with legal boundary-folded realizations, including incompatible users and aliasing boundaries.

See [tile types](../../types/tile.md), [the blocked MMA example](../matrix/blocked-mma.md), and [layout cases](../../../conformance/cases/linear-layout.md).
