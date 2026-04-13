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

# --- Skills ---
# Keep wrapper-only skills in codex-workspace and out of synced app repos.
rsync -av --delete \
  --exclude 'workspace-evolution/' \
  "$ROOT/.agents/skills/" "$TARGET_DIR/.agents/skills/"

echo "✅ Sync complete"
