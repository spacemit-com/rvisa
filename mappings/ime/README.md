# [IME](https://github.com/riscv/integrated-matrix-extension) Mappings

Vector-register representations are central to [IME](https://github.com/riscv/integrated-matrix-extension) mappings. Input packing, accumulator grouping, matrix geometry, and configuration interact with the surrounding vector program.

## Mapping requirements

- Source and accumulator element widths and their grouping relationships.
- Logical-to-register coordinates, operand overlap/alignment, and packing.
- Configuration transitions, active regions, numerical reduction, and vector epilogues.

Use the [Integrated Matrix Extension source material](https://github.com/riscv/integrated-matrix-extension) as an entry point. Each profile fixes its own source revision and capabilities; it must not combine incompatible draft or vendor definitions.

## Profile index

The [profile index](profiles/README.md) records concrete mappings. Profiles follow the [shared contract](../contract.md) and [document format](../templates/profile/README.md).
