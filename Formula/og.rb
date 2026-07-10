class Og < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og/releases/download/v0.1.2/og-aarch64-apple-darwin.tar.xz"
      sha256 "92626edfd21ea7b67f2b74f6b055bf175a583042476fbc61bda37a125c2416e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og/releases/download/v0.1.2/og-x86_64-apple-darwin.tar.xz"
      sha256 "645abec4f875c96a93f5f7d0172bf2a07a9cda70cec182a8fcfff9b98ab80c97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og/releases/download/v0.1.2/og-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15ce519c6454f91b7d49259e6bd22c35da7114032160b13727f9080d861faf46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og/releases/download/v0.1.2/og-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "57042d6b74b05904e24700e6120ef17d4d23d20d50c02ab4c4abd3b79f592308"
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
