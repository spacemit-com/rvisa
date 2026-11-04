# Vector Operations

Vector operations preserve the distinction between scalable capacity, inferred fixed-length representation, and separate fixed-length groups. Their semantics depend on logical values and configuration, rather than an assumed register count.

## Computation and transformation

Elementwise arithmetic and comparisons preserve the applicable coordinate relationships. Type conversion preserves the required element correspondence and rechecks capacity/group constraints. Shape and packing operations must retain their explicit ordering and grouping rules.

A reduction defines its contributing elements and numerical order. Tail fill is part of the value; it is not an implicit arithmetic mask.

## Matrix primitives in the vector domain

`vmadot(acc, x, y)` expresses the vector-group matrix relationship. For input groups `x[b0,m,k]` and `y[b1,n,k]`, its accumulation spans the Cartesian product of the two group axes.

This pairing differs from the paired-batch reduction of `tmma`. Flattening a carrier must not discard the group/packing metadata required to distinguish them.

## Configuration and legality

Configuration-sensitive operations are ordered with the logical configuration they use. A vector-family name does not imply a standard RVV single-instruction implementation. Profile-specific geometry, layouts, and numerical support remain explicit.

See [vector types](../../types/vector.md), [matrix operations](../matrix/README.md), and the [operation index](../README.md).
