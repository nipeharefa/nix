{ pkgs, lib, ... }:
{

  launchd.agents.dnsproxy = {
    serviceConfig.RunAtLoad = true;
    serviceConfig.StandardOutPath = "/tmp/launchd-dnscrypt.log";
    serviceConfig.StandardErrorPath = "/tmp/launchd-dnscrypt.error";
    serviceConfig.ProgramArguments = [
      "${pkgs.dnsproxy}/bin/dnsproxy"
      "-u"
      "quic://dns.adguard-dns.com"
      "-u"
      "https://cloudflare-dns.com/dns-query"
      # PureDNS
      "-u"
      "172.64.36.2"
      # End of PureDNS
      "-b"
      "8.8.8.8:53"
      "-b"
      "9.9.9.9:53"
      "--cache"
      "--cache-min-ttl=600"
      "--fastest-addr"
    ];
  };

  nix = {
    configureBuildUsers = true;
    useDaemon = true;
    settings = {
      auto-optimise-store = true;
      sandbox = "relaxed";
      cores = 1;
      max-jobs = 8;
      trusted-users = [
        "@admin"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "gowi.cachix.org-1:IsoKXakETjg57xeM4tmS162ZLh04GocIBqhxTC7kF9k="
        "tricktron.cachix.org-1:N1aBeQuELyEAOgvizaDC/qqFltwv7N7oSMaNozyDz6w="
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://tricktron.cachix.org"
        "https://cache.nixos.org/"
        "https://gowi.cachix.org"
      ];
      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # yggdrasil
    # iterm2
    dnsproxy
    dnscrypt-proxy2
    # terminal-notifier
  ];

# font
  # fonts.fontDir.enable = true;
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
  ];
}
