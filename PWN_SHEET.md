# PWN_SHEET

## Triage

```bash
file ./chall
checksec --file=./chall
ldd ./chall
readelf -h ./chall
strings -a -n 8 ./chall | head -n 40
```

## GDB and crash work

```bash
gdb -q ./chall
cyclic 256
cyclic -l <value>
```

## Gadget and binary helpers

```bash
ropper --file ./chall --search "pop rdi; ret"
ROPgadget --binary ./chall | head
objdump -d -M intel ./chall | less
readelf -a ./chall | less
```

## libc and loader

```bash
pwninit
one_gadget ./libc.so.6
patchelf --print-interpreter ./chall
patchelf --print-needed ./chall
```

## Pwntools loop

```bash
python3 solve.py
python3 solve.py GDB
python3 solve.py REMOTE HOST=host PORT=31337
```

## Cross-arch

```bash
qemu-aarch64 -L . ./chall
gdb-multiarch -q ./chall
```

## Fast reminders

- no PIE: try fixed addresses early
- full RELRO: do not plan GOT overwrite first
- NX: think ret2libc, ROP, SROP, ORW
- canary: leak or avoid smashing through it
