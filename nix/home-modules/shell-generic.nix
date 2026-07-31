{ ... }:
{
  home = {
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
}
