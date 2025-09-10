class C2f < Formula
  desc "CLI to write clipboard contents to a file"
  homepage "https://github.com/balintb/c2f"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/balintb/c2f/releases/download/v0.0.5/c2f-aarch64-apple-darwin.tar.xz"
      sha256 "6568db40eae01d96bd733e19e5a429b45b7503a04e87bc25dd220d007eb87089"
    end
    if Hardware::CPU.intel?
      url "https://github.com/balintb/c2f/releases/download/v0.0.5/c2f-x86_64-apple-darwin.tar.xz"
      sha256 "cdf6114d228bc32e5e3ef73fa72f31eb9d3618c2c44b25451c1fe4a468efe999"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/balintb/c2f/releases/download/v0.0.5/c2f-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f363bdbee772220b245d484035b7e68c711d923dc7e84155f67f9eb0cfcd2986"
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
