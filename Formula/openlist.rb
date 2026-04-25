class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  version "4.2.2"
  license "AGPL-3.0-only"

  if Hardware::CPU.arm?
    url "https://github.com/OpenListTeam/OpenList/releases/download/v4.1.10/openlist-darwin-arm64.tar.gz"
    sha256 "e6237ca1e68514b2b64967d9380114f5d02f1e7edde9297006ecf4c71080bd69"
  else
    url "https://github.com/OpenListTeam/OpenList/releases/download/v4.1.10/openlist-darwin-amd64.tar.gz"
    sha256 "8dd42380d1d3103fc589a0b22d076e1c1d8ec6c0d233dd9b8b314a9be4d16f5b"
  end

  def install
    bin.install "openlist"
  end

  service do
    run [opt_bin/"openlist", "server", "--data", var/"openlist"]
    keep_alive true
    working_dir var/"openlist"
    log_path var/"log/openlist.log"
    error_log_path var/"log/openlist.log"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end
