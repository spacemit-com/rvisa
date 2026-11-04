# Element Types

Element types identify numerical values; storage encodings, instruction support, and conversion policies are separate requirements. The following names are used by the operation definitions.

## Core element vocabulary

| Type | Meaning in this draft |
| --- | --- |
| bool | Scalar Boolean or a condition at a mask coordinate |
| index | Integer used for sizes, coordinates, and element offsets; arithmetic must satisfy the operation's range and overflow preconditions |
| f16 | Binary16 floating-point input |
| bf16 | Bfloat16 floating-point input |
| f32 | Binary32 floating-point computation and the baseline matrix accumulator |

An index is not a pointer or an unsigned quantity by implication; for example, an origin may be negative. The reference notation uses 64-bit signed indices where an external scalar width is needed. A portable runtime ABI remains open.

The baseline unscaled matrix combinations use f16 or bf16 inputs with f32 accumulation. This vocabulary does not require every operation, target, or mixed pair of input formats to be supported.

## Low-precision and scale vocabulary

| Type | Role | Storage boundary |
| --- | --- | --- |
| f8e4m3fn | FP8 payload or scale | One byte per storage element |
| f8e5m2 | FP8 payload | One byte per storage element |
| f8e8m0fnu | Exponent-encoded scale | One byte per storage element |
| f4e2m1fn | FP4 logical payload | Packed storage requires a separate addressing and unpacking contract |

These names denote floating-point formats, not integer aliases. A profile claiming support must identify the precise format definition, special encodings, decoding, and conversion behavior. The vocabulary alone is not a complete format or quantization specification.

For f8e8m0fnu, finite codes 0 through 254 denote 2^(code-127); the code is not the numerical scale. There is no numerical zero among those encodings. Special encodings require the format's declared handling. The exactly representable value 1 is a suitable fill value when a zero cannot be represented.

An FP4 logical element does not imply a C++ object of fractional byte size. Ordinary pointer addressing MUST NOT substitute sizeof(T)=0.5 into the byte-address formula. The packed FP4 memory ABI and general low-precision conversion policies remain open.

## Operation and mapping constraints

A profile declares supported tuples of input, intermediate, scale, accumulator, and result types, together with numerical behavior. Support for a payload format does not establish support for [block-scaled matrix computation](../operations/matrix/tmma-scaled.md).

Scalar, vector, and tile conversions preserve their respective coordinate contracts. Implicit pointer reinterpretation, quantization, zero-point subtraction, or saturation is not introduced by a type name.

See [Scalar Types](scalar.md), [Numeric Model](../core/numeric-model.md), and [Specification Status](../status.md).
