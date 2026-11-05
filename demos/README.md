# Reference Workloads

Reference workloads illustrate RVISA virtual instruction notation and its target instruction/register mappings through common numerical kernels. Each workload defines the computation, data contract, mapping concerns, and verification cases, and states its source form.

**Source status: all six workloads have an RVISA-notation source form.** This revision contains no frontend, so those files are specification-level notation rather than executable programs.

| Workload | Coverage | Source forms |
| --- | --- | --- |
| [Vector addition](vector-add/README.md) | Vector capacity, elementwise computation, and tails | [vector-add.rvisa](vector-add/vector-add.rvisa) · [demo.yaml](vector-add/demo.yaml) |
| [GEMM](gemm/README.md) | Matrix coordinates, accumulation, and tiled memory access | [gemm.rvisa](gemm/gemm.rvisa) · [demo.yaml](gemm/demo.yaml) |
| [GEMM with epilogue](gemm-epilogue/README.md) | Bias/activation, value views, and domain transitions | [gemm-epilogue.rvisa](gemm-epilogue/gemm-epilogue.rvisa) · [demo.yaml](gemm-epilogue/demo.yaml) |
| [Block-scaled GEMM](blockscale-gemm/README.md) | Scale axes, block boundaries, and numerical ordering | [blockscale-gemm.rvisa](blockscale-gemm/blockscale-gemm.rvisa) · [demo.yaml](blockscale-gemm/demo.yaml) |
| [Convolution](conv2d/README.md) | Convolution coordinates, padding, and matrix lowering | [conv2d.rvisa](conv2d/conv2d.rvisa) · [demo.yaml](conv2d/demo.yaml) |
| [Attention](attention/README.md) | Matrix operations, reductions, normalization, and masks | [attention.rvisa](attention/attention.rvisa) · [demo.yaml](attention/demo.yaml) |

## Source forms

An implemented workload carries a `demo.yaml` record and one or more source forms alongside its README. The primary source form is RVISA notation in a `<name>.rvisa` file: virtual operations, operand roles, and register-representation expectations written in the notation this manual defines. A host Python or C++ form may accompany it to make a workload checkable, and both express the same typed operations, operand roles, grouping constraints, and input/output and numerical contract.

A `.rvisa` file is notation, not a program: without a frontend it is neither compiled nor executed, and it establishes no available runtime. Each demo documents the source conventions it uses, and any host form it adds identifies its external compiler or runtime dependencies.

The metadata identifies the workload, core version, required operations/profiles, and verification state.

Core operand stages and source-default normalization are defined in [Operand Evaluation Stages](../spec/operands/stages.md). Reuse the [core design cases](../conformance/cases/core-designs.md) for shared behavior; a demo must not silently choose an unresolved reduction or packing contract.

Tile-level optimizations in a workload have an equivalent public expression under [RVISA-TILE-EXPR-1](../spec/core/tile-optimization.md#expressibility-requirement). Record explicit layout/fragment choices alongside the form left for compiler inference; compare their semantics before comparing performance.

## Target realization records

A target-specific demo identifies its profile revision, virtual operations, target instruction sequences, and register classes/groups for inputs, accumulators, results, and temporaries. It records fragment geometry, configuration changes, transfers, and any permitted spills or staging. A generic example may describe these obligations without claiming an implemented target mapping.

Concrete register numbers may be shown for one generated program, with the profile's actual allocation constraints stated separately. Notation examples do not establish an available frontend or runtime.

## Verification

Reuse [conformance cases](../conformance/README.md) where the same contract applies. State the reference method, precision, numerical comparison, boundary cases, and target conditions. Inspect emitted instructions and register constraints separately from numerical results; report implementation and execution evidence only when obtained.

A workload demonstrates a specified use of RVISA; it does not extend the virtual instruction contract or establish performance portability.
