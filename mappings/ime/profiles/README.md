# [IME](https://github.com/riscv/integrated-matrix-extension) Profiles

| Profile | Maturity | Mapping revision | Supported subset | Source revision |
| --- | --- | --- | --- | --- |
| [ime-main](ime-main/README.md) | draft | 1 | rank-2 `tmma`, signed `int8` × signed `int8` → `int32`, `M = N = 8`, `K` a multiple of 16, `vqmmacc.vv` | `6effbcae3204e5a8a9c9d15ff53959918144870c` |

A registered profile identifies the RVISA version, upstream specification revision, target constraints, mapping revision, supported subset, and verification evidence. The profile identifier remains stable across editorial changes; semantic changes are recorded in its revision history. Registration is not a maturity state: `draft` profiles carry explicit open issues, and a registered profile is not a supported target.

Use one directory per profile and link it from this index when its identity and scope are defined. The [document format](../../templates/profile/README.md) and [mapping contract](../../contract.md) apply.

Return to the [mapping guide](../README.md).
