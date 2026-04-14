#!/usr/bin/env bash

set -euo pipefail

# Saved session handoffs live only under .codex/context.
# Keep this helper aligned with the session-handoff skill docs.

TASK_NAME="${1:-}"
SOURCE_FILE="${2:-}"

if [[ -z "$TASK_NAME" ]]; then
  echo "Error: task name is required"
  echo "Usage: ./save-context.sh <task-name> <source-markdown-file>"
  exit 1
fi

if [[ -z "$SOURCE_FILE" ]]; then
  echo "Error: source markdown file is required"
  echo "Usage: ./save-context.sh <task-name> <source-markdown-file>"
  exit 1
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: source file does not exist: $SOURCE_FILE"
  exit 1
fi

TARGET_DIR=".codex/context"
TARGET_FILE="$TARGET_DIR/$TASK_NAME.md"

mkdir -p "$TARGET_DIR"
cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Saved handoff to: $TARGET_FILE"
