---
created: 2026-04-27
tags:
  - note
  - journal
  - cyberStuff
title: takerover
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:31:05.405Z
---
I am going to start with the conclusion: always note your IPs and domains inside /etc/hosts.

Description:

> Hello there,\
> I am the CEO and one of the co-founders of futurevera.\
> . In Futurevera, we believe that the future is in space. We do a lot of space research and write blogs about it. We used to help students with space questions, but we are rebuilding our support.\
> Recently blackhat hackers approached us saying they could takeover and are asking us for a big ransom. Please help us to find what they can takeover.\
> Our website is located at https://futurevera.\
> (opens in new tab)\
> Hint: Don't forget to add the 10.128.148.201 in /etc/hosts for futurevera.\
> ; )

OK, so let's add the IP to /etc/hosts. We know that there is also a support domain from the description, so we are going to add both with this command:

```
echo "<YOUR-IP>    futurevera.thm   support.futurevera.thm" > /etc/hosts
```

Accessing both domains, there is nothing interesting:\
futurevera.thm:\
![](/images/static/Pasted%20image%2020260427074644.png)\
support.futurevera.thm:\
![](/images/static/Pasted%20image%2020260427074704.png)\
I also tried subdomain enumeration with gobuster and port scanning with nmap, and found nothing interesting.\
The key to solving the box is looking at the site certificates. When accessing the sites for the first time, we get a warning regarding the security of the sites, stating that it has a self-signed certificate:\
![](/images/static/Pasted%20image%2020260427080115.png)\
And so I decided to examine the certificate of each domain.\
For futurevera.thm there is nothing interesting:\
![](/images/static/Pasted%20image%2020260427080237.png)\
But for the support subdomain, we found something interesting:\
![](/images/static/Pasted%20image%2020260427080500.png)\
Cool, now let's edit /etc/hosts again and add this new subdomain (edit /etc/hosts with sudo):\
Your /etc/hosts should look like this:

```
<your_ip> SECRET.futurevera.thm support.futurevera.thm futurevera.thm 
```

Now accessing SECRET.futurevera.thm in your browser will give you the flag:\
![](/images/static/Pasted%20image%2020260427081446.png)
