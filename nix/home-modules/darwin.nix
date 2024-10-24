{ pkgs, ... }:
{
  home = {
    packages = [ pkgs._1password ];
    sessionPath = [
      "/opt/homebrew/bin"
    ];
  };
}
