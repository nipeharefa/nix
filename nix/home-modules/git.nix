{ pkgs, ... }:

let
  nipe = {
    name = "Nipe";
    email = "me@nipeharefa.dev";
  };
in
{
  fonts.fontconfig.enable = true;
  programs.git = {
    enable = true;
    extraConfig = {
      pull.ff = "only";
      commit.gpgSign = true;
      pull.rebase = true;
      gpg.program = "gpg";
      init.defaultBranch = "main";
      url = {
        "git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git@bitbucket.org:" = {
          insteadOf = "https://bitbucket.org/";
        };
      };
    };
    aliases = {
      branches = "branch --sort=-committerdate --format='%(HEAD)%(color:yellow) %(refname:short) | %(color:bold red)%(committername) | %(color:bold green)%(committerdate:relative) | %(color:blue)%(subject)%(color:reset)' --color=always";
      bs = "branches";
      update = "pull --rebase origin git_main_branch";
      can = "commit --amend --no-edit";
      recent = "branch --sort=-committerdate --format=\'%(committerdate:relative)%09%(refname:short)\'";
    };
    includes = [
      {
        condition = "gitdir:~/projects/gowi";
        contents.user = nipe;
      }
    ];
  };
}
