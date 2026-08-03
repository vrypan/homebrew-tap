class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.8.0/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "f668a1aa7064debcc8ea5339536a8e199409c70b848d3daab762981e94582653"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.8.0/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db66ba0da01fdb6d07ea24cf526ce8170b8730b9f0338d97026bd83217bd96c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.8.0/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a86d2ea87c88d4d2a47ca4daba633b98d849491ba8219d0a21ee1a9595d2a428"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "bckt", "bckt-new" if OS.mac? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-new" if OS.linux? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-new" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
