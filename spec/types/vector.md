# Vector Types

The conceptual vector form is `vec<T, D, G>`, where T is the element type. D and G jointly identify a capacity and grouping mode; D is not a rank or a list of dimensions.

## Modes

**RVISA-VEC-MODE-1.** The signs of D and G select the following distinct type modes; legalization MUST preserve the selected mode's element count and grouping constraints.

| D | G | Interpretation |
| --- | --- | --- |
| Negative | Positive | Scalable vector; G denotes the target LMUL relationship |
| Positive | Negative | One fixed-length vector of D elements; representation grouping is inferred |
| Positive | Positive | G separate fixed-length vectors of D elements each |
| Negative | Negative | Type resolved from initialization, operations, and call context |

Positive D is an integer element count. In the separate-fixed mode, positive G is an integer member count and need not be a power of two.

Negative values denote unresolved/scalable markers, conventionally written as -1. Zero is not a legal D or G type parameter. A runtime active length of zero is a separate, valid concept.

## Scalable capacity

For a byte-addressable numerical element type and a legal LMUL L:

```text
capacity(T, L) = L * vlenb / sizeof(T)
0 <= vl <= capacity(T, L)
```

Capacity depends on the target. The compiler must preserve the symbolic relationship rather than substituting the compilation host's vector length. Changing active length does not change the value type.

The profile defines legal LMUL and element-width combinations. The usual integral LMUL values are 1, 2, 4, and 8; fractional LMUL additionally requires target element-width legality. Public fractional-LMUL spelling remains provisional; negative values already have a different meaning. A fraction must not be expressed by an integer division that evaluates to zero.

## Fixed-length modes

An inferred representation of `vec<T, D, -1>` contains D elements even if it uses multiple physical fragments. Replacing its inferred G with a positive value would change the source grouping semantics.

For `vec<T, D, G>` with positive D/G, each of the G vectors satisfies `D * sizeof(T) <= vlenb`. G is a count of separate vectors, not an LMUL. Splitting an over-capacity member does not make that explicit type legal.

## Target register constraints

A target profile relates the resolved type mode to architectural register classes/groups, element coordinates, alignment, and overlap rules. Logical G and LMUL constraints remain distinct from the number of physical registers simultaneously live. Allocation and any permitted fragment reuse must preserve the mode-specific capacity and grouping rules above.

## Inference and conversion

Context-inferred types must resolve consistently before concrete calls and ABI decisions. A missing constraint does not imply LMUL=1 or a fixed default length.

An element-count-preserving conversion from scalable T to U requires `L' = L * sizeof(U) / sizeof(T)`, subject to target legality. Fixed-length inferred modes retain D; separate fixed-length modes retain D/G and recheck per-vector capacity.

Masks preserve logical lane/group relationships without using the byte size of a host Boolean type. [vshape](../operations/vector/vshape.md) preserves element order and the source mode's constraints; [vcast](../operations/vector/vcast.md) defines the mode-specific conversion rules.

An operation's `group=G` metadata is not automatically the G in this type form. Grouped loads and matrix primitives retain their own packing/geometry metadata even when carried by a flat vector. The complete public bridge between such aggregates and these types remains provisional.

For example, at vlenb=128, a separate f32 member of 64 elements exceeds one vector register's capacity. `vec<f32,64,8>` is therefore invalid. A fixed inferred carrier of 512 elements can be considered independently, but preserving an 8-by-64 operation layout requires explicit metadata; it does not legalize the invalid separate-vector type.

A vector value carries no hidden valid-memory-length predicate. Full-capacity pure computation can therefore include fill elements, even when the load that produced the value accessed fewer elements.

See [tile interoperability](tile.md), [layout](../core/layout-model.md), and [open contracts](../status.md).
