---
created: 2026-03-02
tags:
  - note
  - journal
  - cyber
  - cyberStuff
title: Evil-GPT
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:27:54.966Z
---
So this is the first CTF I am going to post.

Description:\
![](https://share.note.sx/files/gc/gcrqcw7n0vgbzkj1aik7.png)

When we connect with netcat, we get the following prompt:\
![](https://share.note.sx/files/68/68qnlx0susg9b3d52r2b.png)\
I tried to enter some commands, but it doesn't respond to anything except exit, for the moment.

I entered "flag " and got the following output:\
![](https://share.note.sx/files/15/15va3qtq0gobxfir3w83.png)

OK, I don't know why, but when I typed ls again, I got the following:\
![](https://share.note.sx/files/6q/6qwgjkjmlm6infuek9vr.png)

In the listing there is an interesting Python script named evilai.py; I am going to try to execute it.

![](https://share.note.sx/files/97/97p5eb4h2p4iosf2xjde.png)\
When I ran this script, we got the following error message, which looks kinda weird; let's look inside:

![](https://share.note.sx/files/j6/j6p76vfhbqhxqwy4pw4e.png)\
As we can see, they won't let us cat it. Also, it translates our command into something else; let's check if it is an alias.

We get the following when we try to find an alias:\
![](https://share.note.sx/files/3s/3s1f0z9pktmpdavcoiem.png)\
I ran the command; nothing good happened.

OK, so after some time of experimenting and googling other alternatives to cat, I succeeded with a double tac:\
![](https://share.note.sx/files/x3/x31dxnp9p95l79dbhxkx.png)\
In .bashrc we got a reference to a bash\_aliases file, which I think is the root of the problem.

We got the following:

![](https://share.note.sx/files/q9/q9nf3da7k64tch6yy8xn.png)

I don't think I will run the command; let's try something else.

![](https://share.note.sx/files/s5/s5qzt617qpnfwdf0w1ds.png)\
This looks better, doesn't it?

Yeah... I didn't write the filename right:

![](https://share.note.sx/files/hw/hwkw9o6cxobnh18gc8nq.png)\
I used double tac on the evil py and got this; I don't know what name it refers to.

We can see that it starts a telnet session with an AI, so maybe if we close telnet it will work.

Yeah, I think I overcomplicated this.

Let's try a simpler way.

So I found a root folder in / and catted the flag from there with double tac, finally:

![](https://share.note.sx/files/qq/qqof0gt146x6bk4i6sqq.png)
