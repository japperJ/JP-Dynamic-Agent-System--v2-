# Extensions Governance

This directory contains all governance artifacts that must exist **before** any new skill or agent is created.

No extension (skill or agent) may be proposed, approved, or activated without the artifacts in this directory being followed.

---

## Artifact Map

| File / Dir | Purpose |
|---|---|
| `EDR_TEMPLATE.md` | Mandatory template for any Extension Decision Record. Every proposed extension must fill this before approval. |
| `REGISTRY.yaml` | Authoritative, auditable registry of all approved extensions (skills and agents). The single source of truth for status, scope, wiring targets, and EDR provenance. |
| `DECISION_RULES.md` | Testable skill-first decision tree (Gate A–D). Governs whether a proposed extension should be a skill, agent, or neither. |
| `WIRING_CONTRACT.md` | Defines what "wired" means for this repo: declarative wiring via REGISTRY.yaml plus operational wiring evidence (plan-driven references or additive agent-file Skill Index sections). |
| `ADDITIVE_ONLY.md` | Additive-only constraints for extension governance work. Restates the baseline gate policy and calls out the special risk of editing `.github/agents/**`. |
| `edr/` | Archive directory for completed Extension Decision Records. Named per convention `EDR-YYYYMMDD-NNNN-<slug>.md`. |

---

## Lifecycle

1. **Propose** — Fill `EDR_TEMPLATE.md` and save as `edr/EDR-YYYYMMDD-NNNN-<slug>.md` with `status: proposed`.
2. **Decide** — Apply `DECISION_RULES.md` (Gates A–D). Update EDR status to `approved` or `rejected`.
3. **Register** — Add an entry to `REGISTRY.yaml`. Only `approved` EDRs may produce `active` registry entries.
4. **Wire** — Follow `WIRING_CONTRACT.md` to make the extension both discoverable and operationally referenced.
5. **Constrain** — Any agent-file edits follow `ADDITIVE_ONLY.md` and require a user checkpoint (Gate 2, `CHANGE_GATES.md`).

---

## P0 Constraint

No file in `.github/agents/**` may be modified as part of Phase 2 work. All Phase 2 changes are scoped to `.planning/**` only.

See: `.planning/baseline/CHANGE_GATES.md` (Gate 1).
