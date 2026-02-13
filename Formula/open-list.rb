class OpenList < Formula
    desc "🗂️A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList."
    homepage "https://oplist.org"
    url "https://github.com/OpenListTeam/OpenList/archive/v#{version}.tar.gz",
        verified: "github.com/OpenListTeam/OpenList"
    version "4.1.10"
    license "AGPL-3.0-only"
  
    if OS.mac?
      if Hardware::CPU.arm?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-arm64.tar.gz"
        sha256 "e6237ca1e68514b2b64967d9380114f5d02f1e7edde9297006ecf4c71080bd69"
      elsif Hardware::CPU.intel?
        url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-amd64.tar.gz"
        sha256 "8dd42380d1d3103fc589a0b22d076e1c1d8ec6c0d233dd9b8b314a9be4d16f5b"
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