cask "clashx-meta" do
    version "1.4.18"
    sha256 "e140752257f14dce92e1abc60ae7a89f6a907d7d8aded14647130382822b00d1"
  
    url "https://github.com/MetaCubeX/ClashX.Meta/releases/download/v#{version}/ClashX.Meta.zip"
    name "ClashX Meta"
    desc "Rule-based custom proxy with GUI based on Clash.Meta"
    homepage "https://github.com/MetaCubeX/ClashX.Meta"
  
    auto_updates true
    livecheck do
      url :url
      strategy :github_latest
    end
  
    app "ClashX Meta.app"
  
    uninstall launchctl: "com.metacubex.ClashX.ProxyConfigHelper",
              quit:      "com.metacubex.ClashX",
              delete:    [
                "/Library/LaunchDaemons/com.metacubex.ClashX.ProxyConfigHelper.plist",
                "/Library/PrivilegedHelperTools/com.metacubex.ClashX.ProxyConfigHelper",
              ]
  
    zap trash: [
      "~/Library/Application Support/com.metacubex.ClashX.meta",
      "~/Library/Caches/com.metacubex.ClashX.meta",
      "~/Library/Logs/ClashX Meta",
      "~/Library/Preferences/com.metacubex.ClashX.meta.plist",
    ]
  end