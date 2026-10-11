---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: infinity shell
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:28:32.502Z
---
Description:\
![](https://share.note.sx/files/ta/ta792pnk6xnx58ymbjk6.png)\
At first examination of the machine, I didn't find anything special:\
![](https://share.note.sx/files/0o/0oj96uciq1wmm34zpkau.jpg)

I decided to investigate /var/log for any logs from the web app:\
![](https://share.note.sx/files/j9/j925dgp7698k1zt8cfjt.png)

I examined every file from the logs in apache2, and the only two that showed something interesting were error.log.1 and especially other\_vhost\_access.log.1.

Whoop, something interesting:\
![](https://share.note.sx/files/nf/nfevnkucovfk0mhd0300.jpg)

Nah, nothing good:\
![](https://share.note.sx/files/73/73fmw7fhdz9vy9zfylbi.png)

Some interesting query here:\
![](https://share.note.sx/files/xs/xs0x20nj9h6isd8cmn9a.png)\
Let's decode them; I think it's Base64:\
![](https://share.note.sx/files/1m/1mt8hniytzgn8nfdtgdc.png)\
OK, that is nice.

And the big one:\
![](https://share.note.sx/files/6e/6e4acwnm785nwoyghss0.png)

And this one was the flag, hurray!
