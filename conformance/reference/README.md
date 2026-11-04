# Reference Methods

Reference methods establish expected semantics independently of the target lowering being evaluated.

## Mathematical and coordinate models

Exact arithmetic and explicit coordinate enumeration can validate shape, indexing, batch pairing, scaling association, and address selection. These methods must state their domain and assumptions.

## Floating-point models

A numerical reference identifies input conversion, intermediate precision, rounding, accumulation order, special values, and approximation policy. Host-language arithmetic is not automatically a model of target floating-point execution.

## Independence and scope

Use an independently derived algorithm or oracle for the property under test. Record where shared utilities might couple the reference to the implementation.

Memory faults, synchronization, target state, and performance require evidence beyond a mathematical model. Executable reference components are under development.

Return to the [conformance framework](../README.md).
