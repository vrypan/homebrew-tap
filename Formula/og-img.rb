class OgImg < Formula
  desc "A small CLI for generating OpenGraph card images for blog posts and static sites"
  homepage "https://github.com/vrypan/og-img"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.2/og-img-aarch64-apple-darwin.tar.xz"
      sha256 "64586dac20c83a32acdc4897236f24e2e94547d46a2c907e34fc946ef6c060da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.2/og-img-x86_64-apple-darwin.tar.xz"
      sha256 "c243dd75661ad5c72bae82d00619f2b199029c96eb67feca05522eeef6d38dc3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.2/og-img-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "486e3ec41a80017e3af8026a2c444fc7ee4fd39980d0f3972c7cc0b43ca790f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/og-img/releases/download/v0.2.2/og-img-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88f8256736e21a35ccee46790d81db9f83f0dc92a7c32d7fd43fa2fb69981df9"
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
