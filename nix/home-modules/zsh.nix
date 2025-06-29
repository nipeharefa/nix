{ pkgs, lib, ... }:

{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        kubernetes = {
          disabled = false;
          symbol = "⎈ ";
          # format = '[$symbol](bright-black) [$context( \($namespace\))]($style)';
        };
      };
    };
    fzf = {
      enable = true;
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
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
      enableBashIntegration = true;
    };
    neovim = {
      enable = true;
      vimAlias = true;
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

        nnoremap <C-n> :NERDTree<CR>
        nnoremap <C-t> :NERDTreeToggle<CR>
      '';
      plugins = with pkgs.vimPlugins; [
        ctrlp
        nerdtree
        nerdtree-git-plugin
        vim-devicons

        #keymap
        # {
        #   plugin = keymapConfig;
        #   type = "lua";
        #   config = builtins.readFile ../config/nvim/keymap.lua;
        # }
      ];
    };
    zsh = {
      enable = true;
      history.size = 100000;
      shellAliases = {
        tx = "tmuxinator";
        nix-gc = ''
          nix-collect-garbage --delete-old;
          sudo nix-collect-garbage --delete-old;
          nix-store --optimize -v;
        '';
        myip = "curl ifconfig.co";
        ip6 = "curl -6 ifconfig.co";
        cl = "clear";
        reload = "source ~/.zshrc";
        flush = "sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache";
        delete-gone-branch = ''
          git branch --v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D
        '';
      };
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "kubectl"
          "golang"
          "docker"
          "history"
          "z"
        ];
        theme = "robbyrussell";
      };
      initContent = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        export ZSH_FZF_HISTORY_SEARCH_BIND='^f'
        bindkey '^f' fzf-history-widget
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:nipe:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      '';
    };

  };
}
