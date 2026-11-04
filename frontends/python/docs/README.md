# Python Binding Design

**Binding and implementation details: TBD.**

The binding specifies how Python syntax denotes RVISA program operations. It must distinguish source analysis, compile-time specialization, and target runtime values.

## Language surface

Document kernel declarations, argument/result types, operation calls, defaults, scalar control flow, value rebinding, and supported helper calls. Unsupported Python constructs require explicit diagnostics.

Each bound operation references its primary semantic definition. Scalar, vector, and tile roles must not be inferred solely from Python's host object behavior.

## Compilation boundary

The design identifies which objects are host invocation data, which values enter the compiled program, and which arguments must be statically resolvable. Host execution must not silently determine target control-flow semantics.

## Correspondence and validation

Tests should cover accepted/rejected programs, default expansion, stage errors, and preservation of types, shapes, effects, and numerical policies. Corresponding C++ examples provide a shared behavioral comparison, not merely matching call counts.

Return to the [Python frontend](../README.md).
