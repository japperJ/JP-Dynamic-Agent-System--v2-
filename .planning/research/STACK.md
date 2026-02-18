# Technology Stack (JP Dynamic Agent System v2)

This repository is primarily a **VS Code Copilot Agent configuration repo**: it contains agent definition files under `.github/agents/` and (currently) no application source code.

| Layer | Technology | Version | Confidence | Source | Rationale |
|---|---|---|---|---|---|
| Host OS | Windows | (user environment) | HIGH | User environment info | Target runtime for local workflow |
| IDE | VS Code Insiders | (not pinned) | MEDIUM | Reference gist notes Insiders + settings; local usage context | Some agent/memory features are Insiders-only/experimental |
| Agent definitions | VS Code “Custom Agents” (`*.agent.md` with YAML frontmatter) | (feature, not pinned) | HIGH | `.github/agents/orchestrator.agent.md` etc. | Declares subagents, models, tools, and operating instructions |
| Orchestration pattern | JP 7-agent lifecycle (Orchestrator/Researcher/Planner/Coder/Designer/Verifier/Debugger) | (process) | HIGH | `.github/agents/*.agent.md` | Separation of duties + lifecycle loops with verification & debugging |
| Documentation retrieval | Context7 MCP server (Upstash extension) | 1.0.1 (ext listing) | HIGH | https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp | “Context7-first” rule depends on MCP docs access |
| “Memory” capability (2 distinct concepts) | (A) VS Code tool listed as `memory` in agent tool lists; (B) GitHub Copilot Memory (repo-scoped memories on GitHub) | Preview / not pinned | MEDIUM | (A) `.github/agents/orchestrator.agent.md` tools; (B) https://docs.github.com/en/copilot/concepts/agents/copilot-memory | Need to distinguish VS Code tool wiring vs GitHub-hosted Copilot Memory feature |
| Source control | Git | (not pinned) | HIGH | Planner/Coder discipline described in agent docs (e.g., per-task commits) | Enables atomic commits per task, debugging via `git bisect`, and traceable summaries |
| Artifact system | `.planning/` file taxonomy (research/roadmap/phases/debug/etc.) | (convention) | HIGH | `.github/agents/orchestrator.agent.md` + `.github/agents/researcher.agent.md` | Enables repeatable plan→execute→verify loops with durable context |

## Observed repository contents (current)

- Present: `.github/agents/` with 7 agent definition files.
- Absent: `.planning/` (will be created by workflow), skills library, README/docs.

**Evidence:** workspace listing shows only `.github/agents/*.agent.md` (no other top-level folders/files).

## Notes on “memory”

There is real ecosystem confusion between:

1. **VS Code agent tool name** used in agent `tools:` lists (e.g., `memory` in `.github/agents/orchestrator.agent.md`).
2. **GitHub Copilot Memory** (preview feature on GitHub.com for PRs/CLI) described in GitHub docs.

They are not necessarily the same system. Plan for graceful degradation if memory is unavailable or renamed, and avoid making the workflow depend on memory for correctness.
