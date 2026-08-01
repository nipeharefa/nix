## Rebuild workflow

```
./bin/rebuild             # defaults to darwin host m1pro + home-manager profile
./bin/rebuild other-host  # override host name
```

## Known workarounds

### tmux pinned to 3.6b (opencode TUI streaming lag)

tmux >= 3.7 introduced a synchronized-output (DECSET 2026) engine. When
opencode's full TUI streams a response inside tmux on macOS arm64, that engine
introduces heavy lag (screen freezes until the response finishes). Outside
tmux (direct iTerm2) it is smooth.

- Upstream bug: https://github.com/anomalyco/opencode/issues/34782
  (tmux 3.7 + macOS arm64 → opencode TUI broken; fix = downgrade to 3.6b)
- Related: tmux 3.7b CHANGES — "Fix so that the end of a synchronized update
  again triggers a redraw" (3.7a→3.7b), showing the sync redraw path was flaky
  across the whole 3.7 line.

`programs.tmux.package` in `nix/home-modules/tmux/default.nix` pins tmux to
3.6b. Remove the override once tmux/opencode ships a fix.

## Optional development shells

- PHP toolchain (install on-demand):

  ```
  nix develop .#php
  ```

- Existing shells live under `devShells.nix` (e.g. `.#rails`, `.#gcloud`).
