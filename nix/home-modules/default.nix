{ ezModules, inputs, lib, ... }:
{

  imports = lib.attrValues
    {
      inherit (ezModules)
        awscli
        git
        home
        shell-generic
        tmux
        zsh
        ;
    } ++ [
    inputs.sops.homeManagerModules.sops
    ({ ... }: {
      home.sessionVariables.EDITOR = "nvim";
      home.sessionVariables.OPENAI_API_KEY = "$(cat ~/.config/sops-nix/secrets/openai_api_key)";
    })
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
  # xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  programs.home-manager.enable = true;

}
