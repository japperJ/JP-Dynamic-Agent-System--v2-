---
phase: 3
plan: 1
type: implement
wave: 1
depends_on:
  - ".planning/phases/2"  # Phase 2 complete (governance artifacts exist)
dependency_graph:
  task_1:
    needs:
      - .planning/extensions/EDR_TEMPLATE.md
      - .planning/extensions/DECISION_RULES.md
      - .planning/extensions/WIRING_CONTRACT.md
      - .planning/extensions/ADDITIVE_ONLY.md
      - .planning/extensions/REGISTRY.yaml
    creates:
      - .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
  task_2:
    needs:
      - .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
    creates:
      - .github/skills/extension-coordinator/SKILL.md
  task_3:
    needs:
      - .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
      - .github/skills/extension-coordinator/SKILL.md
    creates:
      - .github/agents/orchestrator.agent.md
      - .github/agents/researcher.agent.md
      - .github/agents/planner.agent.md
      - .github/agents/coder.agent.md
  task_4:
    needs:
      - .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
      - .github/skills/extension-coordinator/SKILL.md
    creates:
      - .planning/extensions/REGISTRY.yaml
  task_5:
    needs:
      - .github/skills/extension-coordinator/SKILL.md
      - .github/agents/orchestrator.agent.md
      - .github/agents/researcher.agent.md
      - .github/agents/planner.agent.md
      - .github/agents/coder.agent.md
      - .planning/extensions/REGISTRY.yaml
    creates:
      - .planning/phases/3/VERIFICATION.md
wave_plan:
  wave_1: [task_1]
  wave_2: [task_2]
  wave_3: [task_3, task_4]
  wave_4: [task_5]
files_modified:
  - .planning/phases/3/PLAN.md
  - .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
  - .github/skills/extension-coordinator/SKILL.md
  - .github/agents/orchestrator.agent.md
  - .github/agents/researcher.agent.md
  - .github/agents/planner.agent.md
  - .github/agents/coder.agent.md
  - .planning/extensions/REGISTRY.yaml
  - .planning/phases/3/VERIFICATION.md
autonomous: true
must_haves:
  observable_truths:
    - "A new skill `extension-coordinator` exists and documents the controlled extension flow (EDR → decision gates → create → register → wire → verify)."
    - "No new skill/agent creation occurs without an approved EDR; this requirement is both documented and exercised by the Phase 3 changes."
    - "Only the detector agents identified in Phase 3 research (Orchestrator, Researcher, Planner, Coder) receive additive-only append sections; existing behavior is unchanged unless the extension flow is invoked."
    - "The extensions registry contains an entry for `extension-coordinator` that references an approved EDR and declares wiring targets."
    - "Verification evidence exists showing Gate 2 (agent-file edits) was checkpoint-approved, changes were append-only, and P0 anchors still pass."
  artifacts:
    - path: .github/skills/extension-coordinator/SKILL.md
      has:
        - "Valid SKILL.md frontmatter with name=extension-coordinator"
        - "Procedure: EDR drafting + Gate A–D decision enforcement"
        - "Procedure: create → register → wire → verify checklists"
    - path: .github/agents/orchestrator.agent.md
      has:
        - "Appended section under '## Extensions (additive-only)' that routes extension needs through governed flow and references the skill"
    - path: .github/agents/researcher.agent.md
      has:
        - "Appended section under '## Extensions (additive-only)' that reports extension need proposals to Orchestrator"
    - path: .github/agents/planner.agent.md
      has:
        - "Appended section under '## Extensions (additive-only)' that drafts EDRs and enforces skill-first gates"
    - path: .github/agents/coder.agent.md
      has:
        - "Appended section under '## Extensions (additive-only)' that forbids creating skills/agents without an approved EDR"
    - path: .planning/extensions/REGISTRY.yaml
      has:
        - "A new 'active' skill entry for extension-coordinator with wiring_targets including Orchestrator/Researcher/Planner/Coder"
        - "edr path references an approved EDR file that exists on disk"
    - path: .planning/phases/3/VERIFICATION.md
      has:
        - "Gate checks (1–4) results"
        - "P0 anchor spot-check evidence using .planning/baseline/P0_INVARIANTS.yaml"
  key_links:
    - from: .planning/extensions/REGISTRY.yaml
      to: .planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md
      verify: "Registry entry references an EDR that exists and is approved (status: approved)."
    - from: .github/agents/orchestrator.agent.md
      to: .github/skills/extension-coordinator/SKILL.md
      verify: "Orchestrator additive block references the skill as the preferred coordinator playbook."
    - from: .planning/phases/3/PLAN.md
      to: .planning/extensions/ADDITIVE_ONLY.md
      verify: "Tasks explicitly enforce append-only edits for agent files and require a Gate 2 checkpoint before applying them."
---

# Phase 3, Plan 1: Additive integration of the controlled extension flow

## Objective
Integrate the Phase 2 extension governance artifacts into day-to-day agent operation **without changing baseline (P0) behavior unless the extension flow is explicitly invoked**. This phase delivers a skill-first “extension coordinator” playbook and appends strictly additive, behavior-neutral detection/routing sections to the **detector agents only** (Orchestrator, Researcher, Planner, Coder).

## Context
- Phase 3 success criteria: `.planning/ROADMAP.md` → “Phase 3: Additive integration of the controlled extension flow”
- Phase 3 implementation guidance (including exact additive blocks and detector set): `.planning/phases/3/RESEARCH.md`
- Additive-only constraints + Gate 2 checkpoint rules for agent-file edits: `.planning/extensions/ADDITIVE_ONLY.md` and `.planning/baseline/CHANGE_GATES.md`
- Wiring definition for this repo (registry + operational wiring evidence): `.planning/extensions/WIRING_CONTRACT.md`
- P0 anchors to preserve across agent-file changes: `.planning/baseline/P0_INVARIANTS.yaml`

> Scope constraint (explicit): **Do not create a new agent in Phase 3.** This plan is skill-first per Phase 3 research.

## Tasks

### Task 1: Create an EDR for the `extension-coordinator` skill (and obtain required checkpoints)
- **files:**
  - `.planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-coordinator.md`
- **action:**
  - Draft a new EDR using `.planning/extensions/EDR_TEMPLATE.md` proposing the **skill** `extension-coordinator`.
  - In EDR Section 8, apply `.planning/extensions/DECISION_RULES.md` and record explicit PASS/FAIL reasoning for Gates A–D.
  - In the EDR wiring section, declare the wiring targets as: `Orchestrator`, `Researcher`, `Planner`, `Coder`.
  - Declare the operational wiring mechanism for this skill:
    - Minimum requirement: the Phase 3 plan + agent additive blocks will reference the skill path, satisfying the “operationally referenced” expectation.
    - (Do not add an agent-file “Approved Skills” index unless explicitly decided; keep edits minimal.)
  - Request two user checkpoints before proceeding further:
    1) **EDR approval checkpoint**: approve setting the EDR `status: approved`.
    2) **Gate 2 checkpoint**: approve additive append edits to `.github/agents/**` (high-risk).
- **verify:**
  - EDR exists under `.planning/extensions/edr/` and matches template structure.
  - EDR `kind: skill` and explicitly states **no new agent** is proposed.
  - User checkpoint recorded in chat (EDR approved + agent-file edit approval).
- **done:**
  - An EDR exists on disk for `extension-coordinator`, includes Gate A–D reasoning, and is marked `approved` (after user checkpoint).

### Task 2: Create the new project skill `extension-coordinator`
- **files:**
  - `.github/skills/extension-coordinator/SKILL.md`
- **action:**
  - Create the skill file exactly per Phase 3 research guidance:
    - Valid frontmatter (`name: extension-coordinator`, `description`, plus recommended fields like `argument-hint`, `user-invokable`, `disable-model-invocation`).
    - Body content that governs the controlled extension flow: **EDR → decision gates → (if approved) create → register → wire → verify**.
  - Keep the skill scoped to coordination/governance and compatible with “skill-first” policy.
- **verify:**
  - Skill directory name matches the `name:` field.
  - The skill text explicitly forbids ad-hoc creation of skills/agents without an approved EDR.
- **done:**
  - `.github/skills/extension-coordinator/SKILL.md` exists with valid frontmatter and a complete governance playbook.

### Task 3: Append additive detection + routing sections to detector agents ONLY (Orchestrator, Researcher, Planner, Coder)
- **files:**
  - `.github/agents/orchestrator.agent.md`
  - `.github/agents/researcher.agent.md`
  - `.github/agents/planner.agent.md`
  - `.github/agents/coder.agent.md`
- **action:**
  - Append the exact additive blocks specified in `.planning/phases/3/RESEARCH.md` to the end of each target file.
  - The appended content MUST:
    - be placed under the boundary marker `## Extensions (additive-only)` and include the required HTML comment
    - be strictly append-only (no edits above the marker)
    - be behavior-neutral unless the extension flow is invoked
  - **Do not edit any other agent files** (explicitly exclude: Designer, Verifier, Debugger).
- **verify:**
  - Gate 2 is satisfied: checkpoint obtained before applying agent-file edits.
  - Git diff shows only additions in the four files; no deletions/rewrites.
  - Spot-check P0 anchors still exist (per `.planning/baseline/P0_INVARIANTS.yaml`), especially in `orchestrator.agent.md`.
- **done:**
  - Only the four detector agents have new append-only extension sections, and all P0 anchors remain present.

### Task 4: Register the new skill in `.planning/extensions/REGISTRY.yaml`
- **files:**
  - `.planning/extensions/REGISTRY.yaml`
- **action:**
  - Add a new registry entry for the `extension-coordinator` skill.
  - Ensure the entry satisfies the registry governance rules:
    - `status: active` only after the EDR is approved
    - `edr:` points to the EDR path created in Task 1
    - `wiring_targets` includes the four detector agents
    - `source_path` points to `.github/skills/extension-coordinator/`
  - Update `last_updated`.
- **verify:**
  - The YAML remains well-formed.
  - The EDR path exists and is approved.
- **done:**
  - Registry contains an active entry for `extension-coordinator` with correct wiring targets and an approved EDR reference.

### Task 5: Create Phase 3 verification evidence (gates + invariants + wiring)
- **files:**
  - `.planning/phases/3/VERIFICATION.md`
- **action:**
  - Record evidence required by `.planning/baseline/CHANGE_GATES.md` Gate 4:
    - changed file list
    - applied gate results (1–4)
    - checkpoint notes for Gate 2
    - P0 anchor spot-check evidence (cite which invariants were checked and how)
  - Explicitly verify Phase 3 wiring completeness (per `.planning/extensions/WIRING_CONTRACT.md`):
    - declarative wiring: registry entry includes `wiring_targets`
    - operational references: agent additive blocks and/or plan references include the skill path
- **verify:**
  - Evidence is sufficient for an independent Verifier to reproduce the checks.
- **done:**
  - `.planning/phases/3/VERIFICATION.md` exists and demonstrates additive-only compliance and Phase 3 success criteria coverage.

## Verification (phase-level)
A Verifier should be able to confirm:
1. **EDR gating**: a new skill was created only after an approved EDR exists and the registry references it.
2. **Wiring**: `REGISTRY.yaml` declares wiring targets and the detector agents contain operational references to the skill (additive sections).
3. **P0 preserved**: agent-file edits are strictly append-only and P0 anchors in `.planning/baseline/P0_INVARIANTS.yaml` still match.
4. **Additive-only**: diffs show only additions and required checkpoints/evidence are recorded.

## Success Criteria (trace)
Mapped to `.planning/ROADMAP.md` Phase 3 observable truths:
1. Blocks creation without approved EDR: enforced by EDR + registry rules + agent append sections that prohibit ad-hoc creation.
2. Skill wired to correct agents: registry wiring_targets + additive operational references in detector agents.
3. P0 unchanged unless invoked: append-only, behavior-neutral extension sections; no rewrites.
4. Verification gates exist: Phase 3 VERIFICATION.md contains gates + invariants + wiring evidence.
