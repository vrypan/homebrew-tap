class Lilsync < Formula
  desc "Peer-to-peer folder sync for small trusted groups on a LAN."
  homepage "https://github.com/vrypan/lilsync"
  url "https://github.com/vrypan/lilsync/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "cb61496176efbc55828a16e747b557eb8c4fb060a489f20353089169d69c5be5"
  version "0.3.4"
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
