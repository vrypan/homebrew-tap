class OgImg < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og-img"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.0/og-img-aarch64-apple-darwin.tar.xz"
      sha256 "02adc05456e3c13d2db728029a586790a2e20a21fdbde6e7d32c4148a83d34d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.0/og-img-x86_64-apple-darwin.tar.xz"
      sha256 "e5ef38f70c5896997f3d21ca7c68fd37d96ecd7d1efd1f3722a864e514ad9d43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.0/og-img-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8a96a44d0b63aff1f391882c5c73339f31c28635def30c9e30bb52d4e67473c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.0/og-img-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f05b5ebc1155f4fbc220e18ea67b4158fde1b4d265fc70d72b62d34573441c8"
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
