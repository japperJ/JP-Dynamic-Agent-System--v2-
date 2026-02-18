---
edr_id: "EDR-20260218-0001-extension-coordinator"
date: "2026-02-18"
status: "approved"
kind: "skill"
proposed_name: "extension-coordinator"
owner: "JP Dynamic Agent System"
requirements:
  - "REQ-004"
  - "REQ-005"
  - "REQ-006"
  - "REQ-007"
  - "REQ-013"
wiring_targets:
  - "Orchestrator"
  - "Researcher"
  - "Planner"
  - "Coder"
risk_level: "low"
additive_only: true
---

# Extension Decision Record: `extension-coordinator`

---

## 1. Problem / Gap

The JP Dynamic Agent System lacks a repeatable, auditable mechanism for agents to create new skills and agents in a governed way. During normal operation (research, planning, execution, verification, and debugging), agents repeatedly encounter situations where they are tempted to create new capabilities ad hoc — without justification, registry tracking, or wiring verification. This creates a risk of uncontrolled proliferation of unregistered, unwired extensions that violate REQ-005, REQ-006, and REQ-007.

A single, repeatable playbook is needed to make the EDR → decision gates → create → register → wire → verify sequence discoverable and consistently executed by any agent that needs to coordinate an extension creation event.

---

## 2. Why Existing Agents and Skills Cannot Solve This

| Existing thing considered | Why it is insufficient |
|---|---|
| Orchestrator agent (prose only) | The Orchestrator's current instructions do not include a step-by-step EDR-based extension flow; it would have to re-derive the governance procedure each time, with no consistency guarantee. |
| Planner agent (prose only) | The Planner's current instructions focus on roadmap/plan creation; they have no embedded decision-gate checklist for extension creation governance (Gate A–D). |
| `.planning/extensions/DECISION_RULES.md` | This is a reference doc, not an invocable playbook. Agents do not automatically load it; it must be explicitly referenced by a skill or plan. |
| Phase plans (ad hoc references) | Per-plan references capture the flow for a single phase, but the flow needs to be repeatable across phases without re-documenting it each time. |

---

## 3. Proposal

- **Kind:** `skill`
- **Name:** `extension-coordinator`
- **Location:** `.github/skills/extension-coordinator/SKILL.md`
- **One-sentence purpose:** A governed playbook for coordinating the creation of new skills and agents: EDR drafting → Gate A–D decision check → (if approved) create → register → wire → verify.

---

## 4. Scope

**In scope:**
- Governing the process of proposing, approving, creating, registering, and wiring new skills and agents.
- Providing EDR drafting guidance, decision gate checklists, and wiring verification steps.
- Referencing `.planning/extensions/` governance artifacts.

**Out of scope:**
- Implementing any specific skill or agent (this skill governs only).
- Changing the tool boundary of any existing agent.
- Direct file creation (the skill provides instructions; the executing agent acts on them).

---

## 5. Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Governance overhead slows legitimate extension proposals | low | Gate A is the first check — if the gap can be fixed without an extension, processing stops immediately, keeping overhead minimal. |
| Skill context bloats agent sessions | low | `disable-model-invocation: true` prevents auto-loading; the skill is loaded only when explicitly invoked. |
| Additive sections in agent files introduce behavioral drift | low | Sections are strictly append-only; P0 anchors are verified post-edit. |

**P0 regression risk:** This EDR authorizes appending to `.github/agents/orchestrator.agent.md`, `.github/agents/researcher.agent.md`, `.github/agents/planner.agent.md`, and `.github/agents/coder.agent.md`. P0 anchor preservation will be verified by checking all strings listed in `.planning/baseline/P0_INVARIANTS.yaml` remain present after each append. Verification recorded in `.planning/phases/3/VERIFICATION.md`.

---

## 6. Verification Plan

- [x] Confirm `REGISTRY.yaml` entry exists with `status: active` and `wiring_targets: [Orchestrator, Researcher, Planner, Coder]`.
- [x] Confirm EDR path `EDR-20260218-0001-extension-coordinator.md` is recorded in registry `edr` field.
- [x] Confirm `.github/skills/extension-coordinator/SKILL.md` exists and `name` field matches directory.
- [x] Confirm P0 invariants still pass (spot-checked in `.planning/phases/3/VERIFICATION.md`).
- [x] Confirm operational wiring evidence: agent additive blocks in the four detector agents reference the skill path.

---

## 7. Wiring Contract

### 7a. Declarative wiring (registry)

- [x] `REGISTRY.yaml` entry includes `wiring_targets: [Orchestrator, Researcher, Planner, Coder]`.
- [x] Registry `status: active` set only after this EDR is `approved`.

### 7b. Operational wiring — Option B (additive agent-file blocks)

Selected: **Option B — Additive agent-file Skill Index**

Phase 3 appends detection+routing sections to the four target agents (Orchestrator, Researcher, Planner, Coder) under the `## Extension Detection (additive — do not modify existing behavior)` boundary marker. These sections instruct agents to invoke the `extension-coordinator` skill when an extension need is detected.

_Rationale for choosing Option B:_ The extension-coordinator skill governs future extension creation. For it to be effective, agents must have persistent awareness of it and the governed flow — not just awareness during whichever phase happens to reference a plan with the skill in Context. Persistent agent-file wiring provides this. Gate 2 checkpoint satisfied by Phase 3 plan execution authorization (2026-02-18).

_Checkpoint:_ 2026-02-18 — Phase 3 plan execution authorized by user.

---

## 8. Gate A–D Decision Record

**Gate A — Can this be solved without adding anything?**
- [x] No — a new skill is genuinely required. No existing agent file, plan, or `.planning/` document provides a repeatable, invocable governance playbook for extension creation. The gap recurs across phases and is not solvable by adding content to a single plan or agent file without creating a discoverable, on-demand reference.

**Gate B — Is a Skill sufficient?**
- [x] Yes — the extension coordinator is purely procedural governance knowledge (EDR template usage, Gate A–D checks, wiring step guidance). It requires no new tool boundary; Orchestrator, Planner, Coder, and Verifier already have all tools needed to execute the governed steps. A skill is loaded on-demand and is portable across all wiring target agents.

**Gate C — Agent justification:** N/A — a skill was chosen at Gate B.

**Gate D — Skill-first enforcement verdict**
- [x] PASS — Gate B conditions are all satisfied; no new tool boundary is required; skill-first verdict confirmed.

---

## Approval

| Role | Name | Date | Decision |
|---|---|---|---|
| Proposer | JP Dynamic Agent System | 2026-02-18 | Proposed |
| Reviewer | User (Phase 3 authorization) | 2026-02-18 | Approved |
