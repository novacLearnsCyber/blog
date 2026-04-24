---
created: 2026-04-22
tags:
  - note
  - journal
  - cyberStuff
title: 2026-04-22 ǀ 07꞉54
draft: false
date:
subiect:
dificultate: 1
amuca: true
link:
  - https://tryhackme.com/room/lazyadmin
lastmod: 2026-04-24T09:48:55.220Z
---
basic recon found just ports 22 and 80 opened:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422080416.png)\
subdomain enumeration:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422080444.png)\
only /content for now , the scan is still running\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422080521.png)\
After accessing /content we found that the site is running SweetRice , searching for an exploit on this i found this : https://www.exploit-db.com/exploits/40718\
which basically says that we can access some mysql backups by going to /inc/mysql\_backup\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422080742.png)\
downloading the files we get a list of credentials , after searching a lil bit inside it we find this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260424050351.png)\
a username and a password to log in , but where.\
i google it and found that on sweetRice we can log in at  /ac as a admin of the page\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422082433.png)\
and we get this dashboard\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422091226.png)\
some random passwords\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422092629.png)\
looking aroung the site we found a page for ads , where we can inject diferent scripts , cool , so lets try to make a reverse shell with this.\
https://github.com/pentestmonkey/php-reverse-shell , used this shell from monkey pentest, modify your port and ip inside the script.

give it a random name and upload it.\
Now open a listener on your machine with `nc -lnvp <PORT>` , and access http://MachineIp/content/inc/ads , and click on your file u just uploaded.\
and we are inside , looking around we found the first flag in home itguy.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260422092834.png)\
running a sudo -l to see what we can run with privilege we came across this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260424054429.png)\
lets look inside it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260424054535.png)\
ok its a script running another script interesting , lets look inside also of copy.sh\
![](/images/blog-ul-meu/static/Pasted%20image%2020260424054648.png)\
cool its another reverse shell , just setup another lister with nc and modify your ip and port inside copy.sh.\
now to run the script we have to `sudo /usr/bin/perl home/itguy/backup.pl`\
doing that we gonna get a reverse shell cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260424054830.png)\
and we got the last flag nice.
