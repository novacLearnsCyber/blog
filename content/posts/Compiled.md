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
lastmod: 2026-02-05T06:50:48.429Z
---
ok so lets download the boinary and test it\
![](/images/blog-ul-meu/static/Pasted%20image%2020260204090420.png)\
it asks for a password ,lets open it in ghidra\
![](/images/blog-ul-meu/static/Pasted%20image%2020260204090453.png)\
the main function in ghidra show a entangled string of if checks

the function `__isoc99_scanf` seems wierd lets read the man page

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

ok interesting , so according to the man page and the program , everthing before the DoYouEven string will be stored in the variable local\_28  and the variable local\_28 has to have the value `_init` for us to get the password  so lets try the password\
DoYouEven\_init

![](/images/blog-ul-meu/static/Pasted%20image%2020260204091300.png)\
and it works very cool and simple ctf
