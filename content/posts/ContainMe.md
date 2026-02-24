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
lastmod: 2026-02-24T07:58:13.461Z
---
first scan , the host seemed down i hard to use `-Pn` flag for ignoring the host scaning , and we have some pretty interesting ports opened\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215132824.png)\
after another longer scan i found that there are actualy 2 more ports opened\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215134544.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215134533.png)\
lets check the http page and run a gobuster subdomain scan\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215134817.png)\
ok some from the web interface we can see that the server is using apche2 ,we may exploit this later\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215140821.png)\
the gobuster enumeration is finished and we find some interesting subodmains lets acces them\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215141111.png)\
accesing incex.php and looking inside the source code we can see this comment , the first clue\
this is obiously hinting at parametrizezing (excuse my english) the path of the file with `?path=`so lets try this ![](/images/blog-ul-meu/static/Pasted%20image%2020260215141447.png)\
and bamm we have acces to the file system\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215141655.png)\
and we also can execute commands by using `?path=;` cool

knowing that we can execute commands leets try to get a reverse shell

i found this cool sites while searching for a one liner php rever shell :\
https://tex2e.github.io/reverse-shell-generator/index.html\
where u just plug your ip and port and gives u a list off all reverse shell u want to try , i used a proc php shell and it worked\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215143455.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215143500.png)\
cool\
lets look around and try to upgrade the shell\
i tried to upgrade the shell but it wasent so helfull\
so lets search for some binaries we can execute as root\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215144654.png)\
i found this crypt scirpt that runs very wierd then i just pluged random things into it , when i try the name of a user on the machine `mike` it gived me root acces , idk why , also i dont think it is actually root account , but now we have acces to mike ssh keys so that cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215145506.png)\
we also see that if we `ifconfig` we can find that there is another host on the machine\
![](/images/blog-ul-meu/static/Pasted%20image%2020260223153421.png)\
beacause there are 2 eth address

if we go intro mike home directory we can see that there are some sshkeys , cool , so ifwe puthte 2 pieces togheter we can concluded that we need to ssh with this keys into the other host on the machine\
![](/images/blog-ul-meu/static/Pasted%20image%2020260215145514.png)\
lets try to ssh intro mike account , but first how do we the ip addres for the other host ?\
nmap isnt installed on the machine so we will have to use a static binary

i dowloaded a static binary of nmap in my machine then i copied on the attack machine

![](/images/blog-ul-meu/static/Pasted%20image%2020260223161759.png)

```
sudo wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/nmap -O nmap
```

attack machine\
![](/images/blog-ul-meu/static/Pasted%20image%2020260223161953.png)

cool now we know the ip , lets try to ssh into mike with :

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i id_rsa mike@172.16.20.6
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260223162807.png)

cool , inside mike we see some sql database, if we use mike account to acces them and set the password `password` we see the following

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

cool now we have root pass and mike pass\
lets su into root

```bash
 mike@host2:~$ su root 
 Password:
 root@host2:~$ ls 
```

cool now we are root and we see mike zip lets unzip it  and we found the flag

```
root@host2:~$ unzip mike.zip
Archive:  mike.zip
[mike.zip] mike password:
 extracting: mike                    
root@host2:~$ cat mike
THM{_Y0U_F0UND_TH3_C0NTA1N3RS_}
```
