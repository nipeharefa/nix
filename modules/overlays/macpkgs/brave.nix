{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "144.105";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://updates-cdn.bravesoftware.com/sparkle/Brave-Browser/stable/${version}/Brave-Browser-x64.dmg";
        sha256 = "sha256-kr+Zt+4LZk/drRqAW4u4dM1PQe/1tmhuxEOgyunjGWg=";
    };

    sourceRoot = ".";

    desktopName = "Brave Browser";
    installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r "${desktopName}.app" $out/Applications
    '';
}
