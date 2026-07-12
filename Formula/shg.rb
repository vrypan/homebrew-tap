class Shg < Formula
  desc "Scan histories, environment, and AI agent transcripts for secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b4ebe7e699e8caedf1f32f60e95466002e9c9f30b1993cd45e7dfb9d06114137"
  version "0.2.0"
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
