{ pkgs, ... }:

let
  inherit (pkgs) stdenv;
  inherit (pkgs.lib) singleton;

  # a high-order-function for make android sdk with specific versions tools
  # such a plaftorm-andrid-X, build-tools-X, or system-images-android-X.
  #
  # mkAndroidSdk -------------------------------------------------------{{{
  cpuArchForAndroid = if stdenv.isAarch64 then "arm64-v8a" else "x86-64";
  commonSdkInputs = s: [
    s.platform-tools
    s.cmdline-tools-latest
    s.tools
    s.patcher-v4
    s.extras-google-google-play-services
    s.emulator
  ];

  mkShellAndroid = { buildInputs ? [ ], sdkInputs ? _: [ ] }:
    pkgs.mkShell {
      buildInputs = buildInputs
        ++ singleton (pkgs.androidSdk sdkInputs);
    };

  # }}}

  # this function for make nodejs development environments with includes
  # pnpm, yarn, and node.
  mkNodejs = { nodejs, withNodePackages ? _: [ ], buildInputs ? [ ] }:
    let
      nodePackages = pkgs.nodePackages.override {
        inherit nodejs;
      };
      packages = [ nodejs ]
        ++ (withNodePackages nodePackages);
    in
    pkgs.mkShell {
      inherit packages;
      inherit buildInputs;
    };
in

with pkgs;

rec {

  # Rust 🦀 development environments ------------------- {{{
  # `nix develop my#rust`
  rust = mkShell {
    buildInputs = [
      libiconv
      (rust-bin.stable.latest.minimal.override {
        extensions = [ "rustc" ];
      })
    ];
    packages = [
      ffmpeg
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.WebKit
    ];
  };

  # Android development environments ------------------- {{{
  #
  # `nix develop my#android29` 
  android29 = mkShellAndroid {
    buildInputs = [
      gradle
      jdk11
    ];
    sdkInputs = s: [
      s.build-tools-29-0-2
      s.platforms-android-29
      s.platforms-android-31
      s."system-images-android-31-google-apis-playstore-${cpuArchForAndroid}"
    ] ++ commonSdkInputs s;
  };

  # `nix develop my#android30` 
  android30 = mkShellAndroid {
    buildInputs = [
      gradle
      jdk11
    ];
    sdkInputs = s: [
      s.build-tools-30-0-2
      s.platforms-android-31
      s."system-images-android-31-google-apis-playstore-${cpuArchForAndroid}"
    ] ++ commonSdkInputs s;
  };

  # `nix develop my#android31` 
  android31 = mkShellAndroid {
    buildInputs = [
      gradle
      jdk11
    ];
    sdkInputs = s: [
      s.build-tools-31-0-0
      s.platforms-android-31
      s."system-images-android-31-google-apis-playstore-${cpuArchForAndroid}"
    ] ++ commonSdkInputs s;
  };

  # }}}

  # Nodejs development environments ------------------- {{{
  # this node version based on nixpkgs
  # version, shown in search.nixos.org
  # `nix develop my#node` 
  node = mkNodejs {
    inherit nodejs;
    withNodePackages = p: [ p.yarn p.pnpm ];
  };

  # `nix develop my#node14` 
  node14 = mkNodejs {
    nodejs = nodejs-14_x;
    withNodePackages = p: [
      p.yarn
    ];
    buildInputs = [ python3 ];
  };

  # `nix develop my#node16` 
  node16 = mkNodejs {
    nodejs = nodejs-16_x;
    withNodePackages = p: [ p.yarn ];
  };

  # `nix develop my#node18` 
  node18 = mkNodejs {
    nodejs = nodejs-18_x;
    withNodePackages = p: [ p.yarn ];
  };
}

# vim: foldmethod=marker
