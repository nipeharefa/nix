{ pkgs, config, lib, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "dbeaver-community"
      "gather"
      "pritunl"
      "google-chrome"
      "spotify"
      "visual-studio-code"
      "steam"
      "telegram"
      "microsoft-edge"
      "discord"
      "slack"
      "zulu"
      "android-studio"
      "tailscale"
      "brave-browser"
      "iterm2"
      "postman"
      "cloudflare-warp"
      "obs"
      "krisp"
      "stats"
    ];

    brews = [
      "mitmproxy"
      "wireguard-tools"
      "libpq"
      "helm"
      "iproute2mac"
    ];
    # cleanup = "zap";
    taps = [
      # "nrlquaker/createzap"
      # "homebrew/cask"
    ];
  };
}
