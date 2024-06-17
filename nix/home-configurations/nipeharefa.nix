{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home = {
    username = "nipeharefa";
    stateVersion = "22.05";
    homeDirectory = if isDarwin then "/Users/nipeharefa" else "/home/nipeharefa";
  };
}
