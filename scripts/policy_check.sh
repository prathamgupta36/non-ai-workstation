#!/usr/bin/env bash
set -euo pipefail

strict=0

usage() {
  cat <<'EOF'
Usage:
  ctf-kit policy-check [--strict]

Checks for common AI-related environment variables, CLIs, and editor extensions that
can weaken your non-AI workstation story.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      strict=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

warnings=()

add_warning() {
  warnings+=("$1")
}

check_env_vars() {
  local name
  while IFS='=' read -r name _; do
    case "$name" in
      OPENAI_*|ANTHROPIC_*|CLAUDE_*|GOOGLE_GENERATIVE_AI_*|GEMINI_*|MISTRAL_*|GROQ_*|PERPLEXITY_*|OLLAMA_*|LLM_*|AIDER_*)
        add_warning "environment variable set: $name"
        ;;
    esac
  done < <(env | sort)
}

check_commands() {
  local candidate
  for candidate in aider sgpt shell-gpt mods llm codex opencode cursor windsurf ollama; do
    if command -v "$candidate" >/dev/null 2>&1; then
      add_warning "AI-oriented CLI on PATH: $candidate"
    fi
  done
}

check_extension_dir() {
  local extension_root="$1"
  local extension_name

  [[ -d "$extension_root" ]] || return 0

  while IFS= read -r extension_name; do
    case "$extension_name" in
      *copilot*|*tabnine*|*continue*|*codeium*|*codium*|*supermaven*|*openai*|*anthropic*|*claude*|*windsurf*|*cursor*|*llm*)
        add_warning "editor extension installed under $extension_root: $extension_name"
        ;;
    esac
  done < <(find "$extension_root" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null | sort)
}

check_env_vars
check_commands
check_extension_dir "$HOME/.vscode/extensions"
check_extension_dir "$HOME/.vscode-insiders/extensions"
check_extension_dir "$HOME/.cursor/extensions"
check_extension_dir "$HOME/.local/share/code-server/extensions"

if [[ ${#warnings[@]} -eq 0 ]]; then
  echo "Policy check: clean."
  echo "No obvious AI env vars, CLIs, or editor extensions were detected."
  exit 0
fi

echo "Policy check: warnings found."
for warning in "${warnings[@]}"; do
  echo "  - $warning"
done
echo
echo "Recommended action:"
echo "  - unset AI API keys for the event shell"
echo "  - disable AI editor extensions and chat plugins"
echo "  - use a dedicated browser/editor profile for the competition"

if [[ $strict -eq 1 ]]; then
  exit 1
fi
