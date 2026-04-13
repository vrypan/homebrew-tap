class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.7.0/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6b07064a8a6966889165337d5bfdf6e7eb71f19fe3572778ccebca43fc0d6441"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.7.0/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d39968595a359dc34a837fa789675fc547431571ab88ec59afeaf5b060a151d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.7.0/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98362d83ff12b3b971bde918f325b4fa20a2a0b2d2ce460ff6a73891ccee44c6"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.7.0/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "812a21fd03e4843305920ec53c91c20778f45f733d72b60d62eaddd0ab765baf"
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
