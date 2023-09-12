{ pkgs, config,lib, ... }:
{
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
    applications="$HOME/Applications"
    nix_apps="$applications/Nix Apps"

    # Delete the directory to remove old links
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"

    echo "nipe $nix_apps" >&2

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read src; do
      # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
      # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
      # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
      /usr/bin/osascript -e "
          set fileToAlias to POSIX file \"$src\" 
          set applicationsFolder to POSIX file \"$nix_apps\"

          tell application \"Finder\"
              make alias file to fileToAlias at applicationsFolder
              # This renames the alias; 'mpv.app alias' -> 'mpv.app'
              set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
          end tell
      " 1>/dev/null
    done
  '';
  environment = with pkgs; {
    shells = [
      fish
      zsh
    ];

    variables = {
      SHELL = "${fish}/bin/fish";
      CC = "${gcc}/bin/gcc";
    };
  };
  
  nix = {
    configureBuildUsers = true;
    useDaemon = true;
    settings = {
      auto-optimise-store = true;
      sandbox = "relaxed";
      cores = 1;
      max-jobs = 8;
      trusted-users = [
        "@admin"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://cache.nixos.org/"
      ];
      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  # font
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
  ];
}
