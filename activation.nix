{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.activation = {
    copyApplications =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
            (lib.optionalString (pkgs.stdenv.isDarwin)
            (
            let
            apps = pkgs.buildEnv {
                name = "home-manager-applications";
                paths = config.home.packages;
                pathsToLink = "/Applications";
            };
            in
            ''
            echo "setting up ${config.home.homeDirectory}/Applications/Home\ Manager\ Applications...">&2
            if [ ! -e ~/Applications -o -L ~/Applications ]; then
                ln -sfn ${apps}/Applications ~/Applications
            elif [ ! -e ~/Applications/Home\ Manager\ Apps -o -L ~/Applications/Home\ Manager\ Apps ]; then
                ln -sfn ${apps}/Applications ~/Applications/Home\ Manager\ Apps
            else
                echo "warning: ~/Applications and ~/Applications/Home Manager Apps are directories, skipping App linking..." >&2
            fi
            ''
            )
            );
    };
} 