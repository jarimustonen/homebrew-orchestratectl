class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.1/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "ba38ff810711da9191f755fe2b0a001b6c5537efc782940f05eebe068789e94a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.1/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af4bc7b099b02726bb687048330d96424863eb1a3f5405bbab49ae37d858ad8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.2.1/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8e9b559e2d22ed4d79517e9fa7f9f82339e1fe350354dc21bf4870f74134bf9"
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
