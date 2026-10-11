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
lastmod: 2026-10-09T12:30:40.830Z
---
Scanning:\
This nmap scan gives us all we need for the first page:\
![](/images/static/Pasted%20image%2020260303084750.png)\
![](/images/static/Pasted%20image%2020260303084834.png)

So the first page is done.\
I also ran a few gobuster scans and found a few interesting directories:\
![](/images/static/Pasted%20image%2020260303144740.png)\
![](/images/static/Pasted%20image%2020260303144808.png)\
one of them being /js, which is quite interesting, and inside it the api.js file. What grabbed my attention was the ping line:\
![](/images/static/Pasted%20image%2020260303094618.png)

robots.txt gives a map:\
![](/images/static/Pasted%20image%2020260303091608.png)

Trying some parameter checking here:\
![](/images/static/Pasted%20image%2020260303092052.png)

Here I just tried a few random things like accessing that Node.js port, and using the ping IP parameter we saw in that file earlier, I was able to get RCE:\
![](../static/Pasted%20image%20202603095427.png)\
I tried to run a reverse shell script, but it didn't work:\
![](/images/static/Pasted%20image%2020260303102305.png)\
So I just listed the password file:\
![](/images/static/Pasted%20image%2020260303103444.png)\
Inside it, I found two password hashes and both of them were on CrackStation:

```
���(Mr00tf357a0c52799563c7c7b76c1e7543a32)Madmin0d0ea5111e3c1def594c1684e3b9be84: Name or service not known
```

![](/images/static/Pasted%20image%2020260303103535.png)\
mrsheafy\
![](/images/static/Pasted%20image%2020260303104008.png)\
n100906\
Then I just SSH'd with the first username and password:\
![](/images/static/Pasted%20image%2020260303105519.png)\
Inside, I tried to list SUID binaries or sudo permissions, but didn't find anything interesting:\
![](/images/static/Pasted%20image%2020260303105512.png)\
But when I ran id, I saw I have some docker permissions enabled; OK, that's cool:\
![](/images/static/Pasted%20image%2020260303105912.png)\
So I searched GTFOBins for privesc using Docker and found this:\
![](/images/static/Pasted%20image%2020260303110133.png)\
Run it and boom, root access! Room done:\
![](blog-ul-meu/static/Pasted%20image%2020260303110124.png)\
Just cat the SSH key as asked in the question:\
![](/images/static/Pasted%20image%2020260303110159.png)
