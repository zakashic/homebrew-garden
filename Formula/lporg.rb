class Lporg < Formula
    desc "Organize Your macOS Launchpad Apps"
    homepage "https://github.com/blacktop/lporg"
    version "20.4.32"
    license "MIT"
    depends_on :macos
  
    url "https://github.com/blacktop/lporg/releases/download/v20.4.32/lporg_20.4.32_macOS_universal.tar.gz"
    sha256 "200f4c5c743febd6fbac6cded3a74f44ca861696807c2ac719fcf0eca8f88eca"
  
    def install
      bin.install "lporg"
      bash_completion.install "completions/_bash" => "lporg"
      zsh_completion.install "completions/_zsh" => "_lporg"
      fish_completion.install "completions/_fish" => "lporg.fish"
    end
  
    test do
      system "#{bin}/lporg --version"
    end
  end