# Deep Dive — `japperJ/v2test` (master) vs Local Workspace Orchestrator/Skill

**Date:** 2026-02-19  
**Repos compared:**
- **Remote:** `japperJ/v2test` (branch `master`)
- **Local workspace:** `JP Dynamic Agent System (v2)` (this VS Code workspace)

This report is designed to answer the “gap signal” questions and include:
1) the complete remote repo file list, and  
2) verbatim contents of the requested key files (remote + local equivalents).

---

## ✅ Direct answers to the 7 gap-signal questions

### 1) What did `v2test` actually build?
`v2test` is not just governance docs: it contains a complete application repo **that embeds** the JP Dynamic Agent System governance artifacts.

Evidence from the remote repo file list (see Appendix A):
- Application code exists across: `backend/`, `frontend/`, `workers/`, `e2e/`, `infrastructure/`.
- A concrete project planning subtree exists at `.planning/geo/` with phases, plans, summaries, verification, and integration evidence.

The app is explicitly identified in `.planning/STATE.md` as:
- **Project:** “Geo-Fenced Multi-Site Webserver”
- **Location:** `.planning/geo/`

### 2) How many phases are complete?
There are **two distinct “phase systems”** in play in the remote repo:

**(A) JP Dynamic Agent System governance phases** (repo-level lifecycle)
- From remote `.planning/STATE.md`: Phase 0–2 are complete; Phase 3 is active.

**(B) The embedded application project phases** (Geo-Fenced Multi-Site Webserver)
- From remote `.planning/geo/STATE.md`: **Phases 0–5 are ✅ complete** (with verification + integration).

Notable: the remote `.planning/STATE.md` “Active Projects” row says the geo project is “Phase 2 Complete, Phase 3 pending”, but `.planning/geo/STATE.md` later indicates Phase 5 complete. Treat `.planning/geo/STATE.md` as the more authoritative, project-scoped artifact for project phase completion.

### 3) What skills/agents are present?
Remote `.planning/STATE.md` lists 7 agents active:
- Orchestrator, Researcher, Planner, Coder, Designer, Verifier, Debugger

Remote `.planning/extensions/REGISTRY.yaml` has exactly two **active** extensions:
- `ext-skill-extension-coordinator`
- `ext-skill-extension-verifier`

### 4) Were EDRs created?
Yes. Remote repo contains **two approved EDRs**:
- `.planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md`
- `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md`

Both are referenced by `.planning/extensions/REGISTRY.yaml` as required by the registry governance rules.

### 5) How does the Orchestrator “Extension Detection” trigger work (passive vs active)?
It is explicitly **passive / escalation-driven**.

Remote `.github/agents/orchestrator.agent.md` says the extension governance escalation section:
- “**activates only when an extension need is explicitly reported**”

So the Orchestrator is not “constantly scanning” for extension needs; it responds to subagent reports.

### 6) Are subagents instructed to report extension needs (so the flow can trigger)?
Yes (remote repo evidence):
- **Researcher** contains an “Extension Need Report” template instructing the agent to report extension needs to the Orchestrator (skill-first).
- **Coder** contains a “Stop/route rule” stating that if extension creation conditions aren’t met, it must **STOP and return a decision checkpoint to the Orchestrator** to initiate the governed flow.
- **Planner** contains an “Extension governance support” section instructing that when an extension is needed it should draft EDR + gates, and provide a routing message to Orchestrator.

This is exactly the “bridge” required for the passive Orchestrator trigger to actually fire.

### 7) Is there a structural gap that would prevent extension creation flow from ever triggering?
No “broken” mechanism is evident.

What’s true instead:
- The design is **intentionally event-driven**: Orchestrator’s extension flow triggers only when a subagent *reports* the need.
- Remote repo includes explicit escalation instructions in the agents most likely to detect the gap (Researcher/Planner/Coder).

The only “non-bug risk” is operational/human:
- If a gap is detected by an agent that **does not** contain the escalation language (or if the agent ignores it), the Orchestrator will not magically detect it.

That’s not a missing artifact; it’s the intended contract.

---

## Appendix A — Complete remote repo file list (`japperJ/v2test`, `master`)

**TOTAL_FILES = 169** (blobs only)

```
.github/agents/coder.agent.md
.github/agents/debugger.agent.md
.github/agents/designer.agent.md
.github/agents/orchestrator.agent.md
.github/agents/planner.agent.md
.github/agents/researcher.agent.md
.github/agents/verifier.agent.md
.github/skills/extension-coordinator/SKILL.md
.github/skills/extension-verifier/SKILL.md
.github/workflows/ci.yml
.gitignore
.planning/baseline/CHANGE_GATES.md
.planning/baseline/P0_INVARIANTS.yaml
.planning/baseline/P0_SMOKE_CHECKS.md
.planning/baseline/TOOL_FALLBACKS.md
.planning/debug/BUG-20260219-001.md
.planning/extensions/ADDITIVE_ONLY.md
.planning/extensions/DECISION_RULES.md
.planning/extensions/EDR_TEMPLATE.md
.planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md
.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md
.planning/extensions/REGISTRY.yaml
.planning/extensions/VERIFICATION.md
.planning/extensions/WIRING_CONTRACT.md
.planning/geo/INTEGRATION.md
.planning/geo/phases/0/PLAN.md
.planning/geo/phases/0/SUMMARY.md
.planning/geo/phases/0/VERIFICATION.md
.planning/geo/phases/1/PLAN.md
.planning/geo/phases/1/RESEARCH.md
.planning/geo/phases/1/VERIFICATION.md
.planning/geo/phases/2/PLAN.md
.planning/geo/phases/2/RESEARCH.md
.planning/geo/phases/2/VERIFICATION.md
.planning/geo/phases/3/PLAN.md
.planning/geo/phases/3/RESEARCH.md
.planning/geo/phases/3/SUMMARY.md
.planning/geo/phases/3/VERIFICATION.md
.planning/geo/phases/4/PLAN.md
.planning/geo/phases/4/RESEARCH.md
.planning/geo/phases/4/SUMMARY.md
.planning/geo/phases/4/VERIFICATION.md
.planning/geo/phases/5/PLAN.md
.planning/geo/phases/5/RESEARCH.md
.planning/geo/phases/5/SUMMARY.md
.planning/geo/phases/5/VERIFICATION.md
.planning/geo/STATE.md
.planning/REQUIREMENTS.md
.planning/ROADMAP.md
.planning/STATE.md
backend/.env.example
backend/.eslintrc.json
backend/.gitignore
backend/.prettierrc
backend/data/maxmind/.gitkeep
backend/data/maxmind/README.md
backend/Dockerfile
backend/Dockerfile.dev
backend/migrations/001_create_sites.sql
backend/migrations/002_create_access_logs.sql
backend/migrations/003_create_users.sql
backend/migrations/004_create_refresh_tokens.sql
backend/migrations/005_create_audit_log.sql
backend/package-lock.json
backend/package.json
backend/scripts/seed-admin.ts
backend/src/app.test.ts
backend/src/app.ts
backend/src/config.ts
backend/src/db/migrate.ts
backend/src/db/pool.ts
backend/src/jobs/__tests__/logRetention.test.ts
backend/src/jobs/.gitkeep
backend/src/jobs/logRetention.ts
backend/src/middleware/__tests__/authenticate.test.ts
backend/src/middleware/__tests__/ipAccessControl.test.ts
backend/src/middleware/__tests__/requireRole.test.ts
backend/src/middleware/.gitkeep
backend/src/middleware/authenticate.ts
backend/src/middleware/ipAccessControl.ts
backend/src/middleware/requireRole.ts
backend/src/models/.gitkeep
backend/src/models/Site.ts
backend/src/models/User.ts
backend/src/queues/screenshotQueue.ts
backend/src/routes/__tests__/auditLog.test.ts
backend/src/routes/__tests__/gdpr.test.ts
backend/src/routes/__tests__/geo.verifyLocation.test.ts
backend/src/routes/.gitkeep
backend/src/routes/accessLogs.ts
backend/src/routes/artifacts.ts
backend/src/routes/auth.ts
backend/src/routes/gdpr.ts
backend/src/routes/geo.ts
backend/src/routes/health.ts
backend/src/routes/protected.ts
backend/src/routes/sites.ts
backend/src/server.ts
backend/src/services/__tests__/AccessLogService.test.ts
backend/src/services/__tests__/AuditService.test.ts
backend/src/services/__tests__/AuthService.test.ts
backend/src/services/__tests__/GeofenceService.test.ts
backend/src/services/__tests__/GeoIPService.test.ts
backend/src/services/__tests__/SiteService.test.ts
backend/src/services/.gitkeep
backend/src/services/AccessLogService.ts
backend/src/services/AuditService.ts
backend/src/services/AuthService.ts
backend/src/services/GeofenceService.ts
backend/src/services/GeoIPService.ts
backend/src/services/SiteService.ts
backend/src/utils/__tests__/anonymizeIP.test.ts
backend/src/utils/__tests__/getClientIP.test.ts
backend/src/utils/.gitkeep
backend/src/utils/anonymizeIP.ts
backend/src/utils/getClientIP.ts
backend/src/utils/urlSafety.ts
backend/tsconfig.json
backend/vitest.config.ts
e2e/package.json
e2e/playwright.config.ts
e2e/tests/smoke.spec.ts
frontend/.gitignore
frontend/Dockerfile
frontend/Dockerfile.dev
frontend/index.html
frontend/nginx.conf
frontend/package-lock.json
frontend/package.json
frontend/postcss.config.js
frontend/src/App.tsx
frontend/src/components/GeofenceMap.tsx
frontend/src/components/Layout.tsx
frontend/src/components/LogDetailModal.tsx
frontend/src/components/RequireAuth.tsx
frontend/src/hooks/useAuth.ts
frontend/src/hooks/useGeolocation.ts
frontend/src/index.css
frontend/src/lib/api.ts
frontend/src/lib/auth.ts
frontend/src/main.tsx
frontend/src/pages/AccessLogs.tsx
frontend/src/pages/GdprAdmin.tsx
frontend/src/pages/LoginPage.tsx
frontend/src/pages/ProtectedPage.tsx
frontend/src/pages/SiteEditor.tsx
frontend/src/pages/SiteList.tsx
frontend/tailwind.config.js
frontend/tsconfig.json
frontend/tsconfig.node.json
frontend/vite.config.ts
infrastructure/.gitkeep
infrastructure/docker-compose.dev.yml
infrastructure/docker-compose.override.yml
infrastructure/docker-compose.yml
install.ps1
README.md
workers/.env.example
workers/Dockerfile
workers/Dockerfile.dev
workers/package-lock.json
workers/package.json
workers/src/.gitkeep
workers/src/db/pool.ts
workers/src/index.ts
workers/src/s3Client.ts
workers/src/screenshotWorker.ts
workers/src/types.ts
workers/tsconfig.json
```

---

## Appendix B — Verbatim contents (Remote snapshots)

All of the requested remote files are additionally saved verbatim in the local snapshot folder:
`.planning/research/v2test_master_snapshot/`

### B1) Remote `.planning/STATE.md`

```markdown
# JP Dynamic Agent System — State

**Last updated:** 2026-02-18  
**Current phase:** Phase 3 — Ongoing  
**P0 status:** PASS

## Agent Roster

| Agent | File | Status |
|---|---|---|
| Orchestrator | `.github/agents/orchestrator.agent.md` | ✅ Active |
| Researcher | `.github/agents/researcher.agent.md` | ✅ Active |
| Planner | `.github/agents/planner.agent.md` | ✅ Active |
| Coder | `.github/agents/coder.agent.md` | ✅ Active |
| Designer | `.github/agents/designer.agent.md` | ✅ Active |
| Verifier | `.github/agents/verifier.agent.md` | ✅ Active |
| Debugger | `.github/agents/debugger.agent.md` | ✅ Active |

## Extension Registry

| ID | Kind | Status |
|---|---|---|
| `ext-skill-extension-coordinator` | skill | ✅ Active |
| `ext-skill-extension-verifier` | skill | ✅ Active |

## Phase Completion Log

| Phase | Name | Status | Date |
|---|---|---|---|
| Phase 0 | Baseline | ✅ Complete | 2026-02-18 |
| Phase 1 | Extension Governance | ✅ Complete | 2026-02-18 |
| Phase 2 | Bootstrap Extensions | ✅ Complete | 2026-02-18 |
| Phase 3 | Ongoing | 🟢 Active | 2026-02-18 |

## Active Projects

| Project | Location | Status |
|---|---|---|
| Geo-Fenced Multi-Site Webserver | `.planning/geo/` | Phase 2 Complete, Phase 3 pending |
```

### B2) Remote `.planning/ROADMAP.md`

```markdown
# JP Dynamic Agent System — Roadmap

Scope: The JP Dynamic Agent System governance and extension lifecycle.

## Phase 0 — Baseline (COMPLETE ✅)

**Goal:** Establish the core agent team and P0 invariant baseline.

**Success criteria:**
- All 7 agent files exist at `.github/agents/*.agent.md`
- P0 invariants defined at `.planning/baseline/P0_INVARIANTS.yaml`
- Change gates defined at `.planning/baseline/CHANGE_GATES.md`

## Phase 1 — Extension Governance (COMPLETE ✅)

**Goal:** Establish controlled extension lifecycle (skills and agents).

**Success criteria:**
- `REGISTRY.yaml` operational as canonical extension registry
- `WIRING_CONTRACT.md` defines Layer 1 + Layer 2 wiring options
- `DECISION_RULES.md` defines Gates A–D for extension type selection
- `EDR_TEMPLATE.md` provides standard EDR format

## Phase 2 — Bootstrap Extensions (COMPLETE ✅)

**Goal:** Register and verify the two bootstrap skills that support future extension governance.

**Success criteria:**
- `ext-skill-extension-coordinator` — approved EDR, registry active, wiring evidenced
- `ext-skill-extension-verifier` — approved EDR, registry active, wiring evidenced
- `.planning/extensions/VERIFICATION.md` documents governance checklist results
- `P0_SMOKE_CHECKS.md` created at `.planning/baseline/`

## Phase 3 — Ongoing (ACTIVE)

**Goal:** Support project teams using the agent system on their own projects.

**Success criteria:**
- Agent team and governance artifacts remain P0-compliant
- New extensions follow the EDR governance loop
- Projects using the system maintain their own `.planning/<project>/` directories
```

### B3) Remote `.planning/extensions/REGISTRY.yaml`

```yaml
# Extensions Registry
# Schema version: 1
# Canonical source of truth for all approved skills and agents in this repo.
#
# Governance rules:
#   1. An entry MUST NOT have status: active without an approved EDR at the path listed in `edr`.
#   2. All fields marked "(required)" must be populated before an entry is committed.
#   3. `wiring_targets` must list at least one agent name for any active skill.
#   4. Registry changes are additive-only (new entries, status updates, deprecation fields).
#      Deletions require a superseding EDR.
#
# Bootstrap state: The registry is intentionally empty until the first EDR is approved.
# Add the first real entry when EDR-YYYYMMDD-0001-<slug>.md is approved.
#
# Example entry (commented out — copy and uncomment when registering a real extension):
#
# extensions:
#   - id: "ext-skill-example-name"             # (required) stable id: ext-<kind>-<name>
#     kind: "skill"                             # (required) skill | agent
#     name: "example-name"                     # (required) must match .github/skills/<name>/ dir (skills) or .agent.md stem (agents)
#     purpose: >                               # (required) 1–2 sentences, keyword-rich
#       One to two sentences describing what this extension does and when it is invoked.
#     owner: "team-or-person"                  # (required)
#     status: "proposed"                       # (required) active | deprecated | proposed | rejected
#     scope: "planning docs only"              # (required) what the extension is allowed to influence
#     wiring_targets:                          # (required for skills; at least one agent name)
#       - "Planner"
#       - "Coder"
#     edr: ".planning/extensions/edr/EDR-YYYYMMDD-NNNN-<slug>.md"  # (required for active; must exist)
#     source_path: ".github/skills/example-name/"  # (required) .github/skills/<name>/ for skills; .github/agents/<file>.agent.md for agents
#     created: "YYYY-MM-DD"                    # (required) ISO date
#     updated: "YYYY-MM-DD"                    # (required) ISO date; update on any field change
#     tags:                                    # (optional)
#       - "keyword"
#     depends_on: []                           # (optional) list of other ext ids this depends on
#     # deprecation:                           # (optional; populate when status changes to deprecated)
#     #   reason: ""
#     #   replaced_by: ""
#     #   sunset_date: ""

version: 1
last_updated: "2026-02-18"

extensions:
  - id: "ext-skill-extension-verifier"
    kind: "skill"
    name: "extension-verifier"
    purpose: >
      Verifies that a new or updated extension in the JP Dynamic Agent System correctly completed
      the full governance loop (EDR approved → registry active → wiring evidenced → P0 smoke checks
      pass → tooling evidence captured) and produces auditable VERIFICATION.md evidence for the phase.
    owner: "JP Dynamic Agent System"
    status: "active"
    scope: "Extension-loop verification — governance alignment, registry correctness, operational wiring evidence, P0 regression checks, and tooling host evidence capture"
    wiring_targets:
      - "Verifier"
      - "Orchestrator"
    edr: ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"
    source_path: ".github/skills/extension-verifier/"
    created: "2026-02-18"
    updated: "2026-02-18"
    tags:
      - "governance"
      - "verification"
      - "wiring"
      - "p0"
    depends_on: []

  - id: "ext-skill-extension-coordinator"
    kind: "skill"
    name: "extension-coordinator"
    purpose: >
      Governs the controlled creation of new skills and agents in the JP Dynamic Agent System.
      Provides a step-by-step EDR → Gate A–D decision → create → register → wire → verify playbook
      that any agent can invoke when a repeatable workflow gap requires a new extension.
    owner: "JP Dynamic Agent System"
    status: "active"
    scope: "Extension creation governance — the controlled flow for proposing, approving, creating, registering, wiring, and verifying new skills and agents"
    wiring_targets:
      - "Orchestrator"
      - "Researcher"
      - "Planner"
      - "Coder"
    edr: ".planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md"
    source_path: ".github/skills/extension-coordinator/"
    created: "2026-02-18"
    updated: "2026-02-18"
    tags:
      - "governance"
      - "extension-lifecycle"
      - "edr"
      - "skill-first"
    depends_on: []
```

### B4) Remote EDR-0001 `.planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md`

```markdown
---
edr_id: "EDR-20260218-0001-extension-coordinator"
date: "2026-02-18"
status: "approved"         # proposed | approved | rejected | superseded
kind: "skill"              # skill | agent
proposed_name: "extension-coordinator"    # for skills: lowercase-hyphenated, must match .github/skills/<name>/ dir
owner: "JP Dynamic Agent System bootstrap"
requirements:
  - "REQ-005"   # justification before creation — always include
  - "REQ-013"   # registry entry required — always include
wiring_targets:
  - "Orchestrator"
  - "Researcher"
  - "Planner"
  - "Coder"
risk_level: "low"
additive_only: true
---

# Extension Decision Record: `extension-coordinator`

## 1. Problem / Gap

When a repeatable workflow gap is identified, agents need a governed process for creating new skills/agents. Without a coordinator skill, agents may create extensions ad hoc without EDR approval, which can introduce unreviewed changes to the agent system and break additive-only governance.

## 2. Why Existing Agents and Skills Cannot Solve This

| Existing thing considered | Why it is insufficient |
|---|---|
| Orchestrator agent | Coordinates work, but is not an authoritative, on-demand runbook for the full extension lifecycle and can drift over time without a canonical reference. |
| Planner agent | Produces plans, but does not by itself enforce the controlled extension lifecycle unless guided by an authoritative checklist/runbook. |
| Verifier agent | Verifies outcomes, but does not provide the end-to-end controlled creation playbook that prevents governance shortcuts. |
| Ad-hoc notes in phase plans | Plan text is phase-scoped and can become fragmented; it does not provide a canonical, reusable lifecycle playbook available to any agent at the moment the gap is detected. |

## 3. Proposal

- **Kind:** `skill`
- **Name:** `extension-coordinator`
- **Location:** `.github/skills/extension-coordinator/SKILL.md`
- **One-sentence purpose:** Provide the authoritative playbook for proposing, approving, creating, registering, wiring, and verifying new skills/agents so extensions are never created ad hoc.

## 4. Scope

**In scope:**
- Extension creation governance only: EDR drafting, Gate A–D application, approval checkpoint handling, registry entry requirements, wiring option selection (A vs B), and verification handoff.

**Out of scope:**
- Implementing product features or modifying application code.
- Making any non-additive changes to existing agent contracts.
- Performing infrastructure changes unrelated to extension governance.

## 5. Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Process bypass (agents create extensions without approval) | medium | Centralize the lifecycle as a user-invokable skill and require Gate A–D results recorded in the EDR. |
| Prompt bloat if embedded in multiple agents | high | Keep the lifecycle in a skill so it is loaded on-demand. |
| Confusion between declarative wiring vs operational wiring | medium | Explicitly reference `WIRING_CONTRACT.md` and require Layer 2 evidence (Option A or B). |

**P0 regression risk:** This skill does not require editing `.github/agents/**` when using Wiring Option A. Any move to Option B would require Gate 2 checkpoint and P0 anchor re-validation.

## 6. Verification Plan

- [ ] Confirm `REGISTRY.yaml` entry exists with `status: active` and correct `wiring_targets`.
- [ ] Confirm registry `edr` path points to this EDR and the file exists.
- [ ] Confirm `.github/skills/extension-coordinator/SKILL.md` exists and `name` matches directory.
- [ ] Confirm operational wiring evidence exists per Section 7 (Option A references in relevant phase plans).
- [ ] Confirm all P0 invariants still pass (`.planning/baseline/P0_SMOKE_CHECKS.md`).

## 7. Wiring Contract

### 7a. Declarative wiring (registry)

- [x] `REGISTRY.yaml` entry lists `wiring_targets` for the agents expected to use this skill.
- [x] Registry `status` is `active` only because this EDR is `approved`.

### 7b. Operational wiring — chosen option

**Option A — Plan-driven references (no agent-file edits).**

- Plans that introduce or modify extensions will include: `@.github/skills/extension-coordinator/SKILL.md` in their Context section.
- Plan text will explicitly instruct the executing agent to invoke `/extension-coordinator` when an extension is being proposed.

_Rationale for choosing Option A:_ preserves additive-only constraints without triggering Gate 2 (agent-file edits) and avoids changing `.github/agents/**` while still providing auditable wiring evidence in phase plans.

## 8. Gate A–D Decision Record

**Gate A — Can this be solved without adding anything?**
- [x] No — the multi-step governance workflow requires a canonical reference that all agents can reliably invoke; embedding and maintaining this lifecycle across prompts/plans would be impractical and inconsistent.

**Gate B — Is a Skill sufficient?**
- [x] Yes — this is procedural knowledge / repeatable workflow with no new tool boundary needed.

**Gate C — Agent justification (complete only if proposing an agent)**

N/A — skill chosen in Gate B.

**Gate D — Skill-first enforcement verdict**
- [x] PASS — skill is the correct extension type, scope is bounded to extension governance, additive-only.

---

## Approval

| Role | Name | Date | Decision |
|---|---|---|---|
| Proposer | JP Dynamic Agent System bootstrap | 2026-02-18 | Proposed |
| Reviewer | JP Dynamic Agent System bootstrap | 2026-02-18 | Approved |
```

### B5) Remote EDR-0002 `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md`

```markdown
---
edr_id: "EDR-20260218-0002-extension-verifier"
date: "2026-02-18"
status: "approved"         # proposed | approved | rejected | superseded
kind: "skill"              # skill | agent
proposed_name: "extension-verifier"    # for skills: lowercase-hyphenated, must match .github/skills/<name>/ dir
owner: "JP Dynamic Agent System bootstrap"
requirements:
  - "REQ-005"   # justification before creation — always include
  - "REQ-013"   # registry entry required — always include
wiring_targets:
  - "Verifier"
  - "Orchestrator"
risk_level: "low"
additive_only: true
---

# Extension Decision Record: `extension-verifier`

## 1. Problem / Gap

When a new skill or agent is created, there is no standardized checklist to verify the full governance loop was followed (EDR → registry → wiring → P0 checks → tooling evidence). Without this, extensions can be “registered but not actually wired” or “wired but not verified,” which undermines auditability and increases the risk of governance drift.

## 2. Why Existing Agents and Skills Cannot Solve This

| Existing thing considered | Why it is insufficient |
|---|---|
| Verifier agent (base behavior) | The verification procedure is multi-step and easy to perform inconsistently without an authoritative runbook; relying on memory increases error risk. |
| Orchestrator agent | Coordinates but does not guarantee systematic evidence capture across all gates; lacks a standardized extension-loop verification checklist. |
| EDR template alone | Provides structure for decisions, but not the operational checklist/commands for proving wiring + P0 invariants + tooling evidence. |
| CHANGE_GATES.md + P0_INVARIANTS.yaml | Define rules/anchors, but do not provide a consolidated, repeatable verification runbook that produces auditable VERIFICATION.md evidence. |

## 3. Proposal

- **Kind:** `skill`
- **Name:** `extension-verifier`
- **Location:** `.github/skills/extension-verifier/SKILL.md`
- **One-sentence purpose:** Provide the authoritative verification runbook for extension governance (EDR/registry/wiring/P0/tooling evidence) and the required VERIFICATION.md evidence shape.

## 4. Scope

**In scope:**
- Extension-loop verification only: governance alignment, registry correctness, operational wiring evidence checks, P0 regression spot-checks, and tooling evidence capture guidance.

**Out of scope:**
- Modifying application code, infrastructure, or agent files as part of verification.
- Implementing new extensions or making governance decisions (that is handled by the coordinator flow).

## 5. Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| False sense of completion (“exists” mistaken for “wired”) | medium | Skill enforces Layer 1 + Layer 2 wiring contract checks and requires evidence. |
| Prompt bloat if checklist embedded everywhere | high | Keep verification runbook in a skill so it is loaded on demand. |
| Incomplete tooling evidence capture | medium | Skill includes explicit VS Code diagnostics/debug-view checks as evidence. |

**P0 regression risk:** This skill does not require editing `.github/agents/**` under Wiring Option A. If an extension chooses Option B, P0 anchors must be verified via baseline smoke checks.

## 6. Verification Plan

- [ ] Confirm `REGISTRY.yaml` entry exists with `status: active` and correct `wiring_targets`.
- [ ] Confirm registry `edr` points to this EDR and the file exists.
- [ ] Confirm `.github/skills/extension-verifier/SKILL.md` exists and `name` matches directory.
- [ ] Confirm operational wiring evidence exists per Section 7 (Option A references in relevant phase plans, or Option B agent-file additive index with checkpoint evidence).
- [ ] Confirm all P0 invariants still pass (`.planning/baseline/P0_SMOKE_CHECKS.md`).

## 7. Wiring Contract

### 7a. Declarative wiring (registry)

- [x] `REGISTRY.yaml` entry lists `wiring_targets` for agents expected to use this skill.
- [x] Registry `status` is `active` only because this EDR is `approved`.

### 7b. Operational wiring — chosen option

**Option A — Plan-driven references (no agent-file edits).**

- Phase plans that need extension-loop verification will include: `@.github/skills/extension-verifier/SKILL.md` in their Context section.
- Plan text will explicitly instruct the executing agent to invoke `/extension-verifier` when producing verification evidence.

_Rationale for choosing Option A:_ keeps verification evidence phase-scoped and avoids `.github/agents/**` modifications (no Gate 2), while still satisfying the wiring contract via explicit plan references.

## 8. Gate A–D Decision Record

**Gate A — Can this be solved without adding anything?**
- [x] No — the 5-gate verification procedure requires structured, authoritative documentation that cannot be reliably executed from memory alone; embedding this procedure inline in agent instructions would create unworkable prompt sizes and encourage drift.

**Gate B — Is a Skill sufficient?**
- [x] Yes — this is a procedural checklist/workflow with no new tool boundary required.

**Gate C — Agent justification (complete only if proposing an agent)**

N/A — skill chosen in Gate B.

**Gate D — Skill-first enforcement verdict**
- [x] PASS — skill is the correct extension type, scope is bounded, additive-only.

---

## Approval

| Role | Name | Date | Decision |
|---|---|---|---|
| Proposer | JP Dynamic Agent System bootstrap | 2026-02-18 | Proposed |
| Reviewer | JP Dynamic Agent System bootstrap | 2026-02-18 | Approved |
```

### B6) Remote `.github/agents/orchestrator.agent.md`

```markdown
---
name: Orchestrator
description: JP Coordinates the full development lifecycle by delegating to subagents. Never implements directly.
model: Claude Sonnet 4.6 (copilot)
tools: ['read/readFile', 'agent', 'memory']
---

You are a project orchestrator. You break down complex requests into lifecycle phases and delegate to subagents. You coordinate work but NEVER implement anything yourself.

## CRITICAL: Agent Invocation

You MUST delegate to subagents using the `runSubagent` tool. These agents have file editing tools — you do not.

| Agent | Name | Has Edit Tools | Role |
|---|---|---|---|
| Researcher | `Researcher` | Yes | Research, codebase mapping, technology surveys |
| Planner | `Planner` | Yes | Roadmaps, plans, validation, gap analysis |
| Coder | `Coder` | Yes | Code implementation, commits |
| Designer | `Designer` | Yes | UI/UX design, styling, visual implementation |
| Verifier | `Verifier` | Yes | Goal-backward verification, integration checks |
| Debugger | `Debugger` | Yes | Scientific debugging with hypothesis testing |

**You MUST use runSubagent to invoke workspace agents.** The workspace agents are configured with `edit`, `execute`, `search`, `context7`, and other tools. Use the exact agent name (capitalized) from the table above when calling runSubagent.

### Path References in Delegation

**CRITICAL:** When delegating, always reference paths as relative (e.g., `.planning/research/SUMMARY.md`, not an absolute path). Subagents work in the workspace directory and absolute paths will fail across different agent contexts.

## Lifecycle

**Research → Plan → Execute → Verify → Debug → Iterate**

Not every request needs every stage. Assess first, then route.

## Request Routing

Determine what the user needs and pick the shortest path:

| Request Type | Route |
|---|---|
| New project / greenfield | **Full Flow** (Steps 1–10 below) |
| New feature on existing codebase | Steps 3–10 (skip project research) |
| Unknown domain / technology choice | Steps 1–2 first, then assess |
| Bug report | **Debugger Mode Selection** (see below) |
| Quick code change (single file, obvious) | runSubagent(Coder) directly |
| UI/UX only | runSubagent(Designer) directly |
| Verify existing work | runSubagent(Verifier) directly |

### Debugger Mode Selection

When delegating to Debugger, you MUST select the appropriate mode based on user intent:

**Mode Selection Rules:**
- **If user asks "why/what is happening?"** → Use `find_root_cause_only` mode
  - Examples: "Why is this failing?", "What's causing the error?", "Diagnose this issue"
- **If user asks "fix this" or consent to fix is clear** → Use `find_and_fix` mode
  - Examples: "Fix the bug", "Resolve this error", "Make it work"
- **If ambiguous** → Ask one clarifying question:
  - "Would you like me to diagnose the root cause only, or find and fix the issue?"
  - If the user doesn't respond or safety is preferred, default to `find_root_cause_only`

**Delegation Examples:**

For diagnosis only:
```
**Call runSubagent:** `Debugger`
- **description:** "Diagnose authentication failure"
- **prompt:** "Mode: find_root_cause_only. Investigate why users are getting authentication failures on login. Find the root cause but do not implement a fix."
```

For diagnosis and fix:
```
**Call runSubagent:** `Debugger`
- **description:** "Fix infinite loop in SideMenu"
- **prompt:** "Mode: find_and_fix. Debug and fix the infinite loop error in the SideMenu component. Find the root cause and implement the fix."
```

---

## Full Flow: The 10-Step Execution Model

```
User: "Build a recipe sharing app"
  │
  ▼
Orchestrator
  ├─1─► runSubagent(Researcher, project mode)
  ├─2─► runSubagent(Researcher, synthesize)
  ├─3─► runSubagent(Planner, roadmap mode)
  │
  │  For each phase:
  ├─4─► runSubagent(Researcher, phase mode)
  ├─5─► runSubagent(Planner, plan mode)
  ├─6─► runSubagent(Planner, validate mode)     → pass/fail
  ├─7─► runSubagent(Coder) + runSubagent(Designer) → code + .planning/phases/N/SUMMARY.md
  ├─8─► runSubagent(Verifier, phase mode)
  │     └── gaps? → runSubagent(Planner, gaps) → runSubagent(Coder) → runSubagent(Verifier)
  │
  │  After all phases:
  ├─9─► runSubagent(Verifier, integration)
  └─10─► Report to user
```

---

### Step 1: Project Research

Delegate domain research to Researcher in project mode.

**Call the runSubagent tool:** `Researcher`
- **description:** "Research domain and technology stack"
- **Mode:** Project
- **Objective:** Research the domain, technology options, architecture patterns, and pitfalls for: **[user's request]**
- **Inputs:** User request
- **Constraints:** Use source hierarchy (Context7, official docs, web search)
- **prompt:** "Project mode. Research the domain, technology options, architecture patterns, and pitfalls for: **[user's request]**. Use your standard outputs for this mode."

### Step 2: Synthesize Research

Consolidate research outputs into a single summary.

**Call the runSubagent tool:** `Researcher`
- **description:** "Synthesize research findings"
- **Mode:** Synthesize
- **Objective:** Consolidate research findings into a summary
- **Inputs:** `.planning/research/` directory contents
- **Constraints:** Include executive summary, recommended stack, and roadmap implications
- **prompt:** "Synthesize mode. Read all files in `.planning/research/` and create a consolidated summary with executive summary, recommended stack, and roadmap implications. Use your standard outputs for this mode."

### Step 3: Create Roadmap

**Call the runSubagent tool:** `Planner`
- **description:** "Create project roadmap"
- **Mode:** Roadmap
- **Objective:** Create a phased roadmap for: **[user's request]**
- **Inputs:** `.planning/research/SUMMARY.md`
- **Constraints:** Include phase breakdown, requirement mapping, and success criteria
- **prompt:** "Roadmap mode. Using the research in `.planning/research/SUMMARY.md`, create a phased roadmap for: **[user's request]**. Use your standard outputs for this mode."

**Show the user:** Display the roadmap phases and ask for confirmation before proceeding to phase execution.

---

### Phase Loop (Steps 4–8)

Read `ROADMAP.md` and execute each phase in order. For each phase N:

#### Step 4: Phase Research

**Call the runSubagent tool:** `Researcher`
- **description:** "Research Phase [N] implementation"
- **Mode:** Phase
- **Objective:** Research implementation details for Phase [N]: '[phase name]'
- **Inputs:** `.planning/ROADMAP.md` (phase goals), `.planning/research/SUMMARY.md` (stack decisions)
- **Constraints:** Focus on implementation-specific research for this phase
- **prompt:** "Phase mode. Research implementation details for Phase [N]: '[phase name]'. Read `.planning/ROADMAP.md` for phase goals and `.planning/research/SUMMARY.md` for stack decisions. Use your standard outputs for this mode."

#### Step 5: Create Phase Plan

**Call the runSubagent tool:** `Planner`
- **description:** "Create Phase [N] plan"
- **Mode:** Plan
- **Objective:** Create task-level plans for Phase [N]
- **Inputs:** `.planning/phases/[N]/RESEARCH.md` (implementation guidance), `.planning/ROADMAP.md` (success criteria)
- **Constraints:** Plans are prompts—ensure each is executable by a single agent in one session
- **prompt:** "Plan mode. Create task-level plans for Phase [N]. Read `.planning/phases/[N]/RESEARCH.md` for implementation guidance and `.planning/ROADMAP.md` for success criteria. Use your standard outputs for this mode."

#### Step 6: Validate Plan

**Call the runSubagent tool:** `Planner`
- **description:** "Validate Phase [N] plan"
- **prompt:** "Validate mode. Verify the plans in `.planning/phases/[N]/PLAN.md` against Phase [N] success criteria in `.planning/ROADMAP.md`. Check all 6 dimensions: requirement coverage, task completeness, dependency correctness, key links, scope sanity, must-haves traceability."

**If PASS →** Continue to Step 7.
**If ISSUES FOUND →**

**Call the runSubagent tool:** `Planner`
- **description:** "Revise Phase [N] plan"
- **prompt:** "Revise mode. Fix the issues found in validation of Phase [N] plans. Issues: [paste issues]."

Re-run validation. **Maximum 2 revision cycles** — if still failing after 2 revisions, stop and flag to user with the remaining issues.

#### Step 7: Execute Phase

Parse the PLAN.md for task assignments. Determine parallelization using file overlap rules (see Parallelization section below).

**For code tasks, call the runSubagent tool:** `Coder`
- **description:** "Execute Phase [N] implementation"
- **prompt:** "Execute `.planning/phases/[N]/PLAN.md`. Read `STATE.md` for current position. Commit after each task. Write `.planning/phases/[N]/SUMMARY.md` when complete."

**For design tasks, call the runSubagent tool:** `Designer`
- **description:** "Design Phase [N] UI/UX"
- **prompt:** "Implement the UI/UX for Phase [N]. Read `.planning/phases/[N]/PLAN.md` for requirements and `.planning/phases/[N]/RESEARCH.md` for design constraints."

**Parallel execution:** If tasks touch different files and have no dependencies, call runSubagent for Coder and Designer simultaneously with explicit file scoping (see File Conflict Prevention below).

**Wait for:** All tasks complete + `.planning/phases/[N]/SUMMARY.md`

#### Step 8: Verify Phase

**Call the runSubagent tool:** `Verifier`
- **description:** "Verify Phase [N] implementation"
- **Mode:** Phase
- **Objective:** Verify Phase [N] against success criteria
- **Inputs:** Phase directory contents, `ROADMAP.md` (success criteria), `REQUIREMENTS.md`, `STATE.md`
- **Constraints:** Test independently—task completion ≠ goal achievement
- **prompt:** "Phase mode. Verify Phase [N] against success criteria in ROADMAP.md. Test it — verify independently. Use your standard outputs for this mode."

**If PASSED →** Report phase completion to user. Advance to next phase (back to Step 4).
**If GAPS_FOUND →** Enter gap-closure loop:

##### Gap-Closure Loop (max 3 iterations)

```
1. runSubagent(Planner) gaps mode  → read VERIFICATION.md, create fix plans
2. runSubagent(Coder)              → execute fix plans
3. runSubagent(Verifier) re-verify → check gaps are closed
4. Still gaps?                     → repeat (max 3 times)
5. Still failing?                  → report to user with remaining gaps
```

**Call the runSubagent tool:** `Planner`
- **description:** "Create gap-closure plan for Phase [N]"
- **Mode:** Gaps
- **Objective:** Create fix plans for verification gaps
- **Inputs:** `.planning/phases/[N]/VERIFICATION.md` (gaps found)
- **Constraints:** Focus on closing specific gaps identified in verification
- **prompt:** "Gaps mode. Read `.planning/phases/[N]/VERIFICATION.md` and create fix plans for the gaps found. Use your standard outputs for this mode."

**Call the runSubagent tool:** `Coder`
- **description:** "Execute gap-closure for Phase [N]"
- **prompt:** "Execute the gap-closure plan for Phase [N]. Fix the issues identified in verification."

**Call the runSubagent tool:** `Verifier`
- **description:** "Re-verify Phase [N]"
- **prompt:** "Re-verify Phase [N]. Focus on previously-failed items from `VERIFICATION.md`."

**If HUMAN_NEEDED →** Report to user what needs manual verification before continuing.

---

### Post-Phase Steps

#### Step 9: Integration Verification

After ALL phases are complete:

**Call the runSubagent tool:** `Verifier`
- **description:** "Verify cross-phase integration"
- **Mode:** Integration
- **Objective:** Verify cross-phase wiring and end-to-end flows
- **Inputs:** All phase summaries, phase directory contents
- **Constraints:** Check exports are consumed, APIs are called, auth is applied, and user flows work end-to-end
- **prompt:** "Integration mode. Verify cross-phase wiring and end-to-end flows. Read all phase summaries and check that exports are consumed, APIs are called, auth is applied, and user flows work end-to-end. Use your standard outputs for this mode."

**If issues found →** Route back through gap-closure: runSubagent(Planner, gaps mode) → runSubagent(Coder) → runSubagent(Verifier) for the specific cross-phase issues.

#### Step 10: Report to User

Compile final report:

1. **What was built** — from phase summaries
2. **Architecture decisions** — from research
3. **Verification status** — from VERIFICATION.md files
4. **Any remaining human verification items** — flagged by Verifier
5. **How to run/test the project** — setup and run commands

---

## Parallelization Rules

**RUN IN PARALLEL when:**
- Tasks touch completely different files
- Tasks are in different domains (e.g., styling vs. logic)
- Tasks have no data dependencies

**RUN SEQUENTIALLY when:**
- Task B needs output from Task A
- Tasks might modify the same file
- Design must be approved before implementation

## File Conflict Prevention

When delegating parallel tasks, you MUST explicitly scope each agent to specific files.

### Strategy 1: Explicit File Assignment

```
runSubagent(Coder, "Implement the theme context. Create src/contexts/ThemeContext.tsx and src/hooks/useTheme.ts. Do NOT touch any other files.")

runSubagent(Coder, "Create the toggle component in src/components/ThemeToggle.tsx. Do NOT touch any other files.")
```

### Strategy 2: When Files Must Overlap

If multiple tasks legitimately need to touch the same file, run them **sequentially** in separate sub-phases:

```
Phase 2a: runSubagent(Coder, "Add theme context (modifies App.tsx to add provider)")
Phase 2b: runSubagent(Coder, "Add error boundary (modifies App.tsx to add wrapper)")
```

### Strategy 3: Component Boundaries

For UI work, assign agents to distinct component subtrees:

```
runSubagent(Designer, "Design the header section → Header.tsx, NavMenu.tsx")
runSubagent(Designer, "Design the sidebar → Sidebar.tsx, SidebarItem.tsx")
```

### Red Flags (Split Into Phases Instead)

If you find yourself assigning overlapping scope, make it sequential:
- ❌ runSubagent(Coder, "Update the main layout") + runSubagent(Coder, "Add the navigation") (both might touch Layout.tsx)
- ✅ Phase 1: runSubagent(Coder, "Update the main layout") → Phase 2: runSubagent(Coder, "Add navigation to the updated layout")

## CRITICAL: Never Tell Agents HOW

When delegating, describe WHAT needs to be done (the outcome), not HOW to do it.

### ✅ CORRECT delegation
- runSubagent(Coder, "Fix the infinite loop error in SideMenu")
- runSubagent(Coder, "Add a settings panel for the chat interface")
- runSubagent(Designer, "Create the color scheme and toggle UI for dark mode")

### ❌ WRONG delegation
- runSubagent(Coder, "Fix the bug by wrapping the selector with useShallow")
- runSubagent(Coder, "Add a button that calls handleClick and updates state")

## `.planning/` Artifacts

```
.planning/
├── REQUIREMENTS.md         # Requirements with REQ-IDs (Planner creates)
├── ROADMAP.md              # Phase breakdown (Planner creates)
├── STATE.md                # Project state tracking (Planner initializes, Coder updates)
├── INTEGRATION.md          # Cross-phase verification (Verifier creates, Step 9)
├── research/               # Research outputs (Researcher creates, Steps 1–2)
│   ├── SUMMARY.md          # Consolidated research (Researcher synthesize mode)
│   ├── STACK.md            # Technology choices
│   ├── FEATURES.md         # Feature analysis
│   ├── ARCHITECTURE.md     # Architecture patterns
│   └── PITFALLS.md         # Known pitfalls
├── codebase/               # Codebase analysis (Researcher codebase mode)
├── phases/
│   ├── 1/
│   │   ├── RESEARCH.md     # Phase research (Researcher, Step 4)
│   │   ├── PLAN.md         # Task plans (Planner, Step 5)
│   │   ├── SUMMARY.md      # Execution summary (Coder, Step 7)
│   │   └── VERIFICATION.md # Phase verification (Verifier, Step 8)
│   ├── 2/
│   │   └── ...
│   └── N/
└── debug/                  # Debug session files (Debugger creates)
```

When starting a new project, follow the Full Flow starting at Step 1.
When resuming, read `STATE.md` to determine current position and pick up from the correct step.

## Resuming a Project

1. Read `.planning/STATE.md`
2. Check the current phase and status
3. Determine which step to resume from:
   - If research exists but no roadmap → resume at Step 3
   - If roadmap exists but phase not started → resume at Step 4
   - If phase plans exist but not validated → resume at Step 6
   - If phase execution incomplete → resume at Step 7
   - If phase complete but not verified → resume at Step 8

---

## Extension Detection (additive — do not modify existing behavior)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Extension governance escalation (EDR → decision → create → wire → verify)

If any subagent reports that a *new skill or agent* is needed, you MUST route through the controlled extension flow. This section does NOT change normal routing; it activates only when an extension need is explicitly reported.

#### Non-negotiable enforcement
- Do NOT create a new skill or agent directly.
- Do NOT ask a subagent to create a new skill or agent unless there is an EDR on disk under `.planning/extensions/edr/`.
- If an EDR does not exist yet, the next action is to draft one (status: proposed) — not to create the extension.

#### Coordinator action
1. Ask the Planner to draft an EDR using `.planning/extensions/EDR_TEMPLATE.md`.
2. Ask the Planner to apply `.planning/extensions/DECISION_RULES.md` (Gates A–D) inside the EDR (Section 8).
3. If and only if the EDR is approved (user checkpoint):
   - Ask the Coder to create the skill or agent at the EDR's declared location.
   - Ask the Coder (or Planner, if docs-only) to add/update `.planning/extensions/REGISTRY.yaml`.
   - Ask the Planner to ensure the chosen wiring mechanism matches `.planning/extensions/WIRING_CONTRACT.md`.
4. Ask the Verifier to confirm REQ-006/REQ-007 enforcement:
   - an approved EDR exists and is referenced by registry
   - wiring evidence exists (Option A plan refs or Option B additive agent-file index)
   - no P0 regressions

#### Extension coordinator skill
When coordinating, prefer using the project skill:
- `@.github/skills/extension-coordinator/SKILL.md`

If the skill does not exist yet, treat that as an extension need and start by drafting an EDR proposing it.

---

## Example: Recipe Sharing App

### Steps 1–2: Research

**Call runSubagent:** `Researcher`
- **description:** "Research recipe sharing app domain"
- **prompt:** "Project mode. Research the domain of recipe sharing applications — tech stack options, architecture patterns, features, and common pitfalls. Use your standard outputs for this mode."

**Call runSubagent:** `Researcher`
- **description:** "Synthesize research"
- **prompt:** "Synthesize mode. Consolidate all research into a summary with executive summary, recommended stack, and roadmap implications. Use your standard outputs for this mode."

### Step 3: Roadmap

**Call runSubagent:** `Planner`
- **description:** "Create recipe app roadmap"
- **prompt:** "Roadmap mode. Create a phased roadmap for a recipe sharing app using the research in `.planning/research/SUMMARY.md`. Use your standard outputs for this mode."

**Show user the roadmap. Wait for approval.**

### Steps 4–8: Phase 1 Loop

**Call runSubagent:** `Researcher`
- **description:** "Research Phase 1 implementation"
- **prompt:** "Phase mode. Research implementation details for Phase 1. Use your standard outputs for this mode."

**Call runSubagent:** `Planner`
- **description:** "Create Phase 1 plan"
- **prompt:** "Plan mode. Create task plans for Phase 1. Use your standard outputs for this mode."

**Call runSubagent:** `Planner`
- **description:** "Validate Phase 1 plan"
- **prompt:** "Validate mode. Verify Phase 1 plans against success criteria."

**Call runSubagent:** `Coder`
- **description:** "Execute Phase 1"
- **prompt:** "Execute `.planning/phases/1/PLAN.md`. Commit per task. Write summary when done."

**Call runSubagent:** `Verifier`
- **description:** "Verify Phase 1"
- **prompt:** "Phase mode. Verify Phase 1 implementation. Use your standard outputs for this mode."

*If gaps → gap-closure loop → then continue...*

### Steps 4–8: Phase 2 Loop

*(Repeat the same 5-step pattern for each remaining phase...)*

### Step 9: Integration

**Call runSubagent:** `Verifier`
- **description:** "Verify integration"
- **prompt:** "Integration mode. Verify cross-phase wiring and end-to-end flows. Use your standard outputs for this mode."

### Step 10: Report

"All phases complete. Here's what was built, verification status, and how to run it..."
```

### B7) Remote `.github/skills/extension-coordinator/SKILL.md`

```markdown
---
name: extension-coordinator
description: >
  Governs the controlled creation of new skills and agents in the JP Dynamic Agent System.
  Invoke when an agent detects a repeatable workflow gap that may need a new skill or agent.
  Runs the full EDR → Gate A–D decision → (if approved) create → register → wire → verify flow.
  Prevents ad-hoc extension creation without justification and an audit trail.
argument-hint: "<gap summary> | proposed kind (skill|agent) | candidate wiring targets | risk level"
user-invokable: true
disable-model-invocation: true
---

# Extension Coordinator

---

## When to Use This Skill

Invoke this skill when **all three conditions are true**:

1. An agent has detected a repeatable workflow gap during normal operation (research, planning, execution, verification, or debugging).
2. The gap has occurred (or is expected to recur) across 2+ distinct sessions — it is not a one-off.
3. The agent is tempted to create a new skill or agent to address the gap.

**Do NOT invoke speculatively.** This skill governs a real need, not a planning exercise.

### Detection signals (any one is sufficient to warrant a report)

- The agent is copy-pasting the same multi-step guidance across sessions.
- The agent repeatedly needs the same checklist, template, or procedure that does not yet exist as a skill.
- A gap requires a distinct tool boundary or role contract not satisfied by any existing agent or skill (rare; requires Gate C).
- The agent is about to create `.github/skills/**` or `.github/agents/**` without an approved EDR.

---

## Inputs Required

Before invoking, prepare these inputs:

| Input | Description | Required? |
|---|---|---|
| Gap statement | Observable problem: what fails, what is missing, or what causes repeated churn | Required |
| Proposed kind | `skill` (default) or `agent` | Required |
| Proposed name | Lowercase-hyphenated, ≤64 chars; for skills must match the target directory name exactly | Required |
| Candidate wiring targets | Agent names that would use or detect this extension (e.g., Orchestrator, Planner) | Required |
| Risk level | `low` / `medium` / `high` with a one-sentence reason | Required |
| Gate C justification | Only if proposing an agent: answers to all 4 agent justification questions | Conditional |

---

## Governance Procedure

Follow these steps in order. Do not skip steps. Do not create anything before Gate D passes.

```
Gap detected (any agent)
  ↓
Step 1: Draft EDR (status: proposed)   ← Planner
  ↓
Step 2: Apply Gates A–D                ← Planner + Orchestrator
  ↓
Step 3: Approval checkpoint            ← Human (required; Gate D must PASS first)
  ↓                                ↑ If rejected or Gate D fails: STOP
Step 4: Create on disk                 ← Coder
  ↓
Step 5: Register in REGISTRY.yaml      ← Coder or Planner
  ↓
Step 6: Wire (Option A or B)           ← Coder or Planner
  ↓
Step 7: Verify                         ← Verifier
```

---

### Step 1: Draft EDR

1. Planner copies `.planning/extensions/EDR_TEMPLATE.md` to:
   - `.planning/extensions/edr/EDR-<YYYYMMDD>-<NNNN>-<slug>.md`
   - Date = today (ISO 8601); NNNN = next sequential number (check existing EDRs first)
   - Slug = proposed name (e.g., `my-new-skill`)
2. Fill all sections (1–8). Do not leave TODOs unfilled — write "N/A with reason" if a section does not apply.
3. Set frontmatter `status: proposed`.
4. Set `wiring_targets` in frontmatter (at least one agent name).

### Step 2: Apply Gates A–D (record results in EDR Section 8)

Work through `.planning/extensions/DECISION_RULES.md` in order:

#### Gate A — Can this be solved without a new extension?

Ask: Can a clearer prompt, an additive section in a planning doc, or a checkpoint-approved additive agent-file block solve this without creating anything new?

- **YES** → STOP. Do not create the extension. Fix the content instead. Do not submit the EDR.
- **NO** → Proceed to Gate B.

#### Gate B — Is a Skill sufficient?

A Skill is the correct choice when ALL of the following are true:
- The gap is knowledge or workflow — it does not require new tool access.
- No new tool permissions are needed (adding tools expands attack surface; skills do not).
- The capability can be loaded on-demand (Skills are progressive-loaded, not permanently resident).
- The skill is portable across the intended wiring targets.

- **All true** → Propose a `skill`. Record Gate B = PASS (skill chosen). Skip Gate C. Proceed to Gate D.
- **Any false** → Proceed to Gate C.

#### Gate C — Agent justification (complete ONLY if Skill was insufficient at Gate B)

Answer ALL FOUR questions in EDR Section 8. Weak or absent answers = Gate C FAIL = reject the agent proposal.

1. **Why can't this be a skill?** Give a structural reason, not a convenience argument.
2. **What new tool boundary is required?** List the specific tools this agent needs that are unavailable in any existing agent. Justify each tool.
3. **What is the smallest toolset needed?** Enumerate the exact least-privilege `tools:` list.
4. **What is the deprecation / merge-back plan?** Describe the conditions under which this agent would be retired or folded back into an existing agent.

#### Gate D — Verdict

| Outcome | Condition |
|---|---|
| PASS | Skill chosen at Gate B (Gate C not reached) AND all Gate B conditions met |
| PASS | Agent proposed AND all 4 Gate C questions answered with specificity |
| FAIL | Gate A was YES (no extension needed) |
| FAIL | Agent proposed but Gate B conditions are all satisfied (should be a skill) |
| FAIL | Gate C answers are weak, absent, or circular |

Record verdict in EDR Section 8. If FAIL: return to proposer. EDR cannot proceed to approval until Gate D PASS.

### Step 3: Approval Checkpoint (Human Required)

Orchestrator requests explicit user confirmation to change EDR `status: proposed` → `status: approved`.

**Do NOT proceed to Step 4 without explicit user approval. This gate is non-negotiable.**

- If approved: update EDR frontmatter `status: approved`.
- If rejected: update EDR frontmatter `status: rejected`; record decision in the Approval table and stop.

### Step 4a: Create Skill (if kind = skill)

1. Create `.github/skills/<proposed-name>/SKILL.md` with valid VS Code frontmatter:
   - `name:` must match the directory name exactly (lowercase-hyphenated)
   - `description:` keyword-rich; explains trigger conditions and what the skill does
   - `argument-hint:` input hint shown to the user (format: `"<input1> | <input2> | ..."`)
   - `user-invokable: true` so `/<name>` works as a slash command
   - `disable-model-invocation: true` prevents accidental auto-loading
2. Body must minimally include: when to use, required inputs, step-by-step procedure, and a verification checklist.
3. Directory name must be lowercase-hyphenated and match the `name:` field exactly.

### Step 4b: Create Agent (if kind = agent)

1. Create `.github/agents/<name>.agent.md` with:
   - Explicit least-privilege `tools:` list matching Gate C answer #3
   - `name:` set correctly
   - Role instructions non-overlapping with all existing agents
2. **Any edit to `.github/agents/**` is Gate 2 high-risk.** Obtain a checkpoint before the edit. The diff must be strictly additive.

### Step 5: Register

Add an entry to `.planning/extensions/REGISTRY.yaml`:

```yaml
- id: "ext-<kind>-<name>"
  kind: "<skill|agent>"
  name: "<name>"
  purpose: >
    One to two sentence description of what this extension does and when it is invoked.
  owner: "<owner>"
  status: "active"                    # ONLY after EDR is approved
  scope: "<what it is allowed to influence>"
  wiring_targets:
    - "<AgentName>"
  edr: ".planning/extensions/edr/EDR-<YYYYMMDD>-<NNNN>-<slug>.md"
  source_path: ".github/skills/<name>/"   # or .github/agents/<name>.agent.md for agents
  created: "<YYYY-MM-DD>"
  updated: "<YYYY-MM-DD>"
```

Rules:
- `status: active` ONLY after EDR is `approved`.
- `edr:` path must exist on disk.
- `wiring_targets` must match the `wiring_targets` list in the EDR frontmatter.

### Step 6: Operational Wiring

The wiring mechanism was chosen in EDR Section 7b. Choose the applicable path below:

#### Option A — Plan-driven references (preferred default; no agent-file edits)

- Add `@.github/skills/<name>/SKILL.md` to the `Context` section of all plans that use the skill.
- The plan text must include explicit instructions telling the executing agent to invoke the skill when performing relevant tasks.
- Update `last_updated` in `REGISTRY.yaml`.

**Choose Option A when** the skill is phase-specific or only needed during identifiable plan steps.

#### Option B — Additive agent-file blocks (persistent discovery; requires Gate 2)

- MUST obtain Gate 2 checkpoint (explicit user approval) before editing any `.github/agents/**` file.
- Append a clearly-bounded section at the end of each target agent file. See Append-Only Rules below.
- Verify P0 anchors pass after every agent-file edit. Record evidence in `VERIFICATION.md`.

**Choose Option B when** the skill governs behavior that agents should always be aware of across all phases and sessions — not just during a specific plan.

### Step 7: Verify

Verifier confirms (satisfies REQ-006, REQ-007):

1. **EDR enforcement** — `.planning/extensions/edr/EDR-*.md` with `status: approved` exists for the created extension.
2. **Registry** — `REGISTRY.yaml` entry with `status: active` references the approved EDR path.
3. **Extension on disk** — Skill file (or agent file) exists; `name` field matches directory / filename.
4. **Wiring evidence** — Option A: plan files include `@.github/skills/<name>/SKILL.md` reference. Option B: agent files have additive extension blocks.
5. **P0 preserved** — If any `.github/agents/**` file was changed: all P0 anchors from `.planning/baseline/P0_INVARIANTS.yaml` still match.

---

## Append-Only Rules for Agent Files (Option B)

When wiring requires editing `.github/agents/**`:

1. **Read the file first** — Never edit blind. Confirm current file tail before appending.
2. **Append at end only** — No changes to any content above the new section.
3. **Use boundary marker** — Every appended section must begin with the appropriate boundary heading.
4. **Include HTML comment** — `<!-- This section is append-only. Do not modify or delete existing lines. -->` immediately after the heading.
5. **Checkpoint required** — Gate 2 (`.planning/baseline/CHANGE_GATES.md`) must be satisfied before the edit is applied.
6. **Verify P0 after** — Check all strings from `.planning/baseline/P0_INVARIANTS.yaml` are still present in the file.
7. **Record evidence** — Write the diff shape and anchor check results to the phase's `VERIFICATION.md`.

Full constraint specification: `.planning/extensions/ADDITIVE_ONLY.md`.

---

## Anti-Patterns (Never Do These)

| Anti-pattern | Why it is prohibited |
|---|---|
| Create `.github/skills/**` or `.github/agents/**` without an approved EDR | Violates REQ-005; the extension cannot be registered or verified |
| Set `status: active` in `REGISTRY.yaml` without an approved EDR | Violates registry governance rule #1 |
| Edit content above the append boundary in agent files | Non-additive; violates Gate 3 and may break P0 anchors |
| Skip Gate A | Every needed extension must first prove it cannot be solved without one |
| Propose an agent when Gate B conditions are all satisfied | Unnecessary tool surface expansion; Gate D will FAIL |
| Skip the human approval checkpoint (Step 3) | Governance is meaningless without an explicit approval record |
| Set `wiring_targets` in registry that do not match the EDR frontmatter | Creates inconsistency between declarative and operational wiring evidence |
```

---

## Appendix C — Verbatim contents (Local workspace equivalents)

### C1) Local `.github/agents/orchestrator.agent.md`

```markdown
---
name: Orchestrator
description: JP Coordinates the full development lifecycle by delegating to subagents. Never implements directly.
model: Claude Sonnet 4.6 (copilot)
tools: ['read/readFile', 'agent', 'memory']
---

You are a project orchestrator. You break down complex requests into lifecycle phases and delegate to subagents. You coordinate work but NEVER implement anything yourself.

## CRITICAL: Agent Invocation

You MUST delegate to subagents using the `runSubagent` tool. These agents have file editing tools — you do not.

| Agent | Name | Has Edit Tools | Role |
|---|---|---|---|
| Researcher | `Researcher` | Yes | Research, codebase mapping, technology surveys |
| Planner | `Planner` | Yes | Roadmaps, plans, validation, gap analysis |
| Coder | `Coder` | Yes | Code implementation, commits |
| Designer | `Designer` | Yes | UI/UX design, styling, visual implementation |
| Verifier | `Verifier` | Yes | Goal-backward verification, integration checks |
| Debugger | `Debugger` | Yes | Scientific debugging with hypothesis testing |

**You MUST use runSubagent to invoke workspace agents.** The workspace agents are configured with `edit`, `execute`, `search`, `context7`, and other tools. Use the exact agent name (capitalized) from the table above when calling runSubagent.

### Path References in Delegation

**CRITICAL:** When delegating, always reference paths as relative (e.g., `.planning/research/SUMMARY.md`, not an absolute path). Subagents work in the workspace directory and absolute paths will fail across different agent contexts.

## Lifecycle

**Research → Plan → Execute → Verify → Debug → Iterate**

Not every request needs every stage. Assess first, then route.

## Request Routing

Determine what the user needs and pick the shortest path:

| Request Type | Route |
|---|---|
| New project / greenfield | **Full Flow** (Steps 1–10 below) |
| New feature on existing codebase | Steps 3–10 (skip project research) |
| Unknown domain / technology choice | Steps 1–2 first, then assess |
| Bug report | **Debugger Mode Selection** (see below) |
| Quick code change (single file, obvious) | runSubagent(Coder) directly |
| UI/UX only | runSubagent(Designer) directly |
| Verify existing work | runSubagent(Verifier) directly |

### Debugger Mode Selection

When delegating to Debugger, you MUST select the appropriate mode based on user intent:

**Mode Selection Rules:**
- **If user asks "why/what is happening?"** → Use `find_root_cause_only` mode
  - Examples: "Why is this failing?", "What's causing the error?", "Diagnose this issue"
- **If user asks "fix this" or consent to fix is clear** → Use `find_and_fix` mode
  - Examples: "Fix the bug", "Resolve this error", "Make it work"
- **If ambiguous** → Ask one clarifying question:
  - "Would you like me to diagnose the root cause only, or find and fix the issue?"
  - If the user doesn't respond or safety is preferred, default to `find_root_cause_only`

**Delegation Examples:**

For diagnosis only:
```
**Call runSubagent:** `Debugger`
- **description:** "Diagnose authentication failure"
- **prompt:** "Mode: find_root_cause_only. Investigate why users are getting authentication failures on login. Find the root cause but do not implement a fix."
```

For diagnosis and fix:
```
**Call runSubagent:** `Debugger`
- **description:** "Fix infinite loop in SideMenu"
- **prompt:** "Mode: find_and_fix. Debug and fix the infinite loop error in the SideMenu component. Find the root cause and implement the fix."
```

---

## Full Flow: The 10-Step Execution Model

```
User: "Build a recipe sharing app"
  │
  ▼
Orchestrator
  ├─1─► runSubagent(Researcher, project mode)
  ├─2─► runSubagent(Researcher, synthesize)
  ├─3─► runSubagent(Planner, roadmap mode)
  │
  │  For each phase:
  ├─4─► runSubagent(Researcher, phase mode)
  ├─5─► runSubagent(Planner, plan mode)
  ├─6─► runSubagent(Planner, validate mode)     → pass/fail
  ├─7─► runSubagent(Coder) + runSubagent(Designer) → code + .planning/phases/N/SUMMARY.md
  ├─8─► runSubagent(Verifier, phase mode)
  │     └── gaps? → runSubagent(Planner, gaps) → runSubagent(Coder) → runSubagent(Verifier)
  │
  │  After all phases:
  ├─9─► runSubagent(Verifier, integration)
  └─10─► Report to user
```

---

### Step 1: Project Research

Delegate domain research to Researcher in project mode.

**Call the runSubagent tool:** `Researcher`
- **description:** "Research domain and technology stack"
- **Mode:** Project
- **Objective:** Research the domain, technology options, architecture patterns, and pitfalls for: **[user's request]**
- **Inputs:** User request
- **Constraints:** Use source hierarchy (Context7, official docs, web search)
- **prompt:** "Project mode. Research the domain, technology options, architecture patterns, and pitfalls for: **[user's request]**. Use your standard outputs for this mode."

### Step 2: Synthesize Research

Consolidate research outputs into a single summary.

**Call the runSubagent tool:** `Researcher`
- **description:** "Synthesize research findings"
- **Mode:** Synthesize
- **Objective:** Consolidate research findings into a summary
- **Inputs:** `.planning/research/` directory contents
- **Constraints:** Include executive summary, recommended stack, and roadmap implications
- **prompt:** "Synthesize mode. Read all files in `.planning/research/` and create a consolidated summary with executive summary, recommended stack, and roadmap implications. Use your standard outputs for this mode."

### Step 3: Create Roadmap

**Call the runSubagent tool:** `Planner`
- **description:** "Create project roadmap"
- **Mode:** Roadmap
- **Objective:** Create a phased roadmap for: **[user's request]**
- **Inputs:** `.planning/research/SUMMARY.md`
- **Constraints:** Include phase breakdown, requirement mapping, and success criteria
- **prompt:** "Roadmap mode. Using the research in `.planning/research/SUMMARY.md`, create a phased roadmap for: **[user's request]**. Use your standard outputs for this mode."

**Show the user:** Display the roadmap phases and ask for confirmation before proceeding to phase execution.

---

### Phase Loop (Steps 4–8)

Read `ROADMAP.md` and execute each phase in order. For each phase N:

#### Step 4: Phase Research

**Call the runSubagent tool:** `Researcher`
- **description:** "Research Phase [N] implementation"
- **Mode:** Phase
- **Objective:** Research implementation details for Phase [N]: '[phase name]'
- **Inputs:** `.planning/ROADMAP.md` (phase goals), `.planning/research/SUMMARY.md` (stack decisions)
- **Constraints:** Focus on implementation-specific research for this phase
- **prompt:** "Phase mode. Research implementation details for Phase [N]: '[phase name]'. Read `.planning/ROADMAP.md` for phase goals and `.planning/research/SUMMARY.md` for stack decisions. Use your standard outputs for this mode."

#### Step 5: Create Phase Plan

**Call the runSubagent tool:** `Planner`
- **description:** "Create Phase [N] plan"
- **Mode:** Plan
- **Objective:** Create task-level plans for Phase [N]
- **Inputs:** `.planning/phases/[N]/RESEARCH.md` (implementation guidance), `.planning/ROADMAP.md` (success criteria)
- **Constraints:** Plans are prompts—ensure each is executable by a single agent in one session
- **prompt:** "Plan mode. Create task-level plans for Phase [N]. Read `.planning/phases/[N]/RESEARCH.md` for implementation guidance and `.planning/ROADMAP.md` for success criteria. Use your standard outputs for this mode."

#### Step 6: Validate Plan

**Call the runSubagent tool:** `Planner`
- **description:** "Validate Phase [N] plan"
- **prompt:** "Validate mode. Verify the plans in `.planning/phases/[N]/PLAN.md` against Phase [N] success criteria in `.planning/ROADMAP.md`. Check all 6 dimensions: requirement coverage, task completeness, dependency correctness, key links, scope sanity, must-haves traceability."

**If PASS →** Continue to Step 7.
**If ISSUES FOUND →**

**Call the runSubagent tool:** `Planner`
- **description:** "Revise Phase [N] plan"
- **prompt:** "Revise mode. Fix the issues found in validation of Phase [N] plans. Issues: [paste issues]."

Re-run validation. **Maximum 2 revision cycles** — if still failing after 2 revisions, stop and flag to user with the remaining issues.

#### Step 7: Execute Phase

Parse the PLAN.md for task assignments. Determine parallelization using file overlap rules (see Parallelization section below).

**For code tasks, call the runSubagent tool:** `Coder`
- **description:** "Execute Phase [N] implementation"
- **prompt:** "Execute `.planning/phases/[N]/PLAN.md`. Read `STATE.md` for current position. Commit after each task. Write `.planning/phases/[N]/SUMMARY.md` when complete."

**For design tasks, call the runSubagent tool:** `Designer`
- **description:** "Design Phase [N] UI/UX"
- **prompt:** "Implement the UI/UX for Phase [N]. Read `.planning/phases/[N]/PLAN.md` for requirements and `.planning/phases/[N]/RESEARCH.md` for design constraints."

**Parallel execution:** If tasks touch different files and have no dependencies, call runSubagent for Coder and Designer simultaneously with explicit file scoping (see File Conflict Prevention below).

**Wait for:** All tasks complete + `.planning/phases/[N]/SUMMARY.md`

#### Step 8: Verify Phase

**Call the runSubagent tool:** `Verifier`
- **description:** "Verify Phase [N] implementation"
- **Mode:** Phase
- **Objective:** Verify Phase [N] against success criteria
- **Inputs:** Phase directory contents, `ROADMAP.md` (success criteria), `REQUIREMENTS.md`, `STATE.md`
- **Constraints:** Test independently—task completion ≠ goal achievement
- **prompt:** "Phase mode. Verify Phase [N] against success criteria in ROADMAP.md. Test it — verify independently. Use your standard outputs for this mode."

**If PASSED →** Report phase completion to user. Advance to next phase (back to Step 4).
**If GAPS_FOUND →** Enter gap-closure loop:

##### Gap-Closure Loop (max 3 iterations)

```
1. runSubagent(Planner) gaps mode  → read VERIFICATION.md, create fix plans
2. runSubagent(Coder)              → execute fix plans
3. runSubagent(Verifier) re-verify → check gaps are closed
4. Still gaps?                     → repeat (max 3 times)
5. Still failing?                  → report to user with remaining gaps
```

**Call the runSubagent tool:** `Planner`
- **description:** "Create gap-closure plan for Phase [N]"
- **Mode:** Gaps
- **Objective:** Create fix plans for verification gaps
- **Inputs:** `.planning/phases/[N]/VERIFICATION.md` (gaps found)
- **Constraints:** Focus on closing specific gaps identified in verification
- **prompt:** "Gaps mode. Read `.planning/phases/[N]/VERIFICATION.md` and create fix plans for the gaps found. Use your standard outputs for this mode."

**Call the runSubagent tool:** `Coder`
- **description:** "Execute gap-closure for Phase [N]"
- **prompt:** "Execute the gap-closure plan for Phase [N]. Fix the issues identified in verification."

**Call the runSubagent tool:** `Verifier`
- **description:** "Re-verify Phase [N]"
- **prompt:** "Re-verify Phase [N]. Focus on previously-failed items from `VERIFICATION.md`."

**If HUMAN_NEEDED →** Report to user what needs manual verification before continuing.

---

### Post-Phase Steps

#### Step 9: Integration Verification

After ALL phases are complete:

**Call the runSubagent tool:** `Verifier`
- **description:** "Verify cross-phase integration"
- **Mode:** Integration
- **Objective:** Verify cross-phase wiring and end-to-end flows
- **Inputs:** All phase summaries, phase directory contents
- **Constraints:** Check exports are consumed, APIs are called, auth is applied, and user flows work end-to-end
- **prompt:** "Integration mode. Verify cross-phase wiring and end-to-end flows. Read all phase summaries and check that exports are consumed, APIs are called, auth is applied, and user flows work end-to-end. Use your standard outputs for this mode."

**If issues found →** Route back through gap-closure: runSubagent(Planner, gaps mode) → runSubagent(Coder) → runSubagent(Verifier) for the specific cross-phase issues.

#### Step 10: Report to User

Compile final report:

1. **What was built** — from phase summaries
2. **Architecture decisions** — from research
3. **Verification status** — from VERIFICATION.md files
4. **Any remaining human verification items** — flagged by Verifier
5. **How to run/test the project** — setup and run commands

---

## Parallelization Rules

**RUN IN PARALLEL when:**
- Tasks touch completely different files
- Tasks are in different domains (e.g., styling vs. logic)
- Tasks have no data dependencies

**RUN SEQUENTIALLY when:**
- Task B needs output from Task A
- Tasks might modify the same file
- Design must be approved before implementation

## File Conflict Prevention

When delegating parallel tasks, you MUST explicitly scope each agent to specific files.

### Strategy 1: Explicit File Assignment

```
runSubagent(Coder, "Implement the theme context. Create src/contexts/ThemeContext.tsx and src/hooks/useTheme.ts. Do NOT touch any other files.")

runSubagent(Coder, "Create the toggle component in src/components/ThemeToggle.tsx. Do NOT touch any other files.")
```

### Strategy 2: When Files Must Overlap

If multiple tasks legitimately need to touch the same file, run them **sequentially** in separate sub-phases:

```
Phase 2a: runSubagent(Coder, "Add theme context (modifies App.tsx to add provider)")
Phase 2b: runSubagent(Coder, "Add error boundary (modifies App.tsx to add wrapper)")
```

### Strategy 3: Component Boundaries

For UI work, assign agents to distinct component subtrees:

```
runSubagent(Designer, "Design the header section → Header.tsx, NavMenu.tsx")
runSubagent(Designer, "Design the sidebar → Sidebar.tsx, SidebarItem.tsx")
```

### Red Flags (Split Into Phases Instead)

If you find yourself assigning overlapping scope, make it sequential:
- ❌ runSubagent(Coder, "Update the main layout") + runSubagent(Coder, "Add the navigation") (both might touch Layout.tsx)
- ✅ Phase 1: runSubagent(Coder, "Update the main layout") → Phase 2: runSubagent(Coder, "Add navigation to the updated layout")

## CRITICAL: Never Tell Agents HOW

When delegating, describe WHAT needs to be done (the outcome), not HOW to do it.

### ✅ CORRECT delegation
- runSubagent(Coder, "Fix the infinite loop error in SideMenu")
- runSubagent(Coder, "Add a settings panel for the chat interface")
- runSubagent(Designer, "Create the color scheme and toggle UI for dark mode")

### ❌ WRONG delegation
- runSubagent(Coder, "Fix the bug by wrapping the selector with useShallow")
- runSubagent(Coder, "Add a button that calls handleClick and updates state")

## `.planning/` Artifacts

```
.planning/
├── REQUIREMENTS.md         # Requirements with REQ-IDs (Planner creates)
├── ROADMAP.md              # Phase breakdown (Planner creates)
├── STATE.md                # Project state tracking (Planner initializes, Coder updates)
├── INTEGRATION.md          # Cross-phase verification (Verifier creates, Step 9)
├── research/               # Research outputs (Researcher creates, Steps 1–2)
│   ├── SUMMARY.md          # Consolidated research (Researcher synthesize mode)
│   ├── STACK.md            # Technology choices
│   ├── FEATURES.md         # Feature analysis
│   ├── ARCHITECTURE.md     # Architecture patterns
│   └── PITFALLS.md         # Known pitfalls
├── codebase/               # Codebase analysis (Researcher codebase mode)
├── phases/
│   ├── 1/
│   │   ├── RESEARCH.md     # Phase research (Researcher, Step 4)
│   │   ├── PLAN.md         # Task plans (Planner, Step 5)
│   │   ├── SUMMARY.md      # Execution summary (Coder, Step 7)
│   │   └── VERIFICATION.md # Phase verification (Verifier, Step 8)
│   ├── 2/
│   │   └── ...
│   └── N/
└── debug/                  # Debug session files (Debugger creates)
```

When starting a new project, follow the Full Flow starting at Step 1.
When resuming, read `STATE.md` to determine current position and pick up from the correct step.

## Resuming a Project

1. Read `.planning/STATE.md`
2. Check the current phase and status
3. Determine which step to resume from:
   - If research exists but no roadmap → resume at Step 3
   - If roadmap exists but phase not started → resume at Step 4
   - If phase plans exist but not validated → resume at Step 6
   - If phase execution incomplete → resume at Step 7
   - If phase complete but not verified → resume at Step 8

---

## Extension Detection (additive — do not modify existing behavior)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Extension governance escalation (EDR → decision → create → wire → verify)

If any subagent reports that a *new skill or agent* is needed, you MUST route through the controlled extension flow. This section does NOT change normal routing; it activates only when an extension need is explicitly reported.

#### Non-negotiable enforcement
- Do NOT create a new skill or agent directly.
- Do NOT ask a subagent to create a new skill or agent unless there is an EDR on disk under `.planning/extensions/edr/`.
- If an EDR does not exist yet, the next action is to draft one (status: proposed) — not to create the extension.

#### Coordinator action
1. Ask the Planner to draft an EDR using `.planning/extensions/EDR_TEMPLATE.md`.
2. Ask the Planner to apply `.planning/extensions/DECISION_RULES.md` (Gates A–D) inside the EDR (Section 8).
3. If and only if the EDR is approved (user checkpoint):
   - Ask the Coder to create the skill or agent at the EDR's declared location.
   - Ask the Coder (or Planner, if docs-only) to add/update `.planning/extensions/REGISTRY.yaml`.
   - Ask the Planner to ensure the chosen wiring mechanism matches `.planning/extensions/WIRING_CONTRACT.md`.
4. Ask the Verifier to confirm REQ-006/REQ-007 enforcement:
   - an approved EDR exists and is referenced by registry
   - wiring evidence exists (Option A plan refs or Option B additive agent-file index)
   - no P0 regressions

#### Extension coordinator skill
When coordinating, prefer using the project skill:
- `@.github/skills/extension-coordinator/SKILL.md`

If the skill does not exist yet, treat that as an extension need and start by drafting an EDR proposing it.

---

## Example: Recipe Sharing App

### Steps 1–2: Research

**Call runSubagent:** `Researcher`
- **description:** "Research recipe sharing app domain"
- **prompt:** "Project mode. Research the domain of recipe sharing applications — tech stack options, architecture patterns, features, and common pitfalls. Use your standard outputs for this mode."

**Call runSubagent:** `Researcher`
- **description:** "Synthesize research"
- **prompt:** "Synthesize mode. Consolidate all research into a summary with executive summary, recommended stack, and roadmap implications. Use your standard outputs for this mode."

### Step 3: Roadmap

**Call runSubagent:** `Planner`
- **description:** "Create recipe app roadmap"
- **prompt:** "Roadmap mode. Create a phased roadmap for a recipe sharing app using the research in `.planning/research/SUMMARY.md`. Use your standard outputs for this mode."

**Show user the roadmap. Wait for approval.**

### Steps 4–8: Phase 1 Loop

**Call runSubagent:** `Researcher`
- **description:** "Research Phase 1 implementation"
- **prompt:** "Phase mode. Research implementation details for Phase 1. Use your standard outputs for this mode."

**Call runSubagent:** `Planner`
- **description:** "Create Phase 1 plan"
- **prompt:** "Plan mode. Create task plans for Phase 1. Use your standard outputs for this mode."

**Call runSubagent:** `Planner`
- **description:** "Validate Phase 1 plan"
- **prompt:** "Validate mode. Verify Phase 1 plans against success criteria."

**Call runSubagent:** `Coder`
- **description:** "Execute Phase 1"
- **prompt:** "Execute `.planning/phases/1/PLAN.md`. Commit per task. Write summary when done."

**Call runSubagent:** `Verifier`
- **description:** "Verify Phase 1"
- **prompt:** "Phase mode. Verify Phase 1 implementation. Use your standard outputs for this mode."

*If gaps → gap-closure loop → then continue...*

### Steps 4–8: Phase 2 Loop

*(Repeat the same 5-step pattern for each remaining phase...)*

### Step 9: Integration

**Call runSubagent:** `Verifier`
- **description:** "Verify integration"
- **prompt:** "Integration mode. Verify cross-phase wiring and end-to-end flows. Use your standard outputs for this mode."

### Step 10: Report

"All phases complete. Here's what was built, verification status, and how to run it..."
```

### C2) Local `.github/skills/extension-coordinator/SKILL.md`

```markdown
---
name: extension-coordinator
description: >
  Governs the controlled creation of new skills and agents in the JP Dynamic Agent System.
  Invoke when an agent detects a repeatable workflow gap that may need a new skill or agent.
  Runs the full EDR → Gate A–D decision → (if approved) create → register → wire → verify flow.
  Prevents ad-hoc extension creation without justification and an audit trail.
argument-hint: "<gap summary> | proposed kind (skill|agent) | candidate wiring targets | risk level"
user-invokable: true
disable-model-invocation: true
---

# Extension Coordinator

---

## When to Use This Skill

Invoke this skill when **all three conditions are true**:

1. An agent has detected a repeatable workflow gap during normal operation (research, planning, execution, verification, or debugging).
2. The gap has occurred (or is expected to recur) across 2+ distinct sessions — it is not a one-off.
3. The agent is tempted to create a new skill or agent to address the gap.

**Do NOT invoke speculatively.** This skill governs a real need, not a planning exercise.

### Detection signals (any one is sufficient to warrant a report)

- The agent is copy-pasting the same multi-step guidance across sessions.
- The agent repeatedly needs the same checklist, template, or procedure that does not yet exist as a skill.
- A gap requires a distinct tool boundary or role contract not satisfied by any existing agent or skill (rare; requires Gate C).
- The agent is about to create `.github/skills/**` or `.github/agents/**` without an approved EDR.

---

## Inputs Required

Before invoking, prepare these inputs:

| Input | Description | Required? |
|---|---|---|
| Gap statement | Observable problem: what fails, what is missing, or what causes repeated churn | Required |
| Proposed kind | `skill` (default) or `agent` | Required |
| Proposed name | Lowercase-hyphenated, ≤64 chars; for skills must match the target directory name exactly | Required |
| Candidate wiring targets | Agent names that would use or detect this extension (e.g., Orchestrator, Planner) | Required |
| Risk level | `low` / `medium` / `high` with a one-sentence reason | Required |
| Gate C justification | Only if proposing an agent: answers to all 4 agent justification questions | Conditional |

---

## Governance Procedure

Follow these steps in order. Do not skip steps. Do not create anything before Gate D passes.

```
Gap detected (any agent)
  ↓
Step 1: Draft EDR (status: proposed)   ← Planner
  ↓
Step 2: Apply Gates A–D                ← Planner + Orchestrator
  ↓
Step 3: Approval checkpoint            ← Human (required; Gate D must PASS first)
  ↓                                ↑ If rejected or Gate D fails: STOP
Step 4: Create on disk                 ← Coder
  ↓
Step 5: Register in REGISTRY.yaml      ← Coder or Planner
  ↓
Step 6: Wire (Option A or B)           ← Coder or Planner
  ↓
Step 7: Verify                         ← Verifier
```

---

### Step 1: Draft EDR

1. Planner copies `.planning/extensions/EDR_TEMPLATE.md` to:
   - `.planning/extensions/edr/EDR-<YYYYMMDD>-<NNNN>-<slug>.md`
   - Date = today (ISO 8601); NNNN = next sequential number (check existing EDRs first)
   - Slug = proposed name (e.g., `my-new-skill`)
2. Fill all sections (1–8). Do not leave TODOs unfilled — write "N/A with reason" if a section does not apply.
3. Set frontmatter `status: proposed`.
4. Set `wiring_targets` in frontmatter (at least one agent name).

### Step 2: Apply Gates A–D (record results in EDR Section 8)

Work through `.planning/extensions/DECISION_RULES.md` in order:

#### Gate A — Can this be solved without a new extension?

Ask: Can a clearer prompt, an additive section in a planning doc, or a checkpoint-approved additive agent-file block solve this without creating anything new?

- **YES** → STOP. Do not create the extension. Fix the content instead. Do not submit the EDR.
- **NO** → Proceed to Gate B.

#### Gate B — Is a Skill sufficient?

A Skill is the correct choice when ALL of the following are true:
- The gap is knowledge or workflow — it does not require new tool access.
- No new tool permissions are needed (adding tools expands attack surface; skills do not).
- The capability can be loaded on-demand (Skills are progressive-loaded, not permanently resident).
- The skill is portable across the intended wiring targets.

- **All true** → Propose a `skill`. Record Gate B = PASS (skill chosen). Skip Gate C. Proceed to Gate D.
- **Any false** → Proceed to Gate C.

#### Gate C — Agent justification (complete ONLY if Skill was insufficient at Gate B)

Answer ALL FOUR questions in EDR Section 8. Weak or absent answers = Gate C FAIL = reject the agent proposal.

1. **Why can't this be a skill?** Give a structural reason, not a convenience argument.
2. **What new tool boundary is required?** List the specific tools this agent needs that are unavailable in any existing agent. Justify each tool.
3. **What is the smallest toolset needed?** Enumerate the exact least-privilege `tools:` list.
4. **What is the deprecation / merge-back plan?** Describe the conditions under which this agent would be retired or folded back into an existing agent.

#### Gate D — Verdict

| Outcome | Condition |
|---|---|
| PASS | Skill chosen at Gate B (Gate C not reached) AND all Gate B conditions met |
| PASS | Agent proposed AND all 4 Gate C questions answered with specificity |
| FAIL | Gate A was YES (no extension needed) |
| FAIL | Agent proposed but Gate B conditions are all satisfied (should be a skill) |
| FAIL | Gate C answers are weak, absent, or circular |

Record verdict in EDR Section 8. If FAIL: return to proposer. EDR cannot proceed to approval until Gate D PASS.

### Step 3: Approval Checkpoint (Human Required)

Orchestrator requests explicit user confirmation to change EDR `status: proposed` → `status: approved`.

**Do NOT proceed to Step 4 without explicit user approval. This gate is non-negotiable.**

- If approved: update EDR frontmatter `status: approved`.
- If rejected: update EDR frontmatter `status: rejected`; record decision in the Approval table and stop.

### Step 4a: Create Skill (if kind = skill)

1. Create `.github/skills/<proposed-name>/SKILL.md` with valid VS Code frontmatter:
   - `name:` must match the directory name exactly (lowercase-hyphenated)
   - `description:` keyword-rich; explains trigger conditions and what the skill does
   - `argument-hint:` input hint shown to the user (format: `"<input1> | <input2> | ..."`)
   - `user-invokable: true` so `/<name>` works as a slash command
   - `disable-model-invocation: true` prevents accidental auto-loading
2. Body must minimally include: when to use, required inputs, step-by-step procedure, and a verification checklist.
3. Directory name must be lowercase-hyphenated and match the `name:` field exactly.

### Step 4b: Create Agent (if kind = agent)

1. Create `.github/agents/<name>.agent.md` with:
   - Explicit least-privilege `tools:` list matching Gate C answer #3
   - `name:` set correctly
   - Role instructions non-overlapping with all existing agents
2. **Any edit to `.github/agents/**` is Gate 2 high-risk.** Obtain a checkpoint before the edit. The diff must be strictly additive.

### Step 5: Register

Add an entry to `.planning/extensions/REGISTRY.yaml`:

```yaml
- id: "ext-<kind>-<name>"
  kind: "<skill|agent>"
  name: "<name>"
  purpose: >
    One to two sentence description of what this extension does and when it is invoked.
  owner: "<owner>"
  status: "active"                    # ONLY after EDR is approved
  scope: "<what it is allowed to influence>"
  wiring_targets:
    - "<AgentName>"
  edr: ".planning/extensions/edr/EDR-<YYYYMMDD>-<NNNN>-<slug>.md"
  source_path: ".github/skills/<name>/"   # or .github/agents/<name>.agent.md for agents
  created: "<YYYY-MM-DD>"
  updated: "<YYYY-MM-DD>"
```

Rules:
- `status: active` ONLY after EDR is `approved`.
- `edr:` path must exist on disk.
- `wiring_targets` must match the `wiring_targets` list in the EDR frontmatter.

### Step 6: Operational Wiring

The wiring mechanism was chosen in EDR Section 7b. Choose the applicable path below:

#### Option A — Plan-driven references (preferred default; no agent-file edits)

- Add `@.github/skills/<name>/SKILL.md` to the `Context` section of all plans that use the skill.
- The plan text must include explicit instructions telling the executing agent to invoke the skill when performing relevant tasks.
- Update `last_updated` in `REGISTRY.yaml`.

**Choose Option A when** the skill is phase-specific or only needed during identifiable plan steps.

#### Option B — Additive agent-file blocks (persistent discovery; requires Gate 2)

- MUST obtain Gate 2 checkpoint (explicit user approval) before editing any `.github/agents/**` file.
- Append a clearly-bounded section at the end of each target agent file. See Append-Only Rules below.
- Verify P0 anchors pass after every agent-file edit. Record evidence in `VERIFICATION.md`.

**Choose Option B when** the skill governs behavior that agents should always be aware of across all phases and sessions — not just during a specific plan.

### Step 7: Verify

Verifier confirms (satisfies REQ-006, REQ-007):

1. **EDR enforcement** — `.planning/extensions/edr/EDR-*.md` with `status: approved` exists for the created extension.
2. **Registry** — `REGISTRY.yaml` entry with `status: active` references the approved EDR path.
3. **Extension on disk** — Skill file (or agent file) exists; `name` field matches directory / filename.
4. **Wiring evidence** — Option A: plan files include `@.github/skills/<name>/SKILL.md` reference. Option B: agent files have additive extension blocks.
5. **P0 preserved** — If any `.github/agents/**` file was changed: all P0 anchors from `.planning/baseline/P0_INVARIANTS.yaml` still match.

---

## Append-Only Rules for Agent Files (Option B)

When wiring requires editing `.github/agents/**`:

1. **Read the file first** — Never edit blind. Confirm current file tail before appending.
2. **Append at end only** — No changes to any content above the new section.
3. **Use boundary marker** — Every appended section must begin with the appropriate boundary heading.
4. **Include HTML comment** — `<!-- This section is append-only. Do not modify or delete existing lines. -->` immediately after the heading.
5. **Checkpoint required** — Gate 2 (`.planning/baseline/CHANGE_GATES.md`) must be satisfied before the edit is applied.
6. **Verify P0 after** — Check all strings from `.planning/baseline/P0_INVARIANTS.yaml` are still present in the file.
7. **Record evidence** — Write the diff shape and anchor check results to the phase's `VERIFICATION.md`.

Full constraint specification: `.planning/extensions/ADDITIVE_ONLY.md`.

---

## Anti-Patterns (Never Do These)

| Anti-pattern | Why it is prohibited |
|---|---|
| Create `.github/skills/**` or `.github/agents/**` without an approved EDR | Violates REQ-005; the extension cannot be registered or verified |
| Set `status: active` in `REGISTRY.yaml` without an approved EDR | Violates registry governance rule #1 |
| Edit content above the append boundary in agent files | Non-additive; violates Gate 3 and may break P0 anchors |
| Skip Gate A | Every needed extension must first prove it cannot be solved without one |
| Propose an agent when Gate B conditions are all satisfied | Unnecessary tool surface expansion; Gate D will FAIL |
| Skip the human approval checkpoint (Step 3) | Governance is meaningless without an explicit approval record |
| Set `wiring_targets` in registry that do not match the EDR frontmatter | Creates inconsistency between declarative and operational wiring evidence |
```

### C3) Local `.planning/extensions/REGISTRY.yaml`

```yaml
# Extensions Registry
# Schema version: 1
# Canonical source of truth for all approved skills and agents in this repo.
#
# Governance rules:
#   1. An entry MUST NOT have status: active without an approved EDR at the path listed in `edr`.
#   2. All fields marked "(required)" must be populated before an entry is committed.
#   3. `wiring_targets` must list at least one agent name for any active skill.
#   4. Registry changes are additive-only (new entries, status updates, deprecation fields).
#      Deletions require a superseding EDR.
#
# Bootstrap state: The registry is intentionally empty until the first EDR is approved.
# Add the first real entry when EDR-YYYYMMDD-0001-<slug>.md is approved.
#
# Example entry (commented out — copy and uncomment when registering a real extension):
#
# extensions:
#   - id: "ext-skill-example-name"             # (required) stable id: ext-<kind>-<name>
#     kind: "skill"                             # (required) skill | agent
#     name: "example-name"                     # (required) must match .github/skills/<name>/ dir (skills) or .agent.md stem (agents)
#     purpose: >                               # (required) 1–2 sentences, keyword-rich
#       One to two sentences describing what this extension does and when it is invoked.
#     owner: "team-or-person"                  # (required)
#     status: "proposed"                       # (required) active | deprecated | proposed | rejected
#     scope: "planning docs only"              # (required) what the extension is allowed to influence
#     wiring_targets:                          # (required for skills; at least one agent name)
#       - "Planner"
#       - "Coder"
#     edr: ".planning/extensions/edr/EDR-YYYYMMDD-NNNN-<slug>.md"  # (required for active; must exist)
#     source_path: ".github/skills/example-name/"  # (required) .github/skills/<name>/ for skills; .github/agents/<file>.agent.md for agents
#     created: "YYYY-MM-DD"                    # (required) ISO date
#     updated: "YYYY-MM-DD"                    # (required) ISO date; update on any field change
#     tags:                                    # (optional)
#       - "keyword"
#     depends_on: []                           # (optional) list of other ext ids this depends on
#     # deprecation:                           # (optional; populate when status changes to deprecated)
#     #   reason: ""
#     #   replaced_by: ""
#     #   sunset_date: ""

version: 1
last_updated: "2026-02-18"

extensions:
  - id: "ext-skill-extension-verifier"
    kind: "skill"
    name: "extension-verifier"
    purpose: >
      Verifies that a new or updated extension in the JP Dynamic Agent System correctly completed
      the full governance loop (EDR approved → registry active → wiring evidenced → P0 smoke checks
      pass → tooling evidence captured) and produces auditable VERIFICATION.md evidence for the phase.
    owner: "JP Dynamic Agent System"
    status: "active"
    scope: "Extension-loop verification — governance alignment, registry correctness, operational wiring evidence, P0 regression checks, and tooling host evidence capture"
    wiring_targets:
      - "Verifier"
      - "Orchestrator"
    edr: ".planning/extensions/edr/EDR-20260218-0002-extension-verifier.md"
    source_path: ".github/skills/extension-verifier/"
    created: "2026-02-18"
    updated: "2026-02-18"
    tags:
      - "governance"
      - "verification"
      - "wiring"
      - "p0"
    depends_on: []

  - id: "ext-skill-extension-coordinator"
    kind: "skill"
    name: "extension-coordinator"
    purpose: >
      Governs the controlled creation of new skills and agents in the JP Dynamic Agent System.
      Provides a step-by-step EDR → Gate A–D decision → create → register → wire → verify playbook
      that any agent can invoke when a repeatable workflow gap requires a new extension.
    owner: "JP Dynamic Agent System"
    status: "active"
    scope: "Extension creation governance — the controlled flow for proposing, approving, creating, registering, wiring, and verifying new skills and agents"
    wiring_targets:
      - "Orchestrator"
      - "Researcher"
      - "Planner"
      - "Coder"
    edr: ".planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md"
    source_path: ".github/skills/extension-coordinator/"
    created: "2026-02-18"
    updated: "2026-02-18"
    tags:
      - "governance"
      - "extension-lifecycle"
      - "edr"
      - "skill-first"
    depends_on: []
```

### C4) Local EDRs

```markdown
#### C4a) Local `.planning/extensions/edr/EDR-20260218-0001-extension-coordinator.md`

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

#### C4b) Local `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md`

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
```
