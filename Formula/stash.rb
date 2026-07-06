class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-aarch64-macos.tar.xz"
      sha256 "d9daffec46feeddc1710835571fdea48221006ee76874e6eb8999cd4b5537b85"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-x86_64-macos.tar.xz"
      sha256 "a518f503e6a95bf1c0d8057a588001559ab8ba571aebaf6073b0796c88602f0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-aarch64-linux-gnu.tar.xz"
      sha256 "eed2f5ef7c2b7c33522a631f252de4e7df8436d12688fb494b778e8482a2199e"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-x86_64-linux-gnu.tar.xz"
      sha256 "06ff0ad4198a522279153de41d24f0603dec0780077a8dd38c423ec2a1db5172"
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
    bin.install "stash-bookmark"
    pkgshare.install "scripts" if Dir.exist?("scripts")
    (bash_completion/"stash").write Utils.safe_popen_read(bin/"stash-completion", "bash")
    (zsh_completion/"_stash").write Utils.safe_popen_read(bin/"stash-completion", "zsh")
    (fish_completion/"stash.fish").write Utils.safe_popen_read(bin/"stash-completion", "fish")
  end

  test do
    system "#{bin}/stash", "--version"
  end
end
