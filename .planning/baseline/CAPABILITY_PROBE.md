# Capability Probe

This document records what the current host environment can actually do. Because tool availability can vary across VS Code installations, profiles, and configurations, we explicitly probe and record capabilities.

## Capability Matrix

| Capability | Expected | Observed | Evidence | Impact | Fallback |
|---|---|---|---|---|---|
| **Read files** | Yes | (To be filled) | (To be filled: successful file read) | Core requirement | None - mandatory |
| **Create/edit files** | Yes | (To be filled) | (To be filled: successful file creation) | Required for plan execution | Reduced-capability mode (docs-only) |
| **Run terminal commands** | Yes | (To be filled) | (To be filled: successful command execution) | Verification, tooling | Manual execution + screenshot evidence |
| **Delegate to subagents** | Yes | (To be filled) | (To be filled: successful runSubagent call) | Core orchestration | Single-agent mode with reduced scope |
| **MCP tools (Context7)** | Optional | (To be filled) | (To be filled: Context7 tool call result) | Enhanced research | Fallback to web docs + manual citation |
| **Memory tool** | Optional | (To be filled) | (To be filled: memory tool call result) | Convenience only | Store all state in `.planning/` |

## Capability Definitions

### Read files
Ability to read workspace files using file read tools.

**Test:**
```
Read any file in the workspace (e.g., .planning/ROADMAP.md)
```

**Expected result:** File contents returned successfully.

### Create/edit files
Ability to create new files and modify existing files using file edit tools.

**Test:**
```
Create a test file in .planning/ or edit an existing file
```

**Expected result:** File created/modified successfully and persists in workspace.

### Run terminal commands
Ability to execute shell commands in a terminal.

**Test:**
```bash
echo "test" && pwd
```

**Expected result:** Command output returned, showing workspace directory.

### Delegate to subagents
Ability to invoke subagents using the runSubagent tool (Orchestrator only).

**Test:**
Delegation call to any configured agent with a simple task.

**Expected result:** Agent responds and completes the task.

### MCP tools (Context7)
Ability to call Context7 MCP tools for documentation retrieval.

**Test:**
Attempt to call a Context7 tool (e.g., resolve a library or get library docs).

**Expected result:** Tool exists and returns documentation.

**If unavailable:** Not a blocker - fallback research approach applies.

### Memory tool
Ability to use the GitHub Copilot Memory tool for persistent notes.

**Test:**
Attempt to call memory tool with view command.

**Expected result:** Tool exists and can read/write memory files.

**If unavailable:** Not a blocker - use `.planning/` artifacts only.

---

## Operating Modes

Based on capability probe results, the system operates in one of these modes:

### Full Capability Mode

**Criteria:**
- ✅ File read/write works
- ✅ Terminal execution works
- ✅ Subagent delegation works (Orchestrator)
- ✅ MCP tools available (Context7)
- ✅ Memory tool available

**Behavior:**
- Execute plans with full autonomy
- Use Context7 for research
- Store evidence in memory and `.planning/`
- Standard checkpoint frequency

### Standard Capability Mode

**Criteria:**
- ✅ File read/write works
- ✅ Terminal execution works
- ✅ Subagent delegation works
- ❌ MCP tools unavailable OR
- ❌ Memory tool unavailable

**Behavior:**
- Execute plans with full autonomy
- Use web docs + manual citation for research
- Store all evidence in `.planning/` only
- Standard checkpoint frequency

### Reduced Capability Mode

**Criteria:**
- ✅ File read works
- ❌ File write disabled OR
- ❌ Terminal execution disabled OR
- ❌ Subagent delegation disabled

**Behavior:**
- **Docs-only mode:** Focus on planning and documentation
- Increased checkpoint frequency
- User must execute code changes manually
- Evidence provided via user-supplied screenshots/output
- Research limited to reading existing docs and web sources

### Read-Only Mode

**Criteria:**
- ✅ File read works
- ❌ All write operations disabled

**Behavior:**
- Analysis and recommendations only
- No artifact creation
- All work products communicated to user for manual execution

---

## Current Environment Assessment

**Mode determined:** (To be filled after probe execution)

**Justification:** (To be filled: explain which capabilities are available/missing)

**Date assessed:** (To be filled)

---

## Probe Execution Record

### When to run this probe

- At Phase 1 start (initial baseline)
- When switching VS Code profiles
- When environment configuration changes
- When encountering unexpected tool failures

### How to execute

1. Attempt to read a file → record result
2. Attempt to create a test file → record result
3. Attempt to run a terminal command → record result
4. (Orchestrator only) Attempt subagent delegation → record result
5. Attempt to call Context7 tool → record result
6. Attempt to call memory tool → record result
7. Update the capability matrix above with observed results
8. Determine operating mode based on results

### Evidence storage

Record evidence inline in the "Evidence" column of the capability matrix above, or reference external evidence files if needed (e.g., screenshots for manual verification).

---

## Decision Checkpoint

If the probe reveals **Reduced Capability Mode** or **Read-Only Mode**, a user checkpoint is required:

**Question:** How should we proceed?

**Options:**
1. **Enable required capabilities** (adjust VS Code settings to enable file edit, terminal execution, etc.)
2. **Proceed in reduced-capability mode** (docs-only, manual execution workflow)
3. **Halt execution** (resolve environment issues before continuing)

**User decision:** (To be filled)

---

**Last probe execution:** (To be filled)
**Probe result:** (To be filled: Full / Standard / Reduced / Read-Only)
