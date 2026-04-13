#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

APP_NAME="${1:-}"
if [ -z "$APP_NAME" ]; then
  echo "Usage: ./scripts/sync-codex-toolkit.sh <app-folder>"
  exit 1
fi

TARGET_DIR="$ROOT/projects/$APP_NAME"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: $TARGET_DIR does not exist"
  exit 1
fi

echo "Syncing Codex toolkit into: $TARGET_DIR"

# Ensure dirs exist
mkdir -p "$TARGET_DIR/.agents/skills"
mkdir -p "$TARGET_DIR/.codex/agents"
mkdir -p "$TARGET_DIR/.codex/plans"
mkdir -p "$TARGET_DIR/.codex/context"
mkdir -p "$TARGET_DIR/.codex/notes"

# --- Skills ---
# Keep wrapper-only skills in codex-workspace and out of synced app repos.
rsync -av --delete \
  --exclude 'workspace-evolution/' \
  "$ROOT/.agents/skills/" "$TARGET_DIR/.agents/skills/"

# --- Project-local Codex artifacts ---
# Keep working artifacts local to each synced app by default.
GITIGNORE_FILE="$TARGET_DIR/.gitignore"
IGNORE_START="# codex-workspace local artifacts"
IGNORE_END="# /codex-workspace local artifacts"

if [ -f "$GITIGNORE_FILE" ]; then
  TMP_FILE="$(mktemp)"
  awk -v start="$IGNORE_START" -v end="$IGNORE_END" '
    $0 == start { in_block = 1; next }
    $0 == end { in_block = 0; next }
    !in_block { print }
  ' "$GITIGNORE_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$GITIGNORE_FILE"
fi

cat >> "$GITIGNORE_FILE" <<EOF
$IGNORE_START
.codex/plans/
.codex/context/
.codex/notes/
$IGNORE_END
EOF

echo "✅ Sync complete"
