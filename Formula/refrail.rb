# Generated from the checksum-verified GitHub Release assets. Do not edit hashes.
class Refrail < Formula
  desc "Portable Git commit and branch policy checks"
  homepage "https://github.com/batuhanoztrk/RefRail"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.1.0/refrail_v0.1.0_darwin_arm64.zip"
      sha256 "b5a67cae62ae3039976c6fdd9d7763433cb6bc4469f339ffcaaa6766e73e47e5"
    end
    on_intel do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.1.0/refrail_v0.1.0_darwin_amd64.zip"
      sha256 "f26a2fac0ab82079aaf9892154454b4e2257fd621f45cf25fde6543e555fecf5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.1.0/refrail_v0.1.0_linux_arm64.zip"
      sha256 "cbf567f472ac2860b9450b5543c0fe8ff67880c71ebbc92c6e4b14228e848831"
    end
    on_intel do
      url "https://github.com/batuhanoztrk/RefRail/releases/download/v0.1.0/refrail_v0.1.0_linux_amd64.zip"
      sha256 "d16a6cda5278d4ee3f74954f513d2d303a5fe742292b70fa7f91f63fbba992f1"
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
    assert_match '"version":"v0.1.0"', shell_output("#{bin}/refrail version --json")
    system "git", "-c", "init.templateDir=", "init", "--initial-branch=main", "project"
    system bin/"refrail", "install", "--repo", testpath/"project"
    system bin/"refrail", "doctor", "--repo", testpath/"project"
    system bin/"refrail", "uninstall", "--repo", testpath/"project"
  end
end
