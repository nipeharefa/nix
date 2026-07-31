{
  ezModules,
  inputs,
  lib,
  config,
  ...
}:
{

  imports =
    lib.attrValues {
      inherit (ezModules)
        awscli
        fish
        fonts
        fzf
        git
        home
        neovim
        shell
        shell-generic
        sops
        starship
        tmux
        ;
    }
    ++ [
      inputs.sops.homeManagerModules.sops
      (
        { ... }:
        {
          home.shell.enableFishIntegration = true;
        }
      )
    ];

  # nixpkgs.config = {
  #   allowUnfree = true;
  #   overlays = "s";
  # };
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      tarball-ttl = 0;
      contentAddressedByDefault = false;
    };
  };
  # xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  programs.home-manager.enable = true;

}
