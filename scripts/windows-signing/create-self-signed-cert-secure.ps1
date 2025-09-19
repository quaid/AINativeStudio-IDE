# Create-Self-Signed-Cert-Secure.ps1
# Creates a self-signed code signing certificate optimized for GitHub Actions
# This script is designed to run on Windows and generate everything needed for CI/CD

#Requires -Version 5.1

param(
    [Parameter(Mandatory=$false)]
    [string]$CertName = "AINative Studio Code Signing",

    [Parameter(Mandatory=$false)]
    [string]$Organization = "AINative Studio",

    [Parameter(Mandatory=$false)]
    [ValidatePattern('^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$')]
    [string]$Password,

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\certs",

    [Parameter(Mandatory=$false)]
    [ValidateRange(1, 10)]
    [int]$ValidYears = 5,

    [Parameter(Mandatory=$false)]
    [switch]$InstallTrusted = $false,

    [Parameter(Mandatory=$false)]
    [switch]$GenerateGitHubFiles = $true
)

# Generate secure password if not provided
if (-not $Password) {
    Add-Type -AssemblyName System.Web
    $Password = [System.Web.Security.Membership]::GeneratePassword(16, 4)
    Write-Host "Generated secure password: $Password" -ForegroundColor Yellow
    Write-Host "IMPORTANT: Save this password securely!" -ForegroundColor Red
}

# Banner
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host " AINative Studio Certificate Generator" -ForegroundColor Cyan
Write-Host "      Secure Edition for CI/CD" -ForegroundColor Gray
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Host "ERROR: PowerShell execution policy is restricted." -ForegroundColor Red
    Write-Host "Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Create output directory
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Gray
}

# Clean up existing certificates with same name
Write-Host "Checking for existing certificates..." -ForegroundColor Yellow
$existingCerts = @()
$existingCerts += Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert -ErrorAction SilentlyContinue | Where-Object {$_.Subject -like "*$CertName*"}
$existingCerts += Get-ChildItem -Path Cert:\LocalMachine\My -CodeSigningCert -ErrorAction SilentlyContinue | Where-Object {$_.Subject -like "*$CertName*"}

if ($existingCerts.Count -gt 0) {
    Write-Host "Found $($existingCerts.Count) existing certificate(s). Removing..." -ForegroundColor Yellow
    foreach ($oldCert in $existingCerts) {
        try {
            Remove-Item -Path $oldCert.PSPath -Force -ErrorAction SilentlyContinue
            Write-Host "  Removed: $($oldCert.Thumbprint.Substring(0,8))..." -ForegroundColor Gray
        } catch {
            Write-Host "  Could not remove: $($oldCert.Thumbprint.Substring(0,8))..." -ForegroundColor Gray
        }
    }
}

# Create certificate parameters
Write-Host "`nCreating certificate with enhanced security..." -ForegroundColor Green

$certParams = @{
    Type = 'CodeSigningCert'
    Subject = "CN=$CertName, O=$Organization, C=US"
    KeyAlgorithm = 'RSA'
    KeyLength = 4096
    HashAlgorithm = 'SHA256'
    CertStoreLocation = 'Cert:\CurrentUser\My'
    NotAfter = (Get-Date).AddYears($ValidYears)
    KeyUsage = 'DigitalSignature'
    KeySpec = 'Signature'
    KeyExportPolicy = 'Exportable'
    Provider = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
}

# Add extended key usage for code signing
$enhancedKeyUsage = [System.Security.Cryptography.Oid]::new("1.3.6.1.5.5.7.3.3")
$certParams['TextExtension'] = @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")

# Create certificate
try {
    $cert = New-SelfSignedCertificate @certParams
    Write-Host "✅ Certificate created successfully!" -ForegroundColor Green
    Write-Host "   Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
    Write-Host "   Valid until: $($cert.NotAfter.ToString('yyyy-MM-dd'))" -ForegroundColor Gray
} catch {
    Write-Host "❌ Failed to create certificate: $_" -ForegroundColor Red
    exit 1
}

# Export PFX with strong encryption
Write-Host "`nExporting certificate files..." -ForegroundColor Yellow
$pfxPath = Join-Path $OutputPath "ainative-studio-codesign.pfx"
$securePassword = ConvertTo-SecureString -String $Password -Force -AsPlainText

try {
    # Export with full certificate chain
    Export-PfxCertificate `
        -Cert $cert `
        -FilePath $pfxPath `
        -Password $securePassword `
        -ChainOption BuildChain `
        -CryptoAlgorithmOption AES256_SHA256 | Out-Null

    Write-Host "✅ PFX exported: $pfxPath" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to export PFX: $_" -ForegroundColor Red
    exit 1
}

# Export public certificate
$cerPath = Join-Path $OutputPath "ainative-studio-codesign.cer"
try {
    Export-Certificate -Cert $cert -FilePath $cerPath -Type CERT | Out-Null
    Write-Host "✅ CER exported: $cerPath" -ForegroundColor Green
} catch {
    Write-Host "Warning: Could not export CER file: $_" -ForegroundColor Yellow
}

# Generate GitHub Actions files
if ($GenerateGitHubFiles) {
    Write-Host "`nGenerating GitHub Actions configuration..." -ForegroundColor Cyan

    # Convert to Base64
    try {
        $pfxBytes = [System.IO.File]::ReadAllBytes($pfxPath)
        $base64String = [System.Convert]::ToBase64String($pfxBytes)

        # Save base64 to file
        $base64Path = Join-Path $OutputPath "github-cert-base64.txt"
        [System.IO.File]::WriteAllText($base64Path, $base64String)
        Write-Host "✅ Base64 certificate saved: $base64Path" -ForegroundColor Green

        # Create GitHub CLI commands script
        $ghScriptPath = Join-Path $OutputPath "setup-github-secrets.ps1"
        @"
# GitHub CLI commands to set up secrets
# Requires GitHub CLI (gh) to be installed and authenticated

`$repoName = Read-Host "Enter repository name (format: owner/repo)"

Write-Host "Setting up GitHub secrets for `$repoName..." -ForegroundColor Cyan

# Read base64 certificate
`$base64Cert = Get-Content "$base64Path" -Raw

# Set certificate secret
gh secret set WINDOWS_CERTIFICATE_BASE64 --repo `$repoName --body `$base64Cert
if (`$?) {
    Write-Host "✅ WINDOWS_CERTIFICATE_BASE64 secret created" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create WINDOWS_CERTIFICATE_BASE64 secret" -ForegroundColor Red
}

# Set password secret
gh secret set WINDOWS_CERTIFICATE_PASSWORD --repo `$repoName --body "$Password"
if (`$?) {
    Write-Host "✅ WINDOWS_CERTIFICATE_PASSWORD secret created" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create WINDOWS_CERTIFICATE_PASSWORD secret" -ForegroundColor Red
}

Write-Host "`nSecrets configuration complete!" -ForegroundColor Green
"@ | Out-File -FilePath $ghScriptPath -Encoding UTF8

        Write-Host "✅ GitHub setup script created: $ghScriptPath" -ForegroundColor Green

    } catch {
        Write-Host "Warning: Could not generate GitHub files: $_" -ForegroundColor Yellow
    }
}

# Create comprehensive documentation
$infoPath = Join-Path $OutputPath "certificate-info.md"
@"
# AINative Studio Code Signing Certificate

## Certificate Information
- **Subject:** CN=$CertName, O=$Organization, C=US
- **Thumbprint:** $($cert.Thumbprint)
- **Algorithm:** RSA 4096-bit with SHA256
- **Valid Until:** $($cert.NotAfter.ToString('yyyy-MM-dd HH:mm:ss'))
- **Password:** ``$Password``

## Files Generated
| File | Purpose |
|------|---------|
| ``ainative-studio-codesign.pfx`` | Certificate with private key for signing |
| ``ainative-studio-codesign.cer`` | Public certificate for trust distribution |
| ``github-cert-base64.txt`` | Base64 encoded PFX for GitHub secrets |
| ``setup-github-secrets.ps1`` | Script to configure GitHub repository |

## GitHub Actions Setup

### Option 1: Using GitHub CLI (Recommended)
```powershell
cd $OutputPath
.\setup-github-secrets.ps1
```

### Option 2: Manual Setup
1. Go to: **Settings** → **Secrets and variables** → **Actions**
2. Add secret: ``WINDOWS_CERTIFICATE_BASE64``
   - Copy entire contents of ``github-cert-base64.txt``
3. Add secret: ``WINDOWS_CERTIFICATE_PASSWORD``
   - Value: ``$Password``

## Local Testing
```powershell
# Test signing a file
.\sign-executable.ps1 -FilePath "path\to\file.exe" -Thumbprint "$($cert.Thumbprint)"

# Or use PFX directly
.\sign-executable.ps1 -FilePath "path\to\file.exe" -PfxPath "$pfxPath" -PfxPassword "$Password"
```

## Trust Installation
To trust signed applications:

### For Current User
```powershell
Import-Certificate -FilePath "$cerPath" -CertStoreLocation "Cert:\CurrentUser\TrustedPublisher"
```

### For All Users (Admin Required)
```powershell
Import-Certificate -FilePath "$cerPath" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"
Import-Certificate -FilePath "$cerPath" -CertStoreLocation "Cert:\LocalMachine\Root"
```

## Security Notes
- **NEVER** commit the PFX file or password to version control
- Store the password in a secure password manager
- Rotate certificates every 1-2 years
- For production, use an EV certificate from a trusted CA

## Verification
After signing, verify with:
```powershell
Get-AuthenticodeSignature -FilePath "signed-file.exe"
```

Expected output for self-signed:
- Status: ``Valid`` (locally) or ``UnknownError`` (untrusted)
- SignerCertificate: Shows your certificate details
"@ | Out-File -FilePath $infoPath -Encoding UTF8

Write-Host "✅ Documentation created: $infoPath" -ForegroundColor Green

# Install to trusted stores if requested
if ($InstallTrusted) {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")

    if ($isAdmin) {
        Write-Host "`nInstalling certificate to trusted stores..." -ForegroundColor Yellow
        try {
            Import-Certificate -FilePath $cerPath -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher" | Out-Null
            Write-Host "✅ Installed to Trusted Publishers" -ForegroundColor Green

            Import-Certificate -FilePath $cerPath -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null
            Write-Host "✅ Installed to Trusted Root" -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not install to trusted stores: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "`nNote: Run as Administrator to install certificate to trusted stores" -ForegroundColor Yellow
    }
}

# Summary
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host " ✅ Certificate Generation Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Quick Start for GitHub Actions:" -ForegroundColor Yellow
Write-Host "   1. Run: .\setup-github-secrets.ps1" -ForegroundColor White
Write-Host "   2. Enter your repository name" -ForegroundColor White
Write-Host "   3. Workflows will automatically sign builds" -ForegroundColor White
Write-Host ""
Write-Host "🔐 Certificate Thumbprint:" -ForegroundColor Yellow
Write-Host "   $($cert.Thumbprint)" -ForegroundColor Gray
Write-Host ""
Write-Host "📁 All files saved to:" -ForegroundColor Yellow
Write-Host "   $((Resolve-Path $OutputPath).Path)" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  Security Reminder:" -ForegroundColor Red
Write-Host "   Password saved in certificate-info.md" -ForegroundColor Yellow
Write-Host "   Keep this information secure!" -ForegroundColor Yellow

# Test signing capability
Write-Host "`nTesting signing capability..." -ForegroundColor Cyan
$testFile = Join-Path $env:TEMP "test-sign.txt"
"Test content" | Out-File $testFile

try {
    $testSig = Set-AuthenticodeSignature -FilePath $testFile -Certificate $cert -HashAlgorithm SHA256
    if ($testSig.Status -eq "Valid") {
        Write-Host "✅ Signing test successful!" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Signing test status: $($testSig.Status)" -ForegroundColor Yellow
        Write-Host "   This is normal for self-signed certificates" -ForegroundColor Gray
    }
    Remove-Item $testFile -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "Warning: Could not test signing: $_" -ForegroundColor Yellow
}