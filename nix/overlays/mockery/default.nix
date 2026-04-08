{
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGo126Module rec {
    pname = "go-mockery";
    version = "3.7.0";

    src = fetchFromGitHub {
      owner = "vektra";
      repo = "mockery";
      rev = "v${version}";
      hash = "sha256-h1UQfKOUEoH2LeqKKFOaKftGT+xSorVZByUKVm3xjp8=";
    };

    proxyVendor = true;
    vendorHash = "sha256-cxGH/XOcPrToP5Jg8vyghB8ihUdFoZCPj6fmKpvligs=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/vektra/mockery/v${lib.versions.major version}/internal/logging.SemVer=v${version}"
    ];

    env.CGO_ENABLED = false;

    subPackages = [ "." ];

    nativeCheckInputs = [
      # versionCheckHook
      # go-task
      # gotestsum
    ];

    prePatch = ''
      # remove lint dependency
      substituteInPlace Taskfile.yml \
        --replace-fail "deps: [lint]" "" \
        --replace-fail "go run gotest.tools/gotestsum" "gotestsum"

      # patch e2e scripts
      patchShebangs e2e
    '';

    checkPhase = ''
      runHook preCheck

      ${
        lib.optionalString
          (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86)
          "rm -rf e2e/test_remote_templates/"
      }

      task test.ci

      runHook postCheck
    '';

    doCheck = false;
    doInstallCheck = true;
    versionCheckProgram = "$out/bin/mockery";
    versionCheckProgramArg = "version";

    meta = {
      homepage = "https://github.com/vektra/mockery";
      description = "Mock code autogenerator for Golang";
      maintainers = with lib.maintainers; [
        fbrs
        jk
      ];
      mainProgram = "mockery";
      license = lib.licenses.bsd3;
    };
}
