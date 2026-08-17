class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.4.0/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "dee0b8ad3ddfdfcad3daa4e03d9e1fc6e9da2e2a3c7692654d2d92241be4e1f9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.4.0/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88ba19e916b224f875d096ec9ed27fc15027e16c33f85b335caed6c9bac23ac7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.4.0/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "024d1419365122f3d35caa92f326759db97361583eda26159f9e0093525d43be"
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
