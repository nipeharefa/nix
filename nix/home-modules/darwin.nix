{ pkgs, ... }:
{
  home = {
    packages = [ pkgs._1password-cli ];
    sessionPath = [
      "/opt/homebrew/bin"
    ];
  };
}
