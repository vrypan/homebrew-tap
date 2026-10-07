class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "15abb712753ed6a89abb57d8b795001103ee519c7b3ecf9a1a789b6e2f75c3d6"
  version "0.4.2"
  license "MIT"
  head "https://github.com/vrypan/lilsync.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--profile", "dist", *std_cargo_args
  end

  test do
    system "#{bin}/lilsync", "--version"
  end
end
