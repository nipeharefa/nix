{ pkgs, ... }:
{
  networking.hostName = "flock-mbp1-pro";
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.nipeharefa.home = "/Users/nipeharefa";
}
