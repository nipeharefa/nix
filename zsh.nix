{ pkgs, ... }:

{
  programs = {
    fzf = {
        enable = true;
        fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
        changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    };
    vscode = {
        enable = true;
    };
    tmux = {
      enable = true;
    };
    zsh = {
      enable = true;
      shellAliases = {
        ls = "exa";
        ll = "ls -l";
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
        zinit light joshskidmore/zsh-fzf-history-search
        zinit pack"default+keys" for fzf
        export ZSH_FZF_HISTORY_SEARCH_BIND='^f'
        bindkey '^f' fzf-history-widget
        # theme
        zinit ice depth=1; zinit light romkatv/powerlevel10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        zinit load agkozak/zsh-z
        zinit light Aloxaf/fzf-tab
        # preview directory's content with exa when completing cd
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
        zstyle ':completion:*:git-checkout:*' sort false

        eval "$(direnv hook zsh)"
        npm config set prefix '~/.npm-global'
      '';
    };
  };

  # programs.tmux.enable = true;
  # programs.tmux.terminal = "screen-256color";
}
