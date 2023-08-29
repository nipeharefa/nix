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
        git
        home
        shell-generic
        tmux
        fish
        ;
    }
    ++ [
      inputs.sops.homeManagerModules.sops
      (
        { ... }:
        {
          home.shell.enableFishIntegration = true;
          home.sessionVariables.EDITOR = "nvim";
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

    overlays = lib.attrValues inputs.self.overlays ++ [
      # inputs.ocaml-overlay.overlays.default
    ];
  };
  # xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  programs.home-manager.enable = true;

}
