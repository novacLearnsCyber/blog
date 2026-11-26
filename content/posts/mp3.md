---
created: 2026-11-25
tags:
  - note
  - journal
  - thm
  - cyber
  - cyberStuff
title: mp3
date: 2026-11-26T11:03:55.676Z
lastmod: 2026-11-26T11:03:55.676Z
---
link : https://tryhackme.com/room/convertmyvideo\
recon

```bash
┌──(k㉿kali)-[~]
└─ gobuster dir -u 'http://10.112.158.22/' -w /usr/share/wordlists/SecLists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.112.158.22/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/SecLists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.8.2
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
images               (Status: 301) [Size: 315] [--> http://10.112.158.22/images/]
admin                (Status: 401) [Size: 460]
js                   (Status: 301) [Size: 311] [--> http://10.112.158.22/js/]
tmp                  (Status: 301) [Size: 312] [--> http://10.112.158.22/tmp/]
Progress: 43990 / 220558 (19.94%)[ERROR] error on word aer: timeout occurred during the request
server-status        (Status: 403) [Size: 278]
Progress: 189094 / 220557 (85.73%)^C
```

ports opened :

```bash
┌──(k㉿kali)-[~]
└─ nmap 10.113.175.75
Starting Nmap 7.99 ( https://nmap.org ) at 2026-11-26 13:02 +0200
Nmap scan report for 10.113.175.75
Host is up (0.030s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 1.21 seconds

```
