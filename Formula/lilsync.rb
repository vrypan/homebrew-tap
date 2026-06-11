class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "2442763b616da9bcb7370cc63939acb374ac713896dd4e4288f0f03887aa3e39"
  version "0.3.3"
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
