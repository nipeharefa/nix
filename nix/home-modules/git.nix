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
    settings = {
      init = {
        defaultBranch = "main";
      };
      push = {
        default = "upstream";
        autoSetupRemote = true;
      };
      url = {
        "ssh://git@github.com/".insteadOf = [
          "https://github.com/"
          "gh:"
          "github:"
        ];
        "https://bitbucket.org/".insteadOf = [
          "bitbucket:"
        ];
      };
      extraConfig = {
        commit.gpgSign = true;
        pull.rebase = true;
        gpg.program = "gpg";
        fetch.prune = true;
      };
      aliases = {
        branches = "branch --sort=-committerdate --format='%(HEAD)%(color:yellow) %(refname:short) | %(color:bold red)%(committername) | %(color:bold green)%(committerdate:relative) | %(color:blue)%(subject)%(color:reset)' --color=always";
        bs = "branches";
        update = "pull --rebase origin git_main_branch";
        can = "commit --amend --no-edit";
        recent = "branch --sort=-committerdate --format=\'%(committerdate:relative)%09%(refname:short)\'";
      };
    };
    # ignores = [
    #   ".#*"
    #   ".DS_Store"
    #   ".dir-locals.el"
    #   ".direnv/"
    #   ".idea/"
    #   ".vscode/"
    #   ".clj-kondo/"
    #   ".lsp/"
    #   "*.iml"
    #   ".zed/"
    # ];
    includes = [
      {
        condition = "gitdir:~/projects/gowi";
        contents.user = nipe;
      }
    ];
  };
}
