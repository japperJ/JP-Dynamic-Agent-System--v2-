# Research Summary — JP Dynamic Agent System (v2)

## Executive Summary

This workspace currently contains **only the JP agent definitions** under `.github/agents/` (Orchestrator/Researcher/Planner/Coder/Designer/Verifier/Debugger). The core lifecycle, artifact taxonomy, and discipline (Context7-first research, goal-backward planning, independent verification, hypothesis-driven debugging) are already present in those agent files.

Compared to the referenced ecosystems (Burke Holland’s “Ultralight Orchestration”, GSD-OpenCode, and JP’s published gist/repo), the biggest gap in this workspace is not “missing agent logic”—it’s **missing `.planning/` research artifacts and governance** to support the user’s goal: **controlled self-extension** (adding agents/skills only when justified and documented). The safest additive approach is **skill-first**: add curated Markdown skill modules and a lightweight approval/registry mechanism; only create new agents when a distinct tool boundary or role contract is required.

## Key Findings

1. **The JP 7-agent roster is already installed** in the repo (`.github/agents/*.agent.md`).
   - Confidence: HIGH
   - Source: Workspace listing + agent file contents.

2. **`.planning/` is a core architectural dependency** of the workflow, but it does not yet exist in this workspace.
   - Confidence: HIGH
   - Source: `.github/agents/orchestrator.agent.md` describes `.planning/` artifacts; workspace lacks `.planning/`.

3. **Context7 MCP is the intended documentation backbone** for research/planning/coding agents.
   - Confidence: HIGH
   - Source: Context7 extension docs: https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp

4. **“Memory” is a frequent integration pain point** and appears in two distinct forms:
   - a VS Code tool name listed in agent toolsets (`memory`), often experimental/Insiders-gated
   - GitHub Copilot Memory (repo-scoped) preview feature on GitHub/CLI
   - Confidence: MEDIUM
   - Sources:
     - Orchestrator tool list: `.github/agents/orchestrator.agent.md`
     - GitHub Copilot Memory docs: https://docs.github.com/en/copilot/concepts/agents/copilot-memory

5. **Skills are “plain Markdown knowledge packs” in practice**, making them a low-risk extension mechanism.
   - Confidence: MEDIUM
   - Source: Community repo with `skills/` directory and explicit “Skills & Specialized Knowledge” section: https://github.com/simkeyur/vscode-agents

## Copy vs Add (delta to support controlled self-extension)

### What must be copied (from reference setups)
- **Nothing critical is missing at the agent-definition layer.** The workspace already includes the JP agent files comparable to JP’s repo/gist.
- If you want parity with the broader community ecosystem, you may copy:
  - a `skills/` directory layout (optional) and a small README explaining skill usage.

### What must be added (for your goal)
1. **The required research artifacts** under `.planning/research/` (this set): `STACK.md`, `FEATURES.md`, `ARCHITECTURE.md`, `PITFALLS.md`, `SUMMARY.md`.
2. **A controlled self-extension governance mechanism** (recommended additions beyond this request):
   - Extension Decision Record (EDR) template
   - Registry of approved skills/agents
   - Clear decision rule: skill-first; agent only for tool/role boundaries

## Recommended Stack

- VS Code Insiders (for best feature availability) + Copilot agent support.
- Context7 MCP extension for live docs.
- Git initialized (required for the Coder’s atomic commit discipline).
- Treat memory features as optional enhancements, not dependencies.

## Roadmap Implications

1. **Bootstrap the artifact system:** create `.planning/` and the baseline research docs (done by this research output).
2. **Define the governance for extension before adding anything:** decide what triggers creation of a new skill vs new agent.
3. **Introduce skill-first extensions:** add 1–2 skills only after a justified EDR, to validate the governance workflow.
4. **Only then consider new agents:** require a strict role boundary + toolset justification + sunset/merge-back plan.

## Sources

| Source | Type | Confidence | What it supported |
|---|---|---|---|
| `.github/agents/orchestrator.agent.md` (local) | Workspace file | HIGH | Installed JP orchestrator + lifecycle + `.planning/` artifact model |
| `.github/agents/researcher.agent.md` (local) | Workspace file | HIGH | Research outputs required under `.planning/research/` |
| `.github/agents/planner.agent.md` (local) | Workspace file | HIGH | Planning/validation model |
| `.github/agents/verifier.agent.md` (local) | Workspace file | HIGH | Verification + gap-closure model |
| https://gist.github.com/burkeholland/0e68481f96e94bbb98134fa6efd00436 | Web | MEDIUM | Ecosystem notes: Insiders settings, memory/tool fragility |
| https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp | Official marketplace | HIGH | Context7 MCP capabilities + installation info |
| https://github.com/rokicool/gsd-opencode | Web | MEDIUM | Example of artifact-driven workflow systems in the ecosystem |
| https://github.com/simkeyur/vscode-agents | Web | MEDIUM | Evidence of skills as Markdown knowledge modules |
| https://docs.github.com/en/copilot/concepts/agents/copilot-memory | Official docs | HIGH | Copilot Memory concept + retention/validation model |
| https://docs.github.com/en/copilot/how-tos/use-copilot-agents/copilot-memory | Official docs | HIGH | How to enable/curate Copilot Memory |
