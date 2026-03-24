---
created: 2026-02-01
tags:
  - note
  - journal
  - cyberStuff
title: wonderland
draft: false
date:
subiect:
  - web
  - prisEsc
dificultate: 3
amuca: true
link:
lastmod: 2026-02-01T22:35:10.663Z
---
basic nmap scan :\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201121152.png)\
basic ports opened\
then i did a gobuster scan\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201121842.png)\
interesting , subdomain '/r' , that give me the idea to try every letter in the word rabbit , as a subdomain and founde this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201122133.png)\
interesting\
i wanna try another gobuster scan with this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201122215.png)\
nothing interesting\
i decided to inspect the page and founded this not shown\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201122341.png)\
looks like a password for ssh lets try it\
alice:HowDothTheLittleCrocodileImproveHisShiningTail

nad bam bam we have a shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201122752.png)\
also there is an interesting python script there\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201124031.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201124039.png)\
looking into the script there are just some random lines of a  poem that are exported random , nothing interesting i think

i explored a lil bit hte file system and  with a lucky guest we may find the user flag inside the root folder , interesting that we have privileges for cat but not for ls\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201125202.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260201125830.png)\
Looks like our path is to exploit the walrus python script and run it as the rabbit user to get a shell.

ok cool so we know that we can execute that script with rabbit privileges , and that script uses the random function , so would it work to create our own random.py to run? lets try\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201130350.png)\
firstly create the rnadompy\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201130417.png)\
the content\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201130435.png)\
and we are in we can see that the user has changed\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201131033.png)\
inside the home rabbit directory we have a binary i think teaPary lets check it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201132516.png)

i copied the file on my local machine and string it and found this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201165837.png)\
it seams that the date program is not defined global so we can remake it localy just like we did at the previos exploit , and we will also have to modify the path\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201170134.png)\
like here , and now we are hatter very nice\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201170212.png)\
we found a password inside hatter folder very interesting\
WhyIsARavenLikeAWritingDesk?\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201171101.png)\
i tried to use sudo -l to see the sudo acces but it was blocked so i used getcap -r  used to list file capabilities as a alternative\
now i gonna try to fiind a exploid on gtfobins  for what we found

```
hatter@wonderland:~$ perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/bash";'
root@wonderland:~# whoami; id
root
uid=0(root) gid=1003(hatter) groups=1003(hatter)
```

and i founded a pearl exploit\
perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/bash";'\
very nice now we just have to take the flag

```
root@wonderland:/root# cat /home/alice/root.txt
thm{Twinkle, twinkle, little bat! How I wonder what you’re at!}
```

cool.
