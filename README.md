## Rebuild workflow

```
./bin/rebuild             # defaults to darwin host m1pro + home-manager profile
./bin/rebuild other-host  # override host name
```

## DevShells

Enter a toolchain shell with `nix develop .#<name>` or the `dev` fish function:

```
dev rust       # rustc, cargo, rustfmt, clippy, rust-analyzer
dev php        # php 8.3 + composer/phpstan/php-cs-fixer
dev rails      # ruby 3.4 + postgres 17
dev gcloud     # gcloud + gke-gcloud-auth-plugin
dev fe         # node 24 + yarn + pnpm 10
dev bun
dev flyctl
dev swagger
```

Existing shells live under `devShells.nix`; add a new one by adding a block
there and one word to the `dev` completions in `nix/home-modules/fish.nix`.

## Decisions

- Host/user/module terminology — see [CONTEXT.md](CONTEXT.md).
- tmux pinned to 3.6b (opencode TUI lag) — see
  [docs/adr/0001-pin-tmux-3-6b.md](docs/adr/0001-pin-tmux-3-6b.md).
