# Sign-Executable.ps1
# Signs Windows executables and installers with code signing certificate
# Can use either certificate from store (thumbprint) or PFX file

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,

    [Parameter(Mandatory=$false)]
    [string]$Thumbprint = "",

    [Parameter(Mandatory=$false)]
    [string]$PfxPath = "",

    [Parameter(Mandatory=$false)]
    [string]$PfxPassword = "",

    [Parameter(Mandatory=$false)]
    [string]$TimestampServer = "http://timestamp.digicert.com",

    [Parameter(Mandatory=$false)]
    [string]$Description = "AINative Studio IDE"
)

function Sign-File {
    param(
        [string]$File,
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
    )

    Write-Host "Signing file: $File" -ForegroundColor Cyan

    try {
        # Build signtool arguments
        $signToolArgs = @(
            "sign",
            "/fd", "SHA256",
            "/td", "SHA256",
            "/tr", $TimestampServer,
            "/d", $Description,
            "/sha1", $Certificate.Thumbprint,
            "`"$File`""
        )

        # Try to find signtool.exe
        $signTool = ""

        # Check Windows SDK locations
        $sdkPaths = @(
            "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe",
            "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.22000.0\x64\signtool.exe",
            "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe",
            "${env:ProgramFiles(x86)}\Windows Kits\10\App Certification Kit\signtool.exe",
            "${env:ProgramFiles}\Windows Kits\10\bin\x64\signtool.exe"
        )

        foreach ($path in $sdkPaths) {
            if (Test-Path $path) {
                $signTool = $path
                break
            }
        }

        # Try to find via where command if not found
        if (!$signTool) {
            try {
                $signTool = (where.exe signtool.exe 2>$null)[0]
            } catch { }
        }

        if (!$signTool -or !(Test-Path $signTool)) {
            # Fallback to PowerShell Set-AuthenticodeSignature
            Write-Host "signtool.exe not found, using PowerShell signing..." -ForegroundColor Yellow

            $result = Set-AuthenticodeSignature -FilePath $File -Certificate $Certificate -TimestampServer $TimestampServer

            if ($result.Status -eq "Valid") {
                Write-Host "Successfully signed: $File" -ForegroundColor Green
                return $true
            } else {
                Write-Host "Failed to sign: $($result.StatusMessage)" -ForegroundColor Red
                return $false
            }
        }

        Write-Host "Using signtool at: $signTool" -ForegroundColor Gray

        # Execute signtool
        $process = Start-Process -FilePath $signTool -ArgumentList $signToolArgs -Wait -PassThru -NoNewWindow

        if ($process.ExitCode -eq 0) {
            Write-Host "Successfully signed: $File" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Signtool failed with exit code: $($process.ExitCode)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error signing file: $_" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host "=== AINative Studio Code Signing ===" -ForegroundColor Cyan

# Validate input file
if (!(Test-Path $FilePath)) {
    Write-Host "Error: File not found: $FilePath" -ForegroundColor Red
    exit 1
}

# Get certificate
$cert = $null

if ($Thumbprint) {
    Write-Host "Loading certificate from store with thumbprint: $Thumbprint" -ForegroundColor Yellow
    $cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.Thumbprint -eq $Thumbprint}

    if (!$cert) {
        # Try LocalMachine store
        $cert = Get-ChildItem -Path Cert:\LocalMachine\My -CodeSigningCert | Where-Object {$_.Thumbprint -eq $Thumbprint}
    }
}
elseif ($PfxPath) {
    Write-Host "Loading certificate from PFX file: $PfxPath" -ForegroundColor Yellow

    if (!(Test-Path $PfxPath)) {
        Write-Host "Error: PFX file not found: $PfxPath" -ForegroundColor Red
        exit 1
    }

    if ($PfxPassword) {
        $securePassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($PfxPath, $securePassword)
    } else {
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($PfxPath)
    }
}
else {
    # Try to find any code signing certificate
    Write-Host "Looking for any available code signing certificate..." -ForegroundColor Yellow
    $cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert | Select-Object -First 1

    if (!$cert) {
        $cert = Get-ChildItem -Path Cert:\LocalMachine\My -CodeSigningCert | Select-Object -First 1
    }
}

if (!$cert) {
    Write-Host "Error: No code signing certificate found!" -ForegroundColor Red
    Write-Host "Please provide either -Thumbprint or -PfxPath parameter" -ForegroundColor Yellow
    exit 1
}

Write-Host "Using certificate: $($cert.Subject)" -ForegroundColor Green
Write-Host "Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray

# Handle wildcards and multiple files
$files = Get-ChildItem -Path $FilePath -File
$successCount = 0
$failCount = 0

foreach ($file in $files) {
    if (Sign-File -File $file.FullName -Certificate $cert) {
        $successCount++
    } else {
        $failCount++
    }
}

# Summary
Write-Host "`n=== Signing Summary ===" -ForegroundColor Cyan
Write-Host "Successfully signed: $successCount file(s)" -ForegroundColor Green

if ($failCount -gt 0) {
    Write-Host "Failed to sign: $failCount file(s)" -ForegroundColor Red
    exit 1
}

Write-Host "Code signing complete!" -ForegroundColor Green