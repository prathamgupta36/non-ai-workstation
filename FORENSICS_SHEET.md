# FORENSICS_SHEET

## Triage

```bash
file <artifact>
sha256sum <artifact>
exiftool <artifact>
strings -a -n 8 <artifact> | head -n 40
binwalk <artifact>
```

## Images and files

```bash
pngcheck -v file.png
zsteg file.png
steghide info file.jpg
stegseek file.jpg
```

## Archives and docs

```bash
7z l archive.7z
7z x archive.7z -ooutput
pdfinfo file.pdf
pdftotext file.pdf -
```

## PCAP

```bash
capinfos capture.pcap
tshark -r capture.pcap -q -z io,phs
tshark -r capture.pcap -T fields -e ip.src -e ip.dst | head
wireshark capture.pcap
```

## Memory

```bash
vol -h
vol -f mem.raw windows.info
vol -f mem.raw windows.pslist
vol -f mem.raw windows.netscan
```

## Fast reminders

- trust headers, not extensions
- check metadata before deep extraction
- identify protocols before reading packets one by one
- keep originals untouched
