# [AME](https://github.com/riscv/riscv-attached-matrix-extension) Profiles

| Profile | Maturity | Mapping revision | Supported subset | Source revision |
| --- | --- | --- | --- | --- |
| [ame-main](ame-main/README.md) | draft | 1 | rank-2 `tmma`, `fp16` × `fp16` → `fp32`, `M = N = 16`, `K` a multiple of 32, `mmulacc.2d` | `8d27acdcee7a189aad4e2907412e0c40a9d4b9e2` (tag `v0.6`) |

A registered profile identifies the RVISA version, upstream specification revision, target constraints, mapping revision, supported subset, and verification evidence. The profile identifier remains stable across editorial changes; semantic changes are recorded in its revision history. Registration is not a maturity state: `draft` profiles carry explicit open issues, and a registered profile is not a supported target.

Use one directory per profile and link it from this index when its identity and scope are defined. The [document format](../../templates/profile/README.md) and [mapping contract](../../contract.md) apply.

Return to the [mapping guide](../README.md).
