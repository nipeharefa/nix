{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook
}:
let
  version = "2.1.19";
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
      aarch64-darwin = "sha256-04asj20UefhdMfNpQhyCQTXBAknDIIcBfQWl9CiFLEE=";
      aarch64-linux = "sha256-JkaJmEMRzCyhBKnWpNA5tCZ67PRUPcnqC7wJTusMzI0=";
      x86_64-darwin = "sha256-YzfIcYUyHAeSRN+9nCRQKjAGQBvRU50ZzcnfjekQGEM=";
      x86_64-linux = "sha256-h7zmljYZoFfIzPDOQ4PzdUYCc/tqsCzaR4DtGlQKqTk=";
    }
    .${system} or throwSystem;

in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "claude";

   src = fetchurl {
    url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${plat}/claude";
    inherit hash;
  };

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/claude
  '';

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/claude";
  versionCheckProgramArg = "--version";
})
