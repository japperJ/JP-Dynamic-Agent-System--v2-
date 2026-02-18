# Known Pitfalls (JP Dynamic Agent System v2)

## Pitfall: Tool availability depends on VS Code/Insiders settings
- **Severity:** High
- **Description:** Subagent delegation and file edit tools may appear “configured” in agent files, but the host IDE may not grant them unless specific settings are enabled.
- **Mitigation:** Document required settings (e.g., “Use custom agent in Subagent”) and validate tool availability early with a small test task.
- **Source:** Reference gist discussions about enabling subagents/memory/settings: https://gist.github.com/burkeholland/0e68481f96e94bbb98134fa6efd00436

## Pitfall: Ambiguity around `memory` tool / “Copilot Memory” feature
- **Severity:** High
- **Description:**
  - Agent files may list `memory` as a tool (e.g., Orchestrator), but memory support can be experimental and naming may vary.
  - GitHub Copilot Memory is a separate preview feature (repo-scoped memories on GitHub/CLI), not necessarily the same as a VS Code tool.
- **Mitigation:** Treat memory as optional. Never make correctness depend on it. Keep the workflow functional with only `.planning/` artifacts.
- **Sources:**
  - Tool list in `.github/agents/orchestrator.agent.md`
  - GitHub Copilot Memory docs: https://docs.github.com/en/copilot/concepts/agents/copilot-memory

## Pitfall: MCP server/tool-name mismatches (“unknown tool”)
- **Severity:** Medium
- **Description:** Agent instructions assume `context7/*` tools exist. If Context7 MCP isn’t installed or registers under a different name, the system degrades.
- **Mitigation:** Standardize on the Context7 MCP extension and verify the tool name in your environment.
- **Source:** Context7 MCP extension listing (includes registered functions and claims “no additional config required”): https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp

## Pitfall: Context bloat from large skills / long web captures
- **Severity:** Medium
- **Description:** Skills can be large Markdown knowledge packs; indiscriminately loading them can blow context budgets.
- **Mitigation:** Use skills as references, not always-on context. Prefer linking to skill sections or keeping skills modular.
- **Source:** Community “skills/” pattern is explicitly promoted (skills can be extensive): https://github.com/simkeyur/vscode-agents

## Pitfall: Uncontrolled self-extension (agent/skill sprawl)
- **Severity:** High
- **Description:** If new agents/skills can be created freely, the roster grows, role boundaries blur, and orchestration becomes unreliable.
- **Mitigation:** Adopt “skill-first,” require decision records, and require deprecation/merge-back plans.
- **Source:** Risk inferred from multi-agent system complexity; consistent with traceability emphasis in JP orchestrator/planner.

## Pitfall: Security boundaries when granting `execute`/`edit` tools
- **Severity:** High
- **Description:** Agents with `execute` and `edit` can alter the repo and run commands. Without governance, this increases the risk of unintended destructive actions.
- **Mitigation:**
  - Keep Orchestrator non-implementing.
  - Require explicit file scoping in delegation.
  - Prefer documentation-only skills for knowledge gaps.
- **Source:** Orchestrator’s explicit file-scoping and non-implementation posture: `.github/agents/orchestrator.agent.md`

## Pitfall: Git submodules and reproducibility issues (if adopted later)
- **Severity:** Low
- **Description:** If you later import external systems via git submodules, collaborators may clone without `--recursive` and get missing content.
- **Mitigation:** Document clone/update steps and consider whether a package manager is a better fit.
- **Source:** GitHub blog guidance: https://github.blog/open-source/git/working-with-submodules/
