# Reference Workloads

Reference workloads illustrate RVISA virtual instruction notation and its target instruction/register mappings through common numerical kernels. Each workload defines the computation, data contract, mapping concerns, and verification cases shared by its Python and C++ forms.

**Source implementation status: TBD.** The documents below describe the workloads; they are not executable kernel packages.

| Workload | Coverage |
| --- | --- |
| [Vector addition](vector-add/README.md) | Vector capacity, elementwise computation, and tails |
| [GEMM](gemm/README.md) | Matrix coordinates, accumulation, and tiled memory access |
| [GEMM with epilogue](gemm-epilogue/README.md) | Bias/activation, value views, and domain transitions |
| [Block-scaled GEMM](blockscale-gemm/README.md) | Scale axes, block boundaries, and numerical ordering |
| [Convolution](conv2d/README.md) | Convolution coordinates, padding, and matrix lowering |
| [Attention](attention/README.md) | Matrix operations, reductions, normalization, and masks |

## Paired source forms

Each implemented workload contains `kernel.py`, `kernel.cpp`, and a `demo.yaml` record alongside its README. Both forms express the same typed operations, operand roles, grouping constraints, and input/output and numerical contract. Each demo documents the source conventions it uses and identifies any external compiler or runtime dependencies.

The metadata identifies the workload, core version, required operations/profiles, and verification state. Execution instructions specify the actual implementation and runtime they use.

## Target realization records

A target-specific demo identifies its profile revision, virtual operations, target instruction sequences, and register classes/groups for inputs, accumulators, results, and temporaries. It records fragment geometry, configuration changes, transfers, and any permitted spills or staging. A generic example may describe these obligations without claiming an implemented target mapping.

Concrete register numbers may be shown for one generated program, with the profile's actual allocation constraints stated separately. Python/C++ notation examples do not establish an available frontend or runtime.

## Verification

Reuse [conformance cases](../conformance/README.md) where the same contract applies. State the reference method, precision, numerical comparison, boundary cases, and target conditions. Inspect emitted instructions and register constraints separately from numerical results; report implementation and execution evidence only when obtained.

A workload demonstrates a specified use of RVISA; it does not extend the virtual instruction contract or establish performance portability.
