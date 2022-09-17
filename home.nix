{ inputs, pkgs, system, ... }:

let

  yubiPkgs = with pkgs; [
    yubikey-manager  # yubikey manager cli
    yubioath-desktop # yubikey OTP manager (gui)
  ];

  legacyPackages = inputs.nixpkgs-unstable.legacyPackages.${system};

  gcloud = with legacyPackages; [
    (legacyPackages.google-cloud-sdk.withExtraComponents ([legacyPackages.google-cloud-sdk.components.gke-gcloud-auth-plugin]))
  ];

  defaultPackages = with pkgs; [
    flyctl
    fish
    lcov
    nodejs-16_x
    yarn
    du-dust

    sops

    # container
    podman
    qemu

    neovim
    vim

    hasura-cli
    exa
    zsh
    kubectl
    air
    python39Full
    python39Packages.pipx
    yq
    jq

    postman

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
    iterm2

    direnv
    hugo
    dnsproxy

    # Compilers
    # rustc
    go_1_19
    rustup

    # Golang tools
    golangci-lint
    go-mockery
    
    # browser
    edge
    # brave


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
    home-manager
    nix-prefetch-git
    yarn2nix
    nixpkgs-fmt
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];
in {
  # VSCODE
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];
  };

  programs.tmux.enable = true;
  programs.tmux.terminal = "screen-256color";
  home.packages = defaultPackages ++ gitPkgs ++ gcloud;
}
