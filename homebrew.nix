{ pkgs, config, lib, ... }:
{
	homebrew = {
    enable = true;
    casks = [
      "dbeaver-community" "gather" "pritunl"
      "google-chrome" "spotify" "visual-studio-code" "steam" "telegram"
      "microsoft-edge" "discord" "slack" "zulu" "android-studio"
    ];

    brews = [
      "mitmproxy"
    ];
    # cleanup = "zap";
    taps = [
      "nrlquaker/createzap"
      "homebrew/cask"
    ];
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;
  };
}
