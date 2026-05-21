class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.6.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.6.9/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "1135bc385bcccc13464ba348f449576e709f671fb6b3a21d16e8cabb5a31ca44"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.9/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f846d1208c9fb67494f9b96736648895e1ebb6ef74d7dedcf4aa584a19461f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.9/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28bec69ba48bb13789b958d4fba292103164e70e326ae83992952a86a92cf220"
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
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.mac? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.linux? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
