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
lastmod: 2026-10-09T12:35:16.797Z
---
Basic scanning at the beginning:\
![](/images/static/Pasted%20image%2020260304085816.png)\
A lot of ports open; after trying to connect to each of them, I found this:\
![](/images/static/Pasted%20image%2020260304091917.png)\
Logging in as guest, we get the following dashboard:\
![](/images/static/Pasted%20image%2020260304092419.png)

***

### First flag

In the profile section, I tried to modify some parameters and it works; just like that, we can modify the isAdmin parameter to true:\
![](/images/static/Pasted%20image%2020260304092431.png)\
As admin, we can view the API dashboard, which gives us some interesting information about the structure of the site and how it manages requests:\
![](/images/static/Pasted%20image%2020260304092642.png)\
In the admin settings tab, we can modify the banner image:\
![](/images/static/Pasted%20image%2020260306062732.png)\
This looks like a Local File Inclusion (LFI) vulnerability.\
If we input the two addresses from the API dashboard into admin settings, we get two Base64-encoded responses:\
![](/images/static/Pasted%20image%2020260306063151.png) ![](/images/static/Pasted%20image%2020260306063210.png)\
When we decode those using CyberChef, we get the following (for getAllAdmins):

![](/images/static/Pasted%20image%2020260306082011.png)\
The other address is not that interesting. Using the credentials we got, we can log in to SysMon:

![](/images/static/Pasted%20image%2020260304094655.png)\
![](/images/static/Pasted%20image%2020260304094806.png)\
I tried both of them, and only the administrator one worked:\
![](/images/static/Pasted%20image%2020260304165548.png)\
And we got the first flag, cool!

***

### Second Flag

Viewing the site source code, we see the following. That profile image parameter looks like a good vulnerability to exploit:\
![](/images/static/Pasted%20image%2020260306052826.png)\
I performed a directory traversal inside the URL for /etc/passwd and got the following:\
Payload:

```
profile.php?img=....//....//....//....//....//....//....//....//....//....//....//....//....//....//....//etc/passwd
```

![](/images/static/Pasted%20image%2020260306053007.png)\
We see two users:\
charles and joshua.\
Let's put them into a user.txt file:\
![](/images/static/Pasted%20image%2020260306053233.png)\
Now let's brute-force SSH using hydra:\
![](/images/static/Pasted%20image%2020260306053512.png)\
Command:

```
hydra -L user.txt -P <pathOfWordlist> ssh://<IPofMachine>
```

![](/images/static/Pasted%20image%2020260306053951.png)\
Thanks devs for hydra -R (restore), because I accidentally stopped the process the first time while taking a screenshot.

And after a long brute-force, we get the passwords:\
![](/images/static/Pasted%20image%2020260306061403.png)\
And boom, we are in! Just cat the flag from the path provided:\
![](/images/static/Pasted%20image%2020260306061535.png)
