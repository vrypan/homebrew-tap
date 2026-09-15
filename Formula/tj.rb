class Tj < Formula
  desc "Persistent, addressable terminal journals"
  homepage "https://github.com/vrypan/tj"
  url "https://github.com/vrypan/tj/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7fbdb8ff95bd63bb6430fd0c28816420d487a2e86dfa0936150c02d3abcaddd1"
  version "0.7.2"
  head "https://github.com/vrypan/tj.git", branch: "main"

  depends_on "zig@0.16" => :build

  # Homebrew permits network access during fetch, then builds offline. Keep
  # Zig's content-addressed dependency cache inside the retained build tree so
  # install can use the exact Zecli and Zooi revisions in build.zig.zon.
  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/".zig-global-cache").to_s
    system "zig", "build", "--fetch=all"
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = (buildpath/".zig-global-cache").to_s
    system "zig", "build",
           "-Doptimize=ReleaseSafe",
           "-Dstrip=true",
           "--prefix", prefix
  end

  def caveats
    <<~EOS
      Add the TJ zsh or Fish integration to your shell configuration:

        # zsh
        source #{opt_pkgshare}/tj.plugin.zsh

        # Fish
        source #{opt_pkgshare}/tj.plugin.fish
    EOS
  end

  test do
    %w[tj tjctl].each do |tool|
      assert_path_exists bin/tool
    end

    assert_path_exists pkgshare/"tj.plugin.zsh"
    assert_path_exists pkgshare/"tj.plugin.fish"
    assert_path_exists bash_completion/"tj"
    assert_path_exists bash_completion/"tjctl"
    assert_path_exists zsh_completion/"_tj"
    assert_path_exists zsh_completion/"_tjctl"
    assert_path_exists fish_completion/"tj.fish"
    assert_path_exists fish_completion/"tjctl.fish"

    assert_match version.to_s, shell_output("#{bin}/tj --version")
    assert_match version.to_s, shell_output("#{bin}/tjctl --version")

    (testpath/"sample").write "homebrew-test\n"
    assert_equal "homebrew-test\n", shell_output("#{bin}/tj cat --raw #{testpath}/sample")
  end
end
