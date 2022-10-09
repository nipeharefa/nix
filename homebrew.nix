{ pkgs, config, lib, ... }:
{
	homebrew = {
    enable = true;
    casks = [
      "dbeaver-community" "gather" "pritunl"
      "google-chrome" "spotify" "visual-studio-code" "steam" "telegram"
      "microsoft-edge" "discord" "slack"
    ];

    brews = [
      "mitmproxy"
    ];
    # cleanup = "zap";
    taps = [
      "nrlquaker/createzap"
    ];
    # onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;
  };
}
