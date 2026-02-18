---
edr_id: "EDR-20260218-0002-extension-verifier"
date: "2026-02-18"
status: "approved"
kind: "skill"
proposed_name: "extension-verifier"
owner: "JP Dynamic Agent System"
requirements:
  - "REQ-005"
  - "REQ-013"
  - "REQ-014"
wiring_targets:
  - "Verifier"
  - "Orchestrator"
risk_level: "low"
additive_only: true
approved_by: "orchestrator-auto-pilot-phase4"
---

# Extension Decision Record: `extension-verifier`

---

## 1. Problem / Gap

The JP Dynamic Agent System has a governed creation playbook (`extension-coordinator`) but no corresponding verification playbook. When an extension is created and wired, verifying it correctly requires cross-referencing multiple `.planning/**` docs (EDR template, REGISTRY.yaml, WIRING_CONTRACT.md, P0_SMOKE_CHECKS.md) without any single, on-demand, verifier-grade procedure to consolidate the checks.

Concretely, the current `Verifier` agent is intentionally generic ("goal-backward" verification) and contains no extension-governance-specific steps. As a result:
1. It is unclear which checks must pass before an extension phase is marked complete.
2. There is no standard format for recording extension-loop evidence in a VERIFICATION.md file.
3. The "it exists but didn't load" ambiguity (skill on disk vs. skill loaded in VS Code) is not addressed by any existing artifact.
4. P0 regression spot-checks and tooling evidence capture are not collected consistently across phases.

---

## 2. Why Existing Agents and Skills Cannot Solve This

| Existing thing considered | Why it is insufficient |
|---|---|
| `Verifier` agent (generic) | Goal-backward verifier; no embedded extension-governance checklist; permanently adding one would bloat always-on agent context and trigger a Gate 2 checkpoint for every future run. |
| `extension-coordinator` skill | Governs *creation* of new extensions (EDR → decision gates → create → register → wire). Does not govern *verification* of whether the loop was executed correctly or whether the skill actually loaded. |
| `.planning/extensions/WIRING_CONTRACT.md` | A reference doc, not an invocable playbook. Agents do not auto-load planning docs; they must be explicitly referenced per phase and re-derived each time. |
| `.planning/baseline/P0_SMOKE_CHECKS.md` | Covers P0 regression only; does not address EDR completeness, registry correctness, wiring evidence per extension, or tooling/host evidence capture. |
| Phase verification files (ad hoc) | Each phase's VERIFICATION.md is written ad hoc; there is no consistent procedure, output format, or evidence triad standard applied across phases. |

---

## 3. Proposal

- **Kind:** `skill`
- **Name:** `extension-verifier`
- **Location:** `.github/skills/extension-verifier/SKILL.md`
- **One-sentence purpose:** A verifier-grade, repo-specific runbook for confirming that a new or updated extension correctly completed the full governance loop (EDR approved → registry active → wiring evidenced → P0 smoke checks pass → tooling evidence captured) and for producing auditable VERIFICATION.md evidence.

---

## 4. Scope

**In scope:**
- Verifying that an extension's EDR exists, is approved, and matches the implementation.
- Verifying registry correctness: all required fields, `status: active`, `wiring_targets`, EDR path.
- Verifying operational wiring evidence: Option A (plan references) or Option B (agent-file additive blocks).
- Running/spot-checking P0 regression checks from `.planning/baseline/P0_SMOKE_CHECKS.md`.
- Capturing tooling evidence (VS Code diagnostics + Chat Debug view) to resolve "loaded vs. not loaded" ambiguity.
- Producing structured output to a phase VERIFICATION.md file.

**Out of scope:**
- Creating or modifying extensions (that is governed by `extension-coordinator`).
- Changing the tool boundary of any agent.
- Approving EDRs (approval is a human/checkpoint decision; this skill verifies that approval already occurred).
- Automated execution of VS Code UI checks (those require user-provided evidence).

---

## 5. Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Checklist context bloats agent sessions | low | `disable-model-invocation: true` prevents auto-loading; skill is loaded only on explicit `/extension-verifier` invocation. |
| Verification evidence is incomplete or misformatted | low | The skill provides an explicit output template for VERIFICATION.md; deviations are immediately visible in plan review. |
| P0 smoke checks are stale (commands refer to old structure) | low | The skill references `.planning/baseline/P0_SMOKE_CHECKS.md` directly; smoke checks are updated in that file if structure changes. |

**P0 regression risk:** This EDR authorizes creating a new file at `.github/skills/extension-verifier/SKILL.md`. No `.github/agents/**` file is modified. P0 anchor preservation is not at risk from the skill creation itself. Smoke checks conducted in Phase 4 — see `.planning/phases/4/VERIFICATION.md` for results.

---

## 6. Verification Plan

- [x] Confirm `REGISTRY.yaml` entry exists with `status: active` and `wiring_targets: [Verifier, Orchestrator]`.
- [x] Confirm EDR path `EDR-20260218-0002-extension-verifier.md` is recorded in registry `edr` field.
- [x] Confirm `.github/skills/extension-verifier/SKILL.md` exists and `name` field matches directory `extension-verifier`.
- [x] Confirm P0 invariants still pass (smoke check results recorded in `.planning/phases/4/VERIFICATION.md`).
- [x] Confirm operational wiring evidence (Option A): Phase 4 PLAN.md includes `@.github/skills/extension-verifier/SKILL.md` reference and invocation instruction.
- [x] Confirm no `.github/agents/**` files were modified (Gate 2 not triggered).

---

## 7. Wiring Contract

### 7a. Declarative wiring (registry)

- [x] `REGISTRY.yaml` entry will include `wiring_targets: [Verifier, Orchestrator]` matching frontmatter `wiring_targets`.
- [x] Registry `status` will be set to `active` only after this EDR is `approved`.

### 7b. Operational wiring — Option A (Plan-driven references)

Selected: **Option A — Plan-driven references (no agent-file edits)**

- The Phase 4 plan (`.planning/phases/4/PLAN.md`) includes an explicit `@.github/skills/extension-verifier/SKILL.md` reference in its Context section.
- The Phase 4 plan text instructs the executing agent to invoke `/extension-verifier` when producing Phase 4 verification evidence (Task 7).
- No `.github/agents/**` files are edited in this pilot.

_Rationale for choosing Option A:_ This pilot is specifically designed to demonstrate that Option A works as a wiring mechanism — complementing Phase 3's demonstration of Option B. Choosing Option A keeps Gate 2 risk at zero, eliminates P0 anchor risk from agent-file edits, and reduces the change surface for this pilot. The skill is for verifier-grade compliance checks triggered during specific phase verification tasks, not general always-on orchestration; on-demand plan-driven loading is appropriate.

---

## 8. Gate A–D Decision Record

**Gate A — Can this be solved without adding anything?**
- [x] No — a new skill is genuinely required. No existing agent file, plan, or `.planning/**` document provides a single, on-demand, invocable verification runbook for the extension governance loop. The gap recurs in every phase that creates an extension and is not solvable by adding content to a single plan without creating a discoverable, reusable reference.

**Gate B — Is a Skill sufficient?**
- [x] Yes — the extension verifier is purely procedural verification knowledge (governance alignment checks, registry field validation, wiring evidence review, P0 spot-check procedure, evidence output template). It requires no new tool boundary; the Verifier and Orchestrator already have all tools needed to execute the verification steps. A skill is loaded on-demand and is portable across wiring target agents.

**Gate C — Agent justification:** N/A — a skill was chosen at Gate B.

**Gate D — Skill-first enforcement verdict**
- [x] PASS — Gate A = NO (extension-free resolution not possible), Gate B = PASS (skill is appropriate, no new tool boundary required), Gate C not reached. Proposal satisfies skill-first policy.

---

## Approval

| Role | Name | Date | Decision |
|---|---|---|---|
| Proposer | JP Dynamic Agent System | 2026-02-18 | Proposed |
| Reviewer | orchestrator-auto-pilot-phase4 | 2026-02-18 | Approved — automated execution of Phase 4 plan; EDR self-approved per user instruction (treat as auto-pilot approval for Phase 4 governed pilot execution) |
