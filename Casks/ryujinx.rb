cask "ryujinx" do
    version "1.3.3"
    sha256 "e4818bb84c98e0d3120691821e90772099e46101273d3f145ffdb10eee2c0dbb"
  
    url "https://git.ryujinx.app/projects/Ryubing/releases/download/#{version}/ryujinx-#{version}-macos_universal.app.tar.gz"
    name "Ryujinx"
    desc "Nintendo Switch emulator written in C#"
    homepage "https://git.ryujinx.app/projects/Ryubing"
  
    app "Ryujinx.app"
  
    zap trash: [
      "~/.config/Ryujinx",
      "~/Library/Saved Application State/org.ryujinx.Ryujinx.savedState",
    ]
  end
