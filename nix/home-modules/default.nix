{ ezModules, inputs, lib, ... }:
{

  imports = lib.attrValues {
    inherit (ezModules)
      git
      home
      shell-generic
      tmux
      zsh
      ;
  } ++ [inputs.sops-nix.homeManagerModules.sops];

  nixpkgs.config = {
    allowUnfree = true;
  };
  # xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  programs.home-manager.enable = true;

}
