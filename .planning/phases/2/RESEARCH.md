# Phase 2 Research: Governance for controlled self-extension (skill-first)

## Summary

Phase 2 is a governance + metadata phase. It must create **auditable, repo-local artifacts** that (a) justify any extension **before** it is created (REQ-005), (b) enforce a **skill-first** decision rule (REQ-004), and (c) maintain a durable **registry of approved extensions** (REQ-013).

This repo currently contains **custom agents only** under `.github/agents/*.agent.md` and **no** `.github/skills/` or `.github/instructions/` directories.

**Existing agents (inventory):**
- `.github/agents/orchestrator.agent.md`
- `.github/agents/researcher.agent.md`
- `.github/agents/planner.agent.md`
- `.github/agents/coder.agent.md`
- `.github/agents/designer.agent.md`
- `.github/agents/verifier.agent.md`
- `.github/agents/debugger.agent.md`

Implication: the safest “controlled self-extension” path is to define governance in `.planning/` first (EDR + registry + wiring contract) and only later (Phase 3+) add actual skills/agents.

---

## Standard Stack

| Need | Solution | Version | Confidence | Source |
|---|---|---:|---|---|
| Skill packaging standard | Agent Skills (`SKILL.md` in `.github/skills/<name>/`) | N/A | HIGH | VS Code docs: https://code.visualstudio.com/docs/copilot/customization/agent-skills |
| Skill format constraints | Agent Skills Specification | N/A | HIGH | Agent Skills spec: https://agentskills.io/specification |
| Custom agent location + frontmatter | `.github/agents/*.agent.md` | N/A | HIGH | VS Code docs: https://code.visualstudio.com/docs/copilot/customization/custom-agents |
| Instruction file conventions (`applyTo`) | `.github/instructions/*.instructions.md` | N/A | HIGH | VS Code docs: https://code.visualstudio.com/docs/copilot/customization/custom-instructions |
| Additive-only constraint | Append-only edits + change gates | N/A | HIGH | Local baseline gate doc: `.planning/baseline/CHANGE_GATES.md` |

---

## 1) Extension Decision Records (EDR): exact file locations + naming

### Location (repo convention)

**Directory:** `.planning/extensions/edr/`

Rationale:
- Phase 2 governance is part of the artifact graph under `.planning/` (aligned with the repo’s “artifact-driven lifecycle”).
- Keeping EDRs separate from per-phase folders avoids scattering “extension approvals” across phase execution traces.

### Naming convention (stable, sortable, collision-resistant)

**File name format:** `EDR-YYYYMMDD-NNNN-<slug>.md`

Rules:
- `YYYYMMDD` = date created (UTC or local, but be consistent in the repo)
- `NNNN` = 4-digit sequence for that day (0001, 0002, …) to avoid same-day collisions
- `<slug>` = lowercase hyphenated summary (e.g., `webapp-testing-skill`, `new-security-review-agent`)

Examples:
- `.planning/extensions/edr/EDR-20260218-0001-webapp-testing-skill.md`
- `.planning/extensions/edr/EDR-20260218-0002-security-review-agent.md`

### EDR template location

**Template file:** `.planning/extensions/EDR_TEMPLATE.md`

This template should be mandatory for any new extension proposal (skill or agent) and should be referenced from `REGISTRY.yaml` entries once approved.

### EDR format (recommended)

Use **Markdown with YAML frontmatter** for:
- diff-friendly structure
- machine-checkable metadata (future automation)
- human-readable narrative sections

Recommended frontmatter fields:
- `edr_id`: matches filename without extension (e.g., `EDR-20260218-0001-webapp-testing-skill`)
- `date`: ISO date string
- `status`: `proposed` | `approved` | `rejected` | `superseded`
- `kind`: `skill` | `agent`
- `proposed_name`: skill/agent identifier (for skills: the `name` in SKILL.md)
- `owner`: human/team responsible
- `requirements`: include `REQ-004`, `REQ-005`, `REQ-013` as appropriate
- `wiring_targets`: list of target agents by canonical name (e.g., `Planner`, `Coder`)
- `risk_level`: `low` | `medium` | `high`
- `additive_only`: must be `true`

Required body sections (minimum set aligned to ROADMAP Phase 2 success criteria):
- Problem / gap statement
- Why existing agents/skills can’t solve it (explicitly list what was tried)
- Proposal (what will be added)
- Scope (in-scope / out-of-scope)
- Risks (including tool permission implications)
- Verification plan (how the Verifier can confirm wiring + no P0 regressions)
- Wiring contract (what must be updated so it becomes discoverable + referenced)

---

## 2) Extensions registry: format, fields, file type, location

### Location (repo convention)

**Canonical registry file:** `.planning/extensions/REGISTRY.yaml`

Optional companion (human-friendly): `.planning/extensions/REGISTRY.md` generated/maintained manually as a readable view (not authoritative).

Rationale for YAML:
- Matches existing repo patterns (YAML used for baseline invariants + plan frontmatter).
- Easy diff review.
- Can be consumed later by automated checks (Phase 3+), without changing its shape.

### Registry schema (recommended)

Top-level fields:
- `version`: integer schema version (start at 1)
- `last_updated`: ISO timestamp
- `extensions`: array of entries

Per-extension entry fields (minimum to satisfy REQ-013 and Phase 2 success criteria):
- `id`: stable identifier (recommend: `ext-<kind>-<name>`)
- `kind`: `skill` | `agent`
- `name`: for skills, must match SKILL.md `name`; for agents, must match selected agent name / file
- `purpose`: 1–2 sentences (keyword-rich)
- `owner`: person/team
- `status`: `active` | `deprecated` | `proposed` | `rejected`
- `scope`: what the extension is allowed to influence (e.g., “planning docs only”, “code execution”, “UI styling”, etc.)
- `wiring_targets`: list of agent names that are expected to reference/use it (e.g., `[Planner, Coder]`)
- `edr`: relative path to the approving EDR (must exist for `active`)
- `source_path`: where the implementation lives
  - skills: `.github/skills/<name>/`
  - agents: `.github/agents/<file>.agent.md`
- `created`: ISO date
- `updated`: ISO date

Recommended optional fields:
- `tags`: list of keywords
- `depends_on`: other extension ids
- `deprecation`: object with `reason`, `replaced_by`, `sunset_date`

Governance rule:
- An extension **MUST NOT** be moved to `active` unless an EDR exists and is `approved`.

---

## 3) Decision rules: skill-first gate logic (skill vs agent)

This repo’s roadmap already encodes the core rule:
- Knowledge / documentation gap → **create a skill**
- Distinct tool boundary / role contract gap → **consider a new agent**

To make it enforceable, the EDR template and review checklist should require the following decision tree.

### Gate A — can this be solved without adding anything?

If YES, do not create a skill/agent. Prefer one of:
- clarifying prompt + better plan
- adding a short additive section to an existing agent file (only if checkpoint approved; must preserve P0 anchors)
- adding a `.planning/` playbook doc

### Gate B — if something new is needed, default to Skill

Create a **Skill** when all are true:
- The gap is procedural knowledge, checklists, references, or repeatable workflow.
- The capability can be provided **without** introducing a new tool boundary.
- The skill can be consumed on-demand and remain portable.

This aligns with VS Code’s framing: skills are “folders of instructions, scripts, and resources loaded on-demand.”
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills

### Gate C — only consider a new Agent when Skill is insufficient

Consider a **Custom Agent** only when one or more are true:
- You need **tool restrictions** that differ from existing agents (security boundary / least privilege).
- You need **context isolation** (specialized persona with tighter scope).
- You need an explicit **role contract** that changes workflow orchestration (handoffs, subagent-only visibility, etc.).

This aligns with VS Code’s custom agent purpose: “personas with specific tools, instructions, behaviors,” especially to tailor tools per task.
Source: https://code.visualstudio.com/docs/copilot/customization/custom-agents

### Gate D — skill-first enforcement rule (testable)

An EDR proposing a new agent must explicitly answer:
1. Why can’t this be implemented as a skill?
2. What new tool boundary is required?
3. What is the smallest toolset needed (least privilege)?
4. What is the deprecation/merge-back plan if it’s no longer needed?

If those answers are weak → reject agent proposal and require a skill instead.

---

## 4) Wiring mechanism: how skills are discovered + how this repo should reference them

### Discovery (VS Code behavior)

VS Code discovers project skills by scanning standard locations including:
- `.github/skills/<skill-name>/SKILL.md`
- `.claude/skills/<skill-name>/SKILL.md`
- `.agents/skills/<skill-name>/SKILL.md`

It can also be configured with `chat.agentSkillsLocations`.
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills

VS Code loads skills progressively:
1. Reads `name` + `description` for discovery
2. Loads SKILL.md body when relevant or invoked
3. Loads referenced resources as needed
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills

### Repo convention (recommended)

Because this repo already standardizes “workspace-level customizations live under `.github/`”, adopt:

- **Skills live at:** `.github/skills/<skill-name>/SKILL.md`
- **Each approved skill MUST have:**
  - a registry entry in `.planning/extensions/REGISTRY.yaml`
  - an approved EDR under `.planning/extensions/edr/`

### Referencing (the “wiring contract”)

This repo needs a definition of “wired,” beyond mere discoverability.

Recommended 2-layer wiring contract:

1) **Declarative wiring (governance):**
- `REGISTRY.yaml` must include `wiring_targets: [<AgentName>, ...]`
- Each `wiring_target` is an explicit claim that “this agent is expected to use this skill when relevant.”

2) **Operational wiring (execution evidence):** choose one mechanism per extension (record the choice in the EDR)

Option A (lowest risk, no agent-file edits): Plan-driven referencing
- Phase plans that need the skill include an explicit reference in their Context section, e.g. `@.github/skills/<name>/SKILL.md`.
- The plan text must instruct the executing agent to invoke the skill (manually via `/` or by referencing it) when performing the task.

Option B (stronger discoverability, but touches agent files): Additive agent-file “Skill Index” sections
- Append a clearly delimited section to the target agent(s), containing a short list of “Approved skills I may use,” linking to the skill folder.
- This requires Gate 2 (agent-file gate) and a user checkpoint per `.planning/baseline/CHANGE_GATES.md`.

Phase 3’s checkpoint (“Skill wiring mechanism”) in `.planning/STATE.md` should decide which option becomes the default. Phase 2 should define both and require the EDR to pick one.

---

## 5) Additive-only constraint: patching approach that preserves agent file content

The repo already defines an additive-only policy and a strict checkpoint requirement for editing `.github/agents/**`.
Source: `.planning/baseline/CHANGE_GATES.md`

To preserve existing agent behavior while still allowing additive wiring references later:

### Patching rule (recommended)

When editing any `.github/agents/*.agent.md` file for extension wiring:
- **Do not modify or delete existing lines.**
- Only append new content under a single new section at the end of the file.
- Use an unambiguous boundary marker so future edits remain append-only:
  - Example marker concept: a final section titled `## Extensions (additive-only)`.

### Why this matters

- Agent files are the P0 workflow definition; rewrites risk regressions.
- Append-only edits are easy to review in diff and easier to prove non-regressive.

### Governance enforcement

EDR must state whether agent-file edits are needed.
- If YES: the EDR must include explicit anchor-preservation checks (from `.planning/baseline/P0_INVARIANTS.yaml`) and require a checkpoint.

---

## 6) VS Code Insiders agent-customization conventions relevant to this phase

### Skills (SKILL.md)

**Location:** `.github/skills/<skill-name>/SKILL.md` (project skill)
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills

**SKILL.md frontmatter fields (VS Code):**
- `name` (required): lowercase hyphenated; must match parent directory; max 64 chars
- `description` (required): what + when; max 1024 chars
- `argument-hint` (optional)
- `user-invokable` (optional): show as `/skill` command (defaults true)
- `disable-model-invocation` (optional): block auto-loading (defaults false)
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills

**Naming constraints (Agent Skills spec):**
- lowercase alphanumeric + hyphens only
- must not start/end with hyphen; no consecutive hyphens
- must match directory name
Source: https://agentskills.io/specification

**Progressive loading + size guidance:** keep SKILL.md concise; reference additional files.
Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills and https://agentskills.io/specification

### Custom agents (.agent.md)

**Location:** `.github/agents/*.agent.md` detected as custom agents.
Source: https://code.visualstudio.com/docs/copilot/customization/custom-agents

**Frontmatter fields used for governance relevance:**
- `description`, `name`, `tools`, `model`, `agents`, `user-invokable`, `disable-model-invocation`
Source: https://code.visualstudio.com/docs/copilot/customization/custom-agents

Phase 2 implication:
- A proposed new agent must justify tool boundaries, because the `tools:` list is the enforceable permission surface.

### File-based instructions (.instructions.md)

**Location:** `.github/instructions/*.instructions.md`
**Frontmatter:** `description`, optional `name`, optional `applyTo` glob patterns.
Source: https://code.visualstudio.com/docs/copilot/customization/custom-instructions

This repo currently has no `.github/instructions/`. If governance later needs “always apply these constraints when editing registry/EDRs,” consider adding a narrow `.instructions.md` that applies to `.planning/extensions/**` only (Phase 3+), rather than broad `applyTo: "**"`.

---

## Don’t hand-roll

| Need | Use Instead | Why |
|---|---|---|
| Skill packaging format | Agent Skills standard (`SKILL.md`) | Portable, tool-supported discovery and progressive loading (VS Code + other agents) |
| Agent wiring discovery | `.github/skills` scanning + `REGISTRY.yaml` | Avoid hidden state; make wiring auditable |
| Additive-only enforcement | Existing change gates | Already defined and proven in Phase 1 |

---

## Common Pitfalls

1. **Creating an agent when a skill would suffice** — increases tool surface and governance load.
2. **“Skill exists” but isn’t wired** — discovery ≠ referenced usage; require registry + operational wiring evidence.
3. **Editing agent files non-additively** — risks P0 regressions; must be append-only with checkpoint.
4. **Vague skill descriptions** — reduces discovery and auto-loading; descriptions must be keyword-rich.

---

## Open Questions (should be checkpoints in Phase 3, but defined here)

1. **Default operational wiring mechanism:** plan-driven vs agent-file index vs both.
2. **Registry enforcement mechanism:** manual process only vs add a verifier checklist item that asserts registry+EDR consistency.
3. **Agent naming canonicalization:** use `name:` field in frontmatter vs filename as canonical id in the registry.

---

## Sources

| Source | Type | Confidence |
|---|---|---|
| `.planning/ROADMAP.md` | Local | HIGH |
| `.planning/REQUIREMENTS.md` | Local | HIGH |
| `.planning/research/SUMMARY.md` and `.planning/research/ARCHITECTURE.md` | Local | HIGH |
| `.planning/baseline/CHANGE_GATES.md` | Local | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/agent-skills | Official | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/custom-agents | Official | HIGH |
| https://code.visualstudio.com/docs/copilot/customization/custom-instructions | Official | HIGH |
| https://agentskills.io/specification | Official | HIGH |
