{ lib, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    
    extraConfig = ''
      # ===== GENERAL SETTINGS =====
      set -gu default-command
      set -g default-shell "$SHELL"
      set -g bell-action any
      set -g mouse on
      set -g focus-events on
      set -g status-keys vi
      set -g mode-keys vi
      
      # Enable RGB colour if running in xterm(1)
      set-option -sa terminal-overrides ",xterm*:Tc"
      
      # ===== KEY BINDINGS =====
      # Prefix key
      set -g prefix C-b
      bind C-b send-prefix
      
      # Keep your finger on ctrl, or don't
      bind-key ^D detach-client
      
      # Better pane splitting (maintain current path)
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key ^V split-window -h -p 50 -c "#{pane_current_path}"
      bind-key s split-window -c "#{pane_current_path}"
      bind-key ^S split-window -p 50 -c "#{pane_current_path}"
      bind-key c new-window -c "#{pane_current_path}"
      
      # Smart pane switching with awareness of Vim splits
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      
      # Window navigation
      bind-key -r C-h select-window -t :-
      bind-key -r C-l select-window -t :+
      
      # Pane resizing
      bind-key -r H resize-pane -L 5
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5
      
      # Quick reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded!"
      
      # Session management
      bind S choose-tree -s
      bind W choose-tree -w
      
      # ===== COPY MODE =====
      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line
      
      # ===== CATPPUCCIN THEME =====
      # Status bar
      set -g status-position top
      set -g status-justify left
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      set -g status-left-length 100
      set -g status-right-length 100
      
      # Left side: session name and window info
      set -g status-left "#[bg=#89b4fa,fg=#1e1e2e,bold] #S #[bg=#313244,fg=#89b4fa]#[bg=#313244,fg=#cdd6f4] #(whoami) #[bg=#1e1e2e,fg=#313244]"
      
      # Right side: time and system info
      set -g status-right "#[bg=#1e1e2e,fg=#313244]#[bg=#313244,fg=#cdd6f4] %Y-%m-%d #[bg=#313244,fg=#89b4fa]#[bg=#89b4fa,fg=#1e1e2e,bold] %H:%M "
      
      # Window status
      set -g window-status-format "#[bg=#1e1e2e,fg=#6c7086] #I:#W "
      set -g window-status-current-format "#[bg=#f38ba8,fg=#1e1e2e,bold] #I:#W #{?window_zoomed_flag,🔍,}"
      
      # Pane borders
      set -g pane-border-style "fg=#6c7086"
      set -g pane-active-border-style "fg=#89b4fa"
      
      # Message styling
      set -g message-style "bg=#f9e2af,fg=#1e1e2e"
      set -g message-command-style "bg=#f9e2af,fg=#1e1e2e"
      
      # Mode styling
      set -g mode-style "bg=#f38ba8,fg=#1e1e2e"
      
      # ===== SMART FEATURES =====
      # Auto rename windows based on current program
      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'
      
      # Activity monitoring
      set -g monitor-activity on
      set -g visual-activity off
      
      # Aggressive resize
      set -g aggressive-resize on
      
      # Don't exit from tmux when closing a session
      set -g detach-on-destroy off
      
      # ===== FZF INTEGRATION =====
      # Session switcher with fzf
      bind-key "f" run-shell "tmux neww 'fish -c \"tmux list-sessions -F \\\"#{session_name}\\\" | fzf --reverse --preview \\\"tmux list-windows -t {}\\\" | read session; and tmux switch-client -t \\$session\"'"
    '' + lib.optionalString pkgs.stdenv.isLinux ''
      # Linux clipboard integration
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xsel -i -b"'
      if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
    '' + lib.optionalString pkgs.stdenv.isDarwin ''
      # macOS clipboard integration
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'pbcopy'
      if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | pbcopy"'
      if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"'
    '';
    
    plugins = with pkgs.tmuxPlugins; [
      # Essential plugins
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-save-shell-history 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
          set -g @continuum-boot 'on'
        '';
      }
      yank
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-bind 'u'
        '';
      }
      tmux-thumbs
      sidebar
    ];
  };
}
