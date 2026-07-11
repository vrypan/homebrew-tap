class OgImg < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og-img"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.3/og-img-aarch64-apple-darwin.tar.xz"
      sha256 "140e3318e143d60caa819fb9287778b8127697824bf9012161bcdfaf4d18bab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.3/og-img-x86_64-apple-darwin.tar.xz"
      sha256 "efc0445bda47ce3b01569e1c142fe95fe46cc1996c2668b86dd42e1a034679db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.3/og-img-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fdd8181db91512c3211004d2b09b8ac9f82b22da7d7316334f44275e3b45cb6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.3/og-img-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98d4c4e0e22ab6e3441d7261b37a8fad39e2693a018a1a6485504eab6304afcc"
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
