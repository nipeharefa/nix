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
      ];

      ezConfigs = {
        root = ./nix;
        globalArgs = {
          inherit inputs;
        };
        darwin.hosts = {
          m1pro = {
            userHomeModules = [ "nipeharefa" ];
          };
        };
      };
    };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    parts.url = "github:hercules-ci/flake-parts";

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "parts";
      };
    };

    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };
}
