# [AME](https://github.com/riscv/riscv-attached-matrix-extension) Mappings

[AME](https://github.com/riscv/riscv-attached-matrix-extension) mappings describe independent matrix execution state and its interaction with the rest of the program. Operand storage, accumulator storage, and system interfaces must be distinguished by specification version.

## Mapping requirements

- Supported RVISA operations, legal instruction sequences, and their selection conditions.
- Matrix operand/accumulator register classes, descriptors, storage footprint, and grouping.
- Memory and inter-domain transfers, staging, and supported operation/type combinations.
- Configuration, ownership/context requirements, exceptions, and numerical behavior.

Use the [Attached Matrix Extension source material](https://github.com/riscv/riscv-attached-matrix-extension) as an entry point. Each profile fixes its own source revision and capabilities; it must not combine incompatible draft or vendor definitions.

Tile representations follow the [register priority policy](../../spec/types/tile.md#register-representation). Each profile records fragmentation, simultaneous resource requirements, and the conditions for transfers, reuse, spills, or staging.

## Profile index

The [profile index](profiles/README.md) records concrete mappings. Profiles follow the [shared contract](../contract.md) and [document format](../templates/profile/README.md).
