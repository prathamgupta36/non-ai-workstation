#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/config/tool_manifest.tsv"

usage() {
  cat <<'EOF'
Usage:
  ctf-kit check-tools [all|baseline|rev|pwn|crypto|forensics|web]
  ctf-kit doctor [all|baseline|rev|pwn|crypto|forensics|web] [--fix]

Notes:
  doctor prints a summary and the next setup command.
  doctor --fix forwards to ctf-kit setup <profile> --apply.
EOF
}

mode="check-tools"
if [[ $# -gt 0 ]]; then
  case "$1" in
    check-tools|doctor)
      mode="$1"
      shift
      ;;
  esac
fi

filter="all"
fix=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    all|baseline|rev|pwn|crypto|forensics|web)
      filter="$1"
      shift
      ;;
    --fix)
      fix=1
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

if [[ ! -f "$MANIFEST" ]]; then
  echo "manifest not found: $MANIFEST" >&2
  exit 1
fi

check_probe() {
  local probe="$1"

  case "$probe" in
    cmd:*)
      command -v "${probe#cmd:}" >/dev/null 2>&1
      ;;
    python_module:*)
      python3 -c "import ${probe#python_module:}" >/dev/null 2>&1
      ;;
    path:*)
      local path_probe="${probe#path:}"
      path_probe="${path_probe/#\~/$HOME}"
      [[ -e "$path_probe" ]]
      ;;
    shell:*)
      bash -lc "${probe#shell:}" >/dev/null 2>&1
      ;;
    *)
      return 1
      ;;
  esac
}

ok_count=0
missing_count=0
core_missing=0
optional_missing=0
missing_lines=()

printf '%-11s %-8s %-16s %-8s %s\n' "category" "tier" "tool" "status" "install hint"
printf '%-11s %-8s %-16s %-8s %s\n' "--------" "----" "----" "------" "------------"

while IFS=$'\t' read -r category tier label probe install_hint; do
  [[ -z "$category" || "${category:0:1}" == "#" ]] && continue
  [[ "$filter" != "all" && "$filter" != "$category" ]] && continue

  status="missing"
  if check_probe "$probe"; then
    status="ok"
    ok_count=$((ok_count + 1))
  else
    missing_count=$((missing_count + 1))
    if [[ "$tier" == "core" ]]; then
      core_missing=$((core_missing + 1))
    else
      optional_missing=$((optional_missing + 1))
    fi
    missing_lines+=("$category|$tier|$label|$install_hint")
  fi

  printf '%-11s %-8s %-16s %-8s %s\n' "$category" "$tier" "$label" "$status" "$install_hint"
done <"$MANIFEST"

echo
printf 'Summary: %d ok, %d missing (%d core, %d optional)\n' \
  "$ok_count" "$missing_count" "$core_missing" "$optional_missing"

if [[ "$mode" == "doctor" ]]; then
  if [[ $missing_count -eq 0 ]]; then
    echo "Doctor: no missing tools for profile '$filter'."
  else
    echo "Doctor: missing tools worth fixing first:"
    for line in "${missing_lines[@]}"; do
      IFS='|' read -r category tier label install_hint <<<"$line"
      printf '  - [%s/%s] %s: %s\n' "$category" "$tier" "$label" "$install_hint"
    done
    echo
    echo "Next step:"
    if [[ "$filter" == "all" ]]; then
      echo "  ctf-kit setup all --apply"
    else
      echo "  ctf-kit setup $filter --apply"
    fi
  fi

  if [[ $fix -eq 1 ]]; then
    if [[ "$filter" == "all" ]]; then
      exec "$ROOT/scripts/setup.sh" all --apply
    fi
    exec "$ROOT/scripts/setup.sh" "$filter" --apply
  fi
fi
