# Sources

## Pinned source

| Property | Value |
| --- | --- |
| Repository | <https://github.com/riscv/integrated-matrix-extension> |
| Revision | `6effbcae3204e5a8a9c9d15ff53959918144870c` (default branch `main`) |
| Tag relationship | The commit carries build tag `riscv-isa-release-6effbca-2026-08-04`; the repository also publishes `integrated-matrix-release-*` and `integrated-matrix/stable-*` tags, and none of those identifies this commit |
| Document | `src/integrated-matrix.adoc`, chapter `Zvvm Family of Integrated Matrix Extensions` |
| Accessed | 2026-11-05 |

The repository is a RISC-V manual fork; the IME chapter is a single AsciiDoc file. Instruction descriptions there state minimum version `0.1` with lifecycle state `Draft` for the instructions this profile uses, so the whole profile is pinned to a draft extension.

No other revision of this repository, and no vendor fork, is a source for this profile. A changed upstream contract requires the impact analysis of the [revision policy](../../../contract.md#revision-policy).

## Documents read

Sections below were read in the pinned revision. Section titles are quoted as they appear; nested subsections are given with their parent heading path where the numbering is not obvious.

| Section | Used for |
| --- | --- |
| `Overview` → `Matrix tile multiplication geometry` | tile concept, `lambda`, `M`, `EMUL_C`, `EMUL_C ∈ {1,2,4,8,16}` |
| `Overview` → `ISA control of matrix tile geometry` | register layout of A, B, C; `K_eff = lambda × W × LMUL`; integer `LMUL ∈ {1,2,4,8}`; C base alignment |
| `Overview` → `Matrix tile multiplication computation` | in-register equation `C_tile += A_tile × B_tile^T`, row-major A and B storage |
| `Extensions in Zvvm` → `Naming conventions`, `Computational extensions` | extension naming, `Zvvi8i32mm` row of the computational-extension table |
| `New fields in the Vector Type (vtype) Register` | `lambda[2:0]`, `bs`, `altfmt_A`, `altfmt_B`; reset values |
| `New fields in the Vector Type (vtype) Register` → `Interaction with vector configuration instructions` | `vsetvli`/`vsetivli` do not write IME fields; `vsetvl` writes a complete `vtype`; WARL classes |
| `New fields in the Vector Type (vtype) Register` → `Selected lambda (lambda[2:0]) field` | permissibility condition, preserve-or-initialize rule, clamp rule, illegal-instruction conditions |
| `New fields in the Vector Type (vtype) Register` → `Alternate floating-point format for the output (altfmt)`, `Alternate formats for inputs (altfmt_A, altfmt_B)` | `altfmt` unused for ordinary integer accumulation; `altfmt_A`/`altfmt_B` are 1-bit signedness selectors |
| `Storage formats` → `Element packing in input tiles`, `Byte-sized and wider elements (EEW >= 8)` | packed narrow elements per `SEW` slot; element `k` at bits `[k × EEW + EEW - 1 : k × EEW]` |
| `Zvvmm` → instruction table, `Arithmetic Considerations` → `Integer accumulation` | mnemonics per widening factor `W`; masking unsupported; `vstart` = 0 requirement; modular reduction modulo `2^SEW` |
| `Zvvmttls` → `Tile geometry for multiply-accumulate` | `M_tile`, `K_eff`, `N_tile`, `N_tile_max`, `EMUL_C`, compute-`VL` and A-load-`VL` relations |
| `Zvvmttls` → `C tile tail policy` | tail elements defined by tile column index, not by `element_index >= VL` |
| `Instructions` → `vqmmacc.vv` | encoding, description, `VL` multiple-of requirement, exception list, Sail operation outline |
| `Encoding map` → `Integer encoding map` | legality row `vqmmacc` / `SEW=32` / `EEW=8` / `altfmt_A=0` / `altfmt_B=0` → `Zvvi8i32mm` |
| `Zvvmtls` → `vmtl.v` | order-preserving tile load form, leading-dimension operand, `VL` multiple-of requirement (referenced only; tile memory operations are outside this profile) |
| `Software considerations` → `C-Language Intrinsics` → `IME-only m16 accumulator types` | `psABI` statement for IME accumulator types; `EMUL_C = 2` uses an ordinary vector type suffix |

## Claims

Each claim below is stated in the pinned text at the cited section. Derived quantities are marked as arithmetic on those claims, not as upstream statements.

| Claim | Section |
| --- | --- |
| The extension computes `C ← C + A × B^T` with A and B row-major in register layout and C row-major. | `Overview` → `Matrix tile multiplication computation` |
| `K_eff = lambda × W × LMUL`; A and B register groups extend only along K; `LMUL` does not change C. | `Overview` → `ISA control of matrix tile geometry` |
| `M = N = VLEN ÷ (SEW × lambda)` and `EMUL_C = VLEN ÷ (SEW × lambda²)`, with `EMUL_C ∈ {1,2,4,8,16}` and the C base register a multiple of `EMUL_C`. | `Overview` → `Matrix tile multiplication geometry`, `ISA control of matrix tile geometry` |
| `N_tile = VL ÷ (lambda × LMUL)` and `N_tile_max = M_tile`; `VL` must be a multiple of `lambda × LMUL`; loading an A tile needs `VL = M_tile × lambda × LMUL`. | `Zvvmttls` → `Tile geometry for multiply-accumulate` |
| `vqmmacc.vv` implements `W = 4` with A/B element width `SEW/4`, and its accumulator element width is `SEW`. | `Zvvmm` instruction table; `vqmmacc.vv` page |
| `vqmmacc.vv` raises *Illegal Instruction* for `vstart ≠ 0`, `vm = 0`, `VL` not a multiple of `lambda × LMUL`, `EMUL_C` outside `{1,2,4,8,16}`, unaligned `vs1`/`vs2`/`vd`, or a reserved/not-implemented encoding-map row. | `vqmmacc.vv` page → `Exceptions` |
| `SEW = 32`, `EEW = 8`, `altfmt_A = 0`, `altfmt_B = 0`, `vm = 1` selects the `Zvvi8i32mm` row (`Int8`, `Int8` → `Int32`). | `Encoding map` → `Integer encoding map` |
| With `altfmt_A`/`altfmt_B`, `0` means signed and `1` means unsigned; the accumulator is always signed; `altfmt` and `bs` are ignored for ordinary integer rows. | `Encoding map` → `Integer encoding map` |
| Integer accumulate results are reduced modulo `2^SEW` and are independent of accumulation order or grouping. | `Zvvmm` → `Arithmetic Considerations` → `Integer accumulation` |
| Vector masking is not supported on multiply-accumulate instructions; `vm = 0` is reserved for `vmmacc.vv` and encodes a microscaled form for the widening mnemonics. | `Zvvmm` |
| A nonzero `lambda` write may be clamped to the largest supported value not exceeding the request; `vsetvli`/`vsetivli` never write the IME `vtype` fields. | `Selected lambda (lambda[2:0]) field`, `Interaction with vector configuration instructions` |
| For `EEW >= 8`, packed input elements follow standard vector element ordering, identical to a vector load at that element width. | `Element packing in input tiles` |
| C tile tail elements are selected by column index `j >= N_tile`, not by a one-dimensional `element_index >= VL`; multiply-accumulate never reads or writes them. | `Zvvmttls` → `C tile tail policy` |

## Provisional and unresolved points in the source

* The multiply-accumulate instruction page does not state a source-snapshot or overlap rule for `vd` against `vs1`/`vs2`. [registers.md](registers.md#operand-constraints) resolves this by a profile-level disjointness requirement rather than by reading the text.
* The extension has no operand for input signedness; unsigned rows of the integer encoding map cannot be expressed by an RVISA `tmma` call.
* Floating-point exception flags are not updated by ordinary integer accumulation, and the integer row is outside the open matrix-numerics contract in [Specification Status](../../../../spec/status.md#open-contracts). No unresolved numerical detail affects the declared tuple.
* No assembler spelling, intrinsic, or simulator is specified by this document, and none is claimed.
