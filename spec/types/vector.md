# Vector Types

The conceptual vector form is `vec<T, D, G>`, where T is the element type. D and G jointly identify a capacity and grouping mode; D is not a rank or a list of dimensions.

## Modes

| D | G | Interpretation |
| --- | --- | --- |
| Negative | Positive | Scalable vector; G denotes the target LMUL relationship |
| Positive | Negative | One fixed-length vector of D elements; representation grouping is inferred |
| Positive | Positive | G separate fixed-length vectors of D elements each |
| Negative | Negative | Type resolved from initialization, operations, and call context |

Negative values denote unresolved/scalable markers, conventionally written as -1. Zero is not a legal D or G type parameter. A runtime active length of zero is a separate, valid concept.

## Scalable capacity

For a byte-addressable numerical element type and a legal LMUL L:

```text
capacity(T, L) = L * vlenb / sizeof(T)
0 <= vl <= capacity(T, L)
```

Capacity depends on the target. The compiler must preserve the symbolic relationship rather than substituting the compilation host's vector length. Changing active length does not change the value type.

The profile defines legal LMUL and element-width combinations. Public fractional-LMUL spelling remains provisional; negative values already have a different meaning.

## Fixed-length modes

An inferred representation of `vec<T, D, -1>` contains D elements even if it uses multiple physical fragments. Replacing its inferred G with a positive value would change the source grouping semantics.

For `vec<T, D, G>` with positive D/G, each of the G vectors satisfies `D * sizeof(T) <= vlenb`. G is a count of separate vectors, not an LMUL. Splitting an over-capacity member does not make that explicit type legal.

## Inference and conversion

Context-inferred types must resolve consistently before concrete calls and ABI decisions. A missing constraint does not imply LMUL=1 or a fixed default length.

A value-preserving conversion from scalable T to U requires `L' = L * sizeof(U) / sizeof(T)`, subject to target legality. Fixed-length inferred modes retain D; separate fixed-length modes retain D/G and recheck per-vector capacity.

Masks preserve logical lane/group relationships without using the byte size of a host Boolean type. Shape views preserve element order and the source mode's constraints.

See [tile interoperability](tile.md), [layout](../core/layout-model.md), and [open contracts](../status.md).
