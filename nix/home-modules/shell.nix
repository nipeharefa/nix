{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
}
