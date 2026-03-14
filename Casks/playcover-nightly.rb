cask "playcover-nightly" do
  version :latest
  sha256 :no_check

  url do
    require "net/http"
    require "uri"

    workflow_url = "https://nightly.link/PlayCover/PlayCover/workflows/2.nightly_release/develop"
    response = Net::HTTP.get_response(URI(workflow_url))
    "#{response["location"]}.zip"
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
