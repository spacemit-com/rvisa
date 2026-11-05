# Conformance Framework

The conformance framework connects specification requirements to reusable cases, independent reference methods, and implementation-specific execution.

| Area | Responsibility |
| --- | --- |
| [Cases](cases/README.md) | Inputs, preconditions, expected behavior, and applicability |
| [Reference methods](reference/README.md) | Independent coordinate and numerical expectations |
| [Runners](runners/README.md) | Adapters to IR tools, instruction/register inspection, simulators, and devices |

The obligations are defined in [spec/conformance.md](../spec/conformance.md). Concrete executable cases and adapters are under development.

[Layout and tile-optimization cases](cases/linear-layout.md) compare explicit tile expressions with inferred region rewrites and cover capacities, view identity, blocked contraction, memory coordinates, and conflicting boundaries.

## Evidence records

Record the specification and profile versions, implementation/tool versions, configuration, inputs, method, outcome, and limitations. Coverage and execution are distinct: a case can identify an obligation before an execution result exists.

Separate documentation, mathematical, IR, compilation, instruction/register inspection, execution, and performance evidence. An unavailable or skipped check is not a successful check.

Implementation-specific unit tests remain in their modules. This framework supplies shared requirements and comparison methods rather than replacing all local tests.
