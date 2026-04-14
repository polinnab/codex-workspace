#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_DIR="$ROOT/projects"
TEMPLATE_FILE="$ROOT/.agents/templates/project-AGENTS.template.md"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/project-onboarding.sh <git-url-or-project-name> [project-name]

Examples:
  ./scripts/project-onboarding.sh git@github.com:org/app.git
  ./scripts/project-onboarding.sh https://github.com/org/app.git my-app
  ./scripts/project-onboarding.sh my-app

Behavior:
  - If given a git URL, clone the repo into projects/<name>.
  - If given an existing project name, reuse projects/<name>.
  - Sync the Codex toolkit into the project.
  - Inspect the repo and write onboarding notes under .codex/notes/.
EOF
}

if [ "${1:-}" = "" ]; then
  usage
  exit 1
fi

INPUT="$1"
PROJECT_NAME="${2:-}"

is_git_url() {
  case "$1" in
    git@*|ssh://*|http://*|https://*|git://*) return 0 ;;
    *.git) return 0 ;;
    *) return 1 ;;
  esac
}

derive_project_name() {
  local value
  value="$(basename "$1")"
  value="${value%.git}"
  printf '%s\n' "$value"
}

append_line() {
  if [ -n "$2" ]; then
    printf '%s\n' "$2" >> "$1"
  fi
}

detect_package_manager() {
  local dir="$1"

  if [ -f "$dir/pnpm-lock.yaml" ] || [ -f "$dir/pnpm-workspace.yaml" ]; then
    printf '%s\n' "pnpm"
    return
  fi

  if [ -f "$dir/yarn.lock" ]; then
    printf '%s\n' "yarn"
    return
  fi

  if [ -f "$dir/package-lock.json" ]; then
    printf '%s\n' "npm"
    return
  fi

  if [ -f "$dir/bun.lockb" ] || [ -f "$dir/bun.lock" ]; then
    printf '%s\n' "bun"
    return
  fi

  if [ -f "$dir/composer.lock" ] || [ -f "$dir/composer.json" ]; then
    printf '%s\n' "composer"
    return
  fi

  if [ -f "$dir/Cargo.toml" ]; then
    printf '%s\n' "cargo"
    return
  fi

  if [ -f "$dir/go.mod" ]; then
    printf '%s\n' "go"
    return
  fi

  if find "$dir" -maxdepth 2 \( -name '*.sln' -o -name '*.csproj' \) | grep -q .; then
    printf '%s\n' ".NET SDK"
    return
  fi

  if [ -f "$dir/pyproject.toml" ] || [ -f "$dir/requirements.txt" ]; then
    printf '%s\n' "python tooling"
    return
  fi

  printf '%s\n' "not detected"
}

collect_stack_lines() {
  local dir="$1"

  [ -f "$dir/package.json" ] && printf '%s\n' "- JavaScript / TypeScript signals: package.json"
  [ -f "$dir/pyproject.toml" ] && printf '%s\n' "- Python signals: pyproject.toml"
  [ -f "$dir/requirements.txt" ] && printf '%s\n' "- Python signals: requirements.txt"
  [ -f "$dir/composer.json" ] && printf '%s\n' "- PHP signals: composer.json"
  [ -f "$dir/Cargo.toml" ] && printf '%s\n' "- Rust signals: Cargo.toml"
  [ -f "$dir/go.mod" ] && printf '%s\n' "- Go signals: go.mod"
  [ -f "$dir/Gemfile" ] && printf '%s\n' "- Ruby signals: Gemfile"
  [ -f "$dir/pom.xml" ] && printf '%s\n' "- Java signals: pom.xml"
  [ -f "$dir/build.gradle" ] && printf '%s\n' "- Java / Gradle signals: build.gradle"
  [ -f "$dir/build.gradle.kts" ] && printf '%s\n' "- Kotlin / Gradle signals: build.gradle.kts"

  if find "$dir" -maxdepth 2 \( -name '*.sln' -o -name '*.csproj' \) | grep -q .; then
    printf '%s\n' "- .NET signals: solution or project files"
  fi

  if [ -f "$dir/pnpm-workspace.yaml" ] || [ -f "$dir/turbo.json" ]; then
    printf '%s\n' "- Monorepo signals: workspace or turbo config"
  fi
}

collect_repo_signal_lines() {
  local dir="$1"

  for file in AGENTS.md README.md README package.json pyproject.toml composer.json Cargo.toml go.mod Makefile justfile pom.xml build.gradle build.gradle.kts Gemfile pnpm-workspace.yaml turbo.json; do
    if [ -f "$dir/$file" ]; then
      printf '%s\n' "- $file"
    fi
  done

  find "$dir" -maxdepth 2 \( -name '*.sln' -o -name '*.csproj' \) -print | sed "s#^$dir/#- #"
}

collect_validation_lines() {
  local dir="$1"
  local package_manager
  package_manager="$(detect_package_manager "$dir")"

  if [ -f "$dir/Makefile" ]; then
    grep -Eq '^(validate|check|test|lint|typecheck|build):' "$dir/Makefile" && printf '%s\n' "- Make targets detected. Prefer documented targets such as: make validate, make check, make test"
  fi

  if [ -f "$dir/justfile" ]; then
    grep -Eq '^(validate|check|test|lint|typecheck|build):' "$dir/justfile" && printf '%s\n' "- just targets detected. Prefer documented targets such as: just validate, just check, just test"
  fi

  if [ -f "$dir/package.json" ]; then
    grep -Eq '"validate"[[:space:]]*:' "$dir/package.json" && printf '%s run validate\n' "- package.json script candidate: $package_manager"
    grep -Eq '"check"[[:space:]]*:' "$dir/package.json" && printf '%s run check\n' "- package.json script candidate: $package_manager"
    grep -Eq '"test"[[:space:]]*:' "$dir/package.json" && printf '%s run test\n' "- package.json script candidate: $package_manager"
    grep -Eq '"lint"[[:space:]]*:' "$dir/package.json" && printf '%s run lint\n' "- package.json script candidate: $package_manager"
    grep -Eq '"typecheck"[[:space:]]*:' "$dir/package.json" && printf '%s run typecheck\n' "- package.json script candidate: $package_manager"
  fi

  if [ -f "$dir/composer.json" ]; then
    grep -Eq '"test"[[:space:]]*:' "$dir/composer.json" && printf '%s\n' "- composer script candidate: composer test"
    grep -Eq '"lint"[[:space:]]*:' "$dir/composer.json" && printf '%s\n' "- composer script candidate: composer lint"
    [ -f "$dir/artisan" ] && printf '%s\n' "- Laravel-style test candidate: php artisan test"
    [ -x "$dir/vendor/bin/phpunit" ] && printf '%s\n' "- PHPUnit candidate: vendor/bin/phpunit"
    [ -x "$dir/vendor/bin/phpstan" ] && printf '%s\n' "- PHPStan candidate: vendor/bin/phpstan"
    [ -x "$dir/vendor/bin/pint" ] && printf '%s\n' "- Pint candidate: vendor/bin/pint"
  fi

  if [ -f "$dir/pyproject.toml" ] || [ -f "$dir/requirements.txt" ]; then
    printf '%s\n' "- Python candidates to verify in docs: pytest, ruff check, mypy"
  fi

  if [ -f "$dir/Cargo.toml" ]; then
    printf '%s\n' "- Rust candidates: cargo test, cargo clippy, cargo fmt --check"
  fi

  if [ -f "$dir/go.mod" ]; then
    printf '%s\n' "- Go candidate: go test ./..."
  fi

  if find "$dir" -maxdepth 2 \( -name '*.sln' -o -name '*.csproj' \) | grep -q .; then
    printf '%s\n' "- .NET candidate: dotnet test"
  fi

  if [ -f "$dir/pom.xml" ] || [ -f "$dir/build.gradle" ] || [ -f "$dir/build.gradle.kts" ]; then
    printf '%s\n' "- JVM candidates to verify in docs: mvn test, ./gradlew test"
  fi

  if [ -f "$dir/Gemfile" ]; then
    printf '%s\n' "- Ruby candidates to verify in docs: bundle exec rspec, bundle exec rubocop"
  fi
}

ensure_bullet_fallback() {
  local content="$1"
  local fallback="$2"

  if [ -n "$content" ]; then
    printf '%s\n' "$content"
  else
    printf '%s\n' "$fallback"
  fi
}

if is_git_url "$INPUT"; then
  if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="$(derive_project_name "$INPUT")"
  fi

  TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"
  if [ -e "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR already exists"
    exit 1
  fi

  mkdir -p "$PROJECTS_DIR"
  echo "Cloning repository into $TARGET_DIR"
  git clone "$INPUT" "$TARGET_DIR"
else
  if [ -n "$PROJECT_NAME" ]; then
    echo "Error: a project name override is only supported for git URL onboarding"
    exit 1
  fi

  PROJECT_NAME="$INPUT"
  TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"
  if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: $TARGET_DIR does not exist"
    echo "Pass a git URL to clone a new project or an existing project name under projects/."
    exit 1
  fi
fi

"$ROOT/scripts/sync-codex-toolkit.sh" "$PROJECT_NAME"

NOTES_DIR="$TARGET_DIR/.codex/notes"
REPORT_FILE="$NOTES_DIR/project-onboarding-report.md"
DRAFT_FILE="$NOTES_DIR/AGENTS.generated.md"
PROJECT_AGENTS_FILE="$TARGET_DIR/AGENTS.md"

mkdir -p "$NOTES_DIR"

STACK_LINES="$(collect_stack_lines "$TARGET_DIR" || true)"
SIGNAL_LINES="$(collect_repo_signal_lines "$TARGET_DIR" || true)"
VALIDATION_LINES="$(collect_validation_lines "$TARGET_DIR" || true)"
PACKAGE_MANAGER="$(detect_package_manager "$TARGET_DIR")"

{
  printf '# Project Onboarding Report\n\n'
  printf '## Project\n\n'
  printf -- '- Name: %s\n' "$PROJECT_NAME"
  printf -- '- Path: projects/%s\n' "$PROJECT_NAME"
  printf -- '- Existing AGENTS.md: %s\n' "$([ -f "$PROJECT_AGENTS_FILE" ] && printf 'yes' || printf 'no')"
  printf '\n## Detected Stack Signals\n\n'
  ensure_bullet_fallback "$STACK_LINES" "- No strong stack signals detected from the common manifest list."
  printf '\n## Repo Signals\n\n'
  ensure_bullet_fallback "$SIGNAL_LINES" "- No common onboarding signals detected in the repo root."
  printf '\n## Tooling Guess\n\n'
  printf -- '- Package manager / task runner guess: %s\n' "$PACKAGE_MANAGER"
  printf '\n## Validation Candidates\n\n'
  ensure_bullet_fallback "$VALIDATION_LINES" "- No reliable validation candidates detected automatically. Check project docs and ask the user."
  printf '\n## Recommended Next Questions\n\n'
  printf -- '- Confirm the preferred development command.\n'
  printf -- '- Confirm the preferred validation command or command set.\n'
  printf -- '- Confirm environment setup requirements.\n'
  printf -- '- If this is a monorepo, confirm the primary app or package.\n'
} > "$REPORT_FILE"

if [ ! -f "$PROJECT_AGENTS_FILE" ]; then
  cp "$TEMPLATE_FILE" "$DRAFT_FILE"
  {
    printf '\n## Auto-detected Context\n\n'
    printf -- '- Project path: projects/%s\n' "$PROJECT_NAME"
    printf -- '- Package manager / task runner guess: %s\n' "$PACKAGE_MANAGER"
    printf '\n### Detected Stack Signals\n\n'
    ensure_bullet_fallback "$STACK_LINES" "- No strong stack signals detected automatically."
    printf '\n### Validation Candidates To Confirm\n\n'
    ensure_bullet_fallback "$VALIDATION_LINES" "- No reliable validation candidates detected automatically."
  } >> "$DRAFT_FILE"
fi

echo "Onboarding report: $REPORT_FILE"
if [ -f "$DRAFT_FILE" ]; then
  echo "Generated AGENTS draft: $DRAFT_FILE"
fi
if [ -f "$PROJECT_AGENTS_FILE" ]; then
  echo "Existing project AGENTS.md: $PROJECT_AGENTS_FILE"
fi
echo "Project onboarding scaffold complete"
