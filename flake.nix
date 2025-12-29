{
  description = "my darwin system";
  outputs =
    inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        inputs.ez-configs.flakeModule
        ./devShells.nix
        ./nix/overlays
      ];

      ezConfigs = {
        root = ./nix;
        globalArgs = {
          inherit inputs;
        };
        # home.users.root.importDefault = false;
        darwin.hosts = {
          m1pro = {
            userHomeModules = [ "nipeharefa" ];
          };
        };
      };
    };
  inputs = {

    ## -- nixpkgs 
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    parts.url = "github:hercules-ci/flake-parts";
    mac-app-util.url = "github:hraban/mac-app-util";

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "parts";
      };
    };

    # sops
    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    sops.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    #### ---- nixvim
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "parts";

  };
}
