# Agent Team Task Assignments - Nixpkgs Packaging Project

**Project**: AI Native Studio IDE Nixpkgs Packaging
**PRD**: ~/Documents/Projects/ainative-studio/nixpkgs-PRD.md
**Feature Branch**: `feature/nixpkgs-packaging`
**Repository**: ~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE/

This document assigns specific tasks from the PRD to specialized AI agents working collaboratively with ZeroDB memory integration.

---

## Team Structure

| Agent Role | Primary Responsibility | PRD Milestones |
|------------|----------------------|----------------|
| **AI DevOps Agent** | Build infrastructure, caching, GPU variants | M0, M4 |
| **AI Build Agent** | Core derivation, Electron wrapping | M1, M3 |
| **AI QA Agent** | Testing, determinism, VM smoke tests | M2 |
| **AI Compliance Agent** | Linting, formatting, CI integration | M5 |
| **AI Maintainer Agent** | PR preparation, upstream submission | M6 |

---

## M0: Dev Environment Bootstrap & Caching
**Owner**: AI DevOps Agent
**Status**: 🔄 In Progress

### Tasks

#### 0.1: Hash Generation & Prefetch
- [ ] Generate `fetchFromGitHub` source hash for v1.1.0
- [ ] Generate `npmDepsHash` for ainative-studio subdirectory
- [ ] Update `default.nix` with correct hashes
- [ ] Verify no network access during build

**Commands**:
```bash
cd ~/Documents/Projects/ainative-studio/src/AINativeStudio-IDE/nix/pkgs/applications/editors/ainative-studio-ide
nix-prefetch-github AINative-Studio AINativeStudio-IDE --rev v1.1.0
```

**ZeroDB Context**: Store generated hashes and prefetch results for team reference

---

#### 0.2: Nix Development Environment
- [ ] Create `flake.nix` for local development
- [ ] Set up `direnv` integration
- [ ] Configure build caching (cachix or local)
- [ ] Document environment setup in README

**Deliverable**: Working `flake.nix` with development shell

**ZeroDB Context**: Store flake configuration patterns and cachix setup

---

#### 0.3: Binary Cache Setup
- [ ] Configure cachix for build artifacts
- [ ] Set up GitHub Actions cache
- [ ] Document cache usage for CI/CD

**ZeroDB Context**: Cache configuration settings and access tokens

---

## M1: Initial Derivation + Local CPU Build
**Owner**: AI Build Agent
**Status**: 🔄 In Progress

### Tasks

#### 1.1: Core Derivation Implementation
- [ ] Implement `buildNpmPackage` derivation
- [ ] Configure `npmRoot = "ainative-studio"`
- [ ] Set up native build inputs (node-gyp, python3, pkg-config)
- [ ] Configure `NODE_OPTIONS` for 8GB heap
- [ ] Implement build phase with `npm run compile`

**File**: `nix/pkgs/applications/editors/ainative-studio-ide/default.nix`

**ZeroDB Context**: Store build configuration decisions and troubleshooting notes

---

#### 1.2: Install Phase & Directory Structure
- [ ] Install compiled output to `$out/share/ainative-studio-ide/app`
- [ ] Copy resources and assets
- [ ] Create bin wrapper script
- [ ] Install icons to hicolor theme paths

**ZeroDB Context**: Document install phase patterns and file layout

---

#### 1.3: First Build Validation
- [ ] Run initial build: `nix-build -E '...'`
- [ ] Verify output structure
- [ ] Test binary execution
- [ ] Document any build errors/fixes

**Success Criteria**: Local build completes without network access

**ZeroDB Context**: Store build errors and solutions for future debugging

---

## M2: Determinism & VM Test Passing
**Owner**: AI QA Agent
**Status**: ⏳ Pending M1

### Tasks

#### 2.1: Determinism Testing
- [ ] Run double-build test: `nix/tests/determinism-test.sh`
- [ ] Compare output hashes
- [ ] Identify any non-deterministic sources (timestamps, random data)
- [ ] Fix determinism issues

**File**: `nix/tests/determinism-test.sh`

**Success Criteria**: Identical hashes on repeat builds

**ZeroDB Context**: Store determinism issues and fixes

---

#### 2.2: Smoke Test Implementation
- [ ] Enhance `smoke-run.sh` for headless testing
- [ ] Test with Xvfb virtual display
- [ ] Verify application launches and exits cleanly
- [ ] Add timeout handling

**File**: `nix/tests/smoke-run.sh`

**ZeroDB Context**: Store test configuration and edge cases

---

#### 2.3: NixOS VM Test
- [ ] Create `make-test-python.nix` VM test
- [ ] Test application launch in clean VM
- [ ] Verify desktop integration (icons, .desktop file)
- [ ] Test on Wayland and X11

**Deliverable**: VM test passing on Linux

**ZeroDB Context**: VM test patterns and common issues

---

#### 2.4: Platform Testing
- [ ] Test on `x86_64-linux`
- [ ] Test on `aarch64-linux` (if available)
- [ ] Test on `x86_64-darwin` (if available)
- [ ] Document platform-specific issues

**ZeroDB Context**: Platform-specific build notes

---

## M3: Electron Wrapping Finalized
**Owner**: AI Build Agent
**Status**: ⏳ Pending M1

### Tasks

#### 3.1: System Electron Integration
- [ ] Add `electron_30` dependency
- [ ] Create wrapper with `makeWrapper`
- [ ] Set `ELECTRON_IS_DEV=0`
- [ ] Test with system electron

**ZeroDB Context**: Electron version compatibility notes

---

#### 3.2: Fallback Node Launcher
- [ ] Implement Node.js launcher for no-electron builds
- [ ] Test fallback mode
- [ ] Document when fallback is used

**ZeroDB Context**: Launcher script patterns

---

#### 3.3: Darwin Compatibility
- [ ] Mark as broken if `electron_30 == null` on Darwin
- [ ] Test on macOS (if available)
- [ ] Document Darwin-specific requirements

**ZeroDB Context**: Darwin build quirks

---

## M4: GPU Variant Isolated
**Owner**: AI DevOps Agent
**Status**: ⏳ Pending M1

### Tasks

#### 4.1: CUDA Support
- [ ] Add `cudaSupport ? false` parameter
- [ ] Add CUDA build inputs conditionally
- [ ] Create `ainative-studio-ide-gpu` variant
- [ ] Test CUDA build locally (requires GPU)

**ZeroDB Context**: CUDA configuration and dependencies

---

#### 4.2: ROCm Support
- [ ] Add `rocmSupport ? false` parameter
- [ ] Add ROCm build inputs conditionally
- [ ] Test ROCm variant (if hardware available)

**ZeroDB Context**: ROCm setup notes

---

#### 4.3: GPU Metadata
- [ ] Mark GPU variants as `broken` appropriately
- [ ] Document GPU requirements
- [ ] Add to `meta.description`

**ZeroDB Context**: GPU variant documentation

---

## M5: CI Compliance, Linting, Docs Complete
**Owner**: AI Compliance Agent
**Status**: ⏳ Pending M2

### Tasks

#### 5.1: Nix Formatting
- [ ] Run `nix fmt` on all `.nix` files
- [ ] Set up `treefmt-nix` configuration
- [ ] Add pre-commit hook for formatting
- [ ] Verify nixpkgs style compliance

**Tools**: `nixpkgs-fmt`, `alejandra`, or `treefmt-nix`

**ZeroDB Context**: Formatting standards and tools

---

#### 5.2: Linting & Static Analysis
- [ ] Run `deadnix` (detect dead Nix code)
- [ ] Run `statix` (detect anti-patterns)
- [ ] Run `nixpkgs-lint` (metadata validation)
- [ ] Fix all lint issues

**ZeroDB Context**: Common lint errors and fixes

---

#### 5.3: Metadata Completeness
- [ ] Verify all `meta` fields present
- [ ] Validate SPDX license identifier
- [ ] Check maintainer handles exist
- [ ] Validate changelog URL
- [ ] Set correct `mainProgram`

**ZeroDB Context**: Metadata requirements checklist

---

#### 5.4: Documentation
- [ ] Complete `README.nix` with build instructions
- [ ] Document update procedure
- [ ] Add troubleshooting section
- [ ] Include examples for all build variants

**File**: `nix/docs/README.nix`

**ZeroDB Context**: Documentation templates and patterns

---

#### 5.5: Update Script
- [ ] Test `update.sh` script
- [ ] Verify r-ryantm compatibility
- [ ] Add error handling
- [ ] Document manual update process

**File**: `nix/pkgs/applications/editors/ainative-studio-ide/update.sh`

**ZeroDB Context**: Update automation patterns

---

## M6: PR Open → master or staging
**Owner**: AI Maintainer Agent
**Status**: ⏳ Pending M5

### Tasks

#### 6.1: nixpkgs-review
- [ ] Run `nixpkgs-review pr <id>` locally
- [ ] Verify no regressions
- [ ] Check rebuild count for staging decision
- [ ] Document review results

**Decision**: Target `master` if <1000 rebuilds, else `staging`

**ZeroDB Context**: Review process and common issues

---

#### 6.2: PR Preparation
- [ ] Copy files to nixpkgs fork
- [ ] Add to `all-packages.nix`
- [ ] Write comprehensive PR description
- [ ] Follow nixpkgs PR template

**ZeroDB Context**: PR templates and best practices

---

#### 6.3: OfBorg Validation
- [ ] Submit PR to nixpkgs
- [ ] Monitor OfBorg build status
- [ ] Address any CI failures
- [ ] Respond to maintainer feedback

**ZeroDB Context**: OfBorg error patterns

---

#### 6.4: Upstream Merge
- [ ] Address reviewer comments
- [ ] Make requested changes
- [ ] Ensure all CI passes
- [ ] Get approval from maintainer

**Success Criteria**: PR merged to nixpkgs

**ZeroDB Context**: Review feedback and resolutions

---

## M7: Cache Verification (Post-Merge)
**Owner**: OCA Maintainer (Human)
**Status**: ⏳ Pending M6

This milestone involves human verification after upstream merge.

---

## Agent Collaboration Patterns

### Using ZeroDB for Team Memory

Each agent should:

1. **Store learnings** when encountering issues:
   ```
   zerodb_store_memory:
   - content: "npm hash mismatch fixed by regenerating with nix-prefetch-url"
   - role: "build-agent"
   - session_id: "nixpkgs-packaging"
   - metadata: { task: "M1.1", issue: "hash-mismatch" }
   ```

2. **Search past knowledge** before starting tasks:
   ```
   zerodb_search_memory:
   - query: "electron wrapper makeWrapper pattern"
   - limit: 5
   ```

3. **Share context** with other agents:
   ```
   zerodb_store_vector:
   - content: "Successfully built with electron_30 on x86_64-linux"
   - metadata: { milestone: "M3", platform: "linux", agent: "build-agent" }
   ```

### Cross-Agent Dependencies

- **DevOps → Build**: Hashes must be generated before build can start
- **Build → QA**: Working build required before testing
- **QA → Compliance**: Tests must pass before lint/format
- **Compliance → Maintainer**: All checks must pass before PR

### Daily Standup Pattern

Each agent reports:
1. Tasks completed since last update
2. Current task in progress
3. Blockers or dependencies
4. ZeroDB queries run for context

---

## Progress Tracking

Use this checklist for overall project status:

- [ ] M0: Dev environment ready
- [ ] M1: Local CPU build working
- [ ] M2: Tests passing (determinism + smoke)
- [ ] M3: Electron wrapper finalized
- [ ] M4: GPU variant isolated
- [ ] M5: CI/lint/docs complete
- [ ] M6: PR merged to nixpkgs
- [ ] M7: Cache verified

---

## Communication Channels

**Primary Work**: Feature branch `feature/nixpkgs-packaging`
**Documentation**: This file (`nix/AGENT_TASKS.md`)
**Memory/Context**: ZeroDB (session: `nixpkgs-packaging`)
**Human Oversight**: Karsten Wade (quaid)

---

## Getting Started

### For AI DevOps Agent
Start with M0.1 - generate hashes first, this unblocks the build agent.

### For AI Build Agent
Wait for M0.1 completion, then begin M1.1 with the generated hashes.

### For AI QA Agent
Prepare test infrastructure while build is in progress, execute tests when M1 completes.

### For AI Compliance Agent
Review PRD and nixpkgs guidelines, prepare lint configuration.

### For AI Maintainer Agent
Study nixpkgs PR process and OfBorg documentation.

---

**Last Updated**: 2025-10-27
**Project Status**: M0 In Progress
**Next Critical Path**: Generate hashes (M0.1)
