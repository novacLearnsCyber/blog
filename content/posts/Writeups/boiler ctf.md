---
created: 2026-04-30
tags:
  - note
  - journal
  - cyberStuff
title: boiler ctf
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:58:29.708Z
---
First enumeration:\
![](/images/static/Pasted%20image%2020260430053704.png)\
FTP server with anonymous login, a single file on it:\
![](/images/static/Pasted%20image%2020260430053737.png)\
Encrypted in ROT13:\
![](/images/static/Pasted%20image%2020260430053756.png)\
Nothing interesting:\
![](/images/static/Pasted%20image%2020260430053827.png)\
Basic Ubuntu web server running.

Longer port enumeration:\
![](/images/static/Pasted%20image%2020260430055538.png)

![](/images/static/Pasted%20image%2020260430054726.png)\
Joomla, brute-force the login:\
![](/images/static/Pasted%20image%2020260430062830.png)

> $gobuster dir -u$IP/joomla/ -w /usr/share/wordlists/dirb/common.txt

Ran another gobuster on the directory and we find an interesting directory/subpath named \_test:

![](/images/static/Pasted%20image%2020260504010628.png)

![](/images/static/Pasted%20image%2020260504011121.png)

![](/images/static/Pasted%20image%2020260504011314.png)

`basterd superduper@$$`

![](/images/static/Pasted%20image%2020260504011507.png)

![](/images/static/Pasted%20image%2020260504011743.png)

> \$ find / -perm /4000 -type f -exec ls -ld {} ; 2>/dev/null

![](/images/static/Pasted%20image%2020260504013842.png)

It wasn't that hard, was it?

![](/images/static/Pasted%20image%2020260504013942.png)
