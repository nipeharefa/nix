{
  inputs,
  pkgs,
  ...
}:

let
  mkSopsCmd = name: secretPath:
    pkgs.writeShellScriptBin name ''
      exec ${pkgs.sops}/bin/sops -d "$HOME/secrets/${secretPath}"
    '';

  ai = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    claude-code
    opencode
    rtk
  ];

  defaultPackages = with pkgs; [
    (mkSopsCmd "get_home_password" "home-password.yaml")

    nodejs_24
    yarn

    eza
    air

    python315
    uv
    graphviz

    yq-go
    jq

    redis

    fzy
    fastfetch
    tmuxinator

    envsubst
    hey
    cloudflared
    age

    direnv devenv

    hugo

    go_1_26 gopls
    golangci-lint go-mockery

    nixpkgs-fmt
    nixpkgs-review
    cachix

    opentofu ansible

    kubectl
    kubernetes-helm
    k9s
    kubectx
    kubelogin-oidc

    viddy

    cocoapods

    docker
    docker-compose
    colima

    sops

    pnpm_10
    bun

    git-cliff
    gh

    btop

    go-2fa
    ytt

    gnupg
    pinentry_mac

    mkcert

    bitwarden-cli

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code

    multica-cli

    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
  ];
in
{
  home.packages = defaultPackages ++ ai;
}
