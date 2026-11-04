# Attention

This workload combines matrix products with row-wise normalization and masking. A reference form is scaled dot-product attention:

```text
S = Q * transpose(K) / sqrt(d)
P = softmax(mask(S))
O = P * V
```

Here d is the query/key feature extent. The mask convention and behavior of fully masked rows are part of the selected workload contract.

## Numerical contract

Define input/accumulation formats, scaling, exponential/normalization accuracy, reduction order, and output conversion. A blocked or online formulation must account for rescaling earlier partial results.

Optional outputs such as log-sum-exp require their own defined behavior. Empty rows, zero lengths, and all-masked regions must be specified rather than inferred from a mathematical softmax expression.

## Mapping concerns

Matrix execution interacts with reductions, normalization, value-layout changes, and memory scheduling. Include the transfer and temporary-storage requirements between these phases.

Record the register classes/groups for matrix inputs, score fragments, reduction state, normalization, and output accumulation. Inspect the instruction sequences and legal reuse or spill/staging policy across phase boundaries under the selected profile.

## Verification cases

Compare with an independent dense reference over the supported domain. Cover masks, sequence-length tails, multiple heads, extreme logits, and blocked rescaling behavior.

Python/C++ source forms are TBD. See [numerics](../../spec/core/numeric-model.md), [tmma](../../spec/operations/matrix/tmma.md), [vector reductions](../../spec/operations/vector/README.md#computation-vocabulary), and the [workload index](../README.md).
