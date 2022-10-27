{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "v1.45.113";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/${version}/Brave-Browser-universal.dmg";
        sha256 = "sha256-Df/TgfwWPS+eLWRQzRT74tJSY9V5FYiQe2cvK5UZhXw=";
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
