# Documentation and Metadata Tools

Repository tools maintain the specification's structure and traceability: links and anchors, metadata formats, requirement identities, cross-layer references, and generated indexes.

Indexes should preserve the links among virtual operations, profile revisions, instruction mapping rules, register classes/groups, and conformance evidence. Document checks establish traceability; instruction/register conformance requires appropriate generated-code evidence.

A generated artifact identifies its authoritative inputs. Semantic definitions remain in their primary documents; generated views must not become competing hand-maintained sources.

Maintenance tooling is under development. Executable entry points and local invocation instructions are documented when available. Tool validation is maintained in [tests/](../tests/README.md).

Dialect development drivers belong to the [MLIR module](../mlir/README.md); shared semantic execution belongs to the conformance framework.
