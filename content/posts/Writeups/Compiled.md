---
created: 2026-02-04
tags:
  - note
  - journal
  - cyberStuff
title: Compiled
draft: false
date:
subiect:
  - arhitecture 
  - ghridra
dificultate: 1
amuca: true
link:
  - https://tryhackme.com/room/compiled
lastmod: 2026-10-09T12:29:49.455Z
---
OK, so let's download the binary and test it:\
![](/images/static/Pasted%20image%2020260204090420.png)\
It asks for a password; let's open it in Ghidra:\
![](/images/static/Pasted%20image%2020260204090453.png)\
The main function in Ghidra shows an entangled chain of if checks.

The function `__isoc99_scanf` seems weird; let's read the man page:

```
   `The format string consists of a sequence of directives which` 
   `describe how to process the sequence of input characters. If` 
   `processing of a directive fails, no further input is read, and` 
   `scanf() returns. A "failure" can be either of the following:` 
   `input failure, meaning that input characters were unavailable, or` 
   `matching failure, meaning that the input was inappropriate (see` 
   `below)`

   `A directive is one of the following:`

   `•      A sequence of white-space characters (space, tab, newline,`
          `etc.; see isspace(3)).  This directive matches any amount`
          `of white space, including none, in the input.`

   `•      An ordinary character (i.e., one other than white space or`
          `'%').  This character must exactly match the next`
          `character of input.`

   `•      A conversion specification, which commences with a '%'`
          `(percent) character.  A sequence of characters from the`
          `input is converted according to this specification, and`
          `the result is placed in the corresponding pointer`
          `argument.  If the next item of input does not match the`
          `conversion specification, the conversion fails—this is a`
          `matching failure.`
```

OK, interesting. So according to the man page and the program, everything before the DoYouEven string will be stored in variable local\_28, and local\_28 has to have the value `_init` for us to get the password. So let's try the password:\
DoYouEven\_init

![](/images/static/Pasted%20image%2020260204091300.png)\
And it works. Very cool and simple CTF!
