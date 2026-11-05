# Registers and State

The profile uses three architectural register domains: matrix registers `M`, the accumulator registers `Acc`, and the datatype registers `Md`/`Ad` that qualify them. It also depends on the backend ownership and context-status state. The representation follows [RVISA-TILE-REG-1](../../../../spec/types/tile.md#register-representation); this document records the classes, coordinates, residency, and transfer obligations for the declared subset.

## Matrix register domain (A and B)

| Property | Description |
| --- | --- |
| Identity and role | General-purpose matrix registers `M0`-`M15` or `M0`-`M31` (`AME_NUM_M_REGS`), holding the A and B operands. Each operand is one register (`pack_factor = 2`, `N_sq = 2`, span `N_sq ÷ pack_factor = 1`). |
| Capacity | `AME_MATRIX_REGISTER_SIZE = AME_NELEM × AME_UNIT_DATATYPE_SIZE = 256 × 32 = 8192` bits: two `16 × 16` `fp16` squares, or one `16 × 16` `fp32` square, per register. |
| Element interpretation | Determined by `Md[base]`: `FP16` for both operands. The register's internal byte layout is implementation-defined; only the interoperability load/store image is architectural. |
| Group constraints | A one-register span. No grouping, no alignment constraint derived from `pack_factor` applies, and no `Md` value of any other register in a group is consulted. |
| Operand constraints | The two operands may be the same register; the source-snapshot rule makes that well defined and the extension's own discovery example writes `mmulacc.2d acc0, m0, m0`. |
| Access | `mmulacc.2d` reads `ms1` and `ms2`; `mls.rm` writes and `mss.rm` reads the interoperability image; `mmov.a.m` reads and `mmov.m.a` writes; `msettyp` writes `Md` and clears the register; `mgettyp` reads `Md`. |

`AME_NUM_M_REGS` must be at least 2 for the declared sequence, because A and B must be resident at the same time; a third register removes the serialization of the accumulator staging path. `AME_NUM_M_REGS = 16` and `32` differ in binary compatibility upstream, but the subset needs no register above `m15`, so both are acceptable.

## Accumulator register domain (C)

| Property | Description |
| --- | --- |
| Identity and role | Accumulator registers `Acc0`-`Acc[AME_NUM_ACC_REGS - 1]`, holding the accumulator square and receiving every matrix-multiply result. One register is used. |
| Capacity | One `N × N = 16 × 16` `fp32` square (1024 bytes). An `Acc` register must be large enough for the largest square the implementation supports; with 32-bit-and-narrower datatypes one register of `AME_MATRIX_REGISTER_SIZE` bits suffices. |
| Element interpretation | `Ad[acc]`: `FP32` with the rounding field set to RNE and `Inf`/`Denorm` set. |
| Group constraints | The accumulator is never packed or grouped: it always holds exactly one square, and an index at or beyond `AME_NUM_ACC_REGS` raises *Illegal Instruction*. |
| Operand constraints | The accumulator is both source and destination of every compute instruction; it is read once as the fold seed and updated in place. |
| Access | `mmulacc.2d` reads and writes it; `mmov.a.m` and `mmov.m.a` move it; `asettyp` writes `Ad` and clears the storage; `agettyp` reads `Ad`. There is no memory access path. |

## Datatype registers

| Property | Description |
| --- | --- |
| Identity and role | `Md[n]` for each `M` register, `Ad[n]` for each `Acc` register; 32-bit descriptors. |
| Capacity | `AME_NUM_M_REGS` `Md` registers and `AME_NUM_ACC_REGS` `Ad` registers. |
| Element interpretation | Descriptor fields: bit 31 custom, bits 30:26 exponent width, bits 25:22 rounding mode, bit 21 infinity support, bit 20 denormal support, bits 19:9 reserved (zero), bit 8 class bit, bits 7:0 size. |
| Required values | `FP16` = exponent width 5, RNE, `Inf = 1`, `Denorm = 1`, size 16; `FP32` = exponent width 8, RNE, `Inf = 1`, `Denorm = 1`, size 32. As 32-bit values these are `0x14300110` and `0x20300120`. The value is the sum of `exp_width<<26`, `rounding<<22`, `inf<<21`, `denorm<<20`, `1<<8`, and `size`, shown so that it can be checked against the encoding table rather than taken on trust. |
| Sticky behaviour | A descriptor value is retained even when the register takes no part in a group, and `mmov.*` and `mmulacc.2d` do not modify `Md` or `Ad`. |
| Zero descriptor | Value 0 means uninitialized. A zero or unsupported descriptor makes the tuple unsupported: `amestatus.UN` is set and nothing is written. |

## Coordinate representation

| Virtual element | Target coordinate |
| --- | --- |
| `Aeff[m,k]` = `a[m,k]` | Register `ms1`, interoperability image byte offset `s·512 + m·32 + q·2`, where `k = 16s + q` |
| `Beff[n,k]` = `b[k,n]` | Register `ms2`, interoperability image byte offset `s·512 + q·32 + n·2` = `k·32 + n·2` |
| `Ceff[m,n]` = `acc[m,n]` | Accumulator `acc`, image byte offset `m·64 + n·4` |

The two input images are not symmetric: A's image is a sequence of the two `16 × 16` K-blocks, so it is *not* the plain row-major image of a `16 × 32` matrix, while B's image is exactly the row-major image of `32 × 16`, because B's squares are whole row blocks of the `[K,N]` matrix. Staging A therefore requires a block-column reordering that B does not. Both images are each `pack_factor` contiguous squares "in ascending slot order", which is where the asymmetry comes from.

The mapping from a logical element to the register's internal position is not architectural; the byte offsets above are positions in the memory image produced and consumed by `mls.rm` and `mss.rm`, and the implementation maps those images onto its own layout.

## Resource and temporary-storage policy

| Quantity | Value |
| --- | --- |
| `M` registers per chain step | 2 (A and B); a third allows staging the accumulator without serializing |
| `Acc` registers | 1 |
| Accumulator residency | Live across the whole K chain, and it cannot be spilled to memory: the only paths out are `mmov.m.a` into an `M` register and then `mss.rm` |
| Temporary footprint | One `M` register for accumulator save and restore, 1024 bytes of memory per square image |
| Input residency | The two operand registers are needed only for the fragment being computed and may be re-created per fragment |
| Alignment | Every declared span is one register, so no derived base-alignment rule is exercised; memory bases must be naturally aligned to the element size (2 bytes for `fp16`, 4 bytes for `fp32`) |

If fewer than two `M` registers or no `Acc` register is available, the mapping reports the case as unsupported. A tile store is not optional when the accumulator must survive: because there is no memory-to-accumulator path, spilling the accumulator costs a move plus a store, and reloading costs a load plus a move.

## State and transfers

| State | Effect |
| --- | --- |
| `ameown.OWNED` | Must be 1. Without ownership every instruction except `ame.acquire` and `ame.release` raises *Illegal Instruction*. |
| `mstatus.MS` (and `vsstatus.MS` when `V = 1`) | Must be non-`Off`; `Off` makes every AME instruction and CSR access illegal. |
| `amestatus.UN` | Set when the tuple is unsupported; the destination is left unchanged and no exception is raised, so the mapping must read it rather than infer success. |
| `amefflags` | Accrues `NV`, `DZ`, `OF`, `UF`, `NX` for floating-point results; `fflags` is untouched. |
| `amexsat` | Not used by the declared tuple. |
| `amenlen`, `ameudsz` | Read-only capability reports; the profile's parameter set implies tile side 16 and unit datatype size 32. |
| `amestype` | Scalar datatype for `.ew.x` forms; not used by the declared sequence. |

Datatype programming is a destructive state transition: `msettyp` clears the register group and `asettyp` clears the accumulator, so both must precede the loads and the accumulation. Every destination write, `amefflags`, and `amexsat` update of a register-only instruction become visible as one commit, and a synchronous exception leaves all of them unchanged.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [lowering rules](lowering.md).
