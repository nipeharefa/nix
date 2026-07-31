{ ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      scan_timeout = 500;
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
}
