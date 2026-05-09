class Shg < Formula
  desc "Scan shell history files for accidentally persisted secrets."
  homepage "https://github.com/vrypan/shg"
  url "https://github.com/vrypan/shg/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ab973d350f6088d1a5f3652e300b5278f9d304092778734f31e4af9564ad127a"
  version "0.1.4"
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
