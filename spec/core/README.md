# Core Models

The core models define the semantics that RVISA virtual operations and their target instruction sequences must preserve. Types, operand roles, register representation constraints, and observable effects are considered together.

| Model | Subject |
| --- | --- |
| [Execution](execution-model.md) | Logical programs, control flow, calls, and configuration scope |
| [Values and state](value-model.md) | Computation values, descriptors, views, and effects |
| [Layout](layout-model.md) | Coordinates, matrix axes, storage strides, and representation |
| [Linear layouts](linear-layout.md) | Carrier basis maps, composition, conversions, and valid domains |
| [Tile optimization](tile-optimization.md) | Programmer expressibility, anchors, and closed-region legality |
| [Memory](memory-model.md) | Addressing, bounds, aliasing, ordering, and completion |
| [Transfers](transfers.md) | Path selection, readiness, dependencies, and buffer lifetime |
| [Numerics](numeric-model.md) | Precision, rounding, reductions, and special values |
| [Diagnostics](diagnostics.md) | Invalid programs and unsupported targets |

Operation definitions refine these models with concrete signatures and behavior. The [tile register policy](../types/tile.md#register-representation) and [mapping guarantees](../../mappings/contract.md#mapping-guarantees) connect the logical models to legal register representations and instruction sequences within a declared profile.

Return to the [specification](../README.md).
