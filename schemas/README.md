# Metadata Formats

Metadata connects specification entries, target profiles, conformance evidence, and reference workloads through stable identities and versions.

## Responsibilities

A schema defines required fields, identifier relationships, permitted states, compatibility rules, and validation diagnostics. Structural validation is distinct from verification of the semantic claims recorded in the data.

Formats are under development. The [profile record](../mappings/templates/profile/profile.yaml) and [evidence record](../mappings/templates/profile/conformance.yaml) are current authoring forms rather than finalized backend interfaces.

[MAINTAINERS.yaml](../MAINTAINERS.yaml) records maintenance areas and assignments independently of target capabilities. Empty assignments and template identities remain explicit states, not fabricated data supplied to satisfy a validator.

Schema changes affecting existing records require an explicit version and migration policy.
