---
created: 2026-02-15
tags:
  - note
  - journal
  - cyberStuff
title: ContainMe
draft: false
date:
subiect:
dificultate: 1
amuca: true
link:
  - https://tryhackme.com/room/containme1
lastmod: 2026-10-09T12:38:12.688Z
---
First scan: the host seemed down, so I had to use the -Pn flag to skip host discovery, and we have some pretty interesting ports open:\
![](/images/static/Pasted%20image%2020260215132824.png)\
After another, longer scan, I found that there are actually two more ports open:\
![](/images/static/Pasted%20image%2020260215134544.png)\
![](/images/static/Pasted%20image%2020260215134533.png)\
Let's check the HTTP page and run a gobuster directory scan:\
![](/images/static/Pasted%20image%2020260215134817.png)\
From the web interface, we can see that the server is using Apache2; we may exploit this later:\
![](/images/static/Pasted%20image%2020260215140821.png)\
The gobuster enumeration is finished and we find some interesting paths; let's access them:\
![](/images/static/Pasted%20image%2020260215141111.png)\
Accessing index.php and looking inside the source code, we can see this comment — the first clue:\
This is obviously hinting at passing the path of the file via `?path=`, so let's try this:\
![](/images/static/Pasted%20image%2020260215141447.png)\
And bam, we have access to the filesystem:\
![](/images/static/Pasted%20image%2020260215141655.png)\
And we also can execute commands by chaining with `?path=;` cool:

Knowing that we can execute commands, let's try to get a reverse shell.

I found this cool site while searching for a one-liner PHP reverse shell:\
https://tex2e.github.io/reverse-shell-generator/index.html\
where you just plug in your IP and port and it gives you a list of all the reverse shells you want to try. I used a proc\_open PHP shell and it worked:\
![](/images/static/Pasted%20image%2020260215143455.png)\
![](/images/static/Pasted%20image%2020260215143500.png)\
Cool.\
Let's look around and try to upgrade the shell.\
I tried to upgrade the shell, but it wasn't so helpful.\
So let's search for binaries we can execute as root:\
![](/images/static/Pasted%20image%2020260215144654.png)\
I found this crypt binary that behaves strangely, so I tested random inputs. When I tried the username `mike`, it dropped me into a root shell (or sub-shell). Now we have access to mike's SSH keys, so that's cool:\
![](/images/static/Pasted%20image%2020260215145506.png)\
We also see that running `ifconfig` shows another network interface on the machine:\
![](/images/static/Pasted%20image%2020260223153421.png)\
because there are two eth interfaces.

If we go into mike's home directory, we can see that there are SSH keys. Cool, so putting the pieces together, we can conclude that we need to SSH with these keys into the other container/host on the network:\
![](/images/static/Pasted%20image%2020260215145514.png)\
Let's try to SSH into mike's account. But first, how do we get the IP address for the other host?\
nmap isn't installed on the machine, so we will have to use a statically compiled binary.

I downloaded a static binary of nmap on my machine, then transferred it to the target:

![](/images/static/Pasted%20image%2020260223161759.png)

```
sudo wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/nmap -O nmap
```

Attack machine:\
![](/images/static/Pasted%20image%2020260223161953.png)

Cool, now we know the IP. Let's try to SSH into `mike` with:

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i id_rsa mike@172.16.20.6
```

![](/images/static/Pasted%20image%2020260223162807.png)

Cool, inside mike's machine we see a MySQL database. If we use mike's account to access it and enter the password `password`, we see the following:

```bash
 mysql> select * from users;
 +-------+---------------------+
 | login | password            |
 +-------+---------------------+
 | root  | bjsig4868fgjjeog    |
 | mike  | WhatAreYouDoingHere |
 +-------+---------------------+
 2 rows in set (0.00 sec)
```

Cool, now we have the root password and mike's password.\
Let's `su` to root:

```bash
 mike@host2:~$ su root 
 Password:
 root@host2:~$ ls 
```

Cool, now we are root and we see `mike.zip`. Let's unzip it to find the flag:

```
root@host2:~$ unzip mike.zip
Archive:  mike.zip
[mike.zip] mike password:
 extracting: mike                    
root@host2:~$ cat mike
THM{_Y0U_F0UND_TH3_C0NTA1N3RS_}
```
