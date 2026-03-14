cask "playcover-nightly" do
  version :latest
  sha256 :no_check

  # 1. 指向 nightly.link 的展示页面
  url "https://nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/develop" do |page|
    # 2. 使用正则表达式从页面源码中提取包含 "PlayCover_nightly" 字样且以 ".dmg.zip" 结尾的链接
    file_path = page[%r{href="([^"]+PlayCover_nightly_[^"]+\.dmg\.zip)"}, 1]
    
    # 3. 拼接成完整的下载地址
    "https://nightly.link#{file_path}" if file_path
  end
  
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https://github.com/PlayCover/PlayCover"
  
  auto_updates true
  conflicts_with cask: "playcover-community"
  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "PlayCover.app"

  zap trash: [
    "~/Library/Application Support/io.playcover.PlayCover",
    "~/Library/Caches/io.playcover.PlayCover",
    "~/Library/Containers/io.playcover.PlayCover",
    "~/Library/Frameworks/PlayTools.framework",
    "~/Library/Preferences/io.playcover.PlayCover.plist",
    "~/Library/Saved Application State/io.playcover.PlayCover.savedState",
  ]
end
