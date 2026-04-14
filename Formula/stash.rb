class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.8.0/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "10dea6654877bda3a3a0ba987381d55bb45a8b11ce0b498d3bbe89c08af4c572"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.8.0/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b0577e76829fa9555e1bb4c8fa8f7a7c529faa383fb5a24d2d5bb22a3960c296"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.8.0/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd1e0b85388a08d2f31d7b853e0aa6ed00bb619184a4e48ab66d6c19ded920d7"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.8.0/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9e0bab589e5a1ee40b8352073f65704bb6f47a65769ef5f4be952f2f874b64ff"
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
