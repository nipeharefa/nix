{ inputs, config, pkgs, system, lib, ... }:

let

  yubiPkgs = with pkgs; [
    yubikey-manager # yubikey manager cli
    yubioath-desktop # yubikey OTP manager (gui)
  ];

  defaultPackages = with pkgs; [
    fish
    # lcov
    nodejs_20
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

    # awscli2
    fzy
    neofetch
    tmuxinator
    tmux

    envsubst
    hey
    cloudflared

    direnv
    hugo
    # dnsproxy

    # Compilers
    # rustc
    go_1_22
    rustup

    # Golang tools
    golangci-lint
    go-mockery


    nixpkgs-fmt

    terraform


    # krakend

    kubectl
    kubectx
    viddy
    buf

    # mac
    cocoapods

    cargo-tauri
    # pnpm
    # sonar-scanner-cli
    colima
    gnupg
    sops

    nodePackages.pnpm
    # zinit
    git-cliff
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt # git files encryption
    # hub           # github command-line client
    tig # diff and commit view
  ];
in
{

  home.packages = defaultPackages ++ gitPkgs;
}
