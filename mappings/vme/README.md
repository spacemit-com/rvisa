# [VME](https://github.com/riscv/riscv-isa-manual/pull/2997) Mappings

[VME](https://github.com/riscv/riscv-isa-manual/pull/2997) mappings connect vector input preparation with matrix accumulator state. The representation and lifecycle of the accumulator are explicit parts of the profile.

## Mapping requirements

- Supported RVISA operations, legal instruction sequences, and their selection conditions.
- Vector input register groups, accumulator register classes/coordinates, and transfer operations.
- Interactions between vector configuration and matrix configuration.
- Active dimensions, numerical accumulation, calls, and context-management requirements.

Use the [Vector-Matrix Extension source material](https://github.com/riscv/riscv-isa-manual/pull/2997) as an entry point. Each profile fixes its own source revision and capabilities; it must not combine incompatible draft or vendor definitions.

Tile representations follow the [register priority policy](../../spec/types/tile.md#register-representation). Each profile records fragmentation, simultaneous resource requirements, and the conditions for transfers, reuse, spills, or staging.

## Profile index

The [profile index](profiles/README.md) records concrete mappings. Profiles follow the [shared contract](../contract.md) and [document format](../templates/profile/README.md).
