{ lib, go, glibc, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krakend-ce";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "krakendio";
    repo = "krakend-ce";
    rev = "v${version}";
    hash = "sha256-b5ScbqJkWJaJYa9xYdpyh3PGwkhMxQ5R1ItNkh3EKYM=";
  };

  vendorSha256 = "sha256-j4UMN8ko45BCc5tjZjCpvoX0I05xKnx1Ap10zPV0EtU=";

  subPackages = [ "cmd/krakend-ce" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/luraproject/lura/v2/core.KrakendVersion=${version}"
    "-X github.com/luraproject/lura/v2/core.GoVersion=${lib.getVersion go}"
    "-X github.com/luraproject/lura/v2/core.GlibcVersion=${lib.getVersion glibc}"
  ];

  meta = with lib; {
    description = "KrakenD Community Edition";
    homepage = "https://github.com/krakendio/krakend-ce";
    license = licenses.gpl3Only;
  };
}
