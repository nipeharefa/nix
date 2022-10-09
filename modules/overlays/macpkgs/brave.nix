{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "143.93";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://updates-cdn.bravesoftware.com/sparkle/Brave-Browser/stable/${version}/Brave-Browser-x64.dmg";
        sha256 = "sha256-c+fGlBpyhKlo2EoiIda9u1zWjm1BzD90kP39Mc8B2A8=";
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
