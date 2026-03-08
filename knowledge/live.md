# 2-hour live CTF playbook

## 00-10 minutes: board sweep

- open every challenge and classify it before going deep
- look for obvious one-command wins: stego metadata, simple base64, no-PIE ret2win, fixed-string compare, leaked file path
- write one line per challenge: category, artifact type, likely time, first tool

## 10-35 minutes: take the freebies

- solve the challenges with the shortest path to a confirmed primitive
- avoid "interesting" rabbit holes if another challenge already has a leak, a direct compare, or a simple algebraic model
- submit quickly once the result is validated

## 35-80 minutes: commit to two real targets

- keep one primary target and one backup
- stay on a target only if each ten-minute slice produces a new fact
- if not, park it cleanly and move on

## 80-105 minutes: salvage points

- revisit partial solves with fresh eyes
- switch from elegant to practical
- if a patch, instrumentation trace, or direct algebraic solve works, use it

## 105-120 minutes: stabilize and submit

- re-run solves from clean artifacts when possible
- verify exact flag formatting
- avoid fat-finger losses at the end

## Solo rules that matter

- one rabbit hole at a time
- one running "next action" in the notes
- one stop condition per challenge
- if you cannot say what evidence would prove your hypothesis, your hypothesis is weak

## Fast win signals

- pwn: no PIE, obvious win function, printable leak, format string markers
- rev: `strcmp` or `memcmp`, plaintext success strings, tiny parser, single transform loop
- crypto: repeated XOR hints, shared moduli, small exponent, nonce reuse, obvious PRNG source
- forensics: metadata anomalies, embedded archives, protocol hierarchy dominated by one service, filenames hiding in strings
- web: request parameter reflected cleanly, obvious IDOR, JWT or session misconfiguration, hidden path or vhost found fast
- misc: simple encoding stack, archive nesting, weird file header, challenge text hinting at one standard tool

## Fast loss signals

- complex heap bug with no leak and no libc
- packed or virtualized binary with no runtime foothold
- crypto that smells like lattices but gives no structure
- huge pcap with no protocol summary and no lead

## Search discipline

When stuck, do this in order:

1. `ctf-kit ask --any <keywords>`
2. `ctf-kit cheat <topic>`
3. `docs/references.md`
4. a heavyweight tool or debugger

## Good habits under pressure

- always keep untouched originals in `artifacts/`
- store every useful dump, extracted file, or patched artifact in `output/`
- put addresses, offsets, hashes, and keys in the notes immediately
- prefer a crude working solve over a beautiful unfinished one
