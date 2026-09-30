class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.8.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.8.2/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "3cf1cc202f293f3ab97610c3e8ce787ba506b77924cb65b98dbe37db28a7b8ac"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.8.2/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "63893809613d0bf7bf0c1fb54517ba2ab8b7298e2db31aeec2d9ba72f4816309"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.8.2/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5a3809d79b96c9c4b898373a073dd08d56c11f702e8bfd85ab976be06d46f0c4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bckt", "bckt-new"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bckt", "bckt-new"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bckt", "bckt-new"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
