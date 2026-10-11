---
created: 2026-03-13
tags:
  - note
  - journal
  - cyberStuff
title: Biohazard
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-09T12:41:34.625Z
---
For the first part, just run nmap and access the HTTP server:\
![](/images/static/Pasted%20image%2020260313092553.png)\
I'm going to run a gobuster scan and interact with the HTTP server in parallel.

Inspecting the `/mainsionmain` page, we get the following path:\
![](/images/static/Pasted%20image%2020260313093051.png)\
In there we get the following string:\
![](/images/static/Pasted%20image%2020260313093132.png)\
Let's plug it into CyberChef:\
![](/images/static/Pasted%20image%2020260313093210.png)\
Cool, we have `/teaRoom/`:\
![](/images/static/Pasted%20image%2020260313093241.png)\
But let's see what happens if we press YES:\
![](/images/static/Pasted%20image%2020260313093316.png)\
And we have a flag:\
![](/images/static/Pasted%20image%2020260313093352.png)\
Crazy zombie in `teaRoom`:\
![](/images/static/Pasted%20image%2020260313093426.png)\
And we find a LockPick flag, cool:\
![](/images/static/Pasted%20image%2020260313093509.png)\
Let's press YES:\
![](/images/static/Pasted%20image%2020260313093532.png)\
Damn, that's crazy, like a gobuster scan:\
![](/images/static/Pasted%20image%2020260313093639.png)\
The `barroom` asks us for the lockpick flag, let's see what happens:\
![](/images/static/Pasted%20image%2020260313093723.png)\
Nothing special, let's READ it:\
![](/images/static/Pasted%20image%2020260313093746.png)\
Also plug it into CyberChef:\
![](/images/static/Pasted%20image%2020260313093818.png)\
Cool, and we have a music sheet flag:\
![](/images/static/Pasted%20image%2020260313094015.png)\
When we input the music note into the piano field we get here; let's press YES.\
Pressing YES gives us another flag:

![](/images/static/Pasted%20image%2020260313094215.png)\
Visiting the `diningRoom2F` gives us this; again CyberChef.\
Decrypting the string with ROT13 gives us a page for the blue gem:\
![](/images/static/Pasted%20image%2020260313094530.png)\
And like that we get the blue gem.

NGL, this part of the CTF is so boring; I am not going to continue documenting every single one. Just a simple series of small puzzles—just use CyberChef and the map to solve them.

At the end you should get FTP credentials in this format after combining and decoding the 4 crates:

```
FTP user: [REDACTED], FTP pass: [REDACTED]
```

FTP user: hunter, FTP pass: you\_cant\_hide\_forever

### The Guardhouse

Connect to the FTP server and download all the files:\
![](/images/static/Pasted%20image%2020260313101737.png)

After downloading the files you will get three keys, `important.txt`, and `helmet_key.txt.gpg`.

Use `steghide` for key 1, `exiftool` for key 2, and `binwalk` for key 3. It's not that hard; I will let you find the command flags for these.

All those three keys combined will give you a long base64 string that you will use as the password for the helmet file.

To decrypt the helmet file, use:

```
gpg --no-symkey-cache --decrypt helmet_key.txt.gpg
```

And the folder specified in one of the questions is inside `important.txt`.

### The Revisit

To get the SSH creds, go to `http://IP/studyRoom` and enter the helmet flag:\
![](/images/static/Pasted%20image%2020260315033544.png)\
An archive will be downloaded and you can extract it with:

```
tar -xgf <FILE_NAME>
```

Inside there will be an `eagle_medal.txt` with an SSH username:

TBD  SSH user: umbrella\_guest SSH password: T\_virus\_rules

To get the SSH password, go to `http://IP/hiddenCloset` and enter the Helmet flag. Inside you will see two files:

* Wolf medal: SSH password
* MO disk 1: string decoded with Vigenère cipher and key `albert`

The STARS team leader can also be found in the hidden closet; just read the text.

### Underground Laboratory

After logging in with the SSH creds, we can see a hidden folder and inside it a `chris.txt` file:\
![](/images/static/Pasted%20image%2020260315040713.png)\
Just like that, answer the first 2 questions.

The login password for the traitor we got from the previous task.

Using that password, we can `su` into `wesker`:\
![](/images/static/Pasted%20image%2020260315041428.png)\
After that, we can just `sudo su` and get root. Cool, then bam, we get the ultimate form and the root flag:\
![](/images/static/Pasted%20image%2020260315041555.png)\
Decent room, quite boring.
