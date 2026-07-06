class Stash < Formula
  desc "A local store for pipeline output and ad hoc file snapshots."
  homepage "https://github.com/vrypan/stash"
  version "0.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-aarch64-macos.tar.xz"
      sha256 "432440cfe4c6f563a8a1d7acaecf2cd790394c6acc07d3d2782c723fe81c06cd"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-x86_64-macos.tar.xz"
      sha256 "650dfe0b1e4e2519beb83c468ea2fe80d3d128f5d6cf3ca6ae2aefee19c628c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-aarch64-linux-gnu.tar.xz"
      sha256 "6a09cb87e978a60be0de38cde96acc9913dda1befd40333688a2b34481b00d35"
    end
    on_intel do
      url "https://github.com/vrypan/stash/releases/download/v0.11.0/stash-x86_64-linux-gnu.tar.xz"
      sha256 "97e489175376e9d4f6166274bc5e7452b00c3ef54bc61bc261e9bf968acf50e7"
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
