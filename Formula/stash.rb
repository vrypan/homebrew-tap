class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.2/stash_0.4.2_darwin_arm64.tar.gz"
      sha256 "7dd7f0c71af296fbc0b35b87a57b5b23ce8b5025384bf017c968b779a45a3583"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.2/stash_0.4.2_darwin_x86_64.tar.gz"
      sha256 "9ff3ddf925e7cae3c47bb354530679c78a6720e6b1c8e7cbf65fc98564e4bf31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.2/stash_0.4.2_linux_arm64.tar.gz"
      sha256 "ef000d060af92335cf477cc4647d36bf192ab51e4c91537e7112162bcc6f5055"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.2/stash_0.4.2_linux_x86_64.tar.gz"
      sha256 "6ca6f85d5f0a3e851b6678936a7f2f5700171cdfdd60986d8f9c185eee8ea528"
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
