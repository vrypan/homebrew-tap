class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.5/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0a162556f492dac6e281f7c8eafb2c2b0e915685654c70b9b70159b8c064e912"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.5/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "eb0f6b47bc43fff8469c123739ead86884e67cd45d7586ac7f442ed741fefeba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.5/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e9936f527935f72765d499aa7ade0eb1accd14081aad2f54f5c011bd42501ee"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.5/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aaa86239fac92dade795890c25ccdf52aac5f22081f63de98c74bd0f2c574077"
    end
  end

  def install
    if which("stash")
      installed = Utils.safe_popen_read("stash", "version").strip
      version_text =
        if installed =~ /\Astash (\S+)\z/
          Regexp.last_match(1)
        elsif installed =~ /\A\d+\.\d+\.\d+(?:[-+][^\s]+)?\z/
          installed
        end

      if version_text
        existing_version = Version.new(version_text)
        if existing_version < Version.new("0.5.0")
          odie <<~EOS
            stash #{existing_version} is installed.
            Automatic upgrade from versions older than 0.5.0 is not supported.
            Visit https://github.com/vrypan/stash for more info.
            To force the upgrade: brew uninstall stash first, then install again.
          EOS
        end
      end
    end

    bin.install "stash"
    pkgshare.install "scripts" if Dir.exist?("scripts")
    (bash_completion/"stash").write Utils.safe_popen_read(
      bin/"stash", "completion", "bash"
    )
    (zsh_completion/"_stash").write Utils.safe_popen_read(
      bin/"stash", "completion", "zsh"
    )
    (fish_completion/"stash.fish").write Utils.safe_popen_read(
      bin/"stash", "completion", "fish"
    )
  end

  test do
    system "#{bin}/stash", "version"
  end
end
