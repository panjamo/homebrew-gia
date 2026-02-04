class Gia < Formula
  desc "GIA - General Intelligence Assistant"
  homepage "https://github.com/panjamo/gia"
  version "0.1.208"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/panjamo/gia/releases/download/v0.1.208/gia-macos-x86_64-v0.1.208.tar.gz"
    sha256 "825d98a4be5b88c6f7837485eef3beee588772a09c73e3c6b7e11d4636fa0c9b"
  else
    url "https://github.com/panjamo/gia/releases/download/v0.1.208/gia-macos-aarch64-v0.1.208.tar.gz"
    sha256 "e1c7ead6b02e0c3c2d6ffd7beb7e152a580b803f829a703b171372cf8b87fc48"
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
