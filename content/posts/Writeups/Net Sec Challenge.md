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
lastmod: 2026-10-09T12:34:41.513Z
---
# Introduction

"Use this challenge to test your mastery of the skills you have acquired in the Network Security module. All the questions in this challenge can be solved using only `nmap`, `telnet`, and `hydra`."\
Cool, apparently we can solve it using only those tools; let's try this approach.

### Challenge Questions

Q1: What is the highest port number being open less than 10,000?\
Just run:\
`nmap -p 0-10000 $IP`\
-p specifies ports between 0 and 10000.

Q2: There is an open port outside the common 1000 ports; it is above 10,000. What is it?\
I ran:\
`nmap -p 10000-20000 $ip`\
I estimated that the port would be under 20000.

Q3: How many TCP ports are open?\
Just add the ports from the last two questions.

Q4: What is the flag hidden in the HTTP server header?\
![](/images/static/Pasted%20image%2020260124094724.png)\
For this one, open DevTools in Firefox, navigate to the Network tab, and inspect the response headers.

Q5: What is the flag hidden in the SSH server header?\
Let's try to connect via SSH first:\
![](/images/static/Pasted%20image%2020260124095701.png)\
OK, interesting message about "store now, decrypt later attacks".

Let's use `nmap -sV`:\
![](/images/static/Pasted%20image%2020260124101156.png)\
And we get the flag.\
The flag -sV, according to the help page, is used for identifying the service version and banner of every service.

Q6: We have an FTP server listening on a nonstandard port. What is the version of the FTP server?

![](/images/static/Pasted%20image%2020260124103218.png)\
![](/images/static/Pasted%20image%2020260124103258.png)\
I just scanned for service versions on ports over 10000 and found the version of the FTP server.

Q7: For this one, we need to run a hydra brute-force scan over those usernames; I used rockyou.txt:\
![](/images/static/Pasted%20image%2020260124111326.png)\
After some time, I got the passwords: "andrea" for quinn and "jordan" for eddie.

Now let's log in to the FTP server:

![](/images/static/Pasted%20image%2020260124111816.png)\
I logged in as quinn and got the flag.

Last question:\
When we access the site, we see the following:

![](/images/static/Pasted%20image%2020260124110330.png)

So I thought, let's run a stealth scan; it is that simple:\
![](/images/static/Pasted%20image%2020260124111919.png)\
And that was all!
