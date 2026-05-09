{ pkgs, lib, inputs, config, ... }:
let
  defaultPrimaryUser = "nipeharefa";
  primaryUser = config.system.primaryUser or defaultPrimaryUser;
in
{
  homebrew = {
    onActivation = {
      autoUpdate = false;
    };
    enable = false;
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
      "tailscale-app"
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
      "iproute2mac"
    ];
    # cleanup = "zap";
    taps = [
      # "nrlquaker/createzap"
      # "homebrew/cask"
    ];
  };
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      fallback = true;
      trusted-users = [ "nipeharefa" "@admin" ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-substituters = [ 
        "https://nix-community.cachix.org" 
        "https://cache.clan.lol" 
        "https://mtech.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.clan.lol-1:3KztgSAB5R1M+Dz7vzkBGzXdodizbgLXGXKXlcQLA28="
        "mtech.cachix.org-1:cPDMKB6bI2DjpXfsE8dOcYOdaas9afdRNhLA0MEfXuo="
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
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  # Keep Fish registered and ensure the system drops the Nix PATH glue scripts
  environment.shells = lib.mkAfter [ pkgs.fish ];
  programs.fish.enable = true;
  users.users.${primaryUser}.shell = pkgs.fish;

  ids.uids.nixbld = lib.mkForce 350;
  system.stateVersion = 4;
  system.primaryUser = lib.mkDefault defaultPrimaryUser;

  # sops-nix configuration
  # sops = {
  #   defaultSopsFile = ../../secrets/secret.yaml;
  #   gnupg.home = "/Users/${primaryUser}/.gnupg";
  #   gnupg.sshKeyPaths = [ ];
  # };
}
