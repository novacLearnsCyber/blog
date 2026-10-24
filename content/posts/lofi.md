---
created: 2026-10-22
tags:
  - note
  - journal
  - cyberStuff
title: lofi
date: 2026-10-22T12:52:50.953Z
lastmod: 2026-10-22T13:08:14.265Z
---
desc:

```
Want to hear some lo-fi beats, to relax or study to? We've got you covered! 

  

**Access this challenge** by deploying both the vulnerable machine by pressing the green "Start Lab Machine" button located within this task, and the TryHackMe AttackBox by pressing the  "Start AttackBox" button located at the top-right of the page.

Navigate to the following URL using the AttackBox: [http://MACHINE_IP](http://machine_ip/) and find the flag in the **root of the filesystem.**

  

Check out similar content on TryHackMe:

- [LFI Path Traversal](https://tryhackme.com/r/room/filepathtraversal)
- [File Inclusion](https://tryhackme.com/room/fileinc)

**Note:** The web page does load some elements from external sources. However, they do not interfere with the completion of the room.
```

link:https://tryhackme.com/room/lofi

lofi music site , if we select a type and look at the url we see that the page run a php script with a argument for page ,if we try to access a file like /etc/passwd , we get this\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022160233.png)\
i think because its not a correct path relative to the position of the file where are in right now\
so lets try with ../../../etc/passwd, and it works, cool

playing around , testing diferent file we see that the flag is inside  ../../../flag.txt\
ez
