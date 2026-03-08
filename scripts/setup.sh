#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ctf-kit setup [all|baseline|rev|pwn|crypto|forensics|web] [--plan|--apply]

Examples:
  ctf-kit setup all --plan
  ctf-kit setup pwn --apply
  ./install.sh
EOF
}

profile="all"
action="plan"

while [[ $# -gt 0 ]]; do
  case "$1" in
    all|baseline|rev|pwn|crypto|forensics|web)
      profile="$1"
      shift
      ;;
    --plan)
      action="plan"
      shift
      ;;
    --apply)
      action="apply"
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

selected_profiles=()
if [[ "$profile" == "all" ]]; then
  selected_profiles=(baseline rev pwn crypto forensics web)
else
  selected_profiles=("$profile")
fi

declare -A seen_apt=()
declare -A seen_pip=()
declare -A seen_gem=()
manual_steps=()

add_apt() {
  local package
  for package in "$@"; do
    [[ -n "$package" ]] || continue
    seen_apt["$package"]=1
  done
}

add_pip() {
  local package
  for package in "$@"; do
    [[ -n "$package" ]] || continue
    seen_pip["$package"]=1
  done
}

add_gem() {
  local package
  for package in "$@"; do
    [[ -n "$package" ]] || continue
    seen_gem["$package"]=1
  done
}

add_manual() {
  local step
  for step in "$@"; do
    [[ -n "$step" ]] || continue
    manual_steps+=("$step")
  done
}

for item in "${selected_profiles[@]}"; do
  case "$item" in
    baseline)
      add_apt tmux fzf ripgrep fd-find jq bat tree unzip p7zip-full \
        build-essential clang cmake ninja-build gdb gdb-multiarch lldb \
        strace ltrace binutils file xxd curl ca-certificates python3-pip \
        python3-venv pipx
      ;;
    rev)
      add_apt openjdk-21-jdk qemu-user qemu-user-static rr upx-ucl
      add_manual \
        "Install Ghidra and add ghidraRun to PATH." \
        "Optional second-opinion RE GUI: install Cutter or IDA Free."
      ;;
    pwn)
      add_apt patchelf qemu-user qemu-user-static ruby-full
      add_pip pwntools ropper ROPGadget
      add_manual \
        "Install pwninit release binary and add it to PATH." \
        "Install pwndbg or GEF for a first-class gdb workflow." \
        "Install libc-database or another local libc lookup helper."
      ;;
    crypto)
      add_apt sagemath pari-gp hashcat john openssl
      add_pip pycryptodome gmpy2 sympy
      ;;
    forensics)
      add_apt tshark binwalk libimage-exiftool-perl pngcheck steghide stegseek volatility3 sleuthkit
      add_gem zsteg
      add_manual "Install Wireshark desktop if you want a GUI packet workflow."
      ;;
    web)
      add_apt ffuf sqlmap seclists zaproxy
      add_manual \
        "Install projectdiscovery httpx and add it to PATH." \
        "Install Burp Suite Community if your workflow depends on Repeater/Intruder." \
        "Optional: install feroxbuster for recursive content discovery."
      ;;
  esac
done

apt_packages=()
for package in "${!seen_apt[@]}"; do
  apt_packages+=("$package")
done
IFS=$'\n' apt_packages=($(printf '%s\n' "${apt_packages[@]}" | sort))

pip_packages=()
for package in "${!seen_pip[@]}"; do
  pip_packages+=("$package")
done
IFS=$'\n' pip_packages=($(printf '%s\n' "${pip_packages[@]}" | sort))

gem_packages=()
for package in "${!seen_gem[@]}"; do
  gem_packages+=("$package")
done
IFS=$'\n' gem_packages=($(printf '%s\n' "${gem_packages[@]}" | sort))

run_cmd() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
  "$@"
}

print_section() {
  local title="$1"
  shift
  echo "$title"
  if [[ $# -eq 0 ]]; then
    echo "  (none)"
    return
  fi

  local item
  for item in "$@"; do
    echo "  - $item"
  done
}

echo "Profile: $profile"
echo "Action: $action"
echo

print_section "APT packages" "${apt_packages[@]}"
echo
print_section "Python user packages" "${pip_packages[@]}"
echo
print_section "Ruby gems" "${gem_packages[@]}"
echo
print_section "Manual follow-up" "${manual_steps[@]}"
echo
echo "PATH reminder:"
echo "  export PATH=\"$ROOT/bin:\$HOME/.local/bin:\$PATH\""

if [[ "$action" != "apply" ]]; then
  echo
  echo "Dry run only. Re-run with --apply to install the scripted pieces."
  exit 0
fi

sudo_cmd=()
if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    sudo_cmd=(sudo)
  else
    echo "need root privileges or sudo for apt packages" >&2
    exit 1
  fi
fi

if [[ ${#apt_packages[@]} -gt 0 ]]; then
  run_cmd "${sudo_cmd[@]}" apt-get update
  run_cmd "${sudo_cmd[@]}" apt-get install -y "${apt_packages[@]}"
fi

if [[ ${#pip_packages[@]} -gt 0 ]]; then
  run_cmd python3 -m pip install --user --upgrade "${pip_packages[@]}"
fi

if [[ ${#gem_packages[@]} -gt 0 ]]; then
  if ! command -v gem >/dev/null 2>&1; then
    echo "ruby gems requested but gem is not installed; install ruby-full first" >&2
    exit 1
  fi
  run_cmd gem install --user-install "${gem_packages[@]}"
fi

if [[ ${#manual_steps[@]} -gt 0 ]]; then
  echo
  echo "Manual follow-up still required:"
  print_section "Manual follow-up" "${manual_steps[@]}"
fi
