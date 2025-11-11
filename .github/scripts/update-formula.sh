#!/bin/bash
set -e

# Validate required environment variables
FORMULA="${FORMULA:?FORMULA environment variable is required}"
VERSION="${VERSION:?VERSION environment variable is required}"
FORMULA_FILE="Formula/${FORMULA}.rb"

echo "Updating formula: $FORMULA to version: $VERSION"

# Verify formula file exists
if [ ! -f "$FORMULA_FILE" ]; then
  echo "Error: Formula file $FORMULA_FILE not found"
  exit 1
fi

# Validate version format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format. Expected: X.Y.Z, got: $VERSION"
  exit 1
fi

# Define release URLs
INTEL_URL="https://github.com/panjamo/gia/releases/download/v${VERSION}/gia-macos-x86_64-v${VERSION}.tar.gz"
ARM_URL="https://github.com/panjamo/gia/releases/download/v${VERSION}/gia-macos-aarch64-v${VERSION}.tar.gz"

# Check if release assets exist
echo "Checking if release assets exist..."
if ! curl --output /dev/null --silent --head --fail "$INTEL_URL"; then
  echo "Error: Intel release asset not found at $INTEL_URL"
  exit 1
fi

if ! curl --output /dev/null --silent --head --fail "$ARM_URL"; then
  echo "Error: ARM release asset not found at $ARM_URL"
  exit 1
fi

# Download and calculate SHA256 for Intel (x86_64)
echo "Calculating SHA256 for Intel (x86_64)..."
INTEL_SHA256=$(curl -sL "$INTEL_URL" | shasum -a 256 | awk '{print $1}')
echo "Intel SHA256: $INTEL_SHA256"

# Download and calculate SHA256 for ARM (aarch64)
echo "Calculating SHA256 for ARM (aarch64)..."
ARM_SHA256=$(curl -sL "$ARM_URL" | shasum -a 256 | awk '{print $1}')
echo "ARM SHA256: $ARM_SHA256"

# Create updated formula
cat > "${FORMULA_FILE}" << EOF
class Gia < Formula
  desc "GIA - General Intelligence Assistant"
  homepage "https://github.com/panjamo/gia"
  version "${VERSION}"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/panjamo/gia/releases/download/v${VERSION}/gia-macos-x86_64-v${VERSION}.tar.gz"
    sha256 "${INTEL_SHA256}"
  else
    url "https://github.com/panjamo/gia/releases/download/v${VERSION}/gia-macos-aarch64-v${VERSION}.tar.gz"
    sha256 "${ARM_SHA256}"
  end

  def install
    # Binaries installieren
    bin.install "gia"
    bin.install "giagui"
  end

  def post_install
    # Ausführbar machen (normalerweise nicht nötig, da bin.install das macht)
    chmod 0755, bin/"gia"
    chmod 0755, bin/"giagui"

    # Aus Gatekeeper-Quarantäne entfernen
    system "xattr", "-d", "com.apple.quarantine", bin/"gia" rescue nil
    system "xattr", "-d", "com.apple.quarantine", bin/"giagui" rescue nil
  end

  def caveats
    <<~EOS
      Die Programme gia und giagui wurden installiert.

      Falls beim ersten Start eine Gatekeeper-Warnung erscheint,
      kannst du die Programme manuell freigeben mit:

        sudo xattr -d com.apple.quarantine #{bin}/gia
        sudo xattr -d com.apple.quarantine #{bin}/giagui
    EOS
  end

  test do
    # Einfacher Test, ob die Binaries ausführbar sind
    assert_match version.to_s, shell_output("#{bin}/gia --version")
  end
end
EOF

echo "Formula updated successfully to version ${VERSION}"
echo ""
echo "Updated formula preview:"
cat "${FORMULA_FILE}"
