# Dialect Design

**Design and implementation details: TBD.**

The dialect represents RVISA virtual instruction semantics so that verification and transformation retain typed operands, register grouping constraints, coordinates, numerical policies, and effects.

## Types and operation structure

Types distinguish scalar, fixed/scalable vector, tile, mask, and memory-reference concepts. Resolved source information is represented using appropriate types, SSA operands, attributes/properties, regions, and results.

The source-language evaluation stage determines what must be known during specialization. An IR encoding choice does not change that stage or the operation's semantics.

The [operation reference](../../spec/operations/README.md) supplies the concrete verification inputs: vconfig capacity/valid-state distinctions, vshape/vcast constraints, matrix pairing and numerical policies, scale axes, bounded memory effects, and im2col coordinates. Preserve the [operand stages](../../spec/operands/stages.md#concrete-operand-stages) when deciding between SSA operands and static attributes; the exact encodings remain TBD.

## Target representation constraints

The design must preserve the register classes/groups and operand constraints selected by a target profile, including fragment coordinates, alignment, overlap, operand ties, and fixed-register requirements where applicable. The exact type, attribute, property, or interface encoding remains part of the dialect design.

Logical values and SSA identities remain distinct from concrete physical registers. Conversion applies the [tile register policy](../../spec/types/tile.md#register-representation) and retains enough information to account for permitted reuse, spills, and staging without hiding their effects or numerical consequences.

## Verification and interfaces

Verifiers cover local constraints and cross-operand type/shape relationships. Interfaces expose effects, inference, and other behavior needed by generic transformations. Configuration-sensitive operations and calls retain dependencies that prevent invalid movement or elimination.

## Transformations and conversion

Canonicalization preserves the numerical and memory contracts. Conversion legality includes resource constraints, representation changes, implicit state, and target-specific failure conditions.

Conversion rules refer to the applicable profile revision, legal instruction sequence families, register/operand constraints, and primary semantic definitions. Unsupported behavior must be diagnosed or handled by an explicitly permitted decomposition.

## Validation

Validation covers assembly round trips, negative diagnostics, semantic metadata, effects, and conversion legality. Check that transformations preserve the required register class/group constraints and that target code satisfies the selected mapping rules. IR checks, instruction/register inspection, numerical execution, and target state behavior are distinct evidence layers.

See the [MLIR module](../README.md), [operand stages](../../spec/operands/stages.md), and [conformance requirements](../../spec/conformance.md).
