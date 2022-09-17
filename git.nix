{ config, environment, pkgs, ... }:

let
    work = 1;
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      url = {
        "git@gitlab.com" = {
            insteadOf = "https://gitlab.com";
        };
      };
    };
    aliases = {
        recent = "branch --sort=-committerdate --format=\'%(committerdate:relative)%09%(refname:short)\'";
    };
  };
}
