class OpenList < Formula
    desc "🗂️A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList."
    homepage "https://oplist.org"
    url "https://github.com/OpenListTeam/OpenList/archive/v#{version}.tar.gz",
        verified: "github.com/OpenListTeam/OpenList"
    version "4.0.4"
    license "AGPL-3.0-only"
  
    if OS.mac?
      if Hardware::CPU.arm?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-arm64.tar.gz"
        sha256 "f8be337ebc9070124a11d5538b4d196a0eb1b028cc9c96626309582263a3305f"
      elsif Hardware::CPU.intel?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-amd64.tar.gz"
        sha256 "c7446e7e89f0e0aef6865e78e7e2f02afa5a7f0e9a1f9bf6468be817e370246f"
      end
    end
  
    livecheck do
      url :url
      strategy :github_latest
    end
  
    def install
      bin.install "openlist"
    end
  
    def post_install
      (var/"log/openlist").mkpath
      (etc/"openlist").mkpath
      prefix.install_symlink etc/"openlist" => opt_prefix/"data"
      ln_s var/"log/openlist", opt_prefix/"data/log"
    end
  
    service do
      run [opt_bin/"openlist", "server"]
      working_dir opt_prefix
      keep_alive true
    end
  
    def caveats
      <<~EOS
        To reveal openlist admin user's info in default `config.json` again, run the following command:
          cd #{opt_prefix} && openlist admin
        Or reveal `admin` password via `sqlite3` command (before v3.25.1):
          sqlite3 #{etc}/openlist/data.db "select password from x_users where username = 'admin'"
        Or reset `admin` password:
          cd #{opt_prefix} && openlist admin random
        Or set new `admin` password:
          cd #{opt_prefix} && openlist admin set NEW_PASSWORD
      EOS
    end
  
    test do
      system bin/"openlist", "version"
      system bin/"openlist", "admin"
    end
  end