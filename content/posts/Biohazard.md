---
created: 2026-03-13
tags:
  - note
  - journal
  - cyberStuff
title: Biohazard
draft: false
categories:
  - tryhackme
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-15T08:16:04.147Z
---
For the first part just run nmap and accces the http server\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313092553.png)\
i gonna run a gobuster scan and play with the http server in parallel

inspecting the /mainsionmain page we get the following subdomain\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093051.png)\
in there we get the following string\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093132.png)\
lets plug it into cyber chef\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093210.png)\
cool we have a /teaRoom/\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093241.png)\
but lets see what happens if w epress YES\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093316.png)\
and we have a flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093352.png)\
carazy zombie in teaRoom\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093426.png)\
and we find a LockPick flag cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093509.png)\
lets Yes\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093532.png)\
damn that crazy like a gobuster scan\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093639.png)\
the barroom asks us for the lockpick room lets see what happens\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093723.png)\
nothing special , lets READ it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093746.png)\
also pplug it into cyber chef\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313093818.png)\
cool and we have a music sheet flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313094015.png)\
when we input the music note into the piano field we get here , lets press YES\
pressing yes gives us another flag

![](/images/blog-ul-meu/static/Pasted%20image%2020260313094215.png)\
visiting the diningRoom2F gives us this ,again cyber chef\
decrypting the string with rot13 gives us  a page for the blue gem\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313094530.png)\
and like that we get the blue gem

ngl this part of the ctf is so boring , i am not gonna continue to document it , just a simple series of small puzzles ,just use cyberchef and the map to solve it

in the ending you should get a FTP user and pass in this format after combining and decoding the 4th creates

```
FTP user: [REDACTED], FTP pass: [REDACTED]
```

FTP user: hunter, FTP pass: you\_cant\_hide\_forever

### The guard house

connect to the ftp server and download all the files\
![](/images/blog-ul-meu/static/Pasted%20image%2020260313101737.png)

after dowloading the files u will get three keys ,important.txt and helmet\_key.txt.gpg

use steghide for key 1 , exiftool for key 2 and binwalk for key 3 , its not that hard , i will let you find the command flags for this

all those three keys combined will give u a long base string that u will ass the password for the helmet file

to decrypt the helmet file use

```
gpg --no-symkey-cache --decrypt helmet_key.txt.gpg
```

and the folder specified in one if the questions is inside the inportant.txt

### the revisit

to get the ssh creds go to IP/studyRoom and enter the helmet flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020260315033544.png)\
an archive will be downloaded and u can extract it with

```
tar -xgf <FILE_NAME>
```

inside and there will be an eacgle\_medal.txt with a shh username

TBD  SSH user: umbrella\_guest SSH password: T\_virus\_rules

to get the ssh pass go to IP/hiddenCloset and insert the Helmet room , inside u will see two files\
wolf medal : ssh pass\
MO disk 1 : string decoded with Vigenere enc and key albert

the start team leader can be found also in the hidden closet , just read the text

### Underground laboratory

after login in with the ssh cred we can see a hidden folder and inside a chris.txt file\
![](/images/blog-ul-meu/static/Pasted%20image%2020260315040713.png)\
just like that the answer the first 2 questions

the login pass for the traitor we got from the previos task

using that pass we cand su into weasker\
![](/images/blog-ul-meu/static/Pasted%20image%2020260315041428.png)\
after that we can just sudo su and get into root  , cool ,then bam we get the ultimate form and the root flag ![](/images/blog-ul-meu/static/Pasted%20image%2020260315041555.png)\
decent room , quiet boring ,
