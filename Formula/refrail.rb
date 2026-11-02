# Generated from the checksum-verified GitHub Release assets. Do not edit hashes.
class Refrail < Formula
  desc "Portable Git commit and branch policy checks"
  homepage "https://github.com/batuhanoztrk/RefRail"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.2.0/refrail_v0.2.0_darwin_arm64.zip"
      sha256 "c21461d777d7f8f0af502d14323ed62d84b5cab685b6f298dba90e92583e83f9"
    end
    on_intel do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.2.0/refrail_v0.2.0_darwin_amd64.zip"
      sha256 "2108d21d3b7c74b6ae996dd68f50485a3843010ea8fa02b2c47d41635d248508"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.2.0/refrail_v0.2.0_linux_arm64.zip"
      sha256 "4db6dce713f3f726287e37d787169008149b1432eb1c239e338e14194af05db8"
    end
    on_intel do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.2.0/refrail_v0.2.0_linux_amd64.zip"
      sha256 "d1246479b428f41b0e1f550b767aa2d8cc4ff4c7b752888fb63a9f2b4018de5c"
    end
  end

  depends_on "git"

  def install
    # Keep the verified layout intact; do not expose the private Lefthook binary.
    libexec.install Dir["*"]
    # Prevent Homebrew's metafile fallback from moving LICENSE/README out of
    # the verified bundle during its post-install housekeeping.
    cp libexec/"LICENSE", prefix/"LICENSE"
    bin.install_symlink libexec/"bin/refrail"
  end

  def caveats
    <<~EOS
      Enable RefRail for each clone: refrail install --repo /path/to/project
      After upgrading: refrail update --repo /path/to/project
      Existing clones retain their pinned bundle until you run update.
    EOS
  end

  test do
    ENV["REFRAIL_LANG"] = "en"
    ENV["REFRAIL_HOME"] = (testpath/"tool-home").to_s
    assert_match '"version":"v0.2.0"', shell_output("#{bin}/refrail version --json")
    system "git", "-c", "init.templateDir=", "init", "--initial-branch=main", "project"
    system bin/"refrail", "install", "--repo", testpath/"project"
    system bin/"refrail", "doctor", "--repo", testpath/"project"
    system bin/"refrail", "uninstall", "--repo", testpath/"project"
  end
end
