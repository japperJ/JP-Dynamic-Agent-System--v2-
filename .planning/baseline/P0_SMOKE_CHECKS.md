# P0 Smoke Checks

This checklist should be run after every additive change to ensure P0 workflow behavior is preserved.

## Invariant Spot-Check

**Reference:** `.planning/baseline/P0_INVARIANTS.yaml`

Quick verification of critical invariants:

- [ ] **Agent files exist**: All 7 agent files under `.github/agents/` exist
  ```bash
  ls .github/agents/*.agent.md | wc -l
  # Expected: 7
  ```

- [ ] **Orchestrator delegation contract**: Orchestrator never implements directly
  ```bash
  grep -c "Never implements directly" .github/agents/orchestrator.agent.md
  grep -c "NEVER implement anything yourself" .github/agents/orchestrator.agent.md
  # Both should return > 0
  ```

- [ ] **Verifier independence**: Verifier doesn't trust SUMMARY.md claims
  ```bash
  grep -c "Do NOT trust SUMMARY.md" .github/agents/verifier.agent.md
  # Expected: > 0
  ```

- [ ] **Planning taxonomy exists**: Core planning docs are present
  ```bash
  test -f .planning/REQUIREMENTS.md && test -f .planning/ROADMAP.md && test -f .planning/STATE.md && echo "PASS" || echo "FAIL"
  ```

## Change Scope Check

For Phase 1, verify changes are limited to `.planning/**`:

- [ ] **Path-based gate**: No changes outside `.planning/` directory
  ```bash
  git diff --name-only | grep -v "^\.planning/" | wc -l
  # Expected: 0 (all changes under .planning/)
  ```

- [ ] **Agent files unchanged**: No modifications to `.github/agents/**`
  ```bash
  git diff --name-only .github/agents/ | wc -l
  # Expected: 0 (no agent files modified)
  ```

## Roadmap/Requirements/State Consistency Check

- [ ] **Requirements**: REQ-IDs are unique and properly mapped to phases
  ```bash
  grep "^| REQ-" .planning/REQUIREMENTS.md | cut -d'|' -f2 | sort | uniq -d
  # Expected: no output (no duplicate REQ-IDs)
  ```

- [ ] **Roadmap phase count**: Number of phases in ROADMAP matches STATE progress table
  ```bash
  # Manual check: compare phase count in ROADMAP.md vs STATE.md
  ```

- [ ] **State accuracy**: Current phase status in STATE.md reflects reality
  ```bash
  # Manual verification: Check Phase 1 status matches actual work
  ```

## Checkpoint Rule Reminder

**Critical principle**: When uncertain about:
- Tool availability
- Agent justification
- Integration semantics
- Permission boundaries

**Action required**: STOP and create a user checkpoint rather than guessing.

**Evidence location**: User confirmations logged in `.planning/STATE.md` checkpoint log.

---

## Quick Pass/Fail Assessment

If all checks above pass:
- ✅ **P0 PRESERVED** — Safe to proceed

If any check fails:
- ❌ **P0 VIOLATION** — Investigate and remediate before proceeding

**Last run:** (Record date after each execution)
**Status:** (PASS / FAIL with details)
