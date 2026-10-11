---
created: 2026-09-23
tags:
  - note
  - journal
  - cyberStuff
title: Phantom Fob
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:26:39.799Z
---
THM free room.

Recon:\
![](/images/static/Pasted%20image%2020260923060832.png)\
Nothing interesting; port 29536 is the actual one plugged into the car, while 8080 is just the web interface:\
![](/images/static/Pasted%20image%2020260923060909.png)\
The website shows a lot of interesting information. The description told us that we need to somehow unlock the car; my best guess is that we need to craft a curl request using lock->off.
