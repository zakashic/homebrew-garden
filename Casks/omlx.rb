cask "omlx" do
  on_sequoia do
    version "0.3.0"
    sha256 "cefdcab2b34e72eb0fd86d0c2a6c47e815744a13b57ea9cb37abcaf5ba5a8995"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg"
  end
  on_tahoe do
    version "0.3.0"
    sha256 "7669822e4a1011888231da8c5bd8189ad8011519a845da0a3aa469fb1647aebc"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-tahoe.dmg"
  end

  name "oMLX"
  desc "Graphical interface for running MLX models locally"
  homepage "https://github.com/jundot/omlx"

  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "oMLX.app"
end
