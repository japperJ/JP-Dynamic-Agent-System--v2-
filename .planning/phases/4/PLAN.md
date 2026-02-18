---
phase: 4
plan: 1
type: implement
wave: 1
depends_on:
  - ".planning/phases/3/VERIFICATION.md"
files_modified:
  - ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"
  - ".github/skills/extension-verifier/SKILL.md"
  - ".planning/extensions/REGISTRY.yaml"
  - ".planning/phases/4/VERIFICATION.md"
  - ".planning/phases/4/SUMMARY.md"
  - ".planning/STATE.md"
autonomous: true
must_haves:
  observable_truths:
    - "A pilot skill (`extension-verifier`) is created via the governed loop: EDR → Gates A–D → approval → skill creation → registry update → operational wiring evidence → verification evidence."
    - "The pilot skill is demonstrably accessible to its intended consumer (Verifier) via wiring evidence (Layer 1 registry + Layer 2 plan-driven reference), and can be invoked as `/extension-verifier`."
    - "A verifier-grade checklist (the skill) is used to produce auditable Phase 4 verification evidence, including P0 smoke checks."
    - "P0 workflow invariants remain intact after the pilot changes (smoke checks PASS)."
  artifacts:
    - path: ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"
      has:
        - "frontmatter status: approved (after checkpoint)"
        - "Section 7 wiring contract declares Option A"
        - "Section 8 Gate A–D decision record with Gate D PASS"
    - path: ".github/skills/extension-verifier/SKILL.md"
      has:
        - "frontmatter name: extension-verifier (matches directory)"
        - "user-invokable: true"
        - "disable-model-invocation: true"
        - "procedure covering: governance alignment, registry correctness, operational wiring evidence, P0 regression, tooling evidence, evidence output"
    - path: ".planning/extensions/REGISTRY.yaml"
      has:
        - "new entry id: ext-skill-extension-verifier"
        - "status: active (only after EDR approved)"
        - "wiring_targets includes Verifier"
        - "edr points to the approved EDR"
    - path: ".planning/phases/4/VERIFICATION.md"
      has:
        - "changed file list"
        - "gate results (Gates 1–4)"
        - "EDR/registry/wiring evidence"
        - "P0 smoke check results"
        - "tooling diagnostics triad notes (loaded/referenced/invoked)"
    - path: ".planning/phases/4/SUMMARY.md"
      has:
        - "what was added and why"
        - "remaining gaps / follow-ups"
  key_links:
    - from: "EDR"
      to: "Registry entry"
      verify: "REGISTRY.yaml edr path exists and EDR status is approved before registry status is set to active"
    - from: "Registry entry"
      to: "Skill source path"
      verify: "source_path points to an existing .github/skills/extension-verifier/ directory"
    - from: "Operational wiring (Option A)"
      to: "Plan references skill"
      verify: "This PLAN.md contains an explicit @ reference to .github/skills/extension-verifier/SKILL.md and an invocation instruction"
    - from: "Skill procedure"
      to: "Phase evidence"
      verify: "Phase 4 VERIFICATION.md is produced by following the extension-verifier checklist"
---

# Phase 4, Plan 1: Pilot extension + hardening (prove the loop)

## Objective
Execute the **full controlled extension governance loop** end-to-end for the pilot skill `extension-verifier` (EDR → decision gates → approval → skill creation → registry update → operational wiring → P0 smoke verification → auditable evidence), then complete a hardening pass that captures any remaining gaps and closes the loop for Phase 4.

## Context
- @.planning/ROADMAP.md — Phase 4 goal + success criteria (REQ-014)
- @.planning/REQUIREMENTS.md — REQ-014 definition
- @.planning/extensions/EDR_TEMPLATE.md — EDR required structure
- @.planning/extensions/DECISION_RULES.md — Gates A–D
- @.planning/extensions/WIRING_CONTRACT.md — Layer 1 vs Layer 2 wiring evidence
- @.planning/extensions/REGISTRY.yaml — registry schema + governance rules
- @.planning/baseline/CHANGE_GATES.md — additive-only gates 1–4
- @.planning/baseline/P0_SMOKE_CHECKS.md — P0 regression spot-check commands
- @.github/skills/extension-coordinator/SKILL.md — use to drive the governed creation flow
- @.github/skills/extension-verifier/SKILL.md — (created in this phase) used to generate Phase 4 verification evidence (Option A wiring)

## Tasks

### Task 1: Draft the EDR for the pilot skill (status: proposed)
- **files:**
  - `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md` (create)
- **action:**
  - Create the EDR by copying `.planning/extensions/EDR_TEMPLATE.md`.
  - Fill every section with repo-specific details from `.planning/phases/4/RESEARCH.md`.
  - Set frontmatter fields:
    - `edr_id: "EDR-20260218-0002-extension-verifier"`
    - `date: "2026-02-18"`
    - `status: "proposed"`
    - `kind: "skill"`
    - `proposed_name: "extension-verifier"`
    - `owner: "JP Dynamic Agent System"`
    - `wiring_targets: ["Verifier"]`
    - `risk_level: "low"`
    - `additive_only: true`
  - In **EDR Section 7b (Wiring Contract)** select **Option A (Plan-driven references)** and record rationale: avoid agent-file edits in the pilot to reduce Gate 2 risk.
  - In **EDR Section 8 (Gate A–D)** record a complete decision trace aligned to `.planning/extensions/DECISION_RULES.md`, with Gate D verdict PASS.
  - (Optional but recommended) Invoke `/extension-coordinator` to keep the flow consistent, then translate its output into the EDR file.
- **verify:**
  - The EDR file exists at the specified path.
  - All template sections are filled (no TODO placeholders).
  - Gate A–D section is complete and Gate D = PASS.
- **done:**
  - A review-ready EDR exists with `status: proposed`, Option A chosen, and `wiring_targets` specified.

### Task 2: Checkpoint — obtain approval to set EDR status to approved
- **type:** checkpoint:decision
- **files:**
  - `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md` (edit)
  - `.planning/STATE.md` (edit)
- **action:**
  - Stop and ask the user to review the EDR content and the Gate A–D reasoning.
  - If approved:
    - Update EDR frontmatter `status: "approved"`.
    - Fill the Approval table with reviewer name/date and decision.
    - Add a row to `.planning/STATE.md` checkpoint log recording the approval (Phase 4, EDR approval).
  - If rejected:
    - Update EDR frontmatter `status: "rejected"`.
    - Record the rejection in the Approval table and checkpoint log.
    - Stop the phase execution (do not create the skill or registry entry).
- **verify:**
  - EDR status matches the user decision.
  - `.planning/STATE.md` contains a checkpoint log entry for the decision.
- **done:**
  - Governance approval is explicitly recorded before any `active` registry entry is created.

### Task 3: Create the pilot skill `extension-verifier` on disk
- **files:**
  - `.github/skills/extension-verifier/SKILL.md` (create)
- **action:**
  - Create the skill directory and `SKILL.md`.
  - Use the minimal content specified in `.planning/phases/4/RESEARCH.md` Section 2, ensuring:
    - `name: extension-verifier` matches the directory name exactly.
    - `user-invokable: true` so `/extension-verifier` works.
    - `disable-model-invocation: true` (progressive disclosure; no auto-loading).
  - Include an explicit procedure/checklist covering:
    - governance alignment (EDR exists, approved, matches implementation)
    - registry correctness (required fields)
    - operational wiring evidence (Option A: plan references + invocation instruction)
    - P0 regression checks (`P0_SMOKE_CHECKS.md`)
    - tooling evidence (Diagnostics + Chat Debug view)
    - evidence output to `.planning/phases/4/VERIFICATION.md`
- **verify:**
  - The file exists and frontmatter parses cleanly.
  - The `name` field matches the directory `extension-verifier`.
- **done:**
  - `/extension-verifier` is available and contains the repo-specific verification runbook.

### Task 4: Register the pilot skill in the extensions registry (Layer 1 wiring)
- **files:**
  - `.planning/extensions/REGISTRY.yaml` (edit)
- **action:**
  - Add a new registry entry under `extensions:`:
    - `id: "ext-skill-extension-verifier"`
    - `kind: "skill"`
    - `name: "extension-verifier"`
    - `purpose:` 1–2 sentences describing the verification workflow
    - `owner: "JP Dynamic Agent System"`
    - `status: "active"` (ONLY if Task 2 approved the EDR)
    - `scope:` verification of extension-loop changes and evidence capture
    - `wiring_targets: ["Verifier"]`
    - `edr: ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"`
    - `source_path: ".github/skills/extension-verifier/"`
    - `created: "2026-02-18"`
    - `updated: "2026-02-18"`
    - optional tags: `governance`, `verification`, `wiring`, `p0`
  - Update top-level `last_updated: "2026-02-18"`.
- **verify:**
  - Registry entry exists and matches the skill directory and EDR path.
  - Governance rule holds: no `active` status unless EDR is `approved`.
- **done:**
  - Registry declaratively wires the skill to `Verifier` and references the approved EDR.

### Task 5: Provide operational wiring evidence (Layer 2, Option A)
- **files:**
  - `.planning/phases/4/PLAN.md` (this file; already contains wiring evidence)
- **action:**
  - Ensure this plan includes:
    - An explicit Context reference to `@.github/skills/extension-verifier/SKILL.md` (already present).
    - An explicit instruction for the executing agent to invoke `/extension-verifier` when producing Phase 4 verification evidence (see Task 7).
  - Do NOT edit any `.github/agents/**` files in this pilot (avoid Gate 2).
- **verify:**
  - Plan contains the `@.github/skills/extension-verifier/SKILL.md` reference.
  - Plan includes an explicit invocation instruction.
- **done:**
  - Layer 2 wiring evidence exists without any agent-file edits.

### Task 6: Run P0 smoke checks and record results
- **files:**
  - `.planning/phases/4/VERIFICATION.md` (create)
- **action:**
  - Run the commands in `.planning/baseline/P0_SMOKE_CHECKS.md` after Tasks 3–4.
  - Record:
    - PASS/FAIL results
    - the exact commands run
    - any output needed to prove checks passed
- **verify:**
  - Smoke checks PASS.
  - Verification file includes dated evidence.
- **done:**
  - P0 regression risk is explicitly checked and evidenced for Phase 4.

### Task 7: Produce full Phase 4 verification evidence by following the pilot skill
- **files:**
  - `.planning/phases/4/VERIFICATION.md` (edit)
- **action:**
  - Invoke `/extension-verifier` and follow its checklist to complete Phase 4 verification.
  - Ensure `VERIFICATION.md` includes:
    - changed file list
    - gates applied (Gates 1–4) and outcomes
    - EDR existence + approval evidence
    - registry entry correctness evidence
    - operational wiring evidence (Option A)
    - P0 smoke check results (from Task 6)
    - tooling evidence triad notes: **loaded / referenced / invoked**
- **verify:**
  - `VERIFICATION.md` fully covers Roadmap Phase 4 success criteria #1–#3.
- **done:**
  - Phase 4 verification evidence is complete, auditable, and grounded in the skill’s procedure.

### Task 8: Checkpoint — capture VS Code host evidence (Diagnostics + Chat Debug view)
- **type:** checkpoint:human-action
- **files:**
  - `.planning/phases/4/VERIFICATION.md` (edit)
- **action:**
  - Request the user to perform the following manual checks in VS Code and provide results (paste text or screenshots summary):
    1) Chat customization **Diagnostics** shows the `extension-verifier` skill is **loaded** (not skipped/failed).
    2) Chat **Debug view** indicates the skill content was present in context when `/extension-verifier` was invoked.
  - Record the user-provided evidence in `VERIFICATION.md` under a "Tooling Evidence" section.
- **verify:**
  - `VERIFICATION.md` includes the loaded/referenced/invoked triad with host evidence.
- **done:**
  - Phase 4 resolves the "it exists but didn’t load" ambiguity with explicit host-level evidence.

### Task 9: Hardening — document gaps, close the loop, and update STATE
- **files:**
  - `.planning/phases/4/SUMMARY.md` (create)
  - `.planning/STATE.md` (edit)
- **action:**
  - Write a concise Phase 4 summary:
    - what was added (EDR, skill, registry entry)
    - why (REQ-014)
    - wiring option chosen (Option A) and rationale
    - what was verified and where (link to `VERIFICATION.md`)
    - remaining gaps/follow-ups (if any) with owners and recommended next actions
  - Update `.planning/STATE.md`:
    - Phase 4 status/completion
    - checkpoint log entries (if any occurred)
- **verify:**
  - Summary references all key artifacts and explicitly calls out any remaining gaps.
  - STATE reflects Phase 4 completion only if verification is PASS.
- **done:**
  - Phase 4 is closed with auditable evidence and clear next steps.

## Verification (end-to-end)
A Phase 4 run is considered complete when:
1. The EDR exists and is approved **before** the registry entry is set to `active`.
2. `.github/skills/extension-verifier/SKILL.md` exists and can be invoked as `/extension-verifier`.
3. `REGISTRY.yaml` contains `ext-skill-extension-verifier` wired to `Verifier` with correct `edr` + `source_path`.
4. This plan provides Layer 2 wiring evidence (Option A reference + invocation instruction).
5. `.planning/phases/4/VERIFICATION.md` proves governance alignment, wiring completeness, and P0 smoke checks PASS.
6. `.planning/phases/4/SUMMARY.md` documents what changed and any remaining hardening gaps.

## Success Criteria (trace to ROADMAP Phase 4)
- SC1: A real pilot skill is created via the governed loop and is accessible to its intended agent(s) (wiring + invocable).
- SC2: No new agent is created in Phase 4 (skill-first; Gate C not reached). If a new agent is later proposed, it requires a new EDR + explicit user approval.
- SC3: A verifier-grade checklist confirms EDR/registry/wiring/P0 smoke checks and results are recorded in Phase 4 verification evidence.
