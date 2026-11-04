# Control and Configuration Operations

Control and configuration operations determine which computation is performed and which logical state governs it.

## Control flow

Scalar conditions choose executed paths; vector/tile masks are not implicitly scalar conditions. Loops and static compiled calls preserve value types, shapes, and effect dependencies under the [execution model](../../core/execution-model.md).

`range(stop)` expands to `range(0,stop,1)`. The positive-step form `range(start,stop,step)` denotes a half-open runtime iteration sequence. A zero-iteration loop preserves incoming carried values. A zero step is invalid; complete negative-step compatibility remains provisional.

## Configuration

[vconfig](vconfig.md) defines full and tail configuration, element-width/LMUL inference, and the distinction between capacity, valid memory extent, and hardware vl. Its dynamic-request return convention remains provisional.

Configuration belongs to a function or region; nested calls and regions preserve parent logical state. Profiles record target transitions, clobbers, and preservation requirements.

## Calls and synchronization

A static call resolves its input/result types and declares data and state effects. Runtime invocation, cross-compilation-unit ABI, and cross-program synchronization need explicit contracts; they are not inferred from ordinary function return or source sequencing.

Source-language syntax subsets and frontend implementations are outside this revision. Internal transfer scheduling follows [the transfer contract](../../core/transfers.md), with readiness and storage-lifetime obligations even when no source-level wait is present.

See [diagnostics](../../core/diagnostics.md) and [open contracts](../../status.md).
