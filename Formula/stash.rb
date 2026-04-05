class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.1/stash-aarch64-apple-darwin.tar.xz"
      sha256 "4f1941b0b2e39b039d5fe1117f3b8be420633a3264ef4994f1f1ae5a1d7337de"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.1/stash-x86_64-apple-darwin.tar.xz"
      sha256 "aaeadfe74bd261e27fe224068bba09cdbc76771c493fd0f01fb7ec96a476763b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.1/stash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bad24208b2e12ad0e05fb958edc61b4c60473e8fcb103f5702a54d0f9a7c4dbf"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.1/stash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d1615db89b18f620fac2332369eaa704a97d080280b3bdda56d1cb2560591a4"
    end
  end

  def install
    cellar = HOMEBREW_CELLAR/"stash"
    if cellar.exist?
      installed = cellar.subdirs.map { |d| Version.new(d.basename.to_s) }.max
      if installed && installed < Version.new("0.5.0")
        odie <<~EOS
          stash #{installed} is installed.
          Automatic upgrade from versions older than 0.5.0 is not supported.
          Visit https://github.com/vrypan/stash for more info.
          To force the upgrade:  first, then install again.
        EOS
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
