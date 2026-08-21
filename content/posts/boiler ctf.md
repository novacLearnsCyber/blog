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
lastmod: 2026-05-04T05:41:58.012Z
---
first enumeration\
![](/images/blog-ul-meu/static/Pasted%20image%2020260430053704.png)\
ftp server with anonymous login , a single file on it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260430053737.png)\
excrypted in rot 13\
![](/images/blog-ul-meu/static/Pasted%20image%2020260430053756.png)\
nothin interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260430053827.png)\
basic ubuntu web-server on

longer port enum\
![](/images/blog-ul-meu/static/Pasted%20image%2020260430055538.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260430054726.png)

joomla , bruteforcce the logni

![](/images/blog-ul-meu/static/Pasted%20image%2020260430062830.png)

> $gobuster dir -u$IP/joomla/ -w /usr/share/wordlists/dirb/common.txt

runned another gobuster on .... , and we find an intersting budomain named \_test

![](/images/blog-ul-meu/static/Pasted%20image%2020260504010628.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260504011121.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260504011314.png)

`basterd superduper@$$`

![](/images/blog-ul-meu/static/Pasted%20image%2020260504011507.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260504011743.png)

> \$ find / -perm /4000 -type f -exec ls -ld {} ; 2>/dev/null

![](/images/blog-ul-meu/static/Pasted%20image%2020260504013842.png)

It wasn't that hard, was it?

![](/images/blog-ul-meu/static/Pasted%20image%2020260504013942.png)
