# Crypto playbook

## First questions

- what is known and what is unknown
- what is the data representation: hex, base64, bytes, decimal integers, little-endian limbs
- what algebraic structure is in play: modular arithmetic, XOR, linear algebra, PRNG state, elliptic curve
- is the weakness mathematical, protocol-based, or implementation-based

## Two-minute classification

- repeated short text and key hints: XOR or Vigenere family
- huge integers and `n`, `e`, `c`: RSA family
- point arithmetic or generator notation: ECC or DLP
- outputs that look random but come from code: PRNG recovery
- matrix or recurrence relation: linear algebra over integers or a finite field
- password hashes or archive secrets: hashcat or John, not custom algebra first

## Core stack

- SageMath
- pycryptodome
- gmpy2
- sympy
- pari-gp
- openssl

## Fast attack checklist

### RSA

- run `gcd` across every modulus you have
- check whether `e` is tiny and plaintext may be tiny
- check for shared modulus or related-message structure
- check whether factors look close enough for Fermat
- check whether leaked CRT values or partial key material are present

### XOR and stream ciphers

- normalize to bytes first
- XOR ciphertexts together if keystream reuse is suspected
- look for known plaintext and printable output before building a full solver
- test periodic keys quickly before assuming custom crypto

### PRNG

- identify the generator family from the source or constants
- note what part of state is exposed and how it is truncated
- check whether seeding depends on timestamp, PID, or obvious challenge values

### ECC and DLP

- verify curve parameters and subgroup sizes
- look for reused nonces in signatures
- look for invalid-curve, small-subgroup, or bad parameter choices before attempting discrete logs

### Hash or file cracking

- identify exact format before choosing a mode
- use `hashcat` example hashes or John docs to map the format
- use the correct `*2john` converter for archives and office files

## Workflow

1. restate the challenge as equations or transformations
2. prototype in Python
3. switch to Sage when modular arithmetic, finite fields, or lattices appear
4. validate with tiny toy inputs before throwing big numbers at it
5. keep the final `solve.py` or `solve.sage` reproducible

## Useful one-liners

```bash
python3 -q
sage
sage -python
openssl enc -d -aes-128-cbc -in ciphertext.bin -out plaintext.bin
```

## Handy Sage primitives

```python
gcd(a, b)
inverse_mod(a, n)
crt([a1, a2], [m1, m2])
matrix(GF(p), rows)
```

## References worth trusting

- Sage tutorial: https://doc.sagemath.org/html/en/tutorial/index.html
- Z3 guide: https://microsoft.github.io/z3guide/
- CryptoHack main site: https://cryptohack.org/
- CryptoHack public-key course: https://cryptohack.org/courses/public-key/
- CryptoHack elliptic curves course: https://cryptohack.org/courses/elliptic/
- hashcat wiki: https://hashcat.net/wiki/doku.php?id=hashcat
- hashcat example hashes: https://hashcat.net/wiki/doku.php?id=example_hashes
- John docs: https://www.openwall.com/john/doc/
- John examples: https://www.openwall.com/john/doc/EXAMPLES.shtml
