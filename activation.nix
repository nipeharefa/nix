{ config, pkgs, lib, ... }:


let
  a = 1;
  shellAliases = with pkgs; {
    c = "z";
  };
in {
  home = with pkgs; {
    shellAliases = shellAliases;
    sessionVariables = {
      EDITOR = "nvim";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };
    sessionPath = [
      "$HOME/.yarn/bin"
      "$HOME/.npm-packages/bin"
      "$HOME/.npm-global/bin"
      "/opt/homebrew/bin"
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    ];
  };
}
# {
#   home.

#   home.

#   # Let Home Manager install and manage itself.
#   programs.home-manager.enable = true;
# } 
