{ pkgs, lib, config, ... }:

{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        kubernetes = {
          disabled = false;
        };
        # format = "$directory$git_branch$git_status$kubernetes\n$character";
        palette = "catppuccin_mocha";
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          surface0 = "#313244";
          surface1 = "#45475a";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
        character = {
          success_symbol = "[❯](green)";
          error_symbol = "[❯](red)";
          vicmd_symbol = "[❮](blue)";
        };
        directory = {
          style = "bold lavender";
          truncation_length = 1;
          truncate_to_repo = false;
        };
        git_branch = {
          symbol = " ";
          style = "bold mauve";
        };
        git_status = {
          style = "italic peach";
          format = "([$all_status$ahead_behind]($style))";
        };
      };
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
      fileWidgetCommand = ''
        ${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules
      '';
      changeDirWidgetCommand = ''
        ${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules
      '';
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    # vscode = {
    #   enable = false;
    #   extensions = with pkgs.vscode-marketplace; [
    #     bbenoist.nix
    #     bierner.markdown-mermaid
    #     dbaeumer.vscode-eslint
    #     eamodio.gitlens
    #     esbenp.prettier-vscode
    #     golang.go
    #     redhat.vscode-yaml
    #     asvetliakov.vscode-neovim
    #     bmewburn.vscode-intelephense-client
    #   ];
    # };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      extraLuaConfig = ''
        local claudecode = require('claudecode')
        local neogit = require('neogit')
        local nvimtree = require('nvim-tree')
        local ibl = require('ibl')
        local webicons = require("nvim-web-devicons")
        local wk = require("which-key")

        neogit.setup({})
        ibl.setup({})
        nvimtree.setup({})
        webicons.setup({})
        claudecode.setup({})

        vim.g.mapleader = " "
        local keymap = vim.keymap.set
        keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
        keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fgb', builtin.git_branches, { desc = 'Branches' })
        vim.keymap.set('n', '<leader>fgs', builtin.git_status, { desc = 'Lists current changes git per file with diff preview and add action' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set("n", "<leader>sc", "<C-w>c", { desc = "Close split" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>")

        -- Wrap in a function to pass additional arguments
        vim.keymap.set(
            "n",
            "<leader>gg",
            function() neogit.open({ kind = "split" }) end,
            { desc = "Open Neogit UI" }
        )

        wk.add({
          { "<leader>f", group = "file" }, -- group
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" }
        })

      '';
      extraConfig = ''
        set nocompatible
        set nobackup
        set hidden
        set list
        set listchars=tab:↦\ ,trail:⬝
        set clipboard=unnamedplus
        set mouse=a
        set signcolumn=yes:2

        set relativenumber
        autocmd InsertEnter * :set number
        autocmd InsertLeave * :set relativenumber

        set scrolloff=8
        set sidescrolloff=8
        set updatetime=300
        
        map <C-j> <C-W>j
        map <C-k> <C-W>k
        map <C-h> <C-W>h
        map <C-l> <C-W>l

        set laststatus=2
      '';
      plugins = with pkgs.vimPlugins; [
        ctrlp
        # nerdtree
        # nerdtree-git-plugin
        # vim-devicons
        telescope-nvim
        which-key-nvim

        nvim-treesitter
        nvim-tree-lua

        nvim-web-devicons
        neogit
        indent-blankline-nvim
        snacks-nvim
        claudecode-nvim

        vim-go

        # tree-sitter-lua
        # tree-sitter-go

        #keymap
        # {
        #   plugin = keymapConfig;
        #   type = "lua";
        #   config = builtins.readFile ../config/nvim/keymap.lua;
        # }
      ];
    };
    fish = {
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

        # # Git workflow
        # gs = "git status -sb";
        # ga = "git add";
        # gc = "git commit";
        # gcm = "git commit -m";
        # gca = "git commit --amend --no-edit";
        # # gco = "git checkout";
        # gcb = "git checkout -b";
        # gb = "git branch";
        # gbd = "git branch -d";
        # gbdD = "git branch -D";
        # gd = "git diff";
        # gl = "git log --oneline --graph --decorate";
        # gpl = "git pull --rebase --autostash";
        # gps = "git push";
        # gfa = "git fetch --all --prune";
        # gp = "git push";
        # gpsup = "git push --set-upstream";
        delete-gone-branch = "git branch --verbose | grep '\[gone\]' | awk '{print $1}' | xargs git branch -D";

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
        zi = {
          description = "Interactive zoxide jump";
          body = ''
            if not command -sq zoxide
              echo "zoxide not found" >&2
              return 127
            end
            set -l target (command zoxide query -l | ${pkgs.fzf}/bin/fzf --height=40% --reverse --prompt 'Zoxide> ' --preview 'ls -a {}' --preview-window=down,60%)
            if test -n "$target"
              cd $target
            end
          '';
        };
        cf = {
          description = "fzf search file (skip .git/node_modules)";
          body = ''
            set -l preview "cat {}"
            if command -sq bat
              set preview "bat --style=numbers --color=always {}"
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
            set -l dir (${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules | ${pkgs.fzf}/bin/fzf --height=60% --reverse --preview 'ls -a {}' --preview-window=right,50%)
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
                  --preview 'ls -a {}' --preview-window=right,60%)

            if test -n "$target"
              builtin cd $target
            end
          '';
        };
        cd = {
          description = "cd with optional fzf preview";
          body = ''
            if test (count $argv) -eq 0
              __cd_fzf
            else
              builtin cd $argv
            end
          '';
        };
      };
      interactiveShellInit = ''
        set -g fish_greeting ""
        abbr -a kpf 'kubectl port-forward'
        abbr -a kdp 'kubectl describe pod'
        abbr -a kgno 'kubectl get node'
        abbr -a k 'kubectl' 

        # Completion for kcn function - autocomplete namespaces
        complete -c kcn -f -a '(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null | tr " " "\n")'

        # Completion for --selector flag
        complete -c kubectl \
          # -n '__fish_seen_subcommand_from logs; and __fish_contains_opt -s f follow' \
          -l selector -f -a '(__kubectl_get_selectors)' -d 'Selector (label query)'

      '';
    };
  };

  home.packages = with pkgs; [
    bat
    delta
    fd
    ripgrep
    
    # pkgs.babelfish
    # pkgs.fishPlugins.colored-man-pages
    # https://github.com/franciscolourenco/done
    # pkgs.fishPlugins.done
    # # use babelfish than foreign-env
    # pkgs.fishPlugins.foreign-env
    # # https://github.com/wfxr/forgit
    # pkgs.fishPlugins.forgit
    # # Paired symbols in the command line
    # pkgs.fishPlugins.pisces
    # pkgs.fishPlugins.puffer
    # pkgs.fishPlugins.fifc
    # pkgs.fishPlugins.bass
  ];
}
