#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ctf-kit new <pwn|rev|crypto|forensics|web|misc> <name>
EOF
}

category="${1:-}"
name="${2:-}"

if [[ -z "$category" || -z "$name" ]]; then
  usage >&2
  exit 1
fi

case "$category" in
  pwn|rev|crypto|forensics|web|misc)
    ;;
  *)
    echo "unsupported category: $category" >&2
    usage >&2
    exit 1
    ;;
esac

safe_name="$(printf '%s' "$name" | tr ' ' '-' | tr -cd '[:alnum:]_.-')"
if [[ -z "$safe_name" ]]; then
  echo "challenge name became empty after sanitizing" >&2
  exit 1
fi

destination="$ROOT/work/$category/$safe_name"
if [[ -e "$destination" ]]; then
  echo "destination already exists: $destination" >&2
  exit 1
fi

mkdir -p "$destination/artifacts" "$destination/notes" "$destination/output"

render_template() {
  local source_file="$1"
  local output_file="$2"
  sed \
    -e "s/__CHALLENGE_NAME__/$safe_name/g" \
    -e "s/__CATEGORY__/$category/g" \
    -e "s/__DATE__/$(date +%F)/g" \
    "$source_file" >"$output_file"
}

render_template "$ROOT/templates/common/README.md" "$destination/README.md"

if [[ -d "$ROOT/templates/$category" ]]; then
  while IFS= read -r -d '' template_path; do
    relative_path="${template_path#"$ROOT/templates/$category/"}"
    mkdir -p "$(dirname "$destination/$relative_path")"
    render_template "$template_path" "$destination/$relative_path"
  done < <(find "$ROOT/templates/$category" -type f -print0 | sort -z)
fi

printf 'created %s\n' "$destination"
