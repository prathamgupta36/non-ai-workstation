# CRYPTO_SHEET

## Python and Sage entry points

```bash
python3 -q
sage
sage -python
python3 solve.py
sage solve.sage
```

## Integer and byte conversions

```python
from Crypto.Util.number import *
bytes_to_long(b"test")
long_to_bytes(1952805748)
```

## Fast RSA checks

```python
from math import gcd
gcd(n1, n2)
pow(c, d, n)
```

## Sage primitives

```python
gcd(a, b)
inverse_mod(a, n)
crt([a1, a2], [m1, m2])
matrix(GF(p), rows)
```

## Hashing and cracking

```bash
hashcat --help
john --list=formats
zip2john file.zip > hash.txt
john hash.txt
```

## OpenSSL helpers

```bash
openssl enc -d -aes-128-cbc -in in.bin -out out.bin
openssl dgst -sha256 file.bin
openssl asn1parse -in cert.der -inform DER
```

## Fast reminders

- normalize representation before doing math
- validate on toy values first
- check gcd across every RSA modulus you have
- repeated keystream or nonce reuse beats fancy math
