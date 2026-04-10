class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.6.0/stash-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7029d9e582ee1f632634f4c49fc110bf428334ba9029a2b4a539844d8cbf86b2"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.6.0/stash-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bb6c1e16381566141e89c7e587b7d3c6007ced27462305f1c4b341938fd96d9f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.6.0/stash-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f482ea770c4f43c53d35da70437b36597575af3e47e73f0df2250edc0571e15b"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.6.0/stash-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d3ecf2ab13e993180cddac72129bf8755d90a7ae53849e7117450b035942837"
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
