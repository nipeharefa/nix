{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "v1.45.118";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/${version}/Brave-Browser-universal.dmg";
        sha256 = "sha256-Q5Bl0925h/mi/K6Il0zhRQ475IG+g1VdY0D41SMN+1w=";
    };

    sourceRoot = ".";

    desktopName = "Brave Browser";
    installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r "${desktopName}.app" $out/Applications
        runHook postInstall
    '';
}
