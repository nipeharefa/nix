{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.inputs.flake-compat.follows = "flake-compat";
    home-manager.inputs.utils.follows = "flake-utils";

    # Other sources
    flake-utils.url = "github:numtide/flake-utils";

    sops-nix.url = github:Mic92/sops-nix;
  };

  outputs = { self, nixpkgs, darwin, home-manager, sops-nix, flake-utils, ... }@inputs:
  let
    system = "x86_64-darwin";
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
    pkgs = nixpkgs.legacyPackages.${system};

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              yadm
              niv;
          })
        );
    };

    homeManagerStateVersion = "22.11";
    primaryUserInfo = {
      username = "nipeharefa";
      fullName = "Nipe Harefa";
      email = "nipeharefa@gmail.com";
      nixConfigDirectory = "/Users/nipeharefa/.config/nixpkgs";
    };
    ci = {
      username = "ci";
      fullName = "ci";
      email = "ci@nipeharefa.dev";
      nixConfigDirectory = "/Users/ci/.config/nixpkgs";
    };
    nixDarwinCommonModules = attrValues self.commonModules ++ attrValues self.darwinModules ++ [
      ./configuration.nix
      # ./homebrew.nix
      sops-nix.nixosModules.sops
      home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;
            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            nix.nixPath = { nixpkgs = "${primaryUser.nixConfigDirectory}/nixpkgs.nix"; };
            # `home-manager` config
            users.users.nipeharefa = {
              home = "/Users/nipeharefa";
              shell = pkgs.oh-my-zsh;
            };
            home-manager.users.nipeharefa = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              # home.user-info = config.users.primaryUser;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs system; };
            # home-manager.useUserPackages = true;
            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          }
        )
    ];
  in {
    # devShell.x86_64-darwin = {};
    # start darwin
    darwinConfigurations = rec {
      bootstrap-x86 = makeOverridable darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./configuration.nix
          { nixpkgs = nixpkgsConfig; } ];
      };

      bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

      gowi = makeOverridable darwinSystem {
        system = "x86_64-darwin";
        modules = nixDarwinCommonModules ++ [
          ./homebrew.nix
          {
            users.primaryUser = primaryUserInfo;
            networking.computerName = "gowi";
            networking.hostName = "gowi";
          }
        ];
      };

      m1pro = makeOverridable darwinSystem {
        system = "aarch64-darwin";
        modules = nixDarwinCommonModules ++ [
          {
            users.primaryUser = ci;
            networking.computerName = "gowi.m1pro";
            networking.hostName = "gowi-m1pro";
          }
        ];
      };

      cicd = makeOverridable darwinSystem {
        system = "x86_64-darwin";
        modules = nixDarwinCommonModules ++ [
          {
            users.primaryUser = ci;
            networking.computerName = "gowi.flock";
            networking.hostName = "gowi.flock";
          }
        ];
      };
      cicdm1 = makeOverridable darwinSystem {
        system = "aarch64-darwin";
        modules = nixDarwinCommonModules ++ [
          {
            users.primaryUser = ci;
            networking.computerName = "gowi.cicd";
            networking.hostName = "gowi.cicd";
          }
        ];
      };
    };
    # end of darwin config
    overlays = import ./modules/overlays inputs nixpkgsConfig;

    commonModules = {
        users-primaryUser = import ./modules/user.nix;
      };

    darwinModules = {};
    # `home-manager` modules
    homeManagerModules = {
      rumah = import ./home.nix;
      act = import ./activation.nix;
      gowi-tmux = import ./tmux.nix;
      zsh-extra = import ./zsh.nix;
      gowi-git = import ./git.nix;
      gowi-shells = import ./shells.nix;
      ac = import ./application.nix;
      # r17-devshell = import ./devShell.nix;
      # gowi-homebrew = import ./homebrew.nix;

      home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.commonModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
    };
  }  // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          devShells = {
            default = pkgs.mkShellNoCC {
              name = "PHP project";
              buildInputs = [
                pkgs.sops
              ];
            };
          };
        }
    );
}
