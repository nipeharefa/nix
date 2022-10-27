{ stdenv, fetchgit, cmake, fetchurl, undmg, unzip, cpio, pkg-config, xar }:

stdenv.mkDerivation rec {
    pname = "edge";
    version = "106.0.1370.37";

    src = fetchurl {
        url = "https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/MicrosoftEdge-${version}.pkg";
        sha256 = "sha256-Fh/ZNRCyhyZQDFx+os6SQz2oZGcvCIRdBYqPzsLyAZI=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [ xar cpio ];
    unpackPhase = ''
        xar -xf $src -C .
    '';

    desktopName = "Edge Browser";
    installPhase = ''
        runHook preInstall
        cd MicrosoftEdge-${version}.pkg
        gunzip -dc Payload | cpio -i
        mkdir -p $out/Applications
        cp -r 'Microsoft edge.app' $out/Applications
        runHook postInstall
    '';
}
