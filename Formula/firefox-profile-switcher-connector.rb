class FirefoxProfileSwitcherConnector < Formula

    desc "The native component of the Profile Switcher for Firefox extension."
    homepage "https://github.com/null-dev/firefox-profile-switcher-connector"
    url "https://github.com/null-dev/firefox-profile-switcher-connector/archive/refs/tags/v0.0.7.tar.gz"
    sha256 "1fe2075e2a5bd42455b07771f3e6a08cdee6945e859a304ce715899d505555d6"
    version "0.0.7"
    depends_on "rust" => :build

    @@manifest_name = "ax.nd.profile_switcher_ff.json"

    def install
      system "cargo", "build", "--release", "--bin", "firefox_profile_switcher_connector"

      bin_name = "ff-pswitch-connector"
      bin_path = File.expand_path(bin / bin_name)
      # Fix manifest
      orig_manifest_path = "manifest/manifest-mac.json"
      manifest_contents = File.read(orig_manifest_path)
      manifest_contents = manifest_contents.gsub(/(^\s*"path"\s*:\s*").*("\s*,?\s*$)/) { $1 + bin_path + $2 }
      File.open(orig_manifest_path, "w") {|f| f.puts manifest_contents }

      # Install files
      prefix.install orig_manifest_path => @@manifest_name
      bin.install "target/release/firefox_profile_switcher_connector" => bin_name
    end

    def post_install
      manifest_path = File.expand_path(prefix, @@manifest_name)
      manifest_destination = File.expand_path('~/Library/Application Support/Mozilla/NativeMessagingHosts')
      system "id"
      system "mkdir", "-p", manifest_destination
      system "ln", "-sf", "#{manifest_destination}/#{@@manifest_name}"
    end
  end
