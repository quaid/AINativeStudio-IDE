# AI Native Studio IDE - Nixpkgs Packaging Quickstart

**For AI Agents**: This is your entry point to start working on the nixpkgs packaging project.

## Project Overview

**Goal**: Create a reproducible Nix package for AI Native Studio IDE and upstream it to nixpkgs.

**Current Status**: ✅ Infrastructure initialized, ready for M0 (hash generation)

**Branch**: `feature/nixpkgs-packaging`

**PRD Location**: `~/Documents/Projects/ainative-studio/nixpkgs-PRD.md`

---

## Quick Links

| Resource | Location |
|----------|----------|
| **Task Assignments** | `nix/AGENT_TASKS.md` ← START HERE |
| **Coding Rules** | `nix/AGENT_CODING_RULES.md` ← MUST FOLLOW |
| **Product Backlog** | `nix/BACKLOG.md` |
| **ZeroDB Setup** | `nix/STORE_RULES_IN_ZERODB.md` |
| **Derivation** | `nix/pkgs/applications/editors/ainative-studio-ide/default.nix` |
| **Tests** | `nix/tests/` |
| **Documentation** | `nix/docs/README.nix` |
| **PRD** | `~/Documents/Projects/ainative-studio/nixpkgs-PRD.md` |

---

## Agent Team Structure

```
┌─────────────────────────────────────────────────────────────┐
│                     nixpkgs Packaging Team                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  🤖 AI DevOps Agent     → M0, M4 (infra, GPU)               │
│  🤖 AI Build Agent      → M1, M3 (derivation, electron)     │
│  🤖 AI QA Agent         → M2 (tests, determinism)           │
│  🤖 AI Compliance Agent → M5 (lint, format, CI)             │
│  🤖 AI Maintainer Agent → M6 (PR, upstream)                 │
│                                                              │
│  💾 ZeroDB Memory       → Shared knowledge & context        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Getting Started (For Each Agent)

### Step 1: Read Your Assignment
Open `nix/AGENT_TASKS.md` and find your milestone section.

### Step 2: Query ZeroDB for Context
Before starting, search for relevant past knowledge:
```
zerodb_search_memory:
  query: "nixpkgs buildNpmPackage patterns"
  session_id: "nixpkgs-packaging"
  limit: 5
```

### Step 3: Execute Your Tasks
Follow the task checklist in `AGENT_TASKS.md` for your milestone.

### Step 4: Store Your Learnings
After completing tasks or solving issues:
```
zerodb_store_memory:
  content: "Successfully generated npmDepsHash using nix-prefetch-url"
  role: "devops-agent"
  session_id: "nixpkgs-packaging"
  metadata: { milestone: "M0", task: "hash-generation" }
```

---

## Critical Path (Must Be Done in Order)

```
M0.1 (DevOps) → M1.1 (Build) → M2.1 (QA) → M5.1 (Compliance) → M6.1 (Maintainer)
  ↓               ↓              ↓             ↓                  ↓
Hashes         Derivation     Tests        Lint/Format         PR Ready
```

**Current Blocker**: M0.1 - Hash generation needed to unblock build

---

## Next Immediate Actions

### For AI DevOps Agent (Priority 1) 🚨
**Task**: Generate source and npm hashes (M0.1)

```bash
cd ~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE/nix/pkgs/applications/editors/ainative-studio-ide

# Generate source hash
nix-prefetch-github AINative-Studio AINativeStudio-IDE --rev v1.1.0

# Update default.nix with the hash, then generate npm deps hash
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 | grep "got:"
```

Copy the hashes into `default.nix` to unblock the build agent.

**Store in ZeroDB**: Hash values, command patterns, any issues encountered

---

### For AI Build Agent (Blocked, prepare)
**Status**: Waiting for M0.1 hashes

**Preparation**:
1. Review `default.nix` structure
2. Study nixpkgs `buildNpmPackage` examples
3. Prepare for M1.1 tasks

**Query ZeroDB**: Search for Node.js build patterns, Electron wrapping examples

---

### For AI QA Agent (Blocked, prepare)
**Status**: Waiting for M1 build completion

**Preparation**:
1. Review test scripts in `nix/tests/`
2. Set up Xvfb if available for headless testing
3. Study determinism testing approaches

**Query ZeroDB**: Test patterns, common build reproducibility issues

---

### For AI Compliance Agent (Blocked, prepare)
**Status**: Waiting for M2 test passing

**Preparation**:
1. Install lint tools: `deadnix`, `statix`, `nixpkgs-fmt`
2. Review nixpkgs style guide
3. Study `treefmt-nix` configuration

**Query ZeroDB**: Formatting standards, common lint issues

---

### For AI Maintainer Agent (Blocked, prepare)
**Status**: Waiting for M5 compliance

**Preparation**:
1. Study nixpkgs PR process
2. Review OfBorg CI documentation
3. Understand staging vs master decision criteria

**Query ZeroDB**: PR templates, review feedback patterns

---

## Repository Structure

```
~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE/
├── nix/                              ← Nix packaging workspace
│   ├── AGENT_TASKS.md                ← Detailed task assignments
│   ├── QUICKSTART.md                 ← This file
│   ├── pkgs/
│   │   └── applications/editors/ainative-studio-ide/
│   │       ├── default.nix           ← Main derivation
│   │       └── update.sh             ← r-ryantm automation
│   ├── tests/
│   │   ├── smoke-run.sh              ← Headless launch test
│   │   └── determinism-test.sh       ← Reproducibility check
│   └── docs/
│       └── README.nix                ← Build documentation
├── ainative-studio/                  ← Upstream IDE codebase
│   ├── package.json
│   └── src/
└── README.md
```

---

## ZeroDB Integration

All agents have access to shared memory via ZeroDB MCP server.

### Session ID
Use `"nixpkgs-packaging"` for all memory operations related to this project.

### Recommended Memory Structure

**Store**:
- Build commands and their outputs
- Error messages and solutions
- Configuration decisions
- Hash values and prefetch results
- Test results and fixes

**Search**:
- Before starting a task, search for similar past work
- Query for error messages you encounter
- Find patterns from other agents' work

**Example**:
```javascript
// Store a learning
{
  "content": "npmDepsHash must be regenerated whenever package-lock.json changes",
  "role": "build-agent",
  "session_id": "nixpkgs-packaging",
  "metadata": {
    "task": "M1.1",
    "issue_type": "hash-mismatch",
    "severity": "blocking"
  }
}

// Search for context
{
  "query": "electron wrapper makeWrapper pattern",
  "session_id": "nixpkgs-packaging",
  "limit": 3
}
```

---

## Success Metrics

By milestone:
- **M0**: ✅ Hashes generated, dev env working
- **M1**: ✅ Local build succeeds without network
- **M2**: ✅ Determinism test passes, smoke test passes
- **M3**: ✅ Electron wrapping works
- **M4**: ✅ GPU variant builds (optional)
- **M5**: ✅ All lints pass, docs complete
- **M6**: ✅ PR merged to nixpkgs
- **M7**: ✅ Binary cache verified (post-merge)

---

## Getting Help

### Documentation
- **PRD**: Full project requirements and context
- **AGENT_TASKS.md**: Detailed task breakdown
- **README.nix**: Build instructions and troubleshooting

### ZeroDB
- Search for solutions other agents have found
- Store new learnings for team benefit

### Human Escalation
- Critical blockers: Contact quaid (Karsten Wade)
- Architecture decisions: Consult PRD first, then escalate

---

## Current Project Status

**Last Updated**: 2025-10-27
**Feature Branch**: `feature/nixpkgs-packaging`
**Latest Commit**: `3b6f5cec` - feat: Initialize nixpkgs packaging structure

**Next Critical Action**: AI DevOps Agent to generate hashes (M0.1)

**Estimated Timeline**:
- M0-M1: 1-2 days (hash gen + initial build)
- M2-M3: 1-2 days (testing + electron)
- M4: 1 day (GPU variant - optional)
- M5: 1 day (compliance)
- M6: 3-7 days (PR review process)
- M7: Post-merge verification

---

## Quick Commands Reference

```bash
# Navigate to project
cd ~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE

# Check current branch
git branch --show-current

# Build the package
cd nix/pkgs/applications/editors/ainative-studio-ide
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'

# Run tests
cd ~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE/nix/tests
./smoke-run.sh ./result/bin/ainative-studio-ide
./determinism-test.sh

# Format code
nix fmt

# Commit changes
git add .
git commit -m "feat: <description>"
```

---

**Ready to start? Open `nix/AGENT_TASKS.md` and begin with your assigned milestone!**
