{
  description = "my darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { nixpkgs, darwin, home-manager, sops, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowBroken = true;
          allowUnfree = true;
          tarball-ttl = 0;
          contentAddressedByDefault = false;
        };
      };
    in
    {
      darwinConfigurations.m1pro = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./nix/darwin-configurations/m1pro.nix
          ./nix/darwin-modules/default.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      homeConfigurations.nipeharefa = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home-configurations/nipeharefa.nix
          ./nix/home-modules/default.nix
          sops.homeManagerModules.sops
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };

      devShells.${system} = import ./devShells.nix { inherit pkgs; };
    };
}
