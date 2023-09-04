{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let

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
      GOWI = config.sops.secrets.openai_api_key.path;
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
  sops.gnupg.home = "~/.gnupg";
  sops.defaultSopsFormat = "yaml";
  sops.gnupg.sshKeyPaths = [ ];
  sops.defaultSopsFile = "${../secrets/secret.yaml}";
  sops.secrets = {
    openai_api_key = {
      key = "openai_api_key";
    };
    mong = {
      key = "mong";
    };
  };
}
