# Common workflow

## Default loop

1. import the artifact with `ctf-kit start [--category <name>] <artifact>`
2. keep untouched originals in `artifacts/`
3. review `output/triage.txt` and write confirmed facts into `README.md`
4. use `ctf-kit cheat <topic>` and `ctf-kit ask --any <keywords>` before opening heavyweight tools
5. use category-native tools only after the first classification pass

## Fast triage matrix

- ELF or PE: `file`, `checksec`, `strings`, `readelf`, Ghidra, gdb, `rr`
- archive or firmware blob: `file`, `7z l`, `binwalk`, `strings`
- image or media: `file`, `exiftool`, `pngcheck`, `zsteg`, `strings`
- pcap: `capinfos`, `tshark -r`, Wireshark
- text, script, config, JSON: `file`, `sed`, `jq`, `rg`
- PDF or office-like artifact: `pdfinfo`, `pdftotext`, `strings`

## Search order

Use the cheapest source of truth first:

1. `ctf-kit ask --any <keywords>`
2. `ctf-kit cheat <topic>`
3. local tool help: `man`, `--help`, `apropos`, `tldr`
4. official references in `docs/references.md`
5. heavyweight analysis tools

## Time discipline

- if ten minutes pass with no new fact, pivot or reframe
- if you have a leak, primitive, or algebraic model, stay longer
- stop polishing once the flag path is clear; stabilize and submit
- keep one running "next action" line in `README.md`

## Notes discipline

Write facts, not vibes:

- exact file type, hashes, protections, and sizes
- exact addresses, offsets, keys, moduli, or protocol fields
- exact commands that moved the solve forward
- what you tried that failed, only if it rules out a branch

## Terminal shortcuts worth memorizing

```bash
rg -n "keyword" knowledge templates docs
find . -maxdepth 2 -type f | sort
file <target>
strings -a -n 8 <target> | head -n 40
xxd <target> | head
sha256sum <target>
```

## Safe non-AI automation

These do heavy lifting without violating your contest boundary:

- pwntools for process and remote interaction
- gdb scripting and `rr` replay
- Frida for dynamic tracing
- angr and z3 for path constraints
- SageMath for algebra, finite fields, and lattices
- `tshark`, `binwalk`, `zsteg`, and `vol` for artifact extraction

## Reference anchors

- official tool references live in `docs/references.md`
- live event tactics live in `knowledge/live.md`
- category playbooks live in `knowledge/pwn.md`, `knowledge/rev.md`, `knowledge/crypto.md`, and `knowledge/forensics.md`
