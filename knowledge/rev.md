# Rev playbook

## First five minutes

```bash
file ./chall
sha256sum ./chall
strings -a -n 8 ./chall | head -n 40
readelf -h ./chall
readelf -s ./chall | head -n 40
rabin2 -I ./chall
```

## Initial classification

- fixed string compare or obvious success text: likely patchable or directly invertible
- many bitwise ops and loops around user input: custom transform
- giant dispatcher or jump table: VM or bytecode interpreter
- weird sections, packed imports, high entropy: packer or self-unpacker
- network, file, or crypto APIs: instrument runtime behavior early

## Static workflow

1. inspect strings, symbols, imports, and sections
2. decide whether the target is packed, stripped, or self-modifying
3. load into Ghidra
4. rename functions, arguments, globals, and structures aggressively
5. isolate the flag check, parser, decoder, checksum, or VM loop

## Ghidra habits that save time

From the official student guide, the high-value habits are:

- keep reference, data, and function analyzers on for the first pass
- on large binaries, disable speculative extras first and rerun one-shot analyzers later
- use Defined Strings, Function Graph, and Call Trees early
- rerun one-shot analyzers such as Decompiler Parameter ID, Switch Analysis, and Stack when decompilation looks wrong
- use Script Manager when analysis misses functions or flow edges

## Dynamic workflow

- break on input handlers, parsers, compares, and success or failure prints
- log transformed buffers instead of staring at decompiler output forever
- patch only after you understand what the patch buys you
- use `rr` when the program is annoying to restart
- use `frida-trace` for imported APIs, filesystem access, and crypto entry points
- use angr or z3 only after you have isolated the exact path constraint

## Useful command bundle

```bash
objdump -d -M intel ./chall | less
gdb -q ./chall
rr record ./chall
rr replay
frida-trace -i "open*" -i "read*" ./chall
```

## Common indicators

- `memcmp`, `strcmp`, `strncmp`: direct compare path
- `read`, `recv`, `fgets`, `scanf`: input choke points
- `open`, `stat`, `access`: hidden file dependency or alternate path
- many rotates, xors, and table lookups: keyed transform or simple cipher
- syscalls with few imports: hand-rolled or static binary

## Escalation rules

- if you can model the condition faster than you can read the decompiler, switch to z3
- if the binary is path-heavy but deterministic, switch to angr
- if the program's behavior is time-sensitive or randomized, switch to `rr`

## References worth trusting

- Ghidra student guide: https://ghidra.re/ghidra_docs/GhidraClass/Beginner/Introduction_to_Ghidra_Student_Guide.html
- Frida tracing docs: https://frida.re/docs/frida-trace/
- angr docs: https://docs.angr.io/en/latest/
- Z3 guide: https://microsoft.github.io/z3guide/
- rr project docs: https://rr-project.org/
- pwn.college reverse engineering: https://pwn.college/program-security/reverse-engineering
