{ pkgs, inputs, ... }:
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
  nix = {
    # binary-caches = [ "https://cache.komunix.org/" "https://cache.nixos.org/"];
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      fallback = true;
      trusted-users = [ "@admin" ];
      substituters = pkgs.lib.mkBefore [ "https://cache.komunix.org/" ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.komunix.org/"
      ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # extraOptions = ''
      #   keep-outputs = true
      #   keep-derivations = true
      #   auto-allocate-uids = false
      #   builders-use-substitutes = true
      #   http-connections = 0
      # '';
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = {
        Hour = 3;
        Minute = 15;
        Weekday = 6;
      };
    };

    # registry = {
    #   nixpkgs.flake = inputs.nixpkgs;
    # };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };
  services.nix-daemon.enable = true;
  system.stateVersion = 5;
}
