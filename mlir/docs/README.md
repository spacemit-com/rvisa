# Dialect Design

**Design and implementation details: TBD.**

The dialect represents the RVISA semantic model so that verification and transformation can operate on explicit types, coordinates, numerical policies, and effects.

## Types and operation structure

Types distinguish scalar, fixed/scalable vector, tile, mask, and memory-reference concepts. Resolved source information is represented using appropriate types, SSA operands, attributes/properties, regions, and results.

The source-language evaluation stage determines what must be known during specialization. An IR encoding choice does not change that stage or the operation's semantics.

## Verification and interfaces

Verifiers cover local constraints and cross-operand type/shape relationships. Interfaces expose effects, inference, and other behavior needed by generic transformations. Configuration-sensitive operations and calls retain dependencies that prevent invalid movement or elimination.

## Transformations and conversion

Canonicalization preserves the numerical and memory contracts. Conversion legality includes resource constraints, representation changes, implicit state, and target-specific failure conditions.

Conversion rules refer to the applicable profile and primary semantic definitions. Unsupported behavior must be diagnosed or handled by an explicitly permitted decomposition.

## Validation

Validation covers assembly round trips, negative diagnostics, semantic metadata, effects, and conversion legality. Textual IR matching is one evidence layer; numerical execution and target state behavior need separate checks.

See the [MLIR module](../README.md), [operand stages](../../spec/operands/stages.md), and [conformance requirements](../../spec/conformance.md).
