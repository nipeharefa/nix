{ pkgs, lib, ... }:
{
  environment.shells = with pkgs; [
    # bashInteractive
    # fish
    zsh
  ];

  environment.variables = {
    # CC = "${gcc}/bin/gcc";
  };

  nix = {
    configureBuildUsers = true;
    useDaemon = true;
    settings = {
      auto-optimise-store = true;
      sandbox = "relaxed";
      cores = 1;
      max-jobs = 8;
      trusted-users = [
        "@admin"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "gowi.cachix.org-1:IsoKXakETjg57xeM4tmS162ZLh04GocIBqhxTC7kF9k="
        "tricktron.cachix.org-1:N1aBeQuELyEAOgvizaDC/qqFltwv7N7oSMaNozyDz6w="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://tricktron.cachix.org"
        "https://cache.nixos.org/"
        "https://gowi.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # yggdrasil
    # iterm2
    dnsproxy
    dnscrypt-proxy2
    # terminal-notifier
  ];

  # font
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
  ];
}
