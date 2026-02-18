# Phase 3 Research: Additive integration of the controlled extension flow

## Summary

Phase 3 integrates the Phase 2 governance artifacts into day-to-day agent operation **without changing baseline (P0) behavior unless the extension flow is explicitly invoked**.

This phase must satisfy:
- **REQ-006** — A controlled flow to create a new skill (and if justified, a new agent) during research/planning/coding, repeatable + auditable via `.planning/` artifacts.
- **REQ-007** — Any newly created skill must be wired to the correct agent(s) (discoverable + referenced) and validated by verification checks.

The integration approach for this repo should be:
1. **Detection**: existing agents detect “we keep needing missing knowledge/workflow/tool boundary” during normal work.
2. **Routing**: agents **do not create** skills/agents ad hoc; they route an “extension need” to a single coordinator role.
3. **Governance flow**: the coordinator triggers a controlled sequence: **EDR → decision gates → (if approved) create → register → wire → verify**.
4. **Enforcement**: verifier checks block any new skill/agent creation unless an approved EDR exists and is referenced.

This can be implemented skill-first by adding a single project skill `extension-coordinator` and appending strictly additive blocks to existing agents under the `## Extensions (additive-only)` boundary marker (per `.planning/extensions/WIRING_CONTRACT.md` and `.planning/extensions/ADDITIVE_ONLY.md`).

---

## Inputs reviewed (repo-local)

- `.planning/ROADMAP.md` — Phase 3 goal + success criteria
- `.planning/REQUIREMENTS.md` — REQ-006, REQ-007
- `.planning/extensions/DECISION_RULES.md` — skill-first policy gates
- `.planning/extensions/WIRING_CONTRACT.md` — declarative + operational wiring definitions
- `.planning/extensions/ADDITIVE_ONLY.md` — append-only constraints for `.github/agents/**`
- `.planning/baseline/CHANGE_GATES.md` and `.planning/baseline/P0_INVARIANTS.yaml` — checkpoint triggers + P0 anchors
- All `.github/agents/*.agent.md` files — current instructions/tools/roles

Notes:
- `.github/copilot-instructions.md` does **not** exist in this repo. (VS Code supports it, but Phase 3 does not require adding it.)

---

## Standard stack / platform facts (verified)

| Need | Solution | Confidence | Source |
|---|---|---|---|
| Project skills location | `.github/skills/<skill>/SKILL.md` | HIGH | VS Code Agent Skills docs (project skills paths) |
| SKILL.md required header fields | `name`, `description` | HIGH | VS Code Agent Skills docs |
| SKILL.md optional header fields | `argument-hint`, `user-invokable`, `disable-model-invocation` | HIGH | VS Code Agent Skills docs |
| Custom agents in repo | `.github/agents/*.agent.md` | HIGH | VS Code Custom Agents docs |
| Skill naming constraints | lowercase + hyphens, 1–64, must match directory | HIGH | Agent Skills spec |
| Wiring definition for this repo | `REGISTRY.yaml` + operational evidence (plan refs OR agent-file index) | HIGH | `.planning/extensions/WIRING_CONTRACT.md` |

---

## 1) Agent inventory (current state)

This section inventories each agent’s **frontmatter** and role-relevant properties that impact “extension detection + routing”.

| Agent | File | Description (frontmatter) | Tools (frontmatter) | Normal-phase where it naturally detects gaps |
|---|---|---|---|---|
| Orchestrator | `.github/agents/orchestrator.agent.md` | Coordinates lifecycle; delegates; never implements | `['read/readFile','agent','memory']` | During delegation and subagent result synthesis |
| Researcher | `.github/agents/researcher.agent.md` | Investigates + documents; never implements | `['vscode','execute','read','context7/*','edit','search','web','memory']` | During research when repeated workflow/knowledge gaps appear |
| Planner | `.github/agents/planner.agent.md` | Roadmaps + plans; no code | `['vscode','execute','read','context7/*','edit','search','web','memory','todo']` | During planning/validation when recurring plan scaffolds are needed |
| Coder | `.github/agents/coder.agent.md` | Implements code; commits per task | `['vscode','execute','read','context7/*','github/*','edit','search','web','memory','todo']` | During execution when missing procedural glue causes repeated thrash |
| Designer | `.github/agents/designer.agent.md` | UI/UX implementation | `['vscode','execute','read','context7/*','edit','search','web','memory','todo']` | During UI work when repeated design system patterns are missing |
| Verifier | `.github/agents/verifier.agent.md` | Independent verification | `['vscode','execute','read','edit','search','memory']` | During verification when it finds “created but not wired” gaps |
| Debugger | `.github/agents/debugger.agent.md` | Hypothesis-driven debugging | `['vscode','execute','read','edit','search','web','memory','context7/*']` | During debugging when a recurring debugging playbook is needed |

---

## 2) Extension detection candidates + additive append plan (per agent)

### Key rule: additive-only, non-invasive

Per `.planning/extensions/ADDITIVE_ONLY.md`, any `.github/agents/**` changes must:
- be **append-only at end of file**
- live under the boundary marker:

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->
```

The additive sections below are written to be behavior-neutral:
- they apply **only when an agent detects an “extension need” condition**
- otherwise the agent continues its normal workflow unchanged

### Detection signal definition (shared)

An agent should treat a situation as an “extension need” when one or more are true:
- The agent repeats the same multi-step guidance across sessions (copy/paste patterns).
- The agent repeatedly needs the same checklists/templates (EDR, wiring, verification checklists, etc.).
- A gap requires a distinct tool boundary or role contract not satisfied by existing agents (rare; requires Gate C).
- The work is being blocked by “we need a new skill/agent” and the agent is tempted to create one ad hoc.

### Routing target (shared)

All detection routes to the same coordinator role:
- **Primary coordinator:** `Orchestrator` (because it is the lifecycle router and already owns cross-agent handoffs)
- **Coordinator implementation aid:** project skill `extension-coordinator` (skill-first) invoked by Orchestrator (via Planner/Coder where edits are needed)

Why Orchestrator as the coordinator role:
- It is already responsible for routing across Research → Plan → Execute → Verify.
- It already enforces “never implement directly,” which reduces risk of accidental creation.
- It can delegate the governed steps (EDR drafting, creation, wiring, verification) to the correct subagents.

---

### 2.1 Orchestrator

**(a) Candidate to detect need?** YES — sees cross-agent patterns and can notice repeated “we need a new skill/agent” requests.

**(b) Additive section to append:** add an “extension governance escalation” procedure that is invoked only when subagents report an extension need.

**Exact additive block to append to `.github/agents/orchestrator.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Extension governance escalation (EDR → decision → create → wire → verify)

If any subagent reports that a *new skill or agent* is needed, you MUST route through the controlled extension flow.

#### Non-negotiable enforcement
- Do NOT create a new skill or agent directly.
- Do NOT ask a subagent to create a new skill or agent unless there is an EDR on disk under `.planning/extensions/edr/`.
- If an EDR does not exist yet, the next action is to draft one (status: proposed) — not to create the extension.

#### Coordinator action
1. Ask the Planner to draft an EDR using `.planning/extensions/EDR_TEMPLATE.md`.
2. Ask the Planner to apply `.planning/extensions/DECISION_RULES.md` (Gates A–D) inside the EDR (Section 8).
3. If and only if the EDR is approved (user checkpoint):
   - Ask the Coder to create the skill or agent at the EDR’s declared location.
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
```

---

### 2.2 Researcher

**(a) Candidate to detect need?** YES — frequently uncovers recurring workflows/checklists.

**(b) Additive section to append:** detect recurring “we need a reusable workflow” and report to Orchestrator, including suggested wiring targets.

**Exact additive block to append to `.github/agents/researcher.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Detect extension needs (skill-first)

During research, if you identify a repeatable workflow/checklist/reference that would reduce future thrash, propose a *skill* (default) rather than an agent.

#### What to do when you detect a need
- Do NOT create `.github/skills/**` or `.github/agents/**` yourself unless the phase plan explicitly instructs it AND an approved EDR exists.
- Instead, report the need to the Orchestrator with a concise extension proposal:

**Extension Need Report (copy/paste format):**
- Kind: skill | agent (default: skill)
- Proposed name (skill dir / agent stem):
- Problem/gap (observable):
- Why existing agents/skills can’t solve it:
- Likely wiring targets (agent names):
- Suggested operational wiring: Option A (plan refs) or Option B (agent-file index)
- Risk level (low/medium/high) and why

If an agent is proposed, you MUST reference `.planning/extensions/DECISION_RULES.md` Gate C justification conditions.
```

---

### 2.3 Planner

**(a) Candidate to detect need?** YES — planning is where missing templates and repeatable governance steps show up.

**(b) Additive section to append:** provide controlled “draft EDR” behavior and a standard handoff package for Orchestrator.

**Exact additive block to append to `.github/agents/planner.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Extension governance support (skill-first)

If a plan requires creating a new skill/agent, you MUST ensure the controlled flow is followed.

#### Hard constraints
- Do NOT instruct the Coder/Designer to create `.github/skills/**` or a new `.github/agents/**` file unless an EDR exists at `.planning/extensions/edr/EDR-*.md`.
- Prefer skills over agents unless Gate C is clearly satisfied (see `.planning/extensions/DECISION_RULES.md`).

#### When an extension is needed
1. Draft an EDR (status: proposed) using `.planning/extensions/EDR_TEMPLATE.md`.
2. Fill Section 8 (Gate A–D decision record) with explicit PASS/FAIL reasoning.
3. Provide a routing message to the Orchestrator with:
   - EDR path
   - kind + proposed name
   - wiring_targets list
   - recommended wiring mechanism (Option A vs B) and rationale

#### Plan wiring rules
When planning work that uses an approved skill, include an explicit reference:
- `@.github/skills/<skill-name>/SKILL.md`

Do not assume “skill exists” means it is wired; ensure the plan declares the wiring evidence required by `.planning/extensions/WIRING_CONTRACT.md`.
```

---

### 2.4 Coder

**(a) Candidate to detect need?** YES — execution is where missing reusable procedures cause repeated churn.

**(b) Additive section to append:** enforce “no new skill/agent without approved EDR” at execution time; route to Orchestrator when tempted.

**Exact additive block to append to `.github/agents/coder.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Controlled creation of new skills/agents (EDR required)

If you believe a new skill or agent is needed while executing a plan:

#### Stop/route rule
- Do NOT create or modify `.github/skills/**` or add a new `.github/agents/**` file unless:
  1) the current phase plan explicitly assigns that task, AND
  2) an EDR exists under `.planning/extensions/edr/` with status `approved`, AND
  3) the change references the EDR (path) in the task context / summary.

If any condition is not met, STOP and return a decision checkpoint to the Orchestrator describing the need and asking for the governed flow to be initiated.

#### When approved and assigned
If the plan assigns extension creation and the EDR is approved:
- Follow `.planning/extensions/WIRING_CONTRACT.md` (registry + operational wiring evidence).
- Treat any edit to `.github/agents/**` as high-risk and checkpoint-gated (see `.planning/baseline/CHANGE_GATES.md`, Gate 2).
```

---

### 2.5 Designer

**(a) Candidate to detect need?** SOMETIMES — less frequent, but can detect reusable UI/UX workflows (accessibility checklists, component patterns).

**(b) Additive section to append:** route design-oriented skill needs to Orchestrator; never create skills/agents ad hoc.

**Exact additive block to append to `.github/agents/designer.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Detect reusable UI/UX workflow gaps

If you find yourself repeating the same accessibility/testing/layout guidance across sessions, propose a new *skill* rather than embedding long guidance in chat.

Constraints:
- Do NOT create `.github/skills/**` or `.github/agents/**` unless the plan explicitly assigns it AND an approved EDR exists.
- Report the need to the Orchestrator using a short “Extension Need Report” (kind, proposed name, gap, wiring targets).
```

---

### 2.6 Verifier

**(a) Candidate to detect need?** YES — verifier is the enforcement point and will detect governance gaps (“created but not wired”, “no EDR”).

**(b) Additive section to append:** add explicit REQ-006/REQ-007 verification gates.

**Exact additive block to append to `.github/agents/verifier.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Extension governance verification (REQ-006, REQ-007)

When verifying a phase that may include new skills/agents, you MUST check:

1) **EDR enforcement (blocker)**
- If `.github/skills/**` was created/modified OR a new `.github/agents/**` file was added:
  - Confirm an EDR exists under `.planning/extensions/edr/` and is `approved`.
  - Confirm `REGISTRY.yaml` contains an entry referencing that EDR.
  - If missing → FAIL verification (gaps_found) and cite evidence.

2) **Wiring completeness (blocker)**
- Confirm declarative wiring: `REGISTRY.yaml` wiring_targets include the intended agents.
- Confirm operational wiring evidence exists per the EDR’s choice:
  - Option A: plan files reference `@.github/skills/<name>/SKILL.md` and instruct invocation
  - Option B: agent files have appended `## Extensions (additive-only)` skill index entries

3) **P0 preservation (blocker if violated)**
- If any `.github/agents/**` file changed, ensure changes are append-only and P0 anchors in `.planning/baseline/P0_INVARIANTS.yaml` still match.
```

---

### 2.7 Debugger

**(a) Candidate to detect need?** YES — recurring debug procedures are prime skill candidates.

**(b) Additive section to append:** route “debugging playbook skill” needs to Orchestrator; never create without EDR.

**Exact additive block to append to `.github/agents/debugger.agent.md`:**

```markdown
## Extensions (additive-only)
<!-- This section is append-only. Do not modify or delete existing lines. -->

### Detect repeatable debugging workflows → propose a skill

If you identify a recurring debug workflow that should be standardized (templates, checklists, commands, evidence patterns), propose a new *skill*.

Constraints:
- Do NOT create new skills/agents ad hoc.
- Report the need to the Orchestrator with: proposed skill name, gap statement, and recommended wiring targets.
- If a new agent seems necessary, you MUST reference `.planning/extensions/DECISION_RULES.md` Gate C and provide the tool-boundary justification.
```

---

## 3) Which agent(s) should act as the “extension coordinator”?

### Recommendation

- **Coordinator role:** `Orchestrator`
- **Coordinator playbook:** new project skill `extension-coordinator`

Rationale:
- Orchestrator already owns the cross-agent lifecycle and is the best single place to receive extension-need reports.
- Orchestrator’s current toolset cannot accidentally implement extensions directly, which reduces risk.
- The coordinator can delegate governed steps to Planner (EDR/registry/wiring plan) and Coder (creation/wiring edits) and Verifier (enforcement).

### Alternate (not preferred)

- Planner as coordinator role.

Reason it’s less preferred:
- Planner has edit + execute tools and could accidentally drift into “creating” rather than “coordinating” without Orchestrator oversight.
- The roadmap’s lifecycle model is Orchestrator-driven; keeping coordination there preserves the P0 routing contract.

---

## 4) New skill scaffold plan: `.github/skills/extension-coordinator/`

### Location

- `.github/skills/extension-coordinator/SKILL.md`

This aligns with VS Code’s supported project skills locations (`.github/skills/`).

### SKILL.md: required contents

**Frontmatter (VS Code):**

- `name: extension-coordinator` (must match directory)
- `description:` keyword-rich; describe governance flow, when to use
- `argument-hint:` e.g. `"<gap summary> | target agents | proposed kind"`
- `user-invokable: true` (so `/extension-coordinator` exists)
- `disable-model-invocation: true` (recommended) to require explicit invocation and avoid accidental auto-loading of governance logic

(Frontmatter fields verified in VS Code Agent Skills docs.)

**Body (must include):**
1. **When to use** (trigger conditions; skill-first)
2. **Inputs required**
   - gap statement
   - candidate wiring targets
   - proposed kind (skill/agent)
   - risk level
3. **Governance procedure** (EDR → decision → create → wire → verify)
4. **EDR drafting checklist** (how to fill `.planning/extensions/EDR_TEMPLATE.md`)
5. **Decision enforcement** (Gate A–D summary + how to record in EDR Section 8)
6. **Create-skill flow** and **create-agent flow** (step-by-step; see Section 6 below)
7. **Wiring instructions**
   - registry update requirements
   - operational wiring Option A vs Option B; when to choose which
8. **Verification checklist** for Verifier to apply (REQ-006/REQ-007)
9. **Append-only rules** for `.github/agents/**` (must reference `.planning/extensions/ADDITIVE_ONLY.md` and baseline gates)

### How it is invoked (wiring)

Phase 3 should treat this skill as the standard playbook:
- **Orchestrator** uses it when receiving an extension need report.
- **Planner** can use it to draft the EDR + registry update steps.
- Plans that execute extension tasks should include:
  - `@.github/skills/extension-coordinator/SKILL.md`

This is the lowest-risk operational wiring (Option A) because it avoids agent-file edits for the skill itself.

---

## 5) Is a dedicated “extension coordinator” *agent* justified?

### Recommendation: NO (skill-first verdict)

Applying `.planning/extensions/DECISION_RULES.md`:

- **Gate A:** This cannot be solved purely by better prose in a single plan; the extension flow must become repeatable across phases and detectable during normal work → proceed.
- **Gate B:** The “extension coordinator” capability is procedural governance knowledge (EDR template usage, gate checks, wiring steps) and requires **no new tool boundary** beyond what Orchestrator already coordinates via existing agents.
- Therefore, a **skill** is sufficient and preferred.

A new agent would only be justified if we needed a *distinct* tool boundary or context isolation not already present. Currently, we do not: coordination can be done by Orchestrator delegating to Planner/Coder/Verifier with least privilege already encoded in each.

### When an agent *might* be justified later (future EDR)

Only consider a new agent if:
- governance must be executed with a narrower tools surface than Planner/Coder, OR
- we need hard isolation (e.g., security review context), OR
- we require a new role contract that cannot be represented by an additive skill + Orchestrator routing.

---

## 6) Governance-bound flows: create-skill and create-agent (step-by-step)

These flows are the controlled mechanism that satisfies REQ-006 and REQ-007.

### 6.1 Create-skill flow (within governance boundary)

1. **Detect need** (any agent)
   - Agent recognizes repeatable workflow/knowledge gap.
   - Agent reports an Extension Need Report to Orchestrator.

2. **Draft EDR (proposed)** (Planner)
   - Copy `.planning/extensions/EDR_TEMPLATE.md` into `.planning/extensions/edr/EDR-YYYYMMDD-NNNN-<slug>.md`.
   - Fill Sections 1–8.
   - Set `kind: skill`, `status: proposed`, include `wiring_targets`.

3. **Decision gates (A–D)** (Planner + Orchestrator oversight)
   - Apply `.planning/extensions/DECISION_RULES.md` and record Gate results in EDR Section 8.
   - If Gate A = YES (solvable without extension) → STOP; fix content/prompt/plan instead.

4. **Approval checkpoint** (human)
   - Orchestrator requests user confirmation to set EDR to `approved`.
   - If approved: update EDR frontmatter `status: approved`.

5. **Create skill on disk** (Coder)
   - Create `.github/skills/<skill-name>/SKILL.md` with valid frontmatter.
   - Keep SKILL.md concise; store extra references as additional files.

6. **Register** (Coder or Planner)
   - Add entry to `.planning/extensions/REGISTRY.yaml` with:
     - `status: active`
     - `edr: <path to approved EDR>`
     - `wiring_targets: [...]`
     - `source_path: .github/skills/<skill-name>/`

7. **Operational wiring evidence** (choose per EDR Section 7b)
   - **Option A (preferred default):** add `@.github/skills/<skill>/SKILL.md` reference(s) in the plan(s) that will use it, plus explicit “invoke it” instructions.
   - **Option B:** append Skill Index references into target agent file(s) under `## Extensions (additive-only)` (requires Gate 2 checkpoint).

8. **Verify** (Verifier)
   - Confirm EDR approved + registry references it.
   - Confirm skill exists and directory/name match.
   - Confirm wiring evidence exists (Option A or B) per `.planning/extensions/WIRING_CONTRACT.md`.
   - Confirm P0 invariants still pass if any agent file changed.

### 6.2 Create-agent flow (within governance boundary)

This is strictly rarer and must satisfy Gate C.

1. **Detect need (tool/role boundary)** (any agent)
   - The report must include: what tool boundary is missing and why a skill cannot solve it.

2. **Draft EDR (proposed)** (Planner)
   - Same EDR creation steps, but set `kind: agent`.
   - Must answer all Gate C agent-justification questions in EDR Section 8.

3. **Approval checkpoint (human)**
   - Orchestrator requests explicit user approval, because a new agent changes tool boundaries and risk surface.

4. **Create agent on disk** (Coder)
   - Create `.github/agents/<new>.agent.md` with explicit least-privilege `tools:` list.

5. **Register** (Coder or Planner)
   - Add `REGISTRY.yaml` entry with `kind: agent`, `source_path: .github/agents/<new>.agent.md`, and EDR reference.

6. **Wire**
   - Operational wiring must be explicit:
     - plan-driven references to use that agent, and/or
     - Orchestrator routing updates (append-only) if necessary.

7. **Verify** (Verifier)
   - Confirm EDR approved + registry entry.
   - Confirm tool boundary matches EDR.
   - Confirm P0 invariants still pass.

---

## 7) Phase 3 default wiring recommendations (risk-managed)

### Default operational wiring: Option A (plan-driven)

For Phase 3, prefer **Option A** as the default operational wiring mechanism:
- It avoids changing `.github/agents/**` unless/until a checkpointed decision is made.
- It still satisfies REQ-007 because plans become explicit wiring evidence.

Option B (agent-file skill index) can be introduced later as an explicitly checkpointed action once the team decides persistent agent-file discoverability is worth the risk.

---

## Sources

| Source | Type | Confidence |
|---|---|---|
| `.planning/ROADMAP.md` | Local | HIGH |
| `.planning/REQUIREMENTS.md` | Local | HIGH |
| `.planning/extensions/DECISION_RULES.md` | Local | HIGH |
| `.planning/extensions/WIRING_CONTRACT.md` | Local | HIGH |
| `.planning/extensions/ADDITIVE_ONLY.md` | Local | HIGH |
| `.planning/baseline/CHANGE_GATES.md` and `.planning/baseline/P0_INVARIANTS.yaml` | Local | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/agent-skills | Official | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/custom-agents | Official | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Official | HIGH |
| https://agentskills.io/specification | Official | HIGH |
