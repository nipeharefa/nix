#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#nodejs .#git .#nix-update .#nix .#gnused .#findutils .#bash --command bash
set -euo pipefail

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
LATEST_URL="$BASE_URL/latest"
PACKAGE_FILE="nix/overlays/claude-code/default.nix"

# Fetch versi terbaru
version="$(curl -fsSL "$LATEST_URL" | tr -d '[:space:]')"
echo "Updating claude → $version"

# Platform mapping (diperbaiki syntax)
declare -A PLAT=(
	[aarch64 - darwin]="darwin-arm64"
	[aarch64 - linux]="linux-arm64"
	[x86_64 - darwin]="darwin-x64"
	[x86_64 - linux]="linux-x64"
)

# Buat backup
cp "$PACKAGE_FILE" "$PACKAGE_FILE.bak"

# Update versi (gunakan -i untuk in-place edit, bukan -nE)
sed -i "s/version = \"[^\"]*\"/version = \"$version\"/" "$PACKAGE_FILE"

# Loop setiap platform dan update hash
for system in "${!PLAT[@]}"; do
	plat="${PLAT[$system]}"
	url="$BASE_URL/$version/$plat/claude"

	echo "Prefetching $system..."
	hash="$(nix-prefetch-url --type sha256 "$url")"
	hash="sha256-$hash"

	echo "  $system = $hash"

	# Gunakan -i untuk in-place edit, bukan -nE (yang hanya print)
	sed -i "s|${system} = \"sha256-[^\"]*\"|${system} = \"$hash\"|" "$PACKAGE_FILE"
done

echo "✓ Update selesai!"
echo "Versi baru: $version"
echo "Backup tersimpan di: $PACKAGE_FILE.bak"
