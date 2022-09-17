{ pkgs, lib, ... }:
{

  launchd.daemons.dnsproxy = {
    serviceConfig.RunAtLoad = true;
    serviceConfig.StandardOutPath = "/tmp/launchd-dnscrypt.log";
    serviceConfig.StandardErrorPath = "/tmp/launchd-dnscrypt.error";
    serviceConfig.ProgramArguments = [
      "${pkgs.dnsproxy}/bin/dnsproxy"
      "-u"
      "https://dns.google/dns-query"
      "-u"
      "quic://dns.adguard-dns.com"
      "-u"
      "https://cloudflare-dns.com/dns-query"
      # PureDNS
      "-u"
      "172.64.36.2"
      # End of PureDNS
      "-b"
      "172.64.36.2"
      "--cache-min-ttl=600"
      "--fastest-addr"
    ];
  };
  # launchd.agents.dnsproxy = {
  #   serviceConfig.RunAtLoad = true;
  #   serviceConfig.StandardOutPath = "/tmp/launchd-dnscrypt.log";
  #   serviceConfig.StandardErrorPath = "/tmp/launchd-dnscrypt.error";
  #   serviceConfig.ProgramArguments = [
  #     "${pkgs.dnsproxy}/bin/dnsproxy"
  #     "-u"
  #     "sdns://AgcAAAAAAAAABzEuMC4wLjGgENk8mGSlIfMGXMOlIlCcKvq7AVgcrZxtjon911-ep0cg63Ul-I8NlFj4GplQGb_TTLiczclX57DvMV8Q-JdjgRgSZG5zLmNsb3VkZmxhcmUuY29tCi9kbnMtcXVlcnk"
  #     # PureDNS
  #     "-u"
  #     "sdns://AgcAAAAAAAAADDE0Ni4xOTAuNi4xM6DMEGDTnIMptitvvH0NbfkwmGm5gefmOS1c2PpAj02A5iBETr1nu4P4gHs5Iek4rJF4uIK9UKrbESMfBEz18I33zgtwdXJlZG5zLm9yZwovZG5zLXF1ZXJ5"
  #     "-u"
  #     "sdns://AgcAAAAAAAAAG1syNDAwOjYxODA6MDpkMDo6MTExMTpjMDAxXaDMEGDTnIMptitvvH0NbfkwmGm5gefmOS1c2PpAj02A5iBETr1nu4P4gHs5Iek4rJF4uIK9UKrbESMfBEz18I33zgtwdXJlZG5zLm9yZwovZG5zLXF1ZXJ5"
  #     # End of PureDNS
  #     "-b"
  #     "1.1.1.1"
  #     "--cache-min-ttl=600"
  #     "--fastest-addr"
  #     "--cache"
  #   ];
  # };

  nix = {
    configureBuildUsers = true;
    useDaemon = true;
    settings = {
      auto-optimise-store = true;
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
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
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
}
