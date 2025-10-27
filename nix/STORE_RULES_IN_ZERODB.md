# ZeroDB Memory Initialization for Nixpkgs Project

**Purpose**: Store agent coding rules and project context in ZeroDB for team-wide access

**Execute these commands when deploying the agent team** (requires ZeroDB MCP server running)

---

## 1. Store Core Coding Rules

```javascript
// Store the complete agent coding rules document
zerodb_store_vector({
  content: `[Full content of AGENT_CODING_RULES.md - Planning, Reasoning, Coding, Testing, CI/CD, Monitoring rules]`,
  metadata: {
    type: "coding-rules",
    source: "https://github.com/AINative-Studio/agentic-rules/blob/main/agent-reasoning-planning-execution.md",
    project: "nixpkgs-packaging",
    version: "1.0",
    applies_to: "all-agents"
  }
});
```

## 2. Store Project Context

```javascript
// Store nixpkgs project overview
zerodb_store_memory({
  content: `Nixpkgs packaging project for AI Native Studio IDE. Goal: Create reproducible Nix derivation and upstream to nixpkgs. Team: 5 AI agents (DevOps, Build, QA, Compliance, Maintainer). Feature branch: feature/nixpkgs-packaging. Critical path: M0.1 hash generation → M1 build → M2 tests → M5 compliance → M6 PR submission.`,
  role: "project-coordinator",
  session_id: "nixpkgs-packaging",
  metadata: {
    type: "project-overview",
    status: "initialized",
    next_milestone: "M0",
    blocking_task: "hash-generation"
  }
});
```

## 3. Store Key Rules by Category

### Planning Rules
```javascript
zerodb_store_memory({
  content: `Planning & Roadmapping: Generate 4-week MVP roadmaps as markdown tables. Break weeks into sprints with epics, user stories, T-shirt estimates. Create dependency graphs using Graphviz DOT. Compile release checklists with unchecked boxes. Identify 3+ technical risks with likelihood and mitigation.`,
  role: "planning-rules",
  session_id: "nixpkgs-packaging",
  metadata: {
    category: "planning",
    rule_sections: ["1.1", "1.2", "1.3", "1.4", "1.5"]
  }
});
```

### Reasoning Rules
```javascript
zerodb_store_memory({
  content: `Chain-of-Thought Reasoning: Before nontrivial code, emit numbered reasoning: clarify requirements, weigh alternatives, consider edge cases/performance/security, conclude with chosen approach. Design data models with field types, indexing, relationships reasoning. Compare API options by security, integration ease, compatibility. Optimize performance by identifying bottlenecks, suggesting caching/batching. Explain error handling with potential errors and retry strategies.`,
  role: "reasoning-rules",
  session_id: "nixpkgs-packaging",
  metadata: {
    category: "reasoning",
    rule_sections: ["2.1", "2.2", "2.3", "2.4", "2.5"]
  }
});
```

### TDD Rules
```javascript
zerodb_store_memory({
  content: `Test-Driven Development: Generate failing unit tests (Red phase) using Jest/pytest before implementation. Create integration tests for cross-service functionality with HTTP verification. Convert pseudocode to BDD-style tests with describe/it blocks. Add minimal mocks/stubs for external dependencies. Tests must fail initially, then pass after implementation (Red-Green-Refactor).`,
  role: "tdd-rules",
  session_id: "nixpkgs-packaging",
  metadata: {
    category: "testing",
    rule_sections: ["3.1", "3.2", "3.3", "3.4"],
    critical_for: ["qa-agent", "build-agent"]
  }
});
```

### Refactoring Rules
```javascript
zerodb_store_memory({
  content: `Refactoring Guidelines: Extract duplicated logic into named helper functions with unified diffs. Convert callbacks to async/await with try/catch. Simplify nested conditionals using guard clauses and early returns. Enforce minimal imports, removing unused or heavy dependencies. Document all changes with inline annotations.`,
  role: "refactoring-rules",
  session_id: "nixpkgs-packaging",
  metadata: {
    category: "refactoring",
    rule_sections: ["4.1", "4.2", "4.3", "4.4"]
  }
});
```

### CI/CD Rules
```javascript
zerodb_store_memory({
  content: `CI/CD Automation: Generate GitHub Actions workflows with checkout, deps install, tests, deploy, smoke tests. Include secret placeholders. Create Terraform snippets for infrastructure. Add lint configurations that fail on errors. Implement canary deployments with traffic shifting and health checks. All YAML must be production-ready with proper error handling.`,
  role: "cicd-rules",
  session_id: "nixpkgs-packaging",
  metadata: {
    category: "ci-cd",
    rule_sections: ["5.1", "5.2", "5.3", "5.4"],
    critical_for: ["devops-agent", "compliance-agent"]
  }
});
```

## 4. Store Nixpkgs-Specific Patterns

```javascript
zerodb_store_memory({
  content: `Nixpkgs Packaging Patterns: Use buildNpmPackage for Node.js apps. Generate hashes with nix-prefetch-github and nix-prefetch-url. Ensure hermetic builds (no network during build phase). Set NODE_OPTIONS for large TS builds. Use makeWrapper for Electron integration. Follow nixpkgs formatting with 'nix fmt'. Include passthru.updateScript for r-ryantm. Mark platform-specific broken conditions.`,
  role: "nixpkgs-patterns",
  session_id: "nixpkgs-packaging",
  metadata: {
    type: "domain-knowledge",
    language: "nix",
    applies_to: ["build-agent", "devops-agent"]
  }
});
```

## 5. Store Critical Commands

```javascript
zerodb_store_vector({
  content: `Nix Build Commands:
- Generate source hash: nix-prefetch-github AINative-Studio AINativeStudio-IDE --rev v1.1.0
- Generate npm hash: nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' (extract from error)
- Build package: nix-build -E '...'
- Format code: nix fmt
- Run tests: ./nix/tests/smoke-run.sh ./result/bin/ainative-studio-ide
- Check determinism: ./nix/tests/determinism-test.sh
- Review PR: nixpkgs-review pr <id>`,
  metadata: {
    type: "command-reference",
    category: "nix-operations",
    session_id: "nixpkgs-packaging"
  }
});
```

## 6. Store Success Criteria

```javascript
zerodb_store_memory({
  content: `Success Criteria - Nixpkgs Project: M0: Hashes generated, dev env ready. M1: Local CPU build succeeds without network. M2: Determinism test passes, smoke test passes. M3: Electron wrapping works on all platforms. M4: GPU variant builds (optional). M5: All lints pass (nix fmt, deadnix, statix), docs complete. M6: PR merged to nixpkgs master/staging. M7: Binary cache verified post-merge.`,
  role: "success-criteria",
  session_id: "nixpkgs-packaging",
  metadata: {
    type: "acceptance-criteria",
    source: "PRD-section-12"
  }
});
```

## 7. Store Agent Collaboration Pattern

```javascript
zerodb_store_memory({
  content: `Agent Collaboration: Use session_id 'nixpkgs-packaging' for all memory operations. Store learnings after solving issues. Search for past solutions before starting new tasks. Share context across agents using consistent metadata tags. Report blockers immediately. Update task progress in AGENT_TASKS.md. Follow critical path: DevOps (M0) → Build (M1) → QA (M2) → Compliance (M5) → Maintainer (M6).`,
  role: "collaboration-protocol",
  session_id: "nixpkgs-packaging",
  metadata: {
    type: "team-process",
    applies_to: "all-agents"
  }
});
```

---

## Verification Commands

After storing, verify with:

```javascript
// Search for coding rules
zerodb_search_memory({
  query: "chain of thought reasoning rules",
  session_id: "nixpkgs-packaging",
  limit: 5
});

// Retrieve project context
zerodb_retrieve_memory({
  session_id: "nixpkgs-packaging",
  role: "project-coordinator",
  limit: 1
});

// Search for Nix-specific patterns
zerodb_search_memory({
  query: "buildNpmPackage nix derivation",
  session_id: "nixpkgs-packaging",
  limit: 3
});
```

---

## Notes

- **Execute these BEFORE** agents start work on milestones
- **Session ID** must be `"nixpkgs-packaging"` consistently
- **Metadata tags** enable filtering by agent role and task category
- **Vector storage** enables semantic search for rules and patterns
- **Memory storage** enables structured context retrieval

---

**Agent Deployment Checklist**:
- [ ] ZeroDB MCP server running and connected
- [ ] All memory storage commands executed successfully
- [ ] Verification queries return expected results
- [ ] Agents configured to use session ID `"nixpkgs-packaging"`
- [ ] Coding rules accessible via search

---

**Last Updated**: 2025-10-27
**Storage Version**: 1.0
**Total Memory Items**: 10+
