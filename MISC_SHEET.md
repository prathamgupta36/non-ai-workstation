# MISC_SHEET

## Encoding and text

```bash
base64 -d <<< 'SGVsbG8='
python3 - <<'PY'
import base64
print(base64.b64decode('SGVsbG8='))
PY
```

## Binary inspection

```bash
file <artifact>
xxd <artifact> | head
strings -a -n 8 <artifact> | head -n 40
binwalk <artifact>
```

## Archives

```bash
7z l archive
7z x archive -ooutput
unzip -l archive.zip
tar -tf archive.tar
```

## JSON and structured data

```bash
jq . file.json
python3 -m json.tool < file.json
```

## OpenSSL quick use

```bash
openssl dgst -sha256 file.bin
openssl enc -d -aes-128-cbc -in in.bin -out out.bin
openssl asn1parse -in file.der -inform DER
```

## Fast reminders

- decode one layer at a time
- mismatched extension is a clue
- nested archive plus one weird text file is a common easy solve
