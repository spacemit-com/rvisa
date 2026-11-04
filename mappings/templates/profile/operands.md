# Operand Mapping

Each supported virtual operation defines an explicit correspondence between its typed operands/results and operands in the profile's target instruction sequence.

| Item | Required definition |
| --- | --- |
| Source identity | Operation and operand identifiers, roles, and specification version |
| Type and coordinates | Element types, shapes, grouping, layouts, and evaluation stages |
| Target representation | Register class/group, immediate, descriptor, or implicit state, qualified by sequence step |
| Coordinate relation | Logical index to register/lane or target matrix coordinate |
| Validity | Alignment, overlap, range, grouping, operand ties, destructive updates, and any fixed-register constraints |
| Effects | Reads, writes, configuration interactions, and clobbers |
| Evidence | Source sections, requirement identifiers, and positive/negative cases |

Specify accumulator initialization and result placement as precisely as input placement. Record packing, padding, transfers, and any one-to-many or many-to-one correspondence. Distinguish architectural operand positions and class/group requirements from example physical register assignments.

The [register model](registers.md) defines shared resources; [lowering](lowering.md) defines their use over an instruction sequence; [numerics](numerics.md) defines acceptable arithmetic.
