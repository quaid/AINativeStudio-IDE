#!/bin/bash
# Create GitHub issues for all user stories in BACKLOG.md
# Run from nix/ directory

REPO="quaid/AINativeStudio-IDE"

echo "Creating GitHub issues in $REPO..."

# Story 1.1 - Source Hash Generation (COMPLETED)
gh issue create --repo "$REPO" \
  --title "[Story 1.1] Source Hash Generation" \
  --body "**Epic**: 1 - Reproducible Nix Derivation
**Story Points**: 2 | **Priority**: CRITICAL | **Milestone**: M0 | **Sprint**: 1
**Assignee**: AI DevOps Agent

## User Story
**As a** nixpkgs maintainer
**I want** deterministic source hashing from GitHub releases
**So that** builds are reproducible and verifiable

## Acceptance Criteria
- [x] \`fetchFromGitHub\` hash correctly prefetches v1.1.0
- [x] Hash validation passes in sandbox mode
- [x] No network access during build phase

## Status
✅ **COMPLETE** (commit: 1044b26e)
- Source hash: sha256-Au2UcHgJ9N1o1fnZZOb7IuZB/4HPlk/MLPZIWpkLgAQ=
- See: nix/M0.1-RESULTS.txt" \
&& echo "✓ Created Story 1.1"

# Story 1.2 - NPM Dependencies Hash (COMPLETED)
gh issue create --repo "$REPO" \
  --title "[Story 1.2] NPM Dependencies Hash" \
  --body "**Epic**: 1 - Reproducible Nix Derivation
**Story Points**: 3 | **Priority**: CRITICAL | **Milestone**: M0 | **Sprint**: 1
**Assignee**: AI DevOps Agent

## User Story
**As a** Nix package builder
**I want** locked npm dependencies via hash
**So that** JavaScript dependencies are hermetic

## Acceptance Criteria
- [x] \`npmDepsHash\` generated from ainative-studio/package-lock.json
- [x] Hash includes all transitive dependencies
- [x] Offline build succeeds with cached deps

## Status
✅ **COMPLETE** (commit: 1044b26e)
- npmDepsHash: sha256-ElU9TiSlQE0B0jXrwanGeTZ89AAuxwzE9sjQlEL862M=
- npm-deps derivation validated

## Dependencies
Depends on: #1 (Story 1.1)" \
&& echo "✓ Created Story 1.2"

# Story 1.3 - Core Derivation Build (IN PROGRESS - M1.1)
gh issue create --repo "$REPO" \
  --title "[Story 1.3] Core Derivation Build" \
  --body "**Epic**: 1 - Reproducible Nix Derivation
**Story Points**: 8 | **Priority**: HIGH | **Milestone**: M1 | **Sprint**: 1
**Assignee**: AI Build Agent

## User Story
**As a** Nix user
**I want** to build AI Native Studio IDE from source
**So that** I can install it on my NixOS system

## Acceptance Criteria
- [ ] \`nix-build\` succeeds on x86_64-linux
- [ ] Output binary launches without errors
- [ ] All native modules (node-gyp) compile hermetically
- [ ] No impure environment variables leak

## Current Status
🔄 **IN PROGRESS** - M1.1
- Hashes: ✅ Complete
- Build: ⚠️ Blocked by missing kerberos/gssapi headers
- Next: Add krb5 to buildInputs

## Dependencies
Depends on: #1 (Story 1.1), #2 (Story 1.2)" \
&& echo "✓ Created Story 1.3"

# Story 2.1 - Desktop Entry
gh issue create --repo "$REPO" \
  --title "[Story 2.1] Desktop Entry" \
  --body "**Epic**: 2 - Desktop Integration
**Story Points**: 3 | **Priority**: MEDIUM | **Milestone**: M1 | **Sprint**: 1
**Assignee**: AI Build Agent

## User Story
**As a** desktop user
**I want** AI Native Studio IDE in my application launcher
**So that** I can start it like any other app

## Acceptance Criteria
- [ ] \`.desktop\` file installed to standard XDG path
- [ ] Entry appears in GNOME/KDE application menus
- [ ] Correct categories assigned (Development, IDE, TextEditor, Utility)
- [ ] MIME types properly associated

## Current Status
🔄 **PARTIAL**
- Desktop file defined: ✅ (default.nix)
- Categories fixed: ✅ (removed non-standard 'AI')
- Installation: ⏳ Waiting for M1.3 completion

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 2.1"

# Story 2.2 - Icon Installation
gh issue create --repo "$REPO" \
  --title "[Story 2.2] Icon Installation" \
  --body "**Epic**: 2 - Desktop Integration
**Story Points**: 2 | **Priority**: MEDIUM | **Milestone**: M1 | **Sprint**: 1
**Assignee**: AI Build Agent

## User Story
**As a** desktop user
**I want** AI Native Studio IDE to have proper icons
**So that** it's visually identifiable in my system

## Acceptance Criteria
- [ ] Icons installed to hicolor theme (48x48, 256x256, etc.)
- [ ] Icon cache updated post-install
- [ ] SVG and PNG formats both supported
- [ ] Icons visible in app launcher and window manager

## Current Status
⏳ **PENDING** - M1.3
- Icon installation code exists in default.nix
- Awaiting successful build to test

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 2.2"

# Story 3.1 - Electron System Integration
gh issue create --repo "$REPO" \
  --title "[Story 3.1] Electron System Integration" \
  --body "**Epic**: 3 - Cross-Platform Support
**Story Points**: 5 | **Priority**: HIGH | **Milestone**: M3 | **Sprint**: 2
**Assignee**: AI Build Agent

## User Story
**As a** nixpkgs packager
**I want** to use system Electron instead of bundled
**So that** security updates are centralized

## Acceptance Criteria
- [ ] Package uses nixpkgs \`electron_30\`
- [ ] Wrapper script correctly launches app with system Electron
- [ ] \`ELECTRON_IS_DEV=0\` set for production mode
- [ ] App functionality identical to bundled Electron

## Current Status
🔄 **PARTIAL**
- electron_30 parameter exists in default.nix
- Wrapper with makeWrapper defined
- Needs testing after M1 completion

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 3.1"

# Story 3.2 - Darwin (macOS) Support
gh issue create --repo "$REPO" \
  --title "[Story 3.2] Darwin (macOS) Support" \
  --body "**Epic**: 3 - Cross-Platform Support
**Story Points**: 5 | **Priority**: MEDIUM | **Milestone**: M3 | **Sprint**: 2
**Assignee**: AI Build Agent

## User Story
**As a** macOS user
**I want** AI Native Studio IDE via nix-darwin
**So that** I can use Nix on my Mac

## Acceptance Criteria
- [ ] Build succeeds on x86_64-darwin
- [ ] Build succeeds on aarch64-darwin (Apple Silicon)
- [ ] Darwin-specific code paths tested
- [ ] Package marked \`broken\` if Electron unavailable on Darwin

## Current Status
⏳ **PENDING** - M3

## Dependencies
Depends on: #3 (Story 1.3), #6 (Story 3.1)" \
&& echo "✓ Created Story 3.2"

# Story 3.3 - Linux ARM64 Support
gh issue create --repo "$REPO" \
  --title "[Story 3.3] Linux ARM64 Support" \
  --body "**Epic**: 3 - Cross-Platform Support
**Story Points**: 5 | **Priority**: LOW | **Milestone**: M3 | **Sprint**: 5 (Optional)
**Assignee**: AI Build Agent

## User Story
**As an** ARM server/desktop user
**I want** AI Native Studio IDE on aarch64
**So that** I can develop on ARM platforms

## Acceptance Criteria
- [ ] Build succeeds on aarch64-linux
- [ ] Native modules compile for ARM64
- [ ] Performance acceptable on ARM hardware
- [ ] Hydra CI builds ARM64 variant

## Current Status
⏳ **PENDING** - Sprint 5 (Optional)

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 3.3"

# Story 4.1 - Build Determinism
gh issue create --repo "$REPO" \
  --title "[Story 4.1] Build Determinism" \
  --body "**Epic**: 4 - Testing & Quality Assurance
**Story Points**: 5 | **Priority**: HIGH | **Milestone**: M2 | **Sprint**: 2
**Assignee**: AI QA Agent

## User Story
**As a** nixpkgs reviewer
**I want** bit-for-bit reproducible builds
**So that** binaries can be verified independently

## Acceptance Criteria
- [ ] Two successive builds produce identical hashes
- [ ] No timestamps embedded in output
- [ ] No random data in artifacts
- [ ] \`determinism-test.sh\` passes

## Current Status
⏳ **PENDING** - M2
- Test script ready: nix/tests/determinism-test.sh

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 4.1"

# Story 4.2 - Smoke Testing
gh issue create --repo "$REPO" \
  --title "[Story 4.2] Smoke Testing" \
  --body "**Epic**: 4 - Testing & Quality Assurance
**Story Points**: 3 | **Priority**: HIGH | **Milestone**: M2 | **Sprint**: 2
**Assignee**: AI QA Agent

## User Story
**As a** package maintainer
**I want** automated launch tests
**So that** I know the app actually runs

## Acceptance Criteria
- [ ] Headless launch via Xvfb succeeds
- [ ] App starts within 10 second timeout
- [ ] App exits cleanly without crash
- [ ] \`smoke-run.sh\` passes on CI

## Current Status
⏳ **PENDING** - M2
- Test script ready: nix/tests/smoke-run.sh

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 4.2"

# Story 4.3 - NixOS VM Integration Test
gh issue create --repo "$REPO" \
  --title "[Story 4.3] NixOS VM Integration Test" \
  --body "**Epic**: 4 - Testing & Quality Assurance
**Story Points**: 8 | **Priority**: MEDIUM | **Milestone**: M2 | **Sprint**: 2
**Assignee**: AI QA Agent

## User Story
**As a** NixOS module user
**I want** VM-based integration tests
**So that** the package works in real NixOS environments

## Acceptance Criteria
- [ ] \`make-test-python.nix\` test implemented
- [ ] VM boots with package installed
- [ ] Desktop entry functional in VM
- [ ] Test runs in Hydra CI

## Current Status
⏳ **PENDING** - M2

## Dependencies
Depends on: #3 (Story 1.3), #4 (Story 2.1)" \
&& echo "✓ Created Story 4.3"

# Story 5.1 - Code Formatting
gh issue create --repo "$REPO" \
  --title "[Story 5.1] Code Formatting" \
  --body "**Epic**: 5 - CI/CD & Automation
**Story Points**: 2 | **Priority**: HIGH | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** nixpkgs contributor
**I want** properly formatted Nix code
**So that** my PR meets community standards

## Acceptance Criteria
- [ ] \`nix fmt\` passes on all \`.nix\` files
- [ ] \`treefmt-nix\` configuration working
- [ ] Formatting enforced in pre-commit hook
- [ ] Style matches nixpkgs conventions

## Current Status
⏳ **PENDING** - M5

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 5.1"

# Story 5.2 - Static Analysis
gh issue create --repo "$REPO" \
  --title "[Story 5.2] Static Analysis" \
  --body "**Epic**: 5 - CI/CD & Automation
**Story Points**: 3 | **Priority**: MEDIUM | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** code reviewer
**I want** automated lint checks
**So that** anti-patterns are caught early

## Acceptance Criteria
- [ ] \`deadnix\` finds no dead code
- [ ] \`statix\` finds no anti-patterns
- [ ] \`nixpkgs-lint\` passes
- [ ] All issues fixed or documented

## Current Status
⏳ **PENDING** - M5

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 5.2"

# Story 5.3 - Metadata Completeness
gh issue create --repo "$REPO" \
  --title "[Story 5.3] Metadata Completeness" \
  --body "**Epic**: 5 - CI/CD & Automation
**Story Points**: 2 | **Priority**: MEDIUM | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** nixpkgs maintainer
**I want** complete package metadata
**So that** users know what they're installing

## Acceptance Criteria
- [ ] \`description\` clearly explains the package
- [ ] \`longDescription\` provides details
- [ ] \`homepage\` URL valid
- [ ] \`changelog\` links to GitHub releases
- [ ] \`license\` uses correct SPDX identifier
- [ ] \`maintainers\` list includes quaid, albertolopez, urbantech
- [ ] \`platforms\` accurately reflects supported systems
- [ ] \`mainProgram\` set correctly

## Current Status
🔄 **PARTIAL**
- Basic meta exists in default.nix
- Needs completion in M5

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 5.3"

# Story 5.4 - Automated Updates (r-ryantm)
gh issue create --repo "$REPO" \
  --title "[Story 5.4] Automated Updates (r-ryantm)" \
  --body "**Epic**: 5 - CI/CD & Automation
**Story Points**: 3 | **Priority**: MEDIUM | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** package maintainer
**I want** automatic version updates
**So that** the package stays current with upstream

## Acceptance Criteria
- [ ] \`update.sh\` script functional
- [ ] Script fetches latest GitHub release
- [ ] Script updates version and hashes
- [ ] r-ryantm bot can parse and execute script
- [ ] \`passthru.updateScript\` set correctly

## Current Status
🔄 **PARTIAL**
- update.sh exists: nix/update.sh
- Needs testing and integration

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 5.4"

# Story 6.1 - CUDA Acceleration
gh issue create --repo "$REPO" \
  --title "[Story 6.1] CUDA Acceleration" \
  --body "**Epic**: 6 - GPU Support (Optional)
**Story Points**: 5 | **Priority**: LOW | **Milestone**: M4 | **Sprint**: 5 (Optional)
**Assignee**: AI DevOps Agent

## User Story
**As a** NVIDIA GPU user
**I want** GPU-accelerated AI features
**So that** I can use hardware acceleration

## Acceptance Criteria
- [ ] \`cudaSupport ? false\` parameter works
- [ ] CUDA dependencies only included when enabled
- [ ] Package builds with \`cudaSupport = true\`
- [ ] GPU features functional in CUDA build

## Current Status
⏳ **PENDING** - Sprint 5 (Optional)
- Parameter exists in default.nix
- TODO comments mark where CUDA deps go

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 6.1"

# Story 6.2 - ROCm Acceleration
gh issue create --repo "$REPO" \
  --title "[Story 6.2] ROCm Acceleration" \
  --body "**Epic**: 6 - GPU Support (Optional)
**Story Points**: 5 | **Priority**: LOW | **Milestone**: M4 | **Sprint**: 5 (Optional)
**Assignee**: AI DevOps Agent

## User Story
**As an** AMD GPU user
**I want** ROCm-accelerated AI features
**So that** I can use my AMD hardware

## Acceptance Criteria
- [ ] \`rocmSupport ? false\` parameter works
- [ ] ROCm dependencies only included when enabled
- [ ] Package builds with \`rocmSupport = true\`
- [ ] GPU features functional in ROCm build

## Current Status
⏳ **PENDING** - Sprint 5 (Optional)
- Parameter exists in default.nix
- TODO comments mark where ROCm deps go

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 6.2"

# Story 7.1 - Build Instructions
gh issue create --repo "$REPO" \
  --title "[Story 7.1] Build Instructions" \
  --body "**Epic**: 7 - Documentation
**Story Points**: 3 | **Priority**: MEDIUM | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** developer
**I want** clear build instructions
**So that** I can build the package locally

## Acceptance Criteria
- [ ] \`README.nix\` includes step-by-step build guide
- [ ] Hash generation process documented
- [ ] Common errors and solutions listed
- [ ] Platform-specific notes included

## Current Status
🔄 **PARTIAL**
- README.nix exists with basic info
- Needs expansion in M5

## Dependencies
Depends on: #3 (Story 1.3)" \
&& echo "✓ Created Story 7.1"

# Story 7.2 - Maintainer Guide
gh issue create --repo "$REPO" \
  --title "[Story 7.2] Maintainer Guide" \
  --body "**Epic**: 7 - Documentation
**Story Points**: 2 | **Priority**: MEDIUM | **Milestone**: M5 | **Sprint**: 3
**Assignee**: AI Compliance Agent

## User Story
**As a** package maintainer
**I want** maintenance procedures documented
**So that** I can update and maintain the package

## Acceptance Criteria
- [ ] Update process documented
- [ ] Testing procedures outlined
- [ ] Troubleshooting guide provided
- [ ] Contact information current

## Current Status
⏳ **PENDING** - M5

## Dependencies
Depends on: #3 (Story 1.3), #15 (Story 5.4)" \
&& echo "✓ Created Story 7.2"

# Story 8.1 - nixpkgs-review Validation
gh issue create --repo "$REPO" \
  --title "[Story 8.1] nixpkgs-review Validation" \
  --body "**Epic**: 8 - Upstream Contribution
**Story Points**: 3 | **Priority**: HIGH | **Milestone**: M6 | **Sprint**: 4
**Assignee**: AI Maintainer Agent

## User Story
**As a** PR submitter
**I want** to validate my changes locally
**So that** reviewers don't find issues

## Acceptance Criteria
- [ ] \`nixpkgs-review pr\` runs successfully
- [ ] No rebuild regressions detected
- [ ] All platforms build cleanly
- [ ] Rebuild count <1000 (or staging targeted)

## Current Status
⏳ **PENDING** - M6

## Dependencies
Depends on: All Sprint 1-3 stories complete" \
&& echo "✓ Created Story 8.1"

# Story 8.2 - Pull Request Submission
gh issue create --repo "$REPO" \
  --title "[Story 8.2] Pull Request Submission" \
  --body "**Epic**: 8 - Upstream Contribution
**Story Points**: 5 | **Priority**: HIGH | **Milestone**: M6 | **Sprint**: 4
**Assignee**: AI Maintainer Agent

## User Story
**As a** nixpkgs contributor
**I want** to submit a well-formed PR
**So that** it gets reviewed and merged quickly

## Acceptance Criteria
- [ ] PR targets correct branch (master or staging)
- [ ] PR title follows convention: \"ainative-studio-ide: init at 1.1.0\"
- [ ] PR description complete and clear
- [ ] Commits properly formatted
- [ ] All CI checks passing

## Current Status
⏳ **PENDING** - M6

## Dependencies
Depends on: #20 (Story 8.1)" \
&& echo "✓ Created Story 8.2"

# Story 8.3 - Review Response
gh issue create --repo "$REPO" \
  --title "[Story 8.3] Review Response" \
  --body "**Epic**: 8 - Upstream Contribution
**Story Points**: 5 | **Priority**: HIGH | **Milestone**: M6 | **Sprint**: 4
**Assignee**: AI Maintainer Agent

## User Story
**As a** PR author
**I want** to address reviewer feedback professionally
**So that** my PR gets approved

## Acceptance Criteria
- [ ] All reviewer comments addressed
- [ ] Requested changes implemented
- [ ] Follow-up commits clean and logical
- [ ] Communication respectful and clear

## Current Status
⏳ **PENDING** - M6

## Dependencies
Depends on: #21 (Story 8.2)" \
&& echo "✓ Created Story 8.3"

# Story 8.4 - OfBorg CI Success
gh issue create --repo "$REPO" \
  --title "[Story 8.4] OfBorg CI Success" \
  --body "**Epic**: 8 - Upstream Contribution
**Story Points**: 3 | **Priority**: HIGH | **Milestone**: M6 | **Sprint**: 4
**Assignee**: AI Maintainer Agent

## User Story
**As a** nixpkgs contributor
**I want** OfBorg builds to pass
**So that** maintainers can merge my PR

## Acceptance Criteria
- [ ] All OfBorg platform builds succeed
- [ ] No evaluation errors
- [ ] Test suite passes
- [ ] Meta checks validate

## Current Status
⏳ **PENDING** - M6

## Dependencies
Depends on: #21 (Story 8.2)" \
&& echo "✓ Created Story 8.4"

echo ""
echo "✅ All 23 user stories created as GitHub issues!"
echo "Repository: $REPO"
