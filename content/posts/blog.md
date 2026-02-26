---
created: 2026-02-26
tags:
  - note
  - journal
  - cyberStuff
title: blog
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
  - https://tryhackme.com/room/blog
lastmod: 2026-02-26T09:00:43.194Z
---
ok soo recon\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226022933.png)\
basic ports opened\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226022954.png)\
a lot of interesting subdomains , even robots.txt is available\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226023052.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226023129.png)\
0 , interesting\
also there is an smb server opened, i checked it but nothing interesting there

i had to restart the machine because some of the subodmain werent available , cool\
/wp-admin/

![](/images/blog-ul-meu/static/Pasted%20image%2020260226025028.png)\
login page at wp-admin , cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226025322.png)\
i runed wpscan and found some interesting usernames to try on the login page

```
-e vp , vt , u 
### used to enumerate vulnerable plugin , vulnerable themes , and user id range
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260226025511.png)\
i puted those 2 usernames in a txt file to bruteforce theyre passwords\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226025647.png)

![](/images/blog-ul-meu/static/Pasted%20image%2020260226031903.png)\
and after a long scan i found kwheel=cutepie1

when we log in , in the dasshboard in the right down corner we can see\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226034350.png)\
ok cool , its running wp , i search online for wordpress version 5.0 export , and i found something with image-crip , then i search on metasploid and found\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226035505.png)\
cool , now lets modify the options as following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226035536.png)\
and run and bam we get a shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226034530.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226035703.png)\
now lets enumerate some SUID

![](/images/blog-ul-meu/static/Pasted%20image%2020260226035342.png)\
we found an interesting cheker here\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226035327.png)\
lets see what inside with ltrace\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226035912.png)\
ook cool lil program , so if we just

```
export admin=1 
```

and run the program\
boom root\
![](/images/blog-ul-meu/static/Pasted%20image%2020260226040025.png)\
and solver , decent ctf , i had to restart teh machine a few time
