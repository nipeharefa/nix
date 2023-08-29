{ inputs, lib, ... }:

final: prev:
let
  inherit (final)
    buildGoModule
    fetchFromGitHub
    go-task
    gotestsum
    stdenv
    versionCheckHook;
in
{
  go-mockery = buildGoModule (finalAttrs: {
    pname = "go-mockery";
    version = "3.6.0";

    src = fetchFromGitHub {
      owner = "vektra";
      repo = "mockery";
      rev = "v${finalAttrs.version}";
      hash = "sha256-qcK0FXtAL7kJ+dotthmnMcGa9wu97UsDKBoKy5lD2W4=";
    };

    proxyVendor = true;
    vendorHash = "sha256-Xy2w61ATNDOZKtdekeA9NSdyJq2/eiEZ9iJ3PDSUm9Q=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/vektra/mockery/v${lib.versions.major finalAttrs.version}/internal/logging.SemVer=v${finalAttrs.version}"
    ];

    env.CGO_ENABLED = false;

    subPackages = [ "." ];

    nativeCheckInputs = [
      versionCheckHook
      go-task
      gotestsum
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
  });
}
