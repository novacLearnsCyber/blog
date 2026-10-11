---
created: 2026-03-09
tags:
  - note
  - journal
  - cyberStuff
title: TryHack3M Subscribe
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
  - https://tryhackme.com/room/subscribe
lastmod: 2026-10-09T12:39:30.052Z
---
### Part 1 - Exploitation

Scanning: some interesting ports open.\
![](/images/static/Pasted%20image%2020260310074500.png)

Accessing the HTTP service via Burp Suite and inspecting the site map, we see the following:\
![](/images/static/Pasted%20image%2020260309084231.png)\
Let's look a little bit at the js folder; that invite function seems interesting:\
![](/images/static/Pasted%20image%2020260309084344.png)\
OK, so I copied the function and pasted it into a code beautifier, getting this:\
![](/images/static/Pasted%20image%2020260309084551.png)\
The original function:\
![](/images/static/Pasted%20image%2020260309084610.png)\
So the function basically says that if our hostname is not `capture3milliobsubcribers.thm` we can't log in, so let's modify that in `/etc/hosts`:\
![](/images/static/Pasted%20image%2020260309085351.png)\
OK cool, now let's use Inspect Element to modify that field so it redirects us to the domain specified in the function:\
![](/images/static/Pasted%20image%2020260310075144.png)\
OK cool, so now just input anything into the invite code field and we should get the invite code:\
![](/images/static/Pasted%20image%2020260310075617.png)\
And boom.

Now if we input the invite code into the required field, we get a username and password:\
![](/images/static/Pasted%20image%2020260310075703.png)\
When we log in, we get the following dashboard:\
![](/images/static/Pasted%20image%2020260310055526.png)\
OK cool. When we inspect this in Burp Suite, we see an interesting field called `isVIP`, and we can change its value. Cool:\
![](/images/static/Pasted%20image%2020260310062337.png)\
Accessing the second challenge with the VIP tag, we see the following:\
![](/images/static/Pasted%20image%2020260310062811.png)\
For whatever reason, when trying to access the machine with VIP enabled via Burp Suite, it didn't work, so I modified it using Inspect Element to start the machine:\
![](/images/static/Pasted%20image%2020260310063110.png)\
And we got the machine running. Then we can use Burp Suite again and modify the command field to get the config file, also keeping `isVIP` set to true:\
![](/images/static/Pasted%20image%2020260310063805.png)![](/images/static/Pasted%20image%2020260310063922.png)\
And boom, we get the token:\
![](/images/static/Pasted%20image%2020260310064005.png)\
But what can we do with this token?

When visiting the URL, I was redirected to http://admin1337special.hackme.thm:40009/public/html/ with a status code of 403 (Unauthorized). I attempted to add a cookie SECURE\_TOKEN=ACC#SS\_TO\_ADM1N\_\*\*\*\*\*, but it didn’t work. I started fuzzing directories within /public/html and got these results:

I also updated `/etc/hosts` with `admin1337special.hackme.thm` like this:\
![](/images/static/Pasted%20image%2020260310082040.png)\
And fuzzed:\
![](blog-ul-meu/static/Pasted%20image%2020260310071002.png)\
And fortunately gobuster saved me and showed me the login page:\
![](/images/static/Pasted%20image%2020260310070954.png)\
After we input the token, it asks us for a username and password:\
![](/images/static/Pasted%20image%2020260310071020.png)\
Let's run sqlmap on this. To do that, go into Burp Suite, intercept the request, and right-click in the yellow highlighted area to save it:\
![](/images/static/Pasted%20image%2020260310072348.png)\
Then run sqlmap like this, where `savedSite` is the file we saved:\
![](/images/static/Pasted%20image%2020260310072501.png)\
And boom, password:\
![](/images/static/Pasted%20image%2020260310072653.png)\
Now we are admin:\
![](/images/static/Pasted%20image%2020260310072803.png)\
If we change the action to sign up:\
![](/images/static/Pasted%20image%2020260310073210.png)\
Then we reconnect to the original site, that being `http://hackme.thm/`, and we get the final flag, boom:

![](/images/static/Pasted%20image%2020260310073343.png)

### Part 2 - Detection

#### Q1

Log in at `http://IP:8000` and you should see this interface:\
![](/images/static/Pasted%20image%2020260311121016.png)\
Click on Search & Reporting in the right menu:\
![](/images/static/Pasted%20image%2020260311121231.png)\
If we insert `*` and select all time, we see the exact number of logs.

#### Q2

If we inspect the source IPs and select the address with the most visits, we can see the tool asked for:\
![](/images/static/Pasted%20image%2020260311121722.png)\
![](/images/static/Pasted%20image%2020260311121911.png)

#### Q3

If we click on the tool, we see the amount of events:\
![](/images/static/Pasted%20image%2020260311122055.png)

#### Q4

The IP address from all the sqlmap events.

#### Q5

Select the attacker IP and the count will be shown:\
![](/images/static/Pasted%20image%2020260311122901.png)

#### Q6

Expand one of the sqlmap events using the arrow on the left side of the event; inside you will see a long value indicating the table that the attacker queried:\
![](/images/static/Pasted%20image%2020260311122639.png)
