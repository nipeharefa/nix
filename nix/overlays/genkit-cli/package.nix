{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook
}:
let
  version = "1.26.0";
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";
  plat =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "darwin-x64";
      x86_64-linux = "linux-x64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-darwin = "sha256-DIeDzD4dZB1Z1a+sYvVwpWDD8h1l2W0CDu28YlP0DIo=";
      aarch64-linux = "sha256-JkaJmEMRzCyhBKnWpNA5tCZ67PRUPcnqC7wJTusMzI0=";
      x86_64-darwin = "sha256-YzfIcYUyHAeSRN+9nCRQKjAGQBvRU50ZzcnfjekQGEM=";
      x86_64-linux = "sha256-h7zmljYZoFfIzPDOQ4PzdUYCc/tqsCzaR4DtGlQKqTk=";
    }
    .${system} or throwSystem;

in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "genkit-cli";

   src = fetchurl {
    url = "https://storage.googleapis.com/genkit-assets-cli/prod/${plat}/v${version}/genkit";
    inherit hash;
  };

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/genkit
  '';

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/genkit";
  versionCheckProgramArg = "--version";
})
