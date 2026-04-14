class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.8.1/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "60a91e29f7ac8bd95f0ba786d4213065198d4d9b6a0c5328ac1c2c3f78bda7a7"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.8.1/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6c504addd53eccb43e05e6a0747ea339be60277839e5e20fe53c6a6c488601f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.8.1/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5c5a50b76057148b9b12ad2e2f68c07c95f82d60ce0cda0f0c2327962690429"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.8.1/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e4ed4e3129b4ed68bdcf7b3a5bbfe28a32d71e051b24b85116fb80c0a1ffb1e"
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
    bin.install "stash-completion"
    pkgshare.install "scripts" if Dir.exist?("scripts")
    (bash_completion/"stash").write Utils.safe_popen_read(
      bin/"stash-completion", "bash"
    )
    (zsh_completion/"_stash").write Utils.safe_popen_read(
      bin/"stash-completion", "zsh"
    )
    (fish_completion/"stash.fish").write Utils.safe_popen_read(
      bin/"stash-completion", "fish"
    )
  end

  test do
    system "#{bin}/stash", "version"
  end
end
