# Sources

## Pinned source

| Property | Value |
| --- | --- |
| Repository | <https://github.com/riscv/riscv-attached-matrix-extension> |
| Revision | `8d27acdcee7a189aad4e2907412e0c40a9d4b9e2` (default branch `main`, tag `v0.6`) |
| Documents | `src/instructions.adoc` (instruction set), with `src/state.adoc`, `src/parameters.adoc`, `src/datatypes.adoc`, `src/programming_model.adoc`, `src/instruction_semantics.adoc`, `src/backend_management.adoc`, `src/examples.adoc` |
| Accessed | 2026-11-05 |

The document title is `Attached Matrix Extension (Ztt)` and the tag `v0.6` is the pinned revision's own version label. The extension has no separate short-name registry entry in the pinned tree; `AME` is used as the document's own abbreviation.

## Documents read

| Section | Used for |
| --- | --- |
| `Introduction` | isolation from RVV, detachable shared backend, parameters that affect binary compatibility |
| `AME State` → `Registers`, `Matrix registers (M0-M15 or M0-M31)`, `Matrix datatype registers (Md0-Md15 or Md0-Md31)`, `Accumulator registers`, `Accumulator datatype registers` | `M`/`Md`, `Acc`/`Ad`, implementation-defined register layout, `mls.1r`/`mss.1r` as the layout-independent path, `Acc` as the destination of every matrix multiply |
| `AME State` → `Control and status registers (CSRs)`, `ameown` | `amenlen`, `ameudsz`, `amestype`, `ameown`, `amefflags`, `amexsat`, `amestatus` |
| `Parameters` → `AME_NELEM`, `AME_NUM_ACC_REGS`, `AME_NUM_M_REGS`, `AME_UNIT_DATATYPE_SIZE` | parameter domains, `AME_MATRIX_REGISTER_SIZE`, `N² = AME_NELEM`, binary-compatibility consequences |
| `Datatypes`, `Datatype descriptor encoding`, `Integer datatype class`, `IEEE floating-point class` | descriptor bits, standard `FP16`/`FP32` encodings, rounding/`Inf`/`Denorm` fields, per-datatype rounding selection |
| `Datatypes` → `Datatype and operation discovery` | `amestatus.UN` probing of a datatype or of an exact operation/datatype tuple |
| `Operand formation` | `N_sq = max(pack_factor)`, packed/unit/wide spans, `Acc` exempt from the square-count rule, `ame_nsq_matmul` |
| `Data movement` | only memory↔`M`, X↔`M`, and `M`↔`Acc` paths exist; no memory↔`Acc` path |
| `Memory`, `Square memory access`, `Strided memory access`, `Memory exceptions`, `Consistency model` | interoperability load/store forms, packed-square memory order, base-address alignment to the element size, fault atomicity, unordered element operations |
| `Common instruction semantics` → `Operand validation and exception priority`, `Register group overlap and atomic writeback`, `Datatype tuple support`, `Operation notation` | check order, source snapshot, atomic writeback, `amestatus.UN` contract |
| `Instruction-family semantics` → `2-dimensional matrix multiply operations` | `N × N` squares, transpose variants, `(s,q)` fold seeded by the pre-instruction accumulator, implementation-defined deterministic permutation and documented rounding/fusion |
| `Standard floating-point operation semantics` | rounding selected by the destination datatype rather than a global mode, `amefflags` accrual, canonical quiet NaN, tininess after rounding |
| `Instruction index` and the pages `ame.acquire`, `ame.release`, `msettyp`, `asettyp`, `mgettyp`, `agettyp`, `mls.rm`, `mss.rm`, `mmov.a.m`, `mmov.m.a`, `mmulacc.2d`, `mmulatacc.2d`, `mmulbtacc.2d`, `mzero.2d.acc` | mnemonics, operand roles, encodings, datatype-matching and clear-on-write rules |
| `AME Backend Ownership and Context Management` | `MS` fields, `ameown.OWNED`, acquire descriptor, release drain, OS context switch |
| `Examples` → `GEMM` | cross-check that the `msettyp`/`asettyp`/`mls.rm`/`mmulacc.2d`/`mmov.m.a`/`mss.rm` sequence shape is the one the document uses |

## Claims

| Claim | Section |
| --- | --- |
| `mmulacc.2d acc, ms1, ms2` computes `C = C + A × B`, with `acc` both source and destination. | `mmulacc.2d` |
| Every logical source square is `N × N`; square `s` of the two operands is paired; each output element folds `N_sq × N` products; the fold is seeded with the pre-instruction accumulator and is never seeded with zero. | `2-dimensional matrix multiply operations` |
| The implementation uses a fixed deterministic permutation of all `(s,q)` terms, does not reduce products separately, and documents its overflow, saturation, floating-point rounding, and optional fused-product behavior. | `2-dimensional matrix multiply operations` |
| The instruction's square count is `N_sq = max(pack_factor)` over the tensor operands; a packed operand spans `N_sq / pack_factor` registers; `Acc` operands always hold exactly one square. | `Operand formation` |
| For a 2D multiply, the fold can be written as an `N × (N_sq·N)` by `(N_sq·N) × N` product, so the contraction depth is `N_sq × N`. | `Operand formation`, `2-dimensional matrix multiply operations` |
| `mmulatacc.2d` multiplies the transpose of `ms1` by `ms2`, and `mmulbtacc.2d` multiplies `ms1` by the transpose of `ms2`; the profile uses neither. | `mmulatacc.2d`, `mmulbtacc.2d` |
| `asettyp` sets `Ad` and clears every physical storage bit of the accumulator to raw zero; `msettyp` sets `Md` and clears the datatype's register group. | `asettyp`, `msettyp` |
| `mls.rm`/`mss.rm` transfer one square, or `pack_factor` squares, between memory and one `M` register, using the programmed datatype and a row-major image; packed squares occur in ascending slot order. | `mls.rm`, `Square memory access`, `Memory` |
| Memory-instruction base addresses must be naturally aligned to `ceil(E/8)` bytes; a misaligned base raises an address-misaligned exception before any access. | `Memory`, `Memory exceptions` |
| There is no direct path between memory and `Acc`; `mmov.a.m` and `mmov.m.a` move between `M` and `Acc` and require matching datatypes. | `Data movement`, `mmov.a.m`, `mmov.m.a` |
| `AME_MATRIX_REGISTER_SIZE = AME_NELEM × AME_UNIT_DATATYPE_SIZE`; `AME_NELEM` must be a power of four and `AME_UNIT_DATATYPE_SIZE` a power of two. | `Parameters` |
| The standard `FP16` and `FP32` datatypes have `Inf = 1` and `Denorm = 1`, a don't-care rounding field, and sizes 16 and 32 bits. | `Standard Floating Point Types` |
| Floating-point rounding is selected by the destination datatype; AME has no global dynamic rounding mode; standard operations accrue flags in `amefflags` and not in `fflags`, with tininess detected after rounding. | `Standard floating-point operation semantics` |
| An unsupported datatype tuple sets `amestatus.UN` and leaves every destination unchanged; it is not a synchronous exception. | `Datatype tuple support` |
| Every AME instruction other than `ame.acquire` and `ame.release` raises *Illegal Instruction* when `ameown.OWNED = 0`, and every AME instruction raises it when an applicable `MS` field is `Off`. | `State enablement and ownership access rules` |
| The datatype of an `M` register is implementation-defined in its internal layout; only the interoperability load/store images are architectural. | `Matrix registers (M0-M15 or M0-M31)` |

## Provisional and unresolved points in the source

* **Fold order.** The (s,q) permutation is implementation-defined but must be fixed and deterministic. RVISA `ordered` accumulation in increasing `k` order is therefore not guaranteed by the instruction, and the profile claims only `tree` (see [numerics](numerics.md#equivalence-domain)).
* **Product fusion.** Fused-product behavior is optional and implementation-documented. For the declared `fp16 × fp16 → fp32` tuple the question is numerically void (every product is exactly representable in `fp32`), but the profile records that it does not rely on a fusion guarantee.
* **Operand base alignment.** The common validation order states that "derived base alignment" and the complete physical span are checked, and `mmov.m.a`/`msettyp` mention per-datatype alignment, but the general derivation for packed operands is not stated. The profile avoids the question by using one-register spans only.
* **Datatype support.** Implementations choose which standard datatypes and which exact operation/datatype tuples they support, so the declared tuple is a profile precondition verified by `amestatus.UN`, not an AME guarantee.
* **`Acc` width.** `Acc` must hold the largest representable square for the implementation's supported datatypes; with only 32-bit-and-narrower datatypes supported, one `AME_MATRIX_REGISTER_SIZE` of storage suffices, which the profile's parameter set assumes.
* **No worked floating-point example.** The pinned `Examples` chapter illustrates integer GEMM (`elem_bytes = 1`) and does not include an `FP16 → FP32` example; the profile derives the sequence from the instruction-level contract instead.
