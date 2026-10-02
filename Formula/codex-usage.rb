class CodexUsage < Formula
  desc "Read Codex quota, credits, and token activity from the local daemon"
  homepage "https://github.com/vrypan/codex-usage"
  url "https://github.com/vrypan/codex-usage/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0d0c26aca973e49768df87f60207c4d35e2a90b6be592521502c5560c1719ad6"
  license "MIT"
  head "https://github.com/vrypan/codex-usage.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "codex-usage v#{version}", shell_output("#{bin}/codex-usage version")
  end
end
