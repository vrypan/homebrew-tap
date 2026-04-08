class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.7/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ba97e746509c47d37f74c6851d2f496b578745d5eb4eda42e0bf75b4a7cbc273"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.7/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "508ef33fa231e420715c2f7350ce2511dce0a924cdfaf3a90d4b0e3732365467"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.7/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aa2b6ecac6750be0482dad4da0d7ad2f535447bc59e1974cce103ac900219989"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.7/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21cdf7ba530f26145a7cc7440ea569154fa17a528c00ee05aa658d9c6e2e130f"
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
