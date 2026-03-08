#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SEARCH_DIRS=("$ROOT/knowledge" "$ROOT/templates" "$ROOT/docs")
shopt -s nullglob
ROOT_SHEETS=("$ROOT"/*_SHEET.md "$ROOT/README.md")

usage() {
  cat <<'EOF'
Usage:
  ctf-kit ask [--any|--all] <keywords...>
  ctf-kit search [--any|--all] <keywords...>

Modes:
  --any  return files matching any keyword and rank them by score (default)
  --all  require every keyword to appear somewhere in the file

Without keywords, an interactive file picker is opened if fzf is installed.
EOF
}

mode="any"
tokens=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --any)
      mode="any"
      shift
      ;;
    --all)
      mode="all"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      tokens+=("$1")
      shift
      ;;
  esac
done

if [[ ${#tokens[@]} -eq 0 ]]; then
  if command -v fzf >/dev/null 2>&1; then
    selection="$(
      {
        rg --files "${SEARCH_DIRS[@]}"
        printf '%s\n' "${ROOT_SHEETS[@]}"
      } \
        | sed "s#^$ROOT/##" \
        | sort -u \
        | fzf --prompt='ctf-kit> '
    )" || exit 1
    [[ -n "$selection" ]] || exit 1
    exec "${PAGER:-cat}" "$ROOT/$selection"
  fi

  usage >&2
  exit 1
fi

deduped_tokens=()
for token in "${tokens[@]}"; do
  trimmed="$(printf '%s' "$token" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  [[ -n "$trimmed" ]] || continue
  seen=0
  for existing in "${deduped_tokens[@]}"; do
    if [[ "${existing,,}" == "${trimmed,,}" ]]; then
      seen=1
      break
    fi
  done
  if [[ $seen -eq 0 ]]; then
    deduped_tokens+=("$trimmed")
  fi
done

if [[ ${#deduped_tokens[@]} -eq 0 ]]; then
  echo "no usable keywords supplied" >&2
  exit 1
fi

search_files=()
while IFS= read -r file_path; do
  search_files+=("$file_path")
done < <(
  {
    rg --files "${SEARCH_DIRS[@]}"
    printf '%s\n' "${ROOT_SHEETS[@]}"
  } | sort -u
)

rg_args=()
for token in "${deduped_tokens[@]}"; do
  rg_args+=("-e" "$token")
done

candidates=()
while IFS= read -r matched_file; do
  candidates+=("$matched_file")
done < <(rg -l -i "${rg_args[@]}" "${search_files[@]}" 2>/dev/null || true)

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "no matches for: ${deduped_tokens[*]}"
  if command -v apropos >/dev/null 2>&1; then
    echo
    echo "== apropos =="
    apropos "${deduped_tokens[0]}" 2>/dev/null | head -n 10 || true
  fi
  exit 1
fi

scored_results=()
for file_path in "${candidates[@]}"; do
  score=0
  rank=0
  bonus=0
  matched_tokens=()
  for token in "${deduped_tokens[@]}"; do
    if rg -q -i -e "$token" "$file_path"; then
      score=$((score + 1))
      matched_tokens+=("$token")
    fi
  done

  if [[ "$mode" == "all" && $score -ne ${#deduped_tokens[@]} ]]; then
    continue
  fi

  relative_path="${file_path#"$ROOT/"}"
  case "$relative_path" in
    knowledge/*)
      bonus=3
      ;;
    *_SHEET.md)
      bonus=2
      ;;
    docs/*)
      bonus=1
      ;;
    README.md)
      bonus=-10
      ;;
  esac

  rank=$((score * 10 + bonus))
  scored_results+=("$(printf '%04d\t%03d\t%s\t%s' "$rank" "$score" "$relative_path" "${matched_tokens[*]}")")
done

if [[ ${#scored_results[@]} -eq 0 ]]; then
  echo "no files matched all keywords: ${deduped_tokens[*]}"
  exit 1
fi

printf 'Query mode: %s\n' "$mode"
printf 'Keywords: %s\n' "${deduped_tokens[*]}"
echo

count=0
while IFS=$'\t' read -r padded_rank padded_score relative_path matched_summary; do
  [[ -n "$relative_path" ]] || continue
  count=$((count + 1))
  absolute_path="$ROOT/$relative_path"
  printf '== %s [%s/%s] ==\n' "$relative_path" "$((10#$padded_score))" "${#deduped_tokens[@]}"
  printf 'matched: %s\n' "$matched_summary"
  rg -n -i --context 1 "${rg_args[@]}" "$absolute_path" | sed -n '1,18p'
  echo
  if [[ $count -ge 12 ]]; then
    break
  fi
done < <(printf '%s\n' "${scored_results[@]}" | sort -r)

if command -v apropos >/dev/null 2>&1; then
  echo "== apropos =="
  apropos "${deduped_tokens[0]}" 2>/dev/null | head -n 10 || true
fi
