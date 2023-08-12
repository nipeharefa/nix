{ inputs, pkgs, system, lib, ... }:

let

  yubiPkgs = with pkgs; [
    yubikey-manager  # yubikey manager cli
    yubioath-desktop # yubikey OTP manager (gui)
  ];

  legacyPackages = pkgs;

  gcloud = with legacyPackages; [
    (legacyPackages.google-cloud-sdk.withExtraComponents ([
      legacyPackages.google-cloud-sdk.components.gke-gcloud-auth-plugin
      ]))
    
    legacyPackages.flyctl
  ];
  
  defaultPackages = with pkgs; [
    # flyctl
    fish
    lcov
    # nodejs-19_x
    yarn


    # container
    podman
    qemu
    docker
    docker-compose

    neovim
    vim

    hasura-cli
    exa
    zsh
    air
    python310
    yq
    jq

    redis

    awscli2
    fzf
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
    go_1_20
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
    cachix
    comma # run without install
    nodePackages.node2nix
    rnix-lsp
    # home-manager
    nix-prefetch-git
    # yarn2nix
    nixpkgs-fmt
    rnix-hashes

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
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    # hub           # github command-line client
    tig           # diff and commit view
  ];
in {

  programs.tmux.enable = true;
  programs.tmux.terminal = "screen-256color";
  home.packages = defaultPackages ++ gitPkgs ++ gcloud;
  
  home.file = {
    "Applications/home-manager".source =
    let apps = pkgs.buildEnv
    {
        name = "home-manager-apps";
        paths = with pkgs; [ alacritty ];
        pathsToLink = "/Applications";
    };
    in
    lib.mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";
  };
}
