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
lastmod: 2026-10-09T13:01:45.875Z
---
### Setup

Just follow the Impacket installation guide.\
Note: For `pip3 install -r /opt/impacket/requirements.txt`, I used:

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
```

because otherwise it wouldn't work (externally managed environment). I found the solution on Stack Overflow: https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana

### Task 3 - Welcome to Attacktive Directory

I ran an nmap scan with several flags; quick description:

* `-A`: OS detection and version scanning
* `-p-`: scan ports 1 to 65535
* `-T5`: aggressive timing template (read more in the man page)\
  ![](/images/static/Pasted%20image%2020260119055946.png)
* `-Pn`: treat all hosts as online (skip ping)\
  Note: this scan will take a while.

![](/images/static/Pasted%20image%2020260119061929.png)\
OK, a lot of ports open, interesting.

Questions:

1. `enum4linux`: popular tool for enumeration.
2. For the second question, after running `enum4linux`:\
   ![](/images/static/Pasted%20image%2020260119065808.png)\
   we find that the NetBIOS domain is `THM-AD`.
3. `.local` is not a valid TLD.

### Enumerating Users Via Kerberos

Kerbrute is a tool for enumerating Active Directory users via Kerberos pre-authentication. It uses Go, so we will have to install that as well.

Note that for Kerbrute you need to install Go; here is a guide: https://medium.com/@priyamjpatel/installing-go-on-a-linux-machine-ddf0620d17d

To install Kerbrute, run:

```bash
go install github.com/ropnop/kerbrute@latest
```

After that you will need to download the two wordlists from the page using `wget`:\
![](/images/static/Pasted%20image%2020260119072443.png)

We're going to run Kerbrute in `userenum` mode with the command:

```bash
kerbrute userenum --dc $IP -d spookysec.local userlist.txt
```

(`spookysec.local` was found from the nmap scan):\
![](/images/static/Pasted%20image%2020260119074831.png)

Questions:

1. `userenum`
2. `svc-admin`
3. `backup`

### Task 5

After the enumeration of user accounts is finished, we can attempt to abuse a feature within Kerberos with an attack method called **AS-REP Roasting**. AS-REP Roasting occurs when a user account has the privilege "Does not require Pre-Authentication" set. This means that the account **does not** need to provide valid identification before requesting a Kerberos Ticket on the specified user account.

Important: You may have to run `python` instead of `python3` depending on your environment.

Then I ran the script as instructed on the page.

I made a list with the valid users found from the previous tasks and saved it in `users.txt`:\
![](/images/static/Pasted%20image%2020260119080317.png)

Searching the hash type for `svc-admin` on https://hashcat.net/wiki/doku.php?id=example\_hashes, we find that the hash mode is `Kerberos 5, etype 23, AS-REP` (mode 18200).

After that I entered the hash into Hashcat and cracked it with the password list given to us:

![](/images/static/Pasted%20image%2020260119081555.png)\
Breaking down the command: `-m 18200` represents the hash mode (Kerberos 5, etype 23, AS-REP), and `hash` is the file containing the dumped hash.

And the password is: `management2005`

`svc-admin` : `management2005`

So with the credentials in hand, we can use the primary tool suite for Active Directory exploitation: Impacket!

![](/images/static/Pasted%20image%2020260121144937.png)\
Interesting, there is a `backup` share; let's try to access it:

![](/images/static/Pasted%20image%2020260121145012.png)\
Cool, there are backup credentials!\
After troubleshooting a few connection errors, I downloaded the file:\
![](/images/static/Pasted%20image%2020260121144817.png)\
which is just a base64 encoded string that we can decode very easily with `base64 -d`:\
and we get: `backup@spookysec.local:backup2517860`

And just like that, we get the answers for the questions section:

**Question:** What utility can we use to map remote SMB shares?

**Answer:** `smbclient`

**Question:** Which option will list shares?

**Answer:** `-L`

**Question:** How many remote shares is the server listing?

**Answer:** `6`

**Question:** There is one particular share that we have access to that contains a text file. Which share is it?

**Answer:** `backup`

**Question:** What is the content of the file?

**Answer:** `YmFja3VwQHNwb29reXNlYy5sb2NhbDpiYWNrdXAyNTE3ODYw`

**Question:** Decoding the contents of the file, what is the full contents?

**Answer:** `backup@spookysec.local:backup2517860`

### Task 7

After that we can use `secretsdump.py` for hash dumping using the command:

```bash
secretsdump.py spookysec.local/backup:'backup2517860'@<IP> -just-dc -use-vss
```

And we get the following:\
![](/images/static/Pasted%20image%2020260121150154.png)\
Very cool, we can see the Administrator NTLM hash.\
And just like that, we answer the following questions:

* **What method allowed us to dump NTDS.DIT?**
  * DRSUAPI

* **What is the Administrators NTLM hash?**
  * `0e0363213e37b94221497260b0bcb4fc`

* **What method of attack could allow us to authenticate as the user without the password?**
  * Pass the Hash

* **Using a tool called Evil-WinRM what option will allow us to use a hash?**
  * `-H`

### Task 8

For the last task, just use Evil-WinRM (preinstalled on Kali):

```bash
evil-winrm -i 10.67.160.112 -u administrator -H 0e0363213e37b94221497260b0bcb4fc
```

with the newly found NTLM hash:

![](/images/static/Pasted%20image%2020260121152057.png)\
And we get a shell:\
![](/images/static/Pasted%20image%2020260121152137.png)

And we get a flag on the Desktop:\
![](/images/static/Pasted%20image%2020260121152225.png)

`TryHackMe{4ctiveD1rectoryM4st3r}`

![](/images/static/Pasted%20image%2020260121152352.png)\
And just like that, we get all three flags for every user:

`TryHackMe{B4ckM3UpSc0tty!}`

`TryHackMe{K3rb3r0s_Pr3_4uth}`
