# [VME](https://github.com/riscv/riscv-isa-manual/pull/2997) Profiles

| Profile | Maturity | Mapping revision | Supported subset | Source revision |
| --- | --- | --- | --- | --- |
| [vme-main](vme-main/README.md) | draft | 1 | rank-2 `tmma`, signed `int8` × signed `int8` → `int32`, `M = N = 32`, any `K`, `vtmms.tvv` with `altfmt = 1` | `98b0e96fb240a0b6a54bf814fc2f6a139a409e10` (branch `zvt`, `src/unpriv/zvt.adoc`) |

A registered profile identifies the RVISA version, upstream specification revision, target constraints, mapping revision, supported subset, and verification evidence. The profile identifier remains stable across editorial changes; semantic changes are recorded in its revision history. Registration is not a maturity state: `draft` profiles carry explicit open issues, and a registered profile is not a supported target.

Use one directory per profile and link it from this index when its identity and scope are defined. The [document format](../../templates/profile/README.md) and [mapping contract](../../contract.md) apply.

Return to the [mapping guide](../README.md).
