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
      # GOROOT = "${pkgs.go_1_26}/share/go";
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

  sops = {
    # enable = true;
    # defaultSopsFile
    defaultSopsFile = "${../secrets/secret.enc.yaml}";
    gnupg = {
      home = "~/.gnupg";
    };
    secrets."mong" = {
      key = "openai_api_key";
      # neededForUsers = true;
      path = "${config.home.homeDirectory}/.ssh/mong";
    };
    secrets."happy/smt" = {
      # key = "happy.smt";
      # neededForUsers = true;
      mode = "0600";
      path = "${config.home.homeDirectory}/.ssh/hs";
    };
    # secrets."ssh_configd/cerebre" = {
    #   path = "${config.home.homeDirectory}/.ssh/aa";
    # };
  };
}
