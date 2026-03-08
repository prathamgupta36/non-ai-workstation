# GENERAL_SHEET

## Start every challenge

```bash
cd /path/to/non-ai-workstation
export PATH="$PWD/bin:$HOME/.local/bin:$PATH"
ctf-kit doctor
ctf-kit policy-check --strict
ctf-kit start [--category <name>] <artifact>
ctf-kit ask --any <keywords>
ctf-kit cheat <topic>
```

## Core triage

```bash
file <target>
sha256sum <target>
strings -a -n 8 <target> | head -n 40
xxd <target> | head
binwalk <target>
```

## Search and extraction

```bash
rg -n "flag|ctf|admin|password|TODO" .
find . -maxdepth 2 -type f | sort
7z l <archive>
7z x <archive> -ooutput
```

## Network and HTTP

```bash
curl -i http://target/
curl -skI https://target/
tshark -r capture.pcap -q -z io,phs
```

## JSON and text

```bash
jq . file.json
python3 -m json.tool < file.json
base64 -d <<< 'SGVsbG8='
```

## Category sheets

- [PWN_SHEET.md](PWN_SHEET.md)
- [REV_SHEET.md](REV_SHEET.md)
- [CRYPTO_SHEET.md](CRYPTO_SHEET.md)
- [FORENSICS_SHEET.md](FORENSICS_SHEET.md)
- [WEB_SHEET.md](WEB_SHEET.md)
- [MISC_SHEET.md](MISC_SHEET.md)
