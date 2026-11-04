# Conformance Cases

A conformance case identifies a requirement and the conditions under which its behavior can be checked.

## Case definition

Record the core/profile version, requirement identifiers, input values and layouts, preconditions, expected values or diagnostics, comparison policy, and applicability.

Expected results must have a stated derivation. Outputs from the implementation under test cannot serve as the sole independent expectation.

## Coverage

Include representative valid combinations, invalid types/shapes/stages, zero extents, tails, configuration transitions, layout transforms, aliasing, and numerical boundary cases as applicable.

Cases are language-neutral where possible. Python/C++ source expressions and target invocation details are supplied by the corresponding adapters.

The executable case catalogue is under development. Return to the [conformance framework](../README.md).
