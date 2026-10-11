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
lastmod: 2026-10-09T12:42:06.896Z
---
This will be my first binary exploitation room.\
Let's begin:

### Crackme1

![](/images/static/Pasted%20image%2020260131120000.png)\
Just add execution permissions and run the file.

### Crackme2

![](/images/static/Pasted%20image%2020260131120609.png)\
When we try to run the program it asks for a password, interesting.\
Let's run `strings` to see human-readable characters:\
![](/images/static/Pasted%20image%2020260131120507.png)\
OK cool, we got the password: "super\_secret\_password".\
Now let's just run it with the password:\
![](/images/static/Pasted%20image%2020260131120654.png)

### Crackme3

In the description it says to use some basic reverse engineering methods, so I opened Ghidra and looked into it:\
![](/images/static/Pasted%20image%2020260131122621.png)\
![](/images/static/Pasted%20image%2020260131123909.png)\
The two pictures from above show some very interesting strings encoded in none other than base64. Let's copy them and decode them.\
And decoding the second line, we get the flag:\
![](/images/static/Pasted%20image%2020260131124029.png)

### Crackme4

I loaded it into Ghidra again and found this interesting function performing some kind of XOR operation:\
![](/images/static/Pasted%20image%2020260131162814.png)

I switched to Cutter for a little bit of diversity:\
![](/images/static/Pasted%20image%2020260131165843.png)\
The above image may look intimidating, but it is simpler than you think:

* `ood <argument>`: used to reopen the debugged program with our arguments.
* `db <memory address>`: used for placing a breakpoint there; the memory address is that of the function `get_pwd`.
* `dc`: to continue execution.
* `px @ rdi`: to show in hex the memory of the first argument we passed, and from there we get the password.

### Crackme5

For this one I returned to Ghidra:

![](/images/static/Pasted%20image%2020260131173225.png)\
I noticed that all those local variables are condensed into `local_38`, then `local_58` (user input) is compared to `local_38` using `strcmp`. So I came up with the idea to decode all those local variables from hex to ASCII, and I got the password:

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

I found this function called `my_secure_test`:\
![](/images/static/Pasted%20image%2020260201064826.png)\
If we take every condition and examine the characters it compares against, we can determine the string:\
'1337\_pwd'

### Crackme7

![](/images/static/Pasted%20image%2020260201075821.png)\
For the next one, once again I examined it in Ghidra, looked into the `main` function, and found this `else if` statement. Then I right-clicked on that value and converted it to decimal, getting the decimal value:\
![](/images/static/Pasted%20image%2020260201080008.png)\
Plugged it into the program and got the flag.

### Crackme8

![](/images/static/Pasted%20image%2020260201081212.png)\
Same thing as level 7: just open it in Ghidra, locate the `if` statement, right-click and choose decimal, and you've got it. It's that simple:\
![](/images/static/Pasted%20image%2020260201081307.png)
