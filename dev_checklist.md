# ✅ AINative Studio – Branding Verification Checklist
> Internal QA and verification for rebranded fork of Void Editor  
> Version: v1.0  
> Maintained by: AINative Studio Dev Team

---

## 📁 Repo & Codebase Setup

- [ ] Forked from **Void Editor** GitHub repository
- [ ] Repository renamed to `ainative/ainative-studio`
- [ ] All GitHub project metadata updated (name, description, topics, README)
- [ ] CI/CD (if any) still functional post-fork

---

## 🔤 Branding Replacement – Text

### Global Replacements
- [ ] `Void` → `AINative Studio` (case-sensitive)
- [ ] `Void Editor` → `AINative Studio`
- [ ] `Glass Devtools, Inc.` → `AINative Studio`

### Affected Files
- [ ] `product.json`
- [ ] `package.json`
- [ ] `scripts/code.sh` and CLI messages
- [ ] `README.md`
- [ ] `CONTRIBUTING.md`
- [ ] `SECURITY.md`
- [ ] `LICENSE` (add: “Forked from Void Editor, based on VS Code”)
- [ ] `*.ts`, `*.js`, `*.json`, `*.md` files with inline mentions
- [ ] Remove or update all links to `voideditor.com`, Discord, GitHub `voideditor`

---

## 🖼️ Branding Replacement – Visuals

- [ ] App icon (PNG) updated for:
  - [ ] macOS `.icns`
  - [ ] Windows `.ico`
  - [ ] Linux `.png`
- [ ] Splash screen replaced
- [ ] Favicon updated
- [ ] Logo on welcome screen replaced
- [ ] Icons display correctly on all platforms

---

## 🧠 Branding in Code Comments / Metadata

- [ ] Updated comments like:
  - `// Forked by Void Editor` → `// Forked from Void Editor by AINative Studio`
  - `@voideditor` → `@ainativestudio`
- [ ] Module headers or copyright
- [ ] Any test files or string snapshots using old brand

---

## 🧪 Feature Functionality Check (Parity with Void Editor)

- [ ] **Chat interface** works with all supported models
- [ ] **Tab Autocomplete** and **Quick Edit** functional
- [ ] **Agent Mode**: Create, edit, search, delete flows functional
- [ ] **Gather Mode**: Context window reads files/folders correctly
- [ ] **Checkpoints and Diffs** load and apply correctly
- [ ] **Ollama/local model support** works as expected
- [ ] **Third-party model access** (OpenAI, Anthropic, Gemini, Claude, Grok, etc.) functional

---

## 🖥️ Platform Build Verification

- [ ] macOS `.dmg` builds successfully
- [ ] Windows `.exe` builds successfully
- [ ] Linux `.deb` or `.AppImage` builds successfully
- [ ] Correct AINative icons show in each installer
- [ ] Branded name appears in task manager/system title
- [ ] App runs without telemetry or brand regressions

---

## ✅ Final Acceptance

- [ ] Branding is consistent across UI, CLI, and documentation
- [ ] No visible or referenced use of “Void” remains
- [ ] No regressions from original Void Editor features
- [ ] Internal team sign-off from:
  - [ ] Engineering
  - [ ] Design
  - [ ] QA/Testing
  - [ ] Project Lead

---

## 📬 Notes

- Base fork: [Void Editor GitHub](https://github.com/voideditor/void)  
- Original lineage: VS Code → Void Editor → AINative Studio  
- All work must preserve licensing, architecture, and functionality of the upstream base.

---
