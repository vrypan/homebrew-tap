class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.10.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.3/stash-aarch64-macos.tar.xz"
      sha256 "77e114d4ab3b9db354b87bf46f7121075b0f35a52d7de40abacf6fb3238fd11e"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.3/stash-x86_64-macos.tar.xz"
      sha256 "57b8e9622e613111154cf17092aed99a7669a9a7a8764bbc31623bba518d0c6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.3/stash-aarch64-linux-gnu.tar.xz"
      sha256 "bb1c1668e8fc21fe7b864079f1841c31503dbe3445c6fc3b7a799de976833740"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.3/stash-x86_64-linux-gnu.tar.xz"
      sha256 "3b81fec7adef0950931ddba72e56cb64f8c7ea1ec6a11ee049ae5186fb6c9b53"
    end
  end

  def install
    if which("stash")
      installed = Utils.safe_popen_read("stash", "--version").strip
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
    (bash_completion/"stash").write Utils.safe_popen_read(bin/"stash-completion", "bash")
    (zsh_completion/"_stash").write Utils.safe_popen_read(bin/"stash-completion", "zsh")
    (fish_completion/"stash.fish").write Utils.safe_popen_read(bin/"stash-completion", "fish")
  end

  test do
    system "#{bin}/stash", "--version"
  end
end
