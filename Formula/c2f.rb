class C2f < Formula
  desc "CLI to write clipboard contents to a file"
  homepage "https://github.com/balintb/c2f"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/balintb/c2f/releases/download/v0.0.6/c2f-aarch64-apple-darwin.tar.xz"
      sha256 "3a9945c77798a5fff7cf5f581354a6ebbb4da932768a9990bedb8f9a3fcbe9d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/balintb/c2f/releases/download/v0.0.6/c2f-x86_64-apple-darwin.tar.xz"
      sha256 "59cadc15a6b8cf85621eb08f88806664548511a4451b83cbbf81e65c823d64fd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/balintb/c2f/releases/download/v0.0.6/c2f-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "aa900d44131070ab85871fee2e45652c53c5c22519dc2ddd94c9ee725d524d24"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "c2f" if OS.mac? && Hardware::CPU.arm?
    bin.install "c2f" if OS.mac? && Hardware::CPU.intel?
    bin.install "c2f" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
