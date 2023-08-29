{
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGo126Module rec {
  pname = "cliproxyapi";
  version = "6.8.15";

  src = fetchFromGitHub {
    owner = "router-for-me";
    repo = "CLIProxyAPI";
    rev = "v${version}";
    hash = "sha256-nzfz033KqqKg1vSkUAY5JZAUl5FGesN8tqhlajLn92E=";
  };

  proxyVendor = true;
  vendorHash = "sha256-jNcIsMBGFKYn1fwUlLSjfLEHskQnvtBd40e+mD3a10c=";

  postInstall = ''
    mv $out/bin/server $out/bin/cliproxyapi
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  env.CGO_ENABLED = false;
  subPackages = [ "cmd/server" ];
  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    description = "Wrap Gemini CLI, ChatGPT Codex, Claude Code, Qwen Code, iFlow as an OpenAI/Gemini/Claude/Codex compatible API service, allowing you to enjoy the free Gemini 2.5 Pro, GPT 5, Claude, Qwen model through API";
    maintainers = with lib.maintainers; [ ];
    mainProgram = "cliproxyapi";
    license = lib.licenses.bsd3;
  };
}
