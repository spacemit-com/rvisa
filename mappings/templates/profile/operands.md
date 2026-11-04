# Operand Mapping

Each supported source operation defines an explicit correspondence between logical operands/results and target operands.

| Item | Required definition |
| --- | --- |
| Source identity | Operation and operand identifiers, roles, and specification version |
| Type and coordinates | Element types, shapes, grouping, layouts, and evaluation stages |
| Target representation | Register domain/group, immediate, descriptor, or implicit state |
| Coordinate relation | Logical index to register/lane or target matrix coordinate |
| Validity | Alignment, overlap, range, grouping, and destructive-update constraints |
| Effects | Reads, writes, configuration interactions, and clobbers |
| Evidence | Source sections, requirement identifiers, and positive/negative cases |

Specify accumulator initialization and result placement as precisely as input placement. Record packing, padding, transfers, and any one-to-many or many-to-one correspondence.

The [register model](registers.md) defines shared resources; [lowering](lowering.md) defines their use over an instruction sequence; [numerics](numerics.md) defines acceptable arithmetic.
