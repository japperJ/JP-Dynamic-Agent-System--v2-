---
phase: 2
plan: 1
type: implement
wave: 1
depends_on:
  - ".planning/phases/1"  # Phase 1 complete (baseline + gates)
dependency_graph:
  task_1:
    needs: []
    creates:
      - .planning/extensions/README.md
      - .planning/extensions/edr/.gitkeep
  task_2:
    needs:
      - .planning/extensions/README.md
      - .planning/extensions/edr/.gitkeep
    creates:
      - .planning/extensions/EDR_TEMPLATE.md
  task_3:
    needs:
      - .planning/extensions/README.md
    creates:
      - .planning/extensions/REGISTRY.yaml
  task_4:
    needs:
      - .planning/extensions/EDR_TEMPLATE.md
      - .planning/extensions/REGISTRY.yaml
    creates:
      - .planning/extensions/DECISION_RULES.md
      - .planning/extensions/WIRING_CONTRACT.md
      - .planning/extensions/ADDITIVE_ONLY.md
wave_plan:
  wave_1: [task_1]
  wave_2: [task_2, task_3]
  wave_3: [task_4]
files_modified:
  - .planning/phases/2/PLAN.md
  - .planning/extensions/README.md
  - .planning/extensions/EDR_TEMPLATE.md
  - .planning/extensions/REGISTRY.yaml
  - .planning/extensions/edr/.gitkeep
  - .planning/extensions/DECISION_RULES.md
  - .planning/extensions/WIRING_CONTRACT.md
  - .planning/extensions/ADDITIVE_ONLY.md
autonomous: true
must_haves:
  observable_truths:
    - "An EDR template exists and requires (problem, why existing can’t solve, proposal, risks, verification, wiring targets)."
    - "An extensions registry exists with approved extensions, purpose, owner, scope, wiring targets, and status."
    - "Decision rules (skill-first) are documented as a testable decision tree."
    - "A wiring contract is documented so registry + operational references define what ‘wired’ means."
    - "Additive-only constraints are documented for extension-related changes (including agent-file gate + checkpoints)."
  artifacts:
    - path: .planning/extensions/EDR_TEMPLATE.md
      has:
        - "YAML frontmatter (edr_id, status, kind, proposed_name, owner, requirements, wiring_targets, risk_level, additive_only)"
        - "Body sections: Problem, Why existing can’t solve, Proposal, Risks, Verification plan, Wiring contract"
    - path: .planning/extensions/REGISTRY.yaml
      has:
        - "version"
        - "last_updated"
        - "extensions[] entries with id/kind/name/purpose/owner/status/scope/wiring_targets/edr/source_path/created/updated"
    - path: .planning/extensions/DECISION_RULES.md
      has:
        - "Gate A-D skill-first decision rules"
        - "Agent justification questions (why not skill, tool boundary, least privilege, deprecation plan)"
    - path: .planning/extensions/WIRING_CONTRACT.md
      has:
        - "Declarative wiring (REGISTRY.yaml wiring_targets)"
        - "Operational wiring Option A (plan-driven @ references)"
        - "Operational wiring Option B (additive agent-file Skill Index)"
    - path: .planning/extensions/ADDITIVE_ONLY.md
      has:
        - "Explicit statement: changes are additive-only"
        - "Reference to baseline gates and checkpoint triggers"
  key_links:
    - from: .planning/extensions/REGISTRY.yaml
      to: .planning/extensions/edr/
      verify: "Registry entries reference an EDR path that exists (or are not 'active')."
    - from: .planning/extensions/EDR_TEMPLATE.md
      to: .planning/extensions/WIRING_CONTRACT.md
      verify: "EDR template requires declaring wiring targets + an operational wiring mechanism choice."
    - from: .planning/extensions/DECISION_RULES.md
      to: .planning/extensions/EDR_TEMPLATE.md
      verify: "Decision rules are enforced by EDR questions and required fields."
---

# Phase 2, Plan 1: Governance for controlled self-extension

## Objective
Create the governance artifacts that must exist before any new skill/agent is created: a mandatory EDR template, an auditable registry, explicit skill-first decision rules, a wiring contract that defines what “wired” means, and additive-only constraint documentation. This phase is **docs + metadata only** and should remain within `.planning/**`.

## Context
- Phase success criteria: `.planning/ROADMAP.md` → “Phase 2: Governance for controlled self-extension (skill-first)”
- Phase 2 implementation guidance (including wiring mechanism): `.planning/phases/2/RESEARCH.md`
- Additive-only gates (baseline): `.planning/baseline/CHANGE_GATES.md`

> Wiring mechanism to reference (from RESEARCH):
> - **Declarative wiring:** `REGISTRY.yaml` contains `wiring_targets` (which agents are expected to reference/use the extension)
> - **Operational wiring evidence:** either (A) plan-driven `@.github/skills/<name>/SKILL.md` references in phase plans, or (B) additive “Skill Index” sections appended to target agent files (checkpoint-gated)

## Tasks

### Task 1: Scaffold `.planning/extensions/` governance folder
- **files:**
  - `.planning/extensions/README.md`
  - `.planning/extensions/edr/.gitkeep`
- **action:**
  - Create the canonical Phase 2 governance directory structure under `.planning/extensions/`.
  - Document the purpose of each artifact (EDR template, registry, decision rules, wiring contract, additive-only policy, and EDR archive directory).
- **verify:**
  - Confirm the folder exists and contains the expected files.
  - Confirm all changes are under `.planning/**` (Gate 1 in `CHANGE_GATES.md`).
- **done:**
  - `.planning/extensions/` exists with an `edr/` subfolder tracked in git and a README that explains the governance artifacts.

### Task 2: Create mandatory EDR template (Extension Decision Record)
- **files:**
  - `.planning/extensions/EDR_TEMPLATE.md`
- **action:**
  - Implement the EDR template described in Phase 2 research (YAML frontmatter + required narrative sections).
  - Include required fields that support Phase 2 success criteria:
    - Problem/gap, why existing agents/skills can’t solve it, proposal, risks, verification plan, and **wiring target(s)**.
  - Include an explicit “operational wiring mechanism choice” section that references the wiring contract (Option A vs Option B).
- **verify:**
  - Frontmatter contains: `edr_id`, `date`, `status`, `kind`, `proposed_name`, `owner`, `requirements`, `wiring_targets`, `risk_level`, `additive_only`.
  - Body contains minimum required sections aligned to Roadmap Phase 2 success criteria.
- **done:**
  - A new extension cannot be proposed without filling an EDR that captures both governance intent and wiring intent (targets + operational mechanism).

### Task 3: Create the extensions registry (auditable source of truth)
- **files:**
  - `.planning/extensions/REGISTRY.yaml`
- **action:**
  - Create the canonical registry with schema v1 (as described in Phase 2 research).
  - Add a brief header comment clarifying that the registry may initially contain zero approved extensions (empty list) until the first EDR is approved.
  - Include at least one commented/example entry showing how `wiring_targets` and `edr` path are represented.
  - Encode the governance rule: entries must not be set to `active` without an approved EDR path.
- **verify:**
  - YAML is well-formed and includes `version`, `last_updated`, and `extensions: []`.
  - Schema fields support Phase 2 success criteria #2 and wiring contract needs.
- **done:**
  - A durable registry exists that can list approved skills/agents with purpose/owner/scope/wiring targets/status and EDR reference (and explicitly documents the “empty until first approval” bootstrap state).

### Task 4: Document decision rules, wiring contract, and additive-only constraints
- **files:**
  - `.planning/extensions/DECISION_RULES.md`
  - `.planning/extensions/WIRING_CONTRACT.md`
  - `.planning/extensions/ADDITIVE_ONLY.md`
- **action:**
  - Write a testable “skill-first” decision rule doc (Gate A-D as described in Phase 2 research), including the explicit agent-justification questions.
  - Write a wiring contract doc that defines:
    - Declarative wiring via `REGISTRY.yaml` (`wiring_targets`)
    - Operational wiring Option A (plan-driven `@` references to skills)
    - Operational wiring Option B (additive agent-file “Skill Index” sections; checkpoint-gated)
  - Write an additive-only constraints doc for extension governance work that:
    - Summarizes the baseline gates
    - Calls out the special risk of editing `.github/agents/**`
    - Restates “append-only” as the only allowed shape for any agent-file extension wiring edits (when Phase 3 decides to do so)
- **verify:**
  - Docs explicitly reference the wiring mechanism (declarative + operational) from `.planning/phases/2/RESEARCH.md`.
  - Docs reference `.planning/baseline/CHANGE_GATES.md` for enforcement/checkpoints.
- **done:**
  - Phase 2 success criteria #3 and #4 are satisfied: decision rules are clear/testable and wiring is defined as both discoverable + referenced.

## Verification (phase-level)
- Confirm Phase 2 artifacts exist:
  - `.planning/extensions/EDR_TEMPLATE.md`
  - `.planning/extensions/REGISTRY.yaml`
  - `.planning/extensions/DECISION_RULES.md`
  - `.planning/extensions/WIRING_CONTRACT.md`
  - `.planning/extensions/ADDITIVE_ONLY.md`
- Confirm all edits are under `.planning/**` (Gate 1) and are additive (new files).
- Cross-check Phase 2 success criteria:
  1) EDR template includes all mandatory capture fields + wiring targets
  2) Registry exists with required fields
  3) Decision rule is documented + testable
  4) Wiring contract defines what “wired” means (registry + operational evidence)

## Success Criteria (trace)
Mapped directly to `.planning/ROADMAP.md` Phase 2 observable truths:
1. EDR template exists and captures problem/justification/proposal/risks/verification/wiring targets.
2. Registry exists and lists approved skills/agents with purpose/owner/scope/wiring targets/status.
3. Decision rule (skill vs agent) is documented and testable.
4. Wiring contract is defined so an extension must be both discoverable and referenced by the correct agent(s).
