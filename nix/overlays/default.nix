{ inputs, ... }:

let
  goMockeryOverlay = import ./mockery/default.nix {
    inherit inputs;
    lib = inputs.nixpkgs.lib;
  };
in
{
  # flake.overlays.go-mockery = goMockeryOverlay;

  flake.overlays.cliproxyapi = final: prev: {
    cliproxyapi = final.callPackage ./cliproxyapi/default.nix { };
  };

  flake.overlays.genkit-cli = final: prev: {
    genkit-cli = final.callPackage ./genkit-cli/package.nix { };
  };
  flake.overlays.beads = final: prev: {
    beads = final.callPackage ./beads/package.nix { };
  };
  flake.overlays.redpanda-connect = final: prev: {
    redpanda-connect = final.callPackage ./redpanda-connect/package.nix { };
  };

  flake.overlays.claude-code = final: prev: {
    claude-code = prev.callPackage ./claude-code/default.nix { };
  };
}
