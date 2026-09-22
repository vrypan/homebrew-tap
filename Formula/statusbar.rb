class Statusbar < Formula
  desc "Status bar for any terminal"
  homepage "https://github.com/vrypan/statusbar"
  url "https://github.com/vrypan/statusbar/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "2a1785b9b2d4a58450ad70e4d2531e81cc3b7cbc1af2a70ad2498f3fad6910c7"
  version "0.3.0"
  head "https://github.com/vrypan/statusbar.git", branch: "main"

  depends_on "zig@0.16" => :build

  # Homebrew permits network access during fetch, then builds offline. Keep
  # Zig's dependency cache in the retained build tree for the build step.
  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/".zig-global-cache").to_s
    system "zig", "build", "--fetch=all"
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/".zig-global-cache").to_s
    system "zig", "build", "-Doptimize=ReleaseSafe", "--prefix", prefix
    generate_completions_from_executable bin/"statusbar", "completion"
  end

  test do
    assert_path_exists bin/"statusbar"
    assert_match version.to_s, shell_output("#{bin}/statusbar --version")
    assert_match "[line.1]", shell_output("#{bin}/statusbar config --default")
  end
end
