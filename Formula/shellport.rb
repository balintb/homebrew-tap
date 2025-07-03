# frozen_string_literal: true
# typed: true

class Shellport < Formula
  desc "Taxiway/runway maps in terminal"
  homepage "https://github.com/balintb/shellport"
  url "https://api.github.com/repos/balintb/shellport/tarball/v0.0.3"
  sha256 "a27b624d6991e739dc30fad4e6a833bad95f5b11b58624a2debb3b47ff5133c4"
  license "MIT"

  depends_on "bun"

  def install
    system "bun", "install"

    (bin/"shellport").write <<~EOS
      #!/bin/bash
      exec bun run "#{libexec}/src/cli.ts" "$@"
    EOS

    libexec.install Dir["*"]
  end

  test do
    assert_match "shellport - airport diagrams in terminal", shell_output("#{bin}/shellport --help")
    assert_match "Error: Please provide a valid 4-letter ICAO code", shell_output("#{bin}/shellport ABC 2>&1", 1)
  end
end
