---
created: 2026-03-09
tags:
  - note
  - journal
  - cyberStuff
title: TryHack3M Subscribe
draft: false
categories:
  - tryhackme
date:
subiect:
dificultate: 1
amuca: false
link:
  - https://tryhackme.com/room/subscribe
lastmod: 2026-03-11T16:31:04.364Z
---
### Part 1 - Exploitation

scanning , some interesting ports opened\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310074500.png)

accesing the http via burpsuite and inspecting the site map we see the following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260309084231.png)\
lets look a lil bit at the js folder , that invite function seems interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260309084344.png)\
ok so i copy pasted the function and pasted it into a code beautifier and get this:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260309084551.png)\
the original function :\
![](/images/blog-ul-meu/static/Pasted%20image%2020260309084610.png)\
so the function basicaly sais that if our hostname is not capture3milliobsubcribers.thm we cant log in , so lets modify that is /etc/hostnames\
![](/images/blog-ul-meu/static/Pasted%20image%2020260309085351.png)\
ok cool now lets modify in inspect that field to redirect us to the domain specified in the function\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310075144.png)\
ok cool so now just input anything into the invide code field and we should get the invite code\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310075617.png)\
and boom

now if we input the invite code into the required field we get a username and pass\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310075703.png)\
when we log in we get the following dashboard\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310055526.png)\
ok cool . when we inspect this in burpsuite we see an interesting field called isVIP . and we can change its value , cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310062337.png)\
accesing the second challenge with the VIP tag we see the following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310062811.png)\
for whatever reason when we try to acces the machine with the vip on by bursuie , it dosent worked , so i modify it from inspect to start the machine\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310063110.png)\
and we got the machine on , then we can use burpsuite again and modify the command field to get the config file , also set the isVIP true always\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310063805.png)![](/images/blog-ul-meu/static/Pasted%20image%2020260310063922.png)\
and boom we get the token\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310064005.png)\
but what can we do with this token?

When visiting the URL, I was redirected to http://admin1337special.hackme.thm:40009/public/html/ with a status code of 403 (Unauthorized). I attempted to add a cookie SECURE\_TOKEN=ACC#SS\_TO\_ADM1N\_\*\*\*\*\*, but it didn’t work. I started fuzzing directories within /public/html and got this results:

```
i also update /etc/host with admin1337special.hackme.thm like this 
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260310082040.png)\
and fuzz\
![](blog-ul-meu/static/Pasted%20image%2020260310071002.png)\
and fortunatly gobuster saved me and showed me the login page\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310070954.png)\
after we input the token it asks from us for a username and pass\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310071020.png)\
lets run sql map on this , to do that go into burpsuite , intercept the site , and press in the yellow area i highlighted , press save\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310072348.png)\
then run sqlmap like this , where savedSite is the file we saved\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310072501.png)\
and boom pass\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310072653.png)\
now we are admin\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310072803.png)\
if we change the action to sing up\
![](/images/blog-ul-meu/static/Pasted%20image%2020260310073210.png)\
then we reconect to the original site , that being :http://hackme.thm/ we get the final flag, boom

![](/images/blog-ul-meu/static/Pasted%20image%2020260310073343.png)

### Part 2 - Detection

#### Q1

log in at http://IP:8000 and u should see this interface\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311121016.png)\
click on Search and Reporting in the right menu\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311121231.png)\
if we insert \* and select all time see the exact number of logs

##### Q2

if we inspect the source ips and select the address with the most visits we can see tool we asked for\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311121722.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311121911.png)

#### Q3

if we press the tool we see the amount of events\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311122055.png)

#### Q4

The ip addres from all the sqlmap events

#### Q5

select the attacker ip and the number will be shown\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311122901.png)

### Q6

extend one of the sqlMaps events using the arrow from the left side of the event , in there you will see a long value inside being the table that the attacker used\
![](/images/blog-ul-meu/static/Pasted%20image%2020260311122639.png)
