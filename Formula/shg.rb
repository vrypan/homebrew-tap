class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f3d59fd8ceac3e15006dd6f0d72d2e884daf39737437b7393c94884533e29a45"
  version "0.1.1"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shg version")
  end
end
