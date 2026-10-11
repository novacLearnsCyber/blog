---
created: 2026-02-05
tags:
  - note
  - journal
  - cyberStuff
title: MrRobot
draft: false
date:
subiect:
dificultate: 3
amuca: true
link:
  - https://tryhackme.com/room/mrrobot
lastmod: 2026-10-09T13:02:41.529Z
---
![](/images/static/Pasted%20image%2020260205055009.png)\
The first nmap scan shows that all 1000 ports on the host are in an ignored status.\
After a Google search I found out that using `-sT` can bypass this easily:\
![](/images/static/Pasted%20image%2020260205055956.png)\
Basic ports open, let's try to visit the website:\
![](/images/static/Pasted%20image%2020260205060021.png)\
After a very cool animation, this is what we see.\
I tried `prepare` and a cool cinematic rolled up; nothing too interesting in there. Let's try `question`:\
![](/images/static/Pasted%20image%2020260205060331.png)\
Just some pictures appeared on the screen; I think this whole site is just some promotional content from the TV series.

If I enter `/join`, I get the following:\
![](/images/static/Pasted%20image%2020260205060956.png)\
After I enter an email address, I get nothing in the inbox:\
![](/images/static/Pasted%20image%2020260205061136.png)\
I checked the page source and found these HTML comments:

<!--
\   //~~\ |   |    /\  |~~\|~~  |\  | /~~\~~|~~    /\  |  /~~\ |\  ||~~
 \ /|    ||   |   /__\ |__/|--  | \ ||    | |     /__\ | |    || \ ||--
  |  \__/  \_/   /    \|  \|__  |  \| \__/  |    /    \|__\__/ |  \||__
-->

Just an ASCII message.

Let's check the `robots.txt` file:\
![](/images/static/Pasted%20image%2020260205062914.png)\
This is what we get; interesting files, let's check them:\
![](/images/static/Pasted%20image%2020260205062944.png)\
OK cool string, probably something encoded.\
Nah my bad, this is actually the first key, cool.

If we access the second mentioned file from `robots.txt` (`fsocity.dic`), we get this:\
![](/images/static/Pasted%20image%2020260205063706.png)\
A very long list of words, which looks like a wordlist. I downloaded it with `wget` and ran gobuster with it to find something interesting; I think it's going to take some time:\
![](/images/static/Pasted%20image%2020260205063804.png)\
This is the readme, by the way:\
![](/images/static/Pasted%20image%2020260205063834.png)\
`/Image` directs us to a blog. Cool, a new path here:

![](/images/static/Pasted%20image%2020260205064335.png)

I noticed that even though the list is long, it starts to repeat itself:\
![](/images/static/Pasted%20image%2020260205064434.png)\
I decided to run directory enumeration with a common wordlist:\
![](/images/static/Pasted%20image%2020260205065903.png)\
From this list, `wp-login` seems interesting; let's check it:\
![](/images/static/Pasted%20image%2020260205070046.png)\
And it is WordPress. Good, this means it could be vulnerable; we have to look for the version:\
![](/images/static/Pasted%20image%2020260205070324.png)\
I opened Burp Suite and intercepted a failed login via the proxy:\
![](/images/static/Pasted%20image%2020260205070513.png)\
Cool, "Invalid username". I tried the credentials `admin:admin`, and the error specifically revealed that the username doesn't exist:\
![](/images/static/Pasted%20image%2020260205071414.png)\
I ran this hydra command and got this:

* `-L` specifies the dictionary file we downloaded earlier to take usernames from.
* `-p test` specifies a password to test against all the usernames.
* The `$IP` and HTTP POST form parameters specify the endpoint and failure message.
* `-t 30`: the number of tasks in parallel to run.

And we get the username `elliot`. Let's test it:\
![](/images/static/Pasted%20image%2020260205071745.png)\
Cool, now we get an invalid password:\
![](/images/static/Pasted%20image%2020260205072752.png)\
I ran this command with hydra as well; it's similar to the previous one, just with a few things changed. After some time I got elliot's password: `ER28-0652`.

![](/images/static/Pasted%20image%2020260205072935.png)\
And we are in, cool!\
Next, I did the following:\
Firstly, navigate to the Appearance Theme Editor menu:\
![](/images/static/Pasted%20image%2020260205074357.png)\
Then I modified `archive.php` with this reverse shell from pentestmonkey on GitHub, very cool:\
https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php\
Just copy the raw format, modify your IP and port, and press Update File.\
Note that we also have to create a listener on our machine with the command:\
`rlwrap nc -lvnp 53`\
(`rlwrap` is for line-editing support, and 53 is the listening port).

Now we just have to access `http://10.66.189.112/wp-content/themes/twentyfifteen/archive.php`; after that the script triggers, and we get a reverse shell:\
![](/images/static/Pasted%20image%2020260205074733.png)\
Cool.\
![](/images/static/Pasted%20image%2020260205075029.png)\
I looked around the machine a little bit and found a password hash for the user `robot`. Let's check it on CrackStation:\
![](/images/static/Pasted%20image%2020260205075126.png)\
And we have the robot password; let's login as him:\
![](/images/static/Pasted%20image%2020260205075215.png)\
And it works:\
![](/images/static/Pasted%20image%2020260205075256.png)\
And we have another key, cool.\
Now I think we will have to root this machine completely.\
Let's see what sudo permissions we can get:\
![](/images/static/Pasted%20image%2020260205075422.png)\
Yeah, this is not a good sign.\
I also upgraded the shell with the command:

```
python -c 'import pty;pty.spawn("/bin/bash")'
```

Cool.\
I think we will have to search for SUID binaries in another way.\
SUID binaries are binaries that have the SUID bit set, which means they execute with the permissions of the file owner (like root).\
We search for them with this command:

```
find / -perm +6000 2>/dev/null | grep '/bin'
```

Breakdown of the command:

* It uses `find` to locate binaries with the SUID bit set.
* `2>/dev/null`: redirects error messages to `/dev/null`.
* `grep '/bin'`: filters for standard binary paths.\
  ![](/images/static/Pasted%20image%2020260205080140.png)

After running this command, we see that `/usr/local/bin/nmap` has the SUID bit set. Good, that means we can exploit it.

After searching on GTFOBins, we see that we can exploit nmap by:\
![](/images/static/Pasted%20image%2020260205081153.png)\
Cool, let's do just that:\
![](/images/static/Pasted%20image%2020260205081232.png)\
And bam, we are root and we can read the final flag in `/root/key-3-of-3.txt`. Cool.
