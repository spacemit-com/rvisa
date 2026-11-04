# Conformance Runners

Runners adapt shared cases to a concrete implementation or verification layer.

A runner records dependency versions, target/profile parameters, invocation, input preparation, result comparison, and the execution environment. It preserves the distinction between passed, failed, unsupported, and not-run outcomes.

An unsupported operation must not be silently replaced with a different semantic contract. A fallback, where permitted, is reported with the path actually exercised.

IR validation, simulator execution, and device execution use distinct adapters and evidence scopes. Runner implementations are under development.

Return to the [conformance framework](../README.md).
