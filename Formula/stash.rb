class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.9.0/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fde17516aa0a09024f71a459f2865b8605d940bde8f00d6c42af727fc29b7723"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.9.0/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b46f187109e2bc4b09cc8346a135eaf217e4409134178f49e811f6e994badd57"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.9.0/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e9c3e32c784c13c13bac41b6689e4ca5e6154129a649ed68098714b8df3317e"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.9.0/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cf068d05f0e61ece1b13ee97e4bbe074b6e1a97555b6689862f6c6b0a9bad9c"
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
