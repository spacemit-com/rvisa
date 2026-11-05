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

The source form is described in [Source form](#source-form). See [numerics](../../spec/core/numeric-model.md), [tmma](../../spec/operations/matrix/tmma.md), [vector reductions](../../spec/operations/vector/README.md#computation-vocabulary), and the [workload index](../README.md).

## Source form

[attention.rvisa](attention.rvisa) expresses one 16x16 block of scaled dot-product
attention. Two of its steps have no defined spelling in this revision, and the
file states them as contracts instead of inventing syntax:

- mask application — the public mask spelling is an open contract in
  [Mask types](../../spec/types/mask.md);
- row-wise normalization — no defined operation reduces along one tile axis, and
  the tile reduction is provisional in [the tile vocabulary](../../spec/operations/tile/README.md#shape-and-layout-operations).

~~~text
s = tmma(q, k, 0, ALayout=rowmajor, BLayout=colmajor, CLayout=rowmajor,
         mode=reduce, reduce_order=ordered, valid_k=16)
s = tmul(s, scale)                        # scale = 1/sqrt(d), a static scalar

# masked scores and row-wise softmax: stated, not spelled (see above)

o = tmma(p, v, 0, ALayout=rowmajor, BLayout=colmajor, CLayout=rowmajor,
         mode=reduce, reduce_order=ordered, valid_k=16)
tstore(o_view, origin=[0, 0], value=o)
~~~

Notation only: nothing compiles or executes this file (this revision has no frontend). `demo.yaml` records the metadata.

Not covered: causal and fully masked rows, sequence-length tails, multiple heads,
extreme logits, blocked or online softmax rescaling, log-sum-exp outputs, and
reuse of the first-phase accumulator.
