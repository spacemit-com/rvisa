# Tile Optimization and Programmer Control

RVISA exposes the tile-level transformations that its compiler uses. A programmer can write an optimized tile computation explicitly and obtain the same semantic and representation constraints as the corresponding compiler rewrite.

## Expressibility requirement

**RVISA-TILE-EXPR-1.** Every compiler-performed optimization of an RVISA tile computation MUST have an equivalent expression using public RVISA operations, layout descriptions, operand attributes, and control flow. This includes partitioning, coordinate views, representation conversion, subvalue selection/assembly, contraction traversal, and the load/store realization of a layout.

A compiler explanation must be able to materialize that expression with all relevant layout and numerical constraints. A backend-private tile operator or inaccessible layout choice cannot be the only definition of an optimization. If the public vocabulary cannot express a proposed rewrite, that is a specification gap to resolve before claiming this requirement.

The requirement concerns expressible tile semantics and representation choices. Architectural register allocation, incidental instruction scheduling, and physical register numbers remain governed by the selected profile. It does not promise identical incidental allocation or a performance result for differently written programs.

| Programmer expression | Compiler use |
| --- | --- |
| [tshape and ttranspose](../operations/tile/layout-operations.md) | Factor/merge dimensions and change logical axis views |
| [tconvert_layout](../operations/tile/layout-operations.md#tconvert_layout) | State a physical representation conversion explicitly |
| [textract and tinsert](../operations/tile/selection.md) | Extract a row/column/fragment and assemble immutable results |
| [Axis-bound tmma](../operations/matrix/blocked-mma.md) | Bind factored M/N/K axes and express blocked contraction |
| [tload/tstore](../operations/memory/tile-memory.md) | Produce/consume a declared carrier using descriptor coordinates |
| Scalar loops and carried values | Order fragment computation and accumulator updates |

## Anchors

An anchor operation imposes, selects, or transfers representation constraints at a point in the tile computation. It does not authorize changing mathematical values.

| Anchor | Constraints |
| --- | --- |
| Load, including structured loads | Memory coordinates/bounds and the selected result carrier |
| Store | Value-to-memory correspondence, bounds, and the consumer's access sequence |
| MMA | Instruction geometry, operand/accumulator classes, element packing, and numerical legality |
| textract | Selected coordinate domain and a legal result carrier; a column may require movement |

Other operations can be anchors when their profile contract states the constraints. Elementwise operations propagate compatible maps; different input maps require an explicit compatible conversion or decomposition. Reshape and permutation are view operations, not implicit retile instructions.

**RVISA-TILE-ANCHOR-1.** Compiler-selected anchor layouts MUST be derived through [linear-layout relations](linear-layout.md) and must obey explicit programmer layout constraints. An auto layout leaves a choice to inference. An explicit layout is a constraint, not an ignorable hint. A conflicting requirement needs an expressible conversion, a permitted decomposition, or a diagnostic.

## Closed tile regions

A closed tile region contains the tile-value graph to be optimized, including its boundary loads/stores. Its incoming tile-producing boundaries are loads or absent; its outgoing tile-consuming boundaries are stores or absent. Scalar values, addresses, descriptors, and static metadata may enter without carrying a tile representation.

A region can start from constants/zero construction without a load, or have no escaping tile result. The absence of outputs does not by itself authorize removing memory effects.

**RVISA-TILE-REGION-1.** Before rewriting a region, the compiler MUST account for every tile producer, consumer, alias-relevant effect, and live value at its boundaries. An external tile argument, escaped tile result, unmodeled call, conflicting use, or explicit layout constraint is an additional boundary. The compiler must include it in the proof, retain a conversion there, or choose a smaller region.

Multiple users may demand different layouts. Rewriting one path cannot silently change another user's representation. Loop-carried values and branch joins require consistent boundary contracts.

## Propagation and boundary folding

A valid region rewrite follows these obligations:

1. Resolve shapes, operand roles, numerical policies, and explicit layout constraints.
2. Establish candidate anchor layouts from the selected target/profile.
3. Compose view maps and propagate compatible representation constraints across the tile graph.
4. Derive any required conversion from source/destination maps and validity domains.
5. Fold conversions into boundary loads/stores only when the same semantic access and value correspondence can be generated legally.
6. Check register classes/groups, live resources, configuration, alias ordering, temporary lifetime, and completion.
7. Produce the equivalent explicit RVISA expression and mapping evidence.

The linear-layout algebra determines coordinate correspondence and conversion requirements. Instruction availability and cost decide which legal candidate to use; algebra alone does not establish performance.

## What boundary folding preserves

**RVISA-TILE-BOUNDARY-1.** A layout rewrite MUST preserve the descriptor's logical addresses, bounds, fill values, data types, permitted access, and required ordering. It may change the selected instruction sequence and the order of independent accesses, but may not silently transpose the caller's memory, read padding, duplicate observable effects, or introduce conflicting writes.

Load snapshots and RAW/WAR/WAW relations still hold. Streaming fragments from memory or storing results early requires an alias/lifetime proof; a closed tile graph alone does not prove that its memory arguments are disjoint. Unknown aliasing may require staging, retained values, or rejection of the rewrite.

Matrix fragmentation also preserves accumulator initialization and the required global K sequence. An 8x8x8 instruction with incompatible internal reduction order cannot implement ordered MMA merely because its real-number formula matches.

## Verification

Compare an inferred region with its explicit RVISA expansion using identical operands, bounds, layouts, and numerical policies. Verify coordinate maps and memory traces, then inspect instruction/register and state constraints. Check conflicting users, pinned layouts, external tile values, partial tiles, zero active K, and alias-sensitive stores.

No compiler implementation or target profile is established by this chapter. See [Specification Status](../status.md) for implementation boundaries.
