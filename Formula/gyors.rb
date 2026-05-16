class Gyors < Formula
  desc "Keyboard-first launcher for macOS (alpha)"
  homepage "https://github.com/balintb/Gyors"
  url "https://github.com/balintb/Gyors/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "922c62d77510e3c7c31716d754c0ef81721dfb87f1fdc11d404ebba0ba18e9f7"
  license "MIT"
  head "https://github.com/balintb/Gyors.git", branch: "main"

  depends_on "rust" => :build
  depends_on macos: :sonoma

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.0"

    # build-app.sh runs cargo (Rust staticlib) + swiftc (app shell) +
    # ad-hoc codesign. Output: macos/build/Gyors.app
    system "./scripts/build-app.sh", "release"
    prefix.install "macos/build/Gyors.app"

    # Headless CLI (`gyors query ...`, `gyors plugin scaffold ...`) -
    # build-app.sh only handles the GUI bundle, so install the CLI
    # separately. Cargo lands the binary at #{bin}/gyors
    system "cargo", "install", *std_cargo_args(path: "crates/gyors-cli")
  end

  def caveats
    <<~EOS
      Gyors.app is installed to:
        #{opt_prefix}/Gyors.app

      Symlink it into /Applications so it appears in Launchpad/Spotlight:
        ln -sf "#{opt_prefix}/Gyors.app" /Applications/Gyors.app

      First launch will prompt for Accessibility permission. Grant it under
      System Settings -> Privacy & Security -> Accessibility, then relaunch.

      Default hotkey is opt+shift+space. Override in
      ~/Library/Application Support/Gyors/config.json after first launch.
    EOS
  end

  test do
    assert_predicate prefix/"Gyors.app/Contents/MacOS/Gyors", :executable?
    assert_predicate bin/"gyors", :executable?
  end
end
