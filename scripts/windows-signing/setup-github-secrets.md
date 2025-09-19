# Setting Up GitHub Secrets for Windows Code Signing

## Prerequisites
You've already generated the certificate files using `create-cert-linux.sh` on Linux/WSL.

## Steps to Configure GitHub Actions

### 1. Get the Base64 Certificate

From your Linux/WSL terminal:
```bash
cat /root/AINativeStudio-IDE/scripts/windows-signing/certs/github-cert-base64.txt
```

Copy the entire output (it's a long base64 string).

### 2. Add GitHub Repository Secrets

1. Go to your GitHub repository
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Add these two secrets:

#### Secret 1: WINDOWS_CERTIFICATE_BASE64
- **Name:** `WINDOWS_CERTIFICATE_BASE64`
- **Value:** Paste the entire base64 string from step 1

#### Secret 2: WINDOWS_CERTIFICATE_PASSWORD
- **Name:** `WINDOWS_CERTIFICATE_PASSWORD`
- **Value:** `AINativeStudio2024!`

### 3. How It Works in the Workflows

The Windows workflows (`Windowsx64-signed.yml` and `build-windows-arm64-signed.yml`) will:

1. **Check for certificate** - Only run signing if secrets are present
2. **Import certificate** - Decode from base64 and import to Windows certificate store
3. **Sign executables** - Sign main app, Node.js, and CLI
4. **Sign installers** - Sign both User and System setup files
5. **Clean up** - Remove certificate from runner after use

### 4. Testing Locally on Windows

If you want to test signing on a Windows machine:

1. Copy the PFX file from WSL to Windows:
```bash
cp /root/AINativeStudio-IDE/scripts/windows-signing/certs/ainative-studio-codesign.pfx /mnt/c/Users/YourUsername/Desktop/
```

2. Run PowerShell as Administrator and test:
```powershell
cd C:\path\to\AINativeStudio-IDE\scripts\windows-signing
.\test-signing-local.ps1 -PfxPath "C:\Users\YourUsername\Desktop\ainative-studio-codesign.pfx"
```

### 5. Workflow Behavior

- **With certificates configured**: All executables and installers will be signed
- **Without certificates**: Workflows continue normally, just without signing
- **No workflow changes needed**: Just add the secrets and signing activates automatically

### Security Notes

- **Never commit** certificate files or passwords to the repository
- **Rotate certificates** every 1-2 years
- **Use environment-specific secrets** for different deployment environments
- For production, consider purchasing an EV certificate from a trusted CA

### Verification

After your first workflow run with certificates:
1. Download the artifacts
2. Right-click an executable → Properties → Digital Signatures
3. You should see "AINative Studio Code Signing" as the signer
4. Status will show as "not trusted" (normal for self-signed)
5. But Windows will no longer show "Unknown Publisher"