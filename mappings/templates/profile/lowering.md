# Lowering Rules

Each rule connects one defined source behavior to a legal target realization.

## Rule definition

A rule identifies the source operation/version, supported operand domain, required configuration, coordinate transformations, target sequence or precise pseudocode, and resulting state.

Preconditions include numerical policy, resource constraints, alignment, grouping, and overlap. Dependencies must make the ordering of memory, configuration, and call effects explicit.

## Boundary behavior

Define zero extents, partial tiles, active contraction lengths, invalid combinations, faults/restart, temporary storage, and completion. Physical padding must not add logical contributions.

If the native sequence cannot satisfy the source contract, identify a permitted decomposition or a diagnostic. The existence of an instruction with a similar arithmetic shape is insufficient.

## Evidence and cost

Associate rules with independent cases and compilation/execution evidence. Report any performance observations separately from functional correctness, including packing, transfers, spills, and synchronization.

See [operands](operands.md), [numerics](numerics.md), and [conformance records](conformance.yaml).
