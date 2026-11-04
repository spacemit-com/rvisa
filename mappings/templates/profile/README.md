# Target Profile Format

This document set is the authoring template for a concrete target profile.

| File | Purpose |
| --- | --- |
| [profile.yaml](profile.yaml) | Identity, versions, capabilities, and constraints |
| [sources.md](sources.md) | Fixed source references and provenance |
| [registers.md](registers.md) | Register domains, coordinates, state, and transfers |
| [operands.md](operands.md) | Source and target operand correspondence |
| [lowering.md](lowering.md) | Legality and realization rules |
| [numerics.md](numerics.md) | Numerical contract and equivalence conditions |
| [conformance.yaml](conformance.yaml) | Coverage and verification evidence |
| [CHANGELOG.md](CHANGELOG.md) | Revision history |

Assign the profile identity and source versions when creating a concrete profile. Populate its supported domain and evidence without implying support outside that domain.

The YAML records are proposed metadata forms; their schema is under development. Null identity fields and `status: template` identify this authoring resource rather than a registered target.

See the [mapping contract](../../contract.md).
