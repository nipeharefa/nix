{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "connect";
  version = "4.77.0";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "connect";
    rev = "v${version}";
    hash = "sha256-hbX1QCeKw8ebINM1AavGyNuZWt+SpgGJgjSfM2elw5c=";
  };

  proxyVendor = true;
  vendorHash = "sha256-FiW1M2fiRv5A9klReMyBRI1nQ0lQU+zNog4ETxd/yB4=";

  postInstall = ''
    mv $out/bin/redpanda-connect $out/bin/connect
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  env.CGO_ENABLED = false;
  subPackages = [ "cmd/redpanda-connect" ];
  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    description = "Wrap Gemini CLI, ChatGPT Codex, Claude Code, Qwen Code, iFlow as an OpenAI/Gemini/Claude/Codex compatible API service, allowing you to enjoy the free Gemini 2.5 Pro, GPT 5, Claude, Qwen model through API";
    maintainers = with lib.maintainers; [ ];
    mainProgram = "connect";
    license = lib.licenses.bsd3;
  };
}
