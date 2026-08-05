class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "365be6282e1ba73b69f21d09185333780b189fe578cc9d0682dd491da03f18c7"
  version "0.3.5"
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
