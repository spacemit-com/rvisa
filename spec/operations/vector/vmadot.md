# vmadot — Vector-Group Matrix Multiply-Accumulate

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-VMADOT |
| Status | Working draft; complete public carrier/packing bridges remain provisional |
| Result | Vector carrier retaining matrix-group metadata |
| Effects | Pure computation with applicable configuration/target-state dependencies |

## Synopsis

~~~text
vmadot(acc: vector<TC>, x: vector<TX>, y: vector<TY>) -> vector<TC>
~~~

The accumulator is the first operand. Logical group geometry, packing, and the connection to concrete vector types must be established before selecting an instruction sequence.

## Logical operands

| Role | Logical coordinates | Element count |
| --- | --- | --- |
| x | [B0,M,K] | B0*M*K |
| y | [B1,N,K] | B1*N*K |
| acc/result | [B0,B1,M,N] | B0*B1*M*N |

These are the operation's group coordinates, not a promise of that many physical registers or an implicit assignment to the third parameter of `vec<T,D,G>`.

**RVISA-VMADOT-PAIR-1.** The operation MUST preserve the Cartesian product of input group axes:

~~~text
result[p,q,m,n] = acc[p,q,m,n]
                 + sum(k=0..K-1, x[p,m,k] * y[q,n,k])
~~~

Each output incorporates its own accumulator once. Flattening a carrier does not erase the metadata needed to recover these coordinates.

## Types, numerics, and validity

The baseline input formats are f16/bf16 with f32 accumulation. Accepted dtype tuples, cube geometry, capacity constraints, and packing are declared explicitly by the applicable contract/profile. Shape/group mismatch and unresolved carrier bridges must be diagnosed.

The equation specifies contributing pairs; it does not define a new reduction-order operand or authorize arbitrary reassociation. A mapping must state the operation's numerical contract, including widening, accumulation order, rounding, and special values. The unresolved numerical details remain explicit rather than being inferred from the target opcode.

## Relationship to tile matrix operations

The cross pairing of [tmma](../matrix/tmma.md) can match this relationship after explicit axis, packing, and numerical normalization. Paired-batch reduce and singleton broadcast do not have this Cartesian product and require distinct decompositions.

A legal pipeline may contain vector loads, vmadot, packing, shape views, and stores. The implementation must preserve configuration, packing, and group relationships through the whole sequence. Neither a vector-family name nor the equation asserts a standard RVV single-instruction encoding.

## IR, registers, and conformance

Profiles identify source and accumulator register classes/groups, element coordinates, alignment, overlap/ties, state clobbers, and legal sequence families. A flat accumulator must not be declared as an invalid separate-vector type to match target packing.

Test at least two groups on each side with different values, nonzero accumulators, and non-square M/N. Compare against the independent cross-pair expectations in [core design cases](../../../conformance/cases/core-designs.md#matrix-pairing-and-accumulation); inspect register and state constraints separately.
