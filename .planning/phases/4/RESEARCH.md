# Phase 4 Research — Pilot extension + hardening (prove the loop)

## Summary

Phase 4 must satisfy **REQ-014**: prove the controlled extension loop end-to-end with a **real** pilot skill (and an agent only if justified/approved) while preserving P0 and additive-only rules.

**Recommendation (pilot skill candidate):** create a new skill named **`extension-verifier`**.

- **What it does:** a verifier-focused, repo-specific runbook for validating extension-loop changes (EDR ⇄ registry ⇄ wiring ⇄ P0 smoke checks) and producing auditable verification evidence.
- **Why it’s a real gap:** the current `Verifier` agent is a general “goal-backward” verifier and does not contain extension-governance-specific verification steps; the existing `extension-coordinator` skill governs *creation*, not *verification*. As the system grows, missing/uneven verification steps are a predictable failure mode.
- **Why a skill (not an agent):** this is procedural knowledge + checklists; it does not require a new tool boundary.

## 1) Pilot skill candidate (ONE) with Gate A–D justification

### Candidate: `extension-verifier`

**Problem statement (the gap):**

There is no single, on-demand, verifier-grade workflow that:

1) checks that a new extension actually followed governance (EDR exists, is approved, matches implementation),
2) validates registry + wiring completeness per `.planning/extensions/WIRING_CONTRACT.md`,
3) runs P0 regression spot-checks per `.planning/baseline/P0_SMOKE_CHECKS.md`, and
4) captures tooling/host evidence (customization diagnostics + Chat Debug view) to reduce “it exists but it didn’t load / wasn’t used” ambiguity.

Today these requirements are spread across multiple `.planning/**` docs (and previous phase verification evidence), while the `Verifier` agent file remains intentionally generic.

### Gate A — Can this be solved without adding anything?

**Assessment: NO.**

- A single prompt can’t reliably reproduce a multi-part verification procedure with consistent output formatting and the correct repo-local references.
- Adding content directly to existing agent files would:
  - trigger Gate 2 (agent-file gate) and require checkpointing,
  - risk P0 anchor breakage,
  - and would permanently bloat the always-on agent instructions.
- A `.planning/**` doc could partially help, but it is not progressive-loaded as a “capability” and is easier to forget to reference; Phase 4’s stated goal is to prove the *extension loop* with a real example skill, so we should pick a gap where a skill is the right packaging.

### Gate B — Default to Skill

**Assessment: PASS.** This gap is procedural verification knowledge and a repeatable workflow, and it requires **no new tool permissions**.

- Skills are explicitly designed for “specialized capabilities and workflows” and can include checklists and resources/scripts while being loaded on-demand (progressive disclosure).

### Gate C — Agent justification (only if skill is insufficient)

**Assessment: NOT REACHED.** No new tool boundary or role contract is required.

### Gate D — Verdict

**PASS** (Gate A = NO extension-free resolution; Gate B = skill is appropriate; Gate C not reached).

## 2) Minimal `SKILL.md` content for the pilot skill

> This is the minimal content that should live at `.github/skills/extension-verifier/SKILL.md`.

```markdown
---
name: extension-verifier
description: Verify controlled extension-loop changes in this repo (EDR ↔ registry ↔ wiring ↔ P0 smoke checks) and record auditable evidence in phase VERIFICATION.md.
argument-hint: "[phase] [extension id/name] [EDR path] [wiring option A|B]"
user-invokable: true
disable-model-invocation: true
---

# extension-verifier — JP controlled extension verification

## When to use

Use this skill when verifying any change that:
- adds or changes an extension (skill/agent),
- modifies `.planning/extensions/**` governance artifacts,
- modifies `.github/skills/**`, or
- modifies `.github/agents/**` for operational wiring.

## Required inputs

- Phase number (e.g., 4)
- Proposed extension name/id and `REGISTRY.yaml` entry location
- EDR path
- Declared operational wiring option (A plan-driven or B agent-file index)
- List of changed files / commits for the phase

## Procedure (checklist)

### 1) Governance alignment
- Confirm the EDR exists at the referenced path and is **approved**.
- Confirm the EDR’s Gate A–D section is complete and Gate D is PASS.
- Confirm the EDR’s declared wiring option matches what was implemented.

### 2) Registry correctness (declarative wiring)
- Confirm `REGISTRY.yaml` has an entry with:
  - `status: active`
  - `kind: skill`
  - `name` matches `.github/skills/<name>/`
  - `edr` points to the approved EDR
  - `wiring_targets` includes at least one intended agent

### 3) Operational wiring evidence
- Option A: verify Phase plan(s) reference `@.github/skills/extension-verifier/SKILL.md` and instruct invocation.
- Option B: verify additive-only appended section(s) exist in target agent files and diffs are additions-only.

### 4) P0 regression
- Run/spot-check `.planning/baseline/P0_SMOKE_CHECKS.md` and record PASS/FAIL.

### 5) Tooling evidence (reduce “loaded vs not loaded” ambiguity)
- Use VS Code Chat customization **Diagnostics** to confirm the skill is **loaded** (not skipped/failed).
- Use VS Code **Chat Debug view** to confirm the expected skill content appears in the System prompt/Context when invoked.

### 6) Evidence output
- Write verification results to `.planning/phases/<phase>/VERIFICATION.md`, including:
  - file list
  - gate results
  - wiring evidence
  - P0 smoke-check status
  - diagnostics notes (loaded/failed/skipped)

## References

- `.planning/extensions/DECISION_RULES.md`
- `.planning/extensions/WIRING_CONTRACT.md`
- `.planning/extensions/REGISTRY.yaml`
- `.planning/baseline/P0_SMOKE_CHECKS.md`
- VS Code troubleshooting + diagnostics
```

## 3) Wiring: which agents should receive the pilot skill reference?

**Recommended minimal wiring targets (declarative):**

- `Verifier` (primary consumer)

**Recommended operational wiring (Layer 2): Option A — plan-driven reference**

Rationale:
- Demonstrates that Option A works (complements Phase 3’s Option B precedent).
- Avoids editing `.github/agents/**` in the pilot, reducing risk and eliminating Gate 2 checkpoint needs.

Concrete wiring evidence to include during Phase 4 execution:
- In the Phase 4 plan(s), include an explicit reference:
  - `@.github/skills/extension-verifier/SKILL.md`
- In the Phase 4 verification task instructions, explicitly tell the Verifier to invoke `/extension-verifier`.

**Optional later wiring targets (not required for Phase 4):**
- `Coder` (pre-flight self-check before commits)

## 4) End-to-end verification checklist (Phase 4 success criteria)

This checklist is designed to be run by the Verifier as Phase 4 evidence.

### A. Precondition checks (tooling + environment)
- [ ] Workspace is trusted (agents enabled; not in restricted mode).
- [ ] Chat customization Diagnostics is accessible and shows current loaded customizations.
- [ ] Chat Debug view accessible (for inspecting context/tools/system prompt).

### B. Governance flow proof (EDR → creation → wiring → verification)
- [ ] New EDR exists for the pilot skill at `.planning/extensions/edr/EDR-YYYYMMDD-NNNN-extension-verifier.md`.
- [ ] Gate A–D recorded in EDR Section 8; Gate D verdict PASS.
- [ ] EDR `status: approved` before the registry entry is set to `active`.
- [ ] Skill directory created at `.github/skills/extension-verifier/` and contains `SKILL.md` with valid frontmatter (`name` matches directory).
- [ ] `REGISTRY.yaml` updated with a new entry:
  - id: `ext-skill-extension-verifier`
  - status: `active`
  - edr: points to approved EDR
  - wiring_targets: includes Verifier
  - source_path points to `.github/skills/extension-verifier/`

### C. Wiring completeness (Layer 1 + Layer 2)
- [ ] Declarative wiring: registry entry exists and is correct.
- [ ] Operational wiring (Option A): Phase 4 plan references `@.github/skills/extension-verifier/SKILL.md` and includes an invocation instruction.

### D. “It actually loads” validation (host evidence)
- [ ] Chat customization Diagnostics shows `extension-verifier` skill status = loaded (not skipped/failed) and any errors are recorded.
- [ ] Chat Debug view shows the skill’s body was loaded when invoked (evidence: Context / System prompt sections).

### E. P0 regression checks
- [ ] `.planning/baseline/P0_SMOKE_CHECKS.md` passes after the pilot changes.
- [ ] No unexpected edits outside intended scope.

### F. Evidence output
- [ ] `.planning/phases/4/VERIFICATION.md` exists and includes:
  - changed file list
  - gate results (path gate, diff shape, agent-file gate if applicable)
  - EDR/registry/wiring evidence
  - P0 smoke check status
  - diagnostics + Chat Debug view notes

## 5) Confirm: no new agent is needed (skill-first)

**Confirmed:** No new agent is needed for the Phase 4 pilot.

This pilot is a workflow/checklist. It requires no new tool permissions and does not need context isolation or a separate role contract.

### Threshold that WOULD justify an agent (Gate C)

A new agent might become justified only if one (or more) of these become true:

- We need a **strict tool boundary** for verification (for example, a “read-only auditor” agent that can *not* edit files), and none of the existing agents can satisfy that least-privilege need.
- We need **context isolation** (for example, the verifier must not see certain implementation context, or must run in a constrained environment).
- We need an explicit **role contract / workflow orchestration change** (handoffs, hard separation between implementation and verification actions).

If any of the above is proposed, it must pass Gate C’s four justification questions in a new EDR, and requires explicit user approval (per ROADMAP Phase 4 checkpoints).

## 6) Hardening steps to make the extension loop production-grade

These are additive documentation/process hardening items that reduce ambiguity and future regressions.

### A) Standardize “loaded vs referenced vs invoked” evidence

Add (or formalize within Phase 4 verification) a required evidence triad for every active skill:

1) **Loaded** — Chat customization Diagnostics shows the skill is loaded (not skipped/failed).
2) **Referenced** — registry entry + operational wiring evidence exists.
3) **Invoked** — Chat Debug view confirms the skill body was present in context during the run.

Rationale: eliminates the most common ambiguity in agent customizations.

### B) Document the diagnostics playbook (VS Code)

Include a short “Diagnostics SOP” (either in the new skill or in baseline docs) that:

- shows how to open Chat customization Diagnostics (right-click Chat → Diagnostics)
- explains status meanings (loaded/skipped/failed)
- shows how to open Chat Debug view and which sections matter (System prompt / Context / Tool responses)

### C) Reduce agent-file edits as the default

Phase 3 chose Option B for `extension-coordinator` for persistent discoverability. For future skills, treat Option A as the default unless there’s a demonstrated reason the agent must always know about the skill.

This reduces:
- Gate 2 checkpoint frequency
- P0 anchor risk
- merge conflict surface in `.github/agents/**`

### D) Add security hygiene to the loop (host-level)

Reference VS Code’s security baseline:
- review edits before accepting (diff review)
- protect sensitive files via edit approval rules (e.g., `.env`, `.vscode/*.json`)
- be explicit about MCP server trust and avoid enabling broad auto-approvals

Even though this repo is “docs/governance heavy,” Phase 4 is where this becomes operational.

### E) Make “tool availability” checks first-class evidence

Phase 4 hidden-risk checks explicitly require tool availability checks. Record them in Phase 4 verification:

- workspace trust state
- diagnostics availability
- Chat Debug view availability
- (if any MCP servers used) MCP status/log availability

### F) Create a repeatable phase verification template for extension changes

Optionally create a template section (in Phase 4 plan or in a baseline doc) with:

- changed file list (auto-collected)
- gate results
- EDR/registry/wiring table
- P0 status
- diagnostics triad evidence

## Sources (verified)

Repo-local:
- `.planning/ROADMAP.md` (Phase 4 goal + success criteria)
- `.planning/REQUIREMENTS.md` (REQ-014)
- `.planning/extensions/DECISION_RULES.md` (Gates A–D)
- `.planning/extensions/WIRING_CONTRACT.md`
- `.planning/baseline/P0_SMOKE_CHECKS.md`

Official docs (HIGH confidence):
- Agent Skills in VS Code: https://code.visualstudio.com/docs/copilot/customization/agent-skills
- Custom agents in VS Code: https://code.visualstudio.com/docs/copilot/customization/custom-agents
- Troubleshooting + customization diagnostics: https://code.visualstudio.com/docs/copilot/troubleshooting
- Chat Debug view: https://code.visualstudio.com/docs/copilot/chat/chat-debug-view
- Security considerations: https://code.visualstudio.com/docs/copilot/security
- Review AI-generated edits: https://code.visualstudio.com/docs/copilot/chat/review-code-edits
- MCP servers (trust + logs): https://code.visualstudio.com/docs/copilot/customization/mcp-servers
