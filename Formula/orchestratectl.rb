class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.5/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "68526c4c17afec280907f6ca624242c07650ab141dcd7b5949f970f6881aab78"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.5/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "99633dc4ed269abe217ec43d45b30ecb8d17c22a3f3842e5cb6b6d409530975e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.5/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "508daa37985c5145c5f37cd9c6b8e7693a19e011221aefab69684be3af05f49b"
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
