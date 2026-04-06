class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.6/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3339f148f2aa9cef009591b0910b18666196e781ded14ea01f581014f531bf58"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.6/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bf7aa104b5d23ce6e764a114a345ae5e33b39f2a14a8e0456ea09d3cc87fa033"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.6/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff3142098f7dba557191937caf3cb8717f8aac95f1812b0aed6a8b720ec5a5ef"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.6/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fdb431a60cd71cb7a8a90eee660888de9749a3b4f9fd3f671c1745740f90da53"
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
