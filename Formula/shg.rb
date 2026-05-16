class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "1bcec45539b48436e10b0112ed30e5819177282f9a5108bd3714fcb8bd1615ea"
  version "0.1.6"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "--prefix", prefix
    (share/"shg/extras").install Dir["extras/*"]
    (share/"shg/defaults").install "src/defaults/ignore.default.shg",
                                   "src/defaults/match.default.shg",
                                   "src/defaults/paths.default.shg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shg version")
  end
end
