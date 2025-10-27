# Product Backlog - AI Native Studio IDE Nixpkgs Packaging

**Project**: AI Native Studio IDE Nixpkgs Package
**Product Owner**: Karsten Wade (quaid)
**Scrum Master**: AI Project Coordinator
**Team**: 5 AI Agents (DevOps, Build, QA, Compliance, Maintainer)

**Sprint Duration**: 3 days
**Total Sprints**: 4-5 estimated

---

## Epic 1: Reproducible Nix Derivation

### User Story 1.1: Source Hash Generation
**As a** nixpkgs maintainer
**I want** deterministic source hashing from GitHub releases
**So that** builds are reproducible and verifiable

**Acceptance Criteria**:
- [ ] `fetchFromGitHub` hash correctly prefetches v1.1.0
- [ ] Hash validation passes in sandbox mode
- [ ] No network access during build phase

**Story Points**: 2
**Priority**: CRITICAL (blocks all)
**Milestone**: M0
**Assignee**: AI DevOps Agent

---

### User Story 1.2: NPM Dependencies Hash
**As a** Nix package builder
**I want** locked npm dependencies via hash
**So that** JavaScript dependencies are hermetic

**Acceptance Criteria**:
- [ ] `npmDepsHash` generated from ainative-studio/package-lock.json
- [ ] Hash includes all transitive dependencies
- [ ] Offline build succeeds with cached deps

**Story Points**: 3
**Priority**: CRITICAL (blocks build)
**Milestone**: M0
**Assignee**: AI DevOps Agent

---

### User Story 1.3: Core Derivation Build
**As a** Nix user
**I want** to build AI Native Studio IDE from source
**So that** I can install it on my NixOS system

**Acceptance Criteria**:
- [ ] `nix-build` succeeds on x86_64-linux
- [ ] Output binary launches without errors
- [ ] All native modules (node-gyp) compile hermetically
- [ ] No impure environment variables leak

**Story Points**: 8
**Priority**: HIGH
**Milestone**: M1
**Assignee**: AI Build Agent

---

## Epic 2: Desktop Integration

### User Story 2.1: Desktop Entry
**As a** desktop user
**I want** AI Native Studio IDE in my application launcher
**So that** I can start it like any other app

**Acceptance Criteria**:
- [ ] `.desktop` file installed to standard XDG path
- [ ] Entry appears in GNOME/KDE application menus
- [ ] Correct categories assigned (Development, IDE, AI)
- [ ] MIME types properly associated

**Story Points**: 3
**Priority**: MEDIUM
**Milestone**: M1
**Assignee**: AI Build Agent

---

### User Story 2.2: Icon Installation
**As a** desktop user
**I want** AI Native Studio IDE to have proper icons
**So that** it's visually identifiable in my system

**Acceptance Criteria**:
- [ ] Icons installed to hicolor theme (48x48, 256x256, etc.)
- [ ] Icon cache updated post-install
- [ ] SVG and PNG formats both supported
- [ ] Icons visible in app launcher and window manager

**Story Points**: 2
**Priority**: MEDIUM
**Milestone**: M1
**Assignee**: AI Build Agent

---

## Epic 3: Cross-Platform Support

### User Story 3.1: Electron System Integration
**As a** nixpkgs packager
**I want** to use system Electron instead of bundled
**So that** security updates are centralized

**Acceptance Criteria**:
- [ ] Package uses nixpkgs `electron_30`
- [ ] Wrapper script correctly launches app with system Electron
- [ ] `ELECTRON_IS_DEV=0` set for production mode
- [ ] App functionality identical to bundled Electron

**Story Points**: 5
**Priority**: HIGH
**Milestone**: M3
**Assignee**: AI Build Agent

---

### User Story 3.2: Darwin (macOS) Support
**As a** macOS user
**I want** AI Native Studio IDE via nix-darwin
**So that** I can use Nix on my Mac

**Acceptance Criteria**:
- [ ] Build succeeds on x86_64-darwin
- [ ] Build succeeds on aarch64-darwin (Apple Silicon)
- [ ] Darwin-specific code paths tested
- [ ] Package marked `broken` if Electron unavailable on Darwin

**Story Points**: 5
**Priority**: MEDIUM
**Milestone**: M3
**Assignee**: AI Build Agent

---

### User Story 3.3: Linux ARM64 Support
**As an** ARM server/desktop user
**I want** AI Native Studio IDE on aarch64
**So that** I can develop on ARM platforms

**Acceptance Criteria**:
- [ ] Build succeeds on aarch64-linux
- [ ] Native modules compile for ARM64
- [ ] Performance acceptable on ARM hardware
- [ ] Hydra CI builds ARM64 variant

**Story Points**: 5
**Priority**: LOW
**Milestone**: M3
**Assignee**: AI Build Agent

---

## Epic 4: Testing & Quality Assurance

### User Story 4.1: Build Determinism
**As a** nixpkgs reviewer
**I want** bit-for-bit reproducible builds
**So that** binaries can be verified independently

**Acceptance Criteria**:
- [ ] Two successive builds produce identical hashes
- [ ] No timestamps embedded in output
- [ ] No random data in artifacts
- [ ] `determinism-test.sh` passes

**Story Points**: 5
**Priority**: HIGH
**Milestone**: M2
**Assignee**: AI QA Agent

---

### User Story 4.2: Smoke Testing
**As a** package maintainer
**I want** automated launch tests
**So that** I know the app actually runs

**Acceptance Criteria**:
- [ ] Headless launch via Xvfb succeeds
- [ ] App starts within 10 second timeout
- [ ] App exits cleanly without crash
- [ ] `smoke-run.sh` passes on CI

**Story Points**: 3
**Priority**: HIGH
**Milestone**: M2
**Assignee**: AI QA Agent

---

### User Story 4.3: NixOS VM Integration Test
**As a** NixOS module user
**I want** VM-based integration tests
**So that** the package works in real NixOS environments

**Acceptance Criteria**:
- [ ] `make-test-python.nix` test implemented
- [ ] VM boots with package installed
- [ ] Desktop entry functional in VM
- [ ] Test runs in Hydra CI

**Story Points**: 8
**Priority**: MEDIUM
**Milestone**: M2
**Assignee**: AI QA Agent

---

## Epic 5: CI/CD & Automation

### User Story 5.1: Code Formatting
**As a** nixpkgs contributor
**I want** properly formatted Nix code
**So that** my PR meets community standards

**Acceptance Criteria**:
- [ ] `nix fmt` passes on all `.nix` files
- [ ] `treefmt-nix` configuration working
- [ ] Formatting enforced in pre-commit hook
- [ ] Style matches nixpkgs conventions

**Story Points**: 2
**Priority**: HIGH
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

### User Story 5.2: Static Analysis
**As a** code reviewer
**I want** automated lint checks
**So that** anti-patterns are caught early

**Acceptance Criteria**:
- [ ] `deadnix` finds no dead code
- [ ] `statix` finds no anti-patterns
- [ ] `nixpkgs-lint` passes
- [ ] All issues fixed or documented

**Story Points**: 3
**Priority**: MEDIUM
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

### User Story 5.3: Metadata Completeness
**As a** nixpkgs maintainer
**I want** complete package metadata
**So that** users know what they're installing

**Acceptance Criteria**:
- [ ] `description` clearly explains the package
- [ ] `longDescription` provides details
- [ ] `homepage` URL valid
- [ ] `changelog` links to GitHub releases
- [ ] `license` uses correct SPDX identifier
- [ ] `maintainers` list includes quaid, albertolopez, urbantech
- [ ] `platforms` accurately reflects supported systems
- [ ] `mainProgram` set correctly

**Story Points**: 2
**Priority**: MEDIUM
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

### User Story 5.4: Automated Updates (r-ryantm)
**As a** package maintainer
**I want** automatic version updates
**So that** the package stays current with upstream

**Acceptance Criteria**:
- [ ] `update.sh` script functional
- [ ] Script fetches latest GitHub release
- [ ] Script updates version and hashes
- [ ] r-ryantm bot can parse and execute script
- [ ] `passthru.updateScript` set correctly

**Story Points**: 3
**Priority**: MEDIUM
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

## Epic 6: GPU Support (Optional)

### User Story 6.1: CUDA Acceleration
**As a** NVIDIA GPU user
**I want** GPU-accelerated AI features
**So that** I can use hardware acceleration

**Acceptance Criteria**:
- [ ] `cudaSupport ? false` parameter works
- [ ] CUDA dependencies only included when enabled
- [ ] Package builds with `cudaSupport = true`
- [ ] GPU features functional in CUDA build

**Story Points**: 5
**Priority**: LOW
**Milestone**: M4
**Assignee**: AI DevOps Agent

---

### User Story 6.2: ROCm Acceleration
**As an** AMD GPU user
**I want** ROCm-accelerated AI features
**So that** I can use my AMD hardware

**Acceptance Criteria**:
- [ ] `rocmSupport ? false` parameter works
- [ ] ROCm dependencies only included when enabled
- [ ] Package builds with `rocmSupport = true`
- [ ] GPU features functional in ROCm build

**Story Points**: 5
**Priority**: LOW
**Milestone**: M4
**Assignee**: AI DevOps Agent

---

## Epic 7: Documentation

### User Story 7.1: Build Instructions
**As a** developer
**I want** clear build instructions
**So that** I can build the package locally

**Acceptance Criteria**:
- [ ] `README.nix` includes step-by-step build guide
- [ ] Hash generation process documented
- [ ] Common errors and solutions listed
- [ ] Platform-specific notes included

**Story Points**: 3
**Priority**: MEDIUM
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

### User Story 7.2: Maintainer Guide
**As a** package maintainer
**I want** maintenance procedures documented
**So that** I can update and maintain the package

**Acceptance Criteria**:
- [ ] Update process documented
- [ ] Testing procedures outlined
- [ ] Troubleshooting guide provided
- [ ] Contact information current

**Story Points**: 2
**Priority**: MEDIUM
**Milestone**: M5
**Assignee**: AI Compliance Agent

---

## Epic 8: Upstream Contribution

### User Story 8.1: nixpkgs-review Validation
**As a** PR submitter
**I want** to validate my changes locally
**So that** reviewers don't find issues

**Acceptance Criteria**:
- [ ] `nixpkgs-review pr` runs successfully
- [ ] No rebuild regressions detected
- [ ] All platforms build cleanly
- [ ] Rebuild count <1000 (or staging targeted)

**Story Points**: 3
**Priority**: HIGH
**Milestone**: M6
**Assignee**: AI Maintainer Agent

---

### User Story 8.2: Pull Request Submission
**As a** nixpkgs contributor
**I want** to submit a well-formed PR
**So that** it gets reviewed and merged quickly

**Acceptance Criteria**:
- [ ] PR targets correct branch (master or staging)
- [ ] PR title follows convention: "ainative-studio-ide: init at 1.1.0"
- [ ] PR description complete and clear
- [ ] Commits properly formatted
- [ ] All CI checks passing

**Story Points**: 5
**Priority**: HIGH
**Milestone**: M6
**Assignee**: AI Maintainer Agent

---

### User Story 8.3: Review Response
**As a** PR author
**I want** to address reviewer feedback professionally
**So that** my PR gets approved

**Acceptance Criteria**:
- [ ] All reviewer comments addressed
- [ ] Requested changes implemented
- [ ] Follow-up commits clean and logical
- [ ] Communication respectful and clear

**Story Points**: 5
**Priority**: HIGH
**Milestone**: M6
**Assignee**: AI Maintainer Agent

---

### User Story 8.4: OfBorg CI Success
**As a** nixpkgs contributor
**I want** OfBorg builds to pass
**So that** maintainers can merge my PR

**Acceptance Criteria**:
- [ ] All OfBorg platform builds succeed
- [ ] No evaluation errors
- [ ] Test suite passes
- [ ] Meta checks validate

**Story Points**: 3
**Priority**: HIGH
**Milestone**: M6
**Assignee**: AI Maintainer Agent

---

## Backlog Prioritization

### Sprint 0: Infrastructure (1 day)
- [x] Feature branch created
- [x] Nix directory structure initialized
- [x] Test scripts created
- [x] Documentation skeleton
- [ ] Push to GitHub

### Sprint 1: Foundation (3 days)
**Goal**: Working local build

| Story | Points | Priority | Assignee |
|-------|--------|----------|----------|
| 1.1 Source Hash Generation | 2 | CRITICAL | DevOps |
| 1.2 NPM Dependencies Hash | 3 | CRITICAL | DevOps |
| 1.3 Core Derivation Build | 8 | HIGH | Build |
| 2.1 Desktop Entry | 3 | MEDIUM | Build |
| 2.2 Icon Installation | 2 | MEDIUM | Build |

**Sprint Points**: 18
**Sprint Goal**: `nix-build` succeeds and app launches

---

### Sprint 2: Quality & Portability (3 days)
**Goal**: Tests passing, multi-platform

| Story | Points | Priority | Assignee |
|-------|--------|----------|----------|
| 4.1 Build Determinism | 5 | HIGH | QA |
| 4.2 Smoke Testing | 3 | HIGH | QA |
| 3.1 Electron System Integration | 5 | HIGH | Build |
| 3.2 Darwin Support | 5 | MEDIUM | Build |
| 4.3 NixOS VM Integration Test | 8 | MEDIUM | QA |

**Sprint Points**: 26
**Sprint Goal**: All tests passing, Darwin builds working

---

### Sprint 3: Compliance & Polish (2 days)
**Goal**: Ready for PR submission

| Story | Points | Priority | Assignee |
|-------|--------|----------|----------|
| 5.1 Code Formatting | 2 | HIGH | Compliance |
| 5.2 Static Analysis | 3 | MEDIUM | Compliance |
| 5.3 Metadata Completeness | 2 | MEDIUM | Compliance |
| 5.4 Automated Updates | 3 | MEDIUM | Compliance |
| 7.1 Build Instructions | 3 | MEDIUM | Compliance |
| 7.2 Maintainer Guide | 2 | MEDIUM | Compliance |

**Sprint Points**: 15
**Sprint Goal**: All lints pass, docs complete

---

### Sprint 4: Upstream (5-7 days)
**Goal**: PR merged to nixpkgs

| Story | Points | Priority | Assignee |
|-------|--------|----------|----------|
| 8.1 nixpkgs-review Validation | 3 | HIGH | Maintainer |
| 8.2 Pull Request Submission | 5 | HIGH | Maintainer |
| 8.3 Review Response | 5 | HIGH | Maintainer |
| 8.4 OfBorg CI Success | 3 | HIGH | Maintainer |

**Sprint Points**: 16
**Sprint Goal**: PR approved and merged

---

### Sprint 5 (Optional): GPU Support (2 days)
**Goal**: GPU variant functional

| Story | Points | Priority | Assignee |
|-------|--------|----------|----------|
| 6.1 CUDA Acceleration | 5 | LOW | DevOps |
| 6.2 ROCm Acceleration | 5 | LOW | DevOps |
| 3.3 Linux ARM64 Support | 5 | LOW | Build |

**Sprint Points**: 15
**Sprint Goal**: GPU builds working locally

---

## Definition of Done

A user story is DONE when:
- [ ] All acceptance criteria met
- [ ] Code reviewed (self or peer)
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Changes committed to feature branch
- [ ] ZeroDB memory updated with learnings

---

## Definition of Ready

A user story is READY when:
- [ ] Acceptance criteria clearly defined
- [ ] Dependencies identified
- [ ] Story points estimated
- [ ] Assignee confirmed
- [ ] Prerequisites completed

---

## Velocity Tracking

| Sprint | Planned | Completed | Notes |
|--------|---------|-----------|-------|
| 0 (Infra) | - | 5 tasks | Setup complete |
| 1 (Foundation) | 18 pts | TBD | Critical path |
| 2 (Quality) | 26 pts | TBD | Test focus |
| 3 (Compliance) | 15 pts | TBD | Polish |
| 4 (Upstream) | 16 pts | TBD | Review dependent |
| 5 (GPU) | 15 pts | TBD | Optional |

---

## Risks & Dependencies

### High Risk
- **Electron version compatibility**: Mitigate with fallback Node launcher
- **Darwin build access**: May need Darwin CI runner
- **nixpkgs review duration**: Community-dependent, cannot control

### Medium Risk
- **npm dependency changes**: Locked via hash, but upstream may shift
- **GPU driver availability**: GPU variants optional for this reason
- **CI resource limits**: Hydra may timeout on large builds

### Dependencies
- Story 1.2 depends on 1.1 (hashes)
- Story 1.3 depends on 1.1, 1.2 (derivation needs hashes)
- All Sprint 2 stories depend on Sprint 1 completion
- Sprint 4 depends on Sprint 3 (can't PR without compliance)

---

## Burndown Chart (Planned)

```
Story Points
    │
75  │ ████████████
    │ ████████████
60  │ ████████████
    │ ████████████
45  │ ████████████ ██████████
    │ ████████████ ██████████
30  │ ████████████ ██████████ ███████
    │ ████████████ ██████████ ███████
15  │ ████████████ ██████████ ███████ ████████
    │ ████████████ ██████████ ███████ ████████
 0  │ ────────────────────────────────────────
    └─── Sprint1 ─ Sprint2 ─ Sprint3 ─ Sprint4
```

---

## Product Backlog Refinement

**Schedule**: End of each sprint
**Participants**: All agents + Product Owner
**Activities**:
- Review completed stories
- Refine upcoming stories
- Re-estimate based on velocity
- Adjust priorities
- Update ZeroDB with insights

---

**Last Updated**: 2025-10-27
**Product Owner**: Karsten Wade (quaid)
**Total Story Points**: 90 (excluding optional Sprint 5)
**Target Completion**: Sprint 4 end (~14 days)
