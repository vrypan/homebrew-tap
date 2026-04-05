class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.5.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.2/stash-aarch64-apple-darwin.tar.xz"
      sha256 "d25d67e08bc6890674b3fb311df85217f4b0c66f4edd18ae10ecb55545f16162"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.2/stash-x86_64-apple-darwin.tar.xz"
      sha256 "65f3908c36b60e73e2e6381712e11525e7ab9e7c1bdc186f6ae1b46bd8d20ea2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.5.2/stash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06be23e91b060bebc1e4f4a141d14d3446e7afb9ac56e07fcbc02643811acfcc"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.5.2/stash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9dc002063a541e88511c76f0efeb0df685f0870c46789ebfb83622c67bea263a"
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
