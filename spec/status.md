# Specification Status

## Document state

RVISA is a **working draft**. [VERSION](../VERSION) records the current specification version. The current text may change through review; it is not a ratified RISC-V International specification.

The core chapters establish the conceptual and semantic baseline under discussion. Detailed operation signatures, complete binding coverage, and concrete target profiles are still being developed.

## Component status

| Component | State | Entry point |
| --- | --- | --- |
| Core models, types, and operand rules | Working draft | [Specification](README.md) |
| Operation reference | Family contracts documented; detailed per-operation definitions in development | [Operations](operations/README.md) |
| Target mapping method | Working draft | [Mapping contract](../mappings/contract.md) |
| Concrete [IME](https://github.com/riscv/integrated-matrix-extension)/[VME](https://github.com/riscv/riscv-isa-manual/pull/2997)/[AME](https://github.com/riscv/riscv-attached-matrix-extension) profiles | Not yet registered | [Mappings](../mappings/README.md) |
| MLIR dialect | TBD | [MLIR](../mlir/README.md) |
| Python frontend | TBD | [Python](../frontends/python/README.md) |
| C++ frontend | TBD | [C++](../frontends/cpp/README.md) |
| Reference workload implementations | TBD | [Demos](../demos/README.md) |
| Executable conformance and maintenance tools | TBD | [Conformance](../conformance/README.md), [tools](../tools/README.md) |

Document review, implementation availability, and verification evidence are independent. A working draft can define a requirement before an implementation exists.

## Open contracts

| Topic | Unresolved part |
| --- | --- |
| Vector source types | Public fractional-LMUL and mask spelling; aggregate/grouped type bridges |
| Configuration | Dynamic `vconfig` return-value convention |
| Extended stores | Complete address contracts for `vsstore` and `tsstore` |
| Numerical operations | Operation-specific special-value, reduction, and approximation contracts |
| Language and ABI | Complete source subsets, cross-compilation-unit and runtime interfaces |
| IR and metadata | Detailed dialect representation and versioned metadata schemas |
| Target realization | Selected source revisions, supported subsets, resources, and execution evidence |

An open contract must be resolved explicitly in its primary definition and reflected in affected bindings, mappings, and verification cases. The [RFC process](../rfcs/README.md) records material decisions.

## Verification

Current repository checks cover documentation structure, metadata syntax, and editorial consistency. Executable frontend, compiler, target, and device conformance has not been established. Reports must state the verified layer and applicable versions.
