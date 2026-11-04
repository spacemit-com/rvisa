# Scalar Operations

Scalar operations act on individual computation values. Their contracts define arithmetic, comparison, conversion, and selection independently of the physical register or source-language spelling.

## Common requirements

Operands and results must have compatible declared types. Conversions state their numerical behavior explicitly; address values and compile-time options are not silently accepted as numerical data.

A scalar selection chooses a value. It does not reverse memory accesses or effects already performed to produce either candidate. Scalar branch behavior belongs to the execution/control-flow model.

The operation reference supplies each operation's result type, exceptional behavior, and diagnostics. A target's scalar capability set is recorded in its profile together with the instruction sequences, register classes, and immediate restrictions used for the supported operations.

See [scalar types](../../types/scalar.md), [numerics](../../core/numeric-model.md), and the [operation index](../README.md).
