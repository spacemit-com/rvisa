# Mapping Revision History

## ime-main revision 1 — initial profile

| Property | Value |
| --- | --- |
| Profile | `ime-main`, mapping revision 1, status `draft` |
| RVISA revision | 0.2.0 |
| Upstream source | `riscv/integrated-matrix-extension` @ `6effbcae3204e5a8a9c9d15ff53959918144870c`, `src/integrated-matrix.adoc`, accessed 2026-11-05 |

### Scope established

* Declared subset: rank-2 `tmma` with signed `int8` inputs and an `int32` accumulator, realized by `vqmmacc.vv` (`Zvvi8i32mm`, `W = 4`).
* Single microtile geometry: `VLEN = 1024`, `vtype.vsew = 32`, `lambda = 4`, `LMUL = 1`, therefore `M = N = 8`, `K_eff = 16`, `EMUL_C = 2`, compute `vl = 32`.
* Rules `IME-TMMA-I8I32` and `IME-TMMA-I8I32-K0`; `valid_k` restricted to `0` and multiples of 16.
* Register model: one register per input fragment, a 2-register accumulator group aligned to `EMUL_C`, disjointness of the accumulator group from both input groups, no spill sequence in this revision.
* Numerical contract: exact integer products with modular `int32` accumulation; `ordered` and `tree` are bit-identical.

### Deliberate omissions and unresolved items

* Unsigned input rows of the integer encoding map cannot be expressed by `tmma`; input signedness remains an open contract.
* Rank-3 batch pairing, partial K fragments, non-multiple `K`, and layouts other than `rowmajor`/`colmajor`/`rowmajor` are diagnosed rather than lowered.
* Fragment staging through memory (tile load/store, im2col) is excluded; the order-preserving tile load is recorded as an available instruction so a later revision can define the transfer contract without re-reading the source.
* The pinned text states no source-snapshot rule for the multiply-accumulate instruction; the profile resolves this by a disjointness requirement rather than by inference.
* No ABI statement exists for tile fragments across function boundaries.

### Compatibility

This is the first revision, so there is no migration path. A later revision that changes the geometry parameter set, the layout triple, the register grouping, the `valid_k` domain, or the spill policy changes the mapping contract and requires a new `mapping_revision` with the impact analysis of the [revision policy](../../../contract.md#revision-policy). Editorial changes that preserve those properties do not.

### Verification state

Documentation checks passed; IR legality, compilation, instruction inspection, numerical evaluation, simulator execution, device execution, and performance are recorded as `not-run` in [conformance.yaml](conformance.yaml). Replacing a `not-run` entry requires evidence at that layer, not a restatement of the source.
