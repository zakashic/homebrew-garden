class OpenList < Formula
    desc "🗂️A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList."
    homepage "https://oplist.org"
    url "https://github.com/OpenListTeam/OpenList/archive/v#{version}.tar.gz",
        verified: "github.com/OpenListTeam/OpenList"
    version "4.1.9"
    license "AGPL-3.0-only"
  
    if OS.mac?
      if Hardware::CPU.arm?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-arm64.tar.gz"
        sha256 "c2a2ec40bb3051a5f84a86c0b9c00a7c74346813afcbe466da1e4a6b5c79f3a3"
      elsif Hardware::CPU.intel?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-amd64.tar.gz"
        sha256 "9e2f88b36c1d9fb88bc00d5323034c209f4796f6f6a4cd89a34a7a11218b9e80"
      end
    end
  
    livecheck do
      url :url
      strategy :github_latest
    end
  
    def install
      bin.install "openlist"
    end
  
    # def post_install
    #   (var/"log/openlist").mkpath
    #   (etc/"openlist").mkpath
    #   prefix.install_symlink etc/"openlist" => opt_prefix/"data"
    #   ln_s var/"log/openlist", opt_prefix/"data/log"
    # end

    def post_install
        (var/"log/openlist").mkpath
        (etc/"openlist").mkpath
        ln_sf etc/"openlist", prefix/"data"
        ln_sf var/"log/openlist", prefix/"data/log"
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