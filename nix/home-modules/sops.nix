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
    secrets."opencode_otlp_endpoint" = {
      mode = "0400";
      path = "${config.home.homeDirectory}/.config/sops-nix/opencode_otlp_endpoint";
    };
  };
}
