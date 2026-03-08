# Non-AI Workstation

This repository is a local helper system for CTFs and hands-on security work that keeps artifacts, notes, and automation local. It is built for workflows where you want deterministic, grep-driven tooling instead of LLMs, remote AI APIs, or automated AI agents.

## What this gives you

- `install.sh` or `ctf-kit setup`: one-command workstation bootstrap for common CTF profiles
- `ctf-kit doctor`: readiness report with a direct fix path
- `ctf-kit policy-check`: local non-AI workflow self-check for obvious AI tooling drift
- `ctf-kit start`: create a workspace, import artifacts, run triage, and print the next commands
- `ctf-kit ask` or `ctf-kit search`: ranked keyword search across local notes, templates, and setup docs
- `ctf-kit new`: scaffold a challenge workspace with notes and starter files
- `ctf-kit triage`: quick local artifact triage for binaries, archives, pcaps, images, PDFs, and text
- `ctf-kit check-tools`: compare your machine against a curated tooling manifest
- `ctf-kit cheat`: print a category playbook without leaving the terminal
- `docs/references.md`: curated official docs and high-signal training links for deeper follow-up
- `*_SHEET.md`: top-level quick-command sheets for live use

No part of this repository calls an LLM, embedding model, remote AI API, or autonomous agent.

## Quick start

```bash
export PATH="$PWD/bin:$HOME/.local/bin:$PATH"
./install.sh
ctf-kit doctor
ctf-kit policy-check --strict
ctf-kit start ./challenge.zip
ctf-kit ask --any format string leak libc
ctf-kit cheat pwn
```

## Command summary

```text
ctf-kit help
ctf-kit ask [--any|--all] <keywords...>
ctf-kit search [--any|--all] <keywords...>
ctf-kit cheat <policy|live|common|pwn|rev|crypto|forensics|web|misc>
ctf-kit start [--category <name>] [--name <workspace>] <artifact-or-directory>...
ctf-kit new <pwn|rev|crypto|forensics|web|misc> <name>
ctf-kit triage <file-or-directory>
ctf-kit check-tools [all|baseline|rev|pwn|crypto|forensics|web]
ctf-kit doctor [all|baseline|rev|pwn|crypto|forensics|web] [--fix]
ctf-kit setup [all|baseline|rev|pwn|crypto|forensics|web] [--plan|--apply]
ctf-kit policy-check [--strict]
ctf-kit manifest
```

## Repo layout

- `bin/ctf-kit`: main launcher
- `scripts/`: implementation scripts
- `install.sh`: top-level installer wrapper for new teammates
- `knowledge/`: short local playbooks and reminders
- `templates/`: per-category starter files
- `docs/tooling.md`: best-of-breed Ubuntu 24.04 setup guidance
- `docs/references.md`: vetted external references worth keeping bookmarked
- `*_SHEET.md`: condensed command sheets by category
- `config/tool_manifest.tsv`: recommended tools used by `check-tools`
- `work/`: generated challenge workspaces

## Safe usage boundary

Use this repo for:

- local search
- local setup and compliance checks
- command reminders
- workspace setup
- file triage
- non-AI automation like pwntools, Sage, radare2, Ghidra, gdb, Wireshark, rr, angr, z3

Do not use this repo to wrap or proxy any AI service during challenge work. Keep challenge text, files, flags, binaries, pcaps, and datasets out of AI systems entirely if you want a clear non-AI workflow story.

## Recommended next step

Read [docs/tooling.md](docs/tooling.md), run `ctf-kit doctor`, then install the missing tools you actually need for your strongest categories first. The fastest high-value path is usually:

1. baseline CLI tools
2. gdb plus pwndbg or GEF
3. pwntools plus pwninit plus qemu-user
4. Ghidra plus Cutter or radare2
5. SageMath plus core Python crypto libraries
6. tshark plus binwalk plus exiftool
7. ffuf plus httpx plus sqlmap plus Burp

## Recommended day-one flow for a new teammate

```bash
git clone <repo> non-ai-workstation
cd non-ai-workstation
export PATH="$PWD/bin:$HOME/.local/bin:$PATH"
./install.sh
ctf-kit doctor
ctf-kit policy-check --strict
ctf-kit start ./artifact-or-directory
```
