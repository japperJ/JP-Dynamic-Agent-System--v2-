---
phase: 1
plan: 1
type: implement
wave: 1
depends_on: []
files_modified:
  - .planning/REQUIREMENTS.md
  - .planning/ROADMAP.md
  - .planning/STATE.md
  - .planning/baseline/P0_INVARIANTS.yaml
  - .planning/baseline/P0_SMOKE_CHECKS.md
  - .planning/baseline/CHANGE_GATES.md
  - .planning/baseline/HOST_ENVIRONMENT.md
  - .planning/baseline/CAPABILITY_PROBE.md
  - .planning/baseline/TOOL_FALLBACKS.md
  - .planning/baseline/SIZE_GUIDELINES.md
  - .planning/phases/1/VERIFICATION.md
autonomous: true
must_haves:
  observable_truths:
    - ".planning/REQUIREMENTS.md, .planning/ROADMAP.md, and .planning/STATE.md remain accurate and consistent with repo reality."
    - "Baseline P0 workflow invariants are captured in a checkable, diff-friendly format."
    - "A phase verification pattern exists and stores evidence in-repo, without depending on optional tools (e.g., memory, Context7)."
    - "Checkpoint rules exist and are referenced: uncertainty triggers user confirmation rather than guessing."
  artifacts:
    - path: .planning/baseline/P0_INVARIANTS.yaml
      has: ["version", "baseline", "scope", "invariants[]"]
    - path: .planning/baseline/CHANGE_GATES.md
      has: ["Path-based gate", "Diff-shape gate", "Agent-file gate", "Evidence requirements"]
    - path: .planning/baseline/HOST_ENVIRONMENT.md
      has: ["VS Code channel", "VS Code version/commit", "Profile", "Extensions list", "Context7 presence"]
    - path: .planning/baseline/CAPABILITY_PROBE.md
      has: ["Capability matrix", "Results", "Reduced-capability mode definition"]
    - path: .planning/phases/1/VERIFICATION.md
      has: ["Success criteria checklist", "Hidden-risk checks", "Evidence log"]
  key_links:
    - from: .planning/phases/1/VERIFICATION.md
      to: .planning/baseline/P0_INVARIANTS.yaml
      verify: "VERIFICATION.md references invariants file and records spot-check evidence"
    - from: .planning/phases/1/VERIFICATION.md
      to: .planning/baseline/CHANGE_GATES.md
      verify: "VERIFICATION.md includes additive-only gates and how to apply them"
    - from: .planning/STATE.md
      to: .planning/phases/1/VERIFICATION.md
      verify: "STATE checkpoint log references Phase 1 verification + reduced-capability decision"
---

# Phase 1, Plan 1: Baseline planning + risk gates (P0-preserving)

## Objective
Create the **durable Phase 1 baseline**: (1) codify P0 workflow invariants in a checkable format, (2) define additive-only regression gates and a phase verification pattern that stores evidence in-repo, and (3) explicitly probe and document host/tool capabilities (Insiders vs Stable, MCP/Context7, file edit permissions), with fallbacks when optional tools aren’t available.

## Context
- @.planning/phases/1/RESEARCH.md
- @.planning/ROADMAP.md
- @.planning/REQUIREMENTS.md
- @.planning/STATE.md

## Checkpoint rule (applies throughout this plan)
If any step depends on **uncertain host/tool availability** (file edit permission, subagent delegation, terminal execution, Context7/MCP, Copilot memory), the executing agent must:
1) record the uncertainty in `.planning/baseline/CAPABILITY_PROBE.md`, and
2) stop and request a user checkpoint choosing: **Reduced-capability (docs-only)** vs **Enable required capabilities**.

## Tasks

### Task 1: Baseline invariants + repeatable smoke checks
- **type:** auto
- **depends on:** none
- **files to create:**
  - `.planning/baseline/P0_INVARIANTS.yaml`
  - `.planning/baseline/P0_SMOKE_CHECKS.md`
- **files to review/edit (only if incorrect):**
  - `.planning/REQUIREMENTS.md`
  - `.planning/ROADMAP.md`
  - `.planning/STATE.md`
- **action (what to add / structure):**
  1) Create `.planning/baseline/P0_INVARIANTS.yaml` using the schema described in Phase 1 research.
     - Minimum sections:
       - `version`, `baseline: P0`, `scope` (repo name, includes)
       - `invariants:` list with at least:
         - **file existence** invariants for `.github/agents/*.agent.md` (all expected roles)
         - **content anchor** invariants for 3–6 high-signal statements (e.g., orchestrator delegation / never implement directly / relative paths; verifier evidence discipline)
         - **planning taxonomy** invariants (presence of `.planning/` key docs)
     - Each invariant must include: `id`, `kind`, and either `paths` or `path` + `must_contain`.
  2) Create `.planning/baseline/P0_SMOKE_CHECKS.md` as a short, repeatable checklist intended to be rerun after every additive change.
     - Must include:
       - “Invariant spot-check” (reference `P0_INVARIANTS.yaml`)
       - “Change scope check” (only `.planning/**` in Phase 1)
       - “Roadmap/Requirements/State consistency check”
       - “Checkpoint rule reminder”
  3) Review `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/STATE.md` for obvious mismatches with the repo (don’t invent new requirements). Only edit if a factual inconsistency is found.
- **verify (how to confirm completion):**
  - `P0_INVARIANTS.yaml` exists and includes at least:
    - one `file_exists` invariant covering the agent files
    - one `file_contains_all` (or equivalent) anchor invariant for orchestrator/verifier
  - `P0_SMOKE_CHECKS.md` exists and is runnable as a checklist (no TODO-only document).
  - If any of the reviewed planning docs were edited, the edits are limited to correcting factual mismatches and are noted in Phase 1 verification evidence.
- **done (observable result):**
  - There is now a **checkable, diff-friendly** statement of “what must not change” for P0.

### Task 2: Host prerequisites + capability probe (tool-optional discipline)
- **type:** checkpoint:human-verify
- **depends on:** Task 1
- **files to create:**
  - `.planning/baseline/HOST_ENVIRONMENT.md`
  - `.planning/baseline/CAPABILITY_PROBE.md`
  - `.planning/baseline/TOOL_FALLBACKS.md`
- **action (what to add / structure):**
  1) In `HOST_ENVIRONMENT.md`, add a structured capture template with sections:
     - VS Code channel (Stable vs Insiders)
     - Version + commit (from CLI if available)
     - Active profile name / user-data-dir notes (if relevant)
     - Installed extensions list (at minimum: whether `Upstash.context7-mcp` is present)
     - Notes on whether workspace has committed `.vscode/` settings (expected: none)
  2) In `CAPABILITY_PROBE.md`, add:
     - A capability matrix table with rows:
       - read files
       - create/edit files
       - run terminal commands
       - delegate to subagents
       - MCP tools available (Context7)
       - `memory` tool availability
     - For each, include columns: `Expected`, `Observed`, `Evidence`, `Impact`, `Fallback`.
     - Define **Reduced-capability mode**: docs-only, evidence-first, web sources allowed, more frequent checkpoints.
  3) In `TOOL_FALLBACKS.md`, define explicit fallbacks:
     - If Context7 is unavailable → use official docs URLs and record citations
     - If `memory` tool is unavailable → store all durable state in `.planning/` only
     - If terminal execution is unavailable → record “unverified by CLI” and require user-provided values/screenshots
     - If subagent delegation is unavailable → work in single-agent mode; reduce scope and checkpoint
- **verify (how to confirm completion):**
  - The three baseline host/tool documents exist and contain templates + at least one filled “Observed” field for the current environment.
  - Reduced-capability mode is explicitly defined and referenced.
- **done (observable result):**
  - The repo contains durable, **tool-optional** evidence about what the host can do, and how the workflow proceeds when it cannot.

### Task 3: Additive-only change gates + Phase 1 verification pattern (evidence location + checkpoints)
- **type:** auto
- **depends on:** Tasks 1–2
- **files to create:**
  - `.planning/baseline/CHANGE_GATES.md`
  - `.planning/baseline/SIZE_GUIDELINES.md`
  - `.planning/phases/1/VERIFICATION.md`
- **files to edit:**
  - `.planning/STATE.md` (add Phase 1 checkpoint entries/evidence links only)
- **action (what to add / structure):**
  1) In `CHANGE_GATES.md`, define gates that can be applied after each additive extension:
     - **Path-based gate:** Phase 1 changes allowed only under `.planning/**` (anything else requires checkpoint).
     - **Agent-file gate:** if `.github/agents/**` changes, it must be strictly additive and must preserve anchors referenced by `P0_INVARIANTS.yaml`; require user checkpoint.
     - **Diff-shape gate:** if edits are non-additive (rewrite/replace), require checkpoint.
     - **Evidence rule:** verifier records changed-file list + justification + which invariants were rechecked.
  2) In `SIZE_GUIDELINES.md`, add guardrails against context bloat:
     - recommended max sizes for skills/research captures
     - when to split files
     - link to “plans are prompts” constraint (single-session executability)
  3) In `phases/1/VERIFICATION.md`, create the Phase 1 verification checklist that directly maps to ROADMAP Phase 1 success criteria + hidden-risk checks.
     - Must include:
       - Success criteria checklist items (with “Evidence:” bullet under each)
       - Hidden-risk probes (subagent delegation + file edit permissions, Context7 availability, memory optionality)
       - A section “Changed files” referencing a git diff summary (or manual list if git unavailable)
       - A section “Checkpoints taken” linking to entries in `.planning/STATE.md`
  4) Update `.planning/STATE.md` checkpoint log to include explicit Phase 1 decision(s):
     - Reduced-capability mode decision (if needed)
     - (Optional) decision: whether to adopt strict hashes for “must-not-change” files in later phases
- **verify (how to confirm completion):**
  - `VERIFICATION.md` references the baseline files created in Tasks 1–2 (invariants, capability probe, change gates).
  - `CHANGE_GATES.md` clearly states what is allowed/disallowed and what requires a checkpoint.
  - `.planning/STATE.md` has at least one new or updated checkpoint entry referencing Phase 1 evidence.
- **done (observable result):**
  - The project has a repeatable verification pattern with durable evidence, and explicit gates that preserve P0 via additive-only rules.

## Verification (end-to-end)
After completing Tasks 1–3, the executing agent should ensure `.planning/phases/1/VERIFICATION.md` contains:
- Evidence that the three core planning docs still reflect reality (`REQUIREMENTS`, `ROADMAP`, `STATE`).
- Links to the baseline invariants, capability probe, and change gates.
- A filled-out hidden-risk section indicating whether the environment supports delegation/editing/MCP tools, or whether reduced-capability mode was chosen.

## Success Criteria (Phase 1)
This plan is complete when:
1) P0 invariants are captured and checkable (`.planning/baseline/P0_INVARIANTS.yaml`).
2) Host/tool capabilities + fallbacks are documented (`HOST_ENVIRONMENT.md`, `CAPABILITY_PROBE.md`, `TOOL_FALLBACKS.md`).
3) Additive-only gates + verification evidence pattern exist and are referenced (`CHANGE_GATES.md`, `phases/1/VERIFICATION.md`).
4) Checkpoint rules are explicit and linked from verification/state artifacts.
