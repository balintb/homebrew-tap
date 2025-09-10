class C2f < Formula
  desc "CLI to write clipboard contents to a file"
  homepage "https://github.com/balintb/c2f"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/balintb/c2f/releases/download/v0.1.0/c2f-aarch64-apple-darwin.tar.xz"
      sha256 "b815584feb2e4fd25d56529023d2595e26542494248002cbc8892d63d3809a12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/balintb/c2f/releases/download/v0.1.0/c2f-x86_64-apple-darwin.tar.xz"
      sha256 "625d10297b0b0dae2257d2f82bc1abcaf05d9d5c498829be80917f1765890a32"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/balintb/c2f/releases/download/v0.1.0/c2f-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b9608db7c5bb41f1c040be5a9ed4c8e0c6ab16af078633ac1cc4215a45cba47c"
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
