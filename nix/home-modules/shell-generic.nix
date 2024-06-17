{ config, osConfig, lib, pkgs, ... }:
let

  shellAliases = with pkgs; {
    c = "z";
    tf = "terraform";
  };

in
{
  home = {
    shellAliases = shellAliases;
    sessionVariables = {
      EDITOR = "nvim";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
      GOWI = "${config.sops.secrets.openai_api_key.path}";
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
      # sopsFile = ./secrets.yaml;
      key = "openai_api_key";
    };
  };
}
