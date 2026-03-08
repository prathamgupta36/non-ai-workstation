#!/usr/bin/env python3
import base64
from math import gcd

from Crypto.Util.number import bytes_to_long, long_to_bytes


def main():
    # Keep the algebra explicit so the reasoning stays reviewable.
    # Add small sanity checks before throwing large challenge values at a script.
    sample = b"replace-me"
    print(bytes_to_long(sample))
    print(long_to_bytes(bytes_to_long(sample)))
    print(base64.b64encode(sample))
    print(gcd(21, 14))


if __name__ == "__main__":
    main()
