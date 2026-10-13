---
created: 2026-10-13
tags:
  - note
  - journal
  - cyberStuff
title: Towel on the Sunbed
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-13T08:15:18.626Z
---
link:https://tryhackme.com/room/hh-towelonthesunbed-61271709\
description :

```
🛎️ Concierge Briefing

Ponzi found the resort's wellness portal running a little side project called _Ponzi_ — a crypto rewards app, poolside edition. He set his towel down, claimed his daily reward, and went to reapply sunscreen. He came back to find the sunbed had been "claimed" three times over while he wasn't looking.

He's convinced the app owes him a spot in the Whale Vault. The app disagrees, politely, once every 24 hours. Somewhere between his request and the server's clock, there's a gap wide enough to walk a whale through.
```

first scan

```bash
┌──(k㉿kali)-[~/Desktop]
└─ nmap -sC -sN -Pn $IP
Starting Nmap 7.99 ( https://nmap.org ) at 2026-10-13 03:09 -0400
Stats: 0:00:01 elapsed; 0 hosts completed (1 up), 1 undergoing NULL Scan
NULL Scan Timing: About 14.15% done; ETC: 03:09 (0:00:06 remaining)
Nmap scan report for 10.114.191.214
Host is up (0.034s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE         SERVICE
22/tcp   open|filtered ssh
| ssh-hostkey:
|   256 a6:54:56:6a:25:71:f2:b3:49:aa:d0:fa:7e:87:be:97 (ECDSA)
|_  256 10:65:11:89:58:e7:68:bc:70:4b:8f:35:5a:7c:86:64 (ED25519)
3000/tcp open|filtered ppp

Nmap done: 1 IP address (1 host up) scanned in 3.62 seconds
```

nothing interesting, except the fact that our connection point is running ppp filtered\
ppp\
Point-to-Point Protocol (PPP) is a data link layer protocol that establishes a direct connection between two nodes. It's commonly used for connecting a computer to the internet via a modem, DSL, or other connection. PPP provides a standard way to encapsulate network layer protocols (like IP) over serial lines or other point-to-point links. PPP handles authentication, encryption (though not always enabled by default), and compression. It uses the Link Control Protocol (LCP) to establish, configure, and test the data-link connection. LCP negotiates options like authentication protocols (PAP, CHAP, EAP), compression algorithms (Deflate, Predictor), and Multilink PPP (MLPPP) for aggregating multiple physical links into a single logical link. Network Control Protocols (NCPs) such as IPCP (IP Control Protocol) are then used to configure network layer settings like IP addresses.

after creating a account we can claim a reward, the reward is then blocked for 24 hours\
![](/images/blog-ul-meu/static/Pasted%20image%2020261013031604.png)\
so how can we bypass this ? lets open burpsuite and take a look at the requests\
go to the proxy tab -> set intercept on\
![](/images/blog-ul-meu/static/Pasted%20image%2020261013040528.png)\
after that , in a new account , press the "claim" button\
![](/images/blog-ul-meu/static/Pasted%20image%2020261013040600.png)\
we will intercept the "claim" request ,after that click `CTRL + R ` to send the request to the repeater , repeat `CTRL + R ` 4 times\
-> press drop the request in proxy tab , and turn off the interceptor\
-> go to the repeater tab , and we will see all out requests\
![](/images/blog-ul-meu/static/Pasted%20image%2020261013040942.png)click on the down arrow, and select "Send group in parallel (last-byte sync)" , this will send all our request in the same time.\
check the web server and we got the flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261013035326.png)
