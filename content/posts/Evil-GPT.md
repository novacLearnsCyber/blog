---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: Evil-GPT
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:20:57.725Z
---
so this is the first ctf i goona post ,

Desc :\
![](https://share.note.sx/files/gc/gcrqcw7n0vgbzkj1aik7.png)

when we connect with netcat we got the small following promt ![](https://share.note.sx/files/68/68qnlx0susg9b3d52r2b.png)\
i tried to put some command in but it dosent respond to anything except exit , for the moment

i input "flag " and got the following output\
![](https://share.note.sx/files/15/15va3qtq0gobxfir3w83.png)

ok idk why but when i typed again ls i got the following\
![](https://share.note.sx/files/6q/6qwgjkjmlm6infuek9vr.png)

in the listing is a interesting py script name evilai.py , i gonna try to execute it

![](https://share.note.sx/files/97/97p5eb4h2p4iosf2xjde.png)\
when i runt this script , we got the following error message , which look kinda weird , lets look inside

![](https://share.note.sx/files/j6/j6p76vfhbqhxqwy4pw4e.png)\
as we can see , they wont let us cat it , also it transalte our command into something else , lets check if it is a alias

we got he following when we try to find an alias\
![](https://share.note.sx/files/3s/3s1f0z9pktmpdavcoiem.png)\
i runned the commnad , nothing good happend .

ok ok ok soooo , afeter some time of experimenting and google other types of cat i succesded with a double tac ,\
![](https://share.note.sx/files/x3/x31dxnp9p95l79dbhxkx.png)\
in .bashrc we got reference to a bash\_aliases file , which i think its the root of the problems

we got the following

![](https://share.note.sx/files/q9/q9nf3da7k64tch6yy8xn.png)

i dont think i will run the command , lets try something else

![](https://share.note.sx/files/s5/s5qzt617qpnfwdf0w1ds.png)\
this look better dosent it

yeeee. ... i didnet write right the file name

![](https://share.note.sx/files/hw/hwkw9o6cxobnh18gc8nq.png)\
i used the double tac on the evil py and got this , i dont know what name it refers to

we can see that it strat a telnet with an ai , so maybe if we close the telnet it will work

yeah i think i overcomplicated this

lets try a simpler way

so i find a root flder in the / and cat the flag from there with the double tac , finnaly

![](https://share.note.sx/files/qq/qqof0gt146x6bk4i6sqq.png)
