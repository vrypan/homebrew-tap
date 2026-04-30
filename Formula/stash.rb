class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.0/stash-aarch64-macos.tar.xz"
      sha256 "d7a42353bc2c147735e1d3cb6f8fe91447975997022ff16b6e635fe11de263fe"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.0/stash-x86_64-macos.tar.xz"
      sha256 "216e70076e33c31b0f2a18d449d43cae56508f74c1c7a49e516a35107531f354"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.10.0/stash-aarch64-linux-gnu.tar.xz"
      sha256 "0b49bf823a379ed3869f03beab3cc9b3c2ecdf888b4b2842a1329df24bf93bd5"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.10.0/stash-x86_64-linux-gnu.tar.xz"
      sha256 "0a0ca4a061c460df55651c2c17647a4fe916fcea90cc3497404eb55f2d998f78"
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
    pkgshare.install "scripts" if Dir.exist?("scripts")
  end

  test do
    system "#{bin}/stash", "--version"
  end
end
