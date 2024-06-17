{ inputs, pkgs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable { inherit (pkgs.stdenv) system; };
  inherit (unstable-pkgs.darwin) linux-builder;
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.nipeharefa.home = "/Users/nipeharefa";
}

