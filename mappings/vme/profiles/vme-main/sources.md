# Sources

## Pinned source

| Property | Value |
| --- | --- |
| Repository | <https://github.com/riscv/riscv-isa-manual> |
| Revision | `98b0e96fb240a0b6a54bf814fc2f6a139a409e10` (branch `zvt`) |
| Document | `src/unpriv/zvt.adoc`, chapter `Zvt Family of Vector Matrix Extensions, Version 0.4` |
| Accessed | 2026-11-05 |

The pinned revision is the branch tip at review time. It is one commit newer than the first revision examined, and that commit changes only text this profile relies on: `98b0e96f` ("Zvt: remove stale zero-result description for msettm/msettk", upstream PR #3466) deletes the sentence stating that `tm` or `tk` becomes zero when `mtwiden = 0`. That sentence contradicts the illegal-instruction rule for the same condition, which this profile's selection preconditions use, so the pin was advanced to the revision in which the contradiction is gone. No other part of `src/unpriv/zvt.adoc` changed in that commit, and no requirement, geometry pin, or numerical statement of this profile depends on the deleted text.

The checked-out branch is the branch whose tip is pinned above; `src/unpriv/matrix.adoc` in the same tree is an eight-line placeholder chapter and contributes no requirement.

## Repository consulted and not used

| Repository | Revision | Observation |
| --- | --- | --- |
| <https://github.com/riscv/riscv-vme> | `5570c7b2b8e2d5b28b3627a0bbed57bf3afb4e6a` (default branch `main`, also tag `riscv-isa-release-5570c7b-2026-07-29`) | The tree is a RISC-V manual build with `src/unpriv/matrix.adoc` stating "This chapter is a placeholder for forthcoming matrix extensions." A search of all `.adoc` files for `Zvt` and for the instruction mnemonics used here returns no match, and the three remote branches (`main`, `codex/update-riscv-docs-base-image`, `rpsene/update-github-action-versions`) carry no Zvt text. It is therefore **not** a source of this profile. |

The family guide links <https://github.com/riscv/riscv-vme> as VME source material. At the revision above that link does not lead to a specification; the normative text used here is the `zvt` branch of `riscv-isa-manual`. Reconciling the family-guide link with an actual source is an open documentation action, recorded as unresolved rather than silently changed here.

## Documents read

| Section | Used for |
| --- | --- |
| `Overview` | tile state, `TEW = SEW × TWIDEN`, `C[M,N] += A[K,M]^T × B[K,N]`, `KMAX ∈ {1,2,4}`, extension dependency table, computational-extension table (`Zvti8i32mm`, multiplicand widths, accumulator type) |
| `Overview` → `Matrix Tile State` | `TE` parameter, `TEW = 32` tiles `mt0`, `mt4`, `mt8`, `mt12`, `ETE`, `Zvt<N>t` |
| `Overview` → `Matrix Tile State` → `Tile Punning` | tile aliasing across `TEW`; recorded so that the profile can forbid accesses through a non-matching `TEW` |
| `Matrix Type (mtype) CSR` | CSR address `0xC23`, fields `tm[23:10]`, `tk[7:5]`, `mtwiden[1:0]`, `mtwiden = 0` meaning unconfigured |
| `Matrix-Multiply Operations` | `C[tm,tn] += A[tk,tm]^T × B[tk,tn]`; `tn = min(vl, ETE)`; vector register group layout of a `tk`-row operand; row separation `8/KMAX`; register-specifier divisibility by `LMUL` and `mod 8 < 8/KMAX` constraints |
| `Matrix Configuration Instructions` | `msetmtype`/`msetmtypei` behavior including the derived `vlmul`, `vma`/`vta` forcing, and `mtype = 0` when unconfigured; `vset[i]vl[i]` write `mtype = 0` |
| `Matrix Configuration Instructions` → `msettn`, `msettm` and `msettk`, `Supported SEW, TWIDEN, and KMAX values` | clamping rules, illegal-instruction conditions, and the `KMAX` table entry for `TEW = 32`, `SEW = 8`, `TWIDEN = 4` → `KMAX = 4` |
| `Tile Subset Specifier (TSS)` | tile, pattern, and index encoding; reserved indices `>= ETE` |
| `Load/Store Tile Subset to Memory` | `vtle8/16/32/64`, `vtse8/16/32/64`, `rs1` base and `rs2` TSS operands, contiguous transfers, body extent `[vstart, min(vl, ETE) - 1]`, alignment exceptions, reserved state when `mtwiden = 0` |
| `Move Tile Subset between Tile State and Vector Registers` | `vtmv.v.t vd, rs1`, `vtmv.t.v rs1, vs2`, same body/tail extent rule |
| `Matrix Arithmetic Instructions` | `vtfmm.tvv`, `vtfmm.alt.tvv`, `vtmmu.tvv`, `vtmms.tvv` and the `SEW`/`TWIDEN`/`altfmt`/operand-type table; `vs2` is A, `vs1` is B, `mtd` is C; no-op when `tm`, `tn`, or `tk` is zero; tail policy; exception flags |
| `Matrix Arithmetic Instructions` → `Matrix Arithmetic Instruction Encoding` | `OP-VE` encoding, tile number in `rd`, `t mod (16/NTiles) = 0` rule for `TEW = 32` |
| `Matrix Tile-Zero Instruction` | `vtzero mtd` writes zero over the `tm × tn` submatrix |
| `Context Status` | `mstatus.MS` / `vsstatus.MS`, `vtdiscard`, `mtype` as part of the vector context |

## Claims

| Claim | Section |
| --- | --- |
| The computational instruction computes `C[M,N] += A[K,M]^T × B[K,N]`, with A and B sourced from vector registers and C held in tile state. | `Overview`, `Matrix-Multiply Operations` |
| `KMAX = 4` for `SEW = 8`, `TWIDEN = 4`; `tk` is the number of dot-product terms per accumulator element and is at most `KMAX`. | `Supported SEW, TWIDEN, and KMAX values` |
| `tn = min(vl, ETE)` and `tm`/`tk` come from `mtype`; `msettn`/`msettm`/`msettk` clamp their arguments to `min(rs1, LMUL·EVE, ETE)` and `min(rs1, KMAX)` and write the clamped value back to `rd`. | `Matrix-Multiply Operations`, `msettn`, `msettm` and `msettk` |
| For `TEW = 32` there are four tiles, `mt0`, `mt4`, `mt8`, `mt12`, each `TE × TE` elements. | `Matrix Tile State` |
| A `tk`-row operand keeps each row in its own vector register group; rows are separated by `8/KMAX` vector registers; the group specifier must be a multiple of `LMUL` and, modulo 8, less than `8/KMAX`; all rows fit in one eight-register group. | `Matrix-Multiply Operations` |
| `vtmms.tvv` with `SEW = 8`, `TWIDEN = 4`, `altfmt = 1` denotes `int8 × int8 → int32` (`Zvti8i32mm`); `altfmt = 0` denotes `int8 × uint8`. | `Matrix Arithmetic Instructions` |
| If `tm`, `tn`, or `tk` is zero, a matrix arithmetic instruction performs no computation and updates no state; elements outside `[0,tm) × [0,tn)` are tail and handled tail-agnostically. | `Matrix Arithmetic Instructions` |
| `msetmtypei` writes `vl = 0`, sets `mtype.mtwiden` and `vtype.vsew`/`vtype.altfmt` from immediates, derives `vlmul`, forces `vma = vta = 1`, clamps `tk` and `tm`, and zeroes `mtype` when the matrix unit is unconfigured or `vtype` is invalid. | `Matrix Configuration Instructions` |
| `vsetvli` and `vsetivli` write zero to `mtype`. | `Matrix Configuration Instructions` |
| `msettm` and `msettk` raise *Illegal Instruction* when `mtwiden = 0`; `msettn` degenerates to `vsetvl` semantics in that case. | `msettn`, `msettm` and `msettk` |
| `vtle*`/`vtse*`/`vtmv*` move tile subsets with the TSS operand, transfer contiguously, use body elements `[vstart, min(vl, ETE) - 1]`, and are reserved when `mtwiden = 0`. | `Load/Store Tile Subset to Memory`, `Move Tile Subset between Tile State and Vector Registers` |
| Misaligned element addresses for tile subset loads and stores raise an address-misaligned or access-fault exception, and the precise exception model of the vector extension applies. | `Load/Store Tile Subset to Memory` |
| Executing an instruction that accesses tile state raises *Illegal Instruction* when `mstatus.MS` is `Off`; `vset*` and `mset*` do not access tile state. | `Zvt Context Status in mstatus` |

## Provisional and unresolved points in the source

* **Integer accumulator overflow.** The chapter defines the float matrix arithmetic rounding and exception rules in detail but states no overflow or saturation behaviour for the integer rows of `vtmms.tvv`/`vtmmu.tvv`. The [numerics](numerics.md) contract is therefore restricted to results representable in `int32` and records the wider case as unresolved; the profile does not invent a wrapping rule and does not borrow the IME or AME wording.
* **`msetmtypei` assembly spelling.** The source gives the recommended syntax as `msetmtypei eM[alt], wN` with `[alt]` described metasyntactically ("`alt` sets `altfmt=1` when present"). The exact token spelling for the `altfmt = 1` form is therefore not fixed by the text and is marked provisional; the profile states the architectural effect (an `altfmt = 1` `vtype` write) instead of relying on a spelling.
* **`TE` is an implementation parameter.** `TE = 32` is legal (`VLEN/4 ≥ TE ≥ 4`, power of two) but is not guaranteed by the extension; the profile therefore constrains it.
* **Tile specifier encoding for `TEW = 32`.** The chapter states that invalid tile specifiers are reserved; the profile treats the tile choice as an allocation decision and requires the encoding constraint to be honoured.
* **Tail-agnostic accumulator tail.** With the declared `tm = tn = 32` the tail is empty, so the tail-agnostic policy has no observable effect for this profile.
