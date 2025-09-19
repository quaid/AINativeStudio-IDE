# Windows Code Signing Setup Guide

## Prerequisites
- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1 or later
- Administrator access (recommended)

## Quick Setup (Recommended)

### Step 1: Open PowerShell as Administrator
1. Right-click Start Menu
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

### Step 2: Navigate to Scripts Directory
```powershell
cd C:\path\to\AINativeStudio-IDE\scripts\windows-signing
```

### Step 3: Run the Secure Certificate Generator
```powershell
# Allow script execution (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the certificate generator
.\create-self-signed-cert-secure.ps1
```

The script will:
- Generate a secure random password (or use your own with `-Password`)
- Create a 4096-bit RSA certificate
- Export all necessary files
- Generate GitHub Actions configuration

### Step 4: Configure GitHub Actions
Run the generated setup script:
```powershell
cd certs
.\setup-github-secrets.ps1
```

Enter your repository name when prompted (format: `owner/repo`)

## Manual Setup (Alternative)

If you prefer to set up manually:

### Step 1: Generate Certificate
```powershell
.\create-self-signed-cert-secure.ps1 -Password "YourSecurePassword123!" -GenerateGitHubFiles
```

### Step 2: Get Base64 Certificate
```powershell
$base64 = Get-Content .\certs\github-cert-base64.txt -Raw
$base64 | clip  # Copies to clipboard
```

### Step 3: Add to GitHub
1. Go to your repository on GitHub
2. Navigate to: Settings → Secrets and variables → Actions
3. Add new secret: `WINDOWS_CERTIFICATE_BASE64` (paste from clipboard)
4. Add new secret: `WINDOWS_CERTIFICATE_PASSWORD` (your password)

## Testing Locally

### Test Signing a File
```powershell
# Using thumbprint (certificate in store)
.\sign-executable.ps1 -FilePath "C:\path\to\your.exe"

# Using PFX file directly
.\sign-executable.ps1 -FilePath "C:\path\to\your.exe" `
    -PfxPath ".\certs\ainative-studio-codesign.pfx" `
    -PfxPassword "YourPassword"
```

### Verify Signature
```powershell
Get-AuthenticodeSignature -FilePath "C:\path\to\signed.exe"
```

## Trust the Certificate (Optional)

To avoid security warnings on your local machine:

### For Current User
```powershell
Import-Certificate -FilePath ".\certs\ainative-studio-codesign.cer" `
    -CertStoreLocation "Cert:\CurrentUser\TrustedPublisher"
```

### For All Users (Admin Required)
```powershell
Import-Certificate -FilePath ".\certs\ainative-studio-codesign.cer" `
    -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"

Import-Certificate -FilePath ".\certs\ainative-studio-codesign.cer" `
    -CertStoreLocation "Cert:\LocalMachine\Root"
```

## Security Best Practices

### DO:
- ✅ Use the secure script (`create-self-signed-cert-secure.ps1`)
- ✅ Let the script generate a strong password
- ✅ Store the password in a password manager
- ✅ Use GitHub secrets for CI/CD
- ✅ Rotate certificates every 1-2 years

### DON'T:
- ❌ Commit PFX files to version control
- ❌ Share passwords in plain text
- ❌ Use weak passwords
- ❌ Leave certificates on shared systems
- ❌ Ignore certificate expiration

## Troubleshooting

### "Script cannot be loaded"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Access denied" errors
- Run PowerShell as Administrator
- Check file permissions on output directory

### Certificate not found for signing
```powershell
# List all code signing certificates
Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
```

### Signature shows as "Unknown" or "Not trusted"
This is normal for self-signed certificates. To be fully trusted:
1. Import the CER file to Trusted Publishers (see above)
2. Or purchase an EV certificate from a trusted CA

## GitHub Actions Workflow

Your workflows are already configured! Once you add the secrets:
1. Push code to trigger a build
2. Workflows automatically sign Windows executables
3. Download artifacts - they'll be signed
4. Check Properties → Digital Signatures on any EXE

## For Production Releases

Consider purchasing an Extended Validation (EV) code signing certificate from:
- DigiCert ($499-699/year)
- Sectigo ($299-499/year)
- GlobalSign ($359-599/year)
- Certum ($129-329/year)

EV certificates provide:
- Immediate SmartScreen reputation
- No security warnings for users
- Professional trust indicators
- Hardware token security

## Support

If you encounter issues:
1. Check `.\certs\certificate-info.md` for details
2. Verify certificate in store: `certmgr.msc`
3. Test with the `test-signing-local.ps1` script
4. Review workflow logs in GitHub Actions