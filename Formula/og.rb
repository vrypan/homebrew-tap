class Og < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og/releases/download/v0.1.3/og-aarch64-apple-darwin.tar.xz"
      sha256 "e489c60d50a9888a1929de0494e4e712727fe29b91c469ced7f567ba6ece2107"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og/releases/download/v0.1.3/og-x86_64-apple-darwin.tar.xz"
      sha256 "5f18d906879f8eee2ca6d2efad89c7706885c218d62bed3fa43f00a89d7ec725"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og/releases/download/v0.1.3/og-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdd63b37872f3e99e103a5165a7aea34180e03c54eca48e4dcd0be0a53747de0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og/releases/download/v0.1.3/og-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69af051f7c2976b2ebf0580b03eafe944d9f990724f9312d4c0998c03121958f"
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
