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
    fish
    # lcov
    nodejs_22
    yarn

    # container
    qemu
    docker
    docker-compose

    # neovim
    vim

    eza
    air
    
    # python
    python310
    uv

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

    direnv
    hugo
    # dnsproxy

    # Compilers
    # rustc
    go_1_24
    rustup

    # Golang tools
    golangci-lint
    go-mockery

    nixpkgs-fmt

    opentofu

    # krakend
    claude-code

    kubectl
    k9s
    kubectx
    kubelogin-oidc
    
    viddy
    # buf

    # mac
    cocoapods

    cargo-tauri
    # pnpm
    # sonar-scanner-cli
    colima
    gnupg
    sops

    # nodejs and friend
    nodePackages.pnpm
    bun
    
    # zinit
    git-cliff

    zsh-fzf-tab

    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Hack"]; })
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
    
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
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
