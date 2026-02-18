# Architecture Patterns (JP Dynamic Agent System v2)

This repo is an **agent-system configuration**, not an application. The “architecture” is therefore the workflow + artifact graph.

## Current architecture (as implemented in this repo)

### Pattern: Thin orchestrator + specialist subagents
- **Why:** Minimizes single-agent context bloat; enforces separation of duties.
- **Structure:**
  - `.github/agents/orchestrator.agent.md` — routes requests; never edits files
  - `.github/agents/researcher.agent.md` — research outputs & codebase mapping
  - `.github/agents/planner.agent.md` — roadmaps + plans + plan validation
  - `.github/agents/coder.agent.md` — implementation discipline (atomic commits)
  - `.github/agents/designer.agent.md` — UI/UX focus
  - `.github/agents/verifier.agent.md` — goal-backward verification
  - `.github/agents/debugger.agent.md` — hypothesis-driven debugging
- **Key decisions it locks in:**
  - Orchestrator does not implement; it delegates.
  - `.planning/` is the single “source of truth” for artifacts and traceability.
  - Verification is independent and may trigger iterative gap closure.
- **Confidence:** HIGH
- **Source:** Local workspace agent definitions under `.github/agents/`

### Pattern: Artifact-driven lifecycle (`.planning/`)
- **Why:** Durable state across sessions; reproducibility; controllable iteration loops.
- **Structure (expected):**
  - `.planning/research/*` for stack/features/architecture/pitfalls + synthesized summary
  - `.planning/ROADMAP.md`, `.planning/REQUIREMENTS.md`, `.planning/STATE.md`
  - `.planning/phases/<N>/{RESEARCH,PLAN,SUMMARY,VERIFICATION}.md`
  - `.planning/debug/BUG-*.md`
- **Key decisions:**
  - Plans are prompts (WHAT not HOW)
  - Limits on revision loops and gap closure loops
- **Confidence:** HIGH
- **Source:** `.github/agents/orchestrator.agent.md`, `.github/agents/planner.agent.md`, `.github/agents/verifier.agent.md`

## Additive architecture for controlled self-extension (recommended)

Goal: allow the system to extend itself (new skills/agents) **only with explicit justification**, without changing existing behavior.

### Pattern: “Skill-first” extension layer
- **Why:** Skills can be pure documentation guidance, avoiding new tool permissions or orchestration changes.
- **Suggested structure:**
  - `skills/<skill-name>/SKILL.md` (curated, versioned guidance)
  - Optional `skills/<skill-name>/README.md` (short summary)
- **Evidence that this is viable:** Community multi-agent setups include `skills/` as Markdown knowledge modules. https://github.com/simkeyur/vscode-agents
- **Decision rule:** If the gap is “knowledge missing” → add a skill; if the gap is “capability/tool boundary missing” → consider an agent.

### Pattern: Extension governance via decision records
- **Why:** Prevents agent/skill sprawl; preserves a minimal, comprehensible roster.
- **Suggested artifacts:**
  - `.planning/extensions/EDR-<date>-<slug>.md` (Extension Decision Record)
  - `.planning/extensions/REGISTRY.md` (approved extensions)
- **Core gates (must pass):**
  1. **Necessity:** cannot be solved by updating existing agent instructions or adding a small skill section
  2. **Bounded scope:** clear “in scope/out of scope” and sunset criteria
  3. **Safety:** does not broaden tool permissions without explicit justification
  4. **Verification:** includes a test/verification plan (even if manual)

### Pattern: Minimal-change integration
- **Why:** Meets the user constraint: do not behaviorally change existing flow beyond an additive governed creation flow.
- **Approach:**
  - Keep existing 7-agent lifecycle unchanged.
  - Add governance docs and a “how to extend” guideline.
  - If a new agent is introduced, it must:
    - have a clearly different role boundary,
    - list tools explicitly,
    - include a deprecation/merge-back strategy.

## Alternatives considered
- **Auto-generating agents on demand:** Rejected for now.
  - Hard to audit; encourages proliferation; increases risk from tool permissions.
  - Confidence: MEDIUM (risk-based judgment; consistent with principles of traceability)
