# Compiler-Managed Transfers

Tile memory operations return computation values or express writes. The compiler selects memory instructions and internal synchronization while preserving the [memory model](memory-model.md).

## Transfer selection

**RVISA-TRANSFER-POLICY-1.** The `allow_tma` option on tload, tstore, and im2col is a compile-time permission:

| Reference notation | Normalized meaning |
| --- | --- |
| Omitted or None | TMA permitted |
| true | TMA permitted |
| false | TMA forbidden for this operation |

Only the appropriate compile-time Boolean/omission is accepted. An integer used as a Boolean, a dynamic policy value, or duplicate options must be diagnosed. In the C++ notation, the permission is an option tag; its position among distinct tags does not change semantics.

TMA denotes a transfer acceleration path explicitly registered by a target profile. Permission does not require that capability, force its selection, or guarantee asynchronous execution or overlap. If permitted but unavailable or unsuitable, ordinary memory sequences remain candidates. A false option does not force all other operations or non-TMA accesses to execute serially.

A hard capability requirement, if a profile defines one, is a different constraint. Requiring a TMA path while forbidding it is a conflict.

## Values and dependencies

tload and im2col return ordinary immutable tiles. tstore returns void and records a write. These interfaces do not expose pending tiles, events, queues, barrier counts, or source-level wait operands.

**RVISA-TRANSFER-ORDER-1.** An internally asynchronous implementation MUST preserve:

| Dependency | Required behavior |
| --- | --- |
| Load or im2col to a value consumer | Every consumed element is ready |
| Store to a possibly aliasing load | The load observes the preceding write where required |
| Load to a possibly aliasing store | The store does not destroy the value the load must observe |
| Store to a possibly aliasing store | Overlapping final values preserve program order |
| Transfer or consumer to storage reuse | The storage remains valid until every dependent use completes |
| Calls, branches, loops, configuration | Effects follow executed paths and governing state |

These relations cross scalar, vector, and tile operation families. Distinct pointer parameters do not imply noalias. Scheduling must also preserve matrix accumulation order.

An internal function return does not automatically drain all engines. However, a function's temporary storage cannot expire while work still uses it. Before the runtime reports program completion, external writes satisfy the runtime's visibility contract. Host launch behavior and synchronization between logical programs require separate runtime contracts.

## Path legality

The chosen path must preserve coordinates, element type, bounds, fill values, alias ordering, and completion. Hardware zero fill cannot replace arbitrary other values without a correct supplementary sequence.

Tile register representation and transfer-engine selection are separate decisions. A profile records transfer direction, supported rank/shape, strides, alignment, format, padding, rectangular or im2col access, and completion mechanism. Matrix capability in [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), or [AME](https://github.com/riscv/riscv-attached-matrix-extension) does not itself establish a TMA path.

Ordinary vector-register loads, address generation, and permitted staging may implement tile memory operations under the [mapping guarantees](../../mappings/contract.md#mapping-guarantees). If no candidate satisfies semantics and resources, report the unsupported case.

## Informative pipeline pattern

| Phase | Logical action | Scheduling obligation |
| --- | --- | --- |
| Prologue | Load current only if work exists | No initial access on a zero-work path |
| Lookahead | Load next only if another iteration exists | Preserve bounds and alias dependencies |
| Compute | Consume current and update accumulator/state | Retain required numerical order |
| Carry | Rebind current to next | Rebinding does not immediately free old storage |
| Drain | Execute the last computation without another prefetch | Preserve the last values' lifetimes |
| Store | Write completed output | Keep the source available until transfer completion |

This pattern permits overlap when dependencies and resources allow it. Earlier source definition of next does not force an immediate hardware transfer.

Validation reports selected paths, waits, temporary storage, reuse, and measured overlap separately. Mathematical or source-level checks alone do not demonstrate asynchronous device execution.
