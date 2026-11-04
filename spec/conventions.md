# Conventions

These conventions apply to the specification, operation reference, IR descriptions, examples, and target profiles.

## Normative and informative text

MUST and MUST NOT express requirements of the stated contract. SHOULD expresses a recommendation whose exceptions need justification. MAY identifies a permitted choice.

Normative text describes observable behavior, legal inputs, and implementation obligations. Rationale, worked examples, and optimization advice are informative and must be identified as such. A recommendation cannot relax a requirement.

Requirements in this working draft are proposals under development; the document state is recorded in [Specification Status](status.md). Project review states do not imply external ratification.

## Instruction notation and target terminology

Use *RVISA operation* for a specified virtual operation and *target instruction* for an architectural instruction in a selected profile. A Python/C++ spelling illustrates that operation; it does not by itself define an executable API or a machine encoding.

Distinguish a logical group from a target register group, a register class from a concrete physical register number, and a mapping rule from one generated instruction sequence. Qualify mapping guarantees by profile identity and revision. The primary definitions are the [tile representation policy](types/tile.md#register-representation) and [target mapping guarantees](../mappings/contract.md#mapping-guarantees).

## Requirement identifiers

A requirement referenced by another component should have a stable identifier and one primary definition. Identifiers should describe the subject, remain unique within the specification, and survive editorial relocation.

Use a named Markdown anchor or a visible rule identifier at the definition. Mapping rules, diagnostics, and conformance cases refer to it rather than maintaining an independent copy of the requirement.

## Parameters and units

| Notation | Meaning |
| --- | --- |
| `T`, `dtype` | Element type |
| `M, N, K` | Logical matrix dimensions, interpreted by the operation's axis convention |
| `B0, B1` | Input batch dimensions |
| `shape` | Logical coordinate domain |
| `capacity` | Full logical vector capacity, possibly symbolic |
| `vl`, `valid_k` | Operation-specific active extent; not a replacement for type capacity |
| `vlenb` | Target vector-register width in bytes |
| `offset`, `stride`, `origin` | Element-based quantities unless the applicable contract states otherwise |

Every alternative unit or packed representation must be explicit. Pointer values, memory bounds, logical coordinates, and register numbers are different quantities.

## Unspecified and unsupported behavior

- **Provisional** identifies a contract with listed open decisions.
- **Implementation-defined** permits a specified set of choices and requires an implementation to document its choice.
- **Unsupported** identifies a capability or combination outside an implementation's declared coverage.
- **Invalid** identifies a violation of the virtual instruction specification's validity rules.

These terms are not interchangeable. Unknown resource limits do not mean unbounded capacity. An implementation cannot select an arbitrary interpretation of a provisional contract and claim general conformance.

## Examples and references

Label pseudocode as such. Python/C++ examples illustrate RVISA semantics and do not imply execution support. Numerical examples state formats, rounding assumptions, and comparison policy.

Link matrix-extension references to the corresponding upstream specification or proposal. Use vendor sources for vendor-specific extensions. Concrete target claims cite a fixed source version and relevant section. The [reference index](references.md) identifies upstream entry points; the profile supplies its exact dependencies.
