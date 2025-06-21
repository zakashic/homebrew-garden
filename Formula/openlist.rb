class OpenList < Formula
    desc "🗂️A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList."
    homepage "https://oplist.org"
    url "https://github.com/OpenListTeam/OpenList/releases",
        verified: "github.com/alist-org/alist/"
    version "4.0.0"
    license "AGPL-3.0-only"
  
    if OS.mac?
      if Hardware::CPU.arm?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-arm64.tar.gz"
        sha256 "4a70b0d50c5b99ef8d59467582aa6a98eccee98be464100dc349226620c4591b"
      elsif Hardware::CPU.intel?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-amd64.tar.gz"
        sha256 "15f1a537ec596801cfcd6170a58c67dfc5d9675bbe2edbeb8a9d30d6f96ef70a"
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