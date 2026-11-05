# Registers and State

This profile spans two architectural register domains: the vector register file, which holds the A and B operands, and the matrix tile state, which holds the accumulator. Neither domain can hold the other's role in the declared subset. The representation follows [RVISA-TILE-REG-1](../../../../spec/types/tile.md#register-representation), and the split of logical groups, architectural groups, and simultaneously live registers is stated per domain.

## Vector register domain (A and B)

| Property | Description |
| --- | --- |
| Identity and role | RISC-V vector register file, registers `v0`-`v31`; source operand domain. Each `tk`-row operand consumes `tk ≤ 4` row registers. |
| Capacity | 32 registers of `VLEN = 1024` bits (128 bytes). At `SEW = 8`, one register holds `EVE = 128` elements; a row's active extent is `tm` elements for A and `tn` elements for B, both 32 here. |
| Element interpretation | Signed `int8`, one element per byte, element `i` at bits `[8i+7 : 8i]`. |
| Group constraints | Each row is one register (`LMUL = 1`). Successive rows are separated by `8/KMAX = 2` vector registers. The rows of one operand must lie inside a single eight-register group, so the operand's base specifier taken modulo 8 must be less than `8/KMAX = 2`, and it must be a multiple of `LMUL = 1`. |
| Operand constraints | With the base at `w` (mod 8 = 0) the rows are at `w, w+2, w+4, w+6`; with the base at `w+1` (mod 8 = 1) they are at `w+1, w+3, w+5, w+7`. Both operands may therefore share one eight-register window, A using the even and B the odd offsets; the profile's preferred allocation is exactly that, because it uses 8 registers for both operands. Registers in the window that hold no row belong to unrelated values and are not read. |
| Access | `vtmms.tvv` reads the operand groups. Ordinary vector loads (`vle8.v` with `vl = 32`) stage a row, and `vtmv.t.v` / `vtmv.v.t` move tile subsets to and from a vector register group. |

The base-register rule is the source's, not a convenience: taking the specifier modulo 8 and requiring it to be less than `8/KMAX` prevents a row collection from spanning an eight-register group boundary.

## Matrix tile domain (accumulator C)

| Property | Description |
| --- | --- |
| Identity and role | Matrix tile state. At `TEW = 32` the state is viewed as four square tiles `mt0`, `mt4`, `mt8`, `mt12`; the accumulator is one of them. |
| Capacity | One `TEW = 32` tile is `TE × TE = 32 × 32` `int32` elements (4 KiB). The four tiles total 16 KiB. |
| Group constraints | The tile number is encoded in the instruction's `rd` field. Instructions that do not support `TEW = 8` do not encode `t[0]`, and a specifier whose value modulo `16/NTiles = 4` is nonzero is reserved, so only `mt0`, `mt4`, `mt8`, `mt12` exist at this element width. |
| Operand constraints | The declared geometry uses the whole tile: `tm = tn = 32`, so no tile element is outside the active submatrix. Two tiles are related only through punning, described below. |
| Access | `vtmms.tvv` reads and writes the active submatrix; `vtzero` writes zeros; `vtle32` and `vtse32` transfer rows or columns; `vtmv.v.t` and `vtmv.t.v` move a row or column to and from vector registers; `vtdiscard` marks the state dead for context purposes. |

### Tile punning and cross-width aliasing

The tile state is reshaped for each supported `TEW`, so the same physical storage appears as one `TEW = 32` tile or as four `TEW = 8` tiles. The profile forbids accessing a tile through a `TEW` other than the one that produced it, and forbids mixing row and column patterns as a way of reading a differently shaped view: punning exists for context switching and debugging, not as a general reinterpretation path.

## Coordinate representation

| Virtual element | Target coordinate |
| --- | --- |
| `Aeff[m,k]` = `a[k,m]` (`ALayout = colmajor`, exposed shape `[K,M]`) | Row `k mod 4` of the current fragment: register `baseA + 2·(k - 4j)`, element position `m` |
| `Beff[n,k]` = `b[k,n]` (`BLayout = rowmajor`, exposed shape `[K,N]`) | Row `k mod 4` of the current fragment: register `baseB + 2·(k - 4j)`, element position `n` |
| `Ceff[m,n]` = `acc[m,n]` (`CLayout = rowmajor`) | Tile `mtd`, row `m`, column `n` of the active `tm × tn` submatrix |

Fragment `j` covers `k ∈ [4j, 4j + tk)`; the row index inside the fragment is `k - 4j`. Element positions beyond `tm` (A) or `tn` (B) in a row register are not read. The intra-tile physical placement of an accumulator element is the punning layout and is not a software-visible address in this profile: every accumulator transfer in the subset uses a row or column tile subset specifier, whose memory image is contiguous with increasing row or column index.

Coverage, replication, and padding:

* A/B rows: `tm` (respectively `tn`) active elements of `EVE = 128` available positions per register; the remaining positions are unused, not padding that participates in the computation.
* Accumulator: full coverage; no padding.
* Replication: none. No element is broadcast, and a singleton batch axis does not exist for rank-2 inputs.

## Resource and temporary-storage policy

| Quantity | Value |
| --- | --- |
| Registers per compute step | 8: four A rows in one eight-register window and four B rows in the same or another window |
| Preferred allocation | One window: A at offsets 0, 2, 4, 6 and B at offsets 1, 3, 5, 7 |
| Accumulator residency | One tile out of four, live across the whole K chain |
| Input residency | Input rows are needed only for the fragment being computed; they may be reloaded or rebound per fragment |
| Temporary storage | None inside the instruction; staging from memory uses ordinary vector loads into the row registers |

There is no declared spill sequence for the accumulator beyond the row transfers named above, and no staging requirement is imposed on the A/B row registers because they follow the vector architecture's own save rules. If the surrounding allocation cannot provide two compliant operand bases, the mapping reports the case as unsupported.

Accumulator save and restore is per row: `vtse32` with a row tile subset specifier writes `min(vl, ETE) = 32` `int32` elements (128 bytes) contiguously in increasing column order, one instruction per row, and `vtle32` reverses it. 32 instructions transfer the whole tile. A raw, width-agnostic image would require the `TEW = 8` view and is outside the declared subset.

## State and transfers

| State | Effect |
| --- | --- |
| `mtype.mtwiden` | `3` for `TWIDEN = 4` (`TWIDEN = 1 << (mtwiden - 1)`); the value `0` means the matrix unit is not configured, in which case `msettm`/`msettk` raise *Illegal Instruction* and tile transfers are reserved. |
| `mtype.tm = 32`, `mtype.tk ≤ 4` | Active accumulator rows and contraction depth of the next instruction. |
| `vl = tn = 32` | Active accumulator columns. The same register supplies the body extent of `vtle`/`vtse`. |
| `vtype.vsew = 8`, `vtype.altfmt = 1`, `vtype.vlmul = 0` | Multiplicand width, signed interpretation of both operands, and `LMUL = 1`; `vta`/`vma` are forced to 1 by `msetmtypei`. |
| `mstatus.MS` / `vsstatus.MS` | Must be non-`Off` for any tile access; configuration instructions do not access tile state. |
| `vstart` | Must be 0 for matrix arithmetic; tile subset transfers use `vstart` for their body and follow the vector precise-exception model. |

Configuration ordering is part of the state contract: `msetmtypei` establishes `mtype` and `vtype`, the `mset*` instructions then narrow `tm`/`tn`/`tk`, and no `vsetvli` or `vsetivli` may follow, because those instructions write `mtype = 0` and unconfigure the matrix unit. Values become available when the writing instruction commits; tile elements outside `[0,tm) × [0,tn)` are tail and stay unspecified.

Return to the [profile overview](README.md) · [operand mappings](operands.md) · [lowering rules](lowering.md).
