{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = ''
      ${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules
    '';
    fileWidget = {
      command = ''
        ${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules
      '';
      options = [
        "--height=60%"
        "--reverse"
        "--preview" "bat --style=numbers --color=always --paging=never {}"
        "--preview-window=right,60%,border"
      ];
    };
    changeDirWidget = {
      command = ''
        ${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules
      '';
      options = [
        "--height=60%"
        "--reverse"
        "--preview" "eza -a -l --color=always --group-directories-first {}"
        "--preview-window=right,60%,border"
      ];
    };
  };
}
