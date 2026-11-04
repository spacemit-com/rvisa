# Extended Stores — Provisional

`vsstore` and `tsstore` are reserved operation names with incomplete address contracts. Their presence does not establish a stable signature or implemented capability.

## Established data roles

vsstore uses vector data normalization; tsstore uses tile data normalization, including explicit rank-2 vector views and unambiguous scalar broadcast. The expected effect is Write, with configuration/alias dependencies as applicable.

## Candidate vector form

The following is a proposal, not a frozen signature:

~~~text
vsstore(ptr, idx, value, stride) -> void
candidate_address(j) = ptr + sizeof(T) * (idx + j*stride)
~~~

The candidate is one-dimensional, uses nonnegative element strides, and writes only valid lanes. More than one valid lane with stride=0 creates a conflicting write and would be rejected. Address overflow and invalid allocations remain forbidden. Grouped/two-dimensional forms do not follow automatically.

## Open tile contract

The distinction between tsstore and the already strided [tview/tstore](tile-memory.md) combination remains unresolved. Rank, stride interpretation, address generation, bounds, and conflict behavior must be specified together before acceptance.

An implementation MUST NOT generate a guessed access sequence for an unqualified provisional operation. Defined strided tile accesses use tview and tstore. See [Specification Status](../../status.md) and the [RFC process](../../../rfcs/README.md).
