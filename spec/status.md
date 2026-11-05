# Specification Status

## Document state

RVISA is a **working draft**. [VERSION](../VERSION) records the current specification version. The current text may change through review; it is not a ratified RISC-V International specification.

The manual defines concrete type, operand, and operation contracts alongside the register representation and mapping policies. The [design baseline](design-baseline.md) records the fixed earlier source revision and the adopted definitions. [RFC 0001](../rfcs/0001-instruction-and-register-mapping-contracts.md) covers instruction/register mapping, [RFC 0002](../rfcs/0002-core-operation-contracts.md) covers the core types and operations, and [RFC 0003](../rfcs/0003-programmer-expressible-tile-layouts.md) covers programmer-expressible tile optimization and linear layouts. These remain draft proposals.

A defined mapping requirement does not establish a supported target or confer the profile maturity state stable. Source-language frontend implementations are outside this revision. Reference workloads in [demos/](../demos/README.md) include RVISA-notation source forms, with execution support tracked separately.

## Component status

| Component | State | Entry point |
| --- | --- | --- |
| Core models, types, and operand rules | Working draft with concrete capacity, shape, stage, and effect rules | [Specification](README.md) |
| Tile layout and optimization | Rank-1 through rank-N carriers, exact view semantics, anchor regions, and public-expression requirements defined in draft | [Linear layouts](core/linear-layout.md), [tile optimization](core/tile-optimization.md) |
| Key operations | Signatures, semantics, defaults, diagnostics, and mapping obligations documented | [Operations](operations/README.md) |
| Additional scalar/vector/tile vocabulary | Common value/role rules documented; specified numerical and interface details remain open | [Operation families](operations/README.md) |
| Target mapping method | Working draft | [Mapping contract](../mappings/contract.md) |
| Concrete [IME](https://github.com/riscv/integrated-matrix-extension)/[VME](https://github.com/riscv/riscv-isa-manual/pull/2997)/[AME](https://github.com/riscv/riscv-attached-matrix-extension) profiles | Draft profiles registered; implementation evidence tracked per profile | [Mappings](../mappings/README.md) |
| MLIR dialect | TBD | [MLIR](../mlir/README.md) |
| Reference workloads | RVISA-notation source forms available; executable implementations TBD | [Demos](../demos/README.md) |
| Conformance cases | Specification-level cases with expected values/diagnostics | [Core design cases](../conformance/cases/core-designs.md) |
| Executable conformance tools | TBD | [Conformance](../conformance/README.md) |
| Documentation site | MkDocs configuration and assembly tool available | [Tools](../tools/README.md) |

Document review, implementation availability, and verification evidence are independent. A working draft can define a requirement before an implementation exists.

## Open contracts

| Topic | Unresolved part and primary location |
| --- | --- |
| Vector source types | Public fractional-LMUL and mask spelling; aggregate/grouped bridges in [Vector Types](types/vector.md) |
| Configuration | Dynamic-request return value of [vconfig](operations/control/vconfig.md#provisional-return-contract); behavior outside the defined full/tail domain |
| Grouped access and packing | Complete carrier, coordinate, bounds, and memory-overload contracts for [vector operations](operations/vector/README.md#computation-vocabulary) and [vector memory](operations/memory/vector-memory.md#other-overloads-and-open-boundaries) |
| Extended stores | Complete address contracts for [vsstore and tsstore](operations/memory/extended-stores.md) |
| Vector numerical operations | Reduction order/special values, viota dtype/range, approximation accuracy, and complete ordinary arithmetic/conversion policies |
| Tile reductions and broadcasting notation | treduce_sum axes/result/singletons/numerics and complete broadcast tag notation in [Tile Operations](operations/tile/README.md#shape-and-layout-operations) |
| Matrix numerics | Remaining rounding/special-value details for ordinary tmma/vmadot and declared FMA/format policies for scaled accumulation; explicit scaling-rounding points are already defined |
| Low-precision formats and storage | Complete format/conversion coverage and packed FP4 memory ABI in [Element Types](types/element-types.md) |
| Control, ABI, and runtime | Full negative-step range semantics, cross-compilation-unit calling conventions, host invocation, and cross-program synchronization |
| Extended matrix forms | Concrete source syntax for explicit axis binding; scaled-MMA factor/scale-axis extension remains separate from the compact form |
| Layout implementation | Dialect encodings, concrete profile anchor constraints, cost selection, and executable public-expression reconstruction |
| IR and metadata | Detailed dialect representation and versioned metadata schemas |
| Target realization | Selected source revisions, legal sequences, register classes/groups, resource policies, supported subsets, and verification evidence |

An open contract must be resolved explicitly in its primary definition and reflected in affected IR descriptions, mappings, demos, and verification cases. A profile cannot silently choose an unqualified interpretation and claim general conformance. The [RFC process](../rfcs/README.md) records material decisions.

## Verification

Documentation review covers structure, metadata syntax, terminology, equations, and independently derived case expectations. The [core](../conformance/cases/core-designs.md) and [linear-layout](../conformance/cases/linear-layout.md) cases are verification obligations, not reports of implementation passes.

Executable compiler, target, and device conformance has not been established. Reports must distinguish mathematical checks, numerical checks under a named policy, IR verification, compilation, instruction/register inspection, execution, and performance.
