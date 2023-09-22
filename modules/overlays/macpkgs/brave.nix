{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip }:

stdenv.mkDerivation rec {
  pname = "brave";
  version = "v1.45.123";

  nativeBuildInputs = [ undmg ];
  src = fetchurl {
    url = "https://github.com/brave/brave-browser/releases/download/${version}/Brave-Browser-universal.dmg";
    sha256 = "sha256-Mu/woyHILJ9Jp6M7FUtaS/tPbsm2TCtYdEqHNcA+zFo=";
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
