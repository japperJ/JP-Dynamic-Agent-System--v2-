# Feature Analysis (JP Dynamic Agent System v2)

This document describes **what the repo currently provides** and what must be **added** to support the user’s goal: *controlled self-extension* (adding new agents/skills only when justified + documented).

## Feature: Multi-agent SDLC orchestration (JP flow)
- **Standard approach:** A thin orchestrator delegates to specialist agents; work is tracked via durable artifacts under `.planning/`.
- **What exists here:** Full 10-step execution model + routing rules in `.github/agents/orchestrator.agent.md`.
- **Pitfalls:** Tool availability/settings can silently prevent subagent execution; see PITFALLS.md.
- **Confidence:** HIGH
- **Source:** `.github/agents/orchestrator.agent.md`

## Feature: Research discipline with source hierarchy (Context7-first)
- **Standard approach:** Use live docs for libraries/frameworks to avoid stale model knowledge.
- **What exists here:** A strict hierarchy and confidence protocol.
- **What to add:** (Optional) a short repo-level “How to use Context7 in this system” doc, but not required for baseline.
- **Pitfalls:** Missing MCP server or tool name mismatch leads to “unknown tool” and degraded research.
- **Confidence:** HIGH
- **Source:** `.github/agents/researcher.agent.md`; Context7 extension listing: https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp

## Feature: Goal-backward planning with plan validation
- **Standard approach:** Derive must-haves and verification hooks from success criteria; validate plans before execution.
- **What exists here:** Planner modes (roadmap/plan/validate/gaps/revise) and a 6-dimension validation rubric.
- **Pitfalls:** Oversized plans degrade execution; validation loops need explicit limits.
- **Confidence:** HIGH
- **Source:** `.github/agents/planner.agent.md`

## Feature: Independent verification & gap-closure loops
- **Standard approach:** Treat task completion as insufficient; verify artifacts are wired and observable truths hold.
- **What exists here:** Phase & integration verification modes plus structured YAML gap output.
- **Pitfalls:** Verification can be gamed by trusting summaries; this system explicitly forbids that.
- **Confidence:** HIGH
- **Source:** `.github/agents/verifier.agent.md`

## Feature: Scientific debugging workflow
- **Standard approach:** Hypothesis-driven debugging with persistent evidence logs; avoid bias.
- **What exists here:** Dedicated Debugger agent and `.planning/debug/BUG-*.md` protocol.
- **Pitfalls:** Debug sessions can balloon in scope without a 3-test rule.
- **Confidence:** MEDIUM (agent file exists; not validated in execution here)
- **Source:** `.github/agents/debugger.agent.md` (present in workspace)

## Feature: Controlled self-extension (agents + skills) — **missing; must be added**

### What “controlled self-extension” needs
A governance mechanism that answers:

1. **When is extension allowed?** (clear triggers)
2. **What form is allowed?** (skill doc vs agent vs prompt template)
3. **How is it justified + documented?** (lightweight but mandatory)
4. **How is it validated?** (non-breaking, additive, no behavior regression)

### Recommended implementation pattern (non-invasive)
- Prefer **skills (curated Markdown knowledge packs)** as the first extension mechanism.
  - Skills can be plain Markdown guidance modules (observed in community examples) and don’t require new tool permissions.
  - Evidence: community repo includes `skills/` directory and describes skills as specialized knowledge. https://github.com/simkeyur/vscode-agents
- Only create a **new agent** when one of these is true:
  - It requires a distinct toolset (e.g., `github/*`, `execute`) or a different safety boundary.
  - It needs a different “mode contract” (e.g., research-only vs implement-only).
  - The existing agents’ instructions would become bloated or internally contradictory.

### What to add to this repo (design)
- A small **extension decision record** template (EDR) requiring:
  - Problem statement
  - Why an existing agent/skill cannot solve it
  - Proposed change (skill/agent)
  - Expected benefit and risks
  - Verification plan
- A **registry** documenting approved skills/agents and their owners.

*(These governance docs are recommended; the required deliverables for this request remain the `.planning/research/*` files.)*

- **Pitfalls:** Uncontrolled proliferation increases cognitive load and tool attack surface.
- **Confidence:** MEDIUM
- **Sources:**
  - JP flow emphasizes traceable artifacts and strict routing: `.github/agents/orchestrator.agent.md`
  - Skills as Markdown modules in practice: https://github.com/simkeyur/vscode-agents
  - Reference “Ultralight Orchestration” agent ecosystem discussions highlight tool/settings fragility: https://gist.github.com/burkeholland/0e68481f96e94bbb98134fa6efd00436
