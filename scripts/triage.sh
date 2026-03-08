#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ctf-kit triage <file-or-directory>
EOF
}

target="${1:-}"
if [[ -z "$target" ]]; then
  usage >&2
  exit 1
fi

if [[ ! -e "$target" ]]; then
  echo "target not found: $target" >&2
  exit 1
fi

if [[ -d "$target" ]]; then
  echo "Directory: $(readlink -f "$target")"
  echo
  find "$target" -maxdepth 2 -mindepth 1 -printf '%y %P\n' | sort
  exit 0
fi

description="$(file -b "$target")"
mime_type="$(file -b --mime-type "$target")"

echo "Path: $(readlink -f "$target")"
echo "Type: $description"
echo "MIME: $mime_type"
echo "Size: $(stat -c%s "$target") bytes"
echo "SHA256: $(sha256sum "$target" | awk '{print $1}')"
echo

show_binary() {
  echo "== Binary summary =="

  if command -v checksec >/dev/null 2>&1; then
    checksec --file="$target" || true
  elif command -v pwn >/dev/null 2>&1; then
    pwn checksec "$target" || true
  fi

  if command -v readelf >/dev/null 2>&1; then
    readelf -h "$target" | grep -E 'Class:|Data:|Machine:|Type:|Entry point address:' || true
  fi

  if command -v ldd >/dev/null 2>&1; then
    echo
    echo "Linked libraries:"
    ldd "$target" 2>/dev/null || true
  fi

  echo
  echo "Interesting strings:"
  strings -a -n 8 "$target" | head -n 20 || true
  echo
  echo "Suggested next steps:"
  echo "- Run Ghidra or Cutter for static analysis."
  echo "- Break on input parsing and comparisons in gdb."
  echo "- If this is a pwn target, inspect mitigations and libc/ld.so alignment first."
}

show_archive() {
  echo "== Archive summary =="
  case "$description" in
    *Zip\ archive*)
      unzip -l "$target" 2>/dev/null || true
      ;;
    *tar\ archive*)
      tar -tf "$target" 2>/dev/null | head -n 40 || true
      ;;
    *gzip\ compressed*)
      gzip -l "$target" 2>/dev/null || true
      ;;
  esac

  if command -v binwalk >/dev/null 2>&1; then
    echo
    binwalk "$target" || true
  fi

  echo
  echo "Suggested next steps:"
  echo "- List contents without extracting anything surprising."
  echo "- Check for nested archives or embedded files."
}

show_text() {
  echo "== Text preview =="
  sed -n '1,40p' "$target"
}

show_pdf() {
  echo "== PDF summary =="
  if command -v pdfinfo >/dev/null 2>&1; then
    pdfinfo "$target" || true
  fi

  if command -v pdftotext >/dev/null 2>&1; then
    echo
    echo "Extracted text preview:"
    pdftotext "$target" - 2>/dev/null | sed -n '1,40p'
  fi
}

show_image() {
  echo "== Image summary =="
  if command -v exiftool >/dev/null 2>&1; then
    exiftool "$target" || true
  fi

  echo
  echo "Interesting strings:"
  strings -a -n 8 "$target" | head -n 20 || true

  echo
  echo "Suggested next steps:"
  echo "- Check metadata, dimensions, channels, and trailing data."
  echo "- Try pngcheck, zsteg, steghide, or stegseek if the file type fits."
}

show_pcap() {
  echo "== PCAP summary =="
  if command -v capinfos >/dev/null 2>&1; then
    capinfos "$target" || true
  elif command -v tshark >/dev/null 2>&1; then
    tshark -r "$target" -q -z io,phs 2>/dev/null | sed -n '1,40p'
  fi

  echo
  echo "Suggested next steps:"
  echo "- Identify protocols and export objects before deep packet inspection."
}

case "$description" in
  *ELF*|*PE32*|*Mach-O*)
    show_binary
    ;;
  *Zip\ archive*|*tar\ archive*|*gzip\ compressed*|*7-zip\ archive*|*RAR\ archive*)
    show_archive
    ;;
  *pcap*|*pcapng*)
    show_pcap
    ;;
  PDF\ document*)
    show_pdf
    ;;
  *image\ data*|*bitmap*)
    show_image
    ;;
  ASCII\ text*|UTF-8\ Unicode\ text*|JSON\ text*|*script*)
    show_text
    ;;
  *)
    echo "No specialized triage branch for this file type."
    echo "Start with: file, strings, xxd, binwalk, and a manual preview."
    ;;
esac
