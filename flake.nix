{
   description = "my darwin system";
   outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-darwin"
    ];

    flake = {
        description = "A flake using Home Manager and perSystem configuration.";

        darwinConfigurations = {
          m1pro = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              ./configuration.nix
              ./homebrew.nix
              inputs.home-manager.darwinModules.home-manager
              ({ pkgs, config, ... }: {
                nixpkgs = {
                  config = { allowUnfree = true; };
                };
                users.users.nipeharefa = {
                  home = "/Users/nipeharefa";
                  shell = pkgs.oh-my-zsh;
                };
                system.stateVersion = 4;
                home-manager.useGlobalPkgs = true;
                # home-manager.useUserPackages = true;
                home-manager.users.nipeharefa = {
                  imports = [
                    ./home.nix
                    ./zsh.nix
                    ./git.nix
                    ./activation.nix
                    ./tmux.nix
                    # ./devShells.nix
                  ];
                  home.stateVersion = "24.05";
                  home.packages = [
                    pkgs.sops
                  ];
                };
              })
            ];
          };
        };
        
      };

  };
   inputs = {

   ## -- nixpkgs 
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    parts.url = "github:hercules-ci/flake-parts";
   };
}
