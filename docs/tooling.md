# Best-Of-Breed Non-AI Setup

This guide is tuned for Ubuntu 24.04.4 LTS on x86_64, which is the current machine.

## Fast onboarding

For a new teammate, the intended path is:

```bash
export PATH="$PWD/bin:$HOME/.local/bin:$PATH"
./install.sh
ctf-kit doctor
ctf-kit policy-check --strict
ctf-kit start ./artifact-or-directory
```

If you only want a subset, use `ctf-kit setup <profile> --plan` first.

## Policy boundary

The local contest PDF draws a hard line:

- allowed: AI only as a reference or search tool
- prohibited: giving AI challenge descriptions, files, prompts, binaries, datasets, or asking it to solve
- prohibited: AI exploit generation for a challenge
- prohibited: AI agents, automated prompt pipelines, or scripts that send challenge data to AI

The safest approach is simple: do not use AI at all during the event. Build a strong local workstation instead.

## System architecture

Best practical setup:

1. Host OS or primary VM: Ubuntu 24.04 LTS
2. Optional second VM snapshot for risky binaries and weird dependencies
3. Docker for per-challenge libc or service isolation
4. This repository as your searchable local knowledge base and launcher

Why this works:

- fast rollback with snapshots
- no cross-contamination between challenges
- repeatable installs
- clear proof that your workflow stayed local and non-AI

## Baseline packages

These are high-value on Ubuntu and worth installing first:

```bash
sudo apt update
sudo apt install -y \
  tmux fzf ripgrep fd-find jq bat tree unzip p7zip-full \
  build-essential clang cmake ninja-build \
  gdb gdb-multiarch lldb strace ltrace \
  binutils file xxd patchelf qemu-user qemu-user-static \
  tshark binwalk libimage-exiftool-perl pngcheck steghide \
  hashcat john sagemath pari-gp \
  openjdk-21-jdk python3-pip python3-venv pipx
```

Then make sure user-local binaries are on `PATH`:

```bash
python3 -m pip install --user --upgrade pwntools ropper ROPGadget pycryptodome gmpy2 sympy frida-tools
```

## RE stack

Core:

- Ghidra: best free all-around decompiler and static RE workbench
- Cutter or radare2: fast inspection and good for odd binary formats
- IDA Free: optional second opinion when Ghidra output is messy

Strong additions:

- `rr`: record-replay debugging for unstable or timing-sensitive binaries
- `frida-trace`: dynamic instrumentation
- `lief`: binary format scripting
- `UPX`: unpacking
- Detect It Easy: fast packer and signature detection

Preferred workflow:

1. `ctf-kit triage <binary>`
2. `checksec`, `readelf`, `strings`, `ldd`
3. Ghidra for static map
4. gdb or rr for runtime behavior
5. angr or z3 only when manual reasoning has identified the right target condition

## Pwn stack

Core:

- gdb plus pwndbg or GEF: pick one, not both
- pwntools: exploit skeletons, socket helpers, packing, ELF parsing
- checksec
- patchelf
- pwninit
- ropper or ROPgadget
- qemu-user and gdb-multiarch for non-x86 targets

High-leverage extras:

- one_gadget for libc shortcut exploration
- libc-database or equivalent local lookup tool
- Docker for target-matching libc and ld.so setups

Install notes:

- pwndbg is usually best installed from its upstream repo so it tracks current gdb and Python
- pwninit is easiest from its release binary

## Crypto stack

Core:

- SageMath: the heaviest non-AI lift for real CTF crypto
- `pycryptodome`, `gmpy2`, `sympy`
- `pari-gp`
- `openssl`

Useful when the challenge expects cracking:

- `hashcat`
- `john`

Best workflow:

1. write the algebra or attack logic down in your notes
2. prototype in Python
3. move to Sage when modular arithmetic, lattices, or finite fields get annoying
4. keep `solve.py` and `solve.sage` together so the reasoning stays reproducible

## Forensics stack

Core:

- Wireshark and tshark
- binwalk
- exiftool
- pngcheck
- steghide
- stegseek
- strings and xxd

When the challenge family needs it:

- Volatility 3 for memory images
- Sleuth Kit and Autopsy for disk images

## Web stack

Core:

- Burp Suite Community or OWASP ZAP
- `ffuf`
- `httpx`
- `sqlmap`
- `curl`
- `jq`

Useful additions:

- `feroxbuster` for recursive content discovery
- browser devtools
- a small local wordlist set such as `SecLists`

Preferred workflow:

1. browse manually through Burp or ZAP
2. replay interesting requests in Repeater
3. verify one signal before automating
4. use `ffuf` or `feroxbuster` for path, vhost, or parameter fuzzing
5. use `httpx` to quickly fingerprint hosts or discovered routes
6. use `sqlmap` only after you have a reproducible candidate request

Install notes:

- Burp and ZAP are usually easiest from their official installers or distro packages
- `ffuf`, `httpx`, `sqlmap`, and `feroxbuster` should all be on `PATH` if you want `ctf-kit doctor web` to report them cleanly

## Offline docs and "AI-feeling" tools that are still safe

These give you a lot of speed without crossing into AI:

- `rg` plus `fzf` over your own notes, templates, and writeups
- Zeal for offline API and language docs
- `tldr` pages for fast command reminders
- `man`, `apropos`, and `info`
- tmux layouts and reusable exploit or Sage templates
- symbolic execution and theorem solving tools such as angr and z3

This repo already gives you a local launcher for the first three ideas.

## Compliance guardrails

Do this before the event:

1. disable or uninstall Copilot, CodeWhisperer, Tabnine, Claude extensions, browser AI helpers, shell AI wrappers, and editor chat plugins
2. use a separate browser profile with no AI extensions
3. keep notes in challenge folders so you can explain your reasoning if asked
4. never send flags, challenge prompts, binaries, pcaps, scripts, datasets, or extracted outputs to any AI

You can also run:

```bash
ctf-kit policy-check --strict
```

This is only a local guardrail, not proof of compliance, but it catches obvious drift such as AI API keys, CLIs, and editor extensions.

## Suggested install order

1. Run `ctf-kit doctor`.
2. Install the missing baseline tools.
3. Install your main category stack:
   - pwn-heavy: pwndbg or GEF, pwntools, pwninit, qemu-user
   - rev-heavy: Ghidra, Cutter or radare2, rr, frida-tools
   - crypto-heavy: SageMath, pycryptodome, gmpy2, sympy, pari-gp
   - web-heavy: Burp or ZAP, ffuf, httpx, sqlmap
4. Add forensics tooling after the core stack is stable.
5. Practice two or three small challenges with this repo until the workflows feel automatic.

## Extending this repo

- add your own notes under `knowledge/`
- add starter files under `templates/`
- keep the tool manifest in `config/tool_manifest.tsv` current
- use `ctf-kit ask --any <keywords>` instead of web searches when the answer is already in your local corpus
