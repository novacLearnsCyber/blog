---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: Evil-GPT v2
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:49:39.861Z
---
Yeah, so this is the continuation of Evil-GPT.\
Description:\
![](https://share.note.sx/files/8f/8f8962doo5lxz37vfv46.png)\
This time we can access the AI through HTTP in the browser, so we know for sure an HTTP port is open:\
![](https://share.note.sx/files/5i/5i5lm0iu441i0qghclig.png)\
Now we can talk to the model like real ChatGPT:\
![](https://share.note.sx/files/z2/z23yv7xtc4i1choh94aa.png)\
Here I tried a trick, with little to no result, as we can see:\
![](https://share.note.sx/files/fe/fe2hbkmjwoodlr47boqs.png)\
so I found the trick. I told the AI to say random stuff and not stop, and eventually it dropped the flag pretty easily. This was actually how the real ChatGPT was attacked some time ago to reveal non-public information:\
![](https://share.note.sx/files/8i/8ircwhzwz87ndibh1gvg.png)
