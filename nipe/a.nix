{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "1.38.115";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://updates-cdn.bravesoftware.com/sparkle/Brave-Browser/stable/142.97/Brave-Browser-x64.dmg";
        sha256 = "sha256-/H6ECfJLW+xM6/j9Ybv1cGm1rPXqppwNsxALgLJqGPw=";
    };

    sourceRoot = ".";

    desktopName = "Brave Browser";
    installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        ls -lah
        cp -r "${desktopName}.app" $out/Applications
    '';
}