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

   mkSopsCmd = name: secretPath:
    pkgs.writeShellScriptBin name ''
      # export SOPS_CONFIG="$HOME/dotfiles/.sops.yaml"

      exec ${pkgs.sops}/bin/sops -d "$HOME/secrets/${secretPath}"
    '';


  ai = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    claude-code
    opencode
    rtk
  ];
  
  defaultPackages = with pkgs; [
    (mkSopsCmd "get_home_password" "home-password.yaml")
    # fish
    # lcov
    nodejs_24
    yarn

    # neovim
    # vim

    eza
    air
    
    # python
    python315
    uv
    graphviz

    yq-go
    jq

    redis

    # awscli2
    fzy
    fastfetch
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
    # rustup

    # Golang tools
    go_1_26 gopls
    golangci-lint go-mockery
    # genkit-cli

    nixpkgs-fmt
    nixpkgs-review
    cachix

    # provisioning
    opentofu ansible

    # vibe
    # claude-code beads rtk opencode

    # kubernetes tools
    kubectl
    kubernetes-helm
    k9s
    kubectx
    kubelogin-oidc
    
    viddy
    # buf

    # mac
    cocoapods

    # cargo-tauri
    # pnpm
    # sonar-scanner-cli
    # container
    # qemu
    docker
    docker-compose
    colima
    
    sops

    # nodejs and friend
    # nodePackages.pnpm
    pnpm_10
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

    mkcert
    
    bitwarden-cli

    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Hack"]; })
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.fira-code

    multica-cli

    # redpanda-connect
    
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
