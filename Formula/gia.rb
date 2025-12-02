class Gia < Formula
  desc "GIA - General Intelligence Assistant"
  homepage "https://github.com/panjamo/gia"
  version "0.1.200"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/panjamo/gia/releases/download/v0.1.200/gia-macos-x86_64-v0.1.200.tar.gz"
    sha256 "c439099bd59b67ce3de8b8875364fe0c9a208f654f626cb883cb6f82b10a01fe"
  else
    url "https://github.com/panjamo/gia/releases/download/v0.1.200/gia-macos-aarch64-v0.1.200.tar.gz"
    sha256 "a664efc6659c150be58bc0d941858e5357b0df20ca24043348689fa8efbd1837"
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
