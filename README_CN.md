# RVISA 规范

[English](README.md) | [简体中文](README_CN.md)

RVISA 是面向 RISC-V 标量、向量与矩阵计算的虚拟指令集，定义统一的编程模型，用于表达计算并映射到 RVV 及 [IME](https://github.com/riscv/integrated-matrix-extension)、[VME](https://github.com/riscv/riscv-isa-manual/pull/2997)、[AME](https://github.com/riscv/riscv-attached-matrix-extension) 等矩阵扩展。

本仓库包含 RVISA 语言规范、目标映射合同、前端与 MLIR 设计文档，以及参考算例，面向架构设计者、编译器实现者、算子开发者和规范贡献者。

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
| [操作](spec/operations/README.md) | 操作分类和定义格式 |
| [目标映射](mappings/README.md) | 版本化的寄存器、操作数和 lowering 合同 |
| [符合性](spec/conformance.md) | 实现声明的要求和验证证据 |

核心规范定义可观察行为；前端以源语言表达这些行为；MLIR dialect 将其表示为编译器 IR；目标 profile 规定这些行为在具体架构上的实现条件。

## 项目状态

规范处于**工作草案**阶段，范围和未决事项见[规范状态](spec/status.md)，版本标识见 [VERSION](VERSION)。

| 组件 | 状态 |
| --- | --- |
| 核心规范与操作参考 | 开发中 |
| 目标映射合同 | 开发中，尚未登记具体 profile |
| [MLIR dialect](mlir/README.md) | TBD |
| [Python 与 C++ 前端](frontends/README.md) | TBD |
| [参考算例](demos/README.md) | 已描述计算问题，源程序实现 TBD |

文档状态与实现支持分别记录，变更见 [CHANGELOG.md](CHANGELOG.md)。

## 仓库组织

- [spec/](spec/README.md)：规范章节与参考资料。
- [mappings/](mappings/README.md)：标准及厂商目标 profile。
- [mlir/](mlir/README.md) 与 [frontends/](frontends/README.md)：编译器表示与语言绑定。
- [demos/](demos/README.md) 与 [conformance/](conformance/README.md)：参考算例与共享验证要求。
- [rfcs/](rfcs/README.md)：设计提案与决议记录。
- [schemas/](schemas/README.md)、[tools/](tools/README.md) 与 [tests/](tests/README.md)：元数据与仓库维护。

## 贡献

编辑约定、变更提案与审查要求见 [CONTRIBUTING.md](CONTRIBUTING.md)，维护领域见 [MAINTAINERS.yaml](MAINTAINERS.yaml)。参与者遵循[行为准则](CODE_OF_CONDUCT.md)。

## 许可证

除另有说明外，项目文档与代码采用 [Apache License, Version 2.0](LICENSE)。第三方材料保留其适用条款与署名。
