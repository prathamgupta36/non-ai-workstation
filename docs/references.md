# Credible References For Live CTF Use

This file exists to answer one question quickly: "if the local notes are not enough, which sources are worth opening without wasting time?"

Selection rules:

- official docs from the tool or project maintainers
- official course material from established training platforms
- resources that help solve fast, not just teach slowly

## Pwn

- Pwntools docs: https://docs.pwntools.com/en/stable/
  Why it earns a slot: the fastest authoritative reference for tubes, ELF parsing, ROP helpers, GDB helpers, format-string helpers, and shellcraft.
- Pwntools GDB helpers: https://docs.pwntools.com/en/stable/gdb.html
  Why it earns a slot: shortens the exploit-debug-fix loop.
- Pwntools ROP docs: https://docs.pwntools.com/en/stable/rop/rop.html
  Why it earns a slot: fastest official reminder for gadget discovery and chain construction.
- Pwndbg docs: https://pwndbg.re/stable/
  Why it earns a slot: command reference for the debugger view you are already using.
- Pwndbg command index: https://pwndbg.re/pwndbg/dev/commands/
  Why it earns a slot: fast lookup when you forget the exact command name.
- pwn.college Program Security: https://pwn.college/program-security/
  Why it earns a slot: reliable exploit-development training material with challenge-oriented framing.
- pwn.college ROP module: https://pwn.college/program-security/return-oriented-programming
  Why it earns a slot: high-value refresher for ROP patterns under time pressure.

## Reversing

- Ghidra student guide: https://ghidra.re/ghidra_docs/GhidraClass/Beginner/Introduction_to_Ghidra_Student_Guide.html
  Why it earns a slot: official workflow guidance for analysis, decompiler repair, graphs, strings, and scripts.
- Frida tracing docs: https://frida.re/docs/frida-trace/
  Why it earns a slot: quickest authoritative reminder for tracing imported or runtime-resolved functions.
- angr docs: https://docs.angr.io/en/latest/
  Why it earns a slot: best official guide for symbolic execution and simulation manager behavior.
- rr docs: https://rr-project.org/
  Why it earns a slot: fastest way to remember record/replay and reverse execution workflows.
- Z3 guide: https://microsoft.github.io/z3guide/
  Why it earns a slot: practical solver reference when the reversing task becomes a constraint problem.
- pwn.college Reverse Engineering: https://pwn.college/program-security/reverse-engineering
  Why it earns a slot: challenge-oriented reversing practice and lecture material.

## Crypto

- Sage tutorial: https://doc.sagemath.org/html/en/tutorial/index.html
  Why it earns a slot: official reference for the math environment most useful in CTF crypto.
- Z3 guide: https://microsoft.github.io/z3guide/
  Why it earns a slot: useful when arithmetic or bit-vector conditions are easier to model than derive by hand.
- CryptoHack: https://cryptohack.org/
  Why it earns a slot: best-known official training platform focused on practical cryptography puzzles.
- CryptoHack public-key course: https://cryptohack.org/courses/public-key/
  Why it earns a slot: strong refresher for RSA and Diffie-Hellman failure patterns.
- CryptoHack elliptic curves course: https://cryptohack.org/courses/elliptic/
  Why it earns a slot: focused ECC refresher without blog-spam noise.
- hashcat wiki: https://hashcat.net/wiki/doku.php?id=hashcat
  Why it earns a slot: authoritative option and mode reference.
- hashcat example hashes: https://hashcat.net/wiki/doku.php?id=example_hashes
  Why it earns a slot: the quickest way to map a hash format to a mode.
- John docs: https://www.openwall.com/john/doc/
  Why it earns a slot: authoritative usage and mode overview.
- John examples: https://www.openwall.com/john/doc/EXAMPLES.shtml
  Why it earns a slot: quick, practical examples when you forget exact syntax.

## Forensics

- Wireshark user's guide: https://www.wireshark.org/docs/wsug_html/
  Why it earns a slot: official guide for display filters, packet dissection, and export workflows.
- Wireshark man pages: https://www.wireshark.org/docs/man-pages/
  Why it earns a slot: direct command-line references for `tshark`, `capinfos`, `editcap`, and friends.
- `tshark` man page: https://www.wireshark.org/docs/man-pages/tshark.html
  Why it earns a slot: fastest authoritative syntax lookup for CLI packet analysis.
- ExifTool home: https://exiftool.org/index.html
  Why it earns a slot: official usage notes and supported metadata coverage.
- ExifTool install and usage notes: https://exiftool.org/install.html
  Why it earns a slot: answers path and invocation confusion quickly.
- Binwalk project: https://github.com/ReFirmLabs/binwalk
  Why it earns a slot: official project home for signatures, extraction behavior, and current usage.
- Volatility Foundation home: https://volatilityfoundation.org/
  Why it earns a slot: official project source for current framework status and docs links.
- Volatility 3 parity release notes: https://volatilityfoundation.org/announcing-the-official-parity-release-of-volatility-3/
  Why it earns a slot: clear statement of current Volatility 3 capabilities and workflow changes.

## Web

- Burp Suite documentation: https://portswigger.net/burp/documentation
  Why it earns a slot: official reference for the exact Burp workflow and tool behavior.
- Burp Suite tools: https://portswigger.net/burp/documentation/desktop/tools
  Why it earns a slot: quickest official index for Proxy, Repeater, Intruder, Decoder, Inspector, and Target.
- OWASP Web Security Testing Guide: https://owasp.org/www-project-web-security-testing-guide/
  Why it earns a slot: current, structured methodology for testing web applications and APIs.
- OWASP WSTG latest: https://owasp.org/www-project-web-security-testing-guide/latest/1-Frontispiece/
  Why it earns a slot: always-current release track for specific web test categories.
- ZAP getting started: https://www.zaproxy.org/docs/desktop/start/
  Why it earns a slot: official starting point for using ZAP as a proxy and quick scanner.
- sqlmap usage: https://github.com/sqlmapproject/sqlmap/wiki/Usage
  Why it earns a slot: authoritative command reference for HTTP request handling and SQLi extraction options.
- ffuf repository: https://github.com/ffuf/ffuf
  Why it earns a slot: official docs and examples for directory, parameter, vhost, and recursion fuzzing.
- ffuf wiki: https://github.com/ffuf/ffuf/wiki
  Why it earns a slot: practical examples and usage patterns straight from the project.
- httpx repository: https://github.com/projectdiscovery/httpx
  Why it earns a slot: authoritative reference for quick HTTP probing and filtering.
- curl docs: https://curl.se/docs/
  Why it earns a slot: best source for exact request syntax when reproducing or trimming requests.

## Misc

- CyberChef repository: https://github.com/gchq/CyberChef
  Why it earns a slot: official reference for one of the fastest non-AI data transformation tools in CTF.
- jq home: https://jqlang.org/
  Why it earns a slot: official jq landing page with links to the tutorial and manual.
- jq manual: https://jqlang.org/manual/dev/
  Why it earns a slot: exact reference for JSON slicing, filtering, and transformation syntax.
- OpenSSL command docs: https://docs.openssl.org/3.4/man1/openssl/
  Why it earns a slot: official command reference for crypto, cert, ASN.1, and binary format tasks.
- curl docs: https://curl.se/docs/
  Why it earns a slot: useful outside web too, especially for downloads, headers, and custom requests.

## How to use this file in a live event

- search locally first with `ctf-kit ask`
- open official docs only for exact syntax, plugin names, file formats, or tool behavior
- use course material for pre-event study or mid-event refreshers, not as a first stop for a syntax question
