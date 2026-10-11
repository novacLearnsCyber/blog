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
lastmod: 2026-10-09T12:38:38.916Z
---
Basic nmap scan:\
![](/images/static/Pasted%20image%2020260201121152.png)\
Basic ports open.\
Then I did a gobuster scan:\
![](/images/static/Pasted%20image%2020260201121842.png)\
Interesting, path `/r`. That gave me the idea to try every letter in the word "rabbit" as a path, and found this:\
![](/images/static/Pasted%20image%2020260201122133.png)\
Interesting.\
I wanted to try another gobuster scan with this:\
![](/images/static/Pasted%20image%2020260201122215.png)\
Nothing interesting.\
I decided to inspect the page and found this note:\
![](/images/static/Pasted%20image%2020260201122341.png)\
Looks like a password for SSH, let's try it:\
alice:HowDothTheLittleCrocodileImproveHisShiningTail

And bam bam, we have a shell:\
![](/images/static/Pasted%20image%2020260201122752.png)\
Also, there is an interesting Python script there:\
![](/images/static/Pasted%20image%2020260201124031.png)\
![](/images/static/Pasted%20image%2020260201124039.png)\
Looking into the script, there are just some random lines of a poem printed at random—nothing interesting, I think.

I explored the filesystem a little bit and, with a lucky guess, found the user flag inside the root folder. Interesting that we have privileges for `cat` but not for `ls`:\
![](/images/static/Pasted%20image%2020260201125202.png)

![](/images/static/Pasted%20image%2020260201125830.png)\
Looks like our path is to exploit the walrus Python script and run it as the `rabbit` user to get a shell.

OK cool, so we know that we can execute that script with `rabbit` privileges, and that script imports the `random` module. Would it work to create our own `random.py` to hijack it? Let's try:\
![](/images/static/Pasted%20image%2020260201130350.png)\
Firstly, create `random.py`:\
![](/images/static/Pasted%20image%2020260201130417.png)\
The content:\
![](/images/static/Pasted%20image%2020260201130435.png)\
And we are in! We can see that the user has changed:\
![](/images/static/Pasted%20image%2020260201131033.png)\
Inside the `/home/rabbit` directory we have a binary, `teaParty`. Let's check it:\
![](/images/static/Pasted%20image%2020260201132516.png)

I copied the file to my local machine and ran `strings` on it, finding this:\
![](/images/static/Pasted%20image%2020260201165837.png)\
It seems that the `date` command is not defined with an absolute path, so we can hijack it locally just like we did in the previous exploit, and modify the `PATH`:\
![](/images/static/Pasted%20image%2020260201170134.png)\
Like here, and now we are `hatter`. Very nice:\
![](/images/static/Pasted%20image%2020260201170212.png)\
We found a password inside Hatter's folder, very interesting:\
WhyIsARavenLikeAWritingDesk?\
![](/images/static/Pasted%20image%2020260201171101.png)\
I tried to use `sudo -l` to check sudo access, but it was blocked, so I used `getcap -r /` to list file capabilities as an alternative.\
Now I'm going to find an exploit on GTFOBins for what we found:

```
hatter@wonderland:~$ perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/bash";'
root@wonderland:~# whoami; id
root
uid=0(root) gid=1003(hatter) groups=1003(hatter)
```

And I found a perl exploit:\
perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/bash";'\
Very nice, now we just have to grab the flag:

```
root@wonderland:/root# cat /home/alice/root.txt
thm{Twinkle, twinkle, little bat! How I wonder what you’re at!}
```

Cool.
