{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip, cpio, pkg-config, xar }:

stdenv.mkDerivation rec {
    pname = "edge";
    version = "1.38.115";

#     nativeBuildInputs = [ pkg-config ];
    src = fetchurl {
        url = "https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/MicrosoftEdge-104.0.1293.70.pkg";
        sha256 = "sha256-GOGGHNTFHXtod/XZ9JL+tcNPz60fUWV3MCQQnPSD4WY=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ xar cpio ];

    unpackPhase = ''
        xar -xf $src -C .
    '';

    desktopName = "Edge Browser";
    installPhase = ''
        runHook preInstall
        cd MicrosoftEdge-104.0.1293.70.pkg
        gunzip -dc Payload | cpio -i
        mkdir -p $out/Applications
        cp -r 'Microsoft Edge.app' $out/Applications
    '';
}