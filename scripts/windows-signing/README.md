# Windows Code Signing for AINative Studio

This directory contains scripts for self-signing Windows executables and installers for AINative Studio IDE.

## Quick Setup

### 1. Generate a Self-Signed Certificate (One-time setup)

Run PowerShell as Administrator:

```powershell
cd scripts/windows-signing
.\create-self-signed-cert.ps1
```

This creates:
- `certs/ainative-studio-codesign.pfx` - Certificate with private key (for signing)
- `certs/ainative-studio-codesign.cer` - Public certificate (for trust)
- `certs/certificate-info.txt` - Certificate details and instructions

### 2. Configure GitHub Actions

1. Convert the PFX to base64:
```powershell
[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('certs\ainative-studio-codesign.pfx'))
```

2. Add these secrets to your GitHub repository:
   - `WINDOWS_CERTIFICATE_BASE64` - The base64 string from step 1
   - `WINDOWS_CERTIFICATE_PASSWORD` - Default: `AINativeStudio2024!`

Go to: Settings → Secrets and variables → Actions → New repository secret

### 3. Sign Files Locally

To sign executables locally:

```powershell
# Sign using thumbprint (certificate in store)
.\sign-executable.ps1 -FilePath "path\to\AINativeStudio.exe" -Thumbprint "YOUR_CERT_THUMBPRINT"

# Sign using PFX file
.\sign-executable.ps1 -FilePath "path\to\AINativeStudio.exe" -PfxPath "certs\ainative-studio-codesign.pfx" -PfxPassword "AINativeStudio2024!"

# Sign multiple files
.\sign-executable.ps1 -FilePath "path\to\*.exe"
```

## Trust the Certificate

For users to avoid security warnings:

### Option 1: Import to Trusted Publishers (Admin required)
```powershell
Import-Certificate -FilePath "ainative-studio-codesign.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"
```

### Option 2: User-level trust
Double-click the `.cer` file and follow the wizard to install to "Trusted Publishers"

## GitHub Actions Integration

The workflows automatically:
1. Import the certificate from secrets
2. Sign the main executable (`AINativeStudio.exe`)
3. Sign Node.js runtime (`node.exe`)
4. Sign CLI tool (`bin/code.exe`)
5. Sign both User and System installers
6. Clean up certificate after signing

## Certificate Details

- **Algorithm**: RSA 4096-bit with SHA256
- **Validity**: 5 years from creation
- **Purpose**: Code Signing
- **Subject**: CN=AINative Studio Code Signing, O=AINative Studio, C=US

## Security Notes

1. **Never commit** the PFX file or password to the repository
2. **Store securely** the PFX file and password
3. **Rotate certificates** periodically (every 1-2 years)
4. For production, consider purchasing an EV Code Signing certificate from a trusted CA

## Troubleshooting

### Certificate not found
- Ensure the certificate is in the correct store: `Cert:\CurrentUser\My`
- Check thumbprint matches: `Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert`

### Signing fails
- Ensure you have Windows SDK installed (for signtool.exe)
- Try running PowerShell as Administrator
- Check certificate hasn't expired: `(Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert).NotAfter`

### Users still see warnings
- Certificate needs to be in Trusted Publishers store
- For downloaded files, Windows adds Mark of the Web (MOTW)
- ZIP packages help avoid MOTW warnings

## Alternative: Using a Trusted CA Certificate

For production releases, consider purchasing a code signing certificate from:
- DigiCert
- Sectigo (formerly Comodo)
- GlobalSign
- Certum

Replace the self-signed certificate steps with your CA certificate.