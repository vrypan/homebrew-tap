class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.1/stash_0.4.1_darwin_arm64.tar.gz"
      sha256 "d51d80082efe1b6a8cda216d0e53994d4d372126de734a30783075da20150e1f"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.1/stash_0.4.1_darwin_x86_64.tar.gz"
      sha256 "797f39ef13a60ccf8c4adcd9643cc5852178567438c829d373fd73a71a07386a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.4.1/stash_0.4.1_linux_arm64.tar.gz"
      sha256 "98d78fe425546cb0a222d56afc0bac5310ced33a345a3bd82c824a3d81d784b7"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.4.1/stash_0.4.1_linux_x86_64.tar.gz"
      sha256 "8a98f5a9524a696c2fee7c06446a8ff0fe8fa0e53da3e9c903da5f4edc75db99"
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
