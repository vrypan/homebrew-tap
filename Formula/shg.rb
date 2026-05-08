class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "4763e206f60796d3add5bfc69afb67b8e84e2cc4fbb4dd16bd9f6b8ee949d125"
  version "0.1.3"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shg version")
  end
end
