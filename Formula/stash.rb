class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.4.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.4/stash_0.4.4_darwin_arm64.tar.gz"
      sha256 "24571ffb374f212601418c34a24f21920507251b2c09a0972506486a6742376d"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.4/stash_0.4.4_darwin_x86_64.tar.gz"
      sha256 "2258b80c1668bb1821329c5890daa0386289a199b86bd87054058fa5a6f36dd1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.4/stash_0.4.4_linux_arm64.tar.gz"
      sha256 "75c050272a8b6db5404d3815767c6578dd24ea22e3a93bd2112bb68dee607b9a"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.4/stash_0.4.4_linux_x86_64.tar.gz"
      sha256 "9d15387d53729e2339509d905176b0973946e2ab98e45ec7d37e68c27962b3f2"
    end
  end

  def install
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
