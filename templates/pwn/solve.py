#!/usr/bin/env python3
from pwn import *

exe = context.binary = ELF("./artifacts/chall", checksec=False)
context.log_level = "info"
context.terminal = ["tmux", "splitw", "-h"]


def start(argv=None, *a, **kw):
    argv = argv or []
    if args.GDB:
        return gdb.debug([exe.path] + argv, gdbscript=GDBSCRIPT, *a, **kw)
    if args.REMOTE:
        host = args.HOST or "localhost"
        port = int(args.PORT or 31337)
        return remote(host, port, *a, **kw)
    return process([exe.path] + argv, *a, **kw)


GDBSCRIPT = """
tbreak main
continue
"""


def main():
    io = start()

    # Replace this with the actual exploit flow.
    io.interactive()


if __name__ == "__main__":
    main()
