# Vector Operations

Vector operations preserve the distinction between scalable capacity, inferred fixed-length representation, and separate fixed-length groups. Their semantics depend on logical values and configuration rather than an assumed register count.

## Defined operations

| Operation | Definition |
| --- | --- |
| [vshape](vshape.md) | Element-preserving value views and symbolic shape inference |
| [vcast](vcast.md) | Numerical conversion with mode-preserving capacity/group rules |
| [vmadot](vmadot.md) | Cartesian group matrix multiplication, accumulator first |
| [vconfig](../control/vconfig.md) | Logical full/tail configuration and state scope |
| [vload / vstore](../memory/vector-memory.md) | Flat vector memory access and bounds |

## Computation vocabulary

The following contracts establish roles and value behavior. Numerical or packing details marked open must be resolved before a complete implementation claim.

| Operation | Operand/result relationship | Contract boundary |
| --- | --- | --- |
| vzero(dtype, group=None) | Zero vector constrained by configuration and expected type | dtype/group are static; operation groups are distinct from type LMUL |
| vmacc(acc,x,y) | Corresponding-lane widened FMA, returning an accumulator-type vector | Preserve input correspondence and accumulation precision; specify rounding/special values |
| vbroadcast(value,n) | Replicate the value into n leading logical groups | n is static; retain each group's element order and metadata |
| vselect(mask,a,b) | Per-coordinate selection with compatible shapes and legal scalar broadcast | Does not suppress prior operand effects |
| vmin / vmax | Elementwise minimum/maximum | NaN and signed-zero behavior require an explicit numerical contract |
| vexp / vlog | Elementwise natural exponential/logarithm | Accuracy, domain, and special values require an explicit contract |
| vsqrt / vrsqrt / vabs | Square root, reciprocal square root, and absolute value | Dtype and approximation rules require explicit coverage |
| vreduce_sum / max / min / mul | Reduction of the complete vector carrier to a scalar | Includes fill elements; order, special values, and supported formats remain to be completed |
| viota | Lane-index value construction | Result dtype and representable index range remain provisional |
| vpack(value,group_len) | Group-interleaving value transformation | Complete coordinate map and grouped-type bridge remain to be specified |
| vpack(memory,options...) | Memory packing variant | Separate addresses, ownership, Read/Write effects, and option spelling remain to be specified |

The spelling vreduce_sum(value), for example, does not add an implicit active-length argument. Choose appropriate fill/masking when an algorithm needs a reduction identity. A fill that was suitable before a nonlinear transform may cease to be suitable afterward.

Tile data first follows [complete flattening](../../types/tile.md#relationship-to-vectors). Ordinary vector results retain vector identity; scalar reductions do not restore tile shape.

## Configuration and target legality

Pure calculations preserve applicable configuration and target-state dependencies. A memory-packing overload cannot inherit Pure from a value overload.

A vector-family name does not establish a standard RVV single-instruction implementation. Each profile declares geometry, numerical support, instruction sequences, register classes/groups, masks, overlap restrictions, and configuration effects. The unresolved bridges above must be diagnosed or identified as an explicit extension, not filled in from an incidental target layout.

See [Vector Types](../../types/vector.md), [open contracts](../../status.md), and [extended stores](../memory/extended-stores.md).
