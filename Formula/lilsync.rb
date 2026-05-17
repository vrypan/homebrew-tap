class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "64ee8b756e68b350e83fa0c40eb75c6ff139e573bc9ff855baade7abcca71bf1"
  version "0.3.1"
  license "MIT"
  head "https://github.com/vrypan/lilsync.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/lilsync", "--version"
  end
end
