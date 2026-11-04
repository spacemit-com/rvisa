# Scalar Types

A scalar represents one numerical or Boolean computation value. Its type is distinct from a pointer, memory descriptor, compile-time option, or target register name.

## Representation and use

An operation's accepted scalar types determine element width, signedness or floating-point format, range, and numerical behavior. Type availability and operation support are separate target capabilities. A target profile identifies the register class or immediate forms accepted by each mapped operand; a scalar type alone does not select a physical register.

A scalar used as an index or extent must satisfy the relevant range and unit constraints. A scalar condition controls program flow; a vector or tile mask is not implicitly converted into that condition.

## Conversion and broadcasting

A conversion changes the element type according to an explicit numerical contract. It must not be inferred merely from a physical register's capacity.

A scalar may be broadcast into a data operand position only when the complete destination shape is uniquely determined. Address and metadata positions do not participate in data broadcasting.

Element formats and RVISA type semantics are independent of source-language type spelling. The detailed format catalogue is part of the developing operation/type reference.

See [operand roles](../operands/roles.md), [masks](mask.md), and [numerics](../core/numeric-model.md).
