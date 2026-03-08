# Reversing notes for __CHALLENGE_NAME__

## Triage

- file:
- hashes:
- architecture:
- packer/obfuscation signals:
- imports:
- likely input path:

## Likely interesting locations

- input parsing:
- transforms:
- compares:
- success path:
- file or network access:

## Dynamic checkpoints

- breakpoints:
- watched memory:
- patched branches:
- logged buffers:

## Questions

- what data is being checked
- where does it diverge on success vs failure
- can I model the condition directly with z3 or angr
- can I solve this faster by tracing runtime APIs than by reading decompiler output
