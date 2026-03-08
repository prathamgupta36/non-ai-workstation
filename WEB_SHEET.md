# WEB_SHEET

## First requests

```bash
curl -i http://target/
curl -skI https://target/
curl -s http://target/robots.txt
curl -s http://target/sitemap.xml
```

## JSON and APIs

```bash
curl -s http://target/api | jq .
curl -s -X POST http://target/api -H 'Content-Type: application/json' -d '{"id":1}'
```

## Fuzzing

```bash
ffuf -w wordlist.txt -u http://target/FUZZ -fc 404
ffuf -w wordlist.txt:FUZZ -u http://target/ -H 'Host: FUZZ.target' -fc 404
ffuf -w params.txt:FUZZ -u 'http://target/item?FUZZ=1' -fs 0
```

## Probing

```bash
httpx -u http://target -title -tech-detect -status-code
httpx -l hosts.txt -title -tech-detect -status-code
```

## SQLi automation

```bash
sqlmap -u 'http://target/item?id=1' --batch
sqlmap -r request.txt --batch
```

## Burp workflow

```text
Proxy -> Repeater -> Intruder -> Decoder -> Target
```

## Fast reminders

- verify one signal in Repeater before automating
- test auth and object IDs early
- hidden routes and backup files are often faster than deep injection
