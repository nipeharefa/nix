{
  inputs,
  config,
  pkgs,
  system,
  lib,
  ...
}:

let

  yubiPkgs = with pkgs; [
    yubikey-manager # yubikey manager cli
    yubioath-desktop # yubikey OTP manager (gui)
  ];

  defaultPackages = with pkgs; [
    # fish
    # lcov
    nodejs_22
    yarn

    # neovim
    vim

    eza
    air
    
    # python
    python310
    uv
    graphviz

    yq-go
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
    age

    direnv devenv
    hugo
    # dnsproxy

    # Compilers
    # rustc
    rustup

    # Golang tools
    go_1_25 gopls gotools wire
    golangci-lint go-mockery cliproxyapi
    genkit-cli

    nixpkgs-fmt
    nixpkgs-review
    cachix

    # provisioning
    opentofu ansible

    # vibe
    claude-code beads

    # kubernetes tools
    kubectl
    kubernetes-helm
    k9s
    kubectx
    
    
    # ffmpeg
    ffmpeg_6-headless
    
    viddy
    # buf

    # mac
    cocoapods

    cargo-tauri
    # pnpm
    # sonar-scanner-cli
    # container
    qemu
    docker
    docker-compose
    colima
    
    sops

    # nodejs and friend
    nodePackages.pnpm
    bun
    
    # zinit
    git-cliff
    gh

    zsh-fzf-tab
    btop

    go-2fa
    ytt

    # gpg
    gnupg
    pinentry_mac

    opentofu

    mkcert

    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Hack"]; })
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code

    redpanda-connect
    
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
  ];

  # gitPkgs = with pkgs.gitAndTools; [
  #   diff-so-fancy # git diff with colors
  #   git-crypt # git files encryption
  #   # hub           # github command-line client
  #   tig # diff and commit view
  #   git-extras
  # ];
in
{

  home.packages = defaultPackages;
}
