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

prompt_conflict_resolution() {
  local source_file="$1"
  local target_file="$2"
  local relative_path="$3"
  local choice

  while true; do
    printf '\nConflict: %s\n' "$relative_path"
    printf '  workspace: %s\n' "$source_file"
    printf '  project:   %s\n' "$target_file"
    printf 'Choose which file to keep [w=workspace, p=project]: '
    read -r choice

    case "$choice" in
      w|W)
        cp -f "$source_file" "$target_file"
        echo "Kept workspace version for $relative_path"
        return 0
        ;;
      p|P)
        echo "Kept project version for $relative_path"
        return 0
        ;;
      *)
        echo "Invalid choice. Enter 'w' or 'p'."
        ;;
    esac
  done
}

sync_tree_preserving_local_files() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"
  local relative_path
  local source_path
  local target_path

  while IFS= read -r relative_path; do
    source_path="$source_dir/$relative_path"
    target_path="$target_dir/$relative_path"

    if [ -d "$source_path" ]; then
      mkdir -p "$target_path"
      continue
    fi

    mkdir -p "$(dirname "$target_path")"

    if [ ! -e "$target_path" ]; then
      cp -p "$source_path" "$target_path"
      echo "Added $label/$relative_path"
      continue
    fi

    if cmp -s "$source_path" "$target_path"; then
      continue
    fi

    prompt_conflict_resolution "$source_path" "$target_path" "$label/$relative_path"
  done < <(cd "$source_dir" && find . -mindepth 1 | LC_ALL=C sort | sed 's|^\./||')
}

# Ensure dirs exist
mkdir -p "$TARGET_DIR/.agents/skills"
mkdir -p "$TARGET_DIR/.agents/shared"
mkdir -p "$TARGET_DIR/.codex/agents"
mkdir -p "$TARGET_DIR/.codex/plans"
mkdir -p "$TARGET_DIR/.codex/context"
mkdir -p "$TARGET_DIR/.codex/notes"

# --- Skills ---
# Keep wrapper-only skills in codex-workspace and out of synced app repos.
TMP_SKILLS_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_SKILLS_DIR"
}
trap cleanup EXIT

rsync -a \
  --exclude 'workspace-evolution/' \
  --exclude 'project-onboarding/' \
  "$ROOT/.agents/skills/" "$TMP_SKILLS_DIR/"

sync_tree_preserving_local_files "$TMP_SKILLS_DIR" "$TARGET_DIR/.agents/skills" ".agents/skills"

# --- Shared workflow assets ---
sync_tree_preserving_local_files "$ROOT/.agents/shared" "$TARGET_DIR/.agents/shared" ".agents/shared"

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
