class Shg < Formula
  desc "Scan histories, environment, and AI agent transcripts for secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "cad7e66e62b7fcec4a6299be69cf60670abc35af23ea72bccbf660c16b057d2e"
  version "0.2.2"
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
