# RISC-V Virtual ISA

[English](README.md) | [简体中文](README_CN.md)

RVISA（RISC-V Virtual ISA）定义面向 RISC-V 标量、向量与矩阵计算的虚拟指令语法。其设计从 RISC-V 矩阵扩展的指令、操作数和寄存器组织出发，覆盖 [IME](https://github.com/riscv/integrated-matrix-extension)、[VME](https://github.com/riscv/riscv-isa-manual/pull/2997)、[AME](https://github.com/riscv/riscv-attached-matrix-extension) 等扩展，并结合 RVV。

RVISA 的目标抽象层次略高于 [NVIDIA PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/)，低于 [NVIDIA cuTile](https://docs.nvidia.com/cuda/cutile-python/)。它从 RISC-V 矩阵扩展出发，采用以 [RVV Intrinsics](https://github.com/riscv-non-isa/riscv-rvv-intrinsic-doc) 为参考的记法，表达带类型的操作、操作数角色及寄存器组约束。版本化目标 profile 明确定义这些操作到目标指令序列、寄存器类别与寄存器组的映射。

[tile 映射](spec/types/tile.md#register-representation)优先使用目标提供的寄存器，包括向量寄存器及寄存器组、矩阵操作数寄存器和累加寄存器。一个 tile 可以跨多个寄存器，也可以按照指令形状进行分片。[映射保证](mappings/contract.md#mapping-guarantees)明确各 profile 的合法指令序列、分组、分配约束和数据搬运，同时允许实现在这些约束内选择具体方案。

本仓库包含 RVISA 指令语法、类型与操作数定义、目标映射合同、MLIR 设计文档，以及参考算例，面向架构设计者、编译器实现者、算子开发者和规范贡献者。

## 矩阵扩展上游仓库

| 扩展 | 上游仓库 | RVISA 映射文档 |
| --- | --- | --- |
| Integrated Matrix Extension（[IME](https://github.com/riscv/integrated-matrix-extension)） | [riscv/integrated-matrix-extension](https://github.com/riscv/integrated-matrix-extension) | [映射要求](mappings/ime/README.md) |
| Vector-Matrix Extension（[VME](https://github.com/riscv/riscv-isa-manual/pull/2997)） | [riscv/riscv-vme](https://github.com/riscv/riscv-vme) | [映射要求](mappings/vme/README.md) |
| Attached Matrix Extension（[AME](https://github.com/riscv/riscv-attached-matrix-extension)） | [riscv/riscv-attached-matrix-extension](https://github.com/riscv/riscv-attached-matrix-extension) | [映射要求](mappings/ame/README.md) |

向量矩阵扩展的规范正文见 [RISC-V ISA Manual 中的 Zvt 提案](https://github.com/riscv/riscv-isa-manual/pull/2997)。各[映射 profile](mappings/README.md)分别记录确切的上游版本、寄存器与操作数要求，以及验证证据。

## 规范

[RVISA 规范手册](spec/README.md)是主要阅读入口。

| 部分 | 内容 |
| --- | --- |
| [介绍与术语](spec/introduction.md) | 范围、抽象边界和术语 |
| [核心模型](spec/core/README.md) | 执行、值、布局、内存、数值和诊断 |
| [类型](spec/types/README.md) | 标量、向量、tile、mask 和内存类型 |
| [操作数](spec/operands/README.md) | 操作数角色、求值阶段和约束 |
| [操作](spec/operations/README.md) | 虚拟操作签名、语义、默认值与诊断 |
| [目标映射](mappings/README.md) | 版本化的寄存器、操作数和 lowering 合同 |
| [符合性](spec/conformance.md) | 实现声明的要求和验证证据 |

核心规范定义可观察行为；MLIR dialect 将其表示为编译器 IR；目标 profile 规定这些行为在具体架构上的实现条件。

草案已定义 [vector/tile 类型](spec/types/vector.md)、[矩阵与分块缩放运算](spec/operations/matrix/README.md)、[访存与卷积展开](spec/operations/memory/README.md)，以及[编译器管理的传输](spec/core/transfers.md)。[设计基线](spec/design-baseline.md)记录定义来源，[核心设计用例](conformance/cases/core-designs.md)给出可独立核对的预期结果。

## 项目状态

规范处于**工作草案**阶段，范围和未决事项见[规范状态](spec/status.md)，版本标识见 [VERSION](VERSION)。

| 组件 | 状态 |
| --- | --- |
| 核心规范与操作参考 | 已写入关键合同的工作草案，未决事项单独跟踪 |
| 目标映射合同 | 开发中，尚未登记具体 profile |
| [MLIR dialect](mlir/README.md) | TBD |
| [参考算例](demos/README.md) | 已描述计算问题，每个算例都提供 RVISA 记法源形式 |

参考算例的源形式为 RVISA 记法（`<name>.rvisa`），可另附 Python 或 C++ 宿主机形式。本版本不包含源语言前端实现，因此记法形式不被编译或执行。

文档状态与实现支持分别记录，变更见 [CHANGELOG.md](CHANGELOG.md)。

## 仓库组织

- [spec/](spec/README.md)：规范章节与参考资料。
- [mappings/](mappings/README.md)：标准及厂商目标 profile。
- [mlir/](mlir/README.md)：编译器表示与 dialect 设计。
- [demos/](demos/README.md) 与 [conformance/](conformance/README.md)：参考算例与共享验证要求。
- [rfcs/](rfcs/README.md)：设计提案与决议记录。
- [schemas/](schemas/README.md)、[tools/](tools/README.md) 与 [tests/](tests/README.md)：元数据与仓库维护。

## 贡献

编辑约定、变更提案与审查要求见 [CONTRIBUTING.md](CONTRIBUTING.md)，维护领域见 [MAINTAINERS.yaml](MAINTAINERS.yaml)。参与者遵循[行为准则](CODE_OF_CONDUCT.md)。

## 许可证

除另有说明外，项目文档与代码采用 [Apache License, Version 2.0](LICENSE)。第三方材料保留其适用条款与署名。
