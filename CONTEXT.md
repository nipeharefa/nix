# Nix System Config (m1pro / nipeharefa)

Single-machine, single-user Nix configuration for the Mac `flock-mbp1-pro`
(nix-darwin + home-manager). One flake with two layers: the darwin host and
the home-manager user profile.

## Language

**host**: The nix-darwin machine definition, id `m1pro`. This is the flake
build/CI key and the argument to `darwin-rebuild switch --flake .#m1pro`.
The machine's macOS hostName is `flock-mbp1-pro` — different by design.
_Avoid_: machine, computer

**user**: The single macOS user `nipeharefa`; doubles as the home-manager
profile name (`homeConfigurations.nipeharefa`).
_Avoid_: account, profile

**home module**: A Nix module under `nix/home-modules/` configuring the
home-manager layer (shell, editor, tmux, git, secrets).
_Avoid_: config, package

**darwin module**: A Nix module under `nix/darwin-modules/` configuring the
system layer (homebrew, nix settings, registered shells).

**secrets**: The encrypted file `nix/secrets/secret.enc.yaml`, decrypted by
sops to its runtime paths at activation. `nix/secrets/secrets.yaml` is the
plaintext working copy — it must stay gitignored.
_Avoid_: credentials

**devShell**: A one-shot toolchain shell under `devShells.aarch64-darwin.*`,
entered via `nix develop .#<name>` or the `dev <name>` fish function.
_Avoid_: nix-shell

## Relationships

- A **host** (`m1pro`) is built from **darwin modules**; the **user**
  (`nipeharefa`) is built from **home modules**.
- A **user** config depends on **secrets** decrypted by sops at activation.
- **devShells** are standalone — neither layer depends on them.

## Flagged ambiguities

- "m1pro" (host id) vs "flock-mbp1-pro" (hostName) — distinct on purpose.
- "awscli" is a **home module** even though it only sets
  `programs.awscli.enable` — that option installs the aws CLI.
