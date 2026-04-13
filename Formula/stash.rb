class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.7.1/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "08fae7e6226a507d27bd743e8bd30f553a946a2dc5be32b0d885ca472d37ba81"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.7.1/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "29cb6f4128b6084321ef95e4844c4cbda98525b75ec5e631d515b78952cbf2a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.7.1/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "564101d676f51fd5b33d994b6f9af16a43e74326f4949ae98ff2bb7d6b6b3766"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.7.1/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "321d96fee246fd72777c41f82887d3a85ff0895874165ef3c261c242ac0e68dd"
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
