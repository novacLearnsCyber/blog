---
created: 2026-03-02
tags:
  - note
  - journal
  - cyberStuff
title: new hire old artifact
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-03-02T13:26:40.268Z
---
link : <https://tryhackme.com/room/newhireoldartifacts>\
![](https://share.note.sx/files/xi/xih320ga97wkl1qv6ogl.png)\
this time we have an splunk interface and we have to work to find the thread

![](https://share.note.sx/files/mm/mmxcsx07nwrqiu4ogj4c.png)

![](https://share.note.sx/files/cj/cjvjulv54sg5zc9t82pu.png)\
lets look a lil bit at the data summary\
good , single host\
i changed the data a lil bit in the filter section , cause in the desc it says december 2021\
![](https://share.note.sx/files/1q/1qaz6z7eg5g5eob73uil.png)

for the fist task i search with the following string\
![](https://share.note.sx/files/lj/ljpdmpood16m84xt88d0.png)\
and here we have the binary name\
![](https://share.note.sx/files/fk/fk4rvk9kr8vyg0kczmli.png)\
also the company\
![](https://share.note.sx/files/cs/cs2ss1qabpgdv4qqo2kp.png)\
the nest task speficy that is the same folder as the first binary , so lets search using that\
C:\Users\FINANC~1\AppData\Local\Temp\\\
![](https://share.note.sx/files/c7/c7pvuhkktqgrfiqtkyzd.png)\
here , note that i har to seearch with other location cause the location previosly added was a hoax

i found that ironicLarge.exe file in the tmp directory then i search after it\
![](https://share.note.sx/files/8s/8s6okr6tdf64wrurbuxc.png)\
i decided to use the last 10 items so i used tail 10 and found the original name being

index=main | search "C:\Users\Finance01\AppData\Local\Temp\*" Image="C:\Users\Finance01\AppData\Local\Temp\IonicLarge.exe"\
\| tail 10

PalitExplorer.exe

and we do found it\
![](https://share.note.sx/files/oq/oqjmb1hbnm6pwy7plm96.png)\
being 2.56.59.42\
be carefull to the format , the correct format is 2\[.]56\[.]59\[.]42

for the next task , i had to search for the two binaries killed ,

so i useed the following string

`index=main | search Taskkill`\
`| highlight Taskkill`\
`| table "ParentCommandLine"`

where taskkill is the powershell command for killing processes\
just search for some long binaries names

for the next task\
i seacrh with the following string for the last command execute in the series of simmilar commands\
![](https://share.note.sx/files/zj/zjcdd7qjnpgtfbwln8fl.png)

then this long text attracted my atetention :

`"C:\Windows\System32\cmd.exe" /C forfiles /p c:\windows\system32 /m waitfor.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147735503 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m where.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737010 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m calc.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737007 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m notepad.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737394 ThreatIDDefaultAction_Actions=6 Force=True" &`

so i decided to make it a lil bit more clear:

`"C:\Windows\System32\cmd.exe" /C forfiles /p c:\windows\system32 /m waitfor.exe /c "cmd /C`\
`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147735503 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m where.exe /c "cmd /C`

`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737010 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m calc.exe /c "cmd /C`

`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737007 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m notepad.exe /c "cmd /C`

and here it is :

**powershell WMIC /NAMESPACE:\root\Microsoft\Windows\Defender PATH MSFT\_MpPreference call Add ThreatIDDefaultAction\_Ids=2147737394 ThreatIDDefaultAction\_Actions=6 Force=True" &**

and based of those we can get the ids\
note :\
![](https://share.note.sx/files/oh/ohqr0eaww79xz79cky9y.png)

for the next task just search in the\
index=main | search "C:\Users\Finance01\AppData\*"

in the image section , the secod image name on and exe is the answer:\
C:\Users\Finance01\AppData\Roaming\EasyCalc\EasyCalc.exe

and for the dlls loaded , just look in the image loaded section in left part of EaseCalc.exe\
and are the following:

ffmpeg.dll\
nw\_elf.dll\
nw.dll
