{ lib, ... }:
{
  imports = [
    ./awscli
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./home.nix
    ./neovim.nix
    ./shell.nix
    ./shell-generic.nix
    ./sops.nix
    ./starship.nix
    ./tmux
    (
      { ... }:
      {
        home.shell.enableFishIntegration = true;
      }
    )
  ];

  programs.home-manager.enable = true;
}
