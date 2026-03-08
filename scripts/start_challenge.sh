#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ctf-kit start [--category <pwn|rev|crypto|forensics|web|misc>] [--name <workspace>] <artifact-or-directory>...

Examples:
  ctf-kit start ./challenge.zip
  ctf-kit start --category pwn ./chall ./libc.so.6 ./ld-linux-x86-64.so.2
  ctf-kit start --category web --name notes-api ./app.py ./templates
EOF
}

valid_category() {
  case "$1" in
    pwn|rev|crypto|forensics|web|misc)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

sanitize_name() {
  printf '%s' "$1" | tr ' ' '-' | tr -cd '[:alnum:]_.-'
}

guess_name() {
  local source_path="$1"
  local base_name

  base_name="$(basename -- "$source_path")"
  base_name="${base_name%%.*}"
  sanitize_name "$base_name"
}

DETECTED_CATEGORY=""
DETECTION_REASON=""
detect_category() {
  local source_path="$1"
  local base_lower
  local description
  local mime_type

  base_lower="$(basename -- "$source_path" | tr '[:upper:]' '[:lower:]')"

  if [[ -d "$source_path" ]]; then
    if find "$source_path" -maxdepth 2 -type f | rg -q '/(libc\.so\.6|ld-linux[^/]*|chall|vuln)$'; then
      DETECTED_CATEGORY="pwn"
      DETECTION_REASON="directory contains a pwn-style bundle"
      return
    fi
    if find "$source_path" -maxdepth 2 -type f | rg -q '\.(php|html|js|ts|jsx|tsx|json|har)$'; then
      DETECTED_CATEGORY="web"
      DETECTION_REASON="directory contains source or web assets"
      return
    fi
    if find "$source_path" -maxdepth 2 -type f | rg -q '\.(pcap|pcapng|png|jpg|jpeg|gif|bmp|pdf|zip|7z|rar|tar|gz)$'; then
      DETECTED_CATEGORY="forensics"
      DETECTION_REASON="directory contains evidence-style artifacts"
      return
    fi
    DETECTED_CATEGORY="misc"
    DETECTION_REASON="directory fallback"
    return
  fi

  case "$base_lower" in
    *.pcap|*.pcapng)
      DETECTED_CATEGORY="forensics"
      DETECTION_REASON="packet capture extension"
      return
      ;;
    *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.tiff|*.wav|*.mp3|*.zip|*.7z|*.rar|*.tar|*.gz|*.pdf)
      DETECTED_CATEGORY="forensics"
      DETECTION_REASON="forensics-style extension"
      return
      ;;
    *.sage|*.pem|*.crt|*.der|*.key|*rsa*|*aes*|*ecc*|*crypto*)
      DETECTED_CATEGORY="crypto"
      DETECTION_REASON="crypto-style filename"
      return
      ;;
    *.php|*.html|*.css|*.js|*.ts|*.jsx|*.tsx|*.http|*.har)
      DETECTED_CATEGORY="web"
      DETECTION_REASON="web-style extension"
      return
      ;;
  esac

  description="$(file -b "$source_path")"
  mime_type="$(file -b --mime-type "$source_path")"

  case "$description" in
    *ELF*|*PE32*|*Mach-O*)
      DETECTED_CATEGORY="rev"
      DETECTION_REASON="executable binary; defaulting to rev unless you override with --category pwn"
      return
      ;;
    *pcap*|*pcapng*)
      DETECTED_CATEGORY="forensics"
      DETECTION_REASON="packet-capture file signature"
      return
      ;;
    PDF\ document*|*image\ data*|*archive*|*compressed*)
      DETECTED_CATEGORY="forensics"
      DETECTION_REASON="artifact type is evidence-heavy"
      return
      ;;
  esac

  case "$mime_type" in
    text/html|application/json)
      DETECTED_CATEGORY="web"
      DETECTION_REASON="text payload with a common web MIME type"
      return
      ;;
    text/*)
      DETECTED_CATEGORY="misc"
      DETECTION_REASON="generic text artifact"
      return
      ;;
  esac

  DETECTED_CATEGORY="misc"
  DETECTION_REASON="fallback category"
}

copy_into_artifacts() {
  local source_path="$1"
  local destination_dir="$2"
  local base_name
  local candidate_path
  local suffix=1

  base_name="$(basename -- "$source_path")"
  candidate_path="$destination_dir/$base_name"

  while [[ -e "$candidate_path" ]]; do
    suffix=$((suffix + 1))
    candidate_path="$destination_dir/${base_name}.${suffix}"
  done

  cp -a "$source_path" "$candidate_path"
  printf '%s\n' "$candidate_path"
}

prefill_readme() {
  local readme_file="$1"
  local artifact_names
  local primary_output
  local next_hint

  [[ -f "$readme_file" ]] || return 0

  artifact_names="$(printf '%s\n' "${copied_paths[@]##*/}" | paste -sd ', ' -)"
  primary_output="$(file -b "$primary_artifact" | tr '\n' ' ')"
  next_hint="review output/triage.txt, then run ctf-kit cheat $category"

  export CTF_ARTIFACT_NAMES="$artifact_names"
  export CTF_PRIMARY_OUTPUT="$primary_output"
  export CTF_CATEGORY="$category"
  export CTF_DETECTION_REASON="${DETECTION_REASON:-manual override or explicit category}"
  export CTF_NEXT_HINT="$next_hint"

  perl -0pi -e '
    s/- artifact names:/- artifact names: $ENV{CTF_ARTIFACT_NAMES}/;
    s/- file output:/- file output: $ENV{CTF_PRIMARY_OUTPUT}/;
    s/- likely category:/- likely category: $ENV{CTF_CATEGORY}/;
    s/- likely fastest path:/- likely fastest path: $ENV{CTF_NEXT_HINT}/;
    s/- fact 1:/- fact 1: imported artifacts into artifacts\/ and saved triage under output\/triage.txt/;
    s/- fact 2:/- fact 2: initial category guess is $ENV{CTF_CATEGORY} ($ENV{CTF_DETECTION_REASON})/;
    s/- do this next:/- do this next: review output\/triage.txt and replace placeholders with confirmed facts/;
  ' "$readme_file"
}

category=""
workspace_name=""
inputs=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --category|-c)
      [[ $# -ge 2 ]] || { echo "missing value for $1" >&2; exit 1; }
      category="$2"
      shift 2
      ;;
    --name|-n)
      [[ $# -ge 2 ]] || { echo "missing value for $1" >&2; exit 1; }
      workspace_name="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        inputs+=("$1")
        shift
      done
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      inputs+=("$1")
      shift
      ;;
  esac
done

if [[ ${#inputs[@]} -eq 0 ]]; then
  usage >&2
  exit 1
fi

for source_path in "${inputs[@]}"; do
  if [[ ! -e "$source_path" ]]; then
    echo "input not found: $source_path" >&2
    exit 1
  fi
done

if [[ -n "$category" ]] && ! valid_category "$category"; then
  echo "unsupported category: $category" >&2
  usage >&2
  exit 1
fi

if [[ -z "$category" ]]; then
  detect_category "${inputs[0]}"
  category="$DETECTED_CATEGORY"
fi

if [[ -z "$workspace_name" ]]; then
  workspace_name="$(guess_name "${inputs[0]}")"
fi

safe_name="$(sanitize_name "$workspace_name")"
if [[ -z "$safe_name" ]]; then
  echo "workspace name became empty after sanitizing" >&2
  exit 1
fi

workspace_dir="$ROOT/work/$category/$safe_name"
if [[ ! -d "$workspace_dir" ]]; then
  "$ROOT/scripts/new_challenge.sh" "$category" "$safe_name" >/dev/null
fi

artifacts_dir="$workspace_dir/artifacts"
output_dir="$workspace_dir/output"
manifest_file="$output_dir/imported.txt"
triage_file="$output_dir/triage.txt"
next_steps_file="$output_dir/next_steps.txt"

timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
{
  printf 'Import time: %s\n' "$timestamp"
  printf 'Category: %s\n' "$category"
  printf 'Detection: %s\n' "${DETECTION_REASON:-manual override or explicit category}"
  echo
} >>"$manifest_file"

copied_paths=()
for source_path in "${inputs[@]}"; do
  absolute_source="$(readlink -f "$source_path")"
  copied_path="$(copy_into_artifacts "$absolute_source" "$artifacts_dir")"
  copied_paths+=("$copied_path")
  printf '%s -> %s\n' "$absolute_source" "$copied_path" >>"$manifest_file"
done

{
  printf 'Triage time: %s\n' "$timestamp"
  echo
} >>"$triage_file"

for copied_path in "${copied_paths[@]}"; do
  printf '== %s ==\n' "$copied_path" >>"$triage_file"
  "$ROOT/scripts/triage.sh" "$copied_path" >>"$triage_file"
  echo >>"$triage_file"
done

primary_artifact="${copied_paths[0]}"
prefill_readme "$workspace_dir/README.md"

cat >"$next_steps_file" <<EOF
cd $workspace_dir
sed -n '1,120p' README.md
sed -n '1,120p' $(printf '%q' "$triage_file")
ctf-kit cheat $category
ctf-kit ask --any $(printf '%q ' "$category" "${safe_name//-/ }")
EOF

echo "Workspace: $workspace_dir"
echo "Category: $category"
echo "Detection: ${DETECTION_REASON:-manual override or explicit category}"
echo "Imported artifacts:"
for copied_path in "${copied_paths[@]}"; do
  printf '  - %s\n' "$copied_path"
done
echo
echo "Saved:"
echo "  - $manifest_file"
echo "  - $triage_file"
echo "  - $next_steps_file"
echo
echo "Recommended next commands:"
echo "  cd $workspace_dir"
echo "  sed -n '1,120p' README.md"
echo "  sed -n '1,160p' $(printf '%q' "$triage_file")"
echo "  ctf-kit cheat $category"
echo "  ctf-kit ask --any ${category} ${safe_name//-/ }"

if [[ "$category" == "rev" ]]; then
  echo
  echo "Note: executables default to rev. If this is an exploit target, restart with --category pwn."
fi

if [[ -f "$primary_artifact" ]]; then
  echo "Primary artifact: $primary_artifact"
fi
