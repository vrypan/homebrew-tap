class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.4.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.3/stash_0.4.3_darwin_arm64.tar.gz"
      sha256 "aba860e7678469e8fc2bde584a527c1aea0b0e59f6702750d86ec2d1fa13dc1a"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.3/stash_0.4.3_darwin_x86_64.tar.gz"
      sha256 "955afb1d1c749d97cd72137ce34cf379f1470e6afa03ea07e221faed0cd41540"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.3/stash_0.4.3_linux_arm64.tar.gz"
      sha256 "8de1ce6d339c110b182e2c31fc6edfb028d0ae839a20a9a741bf1d0e2a4f8d92"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.3/stash_0.4.3_linux_x86_64.tar.gz"
      sha256 "8a8cd932305c5a495479ebd9fe8d0b6c5b6df7f8079bd6f3ba2aef9ffa5f90ec"
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
