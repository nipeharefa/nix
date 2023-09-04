{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home = {
    username = "nipeharefa";
    stateVersion = "25.11"; # 25.11
    homeDirectory = if isDarwin then "/Users/nipeharefa" else "/home/nipeharefa";
  };
}
