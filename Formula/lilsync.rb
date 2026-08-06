class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "570ed562d93245510e6f92b87562ec2977bc2343ec4117ba099f66c46204d236"
  version "0.4.1"
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
