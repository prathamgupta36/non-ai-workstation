# Misc playbook

## When to call it misc

- challenge statement is vague or cross-category
- artifact type and category do not match cleanly
- likely solution is mostly data transformation, format inspection, or archive handling
- there is a strong hint toward one standard utility rather than a full exploit or solver

## First three minutes

```bash
file <artifact>
sha256sum <artifact>
strings -a -n 8 <artifact> | head -n 40
xxd <artifact> | head
binwalk <artifact>
7z l <artifact>
```

## Common patterns

- base64, base32, hex, URL encoding, rot variants
- nested archives or compression layers
- weird headers or mismatched extensions
- JSON, CSV, XML, or protobuf-like structured data
- challenge text hiding the actual tool name

## Fast transformation toolkit

```bash
base64 -d <<< 'SGVsbG8='
python3 - <<'PY'
import base64
print(base64.b64decode('SGVsbG8='))
PY
jq . data.json
openssl enc -d -aes-128-cbc -in in.bin -out out.bin
7z x archive.7z -ooutput
```

## CyberChef-worthy cases

- multi-layer encoding
- bytewise XOR with a short key
- quick timestamp, hash, or binary-to-text conversion
- base64 or hex plus compression or decompression

## Quick sanity checks

- does the extension match the header
- is there trailing data after a normal file terminator
- does the file become obvious after one decode layer
- is the "ciphertext" actually compressed or archived data

## References worth trusting

- CyberChef repo: https://github.com/gchq/CyberChef
- jq home: https://jqlang.org/
- jq manual: https://jqlang.org/manual/dev/
- OpenSSL docs: https://docs.openssl.org/3.4/man1/openssl/
- curl docs: https://curl.se/docs/
