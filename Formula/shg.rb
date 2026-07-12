class Shg < Formula
  desc "Scan histories, environment, and AI agent transcripts for secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4e17feaf6ed23346e06f58225bd3cd906a4d36c930c7a3156de914e84b5acd9b"
  version "0.2.1"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix
    (share/"shg/extras").install Dir["extras/*"]
    (share/"shg/defaults").install "src/defaults/ignore.default.shg",
                                   "src/defaults/match.default.shg",
                                   "src/defaults/paths.default.shg",
                                   "src/defaults/paths.deep.default.shg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shg version")
  end
end
