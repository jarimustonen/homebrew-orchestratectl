class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.2/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "c31aff75e747044ea6a708db7fbb87d5fe366f0ebf3af7bc554a354d779714ea"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.2/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b5ac2baaa598792d3de9c39357505feb72e359310065518737b978dc19bde46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.2/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "911646e29e0b02b422981e76ecf1d211d7d576fe257ba9a875c17979a78a5799"
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
