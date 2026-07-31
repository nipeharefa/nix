{ config, ... }:
{
  sops = {
    defaultSopsFile = "${../secrets/secret.enc.yaml}";
    gnupg = {
      home = "~/.gnupg";
    };
    secrets."mong" = {
      key = "openai_api_key";
      path = "${config.home.homeDirectory}/.ssh/mong";
    };
    secrets."happy/smt" = {
      mode = "0600";
      path = "${config.home.homeDirectory}/.ssh/hs";
    };
  };
}
