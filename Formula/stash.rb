class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.1/stash-aarch64-macos.tar.xz"
      sha256 "1b8ecfd19e8d2c4c0bb7206302db664ea062debbe5de53d314e2fb3f13ed73df"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.1/stash-x86_64-macos.tar.xz"
      sha256 "7157a85536f6930ab4433d985a74f1e54076bb6021d339cbfec0215689a2448b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.1/stash-aarch64-linux-gnu.tar.xz"
      sha256 "db40f9f0b34725875871290a3f56584c2817ba0f066508901465f0e95533eb4e"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.1/stash-x86_64-linux-gnu.tar.xz"
      sha256 "bde21e49f0011bcf450deadad8f15110044c04d1a8740da09f686ddf205d460f"
    end
  end

  def install
    if which("stash")
      installed = Utils.safe_popen_read("stash", "--version").strip
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
    bin.install "stash-completion"
    pkgshare.install "scripts" if Dir.exist?("scripts")
    (bash_completion/"stash").write Utils.safe_popen_read(bin/"stash-completion", "bash")
    (zsh_completion/"_stash").write Utils.safe_popen_read(bin/"stash-completion", "zsh")
    (fish_completion/"stash.fish").write Utils.safe_popen_read(bin/"stash-completion", "fish")
  end

  test do
    system "#{bin}/stash", "--version"
  end
end
