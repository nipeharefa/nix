{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  # secretspath = builtins.toString inputs.nix-secrets;
  shellAliases = with pkgs; {
    # Moved to fish.nix to avoid conflicts
  };

in
{
  home = {
    # shellAliases = shellAliases;
    sessionVariables = {
      EDITOR = "nvim";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };
  };

  programs.man = {
    enable = true;
    generateCaches = false;
  };

  programs.fish = {
    functions.nixgc = {
      description = "Run garbage collection for Nix store (user + system)";
      body = ''
        echo "==> nix-collect-garbage --delete-older-than 7d"
        nix-collect-garbage --delete-older-than 7d
        if command -sq sudo
          echo "==> sudo nix-collect-garbage --delete-older-than 7d"
          sudo nix-collect-garbage --delete-older-than 7d
        end
        echo "==> nix-store --optimise"
        nix-store --optimise
      '';
    };
  };

  # sops = {
  #   enable = true;
  # };
  # sops.gnupg.home = "~/.gnupg";
  # sops.defaultSopsFormat = "yaml";
  # sops.gnupg.sshKeyPaths = [ ];
  # sops.defaultSopsFile = "${../secrets/secret.yaml}";
  # sops.secrets = {
  #   openai_api_key = {
  #     key = "openai_api_key";
  #   };
  #   mong = {
  #     key = "mong";
  #   };
  # };
  sops = {
    # enable = true;
    # defaultSopsFile
    defaultSopsFile = "${../secrets/secret.yaml}";
    gnupg = {
      home = "~/.gnupg";
    };
    secrets."mong" = {
      key = "openai_api_key";
      # neededForUsers = true;
      path = "${config.home.homeDirectory}/.ssh/mong";
    };
    # secrets."ssh_configd/cerebre" = {
    #   path = "${config.home.homeDirectory}/.ssh/aa";
    # };
  };
}
