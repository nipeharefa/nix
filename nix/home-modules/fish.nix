{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      vim = "nvim";
      npu = "nix-prefetch-url";
      # Kubectl shortcuts
      kgp = "kubectl get pods";
      keti = "kubectl exec -it";
      klf = "kubectl logs -f --ignore-errors";
      klfsel = "kubectl logs -f --ignore-errors --selector=";
    };
    shellAliases = {
      # General
      ll = "ls -lah";
      la = "ls -A";
      cl = "command clear";
      generate_pass = "openssl rand -base64 24";

      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Tmuxinator helper
      tx = "tmuxinator";
      # terraform
      tf = "tofu";
    };
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "fish-kubectl-completions";
        src = pkgs.fetchFromGitHub {
          owner = "evanlucas";
          repo = "fish-kubectl-completions";
          rev = "ced676392575d618d8b80b3895cdc3159be3f628";
          sha256 = "sha256-OYiYTW+g71vD9NWOcX1i2/TaQfAg+c2dJZ5ohwWSDCc=";
        };
      }
    ];
    functions = {
      __kubectl_get_selectors = {
        body = ''
          set -l selected (kubectl get pods -o json 2>/dev/null | jq -r '
                .items[] | 
                .metadata.labels | 
                to_entries[] | 
                "\(.key)=\(.value)"
            ' | sort | uniq -c | sort -rn | awk '{printf "%s\t(%d pods)\n", $2, $1}' | \
            fzf --height 90% \
                --border \
                --prompt "Selector: " \
                --with-nth=1 \
                --delimiter='\t' | \
            cut -f1)
            
            if test -n "$selected"
                commandline -i $selected
            end
            commandline -f repaint
          '';
      };
      kcn = {
        description = "Set kubectl namespace (with fzf if no args)";
        body = ''
          if test (count $argv) -eq 0
            # Interactive mode with fzf
            set -l namespace (kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null | tr " " "\n" | ${pkgs.fzf}/bin/fzf --height=40% --reverse --prompt='Select namespace> ')
            if test -n "$namespace"
              kubectl config set-context --current --namespace=$namespace
            end
          else
            # Direct mode with argument
            kubectl config set-context --current --namespace=$argv
          end
        '';
      };
      tree = {
        description = "";
        body = ''
          # Default exa options for tree view
          set default_opts "--tree"
          
          # Combine default options with any user-provided arguments
          command exa $default_opts $argv
        '';
      };
      git-clean-gone = {
        description = "";
        body = ''
          set mode safe
          for arg in $argv
              switch $arg
                  case '--dry-run' '-n'
                      set mode dry
                  case '--force' '-f'
                      set mode force
              end
          end
          set gone_branches (git branch -vv | awk '/: gone]/{print $1}')

          if test (count $gone_branches) -eq 0
              echo "No local branches with deleted remotes."
              return
          end

          echo "Branches with gone upstreams:"
          printf "  %s\n" $gone_branches

          if test $mode = dry
              echo "(dry-run) No branches deleted."
              return
          end

          if test $mode = force
              git branch -D $gone_branches
          else
              git branch -d $gone_branches
          end
        '';
      };
      git-recent = {
        description = "Git recent";
        body = ''
          git for-each-ref \
            --sort=-committerdate \
            --format='%(committerdate:relative)  %(refname:short)' \
            refs/heads/
        '';
      };
      gprom = {
        description = "git pull --rebase origin <default branch>";
        body = ''
          if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo "Not inside a git repository" >&2
            return 1
          end
          set -l default_branch (git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
          if test -z "$default_branch"
            echo "Unable to determine origin HEAD branch" >&2
            return 1
          end

          git pull --rebase origin $default_branch
        '';
      };
      zpi = {
        description = "Interactive zoxide jump with eza preview";
        body = ''
          if not command -sq zoxide
            echo "zoxide not found" >&2
            return 127
          end
          set -l target (command zoxide query -l | ${pkgs.fzf}/bin/fzf --height=60% --reverse --prompt 'Zoxide> ' --preview 'eza -a -l --color=always --group-directories-first {}' --preview-window=down,60%)
          if test -n "$target"
            builtin cd $target
          end
        '';
      };
      cf = {
        description = "fzf search file (skip .git/node_modules)";
        body = ''
          set -l preview "cat {}"
          if command -sq bat
            set preview "bat --style=numbers --color=always --paging=never {}"
          end
          set -l file (${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules | ${pkgs.fzf}/bin/fzf --height=60% --reverse --preview $preview --preview-window=right,60%,wrap)
          if test -n "$file"
            commandline -it -- "$file"
          end
        '';
      };
      cz = {
        description = "fzf search directory (skip .git/node_modules)";
        body = ''
          set -l dir (${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules | ${pkgs.fzf}/bin/fzf --height=60% --reverse --preview 'eza -a -l --color=always --group-directories-first {}' --preview-window=right,50%)
          if test -n "$dir"
            cd $dir
          end
        '';
      };
      nix-dev-php = {
        description = "Enter the PHP dev shell from anywhere";
        body = ''
          set -l repo ~/.config/nixpkgs
          if test (count $argv) -ge 1
            set repo $argv[1]
          end
          if command -sq realpath
            set repo (realpath $repo)
          end
          if not test -d $repo
            echo "Repository not found: $repo" >&2
            return 1
          end
          nix develop "$repo#php"
        '';
      };
      __cd_fzf = {
        description = "FZF-assisted directory picker";
        body = ''
          if test (count $argv) -gt 0
            builtin cd $argv
            return
          end

          set -l target (${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules \
            | ${pkgs.fzf}/bin/fzf --height=60% --reverse --prompt 'Directories> ' \
                --preview 'eza -a -l --color=always --group-directories-first {}' --preview-window=right,60%)

          if test -n "$target"
            builtin cd $target
          end
        '';
      };
      cd = {
        description = "cd; no args jumps via zoxide frecency (with preview), falls back to directory picker";
        body = ''
          if test (count $argv) -gt 0
            builtin cd $argv
            return
          end

          if command -sq zoxide
            set -l dirs (command zoxide query -l 2>/dev/null)
            if test -n "$dirs"
              set -l target (printf '%s\n' $dirs | ${pkgs.fzf}/bin/fzf --height=60% --reverse --prompt 'Zoxide> ' \
                --preview 'eza -a -l --color=always --group-directories-first {}' --preview-window=right,60%)
              if test -n "$target"
                builtin cd $target
              end
              return
            end
          end

          __cd_fzf
        '';
      };
      gwl = {
        description = "List all git worktrees";
        body = ''
          git worktree list
        '';
      };
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -g fish_pager_color_completion
      set -g fish_pager_color_prefix
      set -g fish_pager_color_progress
      
      abbr -a kpf 'kubectl port-forward'
      abbr -a kdp 'kubectl describe pod'
      abbr -a kgno 'kubectl get node'
      abbr -a k 'kubectl'

      complete -c gwd -d "Remove worktree and branch"
      complete -c gwl -d "List all worktrees"

      # Completion for kcn function - autocomplete namespaces
      complete -c kcn -f -a '(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null | tr " " "\n")'

      # Completion for --selector flag
      complete -c kubectl \
        # -n '__fish_seen_subcommand_from logs; and __fish_contains_opt -s f follow' \
        -l selector -f -a '(__kubectl_get_selectors)' -d 'Selector (label query)'

    '';
  };

  home.packages = with pkgs; [
    bat
    delta
    fd
    ripgrep
  ];
}
