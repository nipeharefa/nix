{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
    pname = "brave";
    version = "145.114";

    nativeBuildInputs = [ undmg ];
    src = fetchurl {
        url = "https://updates-cdn.bravesoftware.com/sparkle/Brave-Browser/stable/${version}/Brave-Browser-x64.dmg";
        sha256 = "sha256-d0hblfU10EV+BYUj4GXHi1tben3b784UDKcyHIO+2Gc=";
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
