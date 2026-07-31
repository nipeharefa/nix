{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = ''
      ${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules
    '';
    fileWidget.command = ''
      ${pkgs.fd}/bin/fd --type f --hidden --exclude .git --exclude node_modules
    '';
    changeDirWidget.command = ''
      ${pkgs.fd}/bin/fd --type d --hidden --exclude .git --exclude node_modules
    '';
  };
}
