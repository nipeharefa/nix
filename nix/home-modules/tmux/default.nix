{ lib, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    extraConfig = ''
      set -gu default-command
      set -g default-shell "$SHELL"
      set -g bell-action any
      set -g mouse on
      # Keep your finger on ctrl, or don't
      bind-key ^D detach-client
      
      bind-key v split-window -h  -c "#{pane_current_path}"
      bind-key ^V split-window -h -p 50 -c "#{pane_current_path}"
      bind-key s split-window -c "#{pane_current_path}"
      bind-key ^S split-window -p 50 -c "#{pane_current_path}"
      # act like vim
      setw -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind-key -r C-h select-window -t :-
      bind-key -r C-l select-window -t :+

      # color scheme (styled as vim-powerline)
      set -g status-left-length 52
      set -g status-right-length 451
      set -g status-fg white
      set -g status-bg colour234
      #set -g pane-border-style colour245
      #set -g pane-active-border-fg colour39
      #set -g message-fg colour16
      #set -g message-bg colour221
      #set -g message-attr bold
      
      # set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} #{cpu_temp}'
      # status bar
      set -g status-justify centre
      set -g status-left " #(echo $USER)@#T"
      set -g status-left-length 150
      set -g status-right "#[fg=black]%h %d %Y #[fg=white]%l:%M %p "

    '' + lib.optionalString pkgs.stdenv.isLinux ''
      if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xsel -i -b"'
      if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
    '' + lib.optionalString pkgs.stdenv.isDarwin ''
      if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | pbcopy"'
      if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"'
    '';
    plugins = with pkgs; [
      tmuxPlugins.yank
    ];
  };
}
