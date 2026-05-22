class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.2/stash-aarch64-macos.tar.xz"
      sha256 "7fc73256849a675a3b4108237758597cf28741792d9812975db1c1595cbb696c"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.2/stash-x86_64-macos.tar.xz"
      sha256 "0db3a18664a22e55df7d4ac19b63f8cd0e409644ceea778bd28c97f29cd4302a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.2/stash-aarch64-linux-gnu.tar.xz"
      sha256 "d90313c038c225e54c53957655a925c1055d3d6d0df156049a0575064d2a41c7"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.2/stash-x86_64-linux-gnu.tar.xz"
      sha256 "a2f93d4e14ebcce2a671ef33d04a875a25567830f062e92beb139a7a8e3f9e9d"
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
