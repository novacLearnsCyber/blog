---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: brains
draft: false
categories:
  - tryhackme
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:24:00.250Z
---
link :<https://tryhackme.com/room/brains>\
desc:\
![](https://share.note.sx/files/2i/2i55bxz32r71ios4690k.png)

accesing the ip through a browser we get the followeing\
![](https://share.note.sx/files/yt/ytgkf02melnmlrptcqfy.png)\
mhmm interesting , lets run a port scan

![](https://share.note.sx/files/oh/ohy92b87tuny0fsrxnhe.png)\
nothing really interesting , just ssh and http

i runned a sobdomain enumeration to see any interesting subdomains\
![](https://share.note.sx/files/pg/pgy4lurbucpr117oql2t.png)\
![](https://share.note.sx/files/65/650iwhhq8co0pufxsr93.png)\
and we did find something\
lets check everyone of them

yeah every one of them give the same result , i decided do to another portscan , maybe i will find something new\
![](https://share.note.sx/files/fn/fnvb7257ptm7oub30ryk.png)\
and sure we did\
![](https://share.note.sx/files/z4/z4h7jidr0d0fayvgri4i.png)\
there is something interesting

lets run a subdomain enum on this one to\
![](https://share.note.sx/files/2g/2gctyf37nmiu9flcaxm7.png)\
nothing really interesting here

but in the login page we can exploit the version number\
![](https://share.note.sx/files/q0/q0vimmttl06sszvxmaw6.png)\
and based on that we can use the following cve\
<https://www.rapid7.com/blog/post/2024/03/04/etr-cve-2024-27198-and-cve-2024-27199-jetbrains-teamcity-multiple-authentication-bypass-vulnerabilities-fixed/>

the payload

```
curl -ik http://$IP:8111/hax?jsp=/app/rest/users;.jsp -X POST -H "Content-Type: application/json" --data "{\"username\": \"haxor\", \"password\": \"haxor\", \"email\": \"haxor\", \"roles\": {\"role\": [{\"roleId\": \"SYSTEM_ADMIN\", \"scope\": \"g\"}]}}"
```

![](https://share.note.sx/files/px/pxz25v23tenyw0nlei9u.png)\
we run it and find something interesting ,

yes its all good , but we have to adjust the payload to the bob username\
![](https://share.note.sx/files/7c/7c5n9mdxigbjhscy99pm.png)

now we should install a pugin ourselfs

yeah , here is novac from tomorow , after some long battle with and exploit taht didnt work , i gived up yesterday and continued today , so , what i change

first of all , i will use this exploit :<https://github.com/W01fh4cker/CVE-2024-27198-RCE/blob/main/CVE-2024-27198-RCE.py>

second of all : i figured out how to install faker , i tool needed to use the exploit work using the comand , yesterday when i tried to install it with pip3 i got all kind of error but now it works

```
pip install faker --break-system-packages.
```

and voilea we get the following\
![](https://share.note.sx/files/ke/kegsjjq0k7t32wgu9s1q.png)\
in brainsCVE>py i put he cve\
and we have a shell\
![](https://share.note.sx/files/ek/ek05926wvg5bvbikavqg.png)\
for now i think we a re stuck in this directory\
and we did find a flag\
![](https://share.note.sx/files/k0/k0gvj02vchyo5pf0ku0u.png)

lets investigate the second machine

yeah so we connect to the second machine in browser , note i had to insert manually the port 8000 to connect\
there we have a splunk interface\
navigatge in the left side bar and click on search and reporting\
![](https://share.note.sx/files/d0/d06r1lsdwrshg7q1kla7.png)\
then insert in the box the following string to see the user created\
![](https://share.note.sx/files/qw/qwoav2qfdgxufbhb8pf3.png)\
also select all time in the left box

and there is the malicios user\
![](https://share.note.sx/files/3e/3ewqirstrqx4ub8wdfqx.png)

now for the malicios packeage install on the server\
we search with the following stiring\
![](https://share.note.sx/files/d2/d2bfcd30qbdbytm1lxr0.png)\
![](https://share.note.sx/files/ab/ab34soxut51d2abolkvn.png)\
and that datacolector thing looks suspicios

and for the plugin installed we use the followng string\
![](https://share.note.sx/files/lt/ltlqn940979h2t9ai0lk.png)

and we find it\
![](https://share.note.sx/files/y2/y2l3o61rrq57dxclq8se.png)

good room
