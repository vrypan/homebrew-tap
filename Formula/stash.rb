class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.3/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b7e534212413c9d5b198ad6aba7efdd81ac2c31a4b5ebc59face997499d4f741"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.3/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "47917fa42f4215a9f5aac0b60bde46eee7c0ec4219140bafbe733e2b392bc9f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.3/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9896216bd260c2e931de863d1e507c882f6faef760fe679a193170b064fc1755"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.3/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f462eaa5236b36d2d9b7ffe96580f4ec1eeb2d8e7281382f7ca4feee3361e1a3"
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
