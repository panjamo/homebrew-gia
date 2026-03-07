class Gia < Formula
  desc "GIA - General Intelligence Assistant"
  homepage "https://github.com/panjamo/gia"
  version "0.1.210"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/panjamo/gia/releases/download/v0.1.210/gia-macos-x86_64-v0.1.210.tar.gz"
    sha256 "a1bd5f577f5c1fe5f1821da779b9c364b0839c34fd7076593ccdff32ce5d8b53"
  else
    url "https://github.com/panjamo/gia/releases/download/v0.1.210/gia-macos-aarch64-v0.1.210.tar.gz"
    sha256 "80c5c2d8401cca9c8a3747408a5259b6c0d01245c8e6cfee69c7742eb809ea96"
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
