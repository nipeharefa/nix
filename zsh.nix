{ pkgs, lib, ... }:
 
{
  programs = {
    fzf = {
      enable = true;
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    };
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-marketplace; [
        bbenoist.nix
        bierner.markdown-mermaid
        dbaeumer.vscode-eslint
        eamodio.gitlens
        esbenp.prettier-vscode
        golang.go
        redhat.vscode-yaml
        vscodevim.vim
        bmewburn.vscode-intelephense-client
      ];
      userSettings = {
        # Vim
        "vim.enableNeovim" = true;
        "vim.highlightedyank.enable" = true;

        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
      };
    };
    eza = {
      enable = true;
      enableAliases = true;
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


        set wildmenu
        set wildmode=longest:full,full
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
      shellAliases = {
        tx = "tmuxinator";
        nixgc = "nix-collect-garbage -d";
        myip = "curl ifconfig.co";
        ip6 = "curl -6 ifconfig.co";
        cl = "clear";
        reload = "source ~/.zshrc";
        flush = "sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache";
        delete-gone-branch = ''
          git branch --v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -D
        '';
      };
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "kubectl" "golang" ];
        theme = "robbyrussell";
      };
      initExtraBeforeCompInit = ''
        if [[ ! -f "$HOME/.zinit/bin/zi.zsh" ]]; then
            print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
            command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
            command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
                print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
                print -P "%F{160}▓▒░ The clone has failed.%f%b"
        fi
        source "$HOME/.zinit/bin/zi.zsh"
      '';

      initExtra = ''
        setopt NO_BANG_HIST
        zinit light joshskidmore/zsh-fzf-history-search
        zinit pack"default+keys" for fzf
        export ZSH_FZF_HISTORY_SEARCH_BIND='^f'
        bindkey '^f' fzf-history-widget
        # theme
        zinit ice depth=1; zinit light romkatv/powerlevel10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        zinit load agkozak/zsh-z
        zinit light Aloxaf/fzf-tab
        # preview directory's content with eza when completing cd
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

        # eval "$(direnv hook zsh)"
      '';
    };
    
  };
}