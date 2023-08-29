## Rebuild workflow

```
./bin/rebuild             # defaults to darwin host m1pro + home-manager profile
./bin/rebuild other-host  # override host name
```

## Optional development shells

- PHP toolchain (install on-demand):

  ```
  nix develop .#php
  ```

- Existing shells live under `devShells.nix` (e.g. `.#rails`, `.#gcloud`).
