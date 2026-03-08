# Pwn playbook

## First three minutes

```bash
file ./chall
checksec --file=./chall
ldd ./chall
strings -a -n 8 ./chall | head -n 40
readelf -h ./chall
```

If `checksec` is missing:

```bash
pwn checksec ./chall
```

## Questions to answer immediately

- architecture and bitness
- NX, PIE, RELRO, canary
- static or dynamic linking
- local files provided: `libc.so.6`, `ld-linux`, Dockerfile, source
- bug class: stack, format string, heap, logic, seccomp, race

## Mitigation matrix

- no PIE: use fixed code addresses and `ret2win` or direct ROP first
- PIE: get one code leak before gadget math
- full RELRO: do not waste time planning GOT overwrites
- NX: prefer ret2libc, ROP, SROP, ORW, or one-shot function chains
- no NX: shellcode may be the shortest path
- canary: either leak it or avoid contiguous stack smashing
- seccomp: inspect allowed syscalls and pivot to ORW or a syscall-specific plan

## Fast bug-class cues

- crash plus overwritten return pointer: stack overflow
- user-controlled `printf` or `%` expansion: format string
- allocator menu with `malloc` and `free`: heap
- only read primitive and info leaks: build a base leak plan first
- function pointer, callback table, or vtable style control: arbitrary write target hunt

## Standard toolchain

- gdb plus pwndbg
- pwntools
- patchelf
- pwninit
- ropper or ROPGadget
- qemu-user and gdb-multiarch for non-x86

## Fast local loop

```bash
gdb -q ./chall
cyclic 256
cyclic -l <crash-value>
ropper --file ./chall --search "pop rdi; ret"
one_gadget ./libc.so.6
```

Good debugger checks:

- where input lands on stack or heap
- which comparison gates success
- whether output leaks addresses already
- whether the program forks, alarms, or swaps buffering mode

## Leak workflow

1. identify the cheapest readable pointer: GOT, saved return address, libc pointer, stack pointer, heap pointer, canary
2. compute PIE or libc base
3. re-evaluate the shortest finishing primitive
4. only then script the final exploit

## Remote readiness checklist

- exact `libc` and loader resolved with `pwninit`
- no hard-coded local addresses left in the exploit
- timeout, prompt, and buffering handled in pwntools
- architecture and endianness explicitly set in `context.binary`
- stack alignment checked before `system` or `execve`

## Common failure modes

- local `libc` does not match remote
- PIE base not recovered before gadget math
- stack alignment breaks `system`
- remote prompt parsing is wrong, not the exploit
- `scanf` or `fgets` stops earlier than expected
- seccomp blocks your obvious shell path

## References worth trusting

- pwntools docs: https://docs.pwntools.com/en/stable/
- pwntools GDB helpers: https://docs.pwntools.com/en/stable/gdb.html
- pwntools ROP helpers: https://docs.pwntools.com/en/stable/rop/rop.html
- pwntools tubes and remotes: https://docs.pwntools.com/en/stable/tubes.html
- pwndbg docs: https://pwndbg.re/stable/
- pwndbg command index: https://pwndbg.re/pwndbg/dev/commands/
- pwn.college program security: https://pwn.college/program-security/
- pwn.college ROP module: https://pwn.college/program-security/return-oriented-programming
