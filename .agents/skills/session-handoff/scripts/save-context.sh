#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="${1:-}"
TASK_NAME="${2:-}"
SOURCE_FILE="${3:-}"

if [[ -z "$PROJECT_NAME" ]]; then
  echo "Error: project name is required"
  echo "Usage: ./save-context.sh <project-name> <task-name> <source-markdown-file>"
  exit 1
fi

if [[ -z "$TASK_NAME" ]]; then
  echo "Error: task name is required"
  echo "Usage: ./save-context.sh <project-name> <task-name> <source-markdown-file>"
  exit 1
fi

if [[ -z "$SOURCE_FILE" ]]; then
  echo "Error: source markdown file is required"
  echo "Usage: ./save-context.sh <project-name> <task-name> <source-markdown-file>"
  exit 1
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: source file does not exist: $SOURCE_FILE"
  exit 1
fi

TARGET_DIR="context/$PROJECT_NAME"
TARGET_FILE="$TARGET_DIR/$TASK_NAME.md"

mkdir -p "$TARGET_DIR"
cp "$SOURCE_FILE" "$TARGET_FILE"

echo "Saved handoff to: $TARGET_FILE"
