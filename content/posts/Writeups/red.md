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
lastmod: 2026-10-09T12:44:44.569Z
---
Link: <https://tryhackme.com/room/redisl33t>

Note for the end: on the final script used for privilege escalation, the script has to be modified as shown below, right at the end of the script:

```
environ_p = (c_char_p * len(environ))()
environ_p[:] = environ

print('[+] Calling execve()')

libc.execve(b'/home/red/.git/pkexec', c_char_p(None), environ_p)

```

Description: ![](https://share.note.sx/files/h5/h5x35x2i9crzu2i43h39.png)\
![](https://share.note.sx/files/u8/u8e1pbubq8duwanykz4u.png)\
Scanned the IP with the following command:

```bash
sudo nmap -v --min-rate 10000 $IP -p-
```

Just because it's fast, and it gives us SSH and HTTP open, cool.

Let's run a version scan now:

```bash
sudo nmap -v -sVC -oN nmap.txt $IP -p 22,80
```

![](https://share.note.sx/files/nn/nnjcwrartpfdqv7v2kii.png)\
Cool, OpenSSH, so we have an Ubuntu machine.

Let's check the site:

![](https://share.note.sx/files/7l/7lv6qf74n33d4tdznrzn.jpg)\
Mhmm: <https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/File%20Inclusion>

Let's use Burp Suite:\
![](https://share.note.sx/files/zz/zz1duq434w4y360sftsc.png)\
I used Burp Suite to try to see `/etc/passwd`, but it didn't work.

I took a payload from the following link: <https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/File%20Inclusion>

`php://filter/convert.base64-encode/resource=index.php`

And I found something:\
It's the source code in base64:

![](https://share.note.sx/files/fo/fonwiyjgx18rpx95gkh0.png)\
I edited the payload a little bit to read files, and I managed to access the passwd file:

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

Then I used the following LFI Hunter script:\
<https://github.com/hadrian3689/lfi_hunter.git>

Then I ran it: ![](https://share.note.sx/files/hx/hxufpxriolnx8jhvblyk.png)

And if we `cat unix` it looks like this:\
![](https://share.note.sx/files/uv/uv7cvk81fq7o9oak5y20.png)

Note: The first time it didn't work:\
![](https://share.note.sx/files/r2/r2kt7p3wcm9ngvbhbwx3.png)\
And we do find a history file for `blue`:

Let's try to read the file from Burp Suite:

![](https://share.note.sx/files/qq/qq62942i17ho6jx8ac91.png)\
It also shows that there is a reminder file; let's try to look into it:\
![](https://share.note.sx/files/gw/gwca2e1ik72sy7l5rh52.png)

When we read it we find the following:\
![](https://share.note.sx/files/35/355laeh95i5i940hnkl2.png)\
Cool:

`sup3r_p@s$w0rd!`

I ran the following command to create a list of passwords to brute-force:

```bash
hashcat --stdout pass.txt -r /usr/share/hashcat/rules/best64.rule > passlist.txt
```

Then I used hydra to brute-force:

```bash
hydra -l blue -P passlist.txt $IP ssh
```

Then we found that the password is:\
![](https://share.note.sx/files/b2/b29brme4316i097k01eb.png)

The password is `sup3r_p@s$w0sup3r_p@s$w0`.\
Then we can SSH into it:\
![](https://share.note.sx/files/vq/vq7qgzmny907bvmc4bk7.png)\
And we are in as a blue team member:

![](https://share.note.sx/files/6l/6lvfz53fta1n3kfr3p69.png)

Oooo interesting, I think it's a cronjob running to show those messages:\
![](https://share.note.sx/files/ee/eev898c9jikt41gwrqeb.png)\
Interesting:\
![](https://share.note.sx/files/d6/d6vb0luilddgezqpm9ey.png)\
And it disconnected us, niceee.

I ran hydra again and found it's the same password:\
![](https://share.note.sx/files/z8/z8ckynd1w1vd6m2jfm2t.png)

A simple way to bypass the kick is by adding `-T` at the end of the SSH command:\
![](https://share.note.sx/files/b0/b08ktej0j66g8bser4u8.png)\
Like here; this is a common King of the Hill tip.

After I checked the cronjobs I saw that the machine connects to a server named `redrules.thm`.\
So I modified `/etc/hosts`, added my IP address, and caught a reverse shell from the machine, as shown:\
![](https://share.note.sx/files/2m/2my1cq6evi6qvuyjixco.png)\
![](https://share.note.sx/files/8i/8ivl6pjstfh3m4gli515.png)

Also, if we `ls` we can find the second flag:\
![](https://share.note.sx/files/g0/g0ku1572n4kiomaayigh.png)

Then you just have to copy-paste the following script using vim and run it with Python to privesc.

I suggest creating an HTTP server on your machine then downloading the script with `wget`, because it gave me a very big headache trying to copy-paste with vim:\
<https://github.com/joeammond/CVE-2021-4034?tab=readme-ov-file>

Now you are root and can grab the last flag.
