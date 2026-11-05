# Linear Layouts

A linear layout describes the relationship between carrier coordinates and logical element coordinates. RVISA uses this relationship to derive views, representation conversions, anchor constraints, and memory access sequences. It does not equate a logical tile with one architectural register.

## Domains and direction

A resolved representation records:

| Component | Meaning |
| --- | --- |
| Logical domain D(S) | Coordinates within the tile's full shape S |
| Carrier domain P | Named fragment, register-within-group, and element-slot coordinates |
| L: P -> D(S) | Which logical element is held at a carrier coordinate |
| Validity domain | Carrier coordinates belonging to actual elements, excluding physical padding |
| Resource constraints | Register classes, group sizes/alignment, overlap, and supported instructions |

A fragment identifies part of a value's representation. It does not require all fragments to be resident simultaneously. Register numbers and scheduling are assigned under the [mapping contract](../../mappings/contract.md).

**RVISA-LAYOUT-COVER-1.** A nonreplicating representation MUST cover every logical element exactly once on its valid carrier domain. Replication needs an explicit value operation or declared representation rule with consistent copies. Padding is not an additional logical element and must not contribute to computation or memory access.

## Binary-linear basis

For power-of-two coordinate domains, encode each named coordinate as a bit vector. A binary-linear map has the form:

~~~text
bits(logical_coordinate) = M * bits(carrier_coordinate) over GF(2)
L(p) = XOR of the basis images corresponding to the set bits of p
~~~

The matrix M is specified by the image of each input basis bit. Composition is binary matrix multiplication. Inversion is available for a bijection on the relevant domain; equal element counts alone do not establish invertibility.

This algebra follows the approach described in the [Linear Layouts paper, version 5](https://arxiv.org/html/2505.23819v5) and the [fixed Triton LinearLayout source](https://github.com/triton-lang/triton/blob/f8cddb947b471d6902a39f62d0894d1e552e5e75/include/triton/Tools/LinearLayout.h). RVISA defines its own carrier dimensions and contracts; GPU thread/warp coordinates are not implicit RISC-V resources.

## Views and physical movement

Let V map a new logical coordinate to the corresponding old coordinate.

**RVISA-LAYOUT-VIEW-1.** A reshape or axis permutation MUST preserve the carrier location of every element. Its representation is obtained by coordinate composition, with L_new = inverse(V) composed with L_old for a bijective view. This changes the coordinate description, not the stored element at a carrier location.

For reshape, V is the composition of flattening in the new shape and unflattening in the old shape. For permutation, V applies the inverse axis permutation. The [layout operations](../operations/tile/layout-operations.md) define both precisely.

By contrast, a representation conversion preserves logical coordinates and changes carrier locations. For bijective source and destination layouts:

~~~text
destination_slot = inverse(L_destination)(L_source(source_slot))
~~~

A conversion may be eliminated when this relation requires no movement or when a valid anchor rewrite supplies the destination representation directly. Otherwise its register moves, shuffles, cross-class transfers, or permitted staging are real work.

**RVISA-LAYOUT-CONVERT-1.** Conversion MUST use a valid coordinate correspondence. A padded, sliced, or replicated representation cannot be inverted as though its entire padded carrier domain were bijective. Restrict to valid elements or provide an explicit copy-selection/replication rule.

## Non-power-of-two shapes and symbolic capacities

Logical extents remain arbitrary positive integers. A binary-linear map over padded power-of-two carrier domains is accompanied by exact logical view maps and validity predicates. For example, a 15-element tile can have a 16-slot carrier with one invalid slot; a [3,5] view preserves the same 15 element locations.

A general mixed-radix reshape is not necessarily one GF(2) matrix. The derivation must retain its exact flatten/unflatten map, or use proven piecewise domains. It must not replace division or integer addition with XOR. Every physical fragment mapping remains identified by its linear-layout description and domain.

Scalable shapes and VLEN-dependent representations are parameterized families. A specialization or runtime selection must establish the required capacity, divisibility, coverage, and instruction legality over its declared domain. The compiler host's VLEN is not a substitute.

Fixed row/column extraction restricts a domain and may introduce a coordinate offset. Such offsets and dynamic selector parameters remain explicit; they are not mislabeled as a zero-origin linear map.

## Memory composition

The layout determines logical coordinates; the memory descriptor determines addresses:

~~~text
logical = L(carrier)
address = base + sizeof(T) * (offset + sum((origin[d] + logical[d]) * stride[d]))
~~~

Bounds are checked in logical coordinates before accessing the corresponding element. This composition uses integer address arithmetic, not GF(2) arithmetic on byte addresses. Packed sub-byte formats still require their separate storage contract.

A compiler can therefore load directly into a chosen blocked carrier or store from it without first constructing a contiguous register representation. It must preserve every original value, address, fill, alias dependency, and completion obligation. Deriving a layout does not establish that a particular memory instruction implements it.

## Required derivation record

A profile or compiler explanation identifies the source and destination domains, basis maps, coordinate views, predicates, anchor constraints, conversion relations, and selected legal instructions/register groups. An unresolved constraint or noninvertible map requires a defined decomposition or diagnostic.

See [tile optimization](tile-optimization.md), [the blocked MMA example](../operations/matrix/blocked-mma.md), and [layout conformance cases](../../conformance/cases/linear-layout.md).
