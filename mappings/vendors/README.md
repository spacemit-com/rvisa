# Vendor Extension Mappings

Vendor mappings use independent identifiers for their architecture, extension, encoding revision, and implementation constraints.

Organize a vendor profile by vendor and extension identity. Record source provenance, register/operand behavior, toolchain dependencies, and evidence. Similar names or instruction shapes do not establish compatibility with standard [IME](https://github.com/riscv/integrated-matrix-extension), [VME](https://github.com/riscv/riscv-isa-manual/pull/2997), or [AME](https://github.com/riscv/riscv-attached-matrix-extension) work.

Each profile declares its own instruction sequences, register classes/groups, operand correspondence, and resource policies under the [mapping guarantees](../contract.md#mapping-guarantees). Shared rules may be reused through explicit references. Vendor-specific recommendations remain qualified by their applicable profile and must preserve the core semantics.

No vendor profiles are currently registered. See the [mapping contract](../contract.md) and [profile format](../templates/profile/README.md).
