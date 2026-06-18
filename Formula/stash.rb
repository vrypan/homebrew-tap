class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.10.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.4/stash-aarch64-macos.tar.xz"
      sha256 "1dc995c6795dae61b1e15ba7b633a75fa7bc0bccb6c72d62e17e13f9ea96e02b"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.4/stash-x86_64-macos.tar.xz"
      sha256 "9dea403eb83d9109fec662c8a464395384dc9d933f4bd26d4b6ac300e1549e20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.4/stash-aarch64-linux-gnu.tar.xz"
      sha256 "aa93beae7f0a4c11c958d798fbba00a366292b9f19d4ce652a8de63329fdbc88"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.4/stash-x86_64-linux-gnu.tar.xz"
      sha256 "63beaf6c66df1cf283c4e60c0bd281f3bdb105944c95a09ddcee87d1dc549dbb"
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
    bin.install "stash-bookmark"
    pkgshare.install "scripts" if Dir.exist?("scripts")
    (bash_completion/"stash").write Utils.safe_popen_read(bin/"stash-completion", "bash")
    (zsh_completion/"_stash").write Utils.safe_popen_read(bin/"stash-completion", "zsh")
    (fish_completion/"stash.fish").write Utils.safe_popen_read(bin/"stash-completion", "fish")
  end

  test do
    system "#{bin}/stash", "--version"
  end
end
