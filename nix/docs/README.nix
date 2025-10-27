# AI Native Studio IDE - Nix Packaging

This directory contains the Nix package definition for AI Native Studio IDE.

## Overview

AI Native Studio IDE is packaged using `buildNpmPackage` with a lockfile-based approach for reproducible builds. The package follows nixpkgs community standards and is designed for upstream contribution.

## Package Location

The derivation is located at:
```
nix/pkgs/applications/editors/ainative-studio-ide/default.nix
```

## Building Locally

### CPU-only Build (default)

```bash
# From the repository root
nix-build -E 'with import <nixpkgs> {}; callPackage ./nix/pkgs/applications/editors/ainative-studio-ide {}'
```

### With GPU Support

```bash
# CUDA support
nix-build -E 'with import <nixpkgs> {}; callPackage ./nix/pkgs/applications/editors/ainative-studio-ide { cudaSupport = true; }'

# ROCm support
nix-build -E 'with import <nixpkgs> {}; callPackage ./nix/pkgs/applications/editors/ainative-studio-ide { rocmSupport = true; }'
```

## Hash Generation

Before the first build, you need to generate the npm dependencies hash:

```bash
# Navigate to the package directory
cd nix/pkgs/applications/editors/ainative-studio-ide

# Generate npmDepsHash (this will fail with the hash to use)
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' 2>&1 | grep "got:"

# Copy the hash from the error message and update default.nix
```

The same process applies for the source hash from `fetchFromGitHub`.

## Testing

### Run Test Suite

```bash
cd nix/tests
./run-tests.sh
```

### Manual Testing

After building:
```bash
./result/bin/ainative-studio-ide
```

## Development Workflow

1. **Make changes** to `default.nix`
2. **Rebuild**: `nix-build ...`
3. **Test**: Run the built binary
4. **Format**: `nix fmt` (if using flakes)
5. **Lint**: Run `deadnix` and `statix`

## CI Integration

The package includes:
- **update.sh**: Automated version updates for r-ryantm bot
- **Determinism tests**: Validates reproducible builds
- **VM smoke tests**: Headless launch verification

## Upstreaming to nixpkgs

When ready to contribute upstream:

1. Fork nixpkgs
2. Copy this package to `pkgs/applications/editors/ainative-studio-ide/`
3. Add to `pkgs/top-level/all-packages.nix`:
   ```nix
   ainative-studio-ide = callPackage ../applications/editors/ainative-studio-ide { };
   ```
4. Run `nixpkgs-review` locally
5. Open PR to nixpkgs (target `master` or `staging` based on rebuild count)

## Maintainers

- quaid
- albertolopez
- urbantech

## Build Requirements

### System Dependencies
- Node.js 20+
- Python 3.x
- pkg-config
- Standard C++ compiler

### Optional Dependencies
- Electron 30 (for system electron wrapper)
- CUDA toolkit (for GPU variant)
- ROCm (for AMD GPU variant)

## Architecture Notes

### Build Process

1. **Source**: Fetched from GitHub releases
2. **Dependencies**: Locked via `npmDepsHash` (no network access during build)
3. **Compilation**: TypeScript → JavaScript via `npm run compile`
4. **Packaging**: Install to Nix store with wrapper script
5. **Desktop Integration**: `.desktop` file and icons installed to standard paths

### Electron Handling

The package supports two modes:
1. **System Electron**: Uses nixpkgs `electron_30` if available
2. **Bundled Node**: Falls back to Node.js launcher if electron unavailable

### Native Modules

Native Node modules (via node-gyp) are built hermetically using Nix-provided:
- Python interpreter
- C++ standard library
- pkg-config

## Troubleshooting

### Build Fails with Hash Mismatch

This is expected on first build. Copy the "got" hash from the error and update `default.nix`.

### Electron Not Found

Ensure `electron_30` is available in your nixpkgs version, or set to `null` to use Node launcher.

### GPU Build Fails

GPU variants require unfree packages enabled:
```bash
export NIXPKGS_ALLOW_UNFREE=1
```

### Node Memory Issues

The build sets `NODE_OPTIONS="--max-old-space-size=8192"`. Increase if needed for your platform.

## References

- [Upstream Repository](https://github.com/AINative-Studio/AINativeStudio-IDE)
- [Nixpkgs Manual: buildNpmPackage](https://nixos.org/manual/nixpkgs/stable/#node-packaging)
- [Nixpkgs Contributing Guide](https://nixos.org/manual/nixpkgs/stable/#chap-contributing)
- [Project PRD](../../nixpkgs-PRD.md)
