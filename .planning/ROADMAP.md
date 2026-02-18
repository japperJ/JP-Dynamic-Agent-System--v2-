# Roadmap — JP Dynamic Agent System (v2)

This roadmap builds a **controlled self-extending** JP agent system while preserving existing behavior. The guiding rule is **skill-first**, with **agents added only when a distinct role/tool boundary is justified and approved**.

Context sources (already captured):
- `.planning/research/SUMMARY.md`
- `.planning/research/ARCHITECTURE.md`
- `.planning/research/FEATURES.md`
- `.planning/research/PITFALLS.md`
- `.planning/research/STACK.md`

**Global constraints (apply to all phases):**
- Preserve P0 behavior and keep all changes additive. (Mapped as requirements in Phase 1 for traceability, but enforced throughout.)
- If uncertainty exists (tooling, wiring semantics, agent justification), pause for a user checkpoint rather than guessing.

## Phase 1: Baseline planning + risk gates (P0-preserving)

**Goal:** Establish durable planning artifacts and a baseline of “what must not change,” plus explicit verification and hidden-risk checks.

**Requirements:** REQ-001, REQ-002, REQ-003, REQ-008, REQ-009, REQ-010, REQ-011, REQ-012

**Success Criteria (observable truths):**
1. `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, and `.planning/STATE.md` exist and reflect the current repo reality.
2. The baseline P0 workflow is documented as invariants (“what must remain true”) so later changes can be verified against it.
3. A phase-level verification pattern is defined (who verifies what, where results are stored), without requiring optional tools.
4. Checkpoint rules exist and are referenced: when uncertainty exists, the system pauses for user confirmation rather than guessing.

**Hidden-risk checks:**
- Confirm that subagent delegation and file-edit tool permissions are actually enabled in the host VS Code environment (settings can silently disable capabilities).
- Confirm Context7 MCP tool availability and naming; if missing, define a fallback research approach.
- Explicitly treat `memory` as optional: workflow correctness must not depend on it.
- Guard against context bloat: define size/structure guidelines for skills and research captures.

**Depends on:** None

**User-confirmation checkpoints:**
- If environment/tool availability is ambiguous, require user confirmation on whether to proceed in “reduced capability mode” (docs-only) or to enable required settings.

---

## Phase 2: Governance for controlled self-extension (skill-first)

**Goal:** Define and scaffold the governance artifacts that must exist before anything new (skill/agent) is created.

**Requirements:** REQ-004, REQ-005, REQ-013

**Success Criteria (observable truths):**
1. A mandatory, lightweight “Extension Decision Record” (EDR) template exists that captures: problem, why existing agents/skills can’t solve it, proposal, risks, verification plan, and wiring target(s).
2. An extensions registry exists listing approved skills/agents with: purpose, owner, scope, wiring target agents, and status.
3. A clear decision rule is documented and testable:
   - If the gap is knowledge/documentation → create a skill.
   - If the gap is a distinct tool boundary / role contract → consider a new agent.
4. A wiring contract is defined so “skill exists” is not enough: it must be discoverable and referenced by the correct agent(s).

**Hidden-risk checks:**
- Ensure governance does not widen tool permissions by default.
- Ensure the process does not require editing existing agent behavior unless explicitly triggered.

**Depends on:** Phase 1

**User-confirmation checkpoints:**
- If the governance mechanism would require altering existing agent instructions beyond additive sections, require user confirmation.

---

## Phase 3: Additive integration of the controlled extension flow

**Goal:** Wire the extension governance into the actual agent workflow so creating a skill/agent becomes a controlled, auditable flow.

**Requirements:** REQ-006, REQ-007

**Success Criteria (observable truths):**
1. The system blocks “create new skill/agent” actions unless an approved EDR exists and is referenced in the change.
2. Any created skill is wired to the correct agent(s) (explicit references and/or discovery mechanism) and the verifier has checks to confirm wiring.
3. Existing P0 flow remains unchanged when the extension flow is not invoked.
4. Verification gates exist to prove:
   - No unintended behavioral regressions.
   - Extension additions are additive and scoped.

**Hidden-risk checks:**
- Confirm that any updates to `.github/agents/*.agent.md` are strictly additive and do not alter normal routing.
- Confirm permissions: adding an agent must not expand tool capabilities without explicit review.

**Depends on:** Phase 2

**User-confirmation checkpoints:**
- If a new agent is proposed, require user confirmation on the justification (role boundary/toolset) before creation.
- If wiring semantics are unclear (how skills are discovered/loaded in this repo), require user confirmation on the chosen mechanism.

---

## Phase 4: Pilot extension + hardening (prove the loop)

**Goal:** Execute the controlled extension loop end-to-end with a real example skill (and optional agent), then harden verification and documentation.

**Requirements:** REQ-014

**Success Criteria (observable truths):**
1. At least one example skill is created via the governance flow (EDR → creation → wiring → verification), and its purpose is demonstrably accessible to the intended agent(s).
2. If an agent is created, it is justified (distinct boundary), documented, registered, wired, and verified without regressing P0.
3. A verifier-run checklist (or equivalent) confirms:
   - EDR exists and matches implementation.
   - Registry updated.
   - Wiring present.
   - P0 flow smoke checks pass.

**Hidden-risk checks:**
- Run “tool availability” checks in the actual environment and record results.
- Confirm that the extension mechanism remains auditable in Git history and `.planning/` artifacts.

**Depends on:** Phase 3

**User-confirmation checkpoints:**
- Before creating any new agent (not skill), require explicit user approval.

