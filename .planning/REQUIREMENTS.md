# Requirements

| ID | Requirement | Phase | Priority |
|---|---|---:|---|
| REQ-001 | Preserve existing P0 flow behavior of the current JP agent lifecycle; no behavior regressions. | 1 | Must-have |
| REQ-002 | All changes must be additive extensions only (no breaking edits); if any existing agent file is updated, changes must be strictly additive and gated. | 1 | Must-have |
| REQ-003 | Produce and maintain durable planning artifacts: `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/STATE.md`, plus per-phase folders for plans/verification as execution proceeds. | 1 | Must-have |
| REQ-004 | Add a controlled, skill-first self-extension mechanism (new skills and only-when-needed new agents) governed by explicit decision rules. | 2 | Must-have |
| REQ-005 | Enforce justification + documentation (Extension Decision Record / equivalent) **before** any new skill or agent is created. | 2 | Must-have |
| REQ-006 | Add a controlled flow to create a new skill and (if justified) a new agent during research/planning/coding; the flow must be repeatable and auditable via `.planning/` artifacts. | 3 | Must-have |
| REQ-007 | Ensure any newly created skill is wired to the correct agent(s) (discoverable + referenced) and validated by verification checks. | 3 | Must-have |
| REQ-008 | Include verification criteria per phase, and include explicit hidden-risk checks (tool availability/settings, Context7 MCP mismatch, memory ambiguity, context bloat, permission boundaries). | 1 | Must-have |
| REQ-009 | Include checkpoints requiring user confirmation when uncertainty exists (e.g., whether a new agent is justified, tool permission expansion, or ambiguous integration points). | 1 | Must-have |
| REQ-010 | Keep subsequent phase plans executable by delegated agents: tasks must have clear file targets, verification steps, and “done” criteria. | 1 | Must-have |
| REQ-011 | Add regression verification gates that continuously prove the P0 flow still works after each additive extension (smoke checks + verifier-driven confirmation). | 1 | Must-have |
| REQ-012 | Document required host prerequisites/settings and non-blocking fallbacks so the workflow doesn’t depend on optional tools (e.g., `memory`) for correctness. | 1 | Must-have |
| REQ-013 | Maintain an auditable registry of approved extensions (skills/agents), including ownership, purpose, wiring targets, and status (active/deprecated). | 2 | Should-have |
| REQ-014 | Prove the controlled extension loop end-to-end with a pilot skill (and optional agent only if justified/approved), including verifier evidence and P0 regression checks. | 4 | Must-have |
