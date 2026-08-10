class Orchestratectl < Formula
  desc "Rust CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/orchestratectl"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.4/orchestratectl-aarch64-apple-darwin.tar.xz"
    sha256 "94c77bbb5ffa3086bd7ba0f5137ff9af5d3146ce38844382aecb9b232bd7e5ae"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.4/orchestratectl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e19c76f70c92f6389948a3c64429918ea8d65b39ec3a8731140d3ea6478887c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/orchestratectl/releases/download/v0.1.4/orchestratectl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "133fa20e89aad75da9200ab8c7642bca4b4b2110b84ab267069b92bc0203bf01"
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
