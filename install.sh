#!/usr/bin/env bash
# Nova installer. Downloads the latest Nova release, checks it, unpacks it into
# ~/Projects/nova, and starts Claude Code to set Nova up with you.
# Usage: curl -fsSL https://nicoaccela.github.io/nova-downloads/install.sh | bash
set -euo pipefail

REPO="nicoaccela/nova-downloads"
BASE="https://github.com/$REPO/releases/latest/download"
DEST="${NOVA_DIR:-$HOME/Projects/nova}"

say() { printf '\033[1;35mNova\033[0m  %s\n' "$*"; }
die() { printf '\033[1;31mNova\033[0m  %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "Nova runs on macOS. This looks like $(uname -s)."
[ "$(uname -m)" = "arm64" ] || say "Heads up: Nova is tested on Apple Silicon Macs. Continuing anyway."
command -v curl >/dev/null || die "curl is missing."
command -v shasum >/dev/null || die "shasum is missing."
if ! command -v claude >/dev/null; then
  die "Claude Code isn't installed yet. Install it first (https://claude.com/claude-code), sign in, then run this again."
fi

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
say "Downloading the latest Nova release..."
curl -fsSL "$BASE/nova.tar.gz" -o "$TMP/nova.tar.gz" || die "Download failed. Check your connection and try again."
curl -fsSL "$BASE/nova.tar.gz.sha256" -o "$TMP/nova.tar.gz.sha256" || die "Couldn't fetch the checksum."
want="$(awk '{print $1}' "$TMP/nova.tar.gz.sha256")"
got="$(shasum -a 256 "$TMP/nova.tar.gz" | awk '{print $1}')"
[ -n "$want" ] && [ "$want" = "$got" ] || die "The download didn't match its checksum, so nothing was installed."
say "Checksum OK."

mkdir -p "$(dirname "$DEST")"
if [ -e "$DEST" ]; then
  BAK="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
  mv "$DEST" "$BAK"
  say "Moved your existing $DEST to $BAK"
fi
mkdir -p "$TMP/x"
tar -xzf "$TMP/nova.tar.gz" -C "$TMP/x"
[ -d "$TMP/x/nova" ] || die "The release looks incomplete."
mv "$TMP/x/nova" "$DEST"
say "Nova is unpacked in $DEST"

say "Starting Claude Code. It will find your notes, build your Nova, and walk you through the rest."
cd "$DEST"
if [ -r /dev/tty ]; then
  exec claude "set up Nova" < /dev/tty
else
  say "Open Terminal, then run:  cd \"$DEST\" && claude \"set up Nova\""
fi
