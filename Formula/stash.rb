class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.9.1/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "316a7b729c77600f16e562e31fcccd2dea236644681a47e0b05ecbd6c0f7b057"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.9.1/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "186a5530caae36aeecfa3cbc015b5772d2719668a00ba8d2f5948540cf768f42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.9.1/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f12a19c9761e0a17c21c0f771cd2384157dde043688ddfe5ed7653893eb40474"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.9.1/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0162ada567c69e5a87e0e50091c312b843f3b442a5a898c98d76fd76f9adb8bd"
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
