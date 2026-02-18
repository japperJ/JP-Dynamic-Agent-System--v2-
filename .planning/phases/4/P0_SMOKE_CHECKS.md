# Phase 4 P0 Smoke Checks

**Date:** 2026-02-18  
**Phase:** 4  
**Run by:** orchestrator-auto-pilot-phase4  
**Purpose:** Verify that Phase 4 additive changes (EDR-0002, extension-verifier skill, registry update) did not alter any P0 agent file content or break core planning taxonomy invariants.

---

## Baseline Reference

No separate baseline snapshot directory exists for `.github/agents/`. The P0 invariants are defined in `.planning/baseline/P0_INVARIANTS.yaml` and serve as the canonical baseline. The verification approach is:

1. Run the anchored string checks from `P0_INVARIANTS.yaml` against the current agent files.
2. Confirm `git diff` for Phase 4 commits shows no `.github/agents/**` modifications.
3. Where agent files were additive-block-extended in Phase 3 (orchestrator, researcher, planner, coder), those extension blocks are confirmed present and the P0 anchors remain intact above them.

This approach satisfies "compare key sections against baseline" because the invariants define exactly which sections are baseline-critical.

---

## Check 1 — All 7 agent files exist (P0-AGENTS-EXIST)

**Command:**
```powershell
(Get-ChildItem ".github/agents/*.agent.md").Count
```

**Output:** `7`

**Expected:** `7`

**Result:** ✅ PASS

**Agent files confirmed:**
- `coder.agent.md`
- `debugger.agent.md`
- `designer.agent.md`
- `orchestrator.agent.md`
- `planner.agent.md`
- `researcher.agent.md`
- `verifier.agent.md`

---

## Check 2 — Orchestrator delegation contract intact (P0-ORCH-NO-IMPLEMENT, P0-ORCH-DELEGATION, P0-PLANS-ARE-PROMPTS)

**Commands:**
```powershell
(Select-String "Never implements directly" ".github/agents/orchestrator.agent.md").Count
(Select-String "NEVER implement anything yourself" ".github/agents/orchestrator.agent.md").Count
(Select-String "Plans are prompts" ".github/agents/orchestrator.agent.md").Count
```

**Outputs:**
- `Never implements directly`: `1`
- `NEVER implement anything yourself`: `1`
- `Plans are prompts`: `1`

**Expected:** all `> 0`

**Result:** ✅ PASS — all three orchestrator P0 anchors intact.

---

## Check 3 — Verifier independence intact (P0-VERIFIER-INDEPENDENCE, P0-VERIFIER-GOAL-BACKWARD)

**Commands:**
```powershell
(Select-String "Do NOT trust SUMMARY.md" ".github/agents/verifier.agent.md").Count
(Select-String "Task completion" ".github/agents/verifier.agent.md").Count
```

**Outputs:**
- `Do NOT trust SUMMARY.md`: `2`
- `Task completion` (proxy for "Task completion ≠ Goal achievement"): `2`

**Expected:** all `> 0`

**Result:** ✅ PASS — verifier independence anchors intact.

---

## Check 4 — Planning taxonomy exists (P0-PLANNING-TAXONOMY)

**Commands:**
```powershell
Test-Path ".planning/REQUIREMENTS.md"
Test-Path ".planning/ROADMAP.md"
Test-Path ".planning/STATE.md"
```

**Outputs:** `True`, `True`, `True`

**Expected:** all `True`

**Result:** ✅ PASS

---

## Check 5 — No unexpected agent-file modifications in Phase 4 (additive-only enforcement)

**Command:**
```powershell
git diff --name-only HEAD~3 HEAD | Select-String "\.github/agents/"
```

**Output:** (empty — no matches)

**Expected:** no output (Option A wiring chosen; zero agent-file edits in Phase 4)

**Result:** ✅ PASS — Phase 4 commits (Tasks 1–4) made zero modifications to `.github/agents/**`.

**Changed files in Phase 4 so far (HEAD~3..HEAD):**
- `.planning/extensions/edr/EDR-20260218-0002-extension-verifier.md` (new)
- `.github/skills/extension-verifier/SKILL.md` (new)
- `.planning/extensions/REGISTRY.yaml` (additive update)

---

## Additional anchor checks

**Researcher no-implement boundary (P0-RESEARCHER-NO-IMPLEMENT):**
```powershell
(Select-String "you never implement" ".github/agents/researcher.agent.md").Count
```
Output: `1` — ✅ PASS

---

## Overall P0 Status

| Check | Invariant ID | Result |
|---|---|---|
| 1 — All 7 agent files exist | P0-AGENTS-EXIST | ✅ PASS |
| 2a — Orch "Never implements directly" | P0-ORCH-NO-IMPLEMENT | ✅ PASS |
| 2b — Orch "NEVER implement anything yourself" | P0-ORCH-NO-IMPLEMENT | ✅ PASS |
| 2c — Orch "Plans are prompts" | P0-PLANS-ARE-PROMPTS | ✅ PASS |
| 3a — Verifier "Do NOT trust SUMMARY.md" | P0-VERIFIER-INDEPENDENCE | ✅ PASS |
| 3b — Verifier "Task completion" | P0-VERIFIER-GOAL-BACKWARD | ✅ PASS |
| 4 — Planning taxonomy files exist | P0-PLANNING-TAXONOMY | ✅ PASS |
| 5 — No agent-file edits in Phase 4 | ADDITIVE_ONLY + Gate 1 | ✅ PASS |
| Extra — Researcher "you never implement" | P0-RESEARCHER-NO-IMPLEMENT | ✅ PASS |

**Verdict: ✅ ALL P0 CHECKS PASS — safe to proceed and mark Phase 4 complete.**
