#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_DIR="$ROOT/projects"
SYNC_SCRIPT="$ROOT/scripts/sync-codex-toolkit.sh"
TOOLKIT_VERSION_FILE="$ROOT/TOOLKIT_VERSION"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/update-codex-toolkit.sh [--prefer-workspace] --check
  ./scripts/update-codex-toolkit.sh [--prefer-workspace] --all
  ./scripts/update-codex-toolkit.sh [--prefer-workspace] <project-name>

Behavior:
  --check        Show which projects are missing or behind the current toolkit version.
  --all          Sync the current toolkit version into every project under projects/.
  --prefer-workspace
                 Overwrite conflicting synced toolkit files with the workspace copy.
  <project-name> Sync the current toolkit version into one project.
EOF
}

if [ ! -f "$TOOLKIT_VERSION_FILE" ]; then
  echo "Error: missing toolkit version file at $TOOLKIT_VERSION_FILE"
  exit 1
fi

WORKSPACE_VERSION="$(tr -d '[:space:]' < "$TOOLKIT_VERSION_FILE")"
if [ -z "$WORKSPACE_VERSION" ]; then
  echo "Error: toolkit version is empty in $TOOLKIT_VERSION_FILE"
  exit 1
fi

if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Error: projects directory does not exist at $PROJECTS_DIR"
  exit 1
fi

collect_projects() {
  find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | LC_ALL=C sort
}

read_project_version() {
  local project_name="$1"
  local version_file="$PROJECTS_DIR/$project_name/.codex/toolkit-version"

  if [ -f "$version_file" ]; then
    tr -d '[:space:]' < "$version_file"
  else
    printf '%s\n' "missing"
  fi
}

print_status() {
  local project_name="$1"
  local project_version
  project_version="$(read_project_version "$project_name")"

  if [ "$project_version" = "$WORKSPACE_VERSION" ]; then
    printf 'up-to-date  %s (%s)\n' "$project_name" "$project_version"
    return
  fi

  if [ "$project_version" = "missing" ]; then
    printf 'needs-sync  %s (no recorded toolkit version -> %s)\n' "$project_name" "$WORKSPACE_VERSION"
    return
  fi

  printf 'outdated    %s (%s -> %s)\n' "$project_name" "$project_version" "$WORKSPACE_VERSION"
}

sync_project() {
  local project_name="$1"
  if [ "${PREFER_WORKSPACE:-0}" -eq 1 ]; then
    "$SYNC_SCRIPT" --prefer-workspace "$project_name"
  else
    "$SYNC_SCRIPT" "$project_name"
  fi
}

PREFER_WORKSPACE=0
MODE=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefer-workspace)
      PREFER_WORKSPACE=1
      shift
      ;;
    -h|--help|--check|--all)
      MODE="$1"
      shift
      ;;
    *)
      MODE="$1"
      shift
      ;;
  esac

  if [ -n "$MODE" ]; then
    break
  fi
done

case "$MODE" in
  --check)
    while IFS= read -r project_name; do
      print_status "$project_name"
    done < <(collect_projects)
    ;;
  --all)
    while IFS= read -r project_name; do
      sync_project "$project_name"
    done < <(collect_projects)
    ;;
  ""|-h|--help)
    usage
    ;;
  *)
    if [ ! -d "$PROJECTS_DIR/$MODE" ]; then
      echo "Error: project does not exist at $PROJECTS_DIR/$MODE"
      exit 1
    fi
    sync_project "$MODE"
    ;;
esac
