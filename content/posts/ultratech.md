---
title: ultratech
draft: false
date:
subiect:
dificultate: 3
amuca: false
link:
tags:
  - cyberStuff
lastmod: 2026-03-03T19:56:51.253Z
categories: ["writeups"]
---
scaning:\
this nmap scan gives us all we need for the first page ![](/images/blog-ul-meu/static/Pasted%20image%2020260303084750.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303084834.png)

so the first page is done .\
i also runned a feq gobuster scans and found a few interesting domains ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303144740.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303144808.png)\
one of them being /js which quiet interesting  , and inside it the api.js file , what grabbed my attention was ping line\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303094618.png)

robots.txt gives a map\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303091608.png)

trying some parameter checking here\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303092052.png)

here i just tried a few random things like acces that note.js port and using the ping ip parameter we saw in that file earlier i was eable to get RCE\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303095427.png)\
i tried to do some reverse shell script but it didnt worked\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303102305.png)\
so i just lister the password file\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303103444.png)\
inside it i found 2 passwords hasheh and both of them where on crackstatio

```
���(Mr00tf357a0c52799563c7c7b76c1e7543a32)Madmin0d0ea5111e3c1def594c1684e3b9be84: Name or service not known
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260303103535.png)\
mrsheafy\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303104008.png)\
n100906\
then i just ssh with the first username and pass\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303105519.png)\
inside i tried to list some SUID or sudo but didnt find anything interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303105512.png)\
but when i id i saw a have some docker permisions on , ok that cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303105912.png)\
so i search on GTFO.bins a priv esec using docker and found this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303110133.png)\
run it and boom root acces , room done\
![](blog-ul-meu/static/Pasted%20image%2020260303110124.png)\
just cat the ssh as in the question\
![](/images/blog-ul-meu/static/Pasted%20image%2020260303110159.png)
