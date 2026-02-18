# Host Environment Documentation

This file captures the host VS Code environment configuration for this project. Because no `.vscode/` workspace settings are committed to the repository, host configuration is treated as external state.

## VS Code Channel

- **Channel:** (To be filled: Stable / Insiders)
- **Detection method:** VS Code CLI command name (`code` vs `code-insiders`)
- **URL handler:** (To be filled: `vscode://` vs `vscode-insiders://`)

### How to verify

```bash
# Check which VS Code is in PATH
which code
which code-insiders

# Get version details
code-insiders --version
# or
code --version
```

## Version Information

- **Version:** (To be filled)
- **Commit:** (To be filled)
- **Architecture:** (To be filled)

### Capture command

```bash
code-insiders --version
# Output format:
# <version>
# <commit-hash>
# <architecture>
```

## Active Profile

- **Profile name:** (To be filled: Default / Custom profile name)
- **User data directory:** (To be filled if using custom profile)

### How to verify

Check the active profile in VS Code:
- Open VS Code Settings (Ctrl+,)
- Look for "Profiles" section
- Note the active profile name

Or use CLI:
```bash
code-insiders --profile "<profile-name>"
```

## Installed Extensions

**Key extension presence:**

| Extension | ID | Installed | Version |
|---|---|---|---|
| Context7 MCP | `Upstash.context7-mcp` | (To be filled: Yes/No) | (To be filled) |
| GitHub Copilot | `GitHub.copilot` | (To be filled: Yes/No) | (To be filled) |
| GitHub Copilot Chat | `GitHub.copilot-chat` | (To be filled: Yes/No) | (To be filled) |

### Full extensions list

```bash
code-insiders --list-extensions --show-versions
```

**Recorded output:**
(To be filled: paste extension list)

## Workspace Configuration

- **`.vscode/` directory committed:** No
- **`.vscode/settings.json` present:** No
- **MCP server config committed:** No

**Implication:** Tool availability and MCP server configuration are host-specific, not repository-defined.

## Agent Tool Permissions

VS Code agent tool permissions are controlled by VS Code settings. Check:

Settings → Extensions → GitHub Copilot → Agent Settings

**Settings to verify:**
- `github.copilot.chat.edits.enabled` (file editing)
- `github.copilot.chat.runCommand.enabled` (terminal execution)
- `github.copilot.chat.workspace.enabled` (workspace context)

**Current state:** (To be filled based on actual settings)

## Context7 / MCP Configuration

- **Context7 extension present:** (To be filled: Yes/No)
- **MCP server registration method:** Built-in VS Code MCP support (no manual config needed per extension docs)
- **MCP tools expected:** `mcp_context7-new_resolve-library-id`, `mcp_context7-new_get-library-docs`

### Verification approach

Test Context7 availability by attempting to use it in a chat session, or check extension activation status in VS Code Developer Tools.

## Memory Tool Availability

GitHub Copilot Memory is a preview feature with repository-scoped persistence.

- **Memory tool in agent toolsets:** Listed as available tool
- **Actual availability:** (To be filled: Confirmed/Unconfirmed via tool call)
- **Persistence model:** Validated against citations, 28-day retention

**Source:** [GitHub Copilot Memory docs](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

**Workflow stance:** Memory is treated as **optional**. All critical state must be stored in `.planning/` artifacts.

---

## Capture Checklist

Use this checklist when filling out this document:

- [ ] Determine VS Code channel (Stable/Insiders)
- [ ] Capture version and commit hash
- [ ] Note active profile
- [ ] List installed extensions (at minimum, check for Context7, Copilot)
- [ ] Verify agent tool permissions in settings
- [ ] Test Context7 availability (if installed)
- [ ] Document current state in this file

---

**Last updated:** (To be filled)
**Updated by:** (To be filled: user/agent)
