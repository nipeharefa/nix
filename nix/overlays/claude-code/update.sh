#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#nodejs .#git .#nix-update .#nix .#gnused .#findutils .#bash .#coreutils --command bash
set -euo pipefail

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
LATEST_URL="$BASE_URL/latest"
PACKAGE_FILE="nix/overlays/claude-code/default.nix"

# Fetch versi terbaru
version="$(curl -fsSL "$LATEST_URL" | tr -d '[:space:]')"
echo "Updating claude → $version"


PLAT="darwin-arm64"
SYSTEM="aarch64-darwin"

URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/${PLAT}/claude"

echo "Updating hash for ${SYSTEM}"
echo "Version: ${version}"
echo "URL: ${URL}"

# Compute nix hash (base64, no prefix)
RAW_HASH="$(nix-prefetch-url --type sha256 "$URL")"
HASH="$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 ${RAW_HASH})"

echo "New hash: $HASH"

# BSD sed (macOS) requires -i ''
sed -i '' -E \
  's|(aarch64-darwin[[:space:]]*=[[:space:]]*")sha256-[^"]*(")|\1'"${HASH}"'\2|' \
  "nix/overlays/claude-code/default.nix"

# echo "✔ aarch64-darwin hash updated successfully"