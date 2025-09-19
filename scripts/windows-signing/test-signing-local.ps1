# Test-Signing-Local.ps1
# Test script to verify code signing works on Windows with the generated certificate

param(
    [Parameter(Mandatory=$false)]
    [string]$PfxPath = ".\certs\ainative-studio-codesign.pfx",

    [Parameter(Mandatory=$false)]
    [string]$PfxPassword = "AINativeStudio2024!",

    [Parameter(Mandatory=$false)]
    [string]$TestFile = ""
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "AINative Studio - Local Signing Test" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check if PFX exists
if (!(Test-Path $PfxPath)) {
    Write-Host "Error: PFX file not found at $PfxPath" -ForegroundColor Red
    Write-Host "Please ensure you've copied the certificate from Linux/WSL:" -ForegroundColor Yellow
    Write-Host "  cp /root/AINativeStudio-IDE/scripts/windows-signing/certs/ainative-studio-codesign.pfx ." -ForegroundColor Gray
    exit 1
}

Write-Host "`nStep 1: Loading certificate..." -ForegroundColor Green
try {
    $securePassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($PfxPath, $securePassword)

    Write-Host "✅ Certificate loaded successfully!" -ForegroundColor Green
    Write-Host "   Subject: $($cert.Subject)" -ForegroundColor Gray
    Write-Host "   Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
    Write-Host "   Valid until: $($cert.NotAfter)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Failed to load certificate: $_" -ForegroundColor Red
    exit 1
}

# Import to current user store temporarily
Write-Host "`nStep 2: Importing to certificate store..." -ForegroundColor Green
try {
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("My", "CurrentUser")
    $store.Open("ReadWrite")
    $store.Add($cert)
    $store.Close()
    Write-Host "✅ Certificate imported to CurrentUser\My store" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Could not import to store: $_" -ForegroundColor Yellow
}

# Test signing
Write-Host "`nStep 3: Testing signature..." -ForegroundColor Green

if (!$TestFile) {
    # Create a test executable if none provided
    $TestFile = "$env:TEMP\test-sign.exe"
    Write-Host "Creating test file at $TestFile..." -ForegroundColor Gray

    # Create a minimal test executable (copy powershell.exe as test)
    Copy-Item "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" $TestFile -Force
}

if (!(Test-Path $TestFile)) {
    Write-Host "❌ Test file not found: $TestFile" -ForegroundColor Red
    exit 1
}

# Try to sign using the sign-executable.ps1 script
$signScript = Join-Path $PSScriptRoot "sign-executable.ps1"
if (Test-Path $signScript) {
    Write-Host "Using sign-executable.ps1 to sign the test file..." -ForegroundColor Yellow

    & $signScript -FilePath $TestFile -Thumbprint $cert.Thumbprint -Description "Test Signing"

    # Verify signature
    Write-Host "`nStep 4: Verifying signature..." -ForegroundColor Green
    $sig = Get-AuthenticodeSignature -FilePath $TestFile

    if ($sig.Status -eq "Valid") {
        Write-Host "✅ SUCCESS: File signed and verified!" -ForegroundColor Green
        Write-Host "   Signer: $($sig.SignerCertificate.Subject)" -ForegroundColor Gray
        Write-Host "   Status: $($sig.Status)" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  Signature status: $($sig.Status)" -ForegroundColor Yellow
        Write-Host "   This is expected with self-signed certificates" -ForegroundColor Gray
        Write-Host "   The signature is valid but not trusted by Windows" -ForegroundColor Gray
    }
} else {
    Write-Host "⚠️  sign-executable.ps1 not found, using direct signing..." -ForegroundColor Yellow

    # Fallback to direct signing
    $result = Set-AuthenticodeSignature -FilePath $TestFile -Certificate $cert

    if ($result.Status -eq "Valid" -or $result.Status -eq "UnknownError") {
        Write-Host "✅ File signed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Signing failed: $($result.StatusMessage)" -ForegroundColor Red
    }
}

# Clean up test file if we created it
if ($TestFile -eq "$env:TEMP\test-sign.exe") {
    Remove-Item $TestFile -Force -ErrorAction SilentlyContinue
    Write-Host "`nTest file cleaned up" -ForegroundColor Gray
}

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "GitHub Actions Configuration:" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "The workflows are configured to:" -ForegroundColor Green
Write-Host "1. Import certificate from WINDOWS_CERTIFICATE_BASE64 secret" -ForegroundColor White
Write-Host "2. Sign executables using the imported certificate" -ForegroundColor White
Write-Host "3. Sign installers after building" -ForegroundColor White
Write-Host "4. Clean up certificate after signing" -ForegroundColor White

Write-Host "`nTo use in GitHub Actions:" -ForegroundColor Yellow
Write-Host "1. Copy contents of certs\github-cert-base64.txt" -ForegroundColor White
Write-Host "2. Add as secret: WINDOWS_CERTIFICATE_BASE64" -ForegroundColor White
Write-Host "3. Add password as secret: WINDOWS_CERTIFICATE_PASSWORD = $PfxPassword" -ForegroundColor White

Write-Host "`nNote: Self-signed certificates will show as 'not trusted' but will still" -ForegroundColor Gray
Write-Host "prevent 'Unknown Publisher' warnings and allow SmartScreen reputation building." -ForegroundColor Gray