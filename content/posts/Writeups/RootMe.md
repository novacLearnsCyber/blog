---
created: 2026-03-22
tags:
  - note
  - journal
  - cyberStuff
title: RootMe
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:33:39.869Z
---
### Reconnaissance

Just run:

```
sudo nmap $IP -sCV -p-
```

It will give you all the answers needed.

### Getting a Shell

This is where it became interesting: in the last step we get a secret folder called `panel` where we can upload different files. Cool, we know that this is how we are going to get a reverse shell.

But when I try to upload a .php reverse shell, an error message is triggered saying that PHP is not allowed, so we are going to have to bypass this file filter somehow:\
![647](/images/static/Pasted%20image%2020260322085809.png)\
Researching ways to bypass this, I found out about polyglot files, which are basically files that can be executed as multiple file formats, like a PNG that is also a PDF. With that in mind, we can create a PNG that is also a PHP file.\
Important to mention: you can also bypass this by intercepting the request using Burp Suite and then changing the file format, but I will not go into that here.

I used this video as a guide: https://www.youtube.com/watch?v=uGk5\_yDbSeQ

So after some time of trying, I didn't get the polyglot file to work on the server as intended, so let's try another approach:

Apparently, if we rename a .php file to .php5 it also works, so let's do that:

First run this (if you are on Kali; otherwise, search for a PHP reverse shell online):

```
cp /usr/share/webshells/php/php-reverse-shell.php .
mv webSheell webSheell.php5 
```

Then modify the IP and port in the file, and open a listener:

Start a listener with:

```
rlwrap nc -lnvp <YOUR_PORT>

```

Upload the file in the form and access it at /uploads;\
and like that, we get a shell:

![](/images/static/Pasted%20image%2020260322104610.png)

### Privesc

Let's enumerate SUID binaries with:

```
find / -perm -u=s -type f 2>/dev/null
```

And we get a SUID binary: /usr/bin/python2.7.\
Cool, now we just have to search SUID on GTFOBins:\
![](/images/static/Pasted%20image%2020260322104804.png)\
And we got this one; just run this command and we are root:

```
python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

I will let you find the paths of the flags. Bye bye!
