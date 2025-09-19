# Create-Self-Signed-Certificate.ps1
# Creates a self-signed code signing certificate for AINative Studio
# This certificate can be used for development and testing purposes

param(
    [Parameter(Mandatory=$false)]
    [string]$CertName = "AINative Studio Code Signing",

    [Parameter(Mandatory=$false)]
    [string]$Password = "AINativeStudio2024!",

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\certs",

    [Parameter(Mandatory=$false)]
    [int]$ValidYears = 5
)

Write-Host "Creating self-signed code signing certificate..." -ForegroundColor Green

# Create output directory if it doesn't exist
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# Create the certificate
$cert = New-SelfSignedCertificate `
    -Type CodeSigningCert `
    -Subject "CN=$CertName, O=AINative Studio, C=US" `
    -KeyAlgorithm RSA `
    -KeyLength 4096 `
    -HashAlgorithm SHA256 `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -NotAfter (Get-Date).AddYears($ValidYears) `
    -KeyUsage DigitalSignature `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")

Write-Host "Certificate created with thumbprint: $($cert.Thumbprint)" -ForegroundColor Yellow

# Export certificate to PFX file
$pfxPath = Join-Path $OutputPath "ainative-studio-codesign.pfx"
$securePassword = ConvertTo-SecureString -String $Password -Force -AsPlainText

Export-PfxCertificate `
    -Cert $cert `
    -FilePath $pfxPath `
    -Password $securePassword | Out-Null

Write-Host "Certificate exported to: $pfxPath" -ForegroundColor Green

# Export public certificate (CER)
$cerPath = Join-Path $OutputPath "ainative-studio-codesign.cer"
Export-Certificate `
    -Cert $cert `
    -FilePath $cerPath `
    -Type CERT | Out-Null

Write-Host "Public certificate exported to: $cerPath" -ForegroundColor Green

# Create a certificate info file
$infoPath = Join-Path $OutputPath "certificate-info.txt"
@"
AINative Studio Self-Signed Certificate Information
====================================================
Certificate Name: $CertName
Thumbprint: $($cert.Thumbprint)
Valid Until: $($cert.NotAfter)
PFX Password: $Password

Files Created:
- ainative-studio-codesign.pfx : Certificate with private key (for signing)
- ainative-studio-codesign.cer : Public certificate (for distribution/trust)

To use this certificate:
1. For GitHub Actions: Add the PFX file as a base64 secret
2. For local signing: Import the PFX to your certificate store
3. To trust signed apps: Import the CER file to Trusted Publishers

GitHub Actions Setup:
---------------------
1. Convert PFX to base64:
   [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('$pfxPath'))

2. Add as GitHub secret:
   - WINDOWS_CERTIFICATE_BASE64: The base64 string
   - WINDOWS_CERTIFICATE_PASSWORD: $Password
"@ | Out-File -FilePath $infoPath -Encoding UTF8

Write-Host "`nCertificate information saved to: $infoPath" -ForegroundColor Cyan
Write-Host "`nIMPORTANT: Store the PFX file and password securely!" -ForegroundColor Yellow
Write-Host "The certificate is now in your personal certificate store and exported to files." -ForegroundColor Green

# Optionally install to Trusted Root (requires admin)
$installToTrusted = Read-Host "`nInstall certificate to Trusted Publishers? (requires admin) [y/N]"
if ($installToTrusted -eq 'y' -or $installToTrusted -eq 'Y') {
    try {
        # Check for admin rights
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

        if (!$isAdmin) {
            Write-Host "Restarting script as administrator..." -ForegroundColor Yellow
            Start-Process PowerShell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -CertName `"$CertName`" -Password `"$Password`" -OutputPath `"$OutputPath`" -ValidYears $ValidYears"
            exit
        }

        # Import to Trusted Publishers
        Import-Certificate -FilePath $cerPath -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"
        Write-Host "Certificate installed to Trusted Publishers!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install to Trusted Publishers: $_" -ForegroundColor Red
    }
}

Write-Host "`nCertificate creation complete!" -ForegroundColor Green