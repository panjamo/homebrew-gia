class Gia < Formula
  desc "GIA - General Intelligence Assistant"
  homepage "https://github.com/panjamo/gia"
  version "0.1.226"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/panjamo/gia/releases/download/v0.1.226/gia-macos-x86_64-v0.1.226.tar.gz"
    sha256 "3c42cd08d50ab66dfc4275b918bedcd2f86c82bd4e034e2bd281d3ee1677f5d5"
  else
    url "https://github.com/panjamo/gia/releases/download/v0.1.226/gia-macos-aarch64-v0.1.226.tar.gz"
    sha256 "1367da0893869ea2ee1d14787dec32cec6f24ed62c0d100bc34c94bd26d1ac5b"
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
