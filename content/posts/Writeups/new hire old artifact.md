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
lastmod: 2026-10-09T12:36:33.964Z
---
link : <https://tryhackme.com/room/newhireoldartifacts>\
![](https://share.note.sx/files/xi/xih320ga97wkl1qv6ogl.png)\
This time we have a Splunk interface, and we have to investigate to find the threat:

![](https://share.note.sx/files/mm/mmxcsx07nwrqiu4ogj4c.png)

![](https://share.note.sx/files/cj/cjvjulv54sg5zc9t82pu.png)\
Let's look a little bit at the data summary:\
Good, single host.\
I adjusted the date range in the filter section, because the description mentions December 2021:\
![](https://share.note.sx/files/1q/1qaz6z7eg5g5eob73uil.png)

For the first task, I searched with the following query:\
![](https://share.note.sx/files/lj/ljpdmpood16m84xt88d0.png)\
And here we have the binary name:\
![](https://share.note.sx/files/fk/fk4rvk9kr8vyg0kczmli.png)\
Also the company:\
![](https://share.note.sx/files/cs/cs2ss1qabpgdv4qqo2kp.png)\
The next task specifies that it is in the same folder as the first binary, so let's search using that path:\
C:\Users\FINANC~1\AppData\Local\Temp\\\
![](https://share.note.sx/files/c7/c7pvuhkktqgrfiqtkyzd.png)\
Note that I had to search in another location because the previous path was a decoy.

I found the IonicLarge.exe file in the Temp directory, then searched for it:\
![](https://share.note.sx/files/8s/8s6okr6tdf64wrurbuxc.png)\
I decided to view the last 10 events using tail 10, and found the original name:

index=main | search "C:\Users\Finance01\AppData\Local\Temp\*" Image="C:\Users\Finance01\AppData\Local\Temp\IonicLarge.exe"\
\| tail 10

PalitExplorer.exe

And we do find the IP:\
![](https://share.note.sx/files/oq/oqjmb1hbnm6pwy7plm96.png)\
being 2.56.59.42.\
Be careful with the defanged format; the correct format is 2\[.]56\[.]59\[.]42.

For the next task, I had to search for the two terminated binaries.

So I used the following query:

`index=main | search Taskkill`\
`| highlight Taskkill`\
`| table "ParentCommandLine"`

where taskkill is the command used for terminating processes.\
Just search for the long binary names.

For the next task:\
I searched for the last command executed in the series of similar commands:\
![](https://share.note.sx/files/zj/zjcdd7qjnpgtfbwln8fl.png)

Then this long command line caught my attention:

`"C:\Windows\System32\cmd.exe" /C forfiles /p c:\windows\system32 /m waitfor.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147735503 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m where.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737010 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m calc.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737007 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m notepad.exe /c "cmd /C powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737394 ThreatIDDefaultAction_Actions=6 Force=True" &`

So I broke it down to make it clearer:

`"C:\Windows\System32\cmd.exe" /C forfiles /p c:\windows\system32 /m waitfor.exe /c "cmd /C`\
`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147735503 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m where.exe /c "cmd /C`

`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737010 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m calc.exe /c "cmd /C`

`powershell WMIC /NAMESPACE:\\root\Microsoft\Windows\Defender PATH MSFT_MpPreference call Add ThreatIDDefaultAction_Ids=2147737007 ThreatIDDefaultAction_Actions=6 Force=True" & forfiles /p c:\windows\system32 /m notepad.exe /c "cmd /C`

And here it is:

**powershell WMIC /NAMESPACE:\root\Microsoft\Windows\Defender PATH MSFT\_MpPreference call Add ThreatIDDefaultAction\_Ids=2147737394 ThreatIDDefaultAction\_Actions=6 Force=True" &**

Based on these, we can extract the IDs.\
Note:\
![](https://share.note.sx/files/oh/ohqr0eaww79xz79cky9y.png)

For the next task, search:\
index=main | search "C:\Users\Finance01\AppData\*"

In the Image field, the second executable name is the answer:\
C:\Users\Finance01\AppData\Roaming\EasyCalc\EasyCalc.exe

And for the loaded DLLs, look in the ImageLoaded field on the left for EasyCalc.exe;\
they are the following:

ffmpeg.dll\
nw\_elf.dll\
nw.dll
