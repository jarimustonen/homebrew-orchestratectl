class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.0/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "fa32c808a40aa93900898798812994bcc9cf8aebd4f5a0c79f9c3b1d91464233"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.0/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a388568782aef472e62d9d756e57c6391b7670643218ca9464d18cb2862760a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.0/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b320be07e5d222a7eb5010319438532a19bc9ff937cadacdb8f61cd00432414"
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
    bin.install "orchestratectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "orchestratectl" if OS.linux? && Hardware::CPU.arm?
    bin.install "orchestratectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
