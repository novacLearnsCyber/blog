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
lastmod: 2026-04-27T12:14:48.381Z
---
I am gonna start with the conclusion : always note your ips and domains inside /etc/hosts.

Desc:

> Hello there,\
> I am the CEO and one of the co-founders of futurevera.\
> . In Futurevera, we believe that the future is in space. We do a lot of space research and write blogs about it. We used to help students with space questions, but we are rebuilding our support.\
> Recently blackhat hackers approached us saying they could takeover and are asking us for a big ransom. Please help us to find what they can takeover.\
> Our website is located at https://futurevera.\
> (opens in new tab)\
> Hint: Don't forget to add the 10.128.148.201 in /etc/hosts for futurevera.\
> ; )

ok so let's add the ip to /etc/hosts, we know that there is also a support domain, form the description , so we gonna add both with this command:

```
echo "<YOUR-IP>    futurevera.thm   support.futurevera.thm" > /etc/hosts
```

accesing both domains there is nothing intereting:\
futurevera.thm:\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427074644.png)\
support.futurevera.thm\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427074704.png)\
i also tried to subdomain enumerate with gobuster and port enumeration with nmap and found nothing interesting.\
The key of solving the box is looking at the site certificates , when accessing the sites first time we get a warning regarding the security of the sies , saying it haves a self-signed certificate.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427080115.png)\
and so i decided to examine the certificate of each domain\
for  futurevera.thm there is nothing interesting\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427080237.png)\
but for the support subdomain we found something interesting.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427080500.png)\
cool , now lets modify /etc/hosts again and add this new subdomain (modify with sudo /etc/hosts again )\
your /etc/hosts should look like that

```
<your_ip> SECRET.futurevera.thm support.futurevera.thm futurevera.thm 
```

now accessing SECRET.futurevera.thm in your browser will give you the flag.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260427081446.png)
