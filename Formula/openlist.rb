class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  version "4.2.1"

  if Hardware::CPU.arm?
    url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-arm64.tar.gz"
    sha256 "fe277f79e01ef3eec4086d31672a9579f9e29dab34a125120618ac6c56edb029"
  else
    url "https://github.com/OpenListTeam/OpenList/releases/download/v#{version}/openlist-darwin-amd64.tar.gz"
    sha256 "1038bcd19050b283fc889c34dac9a7a471ce083414d4acfa4dd4f96864579bdd"
  end

  def install
    libexec.install "openlist"

    (bin/"openlist").write <<~SHELL
      #!/bin/bash
      cd "#{etc}/openlist" && exec "#{libexec}/openlist" "$@"
    SHELL
  end

  def post_install
    (etc/"openlist").mkpath
  end

  service do
    run [libexec/"openlist", "server"]
    keep_alive true
    working_dir etc/"openlist"
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
