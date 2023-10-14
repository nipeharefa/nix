{ pkgs, config, lib, ... }:
{
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
  '';
  environment = with pkgs; {
    shells = [
      fish
      zsh
    ];

    variables = {
      SHELL = "${fish}/bin/fish";
      CC = "${gcc}/bin/gcc";
    };
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
        "fossar.cachix.org-1:Zv6FuqIboeHPWQS7ysLCJ7UT7xExb4OE8c4LyGb5AsE="
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://fossar.cachix.org/"
      ];
      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  # font
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
  ];
}
