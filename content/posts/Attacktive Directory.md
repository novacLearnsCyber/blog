---
created: 2026-01-19
tags:
  - note
  - journal
  - cyberStuff
title: Attacktive Directory
draft: false
date:
subiect:
  - windows
  - activeDirectory
dificultate: 3
amuca: false
link:
  - https://tryhackme.com/room/attacktivedirectory
lastmod: 2026-01-21T20:25:42.686Z
---
### Setup

just follow the packets instalation guide\
note : for the `pip3 install -r /opt/impacketrequiments.txt` i used\
`
		python3 -m venv .venv
		source .venv/bin/activate
		python3 -m pip install -r requirements.txt
		`\
because otherwise would't work , i found out that on stackoverflow  , link: https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana

### task 3 welcome to attacktive directory

i runned an nmap scan with a lot of flag , quick description\
-A for os detection\
-p- to scan port 1 to 65535\
-T5 for aggresive template (read more in the man page)\
![](/images/blog-ul-meu/static/Pasted%20image%2020260119055946.png)\
-Pn for pingless way\
note thsi scan will take a while

![](/images/blog-ul-meu/static/Pasted%20image%2020260119061929.png)\
ok ok a lot of ports open interesting

Questions

1. enuv4linux -popular tool for enumeration
2. for the second question , after running enum4linux ![](/images/blog-ul-meu/static/Pasted%20image%2020260119065808.png)\
   we will find that the netbios domaain is THM-AD
3. .local is not a valid TLD

### Enumerating Users Via Kerberos

kerbrute is a tool for exploting kerberos authentification system , it usus GO so we will have to install that also

note that for Kerbrute u need to install go , here is a link for instalation : https://medium.com/@priyamjpatel/installing-go-on-a-linux-machine-ddf0620d17d

also to install kerburte u will run\
\`go install  github.com/ropnop/kerbrute@latest

after that u will need to grab the two wordlists from the page with wget\
![](/images/blog-ul-meu/static/Pasted%20image%2020260119072443.png)

we gonna be running kerbrute with the usernum mode so run the comand

```
kerbrute userenum --dc $IP -d spookysec.local userlist.txt
```

```
	spookysec.local is from the nmap scan , the 
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260119074831.png)

Questions :\
1.userenum\
2.svc-admin\
3.backup

### task 5

After the enumeration of user accounts is finished, we can attempt to abuse a feature within Kerberos with an attack method called **ASREPRoasting.** ASReproasting occurs when a user account has the privilege "Does not require Pre-Authentication" set. This means that the account **does not** need to provide valid identification before requesting a Kerberos Ticket on the specified user account.

important : u have to run python not python3

then i just runned the file just as is instructed on the page

i made a list with the users that worked from the previos tasks and put it in users.txt\
![](/images/blog-ul-meu/static/Pasted%20image%2020260119080317.png)

searching the hash for the svc\_admin on :https://hashcat.net/wiki/doku.php?id=example\_hashes\
we will find that the full hash is `Kerberos 5, etype 23, AS-REP`\
the mode will be at the start of the hash

after that i entered the full hash in hash cat and find it with the password list given to us

<<<<<<< HEAD\
![](/images/blog-ul-meu/static/Pasted%20image%2020260121040054.png)\
and the pass is managment2005
=============================

![](/images/blog-ul-meu/static/Pasted%20image%2020260119081555.png)\
breaking down the commmand , -m 18200 represents the type of the hash , this case being `**Kerberos 5, etype 23, TGS-REP**`  , "hash" - teh file we get from the network

and the pass is managment2005

> > > > > > > 6d5b67357ed606489aea7daa04d413cd94eca937

```
	svc-admin
	management2005
```

so with the credentials here we can finally use the crazy main tool; for active directory exploatation\
IMPACKETTT

![](/images/blog-ul-meu/static/Pasted%20image%2020260121144937.png)\
interesting there is a backup account , lets try to get to it

![](/images/blog-ul-meu/static/Pasted%20image%2020260121145012.png)\
cool and some backupcredential\
after a few error i finally got them\
![](/images/blog-ul-meu/static/Pasted%20image%2020260121144817.png)\
which is just some base65 string we cand decode very easely with\
`base64 -d`\
and we get : backup@spookysec.local:backup2517860

and just like that we get the ans for the questions sections

**Question:** What utility can we use to map remote SMB shares?

```
**Answer:** `smbclient`
    
```

**Question:** Which option will list shares?

```
**Answer:** `-L`
    
```

**Question:** How many remote shares is the server listing?

```
**Answer:** `6`
    
```

**Question:** There is one particular share that we have access to that contains a text file. Which share is it?

```
**Answer:** `backup`
    
```

**Question:** What is the content of the file?

```
**Answer:** `YmFja3VwQHNwb29reXNlYy5sb2NhbDpiYWNrdXAyNTE3ODYw`
    
```

**Question:** Decoding the contents of the file, what is the full contents?

```
**Answer:** `backup@spookysec.local:backup2517860`
    
```

Task7

after that we can use sercretdump.py for hashdumping using the command\
\`secretsdump.py spookysec.local/backup:'backup2517860'@<IP> -just-dc -use-vss

and we gonna get the following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260121150154.png)\
that very cool we can see an admin hash\
and just like that we answer to the following questions

* **What method allowed us to dump NTDS.DIT?**\
  \- DRSUAPI

* **What is the Administrators NTLM hash?**

  * `0e0363213e37b94221497260b0bcb4fc`

* **What method of attack could allow us to authenticate as the user without the password?**

  * `pass the hash`

* **Using a tool called Evil-WinRM what option will allow us to use a hash?**

  * `-H`

Task 8

for the last task just use a windows exploatation tool like evil-winrm comes preinstaled on kali\
and `evil-winrm -i 10.67.160.112 -u administrator -H 0e0363213e37b94221497260b0bcb4fc` with the new foundeed hash

![](/images/blog-ul-meu/static/Pasted%20image%2020260121152057.png)\
and we gonna get a shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260121152137.png)

and we get a flag on the desktop\
![](/images/blog-ul-meu/static/Pasted%20image%2020260121152225.png)

TryHackMe{4ctiveD1rectoryM4st3r}

![](/images/blog-ul-meu/static/Pasted%20image%2020260121152352.png)\
and just like that we get all try of the flag for every user

TryHackMe{B4ckM3UpSc0tty!}

TryHackMe{K3rb3r0s\_Pr3\_4uth}
