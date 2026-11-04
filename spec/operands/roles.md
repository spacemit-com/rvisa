# Operand Roles

Operand roles determine how values are interpreted and which conversions are permitted.

| Role | Interpretation |
| --- | --- |
| Data input | Elements consumed by a computation |
| Accumulator | Initial value incorporated into an accumulation |
| Address or descriptor | Storage location and access metadata |
| Shape or extent | Logical dimensions, bounds, or active range |
| Layout or mode | Coordinate interpretation or a selected semantic variant |
| Mask | Conditions over an operation's coordinate domain |
| Configuration | State governing configuration-sensitive operations |
| Result | Computed value or explicitly returned status |

Data broadcasting applies only where the operation permits it. A pointer, shape, enum, or option is not silently treated as scalar data.

The accumulator's position and initialization semantics are defined per operation. For example, `vmadot` uses an accumulator-first form, whereas `tmma` uses data inputs followed by the accumulator; the operand order must remain explicit across bindings.

Effects may include implicit configuration dependencies even when there is no source-level operand representing that state. The target mapping records corresponding machine operands, fixed registers, and clobbers.

See [evaluation stages](stages.md) and [constraints](constraints.md).
