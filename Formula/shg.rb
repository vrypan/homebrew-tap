class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "75bb5c0ee5d8a09516332abd3508f9ac8764ec7828dac162906986d1762a23c4"
  version "0.1.2"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shg version")
  end
end
