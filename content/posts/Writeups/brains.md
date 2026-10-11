---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: brains
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:55:48.485Z
---
Link: <https://tryhackme.com/room/brains>\
Description:\
![](https://share.note.sx/files/2i/2i55bxz32r71ios4690k.png)

Accessing the IP through a browser, we get the following:\
![](https://share.note.sx/files/yt/ytgkf02melnmlrptcqfy.png)\
Mhmm interesting, let's run a port scan:

![](https://share.note.sx/files/oh/ohy92b87tuny0fsrxnhe.png)\
Nothing really interesting, just SSH and HTTP.

I ran a subdomain enumeration to see any interesting subdomains:\
![](https://share.note.sx/files/pg/pgy4lurbucpr117oql2t.png)\
![](https://share.note.sx/files/65/650iwhhq8co0pufxsr93.png)\
And we did find something.\
Let's check every one of them.

every one of them gives the same result. I decided to do another port scan; maybe I will find something new:\
![](https://share.note.sx/files/fn/fnvb7257ptm7oub30ryk.png)\
And we sure did:\
![](https://share.note.sx/files/z4/z4h7jidr0d0fayvgri4i.png)\
There is something interesting.\
Let's run a subdomain enum on this one too:\
![](https://share.note.sx/files/2g/2gctyf37nmiu9flcaxm7.png)\
Nothing really interesting here.

But on the login page we can exploit the version number:\
![](https://share.note.sx/files/q0/q0vimmttl06sszvxmaw6.png)\
And based on that we can use the following CVE:\
<https://www.rapid7.com/blog/post/2024/03/04/etr-cve-2024-27198-and-cve-2024-27199-jetbrains-teamcity-multiple-authentication-bypass-vulnerabilities-fixed/>

The payload:

```
curl -ik http://$IP:8111/hax?jsp=/app/rest/users;.jsp -X POST -H "Content-Type: application/json" --data "{\"username\": \"haxor\", \"password\": \"haxor\", \"email\": \"haxor\", \"roles\": {\"role\": [{\"roleId\": \"SYSTEM_ADMIN\", \"scope\": \"g\"}]}}"
```

![](https://share.note.sx/files/px/pxz25v23tenyw0nlei9u.png)\
We run it and find something interesting:\
Yes, it's all good, but we have to adjust the payload for the `bob` username:\
![](https://share.note.sx/files/7c/7c5n9mdxigbjhscy99pm.png)

Now we should install a plugin ourselves.

Yeah, here is Novac from tomorrow. After a long battle with an exploit that didn't work, I gave up yesterday and continued today. So, what did I change?

First of all, I will use this exploit: <https://github.com/W01fh4cker/CVE-2024-27198-RCE/blob/main/CVE-2024-27198-RCE.py>

Second of all: I figured out how to install `faker`, a tool needed to make the exploit work using the command. Yesterday when I tried to install it with pip3 I got all kinds of errors, but now it works:

```
pip install faker --break-system-packages
```

And voilà, we get the following:\
![](https://share.note.sx/files/ke/kegsjjq0k7t32wgu9s1q.png)\
In `brainsCVE.py` I put the CVE exploit:\
And we have a shell:\
![](https://share.note.sx/files/ek/ek05926wvg5bvbikavqg.png)\
For now I think we are stuck in this directory.\
And we did find a flag:\
![](https://share.note.sx/files/k0/k0gvj02vchyo5pf0ku0u.png)

Let's investigate the second machine.

Yeah, so we connect to the second machine in the browser (note: I had to manually specify port 8000 to connect).\
There we have a Splunk interface.\
Navigate to the left sidebar and click on Search & Reporting:\
![](https://share.note.sx/files/d0/d06r1lsdwrshg7q1kla7.png)\
Then insert the following string into the search box to see the user created:\
![](https://share.note.sx/files/qw/qwoav2qfdgxufbhb8pf3.png)\
Also select All Time in the time range picker.

And there is the malicious user:\
![](https://share.note.sx/files/3e/3ewqirstrqx4ub8wdfqx.png)

Now for the malicious package installed on the server:\
We search with the following string:\
![](https://share.note.sx/files/d2/d2bfcd30qbdbytm1lxr0.png)\
![](https://share.note.sx/files/ab/ab34soxut51d2abolkvn.png)\
And that datacollector thing looks suspicious.

And for the plugin installed, we use the following string:\
![](https://share.note.sx/files/lt/ltlqn940979h2t9ai0lk.png)

And we find it:\
![](https://share.note.sx/files/y2/y2l3o61rrq57dxclq8se.png)

Good room.
