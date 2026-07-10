class OgImg < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og-img"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.1/og-img-aarch64-apple-darwin.tar.xz"
      sha256 "8f0d9fc0f376748ef1b6af0b773099829a831de2ce51033e001ca2c4a0c8e726"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.1/og-img-x86_64-apple-darwin.tar.xz"
      sha256 "fe3e0bb41c3c5847f546f050bef30eab8557e64550b399a2923a194379d8441d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.1/og-img-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "689273085799c785854c076c1e6cd09a613f5de0c3851dbaa156b46fcff69011"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.1/og-img-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "327acf3d9c88df6884d4b2c0edad6e382553914bc2ae76a64be234aca6d23775"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "og" if OS.mac? && Hardware::CPU.arm?
    bin.install "og" if OS.mac? && Hardware::CPU.intel?
    bin.install "og" if OS.linux? && Hardware::CPU.arm?
    bin.install "og" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
