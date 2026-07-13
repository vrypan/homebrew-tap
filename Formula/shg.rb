class Shg < Formula
  desc "Scan histories, environment, and AI agent transcripts for secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "59304308e2ca209bdfe27500265904e458b041d223930bbab7a9a9a5fdb138fc"
  version "0.2.4"
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
