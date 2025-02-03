class Alist < Formula
    desc "File list program that supports multiple storage powered by Gin and Solidjs"
    homepage "https://alist.nn.ci/"
    url "https://github.com/alist-org/alist/archive/v#{version}.tar.gz",
        verified: "github.com/alist-org/alist/"
    version "3.42.0"
    license "AGPL-3.0-only"
  
    if OS.mac?
      if Hardware::CPU.arm?
        url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-arm64.tar.gz"
        sha256 "014694017ab429656ff0c2abac67cbc73c19191d42616d912304ad5addac94c0"
      elsif Hardware::CPU.intel?
        url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-darwin-amd64.tar.gz"
        sha256 "b8e2957b1a5f8da61bf7b9c952f1c11cf2c40130b1c5facbc330e966de9a789b"
      end
    elsif OS.linux? && Hardware::CPU.intel?
      url "https://github.com/alist-org/alist/releases/download/v#{version}/alist-linux-amd64.tar.gz"
      sha256 "200b5d2d1f315271ab2e980fd3a40b25b1246e11412db0cb5606726e9e6c265b"
    end
  
    livecheck do
      url :url
      strategy :github_latest
    end
  
    def install
      bin.install "alist"
    end
  
    def post_install
      (var/"log/alist").mkpath
      (etc/"alist").mkpath
      prefix.install_symlink etc/"alist" => opt_prefix/"data"
      ln_s var/"log/alist", opt_prefix/"data/log"
    end
  
    service do
      run [opt_bin/"alist", "server"]
      working_dir opt_prefix
      keep_alive true
    end
  
    def caveats
      <<~EOS
        To reveal alist admin user's info in default `config.json` again, run the following command:
          cd #{opt_prefix} && alist admin
        Or reveal `admin` password via `sqlite3` command (before v3.25.1):
          sqlite3 #{etc}/alist/data.db "select password from x_users where username = 'admin'"
        Or reset `admin` password:
          cd #{opt_prefix} && alist admin random
        Or set new `admin` password:
          cd #{opt_prefix} && alist admin set NEW_PASSWORD
      EOS
    end
  
    test do
      system bin/"alist", "version"
      system bin/"alist", "admin"
    end
  end