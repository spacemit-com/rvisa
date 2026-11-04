# vconfig — Logical Vector Configuration

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-VCONFIG |
| Family | Control and configuration |
| Status | Working draft; the return value for dynamic requests is provisional |
| Result | Scalar index; the full-request case is defined below |
| State | Updates logical configuration; lowering may change target state |

## Synopsis

`vconfig` establishes the configuration used by dependent vector operations. It preserves the distinction between a value's capacity, the valid memory extent, and the hardware length of an individual instruction.

~~~text
vconfig(avl: index, lmul: static<LMUL>) -> index
~~~

| Operand | Role and stage | Constraint |
| --- | --- | --- |
| avl | Runtime requested extent, in elements | -1 requests full capacity; the defined tail case is 0 <= avl < W |
| lmul | Compile-time grouping constraint | Legal for the resolved element-width relationship and target profile |

The base element width is inferred jointly from declared vector types, memory element types, operation relationships, and the selected profile. Missing or conflicting constraints MUST produce a diagnostic; traversal order does not select the base width.

## Capacity and active extent

**RVISA-VCONFIG-1.** The implementation MUST distinguish:

| Quantity | Meaning |
| --- | --- |
| W | Full logical capacity, symbolic for a scalable vector |
| valid | Elements accessed by the applicable flat memory operation |
| Hardware vl | Elements processed by one selected target instruction |

For a full request, valid = W and the returned value is W. The scalable capacity relationship is defined in [Vector Types](../../types/vector.md#scalable-capacity). A fixed-length legalization may require several instructions; its hardware lengths do not redefine W.

For a tail request with 0 <= avl < W, valid = avl. A flat load produces a full-capacity value, filling the remaining coordinates; a flat store writes only valid elements. See [vector memory](../memory/vector-memory.md). A tail request does not change the vector's type or LMUL relationship.

Other request ranges need an explicit configuration contract. An implementation MUST NOT infer their behavior from an assumed clamping rule for a target instruction.

## Mixed element widths

Operations sharing lane correspondence must have compatible capacities. For example, scalable f16 at LMUL=1 and f32 at LMUL=2 have equal lane counts. Assigning LMUL=1 to both does not preserve that relationship.

The group argument of a grouped load or zero constructor is separate metadata; it is not automatically the LMUL operand of this operation.

## Scope and state dependencies

Configuration scope is defined by the [execution model](../../core/execution-model.md#configuration-scope). Calls, branches, loops, and configuration-sensitive operations preserve those dependencies. A pure vector helper may work from resolved value types; a callee requiring memory configuration must establish it explicitly.

An implementation may use additional vector configurations while legalizing a tile. Those internal changes MUST NOT leak into the caller's logical configuration. A profile identifies configuration instructions, affected state, and the transitions needed to restore the governing logical state; no automatic hardware restoration is implied.

## Provisional return contract

The dynamic-request return value has not been selected between valid extent and full capacity. An implementation exposing a variant must name and document that variant; unqualified use of the unresolved return value must be diagnosed.

Informative pseudocode uses the defined return only:

~~~text
W = vconfig(-1, L)
process_full_blocks(W)
vconfig(remaining, L)          # 0 <= remaining < W; return value unused
process_tail()
~~~

The unresolved return value does not weaken the defined full/tail memory behavior.

## Diagnostics and conformance

Check absent or conflicting configuration, illegal element-width/LMUL combinations, unresolved type modes, dynamic LMUL, and uses of undefined return behavior. Validate nested calls, branch exit, successive loop iterations, mixed-width values, zero active extent, and internal tile legalization. Inspect required state transitions independently of numerical results; see [core design cases](../../../conformance/cases/core-designs.md).
