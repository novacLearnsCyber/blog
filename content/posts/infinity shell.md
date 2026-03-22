---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: infinity shell
draft: false
categories:
  - tryhackme
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:25:26.725Z
---
Desc:\
![](https://share.note.sx/files/ta/ta792pnk6xnx58ymbjk6.png)\
at a first examinatijon of the machine i didnt find anything special\
![](https://share.note.sx/files/0o/0oj96uciq1wmm34zpkau.jpg)

i decided to investigate /var/log for any logs from the web app\
![](https://share.note.sx/files/j9/j925dgp7698k1zt8cfjt.png)

i examined every file from the logs in apache2 and the only 2 that show something interesting are error.log.1 and especially other\_vhost\_access.log.1

whopp something interesting\
![](https://share.note.sx/files/nf/nfevnkucovfk0mhd0300.jpg)

nahhh nothing good\
![](https://share.note.sx/files/73/73fmw7fhdz9vy9zfylbi.png)

some interesting query here\
![](https://share.note.sx/files/xs/xs0x20nj9h6isd8cmn9a.png)\
lets decode them , i think is base 64\
![](https://share.note.sx/files/1m/1mt8hniytzgn8nfdtgdc.png)\
ok ok that is nice

and the big one\
![](https://share.note.sx/files/6e/6e4acwnm785nwoyghss0.png)

and this onne was the flagg hurayy
