{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> {
    inherit system;
  }
, attrsets
,
}:


let
  packages = [
    "brave"
    "edge"
    "telegram"
    "air"
    "iterm2"
  ];
in
attrsets.genAttrs packages (name: pkgs.callPackage ./${name}.nix { })