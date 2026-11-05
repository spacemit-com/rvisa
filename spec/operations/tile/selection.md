# Tile Extraction, Insertion, and Selection

These working-draft operations distinguish axis-based subvalue extraction, immutable assembly, and Boolean elementwise selection.

| Operation | Meaning |
| --- | --- |
| [textract](#textract) | Fix one coordinate along an axis and return the subvalue with that axis removed |
| [tinsert](#tinsert) | Form a new tile by replacing one axis-selected subvalue |
| [tselect](#tselect) | Choose between two data values at each coordinate using a Boolean mask |

Use these canonical names in source notation, IR descriptions, mapping rules, and examples.

## textract

Operation identifier: RVISA-OP-TEXTRACT. Effect: Pure. Classification: extraction anchor.

~~~text
textract(value: tile<T,S,L>, axis: static<index>, index: index,
     layout = auto) -> extracted_value
~~~

axis selects a logical dimension; index selects one coordinate on it. The remaining dimensions retain their order. For rank greater than one, the result is a tile with that axis removed. Selecting from a rank-1 tile returns a scalar T. Rank-zero tile types are not introduced.

**RVISA-TEXTRACT-1.** For each result coordinate y, insert index at position axis to obtain x; result[y]=value[x]. No other coordinates are selected. The validity condition is 0 <= index < S[axis]. A statically invalid selector is diagnosed; a runtime selector retains an explicit precondition or check under the implementation's declared validity policy.

For a matrix X[M,N], textract(X,axis=0,index=r) gives row r with shape [N]; axis=1 gives column c with shape [M]. Repeated extraction can obtain an [8,8] fragment from [4,4,8,8].

The result initially restricts the source coordinate/carrier relation. The selected layout may preserve those locations or request a packed carrier. A row and column need not have the same movement cost. A packed column may require a gather, permutation, or legal decomposition. Extraction is not an extra memory load and does not alter the source value.

axis and layout are static. index may be runtime only where the profile has a legal realization; a dynamic index does not make result rank or extents dynamic.

## tinsert

Operation identifier: RVISA-OP-TINSERT. Effect: Pure. This is the assembly counterpart to extraction.

~~~text
tinsert(base: tile<T,S,L>, part, axis: static<index>, index: index,
        layout = inherited) -> tile<T,S,L_result>
~~~

part has the element type and shape of textract(base,axis,index); for rank-1 base, part is scalar. A scalar may otherwise broadcast only to the uniquely determined subshape under the common data rules.

**RVISA-TINSERT-1.** The result equals base outside the selected slice and part inside it. Both inputs remain immutable. Index validity is the same as textract. The default result representation inherits the base representation; an explicit alternative layout must be legal and its conversion must be represented.

Insertion is not an addressed store. A compiler may reuse a dead base carrier or eliminate overwritten initial values, but cannot overwrite a still-live value. This operation lets a programmer assemble fragments using ordinary loops and carried tile values.

## tselect

Operation identifier: RVISA-OP-TSELECT. Effect: Pure elementwise value computation.

~~~text
tselect(mask: mask<S>, a: tile_data<T,S>, b: tile_data<T,S>)
    -> tile<T,S,L_result>
~~~

The operands follow the common dtype, shape, and scalar-broadcast rules. The [mask](../../types/mask.md) supplies a Boolean condition for each result coordinate.

**RVISA-TSELECT-1.** At every logical coordinate i, the result is a[i] when mask[i] is true and b[i] otherwise. The result preserves the complete normalized shape, including batch axes; no axis is removed. Selection does not combine the two elements arithmetically or introduce an implicit dtype conversion.

Both candidates are values already computed according to program effects. Selecting a value does not suppress earlier loads or other effects used to produce the unselected candidate. Compatible carrier layouts are propagated under the [layout rules](../../core/tile-optimization.md#anchors); any required representation conversion remains explicit or reconstructible.

## Fragment example

Informative pseudocode:

~~~text
row = textract(C4, axis=0, index=mo)    # [4,8,8]
acc = textract(row, axis=0, index=no)   # [8,8]
updated_row = tinsert(row, result8, axis=0, index=no)
C4 = tinsert(C4, updated_row, axis=0, index=mo)
~~~

This describes immutable rebinding and does not require copying every unaffected element at runtime. The mapping must show any reuse, movement, or staging.

## Conformance

Check row/column coordinates, non-square shapes, repeated rank reduction, rank-1 scalar results, invalid axes/indices, dtype/subshape mismatch, preservation of unselected elements, and live-source preservation. Prove extraction/assembly correspondence independently of the chosen register packing. For tselect, check per-coordinate mask choice, full-shape preservation, and retention of prior operand effects.

See [programmer expressibility](../../core/tile-optimization.md#expressibility-requirement) and [layout cases](../../../conformance/cases/linear-layout.md).
