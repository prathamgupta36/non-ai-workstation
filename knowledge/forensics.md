# Forensics playbook

## Quick triage

```bash
file <artifact>
sha256sum <artifact>
exiftool <artifact>
strings -a -n 8 <artifact> | head -n 40
binwalk <artifact>
```

## Images and media

- read metadata first with `exiftool`
- inspect structure with `pngcheck` if it is PNG
- try `zsteg` on PNG and BMP files
- try `steghide` or `stegseek` if a passphrase is implied
- search for trailing data with `binwalk` and `xxd`

## Archives, docs, and mixed artifacts

- `7z l` or `zipinfo -1` before extracting
- `pdfinfo` and `pdftotext` for PDFs
- `strings` and `binwalk` when the file type looks wrong for the extension
- keep extracted files under `output/`, never overwrite originals

## PCAP fast path

- `capinfos capture.pcap`
- `tshark -r capture.pcap -q -z io,phs`
- identify protocols before packet-by-packet reading
- extract fields with `tshark -T fields` when you know what to look for
- export objects when HTTP, SMB, or FTP appear

Useful patterns:

- odd DNS subdomains or TXT records
- ICMP payloads
- HTTP bodies containing base64 or compressed blobs
- TLS plus obvious client mistakes elsewhere in the flow

## Memory fast path

- start with `vol -h` and identify the target OS
- for Windows, `windows.info`, `windows.pslist`, `windows.pstree`, and `windows.netscan` are usually the first four passes
- dump files or processes only after you know what you are chasing
- preserve hashes and record every extraction step

## Common blind spots

- assuming the file extension is truthful
- opening packets manually before checking protocol hierarchy
- skipping metadata because the artifact "looks normal"
- extracting recursively without noting what came from where

## References worth trusting

- Wireshark user's guide: https://www.wireshark.org/docs/wsug_html/
- Wireshark man pages: https://www.wireshark.org/docs/man-pages/
- `tshark` manual: https://www.wireshark.org/docs/man-pages/tshark.html
- ExifTool home: https://exiftool.org/index.html
- ExifTool install and usage notes: https://exiftool.org/install.html
- Binwalk project: https://github.com/ReFirmLabs/binwalk
- Volatility Foundation home: https://volatilityfoundation.org/
- Volatility 3 parity release notes: https://volatilityfoundation.org/announcing-the-official-parity-release-of-volatility-3/
