# Execution Model

A kernel describes one logical program containing scalar control flow, vector operations, and tile computation. A runtime invocation determines its arguments and execution environment. The mapping from logical programs to physical processors, threads, and execution resources belongs to the target/runtime contract.

## Evaluation stages

Source-language parsing, specialization, and program execution are distinct stages. Types, shape relationships, and compile-time options are resolved as required by each operation. Runtime values remain runtime values even when an implementation happens to observe a constant.

Python and C++ source forms describe the same target computation. An implementation accepting these source forms must not silently replace device control flow with host evaluation.

## Control flow and calls

Scalar conditions select control-flow paths. A mask value is not implicitly a scalar condition. Loops preserve the types and shapes of carried values, and a zero-iteration loop retains its incoming values.

A compiled call must preserve the argument/result contract and the declared effects. An implementation that accepts source code must diagnose unsupported source constructs rather than omit their behavior.

## Configuration scope

Logical vector configuration is scoped to a function or region. A callee does not inherit undeclared caller configuration. Returning from a call or leaving a nested region preserves the parent's logical configuration; the backend supplies any physical reconfiguration needed to implement that rule.

Loop iterations begin with the loop-entry logical configuration. Configuration-sensitive operations must remain ordered with respect to the configuration that governs them.

## Scheduling and completion

The compiler may partition computation and overlap independent work while preserving numerical, memory, configuration, and call dependencies. Source ordering is interpreted through observable behavior, not as a requirement that every operation map to one instruction.

Program completion satisfies the runtime's visibility contract for externally observable writes. Internal function return does not by itself require draining every physical engine. Storage cannot be reused while outstanding work may still access it.

See [values and state](value-model.md), [memory](memory-model.md), and [operand stages](../operands/stages.md).
