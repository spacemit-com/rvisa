# Mapping Revision History

## vme-main revision 1 — initial profile

| Property | Value |
| --- | --- |
| Profile | `vme-main`, mapping revision 1, status `draft` |
| RVISA revision | 0.2.0 |
| Upstream source | `riscv/riscv-isa-manual`, branch `zvt`, `src/unpriv/zvt.adoc` @ `98b0e96fb240a0b6a54bf814fc2f6a139a409e10`, extension version 0.4, accessed 2026-11-05 |

### Scope established

* Declared subset: rank-2 `tmma` with signed `int8` inputs and an `int32` accumulator, realized by `vtmms.tvv` with `vtype.altfmt = 1` (`Zvti8i32mm`).
* Single geometry: `VLEN = 1024`, `SEW = 8`, `TWIDEN = 4`, `TE = 32`, `ETE = 32`, `EVE = 128`, `KMAX = 4`, `LMUL = 1`, `tm = tn = 32`.
* Axis correspondence: `ALayout = colmajor` and `BLayout = rowmajor`, because the instruction computes `C += A^T × B` with A and B as `[K,M]` and `[K,N]` row sets.
* Any `K` and any `valid_k ∈ [0,K]` are supported; the final fragment programs a smaller `tk`.
* Register model: four row registers per operand inside one eight-register window, even offsets for A and odd offsets for B, one `TEW = 32` tile as accumulator, 32 `vtle32`/`vtse32` row transfers for accumulator save and restore.
* Numerical contract: exact integer accumulation restricted to results representable in `int32`.

### Deliberate omissions and unresolved items

* The pinned source does not define integer accumulator overflow; the wider range is unsupported, not wrapped or saturated by inference.
* Only the signed × signed encoding row is declared; mixed-sign and unsigned rows have no operand in `tmma`.
* Rank-3 batch pairing, several-tile output fragmentation, and non-`TEW = 32` tile views are excluded.
* The `altfmt = 1` spelling of `msetmtypei` is provisional in the source; the profile states the architectural effect instead of relying on the token sequence.
* `riscv/riscv-vme` at `5570c7b2b8e2d5b28b3627a0bbed57bf3afb4e6a` contains no Zvt text, so the family-guide link does not lead to a specification; reconciling that link is an open documentation action, not a change made here.

### Pin history

* The upstream pin was advanced from `31a76665e9fc532199c21b99f1311bc8345bc532` to `98b0e96fb240a0b6a54bf814fc2f6a139a409e10` during review. The later commit deletes a stale sentence stating that `tm` or `tk` becomes zero when `mtwiden = 0`, which contradicted the illegal-instruction rule for the same condition that this profile's preconditions rely on. Impact analysis: the commit touches only that sentence in `src/unpriv/zvt.adoc`; no requirement, geometry pin, operand rule, or numerical statement of this profile changes, so `mapping_revision` remains 1 and no other document is affected beyond the recorded revision.

### Compatibility

First revision; no migration path. A later revision that changes the geometry pins, the accumulator tile choice rules, the `valid_k` handling, the operand-offset rule, or the numerical domain changes the mapping contract and requires a new `mapping_revision` under the [revision policy](../../../contract.md#revision-policy).

### Verification state

Documentation checks passed; IR legality, compilation, instruction inspection, numerical evaluation, simulator execution, device execution, and performance are recorded as `not-run` in [conformance.yaml](conformance.yaml).
