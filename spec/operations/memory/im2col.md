# im2col — Convolution Window Load

| Property | Definition |
| --- | --- |
| Operation identifier | RVISA-OP-IM2COL |
| Status | Working draft |
| Result | Rank-2 tile |
| Effects | Read |

## Synopsis

im2col reads a tile of the unfolded matrix for forward two-dimensional cross-correlation. The filter is not reversed. The operation need not materialize the entire unfolded matrix.

~~~text
im2col(view: readable_descriptor<T,4>,
       origin: index[2], shape: static<[TM,TK]>,
       kernel: static<[R,S]>,
       stride: static<[SH,SW]> = [1,1],
       dilation: static<[DH,DW]> = [1,1],
       padding: static<[PT,PB,PL,PR]> = [0,0,0,0],
       other = typed_zero, layout = auto,
       allow_tma = permitted) -> tile<T,[TM,TK],Layout>
~~~

| Operand | Meaning and constraint |
| --- | --- |
| view | Logical axes [B,H,W,C], with runtime sizes and element strides |
| origin | Runtime unfolded-matrix element coordinate [m0,k0]; may be negative |
| shape | Positive compile-time result extents |
| kernel | Positive filter height/width R/S |
| stride | Positive spatial strides SH/SW |
| dilation | Positive spatial dilation DH/DW |
| padding | Nonnegative top/bottom/left/right padding, in that order |
| other | Scalar or matching tile data, normalized to [TM,TK] with dtype T |
| layout | Compile-time representation choice; defaults to auto |
| allow_tma | Compile-time [transfer permission](../../core/transfers.md#transfer-selection) |

B, H, W, and C may be zero. The logical axis order is NHWC, but physical layout is determined by the descriptor. For example, contiguous NCHW storage can be described with logical sizes [B,H,W,C] and strides [C*H*W,W,1,H*W]. This does not move or transpose memory.

Unlike a rectangular tile load, this operation deliberately consumes a rank-4 descriptor and produces a rank-2 value.

## Output geometry

**RVISA-IM2COL-COORD-1.** The unfolded coordinates MUST use the following geometry:

~~~text
EH = DH * (R - 1) + 1
EW = DW * (S - 1) + 1

P = 0 if H + PT + PB < EH
    else 1 + (H + PT + PB - EH) // SH
Q = 0 if W + PL + PR < EW
    else 1 + (W + PL + PR - EW) // SW

M_total = B * P * Q
K_total = R * S * C
~~~

Only nonnegative numerators reach division in these formulas. All intermediate arithmetic and addressed offsets must fit their declared representation.

## Element semantics

For each local result coordinate [i,j], let m=m0+i and k=k0+j. If m is outside [0,M_total) or k is outside [0,K_total), return other[i,j] without decoding coordinates or accessing memory.

For an in-range pair:

~~~text
b = m // (P * Q)
p = (m % (P * Q)) // Q
q = m % Q

c = k % C
s = (k // C) % S
r = k // (S * C)

h = p * SH - PT + r * DH
w = q * SW - PL + s * DW

result[i,j] = view[b,h,w,c]  if 0 <= h < H and 0 <= w < W
              other[i,j]   otherwise
~~~

M is flattened in B/P/Q order, with Q fastest. K is flattened in R/S/C order, with C fastest. The source address uses all four descriptor strides.

**RVISA-IM2COL-BOUNDS-1.** Both the unfolded-matrix tail and spatial padding MUST suppress invalid source accesses and return other. Range checks precede coordinate decoding, so zero B, C, P, or Q never causes a division by zero. PB/PR affect output geometry; PT/PL also shift the window origin.

The default other value expresses zero padding. A nonzero fill changes the computation accordingly.

## Matrix contraction

Informative composition: arrange filter data as W[O,K_total] using the same R/S/C flattening. Then im2col supplies A[TM,TK], a tile load supplies B[TO,TK], and default [tmma](../matrix/tmma.md) produces [TM,TO].

Image batch B is folded into M. It is not a tmma batch axis and is not reduced by tmma's default mode. K-tile origins for the image and filter must match. The final contraction tile uses valid_k; relying only on zero fill does not establish strict floating-point equivalence.

## Mapping and conformance

A profile may realize the coordinate calculation with ordinary loads and vector/register transformations, or a registered transfer path. An engine must support or be supplemented to preserve stride, dilation, padding, dtype, alignment, fill, and logical order. TMA permission alone never makes an engine mandatory.

Register representation and temporary storage follow the [tile policy](../../types/tile.md#register-representation) and [transfer lifetime rules](../../core/transfers.md#values-and-dependencies).

This definition covers forward 2D cross-correlation. It does not silently add grouped, depthwise, transposed, 1D/3D convolution, col2im, or automatic filter rearrangement.

Check nonsquare kernels/tiles, unequal spatial strides/dilation, asymmetric padding, negative origins, M/K tails, zero source dimensions, and alternative physical strides. Compare against independently enumerated convolution windows; see [core design cases](../../../conformance/cases/core-designs.md#convolution-coordinates) and the [convolution workload](../../../demos/conv2d/README.md).
