# Diagnostics

Diagnostics identify violations of the virtual instruction contract and failures to satisfy a target profile's instruction or register requirements. They should include the affected operation, source location, actual and expected properties, and relevant target context.

## Categories

| Category | Typical conditions |
| --- | --- |
| `RVISA-E-TYPE/SHAPE` | Incompatible types, unresolved inference, invalid grouping, or shape mismatch |
| `RVISA-E-STAGE/CONTROL` | Runtime data used as a compile-time parameter, invalid condition, or inconsistent control-flow result |
| `RVISA-E-CONFIG` | Missing or incompatible configuration and invalid scope dependencies |
| `RVISA-E-MEMORY` | Invalid descriptor, known out-of-bounds access, access violation, or address overflow |
| `RVISA-E-LAYOUT` | Coordinate coverage, ordering, or representation constraints cannot be satisfied |
| `RVISA-E-TARGET/UNSUPPORTED` | Required capability, numerical behavior, or resource constraints cannot be implemented |

The categories describe the diagnostic model; the complete operation-specific identifiers and message interface remain part of the developing reference.

## Detection and obligations

Static contradictions must be diagnosed. Conditions dependent on runtime allocation or values belong to explicit call or operation preconditions unless runtime checking is required by the contract.

Unsupported source syntax must not be ignored. An unknown target capability must not be interpreted as present. A provisional contract requires a declared, supported interpretation before an implementation can expose it.

A fallback may be selected only where the requested semantic and capability constraints permit it. A diagnostic should distinguish an invalid program from a valid operation outside the selected implementation's coverage. A failed register mapping reports the relevant class, grouping, alignment, overlap, or capacity condition and identifies whether a permitted decomposition was available.

See [operand constraints](../operands/constraints.md) and [conformance requirements](../conformance.md).
