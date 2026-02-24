---
created: 2026-02-05
tags:
  - note
  - journal
  - cyberStuff
title: MrRobot
draft: false
date:
subiect:
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/mrrobot
lastmod: 2026-02-05T13:13:14.400Z
---
![](/images/blog-ul-meu/static/Pasted%20image%2020260205055009.png)\
the first nmap scan shows that all 1000 ports on the host are in ignored status\
after a google search i found out that using -sN ( connect scan) can bypass this easly\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205055956.png)\
basic ports open , lets try to visit the web site\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205060021.png)\
after a very cool animation this is what we see\
i tried prepare and a cool cinematic roll up , nothing to interesting in ther elets try question\
i![](/images/blog-ul-meu/static/Pasted%20image%2020260205060331.png)\
just some picture aperead on the screen , i think this whole site is just some random promotional things from the tv series

if i enter join i get he following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205060956.png)\
after i enter an email address i get nothing in the inbox\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205061136.png)\
i checked the page nad i get this html commentaries

<!--
\   //~~\ |   |    /\  |~~\|~~  |\  | /~~\~~|~~    /\  |  /~~\ |\  ||~~
 \ /|    ||   |   /__\ |__/|--  | \ ||    | |     /__\ | |    || \ ||--
  |  \__/  \_/   /    \|  \|__  |  \| \__/  |    /    \|__\__/ |  \||__
-->

just an ascii message

lets check robots.txt file\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205062914.png)\
this is what we get , interesting files , lets check them\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205062944.png)\
ok ok cool string , probally something encoded\
nah my bad this is the first key acctually , cool

if we acces the second mentioned page from robots.txt (fsocity.dic) we get this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205063706.png)\
a very long list of words  , which i think is a subdomain list , so wget it on my machine , and run gobuster with it to find something interesting , i think its gonna take some time\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205063804.png)\
this is the readme btw\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205063834.png)\
/Image direct us to a blog , cool cool a new path here

![](/images/blog-ul-meu/static/Pasted%20image%2020260205064335.png)

i noticed that even through the listis long it start to repets itself\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205064434.png)\
i decided to also run another subdomain ennumeration this time with a common subdomain discovery wordlist\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205065903.png)\
from this list the wp-login seems interesting lets check it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205070046.png)\
and it is a wordpress , good this means it is vulnerable , we have to search for the version\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205070324.png)\
i opened burpsuite and intercept a failed login via the proxy\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205070513.png)\
cool invalid username , i tried the credentioals admin admin, so that mean there is someone with the pass admin\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205071414.png)\
i runned this long and complex hydra commad ang i get this\
what does the hydra command acctually does :\
-L specifies the dictionary files we downloaded earlier , to take usernames from\
-p test specifies a password to test all the account names\
\$IP part and all what http port form - speficy for that to look after and return back\
-t 30  the number of tasks in paralled to run

and we get the username elliot , lets test it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205071745.png)\
cool now we get an invalid password\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205072752.png)\
i runned this command also with hydra , is similar to the previos one just a few things changed , after some time i get the elliot password being : ER28-0652

![](/images/blog-ul-meu/static/Pasted%20image%2020260205072935.png)\
and we are in cool\
ok cool so next i did the following\
firstly get into the apperence editor menu\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205074357.png)\
then i modified the archive.php with this reverse shell from pentestMonkey on github very cool\
https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php\
just copied the raw fomat then modify your ip and port and press Update file\
note that we also have to create a listner on our machine with the command\
`rlwrap nc -lvnp 53 `\
rlwrap is just for us to get a better shell , and 53 is the port\
now we just have to acces the page :http://10.66.189.112/wp-content/themes/twentyfifteen/archive.php , after that the script will run and update\
and we get a reverse shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205074733.png)\
cool.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205075029.png)\
i looked around the machine a lil bit and found a password for the user robot that is stored as a hash , lets check it on crackstation\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205075126.png)\
and we have the robot password lets login as him\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205075215.png)\
and it works\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205075256.png)\
and we have another key cool\
nbow i thunk we will have to root this machine completly\
lets see that sudos we gen get\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205075422.png)\
yeah this is not a got sign\
i also upgradeed the shell with the command

```
python -c 'import pty;pty.spawn("/bin/bash")'
```

cool\
i think we will have to search for suid binaries in another way\
suid binaries are binaries that have the suid bit set , that means they can be execute and have other users privileges , which is very op\
we gonna search for them with this command

```
find / -perm +6000 2>/dev/null | grep '/bin'
```

```
	breakdown of the commnad : 
		it uses find to locate a binary with all the permision bits set 
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260205080140.png)\
2>/dev/null - just to redirect the errors into dev/null to be ignored\
grep '/bin' to get the ones that are execute via bin

after running this command we will see that /usr/local/bin/nmap has the suid binary set , good that means we can exploit it

after searching on gtfo bins we see that we can exploit nmap by :\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205081153.png)\
cool lets do just that\
![](/images/blog-ul-meu/static/Pasted%20image%2020260205081232.png)\
and bamm we are root and we can read the final flag in /root/key-3-of-3.txt , cool.
