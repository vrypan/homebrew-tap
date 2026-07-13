class Shg < Formula
  desc "Scan histories, environment, and AI agent transcripts for secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "38cfff5490e7ab2c654df31f68074edb15c7d3cb27f694834f549805f3f3b88b"
  version "0.2.6"
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
