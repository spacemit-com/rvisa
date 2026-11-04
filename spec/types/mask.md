# Mask Types

A mask associates Boolean conditions with a defined logical coordinate domain. Its shape and group relationships follow the values and operations to which it applies.

## Interpretation

Mask storage is an implementation choice subject to the target contract. It is not derived by inserting `sizeof(bool)` into a numerical vector-capacity formula.

A mask is not a scalar branch condition. Reducing it to a scalar decision requires an explicitly defined operation.

## Operation-specific behavior

An operation specifies whether a mask controls access, computation, result selection, or preservation of inactive elements. These effects are not interchangeable. Selecting between already computed values does not suppress an earlier memory access.

Mask and tail handling must preserve the documented inactive-element and numerical rules. The public source-language mask spelling remains an [open contract](../status.md).

See [scalar types](scalar.md), [memory](../core/memory-model.md), and [operand roles](../operands/roles.md).
