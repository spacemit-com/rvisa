# Conformance Cases

A conformance case identifies a requirement and the conditions under which its behavior can be checked.

## Case definition

Record the core/profile version, requirement identifiers, input values and layouts, preconditions, expected values or diagnostics, comparison policy, and applicability.

Expected results must have a stated derivation. Outputs from the implementation under test cannot serve as the sole independent expectation.

## Coverage

Include representative valid combinations, invalid types/shapes/stages, zero extents, tails, configuration transitions, layout transforms, aliasing, and numerical boundary cases as applicable.

Mapping cases also identify legal instruction sequence families, operand/register classes and groups, allocation constraints, and spill/staging policy. Include valid and invalid alignment/overlap combinations and resource boundaries that trigger documented fragmentation or rejection. Expected register constraints come from the profile and its sources rather than one generated allocation.

Cases are independent of a particular source notation where possible. Python/C++ source expressions and target invocation details are supplied by the corresponding adapters.

[Core design cases](core-designs.md) define inputs, exact expected values or diagnostics, and mapping obligations for the adopted type, matrix, memory, configuration, and convolution contracts. They are specification-level cases; an executable case catalogue remains under development. Return to the [conformance framework](../README.md).
