---
created: 2026-04-22
tags:
  - note
  - journal
  - cyberStuff
title: LazyAdmin
draft: false
date:
subiect:
dificultate: 1
amuca: true
link:
  - https://tryhackme.com/room/lazyadmin
lastmod: 2026-10-09T12:29:30.276Z
---
Basic recon found only ports 22 and 80 open:\
![](/images/static/Pasted%20image%2020260422080416.png)\
Subdomain enumeration:\
![](/images/static/Pasted%20image%2020260422080444.png)\
Only /content for now; the scan is still running:\
![](/images/static/Pasted%20image%2020260422080521.png)\
After accessing /content, we found that the site is running SweetRice. Searching for an exploit on this, I found this: https://www.exploit-db.com/exploits/40718\
which basically says that we can access some MySQL backups by going to /inc/mysql\_backup:\
![](/images/static/Pasted%20image%2020260422080742.png)\
Downloading the files, we get a list of credentials; after searching a little bit inside, we find this:\
![](/images/static/Pasted%20image%2020260424050351.png)\
A username and a password to log in, but where?\
I googled it and found that on SweetRice we can log in at /ac as admin of the page:\
![](/images/static/Pasted%20image%2020260422082433.png)\
And we get this dashboard:\
![](/images/static/Pasted%20image%2020260422091226.png)\
Some random passwords:\
![](/images/static/Pasted%20image%2020260422092629.png)\
Looking around the site, we found a page for ads where we can inject different scripts. Cool, so let's try to get a reverse shell with this.\
https://github.com/pentestmonkey/php-reverse-shell — I used this shell from pentestmonkey; modify your port and IP inside the script.

Give it a random name and upload it.\
Now open a listener on your machine with `nc -lnvp <PORT>`, access http://MachineIp/content/inc/ads, and click on the file you just uploaded.\
And we are inside. Looking around, we found the first flag in /home/itguy:\
![](/images/static/Pasted%20image%2020260422092834.png)\
Running sudo -l to see what we can run with elevated privileges, we came across this:\
![](/images/static/Pasted%20image%2020260424054429.png)\
Let's look inside it:\
![](/images/static/Pasted%20image%2020260424054535.png)\
OK, it's a script running another script, interesting. Let's look inside copy.sh as well:\
![](/images/static/Pasted%20image%2020260424054648.png)\
Cool, it's another reverse shell; just set up another listener with nc and modify your IP and port inside copy.sh.\
Now, to run the script we have to run: `sudo /usr/bin/perl /home/itguy/backup.pl`\
Doing that, we get a reverse shell. Cool:\
![](/images/static/Pasted%20image%2020260424054830.png)\
And we got the last flag, nice!
