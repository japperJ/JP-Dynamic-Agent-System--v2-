# Phase 1 Research: Baseline planning + risk gates (P0-preserving)

## Summary

Phase 1 is a **docs + verification-gates** phase: capture “P0 workflow invariants” in a structured, checkable way; define a verification pattern that does **not** depend on optional tools (notably `memory`); and add explicit hidden-risk probes for host environment capabilities (VS Code Insiders vs Stable, MCP/Context7 availability, subagent/edit permissions).

This repo currently has **no `.vscode/` workspace settings** committed (no `.vscode/settings.json`, no MCP config files). Therefore, Phase 1 must treat *host configuration* as external state and record it in `.planning/` as durable evidence.

## Requirements covered (Phase 1)

| Requirement | What Phase 1 needs to enable | Where to capture/verify |
|---|---|---|
| REQ-001 | Preserve current JP P0 lifecycle behavior (no regressions) | Baseline invariants + additive-only diff gates |
| REQ-002 | Additive-only changes, with strict gating if agent files touched | Additive policy + diff-based regression checks |
| REQ-003 | Durable planning artifacts and per-phase folders | `.planning/phases/1/*` scaffolding conventions |
| REQ-008 | Verification criteria + hidden-risk checks | Capability probe + Context7/MCP probe + memory-optional stance |
| REQ-009 | User-confirmation checkpoints when uncertain | “Reduced-capability mode” checkpoint rules |
| REQ-010 | Plans executable by delegated agents (clear file targets + done criteria) | Provide file targets and verification mechanisms here |
| REQ-011 | Continuous P0 regression gates after each additive extension | Baseline snapshot + repeating smoke checks |
| REQ-012 | Document host prerequisites + fallbacks (no optional-tool dependency) | Host prerequisites section + fallback playbooks |

---

## Standard stack (for Phase 1 work)

| Need | Solution | Version | Confidence | Source |
|---|---|---|---|---|
| Identify Insiders vs Stable | VS Code Insiders “side-by-side install” + host capture | N/A | HIGH | VS Code Insiders download page https://code.visualstudio.com/insiders/ |
| Capture host VS Code version & extensions | VS Code CLI (`--version`, `--list-extensions`) via `code-insiders` | N/A | HIGH | VS Code CLI docs (Insiders uses `code-insiders`; supports `--version`, `--list-extensions`) https://code.visualstudio.com/docs/editor/command-line |
| Programmatic detection reference (if needed later) | VS Code Extension API `vscode.env.*` (e.g., `appName`) | N/A | HIGH | VS Code API docs (`env.appName`, etc.) https://code.visualstudio.com/api/references/vscode-api#env |
| MCP/Context7 docs retrieval | Upstash Context7 MCP extension registers an MCP server (`context7`) and tools like `mcp_context7-new_*` | 1.0.1 (listing) | HIGH | Marketplace listing https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp + repo https://github.com/upstash/context7-vscode-extension |
| “Memory is optional” discipline | Treat GitHub Copilot Memory as a bonus; don’t depend on it | Preview | HIGH | GitHub docs describe validation via citations + 28-day retention https://docs.github.com/en/copilot/concepts/agents/copilot-memory |

---

## 1) Capturing P0 workflow invariants (checkable format)

### What “P0 workflow” means in this repo

P0 is the currently-installed JP multi-agent lifecycle and its constraints, as encoded in:
- `.github/agents/*.agent.md` (Orchestrator/Researcher/Planner/Coder/Designer/Verifier/Debugger)
- the artifact taxonomy under `.planning/` as described by the Orchestrator agent

P0 invariants should focus on **what must remain true** even as you add governance, skills, and extension flows.

### Recommended invariant types (make them checkable)

Use a *structured assertions file* (YAML or JSON) that a human (and later an automated checker) can verify with simple reads/greps.

Recommended invariant categories:

1) **File existence invariants**
- Example: “All 7 agent files exist under `.github/agents/`.”

2) **Content anchor invariants** (stable snippets)
- Example: Orchestrator must include “Never implements directly” and must instruct delegation.

3) **Tool surface invariants** (declared toolsets)
- Example: Each agent’s frontmatter must include a `tools:` list (even if tool availability is host-dependent).

4) **Policy invariants** (workflow rules)
- Example: “Use relative paths in delegation” and “Plans are prompts” are not optional.

5) **Artifact-graph invariants** (planning folder taxonomy)
- Example: `.planning/research/*` exists; per-phase folder structure is expected.

### File target: baseline manifest

Create this as part of Phase 1 execution:

- **Target:** `.planning/baseline/P0_INVARIANTS.yaml`
- **Purpose:** canonical, checkable list of invariants (machine-ish format; human readable)

Suggested schema (illustrative):

```yaml
version: 1
baseline: P0
scope:
  repo: JP Dynamic Agent System (v2)
  includes:
    - .github/agents
    - .planning (taxonomy only)

invariants:
  - id: P0-AGENTS-EXIST
    kind: file_exists
    paths:
      - .github/agents/orchestrator.agent.md
      - .github/agents/researcher.agent.md
      - .github/agents/planner.agent.md
      - .github/agents/coder.agent.md
      - .github/agents/designer.agent.md
      - .github/agents/verifier.agent.md
      - .github/agents/debugger.agent.md

  - id: P0-ORCH-NO-IMPLEMENT
    kind: file_contains_all
    path: .github/agents/orchestrator.agent.md
    must_contain:
      - "Never implements directly"
      - "You coordinate work but NEVER implement anything yourself."

  - id: P0-RELATIVE-PATHS
    kind: file_contains
    path: .github/agents/orchestrator.agent.md
    must_contain:
      - "always reference paths as relative"

  - id: P0-VERIFIER-EVIDENCE
    kind: file_contains
    path: .github/agents/verifier.agent.md
    must_contain:
      - "Do NOT trust SUMMARY.md claims"

  - id: P0-RESEARCHER-NO-IMPLEMENT
    kind: file_contains
    path: .github/agents/researcher.agent.md
    must_contain:
      - "you never implement"
```

### Why this format works

- It’s **checkable** with basic file viewing and substring search.
- It’s **diff-friendly** in Git.
- It supports a later “automated verifier” without changing the baseline representation.

### Optional strengthening: hashes for “must-not-change” files

If you want a stronger gate than substring anchors, store hashes for a small set of “P0-critical” files:

- **Target:** `.planning/baseline/P0_HASHES.md` (or `.yaml`)
- Record SHA-256 of:
  - `.github/agents/orchestrator.agent.md`
  - `.github/agents/verifier.agent.md`

This is strict (any whitespace change trips the gate), so reserve it for files you truly want frozen.

---

## 2) Verification pattern that works without optional tools (e.g., `memory`)

### Principle: verification must be file-backed, not tool-backed

Treat tool availability as an **environment variable**: it might differ across machines, profiles, or VS Code channels.

So Phase 1 verification should:
- Store results as Markdown evidence under `.planning/`.
- Avoid relying on “memory” persistence for correctness.

This aligns with GitHub Copilot Memory’s own model: memories are validated against citations in the current codebase, and only used if validated (and auto-expire). Even when memory exists, correctness is anchored in **verifiable evidence** rather than assumption. (GitHub docs) https://docs.github.com/en/copilot/concepts/agents/copilot-memory

### File targets (Phase 1 execution)

- **Target:** `.planning/phases/1/VERIFICATION.md`
  - Contains a checklist of success criteria + evidence links (paths and excerpts).

- **Target:** `.planning/baseline/CAPABILITY_PROBE.md`
  - Records what the current host can actually do (edit, execute, MCP tools, etc.).

### Capability probe matrix (docs-only, repeatable)

Record results in a small table:

- Can the environment:
  - read files? (yes/no)
  - edit/create files? (yes/no)
  - run terminal/execute? (yes/no)
  - use MCP/Context7 tools? (yes/no)
  - use `memory` tool? (yes/no)

Outcome categories:
- **Full capability mode:** everything works
- **Reduced capability mode:** proceed docs-only; fall back to web fetches; require more user checkpoints

---

## 3) Tool/settings detection mechanisms for VS Code Insiders

Because repo-local `.vscode/` configuration is absent, detection must be:
1) **observed** in the running host, then
2) **recorded** under `.planning/`.

### Practical detection (human/ops)

Use VS Code CLI documentation as the baseline:
- VS Code Insiders is launched with **`code-insiders`** (not `code`).
- The CLI can print version details via `--version` and list extensions via `--list-extensions`.
- Insiders URL handler prefix is `vscode-insiders://`.

Source: VS Code CLI docs https://code.visualstudio.com/docs/editor/command-line

### Programmatic detection reference (if needed later)

If you ever implement a small “probe” extension (not required in Phase 1), the VS Code API exposes environment info under `vscode.env`, including:
- `vscode.env.appName`
- `vscode.env.appHost`
- `vscode.env.remoteName`

Source: VS Code API `env` namespace https://code.visualstudio.com/api/references/vscode-api#env

### What to record (file target)

- **Target:** `.planning/baseline/HOST_ENVIRONMENT.md`
  - VS Code channel: Stable vs Insiders
  - Version + commit (from CLI `--version`)
  - Profiles in use (if relevant)
  - Installed extensions list and whether `Upstash.context7-mcp` is installed

---

## 4) Context7 MCP verification approach

### What Context7 claims to provide

The Upstash extension claims:
- It registers an MCP server definition provider named **`context7`**.
- It integrates with VS Code’s built-in MCP support, “no additional configuration required”.
- It exposes tool functions including:
  1. `mcp_context7-new_resolve-library-id`
  2. `mcp_context7-new_get-library-docs`

Sources:
- Marketplace listing https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp
- GitHub repo README https://github.com/upstash/context7-vscode-extension

Separately, the VS Code API has MCP types and registration APIs (e.g., `lm.registerMcpServerDefinitionProvider`, `McpStdioServerDefinition`, `McpHttpServerDefinition`), indicating first-class MCP integration at the API layer.

Source: VS Code API docs (see `lm` namespace and MCP types) https://code.visualstudio.com/api/references/vscode-api#env

### Verification steps (record evidence)

Record results in `.planning/baseline/CAPABILITY_PROBE.md`:

1) **Extension presence check**
- Confirm `Upstash.context7-mcp` is installed (Extensions UI or CLI `--list-extensions`).

2) **Tool name check (behavioral)**
- In a chat session, issue a prompt that *should* trigger Context7 (e.g., “use context7”).
- Confirm the tool invocation succeeds and returns docs.

3) **Negative-path check**
- If the tool is missing/unknown, explicitly declare “Reduced-capability mode: no Context7” and adopt the fallback below.

### Fallback approach if Context7 is unavailable

- Use official docs via web fetch (or manual browsing), and cite URLs.
- For library-specific research, prefer:
  1) official docs
  2) official GitHub repo docs / READMEs
  3) reputable community docs

Also add a checkpoint: enabling Context7 is a user environment decision.

---

## 5) Regression check strategy for additive-only changes (P0-preserving)

### Core idea

Phase 1 should be “**additive-only**” in the strongest sense:
- Prefer adding new `.planning/` artifacts.
- Avoid modifying `.github/agents/*.agent.md` during Phase 1 unless absolutely necessary.

### Additive-only gates (practical, checkable)

Define a gate that the Verifier can apply after each phase/task:

1) **Path-based gate**
- Allowed changes (Phase 1):
  - `.planning/**`
- Disallowed (unless a user checkpoint approves):
  - `.github/agents/**`

2) **Diff-shape gate**
- If a file outside `.planning/` changed → require checkpoint.
- If an agent file changed:
  - Must be *strictly additive* (append-only or clearly marked additive sections).
  - Must preserve original intent statements (anchors in `P0_INVARIANTS.yaml`).

3) **Repeatable smoke checks**
Even for docs-only phases, run “smoke checks” as verification rituals:
- Ensure baseline invariants still pass (spot-check critical anchors).
- Ensure ROADMAP/REQUIREMENTS/STATE remain consistent.

### Evidence storage

- Verifier writes evidence in:
  - `.planning/phases/1/VERIFICATION.md`
- Each gate should cite:
  - which files changed
  - why changes are additive
  - which P0 invariants were re-checked

---

## Common pitfalls (Phase 1)

1) **Conflating two “memory” concepts**
- VS Code tool named `memory` (agent toolset) vs GitHub Copilot Memory (repo-scoped, preview).
- Mitigation: treat both as optional; store all critical state in `.planning/`.

2) **Assuming Context7 exists because agent toolsets mention `context7/*`**
- Mitigation: explicitly probe and record tool availability; maintain fallback research approach.

3) **Accidental non-additive edits to agent definitions**
- Mitigation: path-based gate + “must not change” anchors/hashes.

4) **Host capability drift across VS Code profiles**
- CLI supports `--profile` and can isolate user-data-dir; tool availability can change by profile.
- Mitigation: record the active profile and extension list in `HOST_ENVIRONMENT.md`.

---

## Open questions / checkpoints to resolve in Phase 1 execution

1) Should Phase 1 freeze any agent files with hashes, or rely on anchor-snippet invariants only?
2) Which host profile is considered canonical for this repo’s operation (Insiders profile name)?
3) Should we introduce a tiny automated checker script in a later phase, or keep verification manual-only?

---

## Sources

| Source | Type | Confidence | Used for |
|---|---|---|---|
| https://code.visualstudio.com/docs/editor/command-line | Official | HIGH | Insiders CLI name `code-insiders`, version/extension listing, url prefix |
| https://code.visualstudio.com/insiders/ | Official | HIGH | Insiders positioning + side-by-side install |
| https://code.visualstudio.com/api/references/vscode-api#env | Official | HIGH | `vscode.env.*` for channel detection; MCP types/registration in API listings |
| https://marketplace.visualstudio.com/items?itemName=Upstash.context7-mcp | Official marketplace | HIGH | Context7 MCP claims + available functions |
| https://github.com/upstash/context7-vscode-extension | GitHub repo | HIGH | Context7 MCP server registration claims + function names |
| https://docs.github.com/en/copilot/concepts/agents/copilot-memory | Official | HIGH | Memory validation model (citations + expiry) supporting “evidence-first” approach |
