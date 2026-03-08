# REV_SHEET

## Triage

```bash
file ./chall
sha256sum ./chall
strings -a -n 8 ./chall | head -n 40
readelf -h ./chall
readelf -s ./chall | head -n 40
rabin2 -I ./chall
```

## Static

```bash
ghidraRun
r2 -A ./chall
objdump -d -M intel ./chall | less
```

## Dynamic

```bash
gdb -q ./chall
rr record ./chall
rr replay
frida-trace -i "open*" -i "read*" ./chall
```

## Quick searches

```bash
rabin2 -zz ./chall | head -n 40
rabin2 -i ./chall
strings -a ./chall | rg 'flag|pass|key|correct|wrong'
```

## Solver pivot

```bash
python3
```

- use z3 when the check is easier to model than to read
- use angr when the path condition is isolated and symbolic input is clean
