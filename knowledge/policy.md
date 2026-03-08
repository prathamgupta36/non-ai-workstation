# Policy summary

This is a local house policy for non-AI challenge work and hands-on security practice.

Allowed:

- definitions and concept explanations
- Linux command reminders
- programming syntax and documentation lookup
- general cybersecurity theory

Not allowed:

- asking AI to solve a challenge
- sending challenge descriptions, files, binaries, flags, prompts, datasets, or outputs to AI
- AI-generated exploit code aimed at a specific challenge
- AI analysis of binaries, scripts, or data to derive the answer
- AI agents, autonomous workflows, prompt pipelines, or scripts that forward challenge data to AI

If a workflow feels ambiguous, treat it as forbidden.

A clean compliance story looks like this:

1. all challenge work stays local
2. notes explain the solve path
3. scripts are deterministic and non-AI
4. tooling is standard RE, pwn, crypto, forensics, search, or math automation

Useful local checks:

- `ctf-kit policy-check --strict`
- `ctf-kit doctor`
