---
created: 2026-01-24
tags:
  - note
  - journal
  - cyberStuff
title: Net Sec Challenge
draft: false
date:
subiect:
  - network
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/netsecchallenge
lastmod: 2026-01-24T16:22:18.560Z
---
# Introduction

"Use this challenge to test your mastery of the skills you have acquired in the Network Security module. All the questions in this challenge can be solved using only `nmap`, `telnet`, and `hydra`."\
cool aparently we can solve it only using those tools , lets try this way

### Challenge Questions

Q1 : What is the highest port number being open less than 10,000?\
just run\
`nmap -p 0-10000 $IP   `\
-p mean betwen the port 0 and 10000

Q2 : There is an open port outside the common 1000 ports; it is above 10,000. What is it?\
i runnned\
`nmap -p 10000-20000 $ip`\
i estimated that the port woul be under 20000

Q3:How many TCP ports are open?\
just add the ports from the last 2 question

Q4:What is the flag hidden in the HTTP server header?\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124094724.png)\
for this one go into the dev tools in firefox into the network tab and into the response header

Q5 :What is the flag hidden in the SSH server header?\
let try to ssh connect first\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124095701.png)ok intereting message about , "store now , decrypt later attacks "

lets use `nmap -sV `\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124101156.png)\
and we get the flag ,\
the flag -sV , acording to the help page is for identifying the version and header of every serice

Q6 : We have an FTP server listening on a nonstandard port. What is the version of the FTP server?

![](/images/blog-ul-meu/static/Pasted%20image%2020260124103218.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124103258.png)\
i just scanned for verions o fthe ports for ports over 10000 and found the version of the ftp server

Q7: for this one we need to run a hydra scan over those username , and i chose rockyou.txt\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124111326.png)\
after some time of waithig i got the passwords being being nadrea for quinn and jordan for eddie

now lets login on the ftp server

![](/images/blog-ul-meu/static/Pasted%20image%2020260124111816.png)\
i loged in as quinn and get the flag

Last question :\
when we get to the site we get the following

![](/images/blog-ul-meu/static/Pasted%20image%2020260124110330.png)

so i thought lets run a silent screen , and is that simple\
![](/images/blog-ul-meu/static/Pasted%20image%2020260124111919.png)\
and that was all
