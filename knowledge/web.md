# Web playbook

## First five minutes

```bash
curl -i http://target/
curl -skI https://target/
curl -s http://target/robots.txt
curl -s http://target/sitemap.xml
ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://target/FUZZ -mc all -fs 0
```

## Fast classification

- reflected input or obvious template breakage: XSS or SSTI angle
- numeric object IDs or UUID swaps: IDOR or broken access control
- JWT, session cookies, or exposed client storage: auth and state handling angle
- hidden paths, backup files, or API routes: content discovery angle
- suspicious parameter names, stack traces, or SQL errors: injection angle

## Burp-first workflow

1. browse through Burp or ZAP
2. send interesting requests to Repeater
3. verify one input point at a time
4. only automate after you know what the response signal is

## Fast test ladder

- method changes: `GET`, `POST`, `PUT`, `OPTIONS`
- header changes: `Host`, `X-Forwarded-For`, `Origin`, `Referer`, `Authorization`
- parameter changes: missing, duplicated, array form, JSON form, null, empty, large integer
- path changes: `../`, double slashes, alternate extensions, backup suffixes
- auth changes: remove cookie, replay another user's object ID, swap JWT claims locally

## Useful commands

```bash
curl -i http://target/path
curl -s http://target/api | jq .
ffuf -w wordlist.txt -u http://target/FUZZ -fc 404
ffuf -w wordlist.txt:FUZZ -u http://target/ -H 'Host: FUZZ.target'
sqlmap -u 'http://target/item?id=1' --batch
httpx -u http://target -title -tech-detect -status-code
```

## Common fast wins

- predictable object IDs with no auth recheck
- hidden admin or backup endpoints
- debug or source disclosure files
- JWT `alg` or claim trust issues
- server-side template injection in search or email preview flows
- upload validation that only checks extension or client-side state

## Common time sinks

- running full scanners before you have one promising request
- fuzzing every path when one parameter already reflects unsafely
- assuming XSS when the real issue is IDOR or template evaluation
- skipping authorization tests because login is "too simple"

## References worth trusting

- Burp docs: https://portswigger.net/burp/documentation
- Burp tools index: https://portswigger.net/burp/documentation/desktop/tools
- OWASP WSTG: https://owasp.org/www-project-web-security-testing-guide/
- ZAP getting started: https://www.zaproxy.org/docs/desktop/start/
- sqlmap usage: https://github.com/sqlmapproject/sqlmap/wiki/Usage
- ffuf repo: https://github.com/ffuf/ffuf
- httpx repo: https://github.com/projectdiscovery/httpx
