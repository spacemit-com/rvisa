# Control and Configuration Operations

Control and configuration operations determine which computation is performed and which logical state governs it.

## Control flow

Loops, scalar conditionals, and compiled calls preserve value types, shapes, and effect dependencies. Loop-carried values retain their incoming values when the loop executes zero times. An implementation that accepts source code must diagnose constructs outside its declared subset.

## Configuration

`vconfig` is the logical vector-configuration entry point. The selected active range and element/grouping relationships constrain dependent operations without changing scalable type capacity.

Configuration belongs to a function or region; nested calls and regions preserve the parent logical state. The compiler is responsible for any corresponding target configuration transitions. The profile records the instruction sequence, configuration/register clobbers, and preservation requirements used to implement those transitions.

The return convention for dynamic requested lengths remains provisional. An implementation must not silently choose between active length and full capacity.

## Calls and synchronization

A call declares its data and state effects. Runtime invocation and cross-program synchronization require explicit contracts; they are not inferred from ordinary function return or source sequencing.

See [execution](../../core/execution-model.md), [diagnostics](../../core/diagnostics.md), and [open contracts](../../status.md).
