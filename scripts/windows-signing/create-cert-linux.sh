#!/bin/bash

# Create self-signed code signing certificate for Windows on Linux
# This script creates a certificate that can be used for signing Windows executables

set -e

# Configuration
CERT_NAME="${CERT_NAME:-AINative Studio Code Signing}"
CERT_ORG="${CERT_ORG:-AINative Studio}"
CERT_COUNTRY="${CERT_COUNTRY:-US}"
CERT_PASSWORD="${CERT_PASSWORD:-AINativeStudio2024!}"
CERT_VALIDITY_DAYS="${CERT_VALIDITY_DAYS:-1825}"  # 5 years
OUTPUT_DIR="${OUTPUT_DIR:-./certs}"

echo "======================================"
echo "Creating Self-Signed Certificate for Windows Code Signing"
echo "======================================"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Generate private key
echo "Generating RSA 4096-bit private key..."
openssl genrsa -out "$OUTPUT_DIR/private.key" 4096

# Create certificate configuration
cat > "$OUTPUT_DIR/cert.conf" << EOF
[ req ]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_req

[ dn ]
C=$CERT_COUNTRY
O=$CERT_ORG
CN=$CERT_NAME

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = codeSigning
subjectKeyIdentifier = hash
EOF

# Generate certificate
echo "Creating certificate..."
openssl req -new -x509 -key "$OUTPUT_DIR/private.key" \
    -out "$OUTPUT_DIR/certificate.crt" \
    -days $CERT_VALIDITY_DAYS \
    -config "$OUTPUT_DIR/cert.conf"

# Create PFX/P12 file for Windows
echo "Creating PFX file for Windows..."
openssl pkcs12 -export \
    -out "$OUTPUT_DIR/ainative-studio-codesign.pfx" \
    -inkey "$OUTPUT_DIR/private.key" \
    -in "$OUTPUT_DIR/certificate.crt" \
    -password pass:"$CERT_PASSWORD" \
    -name "$CERT_NAME"

# Export public certificate in DER format (Windows .cer)
echo "Creating CER file..."
openssl x509 -in "$OUTPUT_DIR/certificate.crt" \
    -outform DER \
    -out "$OUTPUT_DIR/ainative-studio-codesign.cer"

# Get certificate thumbprint (SHA1 for Windows compatibility)
THUMBPRINT=$(openssl x509 -in "$OUTPUT_DIR/certificate.crt" -fingerprint -sha1 -noout | sed 's/SHA1 Fingerprint=//' | sed 's/://g')

# Convert PFX to base64 for GitHub Actions
echo "Converting PFX to base64 for GitHub Actions..."
BASE64_CERT=$(base64 -w 0 "$OUTPUT_DIR/ainative-studio-codesign.pfx")

# Create info file
cat > "$OUTPUT_DIR/certificate-info.txt" << EOF
AINative Studio Self-Signed Certificate Information
====================================================
Certificate Name: $CERT_NAME
Organization: $CERT_ORG
Thumbprint (SHA1): $THUMBPRINT
Valid For: $CERT_VALIDITY_DAYS days
PFX Password: $CERT_PASSWORD

Files Created:
--------------
- ainative-studio-codesign.pfx : Certificate with private key (for signing)
- ainative-studio-codesign.cer : Public certificate (for distribution/trust)
- certificate.crt : Certificate in PEM format
- private.key : Private key in PEM format

GitHub Actions Setup:
--------------------
1. Add these as repository secrets:
   - WINDOWS_CERTIFICATE_BASE64
   - WINDOWS_CERTIFICATE_PASSWORD

2. The base64 certificate has been saved to:
   $OUTPUT_DIR/github-cert-base64.txt

3. Copy the contents of github-cert-base64.txt to WINDOWS_CERTIFICATE_BASE64 secret
4. Set WINDOWS_CERTIFICATE_PASSWORD to: $CERT_PASSWORD

Local Windows Usage:
-------------------
1. Copy ainative-studio-codesign.pfx to your Windows machine
2. Double-click to install or use with PowerShell signing script
3. Password: $CERT_PASSWORD

Trust Certificate:
-----------------
To trust signed applications, install ainative-studio-codesign.cer:
- On Windows: Double-click and install to "Trusted Publishers"
- Via PowerShell (Admin): Import-Certificate -FilePath "ainative-studio-codesign.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"
EOF

# Save base64 certificate for easy copying
echo "$BASE64_CERT" > "$OUTPUT_DIR/github-cert-base64.txt"

# Display summary
echo ""
echo "✅ Certificate created successfully!"
echo "======================================"
echo "Certificate Details:"
echo "  Subject: CN=$CERT_NAME, O=$CERT_ORG, C=$CERT_COUNTRY"
echo "  Thumbprint: $THUMBPRINT"
echo "  Valid for: $CERT_VALIDITY_DAYS days"
echo ""
echo "📁 Output Directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
echo "  - ainative-studio-codesign.pfx (for signing)"
echo "  - ainative-studio-codesign.cer (for trust)"
echo "  - github-cert-base64.txt (for GitHub Actions)"
echo "  - certificate-info.txt (documentation)"
echo ""
echo "📋 Next Steps:"
echo "1. Copy contents of $OUTPUT_DIR/github-cert-base64.txt"
echo "2. Add as GitHub secret: WINDOWS_CERTIFICATE_BASE64"
echo "3. Add password as secret: WINDOWS_CERTIFICATE_PASSWORD = $CERT_PASSWORD"
echo ""
echo "⚠️  Security: Keep the PFX file and password secure!"

# Clean up temporary files
rm -f "$OUTPUT_DIR/cert.conf"