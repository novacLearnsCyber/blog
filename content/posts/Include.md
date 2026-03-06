---
created: 2026-03-04
tags:
  - note
  - journal
  - cyberStuff
title: Include
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-06T13:19:01.068Z
---
basic scanning in the begining\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304085816.png)\
a lot of ports opened , after trying to connect to each of them i found this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304091917.png)\
logging in as guest we get the following dashboard\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304092419.png)

***

### First flag

in the profile section i tried to modify some parameters and it works , and just like that we can modify the isAdmin parameter to be true\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304092431.png)\
as admin we can view the api dashboard which gives us some interesting information about the structure of the site and how it manages requests\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304092642.png)\
in the admin settings tab we can modify the banner image\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306062732.png)\
this may look like a Local File Intrusion vulnerabily\
if we input the two addresses from the api dashboard into admin settings we get two base64 encoded responses\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306063151.png) ![](/images/blog-ul-meu/static/Pasted%20image%2020260306063210.png)\
when we decode those using cyber chef we get the following (for getAllAdmins):

![](/images/blog-ul-meu/static/Pasted%20image%2020260304094310.png)\
the other addres is not that interesting , using the credential we got we can log in intro SysMon

![](/images/blog-ul-meu/static/Pasted%20image%2020260304094655.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304094806.png)\
i tried both of them and just administrator one worked whatever\
![](/images/blog-ul-meu/static/Pasted%20image%2020260304165548.png)\
and we got the first flag cool

***

### Second Flag

viewing the site shouce code we see the following , what profile image may look again like a good vulnerabilty to exploit\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306052826.png)\
i did a directory traversal inside the url for /etc/passwd and i got the following\
payload

```
profile.php?img=....//....//....//....//....//....//....//....//....//....//....//....//....//....//....//etc/passwd
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260306053007.png)\
we see 2 users\
charles and joshua\
lets put them into a .txt file\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306053233.png)\
now lets just bruteforce using hydra for the ssh\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306053512.png)\
command:

```
hydra -L user.txt -P <pathOfWordlist> ssh://<IPofMachine>
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260306053951.png)\
thanks devs for hydra -R cause i abandoned the process first time trying to copy the screenshot

and after a long bruteforce we get the passwords\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306061403.png)\
and boom we are in , just cat the flag from the path given to us\
![](/images/blog-ul-meu/static/Pasted%20image%2020260306061535.png)
