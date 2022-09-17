{ pkgs ? import <nixpkgs> { }
, system ? pkgs.stdenv.system
, channel ? "stable",
lib,config, ...
}:

with pkgs;
let
  androidSdk = callPackage ./pkgs/android { };

#   isSupported = _: pkg:
#     if (!lib.isDerivation pkg) then true
#     else builtins.elem system pkg.meta.platforms;

#   filterIsSupported = lib.filterAttrs isSupported;

#   channelPkgs = rec {
#     stable = filterIsSupported (androidSdk.callPackage ./channels/stable { });
#     beta = filterIsSupported (androidSdk.callPackage ./channels/beta { });
#     preview = filterIsSupported (androidSdk.callPackage ./channels/preview { });
#     canary = filterIsSupported (androidSdk.callPackage ./channels/canary { });
#   };

in
rec {
#   packages = androidSdk;
  sdk = callPackage ./a.nix { };
}