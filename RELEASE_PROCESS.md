# AINative Studio IDE Release Process

## Overview
This repository uses a comprehensive release system that automatically gathers the latest successful builds from all platform-specific workflows and creates unified releases.

## Release Workflow: `release-all-successful.yml`

### Purpose
The `release-all-successful.yml` workflow is designed to:
- Find the latest successful build from each platform-specific workflow
- Download artifacts from those successful builds  
- Create a unified release with all available platforms
- Only include builds that have actually succeeded (no broken builds)

### Supported Platforms
The release system currently supports the following platforms:

| Platform | Architecture | Workflow File | Artifact Name |
|----------|-------------|---------------|---------------|
| Linux | x64 | `linux_x64.yml` | `ainative-studio-linux-x64-tar` |
| Linux | ARM (32-bit) | `build-linux-arm.yml` | `ainative-studio-linux-armhf` |
| Linux | ARM64 | `build-linux-arm64.yml` | `ainative-studio-linux-arm64` |
| Windows | x64 | `Windows-x64.yml` | `ainative-studio-win32-x64` |
| Windows | ARM64 | `build-windows-arm64.yml` | `ainative-studio-win32-arm64` |
| macOS | Intel (x64) | `build-macos-x64-simple.yml` | `ainative-studio-darwin-x64` |
| macOS | Apple Silicon (ARM64) | `build-macos-arm64-simple.yml` | `ainative-studio-darwin-arm64` |

## How to Create a Release

### Manual Release (Recommended)
1. Navigate to the Actions tab in GitHub
2. Select "Release All Successful Builds" workflow
3. Click "Run workflow"
4. Fill in the required parameters:
   - **Version tag**: e.g., `v1.0.0`
   - **Release name**: (optional) Custom name for the release
   - **Release notes**: (optional) Custom release notes
   - **Pre-release**: Check if this is a pre-release version

### What Happens During Release
1. **Discovery Phase**: The workflow searches for the latest successful run of each platform workflow
2. **Download Phase**: Artifacts from successful builds are downloaded
3. **Validation Phase**: The system verifies which artifacts were successfully downloaded
4. **Release Creation**: A GitHub release is created with all available artifacts

## Key Benefits

### ✅ Only Working Builds
- The system only includes builds that have actually succeeded
- No more releases with broken or missing platform builds
- Each platform is independently validated

### ✅ Latest Versions
- Always uses the most recent successful build for each platform
- No manual tracking of build numbers or commits required
- Automatic discovery of available builds

### ✅ Robust Error Handling
- If a platform build fails, it's simply excluded from the release
- Other platforms continue to work normally  
- Clear logging shows which builds were found and included

### ✅ Comprehensive Documentation
- Release notes automatically list which builds are included
- Each platform shows the specific build number and commit hash
- Installation instructions included in every release

## Workflow Dependencies

The release workflow depends on these platform-specific workflows being present and working:

### Required Workflows
- `linux_x64.yml` - Linux x64 builds with multiple package formats
- `Windows-x64.yml` - Windows x64 builds and installers  
- `build-macos-arm64-simple.yml` - macOS Apple Silicon builds
- `build-macos-x64-simple.yml` - macOS Intel builds

### Optional Workflows  
- `build-linux-arm.yml` - Linux ARM 32-bit builds
- `build-linux-arm64.yml` - Linux ARM64 builds
- `build-windows-arm64.yml` - Windows ARM64 builds

## Troubleshooting

### No Artifacts Found
If the release contains no artifacts:
1. Check that the platform workflows have run successfully recently
2. Verify that the workflow files exist in `.github/workflows/`
3. Confirm that the artifact names match those specified in the release workflow

### Missing Platforms
If a platform is missing from the release:
1. Check the workflow run logs for that platform
2. Ensure the most recent run of that workflow succeeded
3. Verify the artifact was uploaded correctly

### Release Process Fails
If the release process itself fails:
1. Check the workflow permissions (needs `contents: write`)
2. Verify the GitHub token has appropriate permissions
3. Check for any API rate limiting issues

## Maintenance

### Adding New Platforms
To add support for a new platform:
1. Create the platform-specific workflow in `.github/workflows/`
2. Add the workflow to the `workflows` array in `release-all-successful.yml`
3. Add the platform display name to the `platforms` object
4. Update this documentation

### Removing Platforms  
To remove a platform:
1. Remove the workflow entry from `release-all-successful.yml`
2. Remove the platform from the `platforms` object
3. Update this documentation

## Security Notes

- The workflow requires `contents: write` permission to create releases
- Uses `GITHUB_TOKEN` for API access (automatically provided)
- Only downloads artifacts from the same repository
- All artifact downloads are logged for audit purposes