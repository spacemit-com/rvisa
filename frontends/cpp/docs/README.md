# C++ Binding Design

**Binding and implementation details: TBD.**

The binding describes the accepted C++ source subset and its translation to RVISA semantics.

## Language surface

Document the target compilation boundary, public type/operation spelling, template and compile-time arguments, scalar control flow, local values, and compiled helper calls.

Native scalar and pointer interfaces are distinguished from internal vector/tile value signatures. Source-level values do not establish a stable binary ABI by themselves.

## Type and call boundaries

Preserve scalable capacity, fixed-length grouping, explicit views, and argument/result constraints across calls. Caller configuration must remain logically intact even when target registers or configuration state are clobbered.

The external ABI, cross-translation-unit behavior, and compiler dependency require explicit versioned contracts.

## Correspondence and validation

Validate type/stage errors, control flow, calls, and effect/numerical preservation. Paired Python examples cover equivalent semantic features; source syntax and implementation-specific constructs may differ.

Return to the [C++ frontend](../README.md).
