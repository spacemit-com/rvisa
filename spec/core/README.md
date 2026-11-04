# Core Models

The core models define the behavior shared by RVISA operations and their implementations.

| Model | Subject |
| --- | --- |
| [Execution](execution-model.md) | Logical programs, control flow, calls, and configuration scope |
| [Values and state](value-model.md) | Computation values, descriptors, views, and effects |
| [Layout](layout-model.md) | Coordinates, matrix axes, storage strides, and representation |
| [Memory](memory-model.md) | Addressing, bounds, aliasing, ordering, and completion |
| [Numerics](numeric-model.md) | Precision, rounding, reductions, and special values |
| [Diagnostics](diagnostics.md) | Invalid programs and unsupported targets |

Operation definitions refine these models with concrete signatures and behavior. Target mappings preserve them within a declared profile.

Return to the [specification](../README.md).
