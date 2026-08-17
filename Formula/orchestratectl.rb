class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.3.0/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "6026db85a24b0765c04aa50819cd213db947bc0df82c52168ecb5cbc85182744"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.3.0/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ae9c19e8e2d60f179ad8e2dda6450dcdef49371729e8d5a9045499720060010"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.3.0/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10d391c050458e50d07e521ff42dd7b090210daf48cb498c8153ef7a63928a18"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestratectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orchestratectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orchestratectl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
