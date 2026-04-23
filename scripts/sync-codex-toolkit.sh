#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLKIT_VERSION_FILE="$ROOT/TOOLKIT_VERSION"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/sync-codex-toolkit.sh [--prefer-workspace] <app-folder>

Behavior:
  --prefer-workspace  Overwrite conflicting synced toolkit files with the workspace copy.
EOF
}

PREFER_WORKSPACE=0
APP_NAME=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefer-workspace)
      PREFER_WORKSPACE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [ -n "$APP_NAME" ]; then
        usage
        exit 1
      fi
      APP_NAME="$1"
      shift
      ;;
  esac
done

if [ -z "$APP_NAME" ]; then
  usage
  exit 1
fi

TARGET_DIR="$ROOT/projects/$APP_NAME"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: $TARGET_DIR does not exist"
  exit 1
fi

if [ ! -f "$TOOLKIT_VERSION_FILE" ]; then
  echo "Error: missing toolkit version file at $TOOLKIT_VERSION_FILE"
  exit 1
fi

TOOLKIT_VERSION="$(tr -d '[:space:]' < "$TOOLKIT_VERSION_FILE")"
if [ -z "$TOOLKIT_VERSION" ]; then
  echo "Error: toolkit version is empty in $TOOLKIT_VERSION_FILE"
  exit 1
fi

HAS_CONFLICT_TTY=0
if [ "$PREFER_WORKSPACE" -eq 0 ]; then
  if { exec 3</dev/tty; } 2>/dev/null; then
    HAS_CONFLICT_TTY=1
  fi
fi

echo "Syncing Codex toolkit $TOOLKIT_VERSION into: $TARGET_DIR"

prompt_conflict_resolution() {
  local source_file="$1"
  local target_file="$2"
  local relative_path="$3"
  local choice

  if [ "$PREFER_WORKSPACE" -eq 1 ]; then
    cp -f "$source_file" "$target_file"
    echo "Kept workspace version for $relative_path"
    return 0
  fi

  if [ "$HAS_CONFLICT_TTY" -ne 1 ]; then
    echo "Conflict detected for $relative_path, but no interactive terminal is available."
    echo "Re-run with --prefer-workspace to overwrite synced toolkit files automatically."
    exit 1
  fi

  while true; do
    printf '\nConflict: %s\n' "$relative_path"
    printf '  workspace: %s\n' "$source_file"
    printf '  project:   %s\n' "$target_file"
    printf 'Choose which file to keep [w=workspace, p=project]: '
    read -r choice <&3

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
IGNORE_AGENTS=".agents"
IGNORE_CODEX=".codex"

if [ -f "$GITIGNORE_FILE" ]; then
  TMP_FILE="$(mktemp)"
  awk -v start="$IGNORE_START" -v end="$IGNORE_END" -v agents="$IGNORE_AGENTS" -v codex="$IGNORE_CODEX" '
    function flush_buffer(    i) {
      for (i = 1; i <= buffer_count; i++) {
        print buffer[i]
      }
      buffer_count = 0
    }

    {
      if ($0 != start) {
        print
        next
      }

      buffer_count = 0
      buffer[++buffer_count] = $0

      if ((getline line1) <= 0) {
        flush_buffer()
        exit
      }

      buffer[++buffer_count] = line1

      if (line1 == agents) {
        if ((getline line2) <= 0) {
          flush_buffer()
          exit
        }

        buffer[++buffer_count] = line2

        if (line2 == codex) {
          buffer_count = 0
          next
        }

        flush_buffer()
        next
      }

      while ((getline line) > 0) {
        if (line == end) {
          buffer_count = 0
          next
        }

        buffer[++buffer_count] = line
      }

      flush_buffer()
      exit
    }
  ' "$GITIGNORE_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$GITIGNORE_FILE"
fi

if [ -f "$GITIGNORE_FILE" ] && [ -s "$GITIGNORE_FILE" ] && [ -n "$(tail -c 1 "$GITIGNORE_FILE")" ]; then
  printf '\n' >> "$GITIGNORE_FILE"
fi

cat >> "$GITIGNORE_FILE" <<EOF
$IGNORE_START
$IGNORE_AGENTS
$IGNORE_CODEX
EOF

printf '%s\n' "$TOOLKIT_VERSION" > "$TARGET_DIR/.codex/toolkit-version"

echo "✅ Sync complete"
