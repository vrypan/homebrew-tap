class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "814735dde1a5b28b209d04ad365313cf3b4f811b5497649e6cd6fafe45fbd578"
  version "0.1.5"
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
