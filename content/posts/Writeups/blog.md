---
created: 2026-02-26
tags:
  - note
  - journal
  - cyberStuff
title: blog
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
  - https://tryhackme.com/room/blog
lastmod: 2026-10-09T12:32:37.861Z
---
OK, so recon:\
![](/images/static/Pasted%20image%2020260226022933.png)\
Basic ports open:\
![](/images/static/Pasted%20image%2020260226022954.png)\
A lot of interesting subdomains; even robots.txt is available:\
![](/images/static/Pasted%20image%2020260226023052.png)\
![](/images/static/Pasted%20image%2020260226023129.png)\
Interesting:\
Also there is an SMB server open; I checked it, but found nothing interesting there.

I had to restart the machine because some of the subdomains weren't available. Cool:\
/wp-admin/

![](/images/static/Pasted%20image%2020260226025028.png)\
Login page at /wp-admin, cool:\
![](/images/static/Pasted%20image%2020260226025322.png)\
I ran wpscan and found some interesting usernames to try on the login page:

```
-e vp , vt , u 
### used to enumerate vulnerable plugins, vulnerable themes, and user ID range
```

![](/images/static/Pasted%20image%2020260226025511.png)\
I put those two usernames in a txt file to brute-force their passwords:\
![](/images/static/Pasted%20image%2020260226025647.png)

![](/images/static/Pasted%20image%2020260226031903.png)\
And after a long scan, I found kwheel=cutepie1.

When we log in, in the dashboard in the bottom right corner we can see:\
![](/images/static/Pasted%20image%2020260226034350.png)\
OK cool, it's running WordPress. I searched online for WordPress version 5.0 exploits and found something with image crop, then I searched on Metasploit and found:\
![](/images/static/Pasted%20image%2020260226035505.png)\
Cool, now let's configure the options as follows:\
![](/images/static/Pasted%20image%2020260226035536.png)\
Run it, and bam, we get a shell:\
![](/images/static/Pasted%20image%2020260226034530.png)\
![](/images/static/Pasted%20image%2020260226035703.png)\
Now let's enumerate SUID binaries:

![](/images/static/Pasted%20image%2020260226035342.png)\
We found an interesting checker here:\
![](/images/static/Pasted%20image%2020260226035327.png)\
Let's see what's inside with ltrace:\
![](/images/static/Pasted%20image%2020260226035912.png)\
OK, cool little program. So if we just:

```
export admin=1 
```

and run the program:\
Boom, root:\
![](/images/static/Pasted%20image%2020260226040025.png)\
And solved! Decent CTF; I had to restart the machine a few times.
