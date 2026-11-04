# Reference Workloads

Reference workloads connect the RVISA programming model to common numerical kernels. Each workload defines the computation, data contract, mapping concerns, and verification cases shared by its Python and C++ forms.

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

Each implemented workload contains `kernel.py`, `kernel.cpp`, and a `demo.yaml` record alongside its README. Both forms implement the same input/output and numerical contract. Language-specific syntax is described by the [frontends](../frontends/README.md).

The metadata identifies the workload, core version, required operations/profiles, and verification state. Execution instructions specify the actual implementation and runtime they use.

## Verification

Reuse [conformance cases](../conformance/README.md) where the same contract applies. State the reference method, precision, numerical comparison, boundary cases, and target conditions.

A workload demonstrates a specified use of RVISA; it does not extend the language contract or establish performance portability.
