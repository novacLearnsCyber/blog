---
created: 2026-01-31
tags:
  - note
  - journal
  - cyberStuff
title: ReversingElf
draft: false
date:
subiect:
  - exploatation
dificultate: 1
amuca: false
link:
  - https://tryhackme.com/room/reverselfiles
lastmod: 2026-02-01T13:13:09.038Z
---
This will be my first indo binary exploatation\
lets begin

### Crackme1

![](/images/blog-ul-meu/static/Pasted%20image%2020260131120000.png)\
just add the exec permision and run the file

### Crackme2

![](/images/blog-ul-meu/static/Pasted%20image%2020260131120609.png)\
when we try to run the program they ask for a password , intesting\
lets run Strings to see the human readeble caracthers\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131120507.png)\
ok cool we got the password being "super\_secret\_password"\
now lets just run with the password\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131120654.png)

### Crackme3

in the description it says to use some basic reverse enginering method , so i opened ghridra and looked into it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131122621.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131123909.png)\
the two pictures frm above some very interesintg strings encoded in non other than base64 , lets copy them and decode them\
and decoding the second liine we get the flag\
\*\*![](/images/blog-ul-meu/static/Pasted%20image%2020260131124029.png)

### crackme4

i loaded into ghridra again and founded this interesting function that is performing some kind of xor operation\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131162814.png)

i cheanged to cutter for a lil bit of diversity\
![](/images/blog-ul-meu/static/Pasted%20image%2020260131165843.png)\
the aboce image may look intimidating but is more simple tahn u think\
\- firstly 'ood 'argument ' '\
used for to operate the program as we want and to change it\
\- the `'db <memory address>` 'used for puting a breakpoint there , the momory addes is of the function get\_pwd\
\- dc - to continue\
\- px @rdi to show in hex the addres of the furst argument we passed, then we get the password

### crackme5

for this one i returned to ghildra

![](/images/blog-ul-meu/static/Pasted%20image%2020260131173225.png)\
i noticed that all that local variable are all condesed into local\_38 , then local\_58(user input) is compared to local\_38 using strcmp ,so i come with the idea to decode all those local variable from hex to asci and i got the password

list of var:\
local\_38 = 0x4f\
local\_37 = 0x66\
local\_36 = 100\
local\_35 = 0x6c\
local\_34 = 0x44\
local\_33 = 0x53\
local\_32 = 0x41\
local\_31 = 0x7c\
local\_30 = 0x33\
local\_2f = 0x74\
local\_2e = 0x58\
local\_2d = 0x62\
local\_2c = 0x33\
local\_2b = 0x32\
local\_2a = 0x7e\
local\_29 = 0x58\
local\_28 = 0x33\
local\_27 = 0x74\
local\_26 = 0x58\
local\_25 = 0x40\
local\_24 = 0x73\
local\_23 = 0x58\
local\_22 = 0x60\
local\_21 = 0x34\
local\_20 = 0x74\
local\_1f = 0x58\
local\_1e = 0x74\
local\_1d = 0x7a

password:\
`OfdlDSA|3tXb32~X3tX@sX`4tXtz

### Crackme6

i founded this function called my secure test\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201064826.png)\
if we take every condition and examine the character it comapres to we can determine the character being :\
'1337\_pwd'

### Crackme7

![](/images/blog-ul-meu/static/Pasted%20image%2020260201075821.png)\
for the next one once again i exxamined it in ghidra , look intro the main function and found this else if statement , then i right click on that value and chose to decimal and god the decimal value\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201080008.png)\
plug it into the program and i got the flag

### crackme8

![](/images/blog-ul-meu/static/Pasted%20image%2020260201081212.png)\
samething as level 7 , just go in ghidra , if statement , right click and chose decimal and u got it is that simple\
![](/images/blog-ul-meu/static/Pasted%20image%2020260201081307.png)
