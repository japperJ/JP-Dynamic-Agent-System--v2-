# Size Guidelines

This document provides size and structure guidelines to prevent context bloat and maintain maintainability of planning artifacts and skills.

## Core Principle

**Plans are prompts.** Every artifact in `.planning/` must be consumable by an agent in a single session without hitting context limits or requiring excessive summarization.

---

## File Size Limits (Recommendations)

| File Type | Max Lines | Max Tokens* | Rationale |
|---|---|---|---|
| **PLAN.md** | 500 | ~2000 | Must fit in prompt with context |
| **RESEARCH.md** | 1000 | ~4000 | Research findings, sources |
| **SUMMARY.md** | 300 | ~1200 | Concise phase summary |
| **VERIFICATION.md** | 500 | ~2000 | Evidence + results |
| **Skill file** | 400 | ~1600 | Focused domain knowledge |
| **Agent instructions** | 800 | ~3200 | Complete role definition |
| **Requirements doc** | 300 | ~1200 | Requirement table + context |
| **Roadmap doc** | 600 | ~2400 | Phase breakdown + success criteria |

\* Approximate: 1 line ≈ 4 tokens average for technical content

**Context budget assumption:** ~32K tokens total, with ~10-15K available for planning artifacts after system instructions, conversation history, and file context.

---

## When to Split Files

### Horizontal splitting (by phase/module)

**When a single file exceeds limits, split by:**
1. **Phase** — `.planning/phases/1/RESEARCH.md`, `.planning/phases/2/RESEARCH.md`
2. **Domain** — `.planning/research/STACK.md`, `.planning/research/ARCHITECTURE.md`
3. **Concern** — `.planning/baseline/P0_INVARIANTS.yaml`, `.planning/baseline/CHANGE_GATES.md`

### Vertical splitting (by detail level)

**Use summary + detail pattern:**
- **Summary file:** High-level overview, decisions, links to details
- **Detail files:** Deep-dive content, organized by subtopic

**Example:**
```
.planning/research/
  SUMMARY.md          (300 lines - executive summary + stack decisions)
  STACK.md            (400 lines - detailed stack analysis)
  ARCHITECTURE.md     (500 lines - architecture patterns deep-dive)
  FEATURES.md         (600 lines - feature research)
  PITFALLS.md         (400 lines - known pitfalls)
```

---

## Structure Guidelines

### Frontmatter (YAML)

Every plan file should include frontmatter with:
- Metadata (phase, plan number, type)
- Dependencies
- Files modified
- Must-haves (observable truths, artifacts, key links)

**Frontmatter size:** Keep under 100 lines

### Markdown sections

1. **Headers:** Use consistent hierarchy (h1 for title, h2 for major sections, h3 for subsections)
2. **Lists:** Prefer bulleted/numbered lists over prose for scannability
3. **Tables:** Use for structured data (requirements, file lists, gate results)
4. **Code blocks:** Include language tags for syntax highlighting

### Link density

**Internal links:** Reference other planning docs by relative path
- ✅ `See .planning/research/SUMMARY.md for stack decisions`
- ❌ Long inline quotes from other docs (link instead)

**External links:** Use inline for web sources, collect at bottom for long lists

---

## Skill File Guidelines

Skills are specialized domain knowledge files, typically stored in a `skills/` directory or referenced via frontmatter.

### Skill file structure

```markdown
---
name: [Skill Name]
domain: [Domain/Technology]
purpose: [One-line purpose]
version: 1
---

# [Skill Name]

## When to Use
[Trigger conditions for applying this skill]

## Core Concepts
[Key knowledge, patterns, constraints]

## Common Patterns
[Reusable patterns with examples]

## Pitfalls
[What to avoid]

## Sources
[Citations]
```

### Skill size limits

- **Target:** 200-400 lines
- **Maximum:** 500 lines
- **If larger:** Split into sub-skills or extract reference material

### Skill focus

Each skill should cover **one domain or one cross-cutting concern**:
- ✅ "Next.js App Router patterns"
- ✅ "PostgreSQL schema design best practices"
- ❌ "Full-stack web development" (too broad, split into multiple skills)

---

## Research Capture Guidelines

### Research file types

1. **Project-level research** (`.planning/research/`):
   - SUMMARY.md (consolidated overview)
   - STACK.md (technology choices)
   - ARCHITECTURE.md (architecture patterns)
   - FEATURES.md (feature analysis)
   - PITFALLS.md (known pitfalls)

2. **Phase-level research** (`.planning/phases/<N>/RESEARCH.md`):
   - Implementation-specific research for that phase
   - Focused on "how to build" not "what to build"

### Research conciseness

**Prefer:**
- Key findings with citations
- Decision rationale (why we chose X over Y)
- Critical constraints and non-negotiables
- Links to full docs (not full doc reproduction)

**Avoid:**
- Copying entire articles
- Restating well-known information
- Over-documenting stable, widely-known technologies

### Source citation format

```markdown
| Source | Type | Confidence | Used for |
|---|---|---|---|
| https://nextjs.org/docs | Official | HIGH | App Router patterns |
| https://github.com/user/repo | Community | MEDIUM | Example implementation |
```

---

## Plan File Guidelines

Plans (`.planning/phases/<N>/PLAN.md`) are executable task lists.

### Plan structure

1. **Frontmatter** (metadata, dependencies, must-haves)
2. **Objective** (1-2 sentences)
3. **Context** (links to relevant research/docs)
4. **Tasks** (structured task list)
5. **Verification** (end-to-end verification criteria)
6. **Success Criteria** (observable outcomes)

### Task structure

Each task:
- **type:** auto | checkpoint:human-verify | checkpoint:decision
- **depends on:** task numbers or "none"
- **files to create/edit:** explicit paths
- **action:** what to do (structure, content to add)
- **verify:** how to confirm completion (bash commands, checks)
- **done:** observable result statement

### Task size

- **Target:** 5-10 tasks per plan
- **Maximum:** 15 tasks
- **If more:** Split into multiple plans or waves

---

## Context Management Strategies

### 1. Lazy loading

Don't load all planning docs at once. Load only what's needed:
- Current phase plan
- Immediately relevant research
- Referenced docs (via @-syntax or explicit reads)

### 2. Progressive summarization

As the project grows:
- Phase summaries become more concise
- Research summaries focus on decisions, not details
- Evidence logs reference ranges instead of full output

### 3. Archival strategy

After phase completion and verification:
- Phase directory remains (evidence preservation)
- Optional: Create `.planning/archive/` for older, less-relevant phases
- Keep recent 2-3 phases in main context, archive older

---

## Warning Signs of Bloat

| Symptom | Cause | Remedy |
|---|---|---|
| Plan files > 500 lines | Too much detail in tasks | Extract detail to research or separate docs |
| Research > 1000 lines | Over-documentation | Summarize and link to sources instead of reproducing |
| Verification logs > 500 lines | Full command output included | Summarize results, note "full output available" |
| Context limit warnings | Too many files loaded | Lazy load, reference instead of inline |
| Agent "lost the thread" | Too much noise in planning docs | Simplify, use consistent structure |

---

## Splitting Decision Tree

```
File approaching size limit?
    ↓
Is it frontmatter-heavy?
    ↓ Yes → Extract metadata to separate registry file
    ↓ No
    ↓
Multiple distinct domains?
    ↓ Yes → Split by domain (horizontal)
    ↓ No
    ↓
Can be summarized?
    ↓ Yes → Create summary file + detail files (vertical)
    ↓ No
    ↓
Consider if all content is necessary
    ↓ Yes → Keep as-is but flag for review
    ↓ No → Trim, link to sources
```

---

## Quality Checklist

Before committing a new planning artifact:

- [ ] **File size** within recommended limits?
- [ ] **Structure** follows guidelines (frontmatter, sections, links)?
- [ ] **Citations** present for external knowledge sources?
- [ ] **Readable** in one sitting (single-session consumable)?
- [ ] **Focused** on one phase/domain/concern?
- [ ] **Links** work and reference correct relative paths?

---

**Last updated:** 2026-02-18
