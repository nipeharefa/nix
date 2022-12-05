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
    "iterm2"
    "krakend"
  ];
in
attrsets.genAttrs packages (name: pkgs.callPackage ./${name}.nix { })
