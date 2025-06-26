# 📄 Product Requirements Document (PRD)

**Project Name**: AINative Studio – Rebranded Fork of Void Editor
**Fork Target**: [Void Editor](https://github.com/voideditor/void)
**Void Editor Base**: Fork of Microsoft Visual Studio Code
**Maintained by**: AINative Studio
**Objective**: Create a fully branded release of AINative Studio by forking the Void Editor codebase, replacing all Void branding and references with **AINative Studio**, with **no change in features or functionality**.

---

## 🔥 Purpose

This project aims to launch **AINative Studio**, a rebranded version of the open-source **Void Editor** (a VS Code fork). All instances of **"Void"** and **"Void Editor"** in the codebase, UI, assets, and metadata will be updated to **AINative Studio**. No functional changes will be made—only branding and visual identity.

---

## 🎯 Goals

* ✅ Fork the Void Editor codebase
* ✅ Replace all text-based and visual branding from “Void” to “AINative Studio”
* ✅ Maintain 100% parity with Void Editor's features, models, extensions, and integrations
* ✅ Deliver build-ready artifacts for macOS, Windows, and Linux

---

## 🧱 Scope of Work

### 1. 🔤 Brand Reference Replacement

Update **all instances of the following terms** throughout the codebase, UI, CLI, and docs:

| Original Term          | Replace With      |
| ---------------------- | ----------------- |
| `Void`                 | `AINative Studio` |
| `Void Editor`          | `AINative Studio` |
| `Glass Devtools, Inc.` | `AINative Studio` |

#### Includes:

* UI strings (titlebars, about dialogs, welcome screen)
* Shell scripts and CLI banners
* `product.json`, `package.json`, and installer config
* Code comments and internal documentation
* Build logs and changelogs
* README, CONTRIBUTING, LICENSE metadata

---

### 2. 🖼️ Visual Asset Replacement

Replace all logos, icons, and brand images:

* ✅ Logos, splash screens, and welcome screen visuals
* ✅ Application icons (`.ico`, `.icns`, `.png`) used for macOS/Windows/Linux installers
* ✅ Favicons and in-app visual elements

> 🧾 **All visual assets will be supplied by AINative Studio in PNG format.**

---

### 3. 🗂️ Documentation & Metadata Update

* Rename the GitHub repository: `ainative/ainative-studio`
* Replace all Void Editor references in:

  * `README.md`
  * `CONTRIBUTING.md`
  * `SECURITY.md`
  * `LICENSE` (add line: "Forked from Void Editor, originally based on Visual Studio Code")
* Update or remove links to `voideditor.com`, Discord, and GitHub `voideditor` URLs

---

### 4. 🧠 Code Identifiers & Comments

Perform safe replacements in:

* Code comments: `// Forked from Void` → `// Forked from Void Editor by AINative Studio`
* Code annotations or references: `@voideditor` → `@ainativestudio`
* Only update labels—**do not alter functional logic, paths, or module names unless branding-dependent**

---

## ❌ Out of Scope

* No changes to LLM support, prompts, agent capabilities, or context behavior
* No UX/UI redesign outside of branding
* No modifications to storage, extensions, or backend logic
* No integration of new models or plugins

---

## 🚀 Deliverables

| Deliverable              | Description                                                                     |
| ------------------------ | ------------------------------------------------------------------------------- |
| 🧑‍💻 Forked Source Code | Fully branded AINative Studio source based on Void Editor                       |
| 🖼️ Asset Integration    | All PNG-based logos and icons updated across app, splash, metadata              |
| 📦 Platform Builds       | `.dmg`, `.exe`, `.deb`, `.AppImage` installers for all platforms                |
| 📄 Updated Docs          | README, LICENSE, build scripts, and metadata updated to reflect AINative Studio |
| ✅ QA Checklist           | Functionality verification + branding parity checklist                          |

---

## ✅ QA & Acceptance Criteria

| Component        | Criteria                                                                                |
| ---------------- | --------------------------------------------------------------------------------------- |
| App Title        | Displays "AINative Studio"                                                              |
| About Modal      | References AINative Studio, not Void                                                    |
| Icons & Logos    | All visuals replaced across splash screen, app icon, welcome screen                     |
| Branding in Code | No residual mentions of "Void" or "Glass Devtools"                                      |
| Features         | Chat, Autocomplete, Checkpoints, Agent/Gather modes function identically to Void Editor |
| Platform Builds  | Launchable installers produced for macOS, Windows, and Linux                            |

---

## 🛠️ Build Flow (Inherited from Void Editor)

* Run: `npm install`, `gulp`, then `./scripts/code.sh`
* Platform-specific builds via: `yarn run build`, Electron packagers
* Optional CI: GitHub Actions for auto-build per OS

---

## 📅 Timeline

| Phase     | Task                     | Time         |
| --------- | ------------------------ | ------------ |
| Phase 1   | Fork and Repo Setup      | 0.5 day      |
| Phase 2   | Branding Replacement     | 2–3 days     |
| Phase 3   | Icon/Asset Integration   | 1 day        |
| Phase 4   | Build & Platform Testing | 2 days       |
| Phase 5   | QA and Final Checks      | 1 day        |
| **Total** | —                        | **5–6 days** |

---

## 📎 Dependencies

* ✅ AINative Studio Logo + Icon Pack (PNG)
* ✅ GitHub repository access (`ainative/ainative-studio`)
* ❌ No additional telemetry or attribution required

---

