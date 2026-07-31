{ ... }:

let
  nipe = {
    name = "Nipe";
    email = "me@nipeharefa.dev";
  };
in
{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_nipe";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Nipe";
        email = "me@nipeharefa.dev";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        default = "upstream";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      fetch = {
        prune = true;
      };
      gpg = {
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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

  home.file.".ssh/allowed_signers".text = ''
    me@nipeharefa.dev namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZPQuDCC7n1bXtV3vahNSxliOZPBbnUCf+7DqvQTanO me@nipeharefa.dev
  '';
}
