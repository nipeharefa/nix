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

## Troubleshooting

### Random hex text typed into panes when clicking (iTerm2)

After sleep or long use, iTerm2's mouse reporting can corrupt: clicking a tmux
pane types random hex-ish text (e.g. `6e/831c/dc81b:2de8/4309/c0c1`) into it,
sometimes with a bell. tmux merely forwards the mangled mouse event
(`send-keys -M`); the shell echoes it. A fresh session is fine; the state
accumulates and macOS sleep triggers it.

Fix options:

- **Reset without rebooting:** press `C-b C-d` to detach, then run `treset`
  (attaches to the `gowi` session). A fresh attach clears iTerm2's mouse state.
- **One-key reset:** `C-b C-r` toggles tmux mouse off/on to renegotiate with
  the terminal. If it doesn't clear the garbage, remove the binding.
- **Permanent mitigation:** disable the GPU/Metal renderer in iTerm2
  (Settings → Advanced → renderer). Running fewer concurrent TUIs
  (opencode/nvim) inside tmux reduces how often it happens.

## Decisions

- Host/user/module terminology — see [CONTEXT.md](CONTEXT.md).
- tmux pinned to 3.6b (opencode TUI lag) — see
  [docs/adr/0001-pin-tmux-3-6b.md](docs/adr/0001-pin-tmux-3-6b.md).
