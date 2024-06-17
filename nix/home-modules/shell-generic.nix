{ config, osConfig, pkgs, ... }:
let

  shellAliases = with pkgs; {
    c = "z";
    tf = "terraform";
  };

in {
  home = {
    shellAliases = shellAliases;
  };
  
  sops.gnupg.home = "~/.gnupg";
  sops.gnupg.sshKeyPaths = [ ];
  sops.defaultSopsFile = "${../secrets/secret.yaml}";
  sops.secrets.openai_api_key.path = "openai_api_key";
}
