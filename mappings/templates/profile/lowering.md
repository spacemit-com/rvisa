# Lowering Rules

Each rule connects a defined virtual operation and operand domain to a legal target instruction sequence or parameterized sequence family.

## Rule definition

A rule identifies the virtual operation/version, supported operand domain, required configuration, coordinate transformations, target sequence or precise pseudocode, and resulting state. Each step identifies operand roles, register classes/groups, and the associated register/operand definitions.

Preconditions include numerical policy, resource constraints, alignment, grouping, and overlap. Dependencies must make the ordering of memory, configuration, and call effects explicit. Record which sequence alternatives, fusions, or decompositions are permitted and the conditions selecting them; mapping stability follows the [profile guarantees](../../contract.md#mapping-guarantees).

## Explicit tile expression

For each tile optimization, provide the equivalent public RVISA expression required by [programmer expressibility](../../../spec/core/tile-optimization.md#expressibility-requirement). Show views separately from conversions, selected anchor layouts, fragment extraction/assembly, and contraction traversal. A private backend operator is not a substitute for this expression.

## Boundary behavior

Define zero extents, partial tiles, active contraction lengths, invalid combinations, faults/restart, temporary storage, and completion. Include resource-boundary cases that change fragment scheduling, register reuse, or permitted spills/staging. Physical padding must not add logical contributions. A closed-region rewrite accounts for every use, pinned layout, alias-relevant effect, and external boundary; derive direct load/store addressing from the original descriptor and chosen carrier map.

If the native sequence cannot satisfy the source contract, identify a permitted decomposition or a diagnostic. The existence of an instruction with a similar arithmetic shape is insufficient.

## Evidence and cost

Associate rules with independent cases, instruction/register inspection, and execution evidence. Inspection checks the allowed sequence and class/group constraints without requiring incidental allocation choices. Report any performance observations separately from functional correctness, including packing, transfers, spills, and synchronization.

See [operands](operands.md), [numerics](numerics.md), and [conformance records](conformance.yaml).
