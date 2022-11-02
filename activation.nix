{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
} 
