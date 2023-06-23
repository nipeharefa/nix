{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # rust-overlay
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources / nix utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # Android Development
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
  let
    system = "x86_64-darwin";
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
    pkgs = nixpkgs.legacyPackages.${system};

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays
          ++ singleton (inputs.android-nixpkgs.overlays.default)
          ++ singleton (inputs.rust-overlay.overlays.default);
    };

    homeManagerStateVersion = "23.05";
    primaryUserInfo = {
      username = "nipeharefa";
      fullName = "Nipe Harefa";
      email = "me@nipeharefa.dev";
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
            };
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs system; };
            # home-manager.useUserPackages = true;
            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          }
        )
    ];
    forAllSystems = nixpkgs.lib.genAttrs 
    [
        "aarch64-darwin"
        "x86_64-darwin"
    ];
  in {
    darwinConfigurations = rec {
      bootstrap-x86 = makeOverridable darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./configuration.nix
          { nixpkgs = nixpkgsConfig; } ];
      };

      bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

      gowi = bootstrap-x86.override {
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
          ./homebrew.nix
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
    };
    # end of darwin config
    overlays = import ./modules/overlays inputs nixpkgsConfig;

    devShells = {
      default = pkgs.mkShell {
        name = "Your Project";
        buildInputs = with pkgs; [
          terragrunt
          buf
          swagger-codegen3
          toxiproxy
        ];
      };
    };

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

      home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.commonModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
    };
  } // flake-utils.lib.eachDefaultSystem (system: rec {
    legacyPackages = import inputs.nixpkgs-unstable (nixpkgsConfig // { inherit system; });
    pkgs = nixpkgs.legacyPackages.${system};

    devShells = let pkgs = self.legacyPackages.${system}; in
      import ./devShells.nix { inherit pkgs; inherit (inputs.nixpkgs-unstable) lib; } // {

      };
  });
}
