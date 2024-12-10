{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home = {
    username = "nipeharefa";
    stateVersion = "24.11";
    homeDirectory = if isDarwin then "/Users/nipeharefa" else "/home/nipeharefa";
  };
}
