{ inputs, config, pkgs, system, lib, ... }:

let

  yubiPkgs = with pkgs; [
    yubikey-manager # yubikey manager cli
    yubioath-desktop # yubikey OTP manager (gui)
  ];

  legacyPackages = pkgs;

  gcloud = with pkgs; [
    (google-cloud-sdk.withExtraComponents ([
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
  ];

  defaultPackages = with pkgs; [
    flyctl
    fish
    # lcov
    nodejs-18_x
    yarn


    # container
    podman
    qemu
    docker
    docker-compose

    # neovim
    vim

    eza
    zsh
    air
    python310
    yq
    jq

    redis

    awscli2
    fzy
    neofetch
    tmuxinator
    tmux

    envsubst
    hey
    cloudflared

    direnv
    hugo
    dnsproxy

    # Compilers
    # rustc
    go_1_21
    rustup

    # Golang tools
    golangci-lint
    go-mockery

    ################################## 
    # Communication
    ################################## 
    # discord-ptb
    # slack

    ################################## 
    # Useful Nix related tools
    ################################## 
    # cachix
    comma # run without install
    # nodePackages.node2nix
    rnix-lsp
    # home-manager
    nix-prefetch-git
    # yarn2nix
    nixpkgs-fmt

    terraform

    # krakend

    kubectl
    kubectx
    viddy
    buf

    # mac
    cocoapods

    # Swagger
    swagger-codegen3
    graphviz
    openapi-generator-cli

    cargo-tauri
    # pnpm
    # sonar-scanner-cli
    colima
    gnupg
    # zinit
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt # git files encryption
    # hub           # github command-line client
    tig # diff and commit view
  ];
in
{

  programs.tmux.enable = true;
  programs.tmux.terminal = "screen-256color";
  home.packages = defaultPackages ++ gitPkgs ++ gcloud;
}
